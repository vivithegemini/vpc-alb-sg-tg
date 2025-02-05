provider "aws" {
  region = "us-east-1"
}
/*
data "aws_instance" "d1" {
  instance_id = "i-04c48325ab1b9333e"
}

resource "aws_instance" "server1" {
  ami = data.aws_instance.d1.ami
  instance_type = data.aws_instance.d1.instance_type
  availability_zone = data.aws_instance.d1.availability_zone
}
*/

data "aws_ami" "example" {
  most_recent      = true
  owners           = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.10-hvm-*x86_64-gp2"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "server2" {
  ami = data.aws_ami.example.id
  instance_type = "t2.micro"
}
