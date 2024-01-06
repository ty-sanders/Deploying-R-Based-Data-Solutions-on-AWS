module "r-shiny-apprunner" {
  source = "./modules/application"
  image_tag = "latest"
  ecr_repository_url = "068608558151.dkr.ecr.us-east-2.amazonaws.com/ia-caucus-verification-app"
  vpc_id = "vpc-09b45ae11e8267b0f"
  public_subnets = [
  "subnet-0de6cad8dcc29ba2d",
  "subnet-0ff446aeb0bae33a9"]
  private_subnets = ["subnet-019d3625aec837bc8", "subnet-07ea1412d75c0fc66"]
  vpc_endpoint_id = "vpce-076deb38e560a7de8"
}

