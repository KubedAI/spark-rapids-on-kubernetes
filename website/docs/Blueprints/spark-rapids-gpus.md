---
sidebar_position: 1
sidebar_label: 🚀 Spark RAPIDS on GPUs
---

# ⚡ Spark RAPIDS on GPUs

Welcome to the **Spark RAPIDS on GPUs** documentation! This guide will help you execute a Spark RAPIDS job on a Kubernetes cluster using GPUs for accelerated data processing. Let's get started! 💡

---

## ✅ Pre-requisites

Before you begin, ensure you have the following in place:

1. 🚀 **EKS Cluster**: Make sure your EKS Cluster is up and running.
2. ⚙️ **Karpenter**: The Karpenter autoscaler is properly configured.
3. 🧑‍💻 **Spark Operator**: The Spark Operator is installed and ready for use.

Follow this [installation guide](https://kubedai.github.io/spark-rapids-on-kubernetes/docs/Deployment/installation) to set up your cluster and the necessary addons.

---

## 💻 Executing the Spark RAPIDS Sample Job

This sample job will demonstrate how to run Spark jobs exclusively on **GPUs** using the **Spark RAPIDS** plugin. Here's what the job does:

- 🎲 **Generates Large DataFrames**: The job creates large DataFrames for testing.
- 🔄 **Joins, Aggregations, and Transformations**: It performs data joins, complex aggregations, and transformations on the GPU.
- 🛠️ **Explains Execution Plan**: The job provides an execution plan for debugging and optimization.

---

### 📂 Step 1: Change Directory
Navigate to the directory where you've cloned the Spark RAPIDS project:

```bash
cd spark-rapids-on-kubernetes
```

### 🚀 Step 2: Execute the Spark RAPIDS Job

Ensure you have access to the Kubernetes cluster and are authenticated using kubeconfig. If you haven't authenticated yet, follow the installation steps to set it up.

Run the following command to execute the Spark RAPIDS job:

```sh
kubectl apply -f examples/spark-rapids-sample/rapids-sparkoperator-gpu-test.yaml
```

This will:

 - Request One Driver Pod on an x86 machine (e.g., m6i.large).

 - Request One Executor Pod on a GPU node (e.g., g6.xlarge).

### ⏳ What to Expect

⚡ Node Scaling: The executor pod may take 3-4 minutes to become ready because:

    - 🕒 Karpenter takes around 50 seconds to provision a new GPU node.

    - 🐋 Docker Image Pulling may take 1-2 minutes for the executor pod to start.

🎯 Job Duration: Once everything is set up, the Spark RAPIDS job will complete execution in under 3 minutes.

### 📋 Driver Pod Logs

Once the job completes or during the job execution, you can view the driver logs to see the GPU execution plan and verify the performance improvements using RAPIDS.

```bash
kubectl logs spark-rapids-gpu-test-driver -n data-eng-team
```

**Example of a driver log snippet:**

<details>
  <summary>Click to expand full log (600 lines)</summary>

    ```bash
    ++ id -u
    + myuid=185
    ++ id -g
    + mygid=0
    + set +e
    ++ getent passwd 185
    + uidentry=
    + set -e
    + '[' -z '' ']'
    + '[' -w /etc/passwd ']'
    + echo '185:x:185:0:anonymous uid:/opt/spark:/bin/false'
    + '[' -z /usr/lib/jvm/java-1.8.0-openjdk-amd64 ']'
    + SPARK_CLASSPATH=':/opt/spark/jars/*'
    + env
    + grep SPARK_JAVA_OPT_
    + sort -t_ -k4 -n
    + sed 's/[^=]*=\(.*\)/\1/g'
    ++ command -v readarray
    + '[' readarray ']'
    + readarray -t SPARK_EXECUTOR_JAVA_OPTS
    + '[' -n '' ']'
    + '[' -z ']'
    + '[' -z ']'
    + '[' -n '' ']'
    + '[' -z ']'
    + '[' -z x ']'
    + SPARK_CLASSPATH='/opt/spark/conf::/opt/spark/jars/*'
    + SPARK_CLASSPATH='/opt/spark/conf::/opt/spark/jars/*:/opt/spark/work-dir'
    + case "$1" in
    + shift 1
    + CMD=("$SPARK_HOME/bin/spark-submit" --conf "spark.driver.bindAddress=$SPARK_DRIVER_BIND_ADDRESS" --conf "spark.executorEnv.SPARK_DRIVER_POD_IP=$SPARK_DRIVER_BIND_ADDRESS" --deploy-mode client "$@")
    + exec /usr/bin/tini -s -- /opt/spark/bin/spark-submit --conf spark.driver.bindAddress=100.64.216.89 --conf spark.executorEnv.SPARK_DRIVER_POD_IP=100.64.216.89 --deploy-mode client --properties-file /opt/spark/conf/spark.properties --class org.apache.spark.deploy.PythonRunner local:///opt/sparkRapidsPlugin/gpu_rapids_performance_test.py
    24/10/13 04:37:28 WARN NativeCodeLoader: Unable to load native-hadoop library for your platform... using builtin-java classes where applicable
    INFO:__main__:Configuring Spark session with RAPIDS (GPU-only mode)...
    24/10/13 04:37:29 INFO SparkContext: Running Spark version 3.5.1
    24/10/13 04:37:29 INFO SparkContext: OS info Linux, 6.1.109-118.189.amzn2023.x86_64, amd64
    24/10/13 04:37:29 INFO SparkContext: Java version 1.8.0_422
    24/10/13 04:37:29 INFO ResourceUtils: ==============================================================
    24/10/13 04:37:29 INFO ResourceUtils: No custom resources configured for spark.driver.
    24/10/13 04:37:29 INFO ResourceUtils: ==============================================================
    24/10/13 04:37:29 INFO SparkContext: Submitted application: Spark-RAPIDS-GPU-Only-Performance-Test
    24/10/13 04:37:29 INFO ResourceProfile: Default ResourceProfile created, executor resources: Map(gpu -> name: gpu, amount: 1, script: /opt/sparkRapidsPlugin/getGpusResources.sh, vendor: nvidia.com, cores -> name: cores, amount: 4, script: , vendor: , offHeap -> name: offHeap, amount: 0, script: , vendor: , memoryOverhead -> name: memoryOverhead, amount: 4096, script: , vendor: , memory -> name: memory, amount: 16384, script: , vendor: ), task resources: Map(cpus -> name: cpus, amount: 1.0, gpu -> name: gpu, amount: 1.0)
    24/10/13 04:37:29 INFO ResourceProfile: Limiting resource is gpu at 1 tasks per executor
    24/10/13 04:37:29 WARN ResourceUtils: The configuration of cores (exec = 4 task = 1, runnable tasks = 4) will result in wasted resources due to resource gpu limiting the number of runnable tasks per executor to: 1. Please adjust your configuration.
    24/10/13 04:37:29 INFO ResourceProfileManager: Added ResourceProfile id: 0
    24/10/13 04:37:29 INFO SecurityManager: Changing view acls to: 185,spark
    24/10/13 04:37:29 INFO SecurityManager: Changing modify acls to: 185,spark
    24/10/13 04:37:29 INFO SecurityManager: Changing view acls groups to:
    24/10/13 04:37:29 INFO SecurityManager: Changing modify acls groups to:
    24/10/13 04:37:29 INFO SecurityManager: SecurityManager: authentication disabled; ui acls disabled; users with view permissions: 185, spark; groups with view permissions: EMPTY; users with modify permissions: 185, spark; groups with modify permissions: EMPTY
    24/10/13 04:37:29 INFO Utils: Successfully started service 'sparkDriver' on port 7078.
    24/10/13 04:37:29 INFO SparkEnv: Registering MapOutputTracker
    24/10/13 04:37:29 INFO SparkEnv: Registering BlockManagerMaster
    24/10/13 04:37:29 INFO BlockManagerMasterEndpoint: Using org.apache.spark.storage.DefaultTopologyMapper for getting topology information
    24/10/13 04:37:29 INFO BlockManagerMasterEndpoint: BlockManagerMasterEndpoint up
    24/10/13 04:37:29 INFO SparkEnv: Registering BlockManagerMasterHeartbeat
    24/10/13 04:37:30 INFO DiskBlockManager: Created local directory at /var/data/spark-8c98f9d9-05b6-4332-9d8e-ef900f191715/blockmgr-e681fb9c-77ae-4e94-a2ae-9a73abc8d0b0
    24/10/13 04:37:30 INFO MemoryStore: MemoryStore started with capacity 912.3 MiB
    24/10/13 04:37:30 INFO SparkEnv: Registering OutputCommitCoordinator
    24/10/13 04:37:30 INFO JettyUtils: Start Jetty 0.0.0.0:4045 for SparkUI
    24/10/13 04:37:30 INFO Utils: Successfully started service 'SparkUI' on port 4045.
    24/10/13 04:37:30 INFO ShimLoader: Loading shim for Spark version: 3.5.1
    24/10/13 04:37:30 INFO ShimLoader: Complete Spark build info: 3.5.1, https://github.com/apache/spark, HEAD, fd86f85e181fc2dc0f50a096855acf83a6cc5d9c, 2024-02-15T11:24:58Z
    24/10/13 04:37:30 INFO ShimLoader: Scala version: version 2.12.18
    24/10/13 04:37:30 INFO ShimLoader: findURLClassLoader found a URLClassLoader org.apache.spark.util.MutableURLClassLoader@13e3c1c7
    24/10/13 04:37:30 INFO ShimLoader: Updating spark classloader org.apache.spark.util.MutableURLClassLoader@13e3c1c7 with the URLs: jar:file:/opt/spark/jars/rapids-4-spark_2.12-24.08.1.jar!/spark-shared/, jar:file:/opt/spark/jars/rapids-4-spark_2.12-24.08.1.jar!/spark351/
    24/10/13 04:37:30 INFO ShimLoader: Spark classLoader org.apache.spark.util.MutableURLClassLoader@13e3c1c7 updated successfully
    24/10/13 04:37:30 INFO ShimLoader: Updating spark classloader org.apache.spark.util.MutableURLClassLoader@13e3c1c7 with the URLs: jar:file:/opt/spark/jars/rapids-4-spark_2.12-24.08.1.jar!/spark-shared/, jar:file:/opt/spark/jars/rapids-4-spark_2.12-24.08.1.jar!/spark351/
    24/10/13 04:37:30 INFO ShimLoader: Spark classLoader org.apache.spark.util.MutableURLClassLoader@13e3c1c7 updated successfully
    24/10/13 04:37:31 INFO RapidsPluginUtils: RAPIDS Accelerator build: Map(url -> https://github.com/NVIDIA/spark-rapids.git, branch -> HEAD, revision -> 145f4fd3377e708447137673f19ba17839b23aee, version -> 24.08.1, date -> 2024-08-19T03:47:58Z, cudf_version -> 24.08.0, user -> root)
    24/10/13 04:37:31 INFO RapidsPluginUtils: RAPIDS Accelerator JNI build: Map(url -> https://github.com/NVIDIA/spark-rapids-jni.git, branch -> HEAD, gpu_architectures -> 70;75;80;86;90, revision -> 457498d7fbc37f1eefaf0f02ff22f31d47ceca69, version -> 24.08.0, date -> 2024-08-09T01:35:53Z, user -> root)
    24/10/13 04:37:31 INFO RapidsPluginUtils: cudf build: Map(url -> https://github.com/rapidsai/cudf.git, branch -> HEAD, gpu_architectures -> 70;75;80;86;90, revision -> 4afeb5afa7ac483eef8f9a193c73fcce584db92b, version -> 24.08.0, date -> 2024-08-09T01:35:51Z, user -> root)
    24/10/13 04:37:31 INFO RapidsPluginUtils: RAPIDS Accelerator Private Map(url -> https://gitlab-master.nvidia.com/nvspark/spark-rapids-private.git, branch -> HEAD, revision -> 9fac64da220ddd6bf5626bd7bd1dd74c08603eac, version -> 24.08.0, date -> 2024-08-09T08:34:22Z, user -> root)
    24/10/13 04:37:31 WARN RapidsPluginUtils: RAPIDS Accelerator 24.08.1 using cudf 24.08.0, private revision 9fac64da220ddd6bf5626bd7bd1dd74c08603eac
    24/10/13 04:37:31 WARN RapidsPluginUtils: spark.rapids.sql.multiThreadedRead.numThreads is set to 20.
    24/10/13 04:37:31 WARN RapidsPluginUtils: The current setting of spark.task.resource.gpu.amount (1.0) is not ideal to get the best performance from the RAPIDS Accelerator plugin. It's recommended to be 1/{executor core count} unless you have a special use case.
    24/10/13 04:37:31 WARN RapidsPluginUtils: RAPIDS Accelerator is enabled, to disable GPU support set `spark.rapids.sql.enabled` to false.
    24/10/13 04:37:31 WARN RapidsPluginUtils: spark.rapids.sql.explain is set to `ALL`. Set it to 'NONE' to suppress the diagnostics logging about the query placement on the GPU.
    24/10/13 04:37:31 WARN RapidsShuffleInternalManagerBase: Rapids Shuffle Plugin enabled. Multi-threaded shuffle mode (write threads=20, read threads=20). To disable the RAPIDS Shuffle Manager set `spark.rapids.shuffle.enabled` to false
    24/10/13 04:37:31 INFO DriverPluginContainer: Initialized driver component for plugin com.nvidia.spark.SQLPlugin.
    24/10/13 04:37:31 INFO SparkKubernetesClientFactory: Auto-configuring K8S client using current context from users K8S config file
    24/10/13 04:37:33 INFO ExecutorPodsAllocator: Going to request 1 executors from Kubernetes for ResourceProfile Id: 0, target: 1, known: 0, sharedSlotFromPendingPods: 2147483647.
    24/10/13 04:37:33 INFO ExecutorPodsAllocator: Found 0 reusable PVCs from 0 PVCs
    24/10/13 04:37:33 INFO Utils: Successfully started service 'org.apache.spark.network.netty.NettyBlockTransferService' on port 7079.
    24/10/13 04:37:33 INFO NettyBlockTransferService: Server created on spark-rapids-gpu-test-5b721692842aaf82-driver-svc.data-eng-team.svc 100.64.216.89:7079
    24/10/13 04:37:33 INFO BlockManager: Using org.apache.spark.storage.RandomBlockReplicationPolicy for block replication policy
    24/10/13 04:37:33 INFO BlockManagerMaster: Registering BlockManager BlockManagerId(driver, spark-rapids-gpu-test-5b721692842aaf82-driver-svc.data-eng-team.svc, 7079, None)
    24/10/13 04:37:33 INFO BlockManagerMasterEndpoint: Registering block manager spark-rapids-gpu-test-5b721692842aaf82-driver-svc.data-eng-team.svc:7079 with 912.3 MiB RAM, BlockManagerId(driver, spark-rapids-gpu-test-5b721692842aaf82-driver-svc.data-eng-team.svc, 7079, None)
    24/10/13 04:37:33 INFO BlockManagerMaster: Registered BlockManager BlockManagerId(driver, spark-rapids-gpu-test-5b721692842aaf82-driver-svc.data-eng-team.svc, 7079, None)
    24/10/13 04:37:33 INFO BlockManager: Initialized BlockManager: BlockManagerId(driver, spark-rapids-gpu-test-5b721692842aaf82-driver-svc.data-eng-team.svc, 7079, None)
    24/10/13 04:37:33 INFO BasicExecutorFeatureStep: Decommissioning not enabled, skipping shutdown script
    24/10/13 04:38:03 INFO KubernetesClusterSchedulerBackend: SchedulerBackend is ready for scheduling beginning after waiting maxRegisteredResourcesWaitingTime: 30000000000(ns)
    INFO:__main__:Spark session initialized successfully (GPU-only).
    INFO:__main__:Creating large DataFrames with multiple columns for join operation...
    24/10/13 04:38:05 INFO SharedState: Setting hive.metastore.warehouse.dir ('null') to the value of spark.sql.warehouse.dir.
    24/10/13 04:38:05 INFO SharedState: Warehouse path is 'file:/opt/spark/work-dir/spark-warehouse'.
    INFO:__main__:Performing a GPU-accelerated join between two large DataFrames...
    INFO:__main__:Performing aggregation on the joined DataFrame using GPU...
    INFO:__main__:Running SQL query with aggregation and filtering, explaining execution plan...
    24/10/13 04:38:09 INFO GpuOverrides: Plan conversion to the GPU took 43.05 ms
    24/10/13 04:38:09 INFO GpuOverrides: GPU plan transition optimization took 9.75 ms
    24/10/13 04:38:10 WARN GpuOverrides:
    *Exec <SortExec> will run on GPU
    *Expression <SortOrder> total_amount1#74 DESC NULLS LAST will run on GPU
    *Exec <ShuffleExchangeExec> will run on GPU
        *Partitioning <RangePartitioning> will run on GPU
        *Expression <SortOrder> total_amount1#74 DESC NULLS LAST will run on GPU
        *Exec <FilterExec> will run on GPU
        *Expression <And> ((isnotnull(total_amount1#74) AND isnotnull(total_amount2#75)) AND ((total_amount1#74 > 5000.0) AND (total_amount2#75 > 10000.0))) will run on GPU
            *Expression <And> (isnotnull(total_amount1#74) AND isnotnull(total_amount2#75)) will run on GPU
            *Expression <IsNotNull> isnotnull(total_amount1#74) will run on GPU
            *Expression <IsNotNull> isnotnull(total_amount2#75) will run on GPU
            *Expression <And> ((total_amount1#74 > 5000.0) AND (total_amount2#75 > 10000.0)) will run on GPU
            *Expression <GreaterThan> (total_amount1#74 > 5000.0) will run on GPU
            *Expression <GreaterThan> (total_amount2#75 > 10000.0) will run on GPU
        *Exec <HashAggregateExec> will run on GPU
            *Expression <AggregateExpression> sum(amount1#11) will run on GPU
            *Expression <Sum> sum(amount1#11) will run on GPU
            *Expression <AggregateExpression> sum(amount2#33) will run on GPU
            *Expression <Sum> sum(amount2#33) will run on GPU
            *Expression <Alias> sum(amount1#11)#78 AS total_amount1#74 will run on GPU
            *Expression <Alias> sum(amount2#33)#79 AS total_amount2#75 will run on GPU
            *Exec <ShuffleExchangeExec> will run on GPU
            *Partitioning <HashPartitioning> will run on GPU
            *Exec <HashAggregateExec> will run on GPU
                *Expression <AggregateExpression> partial_sum(amount1#11) will run on GPU
                *Expression <Sum> sum(amount1#11) will run on GPU
                *Expression <AggregateExpression> partial_sum(amount2#33) will run on GPU
                *Expression <Sum> sum(amount2#33) will run on GPU
                *Exec <ProjectExec> will run on GPU
                *Exec <SortMergeJoinExec> will run on GPU
                    #Exec <SortExec> could run on GPU but is going to be removed because replacing sortMergeJoin with shuffleHashJoin
                    #Expression <SortOrder> id1#2L ASC NULLS FIRST could run on GPU but is going to be removed because parent plan is removed
                    *Exec <ShuffleExchangeExec> will run on GPU
                        *Partitioning <HashPartitioning> will run on GPU
                        *Exec <ProjectExec> will run on GPU
                        *Expression <Alias> (rand(-4580673251311449240) * 1000.0) AS amount1#11 will run on GPU
                            *Expression <Multiply> (rand(-4580673251311449240) * 1000.0) will run on GPU
                            *Expression <Rand> rand(-4580673251311449240) will run on GPU
                        *Exec <ProjectExec> will run on GPU
                            *Expression <Alias> id#0L AS id1#2L will run on GPU
                            *Expression <Alias> CASE WHEN (rand(-162214519805210713) > 0.5) THEN A ELSE B END AS category1#7 will run on GPU
                            *Expression <CaseWhen> CASE WHEN (rand(-162214519805210713) > 0.5) THEN A ELSE B END will run on GPU
                                *Expression <GreaterThan> (rand(-162214519805210713) > 0.5) will run on GPU
                                *Expression <Rand> rand(-162214519805210713) will run on GPU
                            *Exec <RangeExec> will run on GPU
                    #Exec <SortExec> could run on GPU but is going to be removed because replacing sortMergeJoin with shuffleHashJoin
                    #Expression <SortOrder> id2#24L ASC NULLS FIRST could run on GPU but is going to be removed because parent plan is removed
                    *Exec <ShuffleExchangeExec> will run on GPU
                        *Partitioning <HashPartitioning> will run on GPU
                        *Exec <ProjectExec> will run on GPU
                        *Expression <Alias> (rand(-3531675506200722645) * 2000.0) AS amount2#33 will run on GPU
                            *Expression <Multiply> (rand(-3531675506200722645) * 2000.0) will run on GPU
                            *Expression <Rand> rand(-3531675506200722645) will run on GPU
                        *Exec <ProjectExec> will run on GPU
                            *Expression <Alias> id#22L AS id2#24L will run on GPU
                            *Expression <Alias> CASE WHEN (rand(8868201660340206917) > 0.5) THEN X ELSE Y END AS category2#29 will run on GPU
                            *Expression <CaseWhen> CASE WHEN (rand(8868201660340206917) > 0.5) THEN X ELSE Y END will run on GPU
                                *Expression <GreaterThan> (rand(8868201660340206917) > 0.5) will run on GPU
                                *Expression <Rand> rand(8868201660340206917) will run on GPU
                            *Exec <RangeExec> will run on GPU

    ...
    ...
    24/10/13 04:40:11 INFO GpuOverrides: Plan conversion to the GPU took 5.93 ms
    24/10/13 04:40:11 INFO GpuOverrides: GPU plan transition optimization took 6.83 ms
    24/10/13 04:40:11 INFO SparkContext: Starting job: showString at NativeMethodAccessorImpl.java:0
    24/10/13 04:40:11 INFO DAGScheduler: Got job 3 (showString at NativeMethodAccessorImpl.java:0) with 1 output partitions
    24/10/13 04:40:11 INFO DAGScheduler: Final stage: ResultStage 8 (showString at NativeMethodAccessorImpl.java:0)
    24/10/13 04:40:11 INFO DAGScheduler: Parents of final stage: List(ShuffleMapStage 7)
    24/10/13 04:40:11 INFO DAGScheduler: Missing parents: List()
    24/10/13 04:40:11 INFO DAGScheduler: Submitting ResultStage 8 (MapPartitionsRDD[38] at showString at NativeMethodAccessorImpl.java:0), which has no missing parents
    24/10/13 04:40:11 INFO MemoryStore: Block broadcast_3 stored as values in memory (estimated size 66.5 KiB, free 912.1 MiB)
    24/10/13 04:40:11 INFO MemoryStore: Block broadcast_3_piece0 stored as bytes in memory (estimated size 29.3 KiB, free 912.1 MiB)
    24/10/13 04:40:11 INFO BlockManagerInfo: Added broadcast_3_piece0 in memory on spark-rapids-gpu-test-5b721692842aaf82-driver-svc.data-eng-team.svc:7079 (size: 29.3 KiB, free: 912.2 MiB)
    24/10/13 04:40:11 INFO SparkContext: Created broadcast 3 from broadcast at DAGScheduler.scala:1585
    24/10/13 04:40:11 INFO DAGScheduler: Submitting 1 missing tasks from ResultStage 8 (MapPartitionsRDD[38] at showString at NativeMethodAccessorImpl.java:0) (first 15 tasks are for partitions Vector(0))
    24/10/13 04:40:11 INFO TaskSchedulerImpl: Adding task set 8.0 with 1 tasks resource profile 0
    24/10/13 04:40:11 INFO TaskSetManager: Starting task 0.0 in stage 8.0 (TID 14) (100.64.144.54, executor 1, partition 0, NODE_LOCAL, 7643 bytes) taskResourceAssignments Map(gpu -> [name: gpu, addresses: 0])
    24/10/13 04:40:11 INFO BlockManagerInfo: Added broadcast_3_piece0 in memory on 100.64.144.54:40463 (size: 29.3 KiB, free: 9.0 GiB)
    24/10/13 04:40:11 INFO MapOutputTrackerMasterEndpoint: Asked to send map output locations for shuffle 2 to 100.64.144.54:39980
    24/10/13 04:40:12 INFO TaskSetManager: Finished task 0.0 in stage 8.0 (TID 14) in 497 ms on 100.64.144.54 (executor 1) (1/1)
    24/10/13 04:40:12 INFO TaskSchedulerImpl: Removed TaskSet 8.0, whose tasks have all completed, from pool
    24/10/13 04:40:12 INFO DAGScheduler: ResultStage 8 (showString at NativeMethodAccessorImpl.java:0) finished in 0.551 s
    24/10/13 04:40:12 INFO DAGScheduler: Job 3 is finished. Cancelling potential speculative or zombie tasks for this job
    24/10/13 04:40:12 INFO TaskSchedulerImpl: Killing all running tasks in stage 8: Stage finished
    24/10/13 04:40:12 INFO DAGScheduler: Job 3 finished: showString at NativeMethodAccessorImpl.java:0, took 0.573601 s
    24/10/13 04:40:12 INFO CodeGenerator: Code generated in 337.051601 ms
    +---------+---------+--------------------+--------------------+
    |category1|category2|       total_amount1|       total_amount2|
    +---------+---------+--------------------+--------------------+
    |        B|        Y|1.2509678979152799E9|2.5029069984810357E9|
    |        B|        X|1.2505991236420312E9| 2.498830686819548E9|
    |        A|        Y|1.2502600486702027E9|2.4991205284351277E9|
    |        A|        X|1.2500673333482282E9| 2.498443896974076E9|
    +---------+---------+--------------------+--------------------+

    INFO:__main__:Stopping the Spark session.
    24/10/13 04:40:12 INFO SparkContext: SparkContext is stopping with exitCode 0.
    24/10/13 04:40:12 INFO SparkUI: Stopped Spark web UI at http://spark-rapids-gpu-test-5b721692842aaf82-driver-svc.data-eng-team.svc:4045
    24/10/13 04:40:12 INFO KubernetesClusterSchedulerBackend: Shutting down all executors
    24/10/13 04:40:12 INFO KubernetesClusterSchedulerBackend$KubernetesDriverEndpoint: Asking each executor to shut down
    24/10/13 04:40:12 WARN ExecutorPodsWatchSnapshotSource: Kubernetes client has been closed.
    24/10/13 04:40:12 INFO MapOutputTrackerMasterEndpoint: MapOutputTrackerMasterEndpoint stopped!
    24/10/13 04:40:12 INFO MemoryStore: MemoryStore cleared
    24/10/13 04:40:12 INFO BlockManager: BlockManager stopped
    24/10/13 04:40:12 INFO BlockManagerMaster: BlockManagerMaster stopped
    24/10/13 04:40:12 INFO OutputCommitCoordinator$OutputCommitCoordinatorEndpoint: OutputCommitCoordinator stopped!
    24/10/13 04:40:12 INFO SparkContext: Successfully stopped SparkContext
    INFO:__main__:Spark session stopped successfully.
    24/10/13 04:40:13 INFO ShutdownHookManager: Shutdown hook called
    24/10/13 04:40:13 INFO ShutdownHookManager: Deleting directory /var/data/spark-8c98f9d9-05b6-4332-9d8e-ef900f191715/spark-be20bd85-675f-4447-8564-60ff5d990034/pyspark-d4aee595-e3ed-48ed-abf8-3a6e0a5733b7
    24/10/13 04:40:13 INFO ShutdownHookManager: Deleting directory /var/data/spark-8c98f9d9-05b6-4332-9d8e-ef900f191715/spark-be20bd85-675f-4447-8564-60ff5d990034
    24/10/13 04:40:13 INFO ShutdownHookManager: Deleting directory /tmp/spark-a227b906-04fe-4ace-a08b-9dfb8d8c0364
    ```
</details>


## 🧹 Cleanup Step

Once you're done with the job execution and have reviewed the results, you can clean up the resources created by the Spark RAPIDS job to free up cluster resources.

To delete the job and its associated resources, run the following command:

```bash
kubectl delete -f examples/spark-rapids-sample/rapids-sparkoperator-gpu-test.yaml
```

This will:

🗑️ Remove the driver and executor pods created by the job.

🛠️ Free up the GPU resources provisioned by Karpenter.

:::warning

Before you shut down your laptop and call it a day, **make sure** that those **GPU nodes** have scaled down! 💸

If you don't, the GPUs will still be running in the cloud, quietly adding to your bill while you're binge-watching your favorite show. 🤑

So, save your wallet! Double-check everything with:

```bash
kubectl get nodes
```
Your future self (and bank account) will thank you! 😅

:::


That's it! 🎉 You've successfully executed a Spark RAPIDS job on Kubernetes using GPUs for accelerated processing. 🚀
