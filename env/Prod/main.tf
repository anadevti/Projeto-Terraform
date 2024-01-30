module "aws-prod" {
  source = "../../Infra"
  instance = "t2.micro"
  region_aws = "us-west-2"
  chave = "iac-prod"
  security_group = "Producao"
  minimo = 1
  maximo = 3
  nomeGrupo = "Prod"
}

##output "IP" {
##  value = module.aws-prod.IP_Pub
##}