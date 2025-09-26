# tf state #
terraform {
  backend "s3" {
    bucket = "webinar-terraform"
    key    = "webinar-terraform/terraform.tfstate"
    region = "sa-east-1"
  }
}

# modulos #
module "nginx_server_dev" {
  source = "./nginx_server_module"

  ami_id        = "ami-082daca2e7d60abda" # Amazon Linux 2 en sa-east-1
  instance_type = "t3.small"
  server_name   = "nginx-server-dev"
  environment   = "dev"
}

module "nginx_server_qa" {
  source = "./nginx_server_module"

  ami_id        = "ami-082daca2e7d60abda" # Amazon Linux 2 en sa-east-1
  instance_type = "t3.small"
  server_name   = "nginx-server-qa"
  environment   = "qa"
}

# output #
output "nginx_dev_ip" {
  description = "Direccion IP publica de la instancia EC2"
  value       = module.nginx_server_dev.server_public_ip
}

output "nginx_dev_dns" {
  description = "DNS publico de la instancia EC2"
  value       = module.nginx_server_dev.server_public_dns
}

output "nginx_qa_ip" {
  description = "Direccion IP publica de la instancia EC2"
  value       = module.nginx_server_qa.server_public_ip
}

output "nginx_qa_dns" {
  description = "DNS publico de la instancia EC2"
  value       = module.nginx_server_qa.server_public_dns
}

# import #
resource "aws_instance" "server-web" {
  ami           = "ami-082daca2e7d60abda"
  instance_type = "t3.micro"

  tags = {
    Name        = "server-web"
    Environment = "test"
    Owner       = "sa.bravo0901@gmail.com"
    Team        = "DevOps"
    Project     = "webinar-terraform"
  }

  vpc_security_group_ids = [
    "sg-09f8670f244fb046e",
  ]
}
