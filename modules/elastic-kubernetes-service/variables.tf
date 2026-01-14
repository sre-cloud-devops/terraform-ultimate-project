variable "vpc_id" {
  default = "vpc-0123456789abcdef0"
}


variable "cluster_name" {
  description = "Cluster name"
  type = string
  default = "my-eks-cluster"
}
variable "cluster_version" {
  description = "EKS cluster version"
  type = string
  default = "1.24"
}


variable "subnet_ids" {
  description = "List of subnet IDs for the EKS cluster"
  type        = list(string)
  default = [ "subnet-0123456789abcdef0", "subnet-0fedcba9876543210" ]
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