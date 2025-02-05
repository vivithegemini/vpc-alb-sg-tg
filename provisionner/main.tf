provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "server1" {
  ami           = "ami-04681163a08179f28"
  instance_type = "t2.micro"
  key_name = aws_key_pair.key.key_name
  
}
# generate keypair
resource "tls_private_key" "tls" {
  algorithm = "RSA"
  rsa_bits  = 2048
}
resource "aws_key_pair" "key" {
  key_name   = "wpkey"
  public_key = tls_private_key.tls.public_key_openssh
}
# save keypair in local file
resource "local_file" "key1" {
  filename        = "wpkey.pem"
  content         = tls_private_key.tls.private_key_pem
  file_permission = 400
}

# create security group
resource "null_resource" "name" {
  provisioner "local-exec" {
    command = "echo ${aws_instance.server1.public_ip} > ip_address.txt"
    
  }
  
  provisioner "file" {
    source = "ip_address.txt"  // path to the file to be copied
    destination = "/home/ec2-user/ip_address.txt" 
  }
  connection {
    type = "ssh"  // ssh -i wpkey.pem ec2-user@${aws_instance.server1.public_ip}
    user = "ec2-user"
    private_key = file("${local_file.key1.filename}")
    host = aws_instance.server1.public_ip
  }
  provisioner "remote-exec" {
    inline = [
      "sudo yum install -y httpd",
      "sudo systemctl start httpd",
      "sudo systemctl enable httpd",
      "sudo chmod -R 666 /var/www/html",
      "sudo echo '<h1>Welcome to Terraform</h1>' |sudo  tee  /var/www/html/index.html"
    ]
    
  }
  depends_on = [ aws_instance.server1, local_file.key1 ]
}


/*
what is terraform?
why terraform?
building blocks of terraform
- provider
- resource
- data
- variable
- output
- module
- provisioner
- import
- terraform commands
a- init
b- plan
c- apply
d- destroy
e- validate
f- fmt
g- show
h- state
i- import
j- workspace
- state file management
- modules
- different environments
- sensitive data
- best practices
use modules
- use version control
- use remote state
- use workspaces // workspace 
*/