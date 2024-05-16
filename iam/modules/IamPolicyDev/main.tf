
provider "aws" {
   region = "us-east-1"
}

#Creating Policy statement to be used for IAM

data "aws_iam_policy_document" "demo" {

   #- List of Resources that are not allowed to access -#
   statement {
       effect = "Deny"
       actions = ["elasticbeanstalk:Createenvironment",
                  "elasticbeanstalk:RebuiltEnvironment",
                  "elasticbeanstalk:TerminateEnvironment"
                 ]
       resources = ["*"]
   }
  
   #- List of resources that are allowed to access -#
   statement {
      effect = "Allow"
      actions = ["ec2:RunInstances"]
      # Here allowing user to perform action on ec2 instance in only one subnet
      resources = [
                  "arn:aws:ec2:us-east-1:AWSAccnt:instance/*",
                  "arn:aws:ec2:us-east-1:AWSAccnt:subnet/subnet-id"
                  ]

      condition {
           test = "StringEquals"
         variable = "ec2:InstanceType"
         values - ["t2.micro", "t2.small"]
      }
   }
}

#Creating IAM Policy

  resource "aws_iam_policy" "dev" {
   name = "dev_policy"
   path = "/"
   policy = data.aws_iam_policy_document.demo.json
  }


