terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.33.0"
    }
  }

  required_version = ">= 1.0.7"
}

 provider "aws" {
  region  = var.region_aws
}

resource "aws_launch_template" "maquina" {
  image_id = "ami-03f65b8614a860c29"
  instance_type = var.instance
  key_name = var.chave
 ## user_data = "${file("init.sh")}"
 ## user_data_replace_on_change = true
  tags = {
    Name = "Terraform ansible com python"
  }
  security_group_names = [ var.security_group ]
  user_data = filebase64("ansible.sh")
}

resource "aws_key_pair" "CHAVESSH" {
  key_name = var.chave
  public_key = file ("${var.chave}")
}

##output "IP_Pub" { ## O terraform cospe pra mim o ip publico da ec2
##  value = aws_instance.app_server.public_ip
##}
resource "aws_autoscaling_group" "grupo" {
  availability_zones = ["${var.region_aws}a", "${var.region_aws}b"]
  name = var.nomeGrupo
  max_size = var.maximo
  min_size = var.minimo
  launch_template{
    id = aws_launch_template.maquina.id
    version = "$Latest"
  }
  target_group_arns = [aws_lb_target_group.alvoLoadBalancer.arn]
}

resource "aws_default_subnet" "subnet_1" {
  availability_zone = "${var.region_aws}a"
}

resource "aws_default_subnet" "subnet_2" {
  availability_zone = "${var.region_aws}b"
}

resource "aws_lb" "loadBalancer" {
  internal = false
  subnets = [ aws_default_subnet.subnet_1.id, aws_default_subnet.subnet_2 ]
}

resource "aws_lb_target_group" "alvoLoadBalancer" {
  name = "maquinasAlvo"
  port = "8000"
  protocol = "HTTP"
  vpc_id = aws_default_vpc.default.id
}

resource "aws_default_vpc" "default" {
  
}

resource "aws_lb_listener" "entradaLB" {
  load_balancer_arn = aws_lb.loadBalancer.arn
  port = "8000"
  protocol = "HTTP"
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.alvoLoadBalancer.arn
    }
}
resource "aws_autoscaling_policy" "escala-prod" {
  name = "terarform-escala"
  autoscaling_group_name = var.nomeGrupo
  policy_type = "TargetTrackingScaling"
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 50.0
  }
}