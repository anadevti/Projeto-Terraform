module "aws-dev" {
  source = "../../Infra"
  instance = "t2.micro"
  region_aws = "us-west-2"
  chave = "iac-dev"
  security_group = "DEV"
  minimo = 0
  maximo = 1
  nomeGrupo = "DEV"
  producao = false
}