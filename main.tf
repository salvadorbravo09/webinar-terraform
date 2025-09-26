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
