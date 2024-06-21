
# Define the AWS provider for Asia & NorthAmerica regions
provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"
}

provider "aws" {
  alias  = "ap_south_1"
  region = "ap-south-1"
}

# Create VPC in us-east-1
resource "aws_vpc" "vpc_nam" {
  provider = aws.us_east_1
  cidr_block = var.nam-vpc-cidr

  tags = {
    Name = "nam_vpc"
  }
}

# Create VPC in asia
resource "aws_vpc" "vpc_asia" {
  provider = aws.ap_south_1
  cidr_block = var.apac-vpc-cidr

  tags = {
    Name = "apac_vpc"
  }
}


# Create public subnets in Asia VPC
resource "aws_subnet" "asia_pub_subnet_1a" {
  vpc_id            = aws_vpc.vpc_asia.id
  cidr_block        = var.apac_subnet1_cidr
  availability_zone = "ap-south-1a"

  tags = {
    Name = "apac-pub-subnet-1a"
  }
}


# Create private subnets in Asia VPC
resource "aws_subnet" "asia_prv_subnet_1a" {
  vpc_id            = aws_vpc.vpc_asia.id
  cidr_block        = var.apac_subnet2_cidr
  availability_zone = "ap-south-1a"

  tags = {
    Name = "apac-prv-subnet-1a"
  }
}

resource "aws_subnet" "asia_prv_subnet_1b" {
  vpc_id            = aws_vpc.vpc_asia.id
  cidr_block        = var.apac_subnet3_cidr
  availability_zone = "ap-south-1b"

  tags = {
    Name = "apac-prv-subnet-1b"
  }
}

# Create public subnets in NAM VPC
resource "aws_subnet" "nam_pub_subnet_1a" {
  vpc_id            = aws_vpc.vpc_nam.id
  cidr_block        = var.nam_subnet1_cidr
  availability_zone = "us-east-1a"

  tags = {
    Name = "us-pub-subnet-1a"
  }
}

# Create a subnets in NAM VPC
resource "aws_subnet" "nam_prv_subnet_1a" {
  vpc_id            = aws_vpc.vpc_nam.id
  cidr_block        = var.nam_subnet2_cidr
  availability_zone = "us-east-1a"

  tags = {
    Name = "us-subnet-1a"
  }
}

resource "aws_subnet" "nam_prv_subnet_1b" {
  vpc_id            = aws_vpc.vpc_nam.id
  cidr_block        = var.nam_subnet3_cidr
  availability_zone = "us-east-1b"

  tags = {
    Name = "us-subnet-1b"
  }
}

resource "aws_internet_gateway" "apac_igw" {
   vpc_id = aws_vpc.vpc_asia.id
   tags = {
    name = "Asia_IGW"
   }
}

resource "aws_internet_gateway" "nam_igw" {
   vpc_id = aws_vpc.vpc_nam.id
   tags = {
    name = "NAM_IGW"
   }
}

# Create an Elastic IP for the Asia NAT Gateway
resource "aws_eip" "asia_nat_eip" {
  vpc = aws_vpc.vpc_asia

  tags = {
    Name = "asia-nat-eip"
  }
}

# Create the Asia NAT Gateway
resource "aws_nat_gateway" "asia_nat_gw" {
  allocation_id = aws_eip.asia_nat_eip.id
  subnet_id     = aws_subnet.asia_pub_subnet_1a.id

  tags = {
    Name = "asia-nat-gateway"
 
  }
}

# Create an Elastic IP for the NAM NAT Gateway
resource "aws_eip" "nam_nat_eip" {
  vpc = aws_vpc.vpc_nam

  tags = {
    Name = "nam-nat-eip"
  }
}

# Create the Northamerica - NAM NAT Gateway
resource "aws_nat_gateway" "nam_nat_gw" {
  allocation_id = aws_eip.nam_nat_eip.id
  subnet_id     = aws_subnet.nam_pub_subnet_1a.id

  tags = {
    Name = "nam-nat-gateway"
  }
}

# Create a route table for the public subnet
resource "aws_route_table" "asia_public_rt" {
  vpc_id = aws_vpc.vpc_asia.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.apac_igw.id
  }

  tags = {
    Name = "asia-public-route-table"
  }
}

# Associate the route table with the public subnet
resource "aws_route_table_association" "asia_public_rt_association" {
  subnet_id      = aws_subnet.asia_pub_subnet_1a.id
  route_table_id = aws_route_table.asia_public_rt.id
}


# Create a route table for the private subnet
resource "aws_route_table" "asia_private_rt" {
  vpc_id = aws_vpc.asia_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.asia_nat_gw.id
  }

  tags = {
    Name = "asia-private-route-table"
  }
}

# Associate the route table with the private subnet
resource "aws_route_table_association" "asia_private_1a_rt_association" {
  subnet_id      = aws_subnet.asia_prv_subnet_1a.id
  route_table_id = aws_route_table.asia_private_rt.id
}

resource "aws_route_table_association" "asia_private_1b_rt_association" {
  subnet_id      = aws_subnet.asia_prv_subnet_1b.id
  route_table_id = aws_route_table.asia_private_rt.id
}


