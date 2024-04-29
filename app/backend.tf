terraform {
  backend "s3" {
    bucket = "samy-bucket"
    key    = "terraform.tfstate"
    region = "us-east-1"
    dynamodb_table = "terraform"
  }
}