locals {
  azs         = ["${var.aws_region}a", "${var.aws_region}b"]
  num_of_az   = length(local.azs)
  subnet_cidr = cidrsubnets(var.vpc_cidr, var.public_subnets_cidr_root_newbits)
}

locals {
  public_subnets_list_cidr = cidrsubnets(local.subnet_cidr[0], [for i in range(local.num_of_az) : var.public_subnets_cidr_sub_newbits]...)
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  public_subnet_tags = {
    "kubernetes.io/role/elb" = 1
  }
  name = "${var.env_name}-vpc"
  cidr = var.vpc_cidr

  azs            = local.azs
  public_subnets = local.public_subnets_list_cidr

  create_igw              = true
  map_public_ip_on_launch = true
}

# security groups das instâncias
module "ec2_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name = "${var.env_name}-intance-sg"
  vpc_id = module.vpc.vpc_id

  ingress_cidr_blocks = var.ingress_cidr_blocks
  ingress_rules = var.ingress_rules

  egress_rules = var.egress_rules
}

resource "aws_lb_target_group" "tg" {
  name     = "alb-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id
}

resource "aws_lb_target_group_attachment" "tg_attachment" {
  count           = 2
  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = [module.ec2_instance_1.id, module.ec2_instance_2.id][count.index]
  port             = 80
}

# Criando o Load Balancer
resource "aws_lb" "alb" {
  name               = "application-load-balancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [module.ec2_sg.security_group_id]
  subnets            = module.vpc.public_subnets # Substitua pelos seus Subnet IDs
}

# Listener para o Load Balancer
resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}

