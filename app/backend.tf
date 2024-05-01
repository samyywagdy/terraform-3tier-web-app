terraform {
  backend "s3" {
    bucket = "samy-bucket"
    key    = "terraform.tfstatee"
    region = "us-east-1"
    dynamodb_table = "terraform"
  }
}