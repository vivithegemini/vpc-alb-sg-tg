resource "aws_instance" "web" {
  ami                                  = "ami-0c614dee691cbbf37"
  associate_public_ip_address          = true
  availability_zone                    = "us-east-1b"
  instance_type                        = "t2.micro"
  key_name                             = "ec2key"
  monitoring                           = false
  subnet_id                            = "subnet-09901ec9fc544c3fa"
  vpc_security_group_ids      = ["sg-05b76aeef2bbe3784"]
  tags = {
    Name = "terraform-import"
  }
}

