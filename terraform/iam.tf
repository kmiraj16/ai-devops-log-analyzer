# 1. Execution Role: Used by the ECS Agent to pull images and write logs
resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecs-task-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "ecs-tasks.amazonaws.com" }
    }]
  })
}

# Attach the standard AWS managed policy for ECS Execution
resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# 2. Task Role: Used by your application code (e.g., to access RDS or S3)
resource "aws_iam_role" "ecs_task_role" {
  name = "ecs-task-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "ecs-tasks.amazonaws.com" }
    }]
  })
}

# Optional: Add specific permissions for your application here.
# For example, if your app needs to read from a specific S3 bucket:
# resource "aws_iam_role_policy" "ecs_task_s3_policy" {
#   role = aws_iam_role.ecs_task_role.id
#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [{
#       Action   = ["s3:GetObject"]
#       Effect   = "Allow"
#       Resource = ["arn:aws:s3:::your-bucket-name/*"]
#     }]
#   })
# }