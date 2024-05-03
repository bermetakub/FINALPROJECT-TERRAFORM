output "security_group" {
  description = "Security Group ID"
  value       = aws_security_group.sg.id
}