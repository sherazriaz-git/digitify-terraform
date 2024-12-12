module "ecr" {
  source  = "terraform-aws-modules/ecr/aws"
  version = "2.3.0"


  repository_name                 = local.name
  repository_image_tag_mutability = "MUTABLE"
  repository_force_delete         = true

  #   repository_read_write_access_arns = ["arn:aws:iam::012345678901:role/terraform"]
  repository_lifecycle_policy = jsonencode({
    rules = [
      {
        rulePriority = 1,
        description  = "Keep last 30 images",
        selection = {
          tagStatus     = "tagged",
          tagPrefixList = ["v"],
          countType     = "imageCountMoreThan",
          countNumber   = 30
        },
        action = {
          type = "expire"
        }
      }
    ]
  })

}