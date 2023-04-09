resource "aws_vpc" "vpc1" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "ec2vpc"
  }
}
resource "aws_subnet" "subnets" {
  count             = length(var.subnet_names)
  cidr_block        = var.cidr_block[count.index]
  availability_zone = "${var.region}${var.subnet_azs[count.index]}"
  vpc_id            = aws_vpc.vpc1.id
  depends_on = [
    aws_vpc.vpc1
  ]
  tags = {
    Name = var.subnet_names[count.index]
  }

}
resource "aws_internet_gateway" "ntier_igw" {
  vpc_id = aws_vpc.vpc1.id
  tags = {
    Name = "ntier-igw"
  }
  depends_on = [
    aws_vpc.vpc1
  ]
}
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc1.id
  tags = {
    Name = "private"
  }
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ntier_igw.id
  }
  depends_on = [
    aws_subnet.subnets
  ]
}

resource "aws_route_table_association" "private_associations" {
  route_table_id = aws_route_table.private.id
  subnet_id      = aws_subnet.subnets[0].id

}
resource "aws_security_group" "sg" {
  name = "ssh"
  ingress {
    from_port   = local.ssh_port
    to_port     = local.ssh_port
    cidr_blocks = [local.anywhere]
    protocol    = local.tcp

  }
  ingress {
    from_port   = local.http_port
    to_port     = local.http_port
    cidr_blocks = [local.anywhere]
    protocol    = local.tcp

  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [local.anywhere]
  }
  tags = {
    Name = "web"
  }
  vpc_id = aws_vpc.vpc1.id

  depends_on = [
    aws_subnet.subnets
  ]
}


resource "aws_instance" "myinstance" {
  for_each = var.any
  ami                         = "ami-05e8e219ac7e82eba"
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  key_name                    = "always"
  subnet_id                   = aws_subnet.subnets[0].id
  vpc_security_group_ids      = [aws_security_group.sg.id]
  tags = {
    Name = "${each.value.Name}"
  }
}



