terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  backend "s3" {
  bucket         = "cloud-devops-terraform-statefile-bucket"
  key            = "terraform.tfstate"
  region         = "us-east-1"
  dynamodb_table = "my-terraform-lock-table"
  encrypt        = true
}
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}


module "vpc" {
  source              = "./modules/virtual-private-cloud"
  vpc_cidr            = var.vpc_cidr
  public_subnet_cidr  = var.public_subnet_cidr
  private_subnet_cidr = var.private_subnet_cidr
  public_subnet_AZs   = var.public_subnet_AZs
  private_subnet_AZs  = var.private_subnet_AZs

}

module "eks" {
  source          = "./modules/elastic-kubernetes-service"
  vpc_id = module.vpc.vpc_id
  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version
  subnet_ids      = concat(module.vpc.public_subnet_ids, module.vpc.private_subnet_ids)
  node_group_config = var.node_group_config
}