resource "aws_s3_bucket" "static_site" {
  bucket = "${var.account_id}-severless-app-proj-static-site"
}



resource "aws_s3_bucket_ownership_controls" "boc_static_site" {
  bucket = aws_s3_bucket.static_site.id
  rule {
  object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "access_static_site" {
  bucket = aws_s3_bucket.static_site.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "acl_static_site" {
  depends_on = [
  aws_s3_bucket_ownership_controls.boc_static_site,
  aws_s3_bucket_public_access_block.access_static_site,
  ]

  bucket = aws_s3_bucket.static_site.id
  acl    = "public-read"
}

resource "aws_s3_bucket_website_configuration" "static_site_conf" {
  bucket = aws_s3_bucket.static_site.id

  index_document {
  suffix = "index.html"
  }

  error_document {
  key = "error.html"
  }

  routing_rule {
  condition {
    key_prefix_equals = "docs/"
  }
  redirect {
    replace_key_prefix_with = "documents/"
  }
  }
}

resource "aws_s3_bucket_policy" "allow_access_from_another_account" {
  bucket = aws_s3_bucket.static_site.id
  policy = jsonencode({
  "Version": "2012-10-17",
  "Id": "Policy1497053408897",
  "Statement": [
    {
    "Sid": "Stmt1497053406813",
    "Effect": "Allow",
    "Principal": "*",
    "Action": "s3:GetObject",
    "Resource": "arn:aws:s3:::${aws_s3_bucket.static_site.id}/*"
    }
  ]
  })
}

resource "aws_s3_bucket" "lambda" {
  bucket = "${var.account_id}-severless-app-proj-static-lambda-functions"
}