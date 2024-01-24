module "aws-prod" {
  source = "../../Infra"
  instance = "t2.micro"
  region_aws = "us-west-2"
  chave = "iac-prod"
}

output "IP" {
  value = module.aws-prod.IP_Pub
}