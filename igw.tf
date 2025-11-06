resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc_ec2_demo.id



  tags = {
    Name = "${var.project_name}-igw"
  }
}