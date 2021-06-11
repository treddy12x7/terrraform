resource "aws_launch_template" "test-asg-template" {
  name_prefix   = "test-asg-templ"
  image_id      = data.aws_ssm_parameter.amis.value
  instance_type = "t2.micro"
  key_name      = "terraform"
  #user_data     = file("scripts/apache.sh")
  user_data              = filebase64("scripts/apache.sh")
  vpc_security_group_ids = [aws_security_group.websg.id]
}

resource "aws_autoscaling_group" "test-asg-grp" {
  #availability_zones = ["us-east-1a"]
  desired_capacity          = 1
  max_size                  = 1
  min_size                  = 1
  health_check_grace_period = 60
  health_check_type         = "ELB"
  #desired_capacity          = 4
  #force_delete              = true
  #placement_group           = aws_placement_group.test.id
  #load_balancers = aws_lb.test.name
  vpc_zone_identifier = aws_subnet.public.*.id
  launch_template {
    id      = aws_launch_template.test-asg-template.id
    version = "$Latest"
    #Default = "$Default"
  }
}
resource "aws_autoscaling_attachment" "test-asg_atchmt_elb" {
  autoscaling_group_name = aws_autoscaling_group.test-asg-grp.id
  alb_target_group_arn   = aws_lb_target_group.test-tg.arn
}
resource "aws_autoscaling_policy" "add-asg-pol" {
  name                   = "add-policy"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 60
  autoscaling_group_name = aws_autoscaling_group.test-asg-grp.name
}
resource "aws_autoscaling_policy" "remove-asg-pol" {
  name                   = "remove-policy"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 60
  autoscaling_group_name = aws_autoscaling_group.test-asg-grp.name
}
resource "aws_cloudwatch_metric_alarm" "avg_cpu_utl_80" {
  alarm_name          = "terraform-auto"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "80"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.test-asg-grp.name
  }

  alarm_description = "This metric monitors ec2 cpu utilization"
  alarm_actions     = [aws_autoscaling_policy.add-asg-pol.arn]
}
resource "aws_cloudwatch_metric_alarm" "avg_cpu_utl_30" {
  alarm_name          = "terraform-auto-re"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "30"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.test-asg-grp.name
  }

  alarm_description = "This metric monitors ec2 cpu utilization"
  alarm_actions     = [aws_autoscaling_policy.remove-asg-pol.arn]
}