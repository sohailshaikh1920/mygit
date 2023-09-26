output "mydevvpc" {
  value = aws_vpc.mydevvpc.id
}

output "mydevsubnet1" {
  value = aws_subnet.mydevsubnet1.id
}

output "mydevroutetable" {

  value = aws_route_table.mydevroutetable.id
}

output "mydevig" {

  value = aws_internet_gateway.mydevig.id
}

output "mydevSG" {

  value = aws_security_group.mydevSG.id
}

output "mydevec2" {

  value = aws_instance.mydevec2.id
}

output "mydevec2-1" {

  value = aws_instance.mydevec2-1.id
}

output "mydevelb" {

  value = aws_elb.mydevelb.id
}
