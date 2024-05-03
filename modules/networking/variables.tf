variable "vpcCIDR" {
  description = "The IPv4 CIDR block for the VPC."
  type = string
  default = "10.0.0.0/16"
}

variable "name" {
    description = "Name to be used on all the resources as identifier"
    type = string
    default = "Bermet"
}

variable "public_cidrs" {
    description = "A list of public subnets inside the VPC"
    default = []
}

variable "private_cidrs" {
    description = "A list of private subnets inside the VPC"
    default = []
}

variable "tag" {
    description = "Tag for all resources"
    type = map(string)
    default = {
      "Name" = "Bermet"
    }
}
