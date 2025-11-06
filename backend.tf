terraform {
  backend "s3" {
    bucket         = "tf-state-aws-vpc-ec2-alex"
    key            = "aws-vpc-ec2/terraform.tfstate"
    region         = "eu-north-1"
    dynamodb_table = "tf-locks"
    encrypt        = true
  }
}
