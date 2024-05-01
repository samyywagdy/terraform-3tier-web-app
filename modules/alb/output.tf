output "TG_ARN" {
  value = aws_lb_target_group.alb-tg.arn
}
output "ALB_DOMAIN_NAME" {
  value = aws_lb.alb.dns_name
}

output "ALB_ZONE_ID" {
  value = aws_lb.alb.zone_id
}