resource "aws_acm_certificate" "cert" {
  domain_name       = var.DOMAIN_NAME
  validation_method = "DNS"

  tags = {
    Environment = "${var.PROJECT_NAME}-CERT"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate_validation" "validate_cert" {
  certificate_arn = aws_acm_certificate.cert.arn
}