output "DNS" {
  description = "The DNS name of the load balancer"
  value       = try(module.alb.alb_dns_name, null)
}

output "subnet" {
  value = module.networking.private_subnets
}