provider "aws" {
  region=var.aws_region
  default_tags {
    tags = {
      provision-by = var.provisioner
      env = var.env_name
    }
  }
}

resource "aws_key_pair" "ec2-key" {
  key_name="${var.env_name}-key"
  public_key = var.ec2_keypair_public_key
}

module "ec2_instance_1"{
  source = "terraform-aws-modules/ec2-instance/aws"
  name = "${var.env_name}-instance-1"
  ami = var.ami_id
  instance_type = var.ec2_instance_type

  key_name = aws_key_pair.ec2-key.key_name
  vpc_security_group_ids = [module.ec2_sg.security_group_id]
  subnet_id = module.vpc.public_subnets[0]
}

module "ec2_instance_2"{
  source = "terraform-aws-modules/ec2-instance/aws"
  name = "${var.env_name}-instance-2"
  ami = var.ami_id
  instance_type = var.ec2_instance_type

  key_name = aws_key_pair.ec2-key.key_name
  vpc_security_group_ids = [module.ec2_sg.security_group_id]
  subnet_id = module.vpc.public_subnets[0]
}

# security groups das instaâncias
module "ec2_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name = "${var.env_name}-intance-sg"
  vpc_id = module.vpc.vpc_id

  ingress_cidr_blocks = var.ingress_cidr_blocks
  ingress_rules = var.ingress_rules

  egress_rules = var.egress_rules
}