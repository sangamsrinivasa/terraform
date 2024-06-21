variable "apac-vpc-cidr" {
   default = "192.168.0.0/24"
}

variable "apac_subnet1_cidr" {
  default = "192.168.0.0/26"
}

variable "apac_subnet2_cidr" {
  default = "192.168.0.64/26"
}

variable "apac_subnet3_cidr" {
  default = "192.168.0.128/26"
}

variable "apac_subnet4_cidr" {
  default = "192.168.0.192/26"
}



variable "nam-vpc-cidr" {
   default = "172.31.0.0/24"
}


variable "nam_subnet1_cidr" {
  default = "172.31.0.0/26"
}

variable "nam_subnet2_cidr" {
  default = "172.31.0.64/26"
}

variable "nam_subnet3_cidr" {
  default = "172.31.0.128/26"
}

variable "nam_subnet4_cidr" {
  default = "172.31.0.192/26"
}


variable "ami-id" {
  default = "ami-0fe630eb857a6ec83"
}

variable "instance_type" {
  default = "t2.micro"
}



