import logging
import sys
import time
from datetime import datetime
from pyspark.sql import SparkSession
from pyspark.sql.types import StructType, StructField, StringType, IntegerType, DoubleType, DateType
from pyspark.sql.functions import from_utc_timestamp, col, broadcast

# Logging configuration
formatter = logging.Formatter('[%(asctime)s] %(levelname)s @ line %(lineno)d: %(message)s')
handler = logging.StreamHandler(sys.stdout)
handler.setLevel(logging.INFO)
handler.setFormatter(formatter)
logger = logging.getLogger()
logger.setLevel(logging.INFO)
logger.addHandler(handler)

dt_string = datetime.now().strftime("%Y_%m_%d_%H_%M_%S")
AppName = "BenchmarkApp"

# Define explicit schemas for CSV files
sales_schema = StructType([
    StructField("sales_id", StringType(), True),
    StructField("product_name", StringType(), True),
    StructField("price", DoubleType(), True),
    StructField("quantity_sold", IntegerType(), True),
    StructField("date_of_sale", DateType(), True),  # assuming date format; can change to timestamp if needed
    StructField("customer_id", StringType(), True)
])

customers_schema = StructType([
    StructField("customer_id", StringType(), True),
    StructField("customer_name", StringType(), True),
    StructField("age", IntegerType(), True),
    StructField("gender", StringType(), True),
    StructField("state", StringType(), True),
    StructField("email", StringType(), True)
])

products_schema = StructType([
    StructField("product_name", StringType(), True),
    StructField("category", StringType(), True),
    StructField("price", DoubleType(), True),
    StructField("stock_quantity", IntegerType(), True)
])

