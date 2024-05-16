
provider "aws" {
   region = "us-east-1"
}


# Iam policy creation
 module "IamPolicyDev" {
   source = "../IamPolicyDev"
 }

 module "IamPolicyQA" {
    source = "../IamPolicyQA"
 }


# Creating IAM User
  resource "aws_iam_user" "demo" {
    name = var.name
    path = var.path
    force_destory = var.force_destory
    tags = {
     "testuser" = var.name
    }
  }







 
