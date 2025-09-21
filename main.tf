# FREE TIER Terraform Configuration
terraform {
  required_version = ">= 1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.1"
    }
  }
}

# AWS Provider Configuration for FREE TIER
provider "aws" {
  region = var.region

  # FREE TIER: Default tags aplicadas a todos os recursos
  default_tags {
    tags = {
      Project     = var.project_name
      Environment = var.environment
      ManagedBy   = "Terraform"
      Tier        = "free"
      CreatedBy   = "IaC-Serverless"
    }
  }
}
