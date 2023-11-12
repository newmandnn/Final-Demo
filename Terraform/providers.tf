terraform {
  required_version = ">= 1.2.0"

  backend "s3" {
    bucket  = "terraform-states-temp"
    encrypt = true
    key     = "Demo/terraform-states/terraform.tfstate"
    region  = "eu-central-1"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.11.0"
    }

    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
  }
}

provider "kubernetes" {
  host                   = module.eks.eks_endpoint
  cluster_ca_certificate = base64decode(module.eks.eks_certificate_authority)
  token                  = module.eks.eks_auth_token
}
provider "kubectl" {
  host                   = module.eks.eks_endpoint
  cluster_ca_certificate = base64decode(module.eks.eks_certificate_authority)
  token                  = module.eks.eks_auth_token
  load_config_file       = false
}

provider "helm" {
  kubernetes {
    host                   = module.eks.eks_endpoint
    cluster_ca_certificate = base64decode(module.eks.eks_certificate_authority)
    token                  = module.eks.eks_auth_token
  }
}


