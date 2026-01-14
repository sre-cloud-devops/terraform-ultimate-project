variable "vpc_cidr" {
    description = "VPC CIDR"    
    type =string
    default = "192.168.0.0/16"
  
}

variable "public_subnet_cidr" {
    description = "Public Subnet CIDR Blocks"    
    type =list(string)
    default = ["192.168.1.0/24"]
  
}


variable "private_subnet_cidr" {
    description = "Private Subnet CIDR Blocks"    
    type =list(string)
    default = ["192.168.2.0/24"]
  
}

variable "public_subnet_AZs" {
    description = "Public Subnet Availability Zones"    
    type =list(string)
    default = ["us-east-1a"]
  
}

variable "private_subnet_AZs" {
    description = "Private Subnet Availability Zones"    
    type =list(string)
    default = ["us-east-1a"]
  
}

variable "cluster_name" {
description = "EKS cluster name"
type = string
default = "my-eks-cluster-01"
}


variable "cluster_version" {
description = "EKS cluster version"
type = string
default = "1.24"
}

variable "node_group_config" {
    description = "Node group configuration for the EKS cluster"
    type = map(object({
        instance_types = list(string)
        capacity_type  = string
        scaling_config = object({
            desired_size = number
            max_size     = number
            min_size     = number
        })
    }))
    default ={
        general ={
            instance_types = ["t3.medium"]
            capacity_type  = "ON_DEMAND"
            scaling_config = {
                desired_size = 2
                max_size     = 4
                min_size     = 1
        }
    }
    }

}