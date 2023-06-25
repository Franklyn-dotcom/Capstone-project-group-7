
# Create an IAM role for the EKS cluster
resource "aws_iam_role" "eks-cluster-role" {
  name = "${var.prefix}-eks-cluster-role"

  assume_role_policy = <<EOF
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
EOF
}

# Attach AmazonEKSClusterPolicy to IAM role for the EKS cluster
resource "aws_iam_role_policy_attachment" "AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks-cluster-role.name
}

# Create the EKS cluster
resource "aws_eks_cluster" "cluster" {
  name     = "${var.prefix}-eks-cluster"
  role_arn = aws_iam_role.eks-cluster-role.arn

  vpc_config {

    # subnet_ids = [aws_subnet.subnets[count.index].id, for count.index in range(length(var.subnet_cidrs))]
    subnet_ids         = [aws_subnet.public_subnet[0].id, aws_subnet.public_subnet[1].id, aws_subnet.private_subnet[0].id, aws_subnet.private_subnet[1].id, ]
    endpoint_private_access = true
    endpoint_public_access  = true
    security_group_ids = [aws_security_group.eks-cluster.id]
  }
  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSClusterPolicy
  ]
}
