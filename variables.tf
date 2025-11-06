variable "aws_region" {
  description = "AWS region pentru toate resursele."
  type        = string
  default     = "eu-north-1"
}

variable "project_name" {
  description = "Prefix pentru Name tag (ex: vpc-ec2-demo)."
  type        = string
  default     = "vpc-ec2-demo"
}

variable "vpc_cidr" {
  description = "CIDR pentru VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR pentru subnetul public."
  type        = string
  default     = "10.0.1.0/24"
}

variable "my_ip_cidr" {
  description = "IP-ul tău în format CIDR pentru acces SSH (ex: 81.196.29.58/32)."
  type        = string
  default     = "81.196.29.58/32"
}

variable "public_key_path" {
  description = "Calea către fișierul cheii publice SSH (.pub)"
  type        = string
  default     = "C:/Users/alext/.ssh/id_ed25519.pub"
  # poți pune default aici sau o pasezi din linia de comandă
  # default = "C:/Users/alext/.ssh/id_ed25519.pub"
}
variable "instance_type" {
  description = "Tipul EC2 (ex: t3.micro)"
  type        = string
  default     = "t3.micro"
}
