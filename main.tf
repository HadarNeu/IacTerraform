
//key pair resource
resource "tls_private_key" "ec2_private_key" {
  algorithm = "RSA"
  rsa_bits  = 4096

}

//creating key pair
module "key_pair" {
  source = "terraform-aws-modules/key-pair/aws"

  key_name   = var.key_name
  public_key = tls_private_key.ec2_private_key.public_key_openssh
}

// Declaring a vpc
resource "aws_vpc" "project-vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "project-vpc"
  }
}

// Internet Gateway
resource "aws_internet_gateway" "project-vpcIGW" {
  depends_on = [
      aws_vpc.project-vpc
  ]
  vpc_id = aws_vpc.project-vpc.id

  tags = {
    Name = "project-vpcIGW"
  }
}

// Route Table
resource "aws_route_table" "public" {
  depends_on = [
      aws_internet_gateway.project-vpcIGW
  ]
  vpc_id = aws_vpc.project-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.project-vpcIGW.id
  }


  tags = {
    Name = "public"
  }
}

// Subnet
resource "aws_subnet" "public-subnet" {
  vpc_id            = aws_vpc.project-vpc.id
  cidr_block        = "10.0.0.0/24"
  availability_zone = "us-west-2a"


  tags = {
    Name = "public-subnet"
  }
}

// Associate subnet to route table

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.public-subnet.id
  route_table_id = aws_route_table.public.id
}


// Creating aws security resource
resource "aws_security_group" "hadar_sg" {
  depends_on = [
    aws_vpc.project-vpc
  ]
  name        = "hadar_sg"
  description = "Allow TCP inbound traffic"
  vpc_id      = aws_vpc.project-vpc.id

  ingress {
    description = "TCP from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.host_ip]
  }
   ingress {
    description = "SSH from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.host_ip]
  }
  ingress {
    description = "HTTPS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.host_ip]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.host_ip]
  }

  tags = {
    Name = "hadar_sg"
  }
}

// Launching new EC2 instance
resource "aws_instance" "hadarHost" {
    ami = var.ami
    instance_type = var.instance_type
    key_name = var.key_name
    vpc_security_group_ids = ["${aws_security_group.hadar_sg.id}"]
    subnet_id = aws_subnet.public-subnet.id
    associate_public_ip_address = true
    tags = {
        Name = "hadarHost"
    }
}

// Creating EBS volume
resource "aws_ebs_volume" "WebVol" {
  availability_zone = "${aws_instance.hadarHost.availability_zone}"
  size              = 1

  tags = {
    Name = "TeraTaskVol"
  }
}


