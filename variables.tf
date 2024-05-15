variable "vpc-cidr" {
   default = "172.31.0.0/16"
}

variable "subnet1" {
  default = "172.31.0.0/18"
}

variable "subnet2" {
  default = "172.31.64.0/18"
}

variable "ami-id" {
  default = "ami-0fe630eb857a6ec83"
}

variable "type" {
  default = "t2.micro"
}

variable "pemfile" {
  default = "citi"
}
