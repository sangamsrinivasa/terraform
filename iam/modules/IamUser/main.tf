
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
  resource "aws_iam_user" "retail_user" {
    name = var.name
    path = var.path
    force_destory = var.force_destory
    tags = {
     "testuser" = var.name
    }
  }


# Create IAM access key

  resource "aws_iam_access_key" "retail_access_key" {
    user = aws_iam_user.retail_user.name
  }

# Attach Policy to user 

  resource "aws_iam_user_policy" "retail_user_policy" {
    user = aws_iam_user.retail_user.name
    policy = var.devuser ? module.IamPolicydev.policy : module.IamPolicyQA.policy
  }



 
