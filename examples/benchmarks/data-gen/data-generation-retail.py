import logging
import sys
from datetime import datetime
import random
from pyspark.sql import SparkSession
from pyspark.sql import functions as f
from pyspark.sql.types import IntegerType

# Logging configuration
formatter = logging.Formatter('[%(asctime)s] %(levelname)s @ line %(lineno)d: %(message)s')
handler = logging.StreamHandler(sys.stdout)
handler.setLevel(logging.INFO)
handler.setFormatter(formatter)
logger = logging.getLogger()
logger.setLevel(logging.INFO)
logger.addHandler(handler)

dt_string = datetime.now().strftime("%Y_%m_%d_%H_%M_%S")
AppName = "DataGenerationApp"

def main(args):
    # Output folder and row counts passed as arguments
    if len(args) != 5:  # Corrected to check for 5 arguments including script name
        print("Usage: data-generation [output-folder] [num_rows_large] [num_rows_small] [num_rows_product]")
        sys.exit(1)

    output_folder = args[1]
    num_rows_large = int(args[2])  # Large dataset row count (e.g., sales)
    num_rows_small = int(args[3])  # Small dataset row count (e.g., customers)
    num_rows_product = int(args[4])  # Product dataset row count

    # Create Spark Session
    spark = SparkSession \
        .builder \
        .appName(f"{AppName}_{dt_string}") \
        .getOrCreate()

    spark.sparkContext.setLogLevel("INFO")
    logger.info("Starting spark application for data generation")

    # Generate random data for sales
    logger.info(f"Generating {num_rows_large} rows for sales data")
    sales_df = generate_sales_data(spark, num_rows_large)

    # Generate random data for customers
    logger.info(f"Generating {num_rows_small} rows for customer data")
    customer_df = generate_customer_data(spark, num_rows_small)

    # Generate random data for products
    logger.info(f"Generating {num_rows_product} rows for product data")
    product_df = generate_product_data(spark, num_rows_product)

    # Write data to output folder
    write_data(sales_df, f"{output_folder}/sales")
    write_data(customer_df, f"{output_folder}/customers")
    write_data(product_df, f"{output_folder}/products")

    logger.info("Ending spark application")
    spark.stop()

def generate_sales_data(spark, num_rows):
    logger.info("Generating sales data...")
    df = spark.range(0, num_rows)
    df = df.withColumn("sales_id", f.concat(f.lit("s_"), f.col("id")))
    df = df.withColumn("product_name", f.concat(f.lit("Product_"), (f.col("id") % 1000)))
    df = df.withColumn("price", (f.rand() * 490 + 10).cast("double"))  # Random float between 10 and 500
    df = df.withColumn("quantity_sold", (f.rand() * 99 + 1).cast("int"))  # Random int between 1 and 100
    df = df.withColumn("random_days", (f.rand() * 730).cast("int"))
    df = df.withColumn("date_of_sale", f.expr("date_sub(current_date(), random_days)"))
    df = df.withColumn("customer_id", f.concat(f.lit("c_"), (f.col("id") % 1000000)))
    df = df.drop("id", "random_days")
    return df

def generate_customer_data(spark, num_rows):
    logger.info("Generating customer data...")
    df = spark.range(0, num_rows)
    df = df.withColumn("customer_id", f.concat(f.lit("c_"), f.col("id")))
    df = df.withColumn("customer_name", f.concat(f.lit("Customer_"), f.col("id")))
    df = df.withColumn("age", (f.rand() * 52 + 18).cast("int"))  # Random age between 18 and 70
    df = df.withColumn("gender", f.when(f.rand() < 0.5, "male").otherwise("female"))
    df = df.withColumn("rand_state", f.rand())
    df = df.withColumn("state", f.when(f.col("rand_state") < 0.25, "NY")
                         .when(f.col("rand_state") < 0.5, "CA")
                         .when(f.col("rand_state") < 0.75, "TX")
                         .otherwise("FL"))
    df = df.withColumn("email", f.concat(f.lit("email_"), f.col("id"), f.lit("@mail.com")))
    df = df.drop("id", "rand_state")
    return df

def generate_product_data(spark, num_rows):
    logger.info("Generating product data...")
    df = spark.range(0, num_rows)
    df = df.withColumn("product_name", f.concat(f.lit("Product_"), f.col("id")))
    df = df.withColumn("category", f.concat(f.lit("Category_"), (f.col("id") % 100)))
    df = df.withColumn("price", (f.rand() * 95 + 5).cast("double"))  # Random float between 5 and 100
    df = df.withColumn("stock_quantity", (f.rand() * 990 + 10).cast("int"))  # Random int between 10 and 1000
    df = df.drop("id")
    return df

def write_data(df, path):
    logger.info(f"Writing data to {path}")
    df.write.mode("overwrite").csv(path, header=True)
    logger.info(f"Data written to {path} successfully")

if __name__ == "__main__":
    if len(sys.argv) != 5:  # Corrected argument check
        print("Usage: data-generation [output-folder] [num_rows_large] [num_rows_small] [num_rows_product]")
        sys.exit(1)

    main(sys.argv)
