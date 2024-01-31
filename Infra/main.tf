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
  user_data = var.producao ? filebase64("ansible.sh"): "" # equivalente a um IF
}
# por exemplo:
# if(var.producao){
#   filebase64("ansible.sh")
# } else{
#   ""
# }

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
# resource "aws_autoscaling_schedule" "liga" {
#   scheduled_action_name  = "liga"
#   min_size               = 0
#   max_size               = 1
#   desired_capacity       = 1
#   start_time             = timeadd (timestamp(),"10m")
#   recurrence = "0 7 * * MON-FRI"
#   autoscaling_group_name = aws_autoscaling_group.grupo.name
# }

## Campo que seria usado para agendamento de ligar e desligar as maquinas, por algum motivo nao funcionou
## vou buscar uma solução, acredito que seja a versão do meu provider.

# resource "aws_autoscaling_schedule" "desliga" {
#   scheduled_action_name  = "desliga"
#   min_size               = 0
#   max_size               = 1
#   desired_capacity       = 0
#   start_time             = timeadd (timestamp(),"11m")
#   recurrence = "0 18 * * MON-FRI"
#   autoscaling_group_name = aws_autoscaling_group.grupo.name
# }


  target_group_arns = var.producao ? [aws_lb_target_group.alvoLoadBalancer[0].arn
  ] : []
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
  count = var.producao ? 1 : 0
}

resource "aws_lb_target_group" "alvoLoadBalancer" {
  name = "maquinasAlvo"
  port = "8000"
  protocol = "HTTP"
  vpc_id = aws_default_vpc.default.id
  count = var.producao ? 1 : 0
}

resource "aws_default_vpc" "default" {
  
}

resource "aws_lb_listener" "entradaLB" {
  load_balancer_arn = aws_lb.loadBalancer[0].arn
  port = "8000"
  protocol = "HTTP"
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.alvoLoadBalancer[0].arn
    }
    count = var.producao ? 1 : 0
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
  count = var.producao ? 1 : 0
}