module "r-shiny-apprunner" {
  source = "./modules/application"
  image_tag = "latest"
  ecr_repository_url = ""
  vpc_id = ""
  public_subnets = [
  "",
  ""]
  private_subnets = ["", ""]
  vpc_endpoint_id = ""
}

