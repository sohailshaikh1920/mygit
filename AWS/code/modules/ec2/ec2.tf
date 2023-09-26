
data "aws_ami" "standardami"{
  most_recent = true
  owners = ["amazon"]

}

resource "aws_instance" "myec2" {

ami = data.aws_ami.standardami.id
instance_type = var.instance_type
subnet_id = "subnet-0816861f09fac99ea"
}
