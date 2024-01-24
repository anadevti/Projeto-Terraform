resource "aws_security_group" "acesso-geral" {
    name = "acesso-geral"
    description = "grupo de Dev"
    ingress = { ##entrada
        cidr_blocks = ["0.0.0.0/"]
        ipv6_cidr_blocks = ["::/0"]
        from_port = 0
        to_port = 0
        protocol = "-1" ##-1 para todos os protocolos
    }
    egress = { ##saida
        cidr_blocks = ["0.0.0.0/"]
        ipv6_cidr_blocks = ["::/0"]
        from_port = 0
        to_port = 0
        protocol = "-1"
    }
    tags = {
      name = "Acesso Geral"
    }
}

##Config feita para grupo de Devs.