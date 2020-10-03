# Role setup for the EC2 nodes
resource "aws_iam_role" "eks-instance-role" {
  name = "eks-instance-role"
  path = "/"
  assume_role_policy = data.aws_iam_policy_document.eks-instance-policy.json
}

data "aws_iam_policy_document" "eks-instance-policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "eks-worker-role-attachment" {
  role = aws_iam_role.eks-instance-role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "eks-cni-role-attachment" {
  role = aws_iam_role.eks-instance-role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_role_policy_attachment" "eks-container-role-attachment" {
  role = aws_iam_role.eks-instance-role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_instance_profile" "eks-instance-profile" {
  name = "eks-instance-profile"
  path = "/"
  role = aws_iam_role.eks-instance-role.id
  provisioner "local-exec" {
    command = "sleep 60"
  }
}



# Role setup for the cluster
resource "aws_iam_role" "eks-cluster-role" {
  name = "eks-cluster-role"
  path = "/"
  assume_role_policy = data.aws_iam_policy_document.eks-cluster-policy.json
}

resource "aws_iam_role_policy_attachment" "eks-cluster-role-attachment" {
  role = aws_iam_role.eks-cluster-role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_iam_role_policy_attachment" "eks-service-role-attachment" {
  role = aws_iam_role.eks-cluster-role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
}

data "aws_iam_policy_document" "eks-cluster-policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type = "Service"
      identifiers = ["eks.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "eks-service-policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type = "Service"
      identifiers = ["eks.amazonaws.com"]
    }
  }
}
