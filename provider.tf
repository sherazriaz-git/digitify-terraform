terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.9.0"
    }
  }
  #   backend "s3" {
  #     bucket               = "ausvet-terraform-dev-tfstate-files"
  #     region               = "ap-southeast-2"
  #     key                  = "terraform.tfstate"
  #     workspace_key_prefix = "LotWorks"
  #   }
}

provider "aws" {
  region = var.region

  default_tags {
    tags = {
      Terraform  = "true"
      Maintainer = var.maintainer
      Project    = var.project_name
      env        = var.env
    }
  }
  skip_metadata_api_check     = true
  skip_region_validation      = true
  skip_credentials_validation = true

}

# provider "aws" {
#   alias  = "virginia"
#   region = "us-east-1"
#   default_tags {
#     tags = {
#       Terraform  = "true"
#       Maintainer = var.maintainer
#       Project    = var.project
#     }
#   }
#   skip_metadata_api_check     = true
#   skip_region_validation      = true
#   skip_credentials_validation = true
# }
