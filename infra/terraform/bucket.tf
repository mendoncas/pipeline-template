terraform {
  backend "s3" {
    bucket = "template-bucket"
    key = "state/terraform.tfstate"
    region = "us-east-1"
  }
}