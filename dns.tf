resource "aws_route53_record" "www-urlite-cc" {
  name    = local.urlite_website_domain
  type    = "A"
  zone_id = data.aws_route53_zone.urlite.id
  alias {
    evaluate_target_health = false
    name                   = aws_cloudfront_distribution.s3_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.s3_distribution.hosted_zone_id
  }
}
