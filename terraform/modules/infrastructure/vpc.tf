module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "r-shiny-app-runner"
  cidr = "10.0.0.0/16"

  azs             = ["us-east-1a", "us-east-1b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  enable_nat_gateway = true
  enable_vpn_gateway = true
}

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

output "aws_account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "aws_iam_principal" {
  value = data.aws_caller_identity.current.arn
}

output "aws_region" {
  value = data.aws_region.current.name
}

output "connector_arn" {
  value = aws_apprunner_vpc_connector.connector.arn
}


resource "aws_ecr_repository" "r_shiny_app_runner_repo" {
  name                 = "r-shiny-app-runner"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

output "ecr_repository_url" {
  value = aws_ecr_repository.r_shiny_app_runner_repo.repository_url
}


output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnets" {
  value = module.vpc.public_subnets
}

output "private_subnets" {
  value = module.vpc.private_subnets
}

#output "r_shiny_build_role_arn" {
#  value = aws_iam_role.app_runner_r_shiny_build_role.arn
#}

output "vpc_endpoint_id" {
  value = module.vpc_endpoints.endpoints.apprunner.id
}

module "vpc_endpoints" {
  source = "terraform-aws-modules/vpc/aws//modules/vpc-endpoints"

  vpc_id             = module.vpc.vpc_id
  security_group_ids = [aws_security_group.endpoint_sg.id]

  endpoints = {
    apprunner = {
      service = "apprunner.requests"
      #private_dns_enabled = true
      subnet_ids = module.vpc.private_subnets
    },
  }
}

resource "aws_security_group" "app_sg" {
  name = "application_sg"
  vpc_id = module.vpc.vpc_id
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_apprunner_vpc_connector" "connector" {
  vpc_connector_name = "vpc-connector"
  subnets            = module.vpc.private_subnets
  security_groups    = [aws_security_group.app_sg.id]
}

resource "aws_security_group" "endpoint_sg" {
  vpc_id = module.vpc.vpc_id

  name        = "r_shiny_vpc_endpoint"
  description = "Security group for Verification VPC Endpoint"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    security_groups = [aws_security_group.app_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_iam_role" "app_runner_r_shiny_build_role" {
  name = "apprunner-r-shiny-build-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "build.apprunner.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "r_shiny_app_test_policy" {
  name = "ecr_pull_policy"
  role = aws_iam_role.app_runner_r_shiny_build_role.id

  # Permissions to pull images from ECR
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchCheckLayerAvailability",
          "ecr:BatchGetImage",
          "ecr:DescribeImages",
          "ecr:GetAuthorizationToken"
        ]
        Resource = "*"
      }
    ]
  })
}