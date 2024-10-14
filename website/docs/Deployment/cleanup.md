---
sidebar_position: 2
sidebar_label: Cleanup
---

# Cleaning Up the Infrastructure 🧹

When you're done with using the Amazon EKS cluster, it's essential to clean up the cluster and any deployed resources to avoid incurring unnecessary costs. 

To remove all resources and clean up the EKS cluster, we've added a `cleanup.sh` script in the github repository. To run the script, execute the below commands.

```
cd spark-rapids-on-kubernetes/scripts
chmod +x cleanup.sh
./cleanup.sh
```

The `cleanup.sh` destroys the EKS cluster and other associated resources (like VPC, Subnets, NAT Gateways etc.) and also deletes any addons that were installed during the installation process.

