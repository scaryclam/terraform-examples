# This is a sample set of files for creating an EKS cluster

 `$terraform apply -var-file=variables/default.tfvars`

This will:

 - Set up a new VPC with the requisite network resources
 - Create security groups for the nodes and the control plane
 - Create the IAM roles and policies for the cluster and the instances (nodes)
 - Create the cluster
 - Create the autoscaling group with the launch template for the AWS EKS-optimised instances

So when terraform apply has finished, you will have a cluster with an attached node running.

Using kubectl

Run:

 `$ aws eks --region eu-west-1 update-kubeconfig --name sample-eks-example-cluster`

 `$ kubectl apply -f aws-auth-cm.yaml`
