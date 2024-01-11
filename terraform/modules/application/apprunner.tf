resource "aws_apprunner_service" "apprunner_r_shiny_app" {
  service_name = "apprunner-r-shiny-app"

  observability_configuration {
    observability_configuration_arn = aws_apprunner_observability_configuration.r_shiny_app_xray_config.arn
    observability_enabled           = true
  }
  source_configuration {
    image_repository {
      image_configuration {
        port = "3838"
      }
      image_identifier      = "${var.ecr_repository_url}:${var.image_tag}"
      image_repository_type = "ECR"
    }
    auto_deployments_enabled = true
    authentication_configuration {
      access_role_arn = "arn:aws:iam::088130860316:role/apprunner-r-shiny-build-role"
    }
  }
  health_check_configuration {
    healthy_threshold   = 3
    interval            = 5
    protocol            = "TCP"
    timeout             = 5
    unhealthy_threshold = 3
  }
  network_configuration {

    ingress_configuration {
      is_publicly_accessible = true
    }

    egress_configuration {
      egress_type       = "VPC"
      vpc_connector_arn = var.connector_arn
    }
  }
  tags = {
    Name = "r-shiny-apprunner"
  }
  instance_configuration {
    cpu = "1024"
  }
}


resource "aws_apprunner_observability_configuration" "r_shiny_app_xray_config" {
  observability_configuration_name = "r-shiny-app-xray-config"

  trace_configuration {
    vendor = "AWSXRAY"
  }
}

output "app_url" {
  value = aws_apprunner_service.apprunner_r_shiny_app.service_url
}


#resource "aws_apprunner_vpc_ingress_connection" "r_shiny_vpc_ingress_connection" {
#  name        = "r-shiny-vpc-ingress-connection"
#  service_arn = aws_apprunner_service.apprunner_r_shiny_app.arn
#
#  ingress_vpc_configuration {
#    vpc_id          = var.vpc_id
#    vpc_endpoint_id = var.vpc_endpoint_id
#  }
#}

