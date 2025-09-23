# ============================================================================
# CONFIGURACION DEL PROVEEDOR AWS
#============================================================================
# Define el proveedor de AWS y especifica la region donde se crearan los recursos
provider "aws" {
  region = "sa-east-1" # Región de São Paulo, Brasil
}

# ============================================================================
# INSTANCIA EC2 - SERVIDOR NGINX
# ============================================================================
# Crea una instancia EC2 que funcionara como servidor web con Nginx
resource "aws_instance" "nginx-server" {
  ami           = "ami-082daca2e7d60abda"
  instance_type = "t3.micro"

  # Script de inicializacion que se ejecuta al arrancar la instancia
  user_data = <<-EOF
              #!/bin/bash
              sudo yum install -y nginx
              sudo systemctl enable nginx
              sudo systemctl start nginx
              EOF

  key_name = aws_key_pair.nginx-server-ssh.key_name

  vpc_security_group_ids = [
    aws_security_group.nginx-server-sg.id
  ]
}

# ssh
# ssh-keygen -t rsa -b 2048 -f "nginx-server.key"
resource "aws_key_pair" "nginx-server-ssh" {
  key_name   = "nginx-server-ssh"
  public_key = file("nginx-server.key.pub")
}

# Security Group #
resource "aws_security_group" "nginx-server-sg" {
  name        = "nginx-server-sg"
  description = "Security group allowing SSH and HTTP access"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
