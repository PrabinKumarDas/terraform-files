provider "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "my_ec2" {
  ami = "ami-0c7632fb77f35db43"
  instance_type = "t3.micro"

  tags = {
    Name = "terraform-ec2"
  }
}