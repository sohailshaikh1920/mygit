
resource "aws_vpc" "mydevvpc" {
  cidr_block           = "10.12.0.0/16"
  enable_dns_hostnames = "true"

  tags = {

    Name = "mydevvpc"

  }
}

resource "aws_subnet" "mydevsubnet1" {

  vpc_id                  = aws_vpc.mydevvpc.id
  cidr_block              = "10.12.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = "true"

  tags = {

    Name = "mydevsubnet1"
  }

}

resource "aws_subnet" "mydevsubnet2" {

  vpc_id                  = aws_vpc.mydevvpc.id
  cidr_block              = "10.12.2.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = "true"

  tags = {

    Name = "mydevsubnet2"
  }

}

resource "aws_route_table" "mydevroutetable" {

  vpc_id = aws_vpc.mydevvpc.id

  tags = {

    Name = "mydevroutetable"
  }

}

resource "aws_route_table_association" "mydevrtassoc1" {

  subnet_id      = aws_subnet.mydevsubnet1.id
  route_table_id = aws_route_table.mydevroutetable.id

}

resource "aws_route_table_association" "mydevrtassoc2" {

  subnet_id      = aws_subnet.mydevsubnet2.id
  route_table_id = aws_route_table.mydevroutetable.id

}

resource "aws_internet_gateway" "mydevig" {

  vpc_id = aws_vpc.mydevvpc.id

  tags = {

    Name = "mydevig"
  }
}

resource "aws_route" "mydevroute" {

  route_table_id         = aws_route_table.mydevroutetable.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.mydevig.id


}

resource "aws_security_group" "mydevSG" {

  name        = "inbound rule"
  description = "to allow ssh & http"
  vpc_id      = aws_vpc.mydevvpc.id

  ingress {

    description = "ssh"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  ingress {

    description = "http"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]


  }

  egress {
    description = "internet"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }

  tags = {
    Name = "mydevSG"
  }
}

resource "aws_instance" "mydevec2" {

  ami                         = "ami-0f9fc25dd2506cf6d"
  instance_type               = "t2.nano"
  subnet_id                   = aws_subnet.mydevsubnet1.id
  vpc_security_group_ids      = [aws_security_group.mydevSG.id]
  key_name                    = "devenv"
  associate_public_ip_address = "true"
  user_data                   = file("userdata.tpl")

  tags = {
    Name = "mydevec2"
  }
}

resource "aws_instance" "mydevec2-1" {

  ami                    = "ami-0f9fc25dd2506cf6d"
  instance_type          = "t2.nano"
  subnet_id              = aws_subnet.mydevsubnet2.id
  vpc_security_group_ids = [aws_security_group.mydevSG.id]
  key_name               = "devenv"

  tags = {
    Name = "mydevec2-1"
  }
}

resource "aws_elb" "mydevelb" {

  name = "mydevelb"
  # availability_zones = ["us-east-1a", "us-east-1b"]
  subnets = [aws_subnet.mydevsubnet1.id, aws_subnet.mydevsubnet2.id]

  listener {

    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 30
  }

  instances                   = [aws_instance.mydevec2.id, aws_instance.mydevec2-1.id]
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

}
