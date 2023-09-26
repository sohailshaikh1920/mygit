
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
