
resource "aws_vpc" "importvpc" {

  cidr_block = "10.0.0.0/16"


tags = {
  Name = "main"
}


}
