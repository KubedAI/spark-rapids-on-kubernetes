# ✨ Spark RAPIDS on Kubernetes 🚀⚡

## ⚠️🚧 WARNING: Work in Progress 🚧⚠️

>This project is still under active development and may not be fully stable. Features, functionality, and configurations are subject to change. Please proceed with caution, and feel free to contribute or provide feedback. 🙏 Thank you for your support!


## 🌟 Overview

Welcome to **Spark RAPIDS on Kubernetes**, where we accelerate data processing workloads using the power of NVIDIA GPUs and Apache Spark, all running in a Kubernetes environment. 🚀

By leveraging the **RAPIDS cuDF** library, this project showcases how you can drastically speed up Spark jobs with GPU acceleration—while saving on costs—all without changing your existing Spark code. This is ideal for scaling AI, machine learning, and data processing workloads.

## 📦 Repo Features

- 📦 **Ready-to-Use Blueprints:** Includes **IaC templates** for setting up an **EKS Cluster**, **NVIDIA Device Plugin**, **CloudWatch**, **Prometheus**, **Spark History Server**, and more.
- 📝 **Spark RAPIDS Sample Scripts:** Pre-configured **Spark RAPIDS** scripts to demonstrate the power of GPU acceleration, ready to run on Kubernetes.
- 📊 **Benchmark Scripts:** Ready-to-use **benchmark scripts** to measure performance differences between **CPU** and **GPU**-accelerated Spark jobs, helping you evaluate the benefits of GPU processing.
- 🐳 **Dockerfiles:** Well-documented **Dockerfiles** to help you build and push **multi-arch images** for Spark RAPIDS on Kubernetes, tailored for your deployment needs.
- 📑 **Website Documentation:** A fully-featured **Docusaurus website** providing detailed guides, installation steps, and examples to help you get started with Spark RAPIDS on Kubernetes.
- 📈 **Scalability with Kubernetes:** Use **Kubernetes** and **Amazon EKS** to automatically scale your workloads, ensuring efficient resource usage for large-scale data sets and computations.


## 💼 Why Spark RAPIDS?

 - 🚀 **Performance Boost:** Process data up to 10x faster by offloading tasks to GPUs, especially for large-scale jobs.
 - 💸 **Cost Savings:** By reducing job execution times, you save on infrastructure costs, using fewer compute resources to achieve faster results.
 - 🔧 **Ease of Use:** No need to change your Spark code—just enable the RAPIDS plugin, and you're ready to go!

## ⚙️ Spark RAPIDS Features

- 💪 **GPU-Accelerated Spark:** Tap into the power of **NVIDIA GPUs** with the **RAPIDS cuDF** library to supercharge your Spark jobs for faster performance.
- 🔗 **Unified Data & AI Pipelines:** Seamlessly combine **ETL** processes with **AI/ML** workflows in a single pipeline, leveraging the power of GPU-based acceleration.
- 🔄 **Advanced Shuffle:** Boost performance with **GPU-to-GPU** communication using **UCX** for faster and more efficient data shuffling operations.
- 💸 **Cost Efficiency:** By processing workloads faster on GPUs, you save on infrastructure costs while speeding up large-scale jobs.
- 🧩 **Plug-and-Play:** Enable **GPU acceleration** with minimal configuration. Run your existing Spark jobs without modifying your code—just enable the RAPIDS plugin.

## 📂 Project Structure

Here’s what you'll find in the project:

```
.
├── README.md          # Project overview and instructions
├── benchmarks         # Bechmarks scripts
├── docker             # Sample Dockerfiles
├── examples           # Spark RAPIDS job examples
├── infra              # Terraform scripts for cluster setup
├── scripts            # Utility scripts for deployment
├── website            # Docusaurus documentation website
├── ADOPTERS.md        # List of project adopters
├── CONTRIBUTING.md    # Guidelines for contributing to the project
├── LICENSE            # License information

```

## 📚 Learn More
For detailed guides, examples, and best practices on using Spark RAPIDS, check out:

To learn more and dive into detailed examples, check out NVIDIA's [documentation](https://docs.nvidia.com/spark-rapids/user-guide/latest/index.html) and explore the [spark-rapids-examples](https://github.com/NVIDIA/spark-rapids-examples).


## 🚀 Getting Started
Ready to dive in? Follow the [installation guide](https://kubedai.github.io/spark-rapids-on-kubernetes/) to set up your Kubernetes environment with Spark RAPIDS, Karpenter, and the Spark Operator.

Let’s accelerate your data processing workflows and save on costs with GPU-accelerated Spark jobs! 💡💻

## 🤝 Support
This project is free to use, and we'd love to see contributions from the community! If you have any questions, feel free to raise an issue on GitHub or provide feedback.
