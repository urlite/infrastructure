data "aws_route53_zone" "urlite" {
  name = local.urlite_domain
}

data "aws_acm_certificate" "urlite" {
  provider = aws.nvirginia
  domain   = local.urlite_domain
}
