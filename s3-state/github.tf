module "github-oidc" {
  source  = "terraform-module/github-oidc-provider/aws"
  version = "2.2.1"
  create_oidc_provider = false
  create_oidc_role     = true

  repositories              = ["sherazriaz-git/digitify-terraform:ref:refs/heads/main"]
  oidc_role_attach_policies = ["arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"]
}
################################################################################
# OUTPUTS
################################################################################
output "oidc_provider_arn" {
  description = "OIDC provider ARN"
  value       = module.github-oidc.oidc_provider_arn
}

output "github_oidc_role" {
  description = "CICD GitHub role."
  value       = module.github-oidc.oidc_role
}