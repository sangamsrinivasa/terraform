provider "aws" {
   region = "us-east-1"
}

#----------
#Create VPC
#----------

resource "aws_vpc" "dev_vpc" {
  cidr_block = var.vpc-cidr
  enable_dns_hostnames = true
  tags = {
     Name = "AWS VPC for Dev"
  } 
}

resource "aws_security_group" "example" {
  name        = "dev-sg"
  description = "Dev security group"
  vpc_id      = aws_vpc.dev_vpc.id

  dynamic "ingress" {
    for_each = var.security_group_rules
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }
}

resource "aws_instance" "example" {
  count         = length(var.instances)
  ami           = var.instances[count.index].ami
  instance_type = var.instances[count.index].instance_type
  key_name      = var.instances[count.index].key_name
  subnet_id     = var.instances[count.index].subnet_id

  tags = var.instances[count.index].tags
}
