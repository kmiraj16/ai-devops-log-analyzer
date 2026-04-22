# --- VPC & Networking Outputs ---

output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "List of IDs of public subnets"
  value       = [aws_subnet.public_a.id, aws_subnet.public_b.id]
}

output "alb_dns_name" {
  description = "The DNS name of the load balancer to access the app"
  value       = aws_lb.main.dns_name
}

# --- ECS Outputs (Critical for GitHub Actions) ---

output "ecs_cluster_name" {
  description = "The name of the ECS Cluster"
  value       = aws_ecs_cluster.main.name
}

output "ecs_service_name" {
  description = "The name of the ECS Service"
  value       = aws_ecs_service.app.name
}

output "aws_region" {
  description = "The AWS region configured in variables"
  value       = var.aws_region
}

# --- Database Outputs ---

output "rds_endpoint" {
  description = "The connection endpoint for the RDS instance"
  value       = aws_db_instance.main.address
}

output "rds_db_name" {
  description = "The name of the database"
  value       = aws_db_instance.main.db_name
}

# --- Security Group Outputs (For debugging) ---

output "ecs_security_group_id" {
  description = "The ID of the ECS Security Group"
  value       = aws_security_group.ecs.id
}