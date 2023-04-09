region = "eu-west-3"
vpc_info = {
  subnet_names    = ["subnet1", "subnet2"]
  cidr_block      = ["10.0.0.0/24", "10.0.1.0/24"]
  subnet_azs      = ["a", "b"]
  public_subnets  = ["10.0.0.0/24"]
  private_subnets = ["10.0.1.0/24"]

}
