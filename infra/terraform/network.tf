//resource "aws_vpc" "template"{
//  cidr_block = "10.0.0.0/16"
//  enable_dns_hostnames = true
//  enable_dns_support = true
//}

locals {
    azs = ["${var.aws_region}a"]
    num_of_az = length(local.azs)
    subnet_cidr = cidrsubnets(var.vpc_cidr, var.public_subnets_cidr_root_newbits)
}

locals {
  public_subnets_list_cidr = cidrsubnets(local.subnet_cidr[0], [for i in range(local.num_of_az): var.public_subnets_cidr_sub_newbits]...)
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  public_subnet_tags = {
    "kubernetes.io/role/elb" = 1
  }
  name = "${var.env_name}-vpc"
  cidr = var.vpc_cidr

  azs = local.azs
  public_subnets  = local.public_subnets_list_cidr
  
  create_igw = true
  map_public_ip_on_launch = true
}