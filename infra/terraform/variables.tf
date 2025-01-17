variable "aws_region" {
  type = string
  default = "us-east-1"
}
variable "env_name" {
  type = string
  default = "template"
}
variable "provisioner" {
  type = string
  default = "terraform"
}
variable "ec2_keypair_public_key" {
  type = string
}
variable "ec2_instance_type" {
  type = string
  default = "t2.micro"
}
variable "ami_id" {
  type = string
  # default = "ami-04b4f1a9cf54c11d0" 
  default = "ami-0e9107ed11be76fde"
}
######################################################################
## Network
variable "vpc_cidr" {
  type = string
  default = "10.0.0.0/16"
}

variable "public_subnets_cidr_root_newbits" {
  type = number
  default = 4
}

variable "public_subnets_cidr_sub_newbits" {
  type = number
  default = 4
}
######################################################################
variable "ingress_cidr_blocks"{
  type = list
  default = ["0.0.0.0/0"]
}
variable "ingress_rules" {
  type = list
  default = ["http-80-tcp", "ssh-tcp"]
}
variable "egress_rules" {
  type = list
  default = ["all-all"]
}
