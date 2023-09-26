
data "aws_ami" "standardami"{
  most_recent = true
  owners = ["amazon"]

}

resource "aws_instance" "standardec2"{

  ami = data.aws_ami.standardami.id
  instance_type = "t2.micro"
  subnet_id = var.subnetid
  count = 3


  tags = {
    Name = "var.ec2name[count.index]"
  }

}
