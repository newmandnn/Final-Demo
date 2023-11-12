# output "eks-endpoint" {
#   value = aws_eks_cluster.eks.endpoint
# }

output "kubeconfig-certificate-authority-data" {
  value = aws_eks_cluster.eks.certificate_authority[0].data
}

output "eks_endpoint" {
  value = data.aws_eks_cluster.demo_cluster.endpoint
}

output "eks_certificate_authority" {
  value = data.aws_eks_cluster.demo_cluster.certificate_authority[0].data
}

output "eks_auth_token" {
  value = data.aws_eks_cluster_auth.demo_cluster.token
}

output "aws_load_balancer_controller_role_arn" {
  value = aws_iam_role.aws_load_balancer_controller.arn
}


