module "aws-dev" {
  source = "../../Infra"
  instance = "t2.micro"
  region_aws = "us-west-2"
  chave = "iac-dev"
}

output "IP" {
  value = module.aws-dev.IP_Pub
}