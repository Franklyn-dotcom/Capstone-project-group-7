# Create the EKS cluster
resource "aws_eks_cluster" "cluster" {
  name     = "${var.prefix}-eks-cluster"
  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {

    # subnet_ids = [aws_subnet.subnets[count.index].id, for count.index in range(length(var.subnet_cidrs))]
    subnet_ids         = aws_subnet.subnets.*.id
    security_group_ids = [aws_security_group.sg.id]
  }
}
