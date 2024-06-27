This feature enables to prevent concurrent runs of 
terraform scripts with out using DynamoDB integration


In order to achieve this
1. You need to have a work space model in your project
2. Run terraform_apply.sh with arguments that are neccessary
ex:
./terraform-apply.sh -var-file=development.tfvars
