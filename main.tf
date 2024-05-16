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
     Name = "AWS VPC for Walmart Retail NorthAmerica"
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

#-----------------------
# Create Private Subnet
#-----------------------

resource "aws_subnet" "retail_private" {
    vpc_id = aws_vpc.retail_vpc.id
    cidr == var.subnet2_cidr
    availability_zone = data.aws_availability_zones.all.names[1]
    tags = {
        name = "Private subnet for Retail"
    }
}


#------------------------
# Create Internet gateway
#------------------------

resource "aws_internet_gateway" "retail_igw" {
   vpc_id = aws_vpc.retail_vpc.id
   tags = {
    name = "Retail InternetGateway"
   }
}


#-------------------------------
# Create Public Route table
#-------------------------------

resource "aws_route_table" "retail_public_route" {
   vpc_id = aws_vpc.retail_vpc.id

   route = {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.retail_igw.id
   }
   tags = {
      name = "Public route through IGW"
   }
}


#---------------------------
# Create private Route Table
#---------------------------

resource "aws_route_table" "retail_private_route" {
     vpc_id = aws_vpc.retail_vpc.id
     route = {
     cidr_block = "0.0.0.0/0"
     instance_id = aws_instance.uatServer.id
     }
}


#-----------------------------------------
# Assoicaite Public RouteTable with Subnet
#-----------------------------------------


resource "aws_route_table_assoiciation" "retail_east1_public" {
     subnet_id = aws_subnet.retail_public.id
     route_table_id = aws_route_table_retail_public_route.id

}


#-----------------------------------------
# Assoicate Private Routetable with Subnet
#-----------------------------------------

resource "aws_route_table_assoication" "retail_east1_private" {
    subnet_id = aws_subnet.retail_private.id
    route_table_id = aws_route_table_retail_private_route.id
}




#-----------------------
# Create security Group
#-----------------------


resource "aws_security_group" "retail_sg" {

   name = "retail_sg_1"
   vpc_id = aws_vpc.retail_vpc.id

   #Outbound Rule

   egress {

     from_port = 0
     to_port = 0
     protocal = -1
     cidr_blocks = ["0.0.0.0/0"]
   }

   #Inbound Rule
   ingress {
   
     from_port = 22
     to_port = 22
     protocal = "tcp"
     cidr_blocks = ["0.0.0.0/0"]
   }
}

#--------------------------
# Create SG for DB Server
#--------------------------

resource "aws_security_group" "retail_sg_db" {
    name = "retail_database_secgroup"
    egress {
     from_port = 0
     to_port = 0
     protocal = "-1"
     cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
      from_port = 3306
      to_port = 3306
      protocal = "tcp"
      security_groups = [aws_security_group.retail_sg.id]

}



resource "aws_instance" "devServer" {
    ami = var.amiid
    instance_type = var.type
    key_name = var.pemfile
    vpc_security_group_ids = [aws_security_group.retail_sg.id]
    subnet_id = aws_subnet.retail_public.id
    availability_zone = data.aws_availability_zone.all.names[0]
 
    assoiciate_public_ip_address = true

    user_data = <<-EOF
                   #!/bin/bash
		   touch /tmp/instance_creation.txt
		   EOF
    tags = {
       name = "Retail Dev Server"
    }
}

resource "aws_instance" "dbServer" {
   ami = var.amiid
   instance_type = var.type
   key_name = var.pemfile
   vpc_security_group_ids = [aws_security_group.retail_sg_db.id]
   subnet_id = aws_subnet.retail_private.id
   availability_zone = data.aws_availability_zone.all.names[1]

   associate_public_ip_address = true

   user_data = <<-EOF
   		 #!/bin/bash
		 touch /tmp/db_creation.txt
		 EOF

   tags = {
     name = "Retail DB Server"
   }
}

