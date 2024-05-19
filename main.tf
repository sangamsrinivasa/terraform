provider "aws" {
   region = "us-east-1"
}


# Create Multiple docker repos

variable "repo_names" {

  type = list
  default = ["webapp1", "webapp2"]
}


#Create private repositary for each application

resource "aws_ecr_repositary" {

  count = length(var.repo_names)
  name = var.repo_names[count.index]
  image_tag_mutability = "MUTABLE"

  image_scaning_configuration {
   scan_on_push = true
  }
}





