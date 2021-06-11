resource "aws_lb" "test" {
  name               = "test-lb-tf"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb-sg.id]
  subnets            = aws_subnet.public.*.id

  tags = {
    Environment = terraform.workspace
  }
}
resource "aws_lb_target_group" "test-tg" {
  name     = "tf-example-lb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.test.*.id[0]
}
/*
resource "aws_lb_target_group_attachment" "test-tg-attch" {
  count = var.web_count
  target_group_arn = aws_lb_target_group.test-tg.arn
  target_id        = aws_instance.web.*.id[count.index]
  port             = 80
}
*/
resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.test.arn
  port              = "80"
  protocol          = "HTTP"
  #ssl_policy        = "ELBSecurityPolicy-2016-08"
  #certificate_arn   = "arn:aws:iam::187416307283:server-certificate/test_cert_rab3wuqwgja25ct3n4jdj2tzu4"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.test-tg.arn
  }
}