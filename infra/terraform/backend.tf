terraform {
  backend "s3" {
    bucket = "template-bucket-sunset"
    key = "state/terraform.tfstate"
    region = "us-east-1"
  }
}
