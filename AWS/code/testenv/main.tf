terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.9.0"
    }
  }
}

provider "aws" {
  # Configuration options
}





resource "aws_instance" "ec2code1" {
  ami           = var.amiid
  instance_type = "t2.nano"
  subnet_id     = "subnet-0816861f09fac99ea"

  tags = {
    Name = "ec2code1"
  }
}

output "ec2code1" {
  value = aws_instance.ec2code1.id

}
