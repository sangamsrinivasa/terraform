provider "aws" {
   region = "us-east-1"
}

#Extract all AZ in the AWS Region
data "aws_availability_zones" "all" {}


#Securty group for ELB

resource "aws_security_group" "retail_sg_elb" {
   name = "Retail SG ELB"
   egress {
   from_port = 0
   to_port = 0
   protocal = "-1"
   cidr_block = ["0.0.0.0/0"]
   }

   ingress {
     from_port = var.elb_port
     to_port = var.elb_port
     protocal = "http"
     cidr_block = ["0.0.0.0/0"]
   }
}

#Security Group for AppServers


resource "aws_security_group" "retail_sg_appsrv" {
   name = "Retail SG AppServer"
   
   #Inbound from anywhere
   ingress  {
    from_port = var.appsrv_port
    to_port = var.appsrv_port
    protocal = "tcp"
    cidr_block = ["0.0.0.0/0"]
   }
}


#Application Load balancer to route trafic across auto scaling group

resource "aws_elb" "retail_elb" {
   name = "ELB-RETAIL"
   security_groups = [aws_security_group.retail_sg_elb.id]
   availability_zones = data.aws_availability_zones.all.names

   health_check {
      target = "HTTP:${var.appsrv_port}/"
      interval = 30
      timeout = 3
      healthy_threshold = 3
      unhealthy_threshold = 3
   }

   #Listenr for requests
   listener {
     lb_port = var.elb_port
     lb_protocal = "http"
     instance_port = var.appsrv_port
     instance_protocal = "http"
   }
}


#Launch configuration for Auto Scaling Group

resource "aws_launch_configuration" "retail_launch_config" {

   name = " Retail AppServer Config"
   image_id = "ami-0fe630eb857a6ec83"
   instance_type = "t2.micro"
   security_groups = [aws_security_group.retail_sg_appsrv.id]

   user_data = <<-EOF
    	       #!/bin/bash
	       touch /tmp/instance_creation.txt
	       echo "Instance created at ${date}" >> /tmp/instance_creation.txt
	       EOF

   #When using launch configuration with in ASG, please set below details
   lifecycle {
     create_before_destroy = true
   }
}

resource "aws_autoscaling_group" "retail_asg" {

   name = "Retail AutoScaling group"
   launch_configuration = aws_launch_configuration.retail_launch_config.id
   availability_zones = data.aws_availability_zones.all.names

# Minimum and Maxium server for ASG
   min_size = 2
   max_size = 10

   load_balancers = [aws_elb.retail_elb.name]
   health_check_type = "ELB"

   tag {
     key = "Name"
     value = "Walmart Retail"
     propagate_at_launch = true
   }
}
























