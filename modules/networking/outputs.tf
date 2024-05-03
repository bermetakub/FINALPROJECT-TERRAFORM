output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = { for i, v in aws_subnet.public_subnet : i => v.id }
}

output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = { for i, v in aws_subnet.private_subnet : i => v.id }
}

output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.vpc.id
}