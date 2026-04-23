resource "aws_ecr_repository" "app_repo" {
  name                 = "ai-log-analyzer"
  image_tag_mutability = "MUTABLE"

  # ADD THIS LINE: Tells AWS to delete the repo even if it has images
  force_delete = true

  image_scanning_configuration {
    scan_on_push = true
  }
}