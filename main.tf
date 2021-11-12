provider "aws" {
  region = "ap-south-1"
}

resource "random_pet" "this" {
  length = 2
}


# Data sources to get VPC, subnets and security group details

data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "all" {
  vpc_id = data.aws_vpc.default.id
}

data "aws_security_group" "default" {
  vpc_id = data.aws_vpc.default.id
  name   = "default"
}


# ACM certificate
resource "aws_route53_zone" "this" {
  name          = "myelbexample.com"
  force_destroy = true
}

module "acm" {
  source  = "terraform-aws-modules/acm/aws"
  version = "~> 3.0"

  zone_id = aws_route53_zone.this.zone_id

  domain_name               = "myelbexample.com"
  subject_alternative_names = ["*.myelbexample.com"]

  wait_for_validation = false
}


# ELB

module "elb" {
  source = "../../"

  name = "myelb-example"

  subnets         = data.aws_subnet_ids.all.ids
  security_groups = [data.aws_security_group.default.id]
  internal        = false

  listener = [
    {
      instance_port     = "80"
      instance_protocol = "http"
      lb_port           = "80"
      lb_protocol       = "http"
    },
    {
      instance_port     = "8080"
      instance_protocol = "http"
      lb_port           = "8080"
      lb_protocol       = "http"
    },
  ]

  tags = {
    Owner       = "user"
    Environment = "test"
  }

  # ELB attachments
  number_of_instances = var.number_of_instances
  instances           = module.ec2_instances.id
}

# EC2 instances

module "ec2_instances" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 2.0"

  instance_count = var.number_of_instances

  name                        = "flask-app"
  ami                         = "ami-06a0b4e3b7eb7a300"
  instance_type               = "t2.micro"
  vpc_security_group_ids      = [data.aws_security_group.default.id]
  subnet_id                   = element(tolist(data.aws_subnet_ids.all.ids), 0)
  associate_public_ip_address = true
}
