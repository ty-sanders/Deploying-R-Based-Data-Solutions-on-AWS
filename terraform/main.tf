module "r-shiny-apprunner" {
  source = "./modules/application"
  image_tag = "latest"
  ecr_repository_url = "088130860316.dkr.ecr.us-east-1.amazonaws.com/r-shiny-app-runner"
  private_subnets = [
  "subnet-0e925f62cae6b723a",
  "subnet-04cafbec45c5e9cf6"]
  public_subnets = [
  "subnet-016500e1c3d0b22f8",
  "subnet-0a9681ee01f6898e3"
  ]
  vpc_id = "vpc-0c4e1aeaf4c4bbf1c"
}

