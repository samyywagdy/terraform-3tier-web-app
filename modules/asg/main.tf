data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_launch_template" "my_template" {
  name_prefix            = "${var.PROJECT_NAME}-template"
  image_id               = data.aws_ami.ubuntu.id
  instance_type          = var.EC2_TYPE
  vpc_security_group_ids = [var.CLIENT_SG_ID, var.SSH_SG_ID]
  user_data              = filebase64("../modules/asg/config.sh")
  key_name               = var.KEY_NAME
  tags = {
    Name = "${var.PROJECT_NAME}-template"
  }
}

resource "aws_autoscaling_group" "asg" {
  desired_capacity          = var.DESIRED_SIZE
  max_size                  = var.MAX_SIZE
  min_size                  = var.MIN_SIZE
  health_check_grace_period = 300
  health_check_type         = "ELB"
  force_delete              = true
  vpc_zone_identifier       = [var.PRI_SUB_2A_ID, var.PRI_SUB_2B_ID]
  target_group_arns         = [var.TG_ARN]

  launch_template {
    id      = aws_launch_template.my_template.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "web-server"
    propagate_at_launch = true # Enables propagation of the tag to Amazon EC2 instances launched via this ASG
  }
}

resource "aws_autoscaling_policy" "scale_up_policy" {
  name                   = "autoscaling_policy"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.asg.name
}
resource "aws_cloudwatch_metric_alarm" "scale_up_alarm" {
  alarm_name          = "${var.PROJECT_NAME}-asg-scale-up-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "80"
  alarm_description   = "This metric monitors ec2 cpu utilization"
  dimensions = {
    "AutoScalingGroupName" = aws_autoscaling_group.asg.name
  }
  actions_enabled = true
  alarm_actions   = [aws_autoscaling_policy.scale_up_policy.arn]
}

resource "aws_autoscaling_policy" "scale_down_policy" {
  name                   = "autoscaling_policy"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.asg.name
}
resource "aws_cloudwatch_metric_alarm" "scale_down_alarm" {
  alarm_name          = "${var.PROJECT_NAME}-asg-scale-down-alarm"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "80"
  alarm_description   = "This metric monitors ec2 cpu utilization"
  dimensions = {
    "AutoScalingGroupName" = aws_autoscaling_group.asg.name
  }
  actions_enabled = true
  alarm_actions   = [aws_autoscaling_policy.scale_down_policy.arn]
}