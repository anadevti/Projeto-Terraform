resource "aws_security_group" "acesso-geral" {
  ingress = [
    {
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      from_port        = 0
      to_port          = 9090
      protocol         = "-1"  # -1 para todos os protocolos
      description      = "Regra de ingresso para a porta 9090"  # Descrição opcional
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]

  egress = [
    {
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      from_port        = 0
      to_port          = 9090
      protocol         = "-1"  # -1 para todos os protocolos
      description      = "Regra de egresso para a porta 9090"  # Descrição opcional
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]

  # Outras configurações do security group...
}