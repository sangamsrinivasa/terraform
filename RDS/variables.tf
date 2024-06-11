
# Define variables
variable "instance_type" {
  default = "t2.micro"
}

variable "ami" {
  default = "ami-0c55b159cbfafe1f0"  # Change to your desired AMI ID
}

variable "key_name" {
  default = "your-key-pair"  # Change to your SSH key pair name
}
