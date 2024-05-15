provider "aws" {
   region = "us-east-1"
}

#----------
#Create VPC
#----------

resource "aws_vpc" "retail_vpc" {
  cidr = var.cidr
  enable_dns_hostnames = true
  tags = {
     Name = "AWS VPC for Retail NorthAmerica"
  } 
}


#-------------------------
# Get list of AZ in region
#-------------------------

data "aws_availability_zones" "all" {}

#--------------------
#Create Public Subnet
#--------------------

resource "aws_subnet" "retail_public" {

  vpc_id = aws_vpc.retail_vpc.id
  cidr = var.subnet1_cidr
  availability_zone = data.aws_availability_zones.all.names[0]
  tags = {
    name = "Public subnet for Retail"
  }
}

resource "aws_internet_gateway" "retail_igw" {
   vpc_id = aws_vpc.aws.id
   tags = {
    name = "Retail InternetGateway"
   }
}









