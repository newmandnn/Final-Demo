variable "eks_cluster_name" {
  default = "Demo-3"
}

variable "eks_cluster_name_role" {
  default = "Demo-role"
}

variable "vpc" {
  description = "AWS VPC"
}

variable "public_subnet_cidrs" {
  type = list(string)
  default = [
    "10.0.1.0/24",
    "10.0.2.0/24"
  ]
}

variable "private_subnet_cidrs" {
  type = list(string)
  default = [
    "10.0.3.0/24",
    "10.0.4.0/24"
  ]
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "tags" {}

variable "env" {}

variable "vpc_id" {}

variable "vpc_cidr" {}
