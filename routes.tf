# Route table pentru VPC
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc_ec2_demo.id

  tags = {
    Name = "${var.project_name}-public-rt"
  }
}

# Ruta implicită IPv4 către Internet prin IGW
resource "aws_route" "public_rt_default_ipv4" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gw.id
}


# Asocierea route table-ului la subnetul public
resource "aws_route_table_association" "public_rt_assoc" {
  subnet_id      = aws_subnet.ec2_demo_public.id
  route_table_id = aws_route_table.public_rt.id
}
