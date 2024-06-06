
provider "aws" {
   region = "us-east-1"
}

variable "app_name" {
  default = "digital_app"
}

variable "app_environment" {
  default = "dev"
}

variable "repo_names" {

  type = list
  default = ["webapp1", "webapp2"]
}

# ecr.tf | Elastic Container Repository

resource "aws_ecr_repository" "digital-ecr" {
  name = "${var.app_name}-${var.app_environment}-ecr"
  tags = {
    Name        = "${var.app_name}-ecr"
    Environment = var.app_environment
  }
}

#Create private repositary for each application

resource "aws_ecr_repositary" "webapp-ecr" {
  count = length(var.repo_names)
  name = var.repo_names[count.index]
  #Allows tag over-writing
  image_tag_mutability = "MUTABLE"

  image_scaning_configuration {
   scan_on_push = true
  }
}
