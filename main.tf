# provider #
provider "aws" {
  region = "sa-east-1" 
}

# resource #
resource "aws_instance" "nginx-server" {
  ami = "ami-082daca2e7d60abda"
  instance_type = "t3.micro"
}