# Create a route table for the public subnet
resource "aws_route_table" "nam_public_rt" {
  vpc_id = aws_vpc.vpc_nam.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.nam_igw.id
  }

  tags = {
    Name = "nam-public-route-table"
  }
}

# Associate the route table with the public subnet
resource "aws_route_table_association" "nam_public_rt_association" {
  subnet_id      = aws_subnet.nam_pub_subnet_1a.id
  route_table_id = aws_route_table.nam_public_rt.id
}


# Create a route table for the private subnet
resource "aws_route_table" "nam_private_rt" {
  vpc_id = aws_vpc.nam_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nam_nat_gw.id
  }

  tags = {
    Name = "nam-private-route-table"
  }
}

# Associate the route table with the private subnets
resource "aws_route_table_association" "nam_private_1a_rt_association" {
  subnet_id      = aws_subnet.nam_prv_subnet_1a.id
  route_table_id = aws_route_table.nam_private_rt.id
}

resource "aws_route_table_association" "nam_private_1b_rt_association" {
  subnet_id      = aws_subnet.nam_prv_subnet_1b.id
  route_table_id = aws_route_table.nam_private_rt.id
}


resource "aws_security_group" "nam_sg" {

   name = "nam_sg"
   vpc_id = aws_vpc.vpc_nam.id

   #Outbound Rule

   egress {

     from_port = 0
     to_port = 0
     protocol = -1
     cidr_blocks = ["0.0.0.0/0"]
   }

   #Inbound Rule
   ingress {
   
     from_port = 80
     to_port = 80
     protocol = "tcp"
     cidr_blocks = ["0.0.0.0/0"]
   }

   ingress {
   
     from_port = 22
     to_port = 22
     protocol = "ssh"
     cidr_blocks = ["0.0.0.0/0"]
   }

   ingress {
   
     from_port = 8080
     to_port = 8080
     protocol = "tcp"
     cidr_blocks = ["0.0.0.0/0"]
   }

}

resource "aws_security_group" "asia_sg" {

   name = "asia_sg"
   vpc_id = aws_vpc.vpc_asia.id

   #Outbound Rule

   egress {

     from_port = 0
     to_port = 0
     protocol = -1
     cidr_blocks = ["0.0.0.0/0"]
   }

   #Inbound Rule
   ingress {

     from_port = 80
     to_port = 80
     protocol = "tcp"
     cidr_blocks = ["0.0.0.0/0"]
   }

   ingress {

     from_port = 22
     to_port = 22
     protocol = "ssh"
     cidr_blocks = ["0.0.0.0/0"]
   }

   ingress {

     from_port = 8080
     to_port = 8080
     protocol = "tcp"
     cidr_blocks = ["0.0.0.0/0"]
   }

}

resource "aws_instance" "NAM_Tomcat_instance_1a" {
    ami = var.ami-id
    instance_type = var.type
    vpc_security_group_ids = [aws_security_group.nam_sg.id]
    subnet_id = aws_subnet.nam_prv_subnet_1a.id
    availability_zone = "us-east-1a"
 
    associate_public_ip_address = true

    user_data = <<-EOF
                   #!/bin/bash
		   # Update the package repository
		   sudo yum update -y
		   # Install required packages
		   sudo yum install -y yum-utils device-mapper-persistent-data lvm2
		   # Add the Docker repository
		   sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
		   # Install Docker
		   sudo yum install -y docker-ce docker-ce-cli containerd.io
		   # Start Docker
		   sudo systemctl start docker
		   # Enable Docker to start on boot
		   sudo systemctl enable docker
		   # Add the ec2-user to the docker group to allow running docker commands without sudo
		   sudo usermod -aG docker ec2-user
		   EOF
    tags = {
       name = "Tomcat_Server_1a"
    }
}

resource "aws_instance" "NAM_Tomcat_instance_1b" {
    ami = var.ami-id
    instance_type = var.type
    vpc_security_group_ids = [aws_security_group.nam_sg.id]
    subnet_id = aws_subnet.nam_prv_subnet_1b.id
    availability_zone = "us-east-1b"
 
    associate_public_ip_address = true

    user_data = <<-EOF
                   #!/bin/bash
		   # Update the package repository
		   sudo yum update -y
		   # Install required packages
		   sudo yum install -y yum-utils device-mapper-persistent-data lvm2
		   # Add the Docker repository
		   sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
		   # Install Docker
		   sudo yum install -y docker-ce docker-ce-cli containerd.io
		   # Start Docker
		   sudo systemctl start docker
		   # Enable Docker to start on boot
		   sudo systemctl enable docker
		   # Add the ec2-user to the docker group to allow running docker commands without sudo
		   sudo usermod -aG docker ec2-user
		   EOF
    tags = {
       name = "Tomcat_Server_1b"
    }
}

