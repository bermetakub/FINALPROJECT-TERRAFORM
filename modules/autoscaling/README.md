## This module will create:
- _AutoScaling Group_
- _Launch Template_
- _Security Group_

## Usage

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

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.0 |


## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_autoscaling_group.asg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group) | resource |
| [aws_launch_template.launch_template](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template) | resource |
| [aws_security_group.sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ami"></a> [ami](#input\_ami) | The AMI from which to launch the instance | `string` | `"ami-07caf09b362be10b8"` | no |
| <a name="input_desired_size"></a> [desired\_size](#input\_desired\_size) | The number of Amazon EC2 instances that should be running in the autoscaling group | `number` | `null` | no |
| <a name="input_ingress_ports"></a> [ingress\_ports](#input\_ingress\_ports) | The specified ports will be allowed | `list(string)` | `[]` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | The type of the instance | `string` | `"t3.micro"` | no |
| <a name="input_max_size"></a> [max\_size](#input\_max\_size) | The maximum size of the autoscaling group | `number` | `null` | no |
| <a name="input_min_size"></a> [min\_size](#input\_min\_size) | The minimum size of the autoscaling group | `number` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | Name to be used on all the resources as identifier | `string` | `"Bermet"` | no |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | Determines whether to use `launch_template_name` as is or create a unique name beginning with the `launch_template_name` as the prefix | `bool` | `true` | no |
| <a name="input_security_group"></a> [security\_group](#input\_security\_group) | A list of security group IDs to associate with | `any` | `null` | no |
| <a name="input_target_group"></a> [target\_group](#input\_target\_group) | A set of `aws_alb_target_group` ARNs, for use with Application or Network Load Balancing | `list(string)` | `[]` | no |
| <a name="input_vpc_zone_Identifier"></a> [vpc\_zone\_Identifier](#input\_vpc\_zone\_Identifier) | A list of subnet IDs to launch resources in. Subnets automatically determine which availability zones the group will reside. Conflicts with `availability_zones` | `list` | `[]` | no |
| <a name="input_vpcid"></a> [vpcid](#input\_vpcid) | ID of VPC where security group should be created | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_security_group"></a> [security\_group](#output\_security\_group) | Security Group ID |
