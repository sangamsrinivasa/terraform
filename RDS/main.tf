# Define provider
provider "aws" {
  region = "us-west-2"  # Change to your desired region
}


# Create security group allowing SSH and Oracle SQL ports
resource "aws_security_group" "instance_sg" {
  name        = "instance_sg"
  description = "Security group for EC2 instance"
  
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Adjust these ports based on your Oracle SQL requirements
  ingress {
    from_port   = 1521  # Oracle SQL default port
    to_port     = 1521
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create EC2 instance
resource "aws_instance" "example" {
  ami           = var.ami
  instance_type = var.instance_type
  key_name      = var.key_name

  security_groups = [aws_security_group.instance_sg.name]

  tags = {
    Name = "example-instance"
  }
}

# Provision script to install Oracle SQL (replace with your actual installation script)
provisioner "remote-exec" {
  inline = [
    "sudo yum -y install oracle-database-client-19c"  # Install Oracle SQL client (example command)
  ]

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("~/.ssh/your-key-pair.pem")  # Path to your SSH private key
    host        = aws_instance.example.public_ip
  }
}

