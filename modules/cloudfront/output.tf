output "CLOUDFRONT_DOMAIN_NAME" {
  value = aws_cloudfront_distribution.my_distribution.domain_name
}

output "CLOUDFRONT_HOSTED_ZONE_ID" {
  value = aws_cloudfront_distribution.my_distribution.hosted_zone_id
}