#////////////////////NETWORK\\\\\\\\\\\\\\\\\\\\\\\\
variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "env" {
  type    = string
  default = "Demo-4"
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
  description = "A list of public subnets inside the VPC"
  type        = list(string)
  default     = []
}

variable "private_subnet_ids" {
  description = "A list of private subnets inside the VPC"
  type        = list(string)
  default     = []
}

#<<<<<<<<<<<<<<<<ECR>>>>>>>>>>>>>>>>>>
variable "repository_name" {
  default = "demo-app-1"
}

#>>>>>>>>>>>>>>>>EKS<<<<<<<<<<<<<<<<<<
variable "cluster_name" {
  default = "Demo-3"
}


locals {
  tags = {
    Environment = var.env
  }
}



#================RDS===================
locals {
  db_name = "Demo-db"
  //db_identifier = "PostgreSQL-db"
}

variable "username" {
  default = "demo"
}
