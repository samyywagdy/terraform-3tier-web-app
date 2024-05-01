resource "aws_lb" "alb" {
  name                       = "${var.PROJECT_NAME}-alb"
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [var.ALB_SG_ID]
  subnets                    = [var.PUB_SUB_1A_ID, var.PUB_SUB_1B_ID]
  enable_deletion_protection = false

  tags = {
    Name = "${var.PROJECT_NAME}-alb"
  }
}

resource "aws_lb_target_group" "alb-tg" {
  name                 = "${var.PROJECT_NAME}-alb-tg"
  port                 = 80
  protocol             = "HTTP"
  target_type          = "instance"
  deregistration_delay = 20 # Default is 300
  vpc_id               = var.VPC_ID
  health_check {
    enabled             = true
    interval            = 20 # Approximate amount of time, in seconds, between health checks of an individual target
    path                = "/"
    timeout             = 10 # Amount of time, in seconds, during which no response means a failed health check.
    matcher             = "200-399"
    protocol            = "HTTP"
    healthy_threshold   = 5 # Default is 3
    unhealthy_threshold = 5 # Default is 3
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_listener" "http_listeners" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "https_listeners" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "443"
  protocol          = "HTTPS"
  certificate_arn   = var.CERT_ARN
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb-tg.arn
  }
}

resource "aws_lb_listener_certificate" "lb_listener_certificate" {
  listener_arn    = aws_lb_listener.https_listeners.arn
  certificate_arn = var.CERT_ARN
}