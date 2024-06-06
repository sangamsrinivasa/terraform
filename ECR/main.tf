
provider "aws" {
   region = "us-east-1"
}

variable "app_name" {
  default = "digital_app"
}

variable "app_environment" {
  default = "dev"
}

# ecr.tf | Elastic Container Repository

resource "aws_ecr_repository" "aws-ecr" {
  name = "${var.app_name}-${var.app_environment}-ecr"
  tags = {
    Name        = "${var.app_name}-ecr"
    Environment = var.app_environment
  }
}
