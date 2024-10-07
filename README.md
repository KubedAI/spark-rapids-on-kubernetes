# Spark RAPIDS on Kubernetes 🚀

## ⚠️🚧 WARNING: Work in Progress 🚧⚠️

    This project is under active development and is not in a stable or complete state yet. Features and functionality are subject to change, and the project may not function as expected.

    Please proceed with caution and feel free to contribute or provide feedback. Thank you for your support!


**Accelerating Data Processing Workloads with GPUs using Apache Spark and NVIDIA RAPIDS on Kubernetes**

## 🌟 Overview

This project showcases the power of NVIDIA RAPIDS and Apache Spark to accelerate data processing on GPUs, running seamlessly in a Kubernetes environment. By combining the power of GPU acceleration with the distributed computing framework of Spark, users can unlock significant performance gains while optimizing for cost efficiency.

As AI and machine learning workloads grow, the need for faster, more efficient processing has become paramount. Traditional CPU-based processing struggles to meet the demands of modern data workloads, but by leveraging the RAPIDS cuDF library with GPU-based computation, you can achieve faster execution and cost savings without changing existing Spark code.

This project provides templates, configurations, and deployment blueprints for running Spark RAPIDS on `Kubernetes`, along with `Terraform` scripts for infrastructure setup and autoscaling with Karpenter.

## ⚙️ Key Features

- **GPU-Accelerated Spark Processing**: Leverage the **RAPIDS cuDF library** to speed up Spark jobs on **NVIDIA GPUs**.
- **Unified AI Framework**: Create a single data pipeline, combining ETL and AI/ML workloads.
- **Scalability**: Harness the scaling power of **Kubernetes** and **Amazon EKS** for large-scale data workloads.
- **Plug-and-Play Configuration**: Run your existing Apache Spark jobs with no code changes by enabling the RAPIDS plugin.
- **Advanced Shuffle with UCX**: Benefit from accelerated GPU-to-GPU and RDMA communication for efficient shuffling.
- **Ready-to-Use Blueprints**: Includes templates for **NVIDIA Device Plugin**, **CloudWatch**, **Prometheus**, **Spark History Server**, **Apache YuniKorn**, and more.

## 💼 Performance and Cost Benefits

The **RAPIDS Accelerator for Apache Spark** offers both **performance improvements** and **cost savings**. By offloading computation to GPUs, users can process data faster while reducing infrastructure costs.

## 📂 Project Structure

```
.
├── README.md
├── examples
├── infra
├── scripts
├── website
├── ADOPTERS.md
├── CONTRIBUTING.md
├── LICENSE
```

## 📚 Learn More

The RAPIDS Accelerator for Apache Spark offers a simple yet powerful way to boost performance and reduce costs. You can run your existing Spark jobs with no changes to your codebase by simply enabling the RAPIDS plugin.

To learn more and dive into detailed examples, check out NVIDIA's [documentation](https://docs.nvidia.com/spark-rapids/user-guide/latest/index.html) and explore the [spark-rapids-examples](https://github.com/NVIDIA/spark-rapids-examples).
