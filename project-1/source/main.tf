terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"
}

provider "aws" {
  profile = "udacity"
  region  = "us-east-1"
}

resource "aws_s3_bucket" "bucket_gctrevino_udacity_project_1" {
  bucket = "bucket-gctrevino-udacity-project-1"
  acl    = "public-read"
  policy = <<EOF
{
"Version":"2012-10-17",
"Statement":[
 {
   "Sid":"AddPerm",
   "Effect":"Allow",
   "Principal": "*",
   "Action":["s3:GetObject"],
   "Resource":["arn:aws:s3:::bucket-gctrevino-udacity-project-1/*"]
 }
]
}
EOF

  website {
    index_document = "index.html"

    #         routing_rules = <<EOF
    # [{
    #     "Condition": {
    #         "KeyPrefixEquals": "docs/"
    #     },
    #     "Redirect": {
    #         "ReplaceKeyPrefixWith": "documents/"
    #     }
    # }]
    # EOF
  }
}

resource "null_resource" "upload_website_to_s3" {
  provisioner "local-exec" {
    command = "AWS_PROFILE=udacity aws s3 sync /home/gctrevino/Udacity/1/udacity-starter-website s3://${aws_s3_bucket.bucket_gctrevino_udacity_project_1.id}"
  }
}

resource "aws_cloudfront_distribution" "cdn_gctrevino_udacity_project_1" {
  origin {
    domain_name = "bucket-gctrevino-udacity-project-1.s3-website-us-east-1.amazonaws.com"
    origin_id   = aws_s3_bucket.bucket_gctrevino_udacity_project_1.id

    custom_origin_config {
      http_port              = "80"
      https_port             = "443"
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1", "TLSv1.1", "TLSv1.2"]
    }
  }

  enabled = true

  default_root_object = "index.html"

  default_cache_behavior {
    //path_pattern     = "/*"
    allowed_methods = ["GET", "HEAD"]
    cached_methods  = ["GET", "HEAD"]

    target_origin_id = aws_s3_bucket.bucket_gctrevino_udacity_project_1.id

    forwarded_values {
      query_string = false
      headers      = ["Origin"]
      cookies {
        forward = "none"
      }
    }

    default_ttl = 3600
    min_ttl     = 500
    max_ttl     = 86400

    compress               = true
    viewer_protocol_policy = "redirect-to-https"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

}