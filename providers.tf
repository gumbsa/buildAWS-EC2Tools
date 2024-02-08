# Start Date 01/10/2024
# Modification Date: 01/10/2024

# AWS Terraform Block
/*
terraform {
  required_version = ">= 1.4"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

# Provider Block
provider "aws" {
  region  = var.aws_region
  profile = "default"
  #access_key = ""
  #secret_key
}
*/

terraform {
  required_version = ">= 1.6"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}


# Provider Block
provider "aws" {
  region  = var.aws_region
  profile = "default"
}

