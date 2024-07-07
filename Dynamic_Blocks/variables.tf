variable "vpc-cidr" {
   default = "172.31.0.0/16"
}

variable "security_group_rules" {
  type = list(object({
    type        = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = [
    {
      type        = "ingress"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      type        = "ingress"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}

variable "instances" {
  type = list(object({
    ami           = string
    instance_type = string
    key_name      = string
    subnet_id     = string
    tags          = map(string)
  }))
  default = [
    {
      ami           = "ami-12345678"
      instance_type = "t2.micro"
      key_name      = "my-key"
      subnet_id     = "subnet-12345678"
      tags          = { Name = "Instance1" }
    },
    {
      ami           = "ami-87654321"
      instance_type = "t2.small"
      key_name      = "my-key"
      subnet_id     = "subnet-87654321"
      tags          = { Name = "Instance2" }
    }
  ]
}

