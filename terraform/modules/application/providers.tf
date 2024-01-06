terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.17.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  profile = "ros-sandbox"
  region  = "us-east-1"
}