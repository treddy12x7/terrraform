/*
resource "aws_instance" "web" {
  count           = var.web_count
  ami             = data.aws_ssm_parameter.amis.value
  instance_type   = "t3.micro"
  subnet_id       = aws_subnet.public.*.id[count.index]
  user_data       = file("scripts/apache.sh")
  security_groups = [aws_security_group.websg.id]
  key_name = "terraform"

  tags = {
    Name = terraform.workspace
  }
}
*/