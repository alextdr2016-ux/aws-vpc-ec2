# 1) Aleg AMI-ul AL2023, mereu cea mai nouă în regiunea curentă
data "aws_ami" "al2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# 3) Instanța EC2 în subnetul public, cu SG + Key Pair
resource "aws_instance" "web" {
  ami                         = data.aws_ami.al2023.id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.ec2_demo_public.id
  vpc_security_group_ids      = [aws_security_group.web_sg.id]
  key_name                    = aws_key_pair.ssh_key.key_name
  associate_public_ip_address = true

  # --- user_data ---
  user_data = <<-EOF
              #!/bin/bash
              dnf -y install httpd
              systemctl enable --now httpd
              echo "Salut din EC2, creat automat de Terraform by Alex!" > /var/www/html/index.html
              EOF


  tags = {
    Name = "${var.project_name}-web"
  }
}
