# variables #
variable "ami_id" {
  description = "ID de la AMI para la instancia EC2"
  default     = "ami-082daca2e7d60abda" # Amazon Linux 2 en sa-east-1
}

variable "instance_type" {
  description = "Tipo de instancia EC2"
  default     = "t3.micro"
}

variable "server_name" {
  description = "Nombre del servidor web"
  default     = "nginx-server"
}

variable "environment" {
  description = "Ambiente de la aplicacion"
  default     = "test"
}

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
  ami           = var.ami_id
  instance_type = var.instance_type

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

  tags = {
    Name        = var.server_name
    Environment = var.environment
    Owner       = "sa.bravo0901@gmail.com"
    Team        = "DevOps"
    Project     = "webinar-terraform"
  }
}

# ssh
# ssh-keygen -t rsa -b 2048 -f "nginx-server.key"
resource "aws_key_pair" "nginx-server-ssh" {
  key_name   = "${var.server_name}-ssh"
  public_key = file("${var.server_name}.key.pub")

  tags = {
    Name        = "${var.server_name}-ssh"
    Environment = "${var.environment}"
    Owner       = "sa.bravo0901@gmail.com"
    Team        = "DevOps"
    Project     = "webinar-terraform"
  }
}

# Security Group #
resource "aws_security_group" "nginx-server-sg" {
  name        = "${var.server_name}-sg"
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

  tags = {
    Name        = "${var.server_name}-sg"
    Environment = "${var.environment}"
    Owner       = "sa.bravo0901@gmail.com"
    Team        = "DevOps"
    Project     = "webinar-terraform"
  }
}

# output #
output "server_public_ip" {
  description = "Direccion IP publica de la instancia EC2"
  value       = aws_instance.nginx-server.public_ip
}

output "server_public_dns" {
  description = "DNS publico de la instancia EC2"
  value       = aws_instance.nginx-server.public_dns
}
