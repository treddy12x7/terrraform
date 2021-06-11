locals {
  vpc_name = terraform.workspace == "dev" ? "dev-vpc" : "prod-vpc"
}
locals {
  azs = data.aws_availability_zones.azs.names
}