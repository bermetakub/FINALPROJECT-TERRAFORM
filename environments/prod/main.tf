# terraform {
#   backend "s3" {
#     bucket = "terraform.tfstate-finalproject-bermet"
#     key = "prod/terraform.tfstate" 
#     region = "us-east-1" 
#   }
# }

variable "aws_region" {
  default = "us-east-1"
}

resource "aws_s3_bucket" "static_site" {
  bucket = "my-static-website-bucket-${random_string.bucket_suffix.result}"

  website {
    index_document = "index.html"
    error_document = "error.html"
  }

  tags = {
    Name        = "Static Website Bucket"
    Environment = "Production"
  }
}

resource "aws_s3_bucket_policy" "static_site_policy" {
  bucket = aws_s3_bucket.static_site.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.static_site.arn}/*"
      },
    ]
  })
}

resource "aws_s3_object" "object" {
    bucket = aws_s3_bucket.static_site.id
    key = "index.html"
    source = "index.html"
    content_type = "text/html"
  
}

resource "aws_s3_object" "errorobject" {
    bucket = aws_s3_bucket.static_site.id
    key = "error.html"
    source = "error.html"
    content_type = "text/html"
  
}

resource "aws_s3_bucket_ownership_controls" "example" {
  bucket = aws_s3_bucket.static_site.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_public_access_block" "example_public_access_block" {
  bucket = aws_s3_bucket.static_site.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "random_string" "bucket_suffix" {
  length  = 8
  special = false
  upper   = false
}

