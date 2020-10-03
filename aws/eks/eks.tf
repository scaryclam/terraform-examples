resource "aws_eks_cluster" "eks-cluster-1" {
  name = "sample-eks-example-cluster"
  role_arn = aws_iam_role.eks-cluster-role.arn
  version = "1.17"

  vpc_config {
    subnet_ids = [
      aws_subnet.eks-example-eu-west-1a.id,
      aws_subnet.eks-example-eu-west-1b.id,
      aws_subnet.eks-example-eu-west-1c.id
    ]
    security_group_ids = [aws_security_group.eks_cluster_control_plane_sg.id]
  }
}


resource "aws_eks_node_group" "basic-node-group" {
  cluster_name = aws_eks_cluster.eks-cluster-1.name
  node_group_name = "example-node-group"
  node_role_arn = aws_iam_role.eks-instance-role.arn
  subnet_ids =  [
    aws_subnet.eks-example-eu-west-1a.id,
    aws_subnet.eks-example-eu-west-1b.id,
    aws_subnet.eks-example-eu-west-1c.id
  ]

  scaling_config {
    desired_size = 1
    max_size = 1
    min_size = 1
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.eks-worker-role-attachment,
    aws_iam_role_policy_attachment.eks-cni-role-attachment,
    aws_iam_role_policy_attachment.eks-container-role-attachment,
  ]
}