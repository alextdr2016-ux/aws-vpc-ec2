resource "aws_subnet" "ec2_demo_public" {
  vpc_id                  = aws_vpc.vpc_ec2_demo.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_name}-public-subnet"
  }
}