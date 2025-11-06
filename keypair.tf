
# Creează un Key Pair în AWS folosind cheia ta publică locală
resource "aws_key_pair" "ssh_key" {
  count = var.create_key_pair ? 1 : 0  # ← Condiție pentru a crea sau nu key pair
  
  key_name   = "${var.project_name}-key" # numele cheii în AWS
  public_key = var.create_key_pair ? file(var.public_key_path) : "" # ← Citește fișierul doar dacă create_key_pair este true

  tags = {
    Name = "${var.project_name}-key"
  }
}