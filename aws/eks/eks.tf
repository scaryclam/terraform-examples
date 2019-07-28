resource "aws_eks_cluster" "eks-cluster-1" {
  name = "sample-eks-${var.env_name}-cluster"
  role_arn = "${aws_iam_role.eks-cluster-role.arn}"

  vpc_config {
    subnet_ids = ["${aws_subnet.eks-example-eu-west-1a.id}", "${aws_subnet.eks-example-eu-west-1b.id}"]
    security_group_ids = ["${aws_security_group.eks_cluster_control_plane_sg.id}"]
  }
}
