# Creează un Key Pair în AWS folosind cheia ta publică locală
resource "aws_key_pair" "ssh_key" {
  key_name   = "${var.project_name}-key" # numele cheii în AWS
  public_key = file(var.public_key_path) # citește conținutul fișierului .pub

  tags = {
    Name = "${var.project_name}-key"
  }
}