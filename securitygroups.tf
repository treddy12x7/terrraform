resource "aws_security_group" "websg" {
  name        = "websg-allow-ssh-http"
  description = "Allow ssh and http"
  vpc_id      = aws_vpc.test.*.id[0]

  ingress {
    #description      = "TLS from VPC"
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    #cidr_blocks = ["0.0.0.0/0"]
    security_groups = [aws_security_group.lb-sg.id]
    #ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
  }
  ingress {
    #description      = "TLS from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    #security_groups      = [aws_security_group.lb-sg.id]
    #ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = terraform.workspace
  }
}

resource "aws_security_group" "lb-sg" {
  name        = "allow http and https from web sg"
  description = "Allw http and https "
  vpc_id      = aws_vpc.test.*.id[0]

  ingress {
    #description      = "TLS from VPC"
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    #security_groups      = [aws_security_group.websg.id]
    #ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    #description      = "TLS from VPC"
    from_port = 443
    to_port   = 443
    protocol  = "tcp"
    #security_groups      = [aws_security_group.websg.id]
    #ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    #ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = terraform.workspace
  }
}
resource "aws_security_group" "rds-sg" {
  name        = "allow-rds-from-websg"
  description = "allow rds from websg "
  vpc_id      = aws_vpc.test.*.id[0]

  ingress {
    #description      = "TLS from VPC"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.websg.id]
    #ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
    #cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    #ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = terraform.workspace
  }
}