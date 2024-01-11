module "r-shiny-apprunner" {
  source = "./modules/application"
  image_tag = "latest"
  connector_arn = "arn:aws:apprunner:us-east-1:088130860316:vpcconnector/vpc-connector/1/c7f0b17b6dd54181bfd18851033ea8fe"
ecr_repository_url = "088130860316.dkr.ecr.us-east-1.amazonaws.com/r-shiny-app-runner"
private_subnets = [
  "subnet-040f1abe519c84062",
  "subnet-0d06f8e73b4343dee"]
public_subnets = [
  "subnet-05feea4ac516d5408",
  "subnet-03ec3c4ca55bf4434"]
vpc_endpoint_id = "vpce-0fc0d539a5dec8569"
vpc_id = "vpc-046cd4aec9573a28e"
}



