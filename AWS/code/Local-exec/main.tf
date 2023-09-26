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

resource "aws_instance" "myec2" {

ami = "ami-0c02fb55956c7d316"
instance_type = "t2.micro"
subnet_id = "subnet-0816861f09fac99ea"



provisioner "local-exec" {
    command = "echo ${self.private_ip} >> private_ips.txt"

  }
}
