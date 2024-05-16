###############
# IAM Dev user
###############

module "iam_dev_user" {
  source = "./modules/IamUser"
  devuser = "1"
  name = "dev_user"
}


##############
# IAM QA User
##############

module "iam_qa_user" {
  source = "./modules/IamUser"
  qauser = "1"
  name = "qa_user"
}

