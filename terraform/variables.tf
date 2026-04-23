variable "aws_region" {
  description = "AWS region for infrastructure"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project name prefix"
  type        = string
  default     = "ai-log-analyzer"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_a_cidr" {
  type    = string
  default = "10.0.1.0/24"
}

variable "public_subnet_b_cidr" {
  type    = string
  default = "10.0.2.0/24"
}

variable "private_app_subnet_a_cidr" {
  type    = string
  default = "10.0.11.0/24"
}

variable "private_app_subnet_b_cidr" {
  type    = string
  default = "10.0.12.0/24"
}

variable "private_db_subnet_a_cidr" {
  type    = string
  default = "10.0.21.0/24"
}

variable "private_db_subnet_b_cidr" {
  type    = string
  default = "10.0.22.0/24"
}

variable "container_port" {
  description = "Container port for the app"
  type        = number
  default     = 8000
}
variable "db_name" {
  description = "PostgreSQL database name"
  type        = string
  default     = "logdb"
}

variable "db_username" {
  description = "PostgreSQL username"
  type        = string
  default     = "loguser"
}

variable "db_password" {
  description = "PostgreSQL password"
  type        = string
  sensitive   = true
}

variable "db_port" {
  description = "PostgreSQL port"
  type        = number
  default     = 5432
}