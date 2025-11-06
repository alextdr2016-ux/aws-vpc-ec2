resource "aws_vpc" "vpc_ec2_demo" {
  cidr_block = var.vpc_cidr

  enable_dns_support   = true
  enable_dns_hostnames = true


  tags = {
    Name = "${var.project_name}-vpc"
  }
}
