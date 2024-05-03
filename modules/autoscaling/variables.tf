variable "name" {
  description = "Name to be used on all the resources as identifier"
  type        = string
  default     = "Bermet"
}

variable "name_prefix" {
  description = "Determines whether to use `launch_template_name` as is or create a unique name beginning with the `launch_template_name` as the prefix"
  type        = bool
  default     = true
}

variable "ami" {
  description = "The AMI from which to launch the instance"
  type        = string
  default     = "ami-07caf09b362be10b8"
}

variable "instance_type" {
  description = "The type of the instance"
  type        = string
  default     = "t3.micro"
}

variable "desired_size" {
  description = "The number of Amazon EC2 instances that should be running in the autoscaling group"
  type        = number
  default     = null
}

variable "min_size" {
  description = "The minimum size of the autoscaling group"
  type        = number
  default     = null
}

variable "max_size" {
  description = "The maximum size of the autoscaling group"
  type        = number
  default     = null
}

variable "vpc_zone_Identifier" {
  description = "A list of subnet IDs to launch resources in. Subnets automatically determine which availability zones the group will reside. Conflicts with `availability_zones`"
  default     = []
}

variable "security_group" {
  description = "A list of security group IDs to associate with"
  default     = null
}

variable "target_group" {
  description = "A set of `aws_alb_target_group` ARNs, for use with Application or Network Load Balancing"
  type        = list(string)
  default     = []
}

variable "vpcid" {
  description = "ID of VPC where security group should be created"
  type        = string
  default     = null
}

variable "ingress_ports" {
  description = "The specified ports will be allowed"
  type        = list(string)
  default     = []

}