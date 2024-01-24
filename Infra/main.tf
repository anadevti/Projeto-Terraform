terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region  = var.region_aws
}

resource "aws_instance" "app_server" {
  ami = "ami-03f65b8614a860c29"
  instance_type = var.instance
  key_name = var.chave
 ## user_data = "${file("init.sh")}"
 ## user_data_replace_on_change = true
  tags = {
    Name = "Terraform ansible com python"
  }
}

resource "aws_key_pair" "CHAVESSH" {
  key_name = var.chave
  public_key = file ("${var.chave}")
}

output "IP_Pub" { ## O terraform cospe pra mim o ip publico da ec2
  value = aws_instance.app_server.public_ip
}