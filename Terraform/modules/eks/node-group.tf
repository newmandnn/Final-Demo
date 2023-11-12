resource "aws_eks_node_group" "private" {
  cluster_name    = aws_eks_cluster.eks.name
  node_group_name = "private-node-group"
  node_role_arn   = aws_iam_role.node-group.arn
  subnet_ids      = var.private_subnet_ids

  labels = {
    "type" = "private"
  }

  instance_types = ["t3.small"]

  scaling_config {
    desired_size = 1
    max_size     = 3
    min_size     = 1
  }

  depends_on = [
    aws_iam_role_policy_attachment.node-group-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.node-group-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.node-group-AmazonEC2ContainerRegistryReadOnly
  ]


}

resource "aws_eks_node_group" "public" {
  cluster_name    = aws_eks_cluster.eks.name
  node_group_name = "public-node-group"
  node_role_arn   = aws_iam_role.node-group.arn
  subnet_ids      = var.public_subnet_ids

  labels = {
    "type" = "public"
  }

  instance_types = ["t3.small"]

  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }

  depends_on = [
    aws_iam_role_policy_attachment.node-group-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.node-group-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.node-group-AmazonEC2ContainerRegistryReadOnly,
  ]

}


resource "aws_iam_role" "node-group" {
  name = "eks-node-group-role"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "node-group-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.node-group.name
}

resource "aws_iam_role_policy_attachment" "node-group-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.node-group.name
}

resource "aws_iam_role_policy_attachment" "node-group-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.node-group.name
}

resource "aws_iam_role_policy" "node-group-ClusterAutoscalerPolicy" {
  name = "eks-cluster-auto-scaler"
  role = aws_iam_role.node-group.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "autoscaling:DescribeAutoScalingGroups",
          "autoscaling:DescribeAutoScalingInstances",
          "autoscaling:DescribeLaunchConfigurations",
          "autoscaling:DescribeTags",
          "autoscaling:SetDesiredCapacity",
          "autoscaling:TerminateInstanceInAutoScalingGroup"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

#========================Security Groups Node============================
resource "aws_security_group" "eks_nodes" {
  name        = "${var.eks_cluster_name}/ClusterSharedNodeSecurityGroup"
  description = "Communication between all nodes in the cluster"
  vpc_id      = var.vpc

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    self      = true
  }

  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [aws_eks_cluster.eks.vpc_config[0].cluster_security_group_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#=====================================ADDONS===============================
resource "aws_eks_addon" "vpc_cni" {
  cluster_name = aws_eks_cluster.eks.name
  addon_name   = "vpc-cni"

  lifecycle {
    ignore_changes = [
      modified_at
    ]
  }

  tags = merge(var.tags, tomap({ "Name" = "vpc-cni" }))

  depends_on = [
    aws_eks_node_group.public
  ]
}

resource "aws_eks_addon" "coredns" {
  cluster_name      = aws_eks_cluster.eks.name
  addon_name        = "coredns"
  resolve_conflicts = "OVERWRITE"

  lifecycle {
    ignore_changes = [
      modified_at
    ]
  }

  tags = merge(var.tags, tomap({ "Name" = "coredns" }))

  depends_on = [
    aws_eks_node_group.public
  ]
}

resource "aws_eks_addon" "kube_proxy" {
  cluster_name      = aws_eks_cluster.eks.name
  addon_name        = "kube-proxy"
  resolve_conflicts = "OVERWRITE"

  lifecycle {
    ignore_changes = [
      modified_at
    ]
  }

  tags = merge(var.tags, tomap({ "Name" = "kube-proxy" }))

  depends_on = [
    aws_eks_node_group.public
  ]
}
