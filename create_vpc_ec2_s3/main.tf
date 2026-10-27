provider "aws" {
    region = "ap-south-1"
}

# 1.create vpc
resource "aws_vpc" "demo_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = "terraform-demo-vpc"
  }
}

#2. create subnet
resource "aws_subnet" "demo_subnet" {
  vpc_id = aws_vpc.demo_vpc.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "terraform-demo-subnet"
  }
}

#3. create internet gateway
resource "aws_internet_gateway" "demo_igw" {
  vpc_id = aws_vpc.demo_vpc.id

  tags = {
    Name = "terraform-demo-igw"
  }
}

#4. create route table
resource "aws_route_table" "demo_RT" {
  vpc_id = aws_vpc.demo_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.demo_igw.id
  }

  tags = {
    Name = "terraform-demo-RT"
  }
}

#5. associate the route table with subnet
resource "aws_route_table_association" "demo_aasociate" {
  subnet_id = aws_subnet.demo_subnet.id
  route_table_id = aws_route_table.demo_RT.id
}

#6. create security group (SG)
resource "aws_security_group" "demo_sg" {
  name = "terraform-demo-sg"
  description = "Allow internet from SSH"
  vpc_id = aws_vpc.demo_vpc.id

  ingress {
    description = "SSH access-restrict IP before use"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "terraform-demo-sg"
  }
}

#7. create EC2 instance
resource "aws_instance" "demo_ec2" {
  ami = "ami-0c7632fb77f35db43"
  instance_type = "t3.micro"
  subnet_id = aws_subnet.demo_subnet.id
  vpc_security_group_ids = [aws_security_group.demo_sg.id]
  associate_public_ip_address = true

  tags = {
    Name = "terraform-demo-ec2"
  }
}

#8. create S3 bucket
resource "aws_s3_bucket" "demo_bucket" {
  bucket_prefix = "terraform-state-demo"

  tags = {
    Name = "terraform-state-demo-bucket"
  }
}