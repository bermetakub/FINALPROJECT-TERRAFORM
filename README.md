# Dev Environment

## Usage

```terraform
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
```

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.47.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_alb"></a> [alb](#module\_alb) | cloudposse/alb/aws | n/a |
| <a name="module_autoscaling"></a> [autoscaling](#module\_autoscaling) | ../../modules/autoscaling | n/a |
| <a name="module_networking"></a> [networking](#module\_networking) | ../../modules/networking | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_ami.Ubuntu](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_DNS"></a> [DNS](#output\_DNS) | The DNS name of the load balancer |

# Prod Environment

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.47.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.6.1 |

## Resources

| Name | Type |
|------|------|
| [aws_s3_bucket.static_site](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_ownership_controls.example](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_ownership_controls) | resource |
| [aws_s3_bucket_policy.static_site_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_public_access_block.example_public_access_block](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_object.errorobject](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_object) | resource |
| [aws_s3_object.object](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_object) | resource |
| [random_string.bucket_suffix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | n/a | `string` | `"us-east-1"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_website_url"></a> [website\_url](#output\_website\_url) | n/a |

