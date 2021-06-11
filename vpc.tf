
resource "aws_vpc" "test" {
  count                = terraform.workspace == "dev" ? 0 : 1
  cidr_block           = var.vpc_cidr
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name      = local.vpc_name
    Createdby = "terraform"
  }
}
