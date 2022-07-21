terraform {
  backend "s3" {
    bucket          = "use1-dev-devops-tfstate"
    key             = "load-balancer-poc/terraform.tfstate"
    region          = "us-east-1"
    dynamodb_table  = "use1-dev-devops-tfstate-lock"
    encrypt         = true
  }
}
