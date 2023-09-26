terraform {
  backend "s3" {
    bucket = "sohailbackend"
    key    = "backend.tfstate"
    region = "us-east-1"
  }
}
