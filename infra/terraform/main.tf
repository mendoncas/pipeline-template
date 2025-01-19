provider "aws" {
  region = var.aws_region
  default_tags {
    tags = {
      provision-by = var.provisioner
      env          = var.env_name
    }
  }
}

resource "aws_key_pair" "ec2-key" {
  key_name   = "${var.env_name}-key"
  public_key = var.ec2_keypair_public_key
}

module "ec2_instance_1" {
  source        = "terraform-aws-modules/ec2-instance/aws"
  name          = "${var.env_name}-instance-1"
  ami           = var.ami_id
  instance_type = var.ec2_instance_type
  user_data     = <<-EOF
                #!/bin/bash
                echo "MESSAGE=servidor1" >> /etc/dockerenv
                EOF

  key_name               = aws_key_pair.ec2-key.key_name
  vpc_security_group_ids = [module.ec2_sg.security_group_id]
  subnet_id              = module.vpc.public_subnets[0]
}

module "ec2_instance_2" {
  source        = "terraform-aws-modules/ec2-instance/aws"
  name          = "${var.env_name}-instance-2"
  ami           = var.ami_id
  instance_type = var.ec2_instance_type
  user_data     = <<-EOF
                #!/bin/bash
                echo "MESSAGE=servidor2" >> /etc/dockerenv
                EOF

  key_name               = aws_key_pair.ec2-key.key_name
  vpc_security_group_ids = [module.ec2_sg.security_group_id]
  subnet_id              = module.vpc.public_subnets[0]
}

