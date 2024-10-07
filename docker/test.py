import logging
from pyspark.sql import SparkSession
from pyspark import SparkConf
import torch

# Setup logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# Function to check and print GPU availability
def check_gpu():
    if torch.cuda.is_available():
        logger.info(f"GPU detected: {torch.cuda.get_device_name(0)}")
    else:
        logger.warning("No GPU detected. Running on CPU.")

# Function to run GPU-based logic (if needed)
def process_on_gpu(value):
    if torch.cuda.is_available():
        # Example placeholder GPU logic (could be expanded for real tasks)
        logger.info(f"Processing value {value} on GPU: {torch.cuda.get_device_name(0)}")
    else:
        logger.info(f"Processing value {value} on CPU")

# Configure Spark
logger.info("Configuring Spark session...")
conf = SparkConf().setAppName("Spark-RAPIDS-Demo").set("spark.plugins", "com.nvidia.spark.SQLPlugin")

# Initialize Spark Session
spark = SparkSession.builder.config(conf=conf).getOrCreate()
logger.info("Spark session initialized successfully.")

# Check for GPU availability in the driver node (initial environment)
logger.info("Checking GPU availability on driver...")
check_gpu()

# Create a large DataFrame to ensure tasks are distributed across executors
logger.info("Creating a large DataFrame...")
df = spark.range(0, 10000000).toDF("value")  # Increase the range for more data
df.createOrReplaceTempView("df")

# Run SQL queries and show the execution plan
logger.info("Running SQL queries and explaining the execution plan...")
spark.sql("SELECT * FROM df WHERE value % 2 = 0").explain()
logger.info("SQL query execution plan explained.")

logger.info("Executing SQL query and showing results...")
spark.sql("SELECT * FROM df WHERE value % 2 = 0").show()

# Process the data on executors (where GPUs may be available)
logger.info("Processing data on executors (GPU tasks if available)...")
df.foreach(lambda row: process_on_gpu(row['value']))

# Stop the Spark session
logger.info("Stopping the Spark session.")
spark.stop()
logger.info("Spark session stopped successfully.")
