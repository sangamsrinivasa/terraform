provider "aws" {
   region = "ap-south-1"
}

#Configuration of EC2 instance
resource "aws_instance" "demo_server" {
 ami = "ami-id"
 instance_type = "t2.micro"
}

#Configuration of S3 bucket
resource "aws_s3_bucket" "demo_bucket" {
   bucket = "Sample Bucket"
}
