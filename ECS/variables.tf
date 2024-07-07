
variable "vpc-cidr" {
   default = "172.31.0.0/16"
}

variable "subnet1_cidr" {
  default = "172.31.0.0/18"
}

variable "image" {
  default = "nginx:httpd"
}

variable "cont_name" {
  default = "webapp"
}

variable "type" {
  default = "t2.micro"
}

