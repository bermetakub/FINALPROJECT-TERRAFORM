terraform {
  backend "s3" {
    bucket = "terraform.tfstate-finalproject-bermet"
    key = "dev/terraform.tfstate" 
    region = "us-east-1" 
  }
}

locals {
  name = "Bermet"
}

module "networking" {
  source        = "../../modules/networking"
  public_cidrs  = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  private_cidrs = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
}

module "autoscaling" {
  source              = "../../modules/autoscaling"
  ami                 = data.aws_ami.Ubuntu.id
  instance_type       = "t2.micro"
  desired_size        = 2
  max_size            = 3
  min_size            = 1
  vpc_zone_Identifier = values(module.networking.private_subnets)
  target_group        = [module.alb.default_target_group_arn]
  vpcid               = module.networking.vpc_id
  ingress_ports       = [22, 80, 443]
}

# module "alb" {
#     source = "terraform-aws-modules/alb/aws"
#     name = "my-ALB"
#     vpc_id  = module.networking.vpc_id
#     subnets = module.networking.public_subnets
#     security_groups = module.autoscaling.security_group

# }

# 
module "alb" {
  source = "cloudposse/alb/aws"

  namespace = "${local.name}-my-alb"

  vpc_id                   = module.networking.vpc_id
  security_group_ids       = [module.autoscaling.security_group]
  subnet_ids               = values(module.networking.public_subnets)
  internal                 = false
  http_enabled             = true
  target_group_name        = "${local.name}-TG"
  target_group_port        = 80
  target_group_protocol    = "HTTP"
  target_group_target_type = "instance"
  access_logs_enabled      = false
  security_group_enabled   = false
}