def main(args):
    if len(args) != 3:
        print("Usage: benchmark [input-s3-folder] [output-s3-folder]")
        sys.exit(1)

    data_folder = args[1]
    output_s3_folder = args[2]

    # Create Spark Session with UTC timezone setting
    spark = SparkSession \
        .builder \
        .appName(f"{AppName}_{dt_string}") \
        .config("spark.sql.session.timeZone", "UTC") \
        .config("spark.sql.adaptive.enabled", "true") \
        .getOrCreate()

    spark.sparkContext.setLogLevel("INFO")
    logger.info("Starting Spark application for benchmarking")

    # Read data using schemas
    sales_df = read_data(spark, f"{data_folder}/sales", sales_schema)
    customer_df = read_data(spark, f"{data_folder}/customers", customers_schema)
    product_df = read_data(spark, f"{data_folder}/products", products_schema)

    # Ensure the 'date_of_sale' is handled as a UTC timestamp
    sales_df = sales_df.withColumn("date_of_sale_utc", from_utc_timestamp(col("date_of_sale"), "UTC"))

    # Convert CSV data to Parquet for faster future reads
    convert_to_parquet(sales_df, f"{output_s3_folder}/sales_parquet")
    convert_to_parquet(customer_df, f"{output_s3_folder}/customers_parquet")
    convert_to_parquet(product_df, f"{output_s3_folder}/products_parquet")

    # Register DataFrames as Temp Views for SQL queries
    sales_df.createOrReplaceTempView("sales")
    customer_df.createOrReplaceTempView("customers")
    product_df.createOrReplaceTempView("products")

    # List of benchmark queries, including complex operations
    queries = [
        {
            "name": "Join Sales and Customers",
            "sql": """
                SELECT s.sales_id, s.product_name, s.price, s.quantity_sold, s.date_of_sale_utc,
                       c.customer_name, c.age, c.gender, c.state
                FROM sales s
                JOIN customers c ON s.customer_id = c.customer_id
                WHERE c.state = 'CA' AND s.price > 100
            """,
            "input_tables": ["sales", "customers"]
        },
        {
            "name": "Aggregate Sales by State",
            "sql": """
                SELECT c.state, SUM(s.price * s.quantity_sold) as total_sales
                FROM sales s
                JOIN customers c ON s.customer_id = c.customer_id
                GROUP BY c.state
                ORDER BY total_sales DESC
            """,
            "input_tables": ["sales", "customers"]
        },
        {
            "name": "Top Selling Products",
            "sql": """
                SELECT s.product_name, SUM(s.quantity_sold) as total_quantity
                FROM sales s
                GROUP BY s.product_name
                ORDER BY total_quantity DESC
                LIMIT 10
            """,
            "input_tables": ["sales"]
        },
        {
            "name": "Sort Sales by Price",
            "sql": """
                SELECT s.sales_id, s.product_name, s.price, s.quantity_sold, s.date_of_sale_utc
                FROM sales s
                ORDER BY s.price DESC
            """,
            "input_tables": ["sales"]
        },
        {
            "name": "Filter Customers by Age",
            "sql": """
                SELECT c.customer_id, c.customer_name, c.age, c.gender, c.state
                FROM customers c
                WHERE c.age > 30 AND c.age < 50
            """,
            "input_tables": ["customers"]
        },
        {
            "name": "Filter and Sort Products by Stock Quantity",
            "sql": """
                SELECT p.product_name, p.category, p.stock_quantity
                FROM products p
                WHERE p.stock_quantity > 500
                ORDER BY p.stock_quantity DESC
            """,
            "input_tables": ["products"]
        },
        {
            "name": "Top Customers by Total Purchase Over Time with Product Category",
            "sql": """
                WITH customer_sales AS (
                    SELECT s.customer_id, SUM(s.price * s.quantity_sold) AS total_purchase, p.category
                    FROM sales s
                    JOIN products p ON s.product_name = p.product_name
                    GROUP BY s.customer_id, p.category
                )
                SELECT cs.customer_id, c.customer_name, c.state, cs.category, cs.total_purchase,
                    RANK() OVER (PARTITION BY c.state ORDER BY cs.total_purchase DESC) as rank_by_state
                FROM customer_sales cs
                JOIN customers c ON cs.customer_id = c.customer_id
                WHERE cs.total_purchase > 500
                ORDER BY c.state, cs.total_purchase DESC
                LIMIT 100
            """,
            "input_tables": ["sales", "customers", "products"]
        }
    ]

    # Execute benchmark queries and collect results
    query_times = []
    for query in queries:
        logger.info(f"Running query: {query['name']}")

        # Run the query and capture execution time
        start_time = time.time()
        result_df = spark.sql(query['sql'])
        # Trigger an action to force Spark to execute the query
        result_count = result_df.count()  # Action to trigger actual query execution
        logger.info(f"Query '{query['name']}' returned {result_count} records")
        end_time = time.time()
        # Show the first 5 rows of the result for debugging
        result_df.show(5)

        execution_time_ms = (end_time - start_time) * 1000  # Convert to milliseconds
        execution_time_sec = (end_time - start_time)  # Convert to seconds

        logger.info(f"Query '{query['name']}' executed in {execution_time_ms:.2f} ms ({execution_time_sec:.2f} seconds)")

        # Store the time taken, input data size, and output data size for each query
        query_times.append((query['name'], execution_time_ms, execution_time_sec))

    # Convert the query times into a DataFrame for easier writing to S3
    query_times_df = spark.createDataFrame(
        query_times,
        ["Query Name", "Execution Time (ms)", "Execution Time (seconds)"]
    )

    # Write the benchmark results to S3
    write_results_to_s3(query_times_df, output_s3_folder)

    logger.info("Benchmarking completed and summary saved to S3")
    spark.stop()

def read_data(spark, path, schema):
    logger.info(f"Reading data from {path} with schema")
    df = spark.read.csv(path, header=True, schema=schema)
    return df

def convert_to_parquet(df, output_path):
    logger.info(f"Converting data to Parquet at {output_path}")
    df.write.mode("overwrite").parquet(output_path)
    logger.info(f"Data written to Parquet at {output_path}")

def write_results_to_s3(df, output_s3_folder):
    logger.info(f"Writing results to {output_s3_folder}")
    df.coalesce(1).write.mode("overwrite").csv(f"{output_s3_folder}/benchmark_summary_{dt_string}", header=True)
    logger.info(f"Results successfully written to {output_s3_folder}")

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: benchmark [input-s3-folder] [output-s3-folder]")
        sys.exit(1)

    main(sys.argv)
