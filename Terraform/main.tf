#===========================================Network==================================================
module "network" {
  source               = "./modules/network"
  vpc_cidr             = var.vpc_cidr
  env                  = var.env
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
}

module "ecr" {
  source          = "./modules/ecr"
  repository_name = var.repository_name
}

#===========================================EKS==================================================

module "eks" {
  source             = "./modules/eks"
  env                = var.env
  tags               = local.tags
  vpc                = module.network.vpc_id
  vpc_id             = module.network.vpc_id
  vpc_cidr           = var.vpc_cidr
  public_subnet_ids  = module.network.public_subnet_ids
  private_subnet_ids = module.network.private_subnet_ids

  depends_on = [module.network]
}

#===========================================ArgoCD==================================================

module "argocd_demo" {
  source           = "./modules/argocd"
  eks_cluster_name = var.cluster_name
  chart_version    = "5.51.0"
}

module "argocd_demo_root" {
  source             = "./modules/argocd-root"
  eks_cluster_name   = var.cluster_name
  git_source_path    = "ArgoCD/applications"
  git_source_repoURL = "git@github.com:newmandnn/Final-Demo.git"
}
