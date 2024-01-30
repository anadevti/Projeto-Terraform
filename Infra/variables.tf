variable "region_aws" {
  type = string
}
variable "chave" {
  type = string
}
variable "instance" {
    type = string  
}
variable "security_group" {
  type = string
}
variable "minimo" {
  type = number
}

variable "maximo" {
  type = number
}

variable "nomeGrupo" {
  type = string
}
## Variaveis sendo declaradas em infra, para serem atribuidas em
## ambiente Dev ou Prod!