resource "aws_s3_bucket" "b" {
  bucket = local.urlite_website_domain
  acl    = "private"
  versioning {
    enabled = false
  }
  tags = {
    Name = local.urlite_website_domain
  }
}

data "aws_iam_policy_document" "s3_policy" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.b.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn]
    }
  }
}

resource "aws_s3_bucket_policy" "example" {
  bucket = aws_s3_bucket.b.id
  policy = data.aws_iam_policy_document.s3_policy.json
}

resource "null_resource" "upload_to_bucket" {
  provisioner "local-exec" {
    command = "aws s3 cp index.html s3://${aws_s3_bucket.b.bucket}"
  }
}

resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
  comment = "Some comment"
}
