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
