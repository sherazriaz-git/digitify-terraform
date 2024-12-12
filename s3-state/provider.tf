terraform {
  backend "s3" {
    bucket                      = "digitify-terraform-state"
    encrypt                     = true
    key                         = "tf/s3/state/prod.tfstate"
    region                      = "us-east-1"
    dynamodb_table              = "digitify-terraform-state-lock"
    skip_metadata_api_check     = true
    skip_region_validation      = true
    skip_credentials_validation = true
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
      # version =  ">= 4.27.0"
    }
  }


}

provider "aws" {
  region = var.region
  default_tags {
    tags = {
      Project    = var.project_name
      Maintainer = var.maintainer
      Terraform  = "true"


    }
  }

  skip_metadata_api_check     = true
  skip_region_validation      = true
  skip_credentials_validation = true
  skip_requesting_account_id  = true
}
