resource "aws_route53_zone" "my_dns" {
  name = var.HOSTED_ZONE_NAME #myapp.samy.com
}

resource "aws_route53_record" "cloudfront_record" {
  zone_id = aws_route53_zone.my_dns.zone_id
  name    = aws_route53_zone.my_dns.name
  type    = "A"

  alias {
    name                   = var.CLOUDFRONT_DOMAIN_NAME
    zone_id                = var.CLOUDFRONT_HOSTED_ZONE_ID
    evaluate_target_health = false
  }
}