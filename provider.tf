terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0"
    }
  }
  required_version = "> 1.0.0"
}
provider "aws" {
  region = "eu-west-3"

}
module "aws_instance" {
  source = "./aws_vpc"
  region = "eu-west-3"
}