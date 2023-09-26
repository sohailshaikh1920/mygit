provider "aws" {
  region = "us-east-1"
}

provider "aws" {

  alias = "miraroad"
  region = "us-west-1"
}
