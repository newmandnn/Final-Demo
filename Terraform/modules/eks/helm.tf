resource "helm_release" "alb_controller" {
  count      = 1
  name       = "aws-load-balancer-controller"
  chart      = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  version    = "1.5.3"
  namespace  = "kube-system"

  set {
    name  = "clusterName"
    value = var.eks_cluster_name
  }

  set {
    name  = "awsRegion"
    value = "eu-central-1"
  }

  set {
    name  = "rbac.create"
    value = "true"
  }

  set {
    name  = "serviceAccount.create"
    value = "true"
  }

  set {
    name  = "serviceAccount.name"
    value = "aws-load-balancer-controller"
  }

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = aws_iam_role.aws_load_balancer_controller.arn
  }

  set {
    name  = "enableServiceMutatorWebhook"
    value = "false"
  }

  depends_on = [
    kubernetes_namespace.aws_observability,
    aws_eks_node_group.public,
    aws_iam_role_policy_attachment.aws_load_balancer_controller_attach

  ]
}
