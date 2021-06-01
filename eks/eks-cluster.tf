#
# EKS Cluster Resources
#  * IAM Role to allow EKS service to manage other AWS services
#  * EC2 Security Group to allow networking traffic with EKS cluster
#  * EKS Cluster
#

resource "aws_iam_role" "jy-cluster" {
  name = "terraform-eks-jy-cluster"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "jy-cluster-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.jy-cluster.name
}

resource "aws_iam_role_policy_attachment" "jy-cluster-AmazonEKSVPCResourceController" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.jy-cluster.name
}

resource "aws_security_group" "jy-cluster" {
  name        = "terraform-eks-jy-cluster"
  description = "Cluster communication with worker nodes"
  vpc_id      = aws_vpc.jy.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "terraform-eks-jy"
  }
}

resource "aws_eks_cluster" "jy" {
  name     = var.cluster-name
  role_arn = aws_iam_role.jy-cluster.arn

  vpc_config {
    security_group_ids = [aws_security_group.jy-cluster.id]
    subnet_ids         = aws_subnet.jy[*].id
  }

  depends_on = [
    aws_iam_role_policy_attachment.jy-cluster-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.jy-cluster-AmazonEKSVPCResourceController,
  ]
}
