resource "aws_launch_template" "launch_template" {
    name_prefix = var.name_prefix
    image_id = var.ami
    instance_type = var.instance_type
    vpc_security_group_ids = var.security_group != null ? [var.security_group] : [aws_security_group.sg.id]
    user_data = base64encode(<<EOF
#!/bin/bash
apt-get update
apt-get install apache2 -y
systemctl enable apache2
systemctl start apache2
echo "<h1>Hello World from $HOSTNAME</h1>" > /var/www/html/index.html
EOF
)
}


resource "aws_autoscaling_group" "asg" {
    name = var.name
    desired_capacity = var.desired_size
    max_size = var.max_size
    min_size = var.min_size
    health_check_grace_period = 300

    vpc_zone_identifier = var.vpc_zone_Identifier
    target_group_arns = var.target_group

    launch_template {
        id = aws_launch_template.launch_template.id
        version = "$Latest"
  }
}

resource "aws_security_group" "sg" {
  vpc_id = var.vpcid
  dynamic "ingress" {
    for_each = toset(var.ingress_ports)
    content {
      to_port     = ingress.key
      from_port   = ingress.key
      cidr_blocks = ["0.0.0.0/0"]
      protocol    = "tcp"
    }
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

    egress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}