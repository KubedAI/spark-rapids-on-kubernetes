# Data Generation and Benchmarking Scripts

## Overview
This repository provides two primary scripts for generating data and benchmarking Spark jobs. The first script generates sample datasets for testing purposes, while the second script benchmarks complex Spark SQL queries, including joins, aggregations, sorting, filtering, and more. These scripts are designed to test and compare performance across different instance types (e.g., CPUs vs GPUs) using Spark on distributed computing platforms such as Amazon EKS or EMR.

### 1. Data Generation Script
Purpose:
The Data Generation Script (data_generation.py) creates large-scale datasets simulating real-world business scenarios, including sales data, customer information, and product details. This generated data can be used as input for running Spark benchmarks, which will help evaluate and compare the performance of different Spark setups or instance types.

Usage:

output-folder: The destination where the generated data will be stored (e.g., an S3 bucket or local folder).
num_rows_large: Number of rows to generate for the large dataset (e.g., sales data).
num_rows_small: Number of rows to generate for the smaller dataset (e.g., customer data).
num_rows_product: Number of rows to generate for product data.

This will generate 1,000,000 sales records, 100,000 customer records, and 10,000 product records, which will be stored in the specified S3 bucket.

### 2. Benchmark Script
Purpose:
The Benchmark Script (benchmark.py) runs a series of complex SQL queries on the generated dataset, capturing performance metrics like query execution time (in milliseconds). It also computes summary statistics, including the average execution time, median, 90th percentile, maximum, and minimum times. The results are saved in an output folder (e.g., an S3 bucket) for later review and comparison.

Usage:

data-folder: The location of the input data (e.g., sales, customer, and product data generated earlier).
output-s3-folder: The destination where the benchmark results will be saved (e.g., an S3 bucket).

This will run the benchmark queries on the input data stored in the specified S3 bucket and save the results to the output folder.

#### Benchmark Queries

The benchmark script runs a variety of Spark SQL queries, such as:

Join Sales and Customers: Joins sales and customer data on customer_id and applies filters.
Aggregate Sales by State: Aggregates total sales grouped by state.
Top Selling Products: Aggregates and ranks products by total quantity sold.
Sort Sales by Price: Sorts sales records based on price.
Filter Customers by Age: Filters customers based on age range.
Filter and Sort Products by Stock Quantity: Filters and sorts products based on stock quantities.

#### Sample Benchmark Output
Once the benchmark script completes, the results will be written to the specified output folder. The output includes execution times for each query and a summary of performance metrics.

##### Sample Output (CSV Format):

| Query Name                 | Execution Time (ms) |
|----------------------------|---------------------|
| Join Sales and Customers    | 5120.45             |
| Aggregate Sales by State    | 2473.33             |
| Top Selling Products        | 1830.55             |
| Sort Sales by Price         | 3765.78             |
| Filter Customers by Age     | 1587.29             |
| Filter and Sort Products    | 2931.41             |

##### Summary Statistics:

| Metric               | Value    |
|----------------------|----------|
| Number of Queries     | 6        |
| Average Time (ms)     | 2951.13  |
| Median Time (ms)      | 2931.41  |
| 90th Percentile (ms)  | 3765.78  |
| Max Time (ms)         | 5120.45  |
| Min Time (ms)         | 1587.29  |


This table provides a concise overview of the performance across various queries, helping users compare different instance types and configurations. The benchmark results can be used to identify bottlenecks, analyze system performance, and make informed decisions regarding infrastructure.