resource "aws_instance" "Asia_Tomcat_instance_1a" {
    ami = var.ami-id
    instance_type = var.type
    vpc_security_group_ids = [aws_security_group.asia_sg.id]
    subnet_id = aws_subnet.asia_prv_subnet_1a.id
    availability_zone = "ap-south-1a"
 
    associate_public_ip_address = true

    user_data = <<-EOF
                   #!/bin/bash
		   # Update the package repository
		   sudo yum update -y
		   # Install required packages
		   sudo yum install -y yum-utils device-mapper-persistent-data lvm2
		   # Add the Docker repository
		   sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
		   # Install Docker
		   sudo yum install -y docker-ce docker-ce-cli containerd.io
		   # Start Docker
		   sudo systemctl start docker
		   # Enable Docker to start on boot
		   sudo systemctl enable docker
		   # Add the ec2-user to the docker group to allow running docker commands without sudo
		   sudo usermod -aG docker ec2-user
		   EOF
    tags = {
       name = "Tomcat_Server_1a"
    }
}

resource "aws_instance" "Asia_Tomcat_instance_1b" {
    ami = var.ami-id
    instance_type = var.type
    vpc_security_group_ids = [aws_security_group.asia_sg.id]
    subnet_id = aws_subnet.asia_prv_subnet_1b.id
    availability_zone = "ap-south-1b"
 
    associate_public_ip_address = true

    user_data = <<-EOF
                   #!/bin/bash
		   # Update the package repository
		   sudo yum update -y
		   # Install required packages
		   sudo yum install -y yum-utils device-mapper-persistent-data lvm2
		   # Add the Docker repository
		   sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
		   # Install Docker
		   sudo yum install -y docker-ce docker-ce-cli containerd.io
		   # Start Docker
		   sudo systemctl start docker
		   # Enable Docker to start on boot
		   sudo systemctl enable docker
		   # Add the ec2-user to the docker group to allow running docker commands without sudo
		   sudo usermod -aG docker ec2-user
		   EOF
    tags = {
       name = "Tomcat_Server_1b"
    }
}

module "ec2-instance" {

  source = "../modules/module/ec2-instance/main.tf"
  ami = var.ami-id
  subnet_id = aws.subnet_id
  az = var.az

}


resource "aws_security_group" "nam_lb_sg" {
  vpc_id = aws_vpc.nam_vpc.id
  ingress {
    from_port = 80
    to_port = 80
    protocal = "http"
    cidr_blocks = ["0.0.0.0/0"]
  }  
  egress {
    from_port = 0
    to_port = 0
    protocal = -1
    cidr_block = ["0.0.0.0/0"]
  }  
}

resource "aws_lb" "nam_lb" {
   name = "NAM_Load_Balancer"
   vpc_id = aws_vpc.nam_vpc.id
   subnet_ids = [subnet1, subnet2]
   internal_facing = false  --> mistake 1
   security_group = lb_sg.id
   load_balancer_type = "application"  
   enable_deletion_protection = true    

}

resource "aws_lb_target_group" "nam_tg" { 
   name = "name"  --> mistake 5
   vpc_id = aws_vpc.nam_vpc.id
   protocal = "http"
   port = 80
   health_check {
      path = "/"
      healthy_threshold = 3
      unhealthy_threshold = 3
      matcher = "200-299"
      interval = 30
      time_out = 5
   }
}

resource "aws_lb_listner" "nam_listner" {

  protocal = "http"
  port = 80
  load_balancer_arn = aws_lb.nam_lb.arn
  default_action {
     type = "forward"
     target_group_arn= aws_target_group.nam_tg.arn
  }
}


resource "aws_lb_target_group_attachment" "nam_target_association" {
  target_group_arn = aws_target_group.nam_tg.arn
  instance_id = "instane_id"
  port = 80
}


# Create a launch configuration
resource "aws_launch_configuration" "nam_ec2_launchconfig" {
  name          = "nam-ec2-launch-configuration"
  image_id      = var.ami-id 
  instance_type = var.type
  security_groups = [aws_security_group.web_sg.id]
  
  lifecycle {
    create_before_destroy = true
  }

}

# Create an Auto Scaling Group
resource "aws_autoscaling_group" "nam_asg" {
  launch_configuration = aws_launch_configuration.nam_ec2_launchconfig.id
  min_size             = 1
  max_size             = 3
  desired_capacity     = 2
  vpc_zone_identifier  = [aws_subnet.subnet1.id, aws_subnet.subnet2.id]

  target_group_arns = [aws_lb.web_elb.arn]

  tag {
    key                 = "Name"
    value               = "web-asg-instance"
    propagate_at_launch = true
  }
}

# Create an Auto Scaling policy to scale out
resource "aws_autoscaling_policy" "nam_scale_out" {
  name                   = "scale-out"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.nam_asg.name
}

# Create an Auto Scaling policy to scale in
resource "aws_autoscaling_policy" "nam_scale_in" {
  name                   = "scale-in"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.nam_asg.name
}


resource "aws_cloudwatch_metric_alarm" "high_cpu_alarm" {
  alarm_name          = "high-cpu"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = 70
  alarm_actions       = [aws_autoscaling_policy.scale_up.arn]
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.example.name
  }
}
