terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.9.0"
    }
  }
  backend "s3" {
    bucket                      = "digitify-terraform-state"
    encrypt                     = true
    key                         = "tf/s3/infra/prod.tfstate"
    region                      = "us-east-1"
    dynamodb_table              = "digitify-terraform-state-lock"
    skip_metadata_api_check     = true
    skip_region_validation      = true
    skip_credentials_validation = true
  }
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
