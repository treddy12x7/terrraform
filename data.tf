data "aws_ssm_parameter" "amis" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}
data "aws_availability_zones" "azs" {
  #state = "available"
}