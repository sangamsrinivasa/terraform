
provider "aws" {
   region = "us-east-1"
}

#Creating Policy statement to be used for IAM

data "aws_iam_policy_document" "demoqa" {

   #READ Only Access
   statement {
       effect = "Allow"
       actions = ["elasticbeanstalk:Check*",
                  "elasticbeanstalk:Describe*",
		  "elasticbeanstalk:List*",
		  "elasticbeanstalk:RequentEnvironmentInfo",
		  "elasticbeanstalk:RetriveEnvironmentInfo",
		  "ec2:Describe*",
		  "elasticloadbalancing:Describe*",
		  "autoscaling:Describe*",
		  "cloudwatch:Describe*",
		  "cloudwatch:List*",
		  "cloudwatch:Get*",
		  "s3:Get*",
		  "s3:List*",
		  "sns:Get*",
		  "sns:List*",
		  "rds:Describe",
		  "cloudformation:Describe*",
		  "cloudformation:List*",
		  "cloudformation:Get*",
		  "cloudformation:Validate*",
		  "cloudformation:Estimate*"
                 ]

      resources = ["*"]
   }
}


#Creating IAM Policy

  resource "aws_iam_policy" "qa" {
   name = "qa_policy"
   path = "/"
   policy = data.aws_iam_policy_document.demoqa.json
  }


