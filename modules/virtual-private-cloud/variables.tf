variable "vpc_cidr" {
  description = "Provide the VPC CIDR Block"
  type        = string
  default     = "192.168.0.0/16"
}

variable "public_subnet_cidr" {
  description = "Public Subnet CIDR Block"
  type        = list(string)
  default     = ["192.168.1.0/24", "192.168.2.0/24", "192.168.3.0/24"]
}

variable "public_subnet_AZs" {
  description = "AZs for Public Subnet to be created"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "private_subnet_cidr" {
  description = "Private Subnet CIDR Block"
  type        = list(string)
  default     = ["192.168.4.0/24", "192.168.5.0/24", "192.168.6.0/24"]
}

variable "private_subnet_AZs" {
  description = "AZs for Private Subnet to be created"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "public_route_table_routes" {
  description = "Routes for Public Route Table"
  type        = string
  default     = "0.0.0.0/0"
}


variable "private_route_table_routes" {
  description = "Routes for Private Route Table"
  type        = string
  default     = "0.0.0.0/0"
}
