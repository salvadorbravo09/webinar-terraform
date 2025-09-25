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