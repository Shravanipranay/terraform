variable "subnet_names" {
  type    = list(string)
  default = ["subnet1", "subnet2"]
}
variable "cidr_block" {
  type    = list(string)
  default = ["10.0.0.0/24", "10.0.1.0/24"]
}
variable "region" {
  type    = string
  default = "eu-west-3"
}
variable "subnet_azs" {
  type    = list(string)
  default = ["a", "b"]
}
