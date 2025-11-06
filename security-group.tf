# Security Group pentru instanța EC2
resource "aws_security_group" "web_sg" {
  name        = "${var.project_name}-sg"
  description = "Allow SSH from my IP and HTTP/HTTPS from anywhere"
  vpc_id      = aws_vpc.vpc_ec2_demo.id

  # --- INBOUND ---
  # SSH din IP-ul tău (introduci la apply: var.my_ip_cidr, ex. 81.196.xx.xx/32)
  ingress {
    description = "SSH from my IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip_cidr]
  }

  # HTTP (port 80) - acces public
  ingress {
    description = "HTTP from anywhere (IPv4)"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTPS (port 443) - acces public
  ingress {
    description = "HTTPS from anywhere (IPv4)"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # --- OUTBOUND ---
  # Egress: permis tot (update-uri, pachete, etc.)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-sg"
  }
}
