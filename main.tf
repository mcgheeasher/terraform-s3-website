# Get the current AWS region (optional, we’ll hardcode region for URL)
data "aws_region" "current" {}

# Create random suffix for unique bucket name
resource "random_id" "bucket_id" {
  byte_length = 4
}

# S3 bucket (ACLs not needed — AWS enforces ownership)
resource "aws_s3_bucket" "site" {
  bucket        = "tf-s3-website-${random_id.bucket_id.hex}"
  force_destroy = true
}

# Website hosting configuration
resource "aws_s3_bucket_website_configuration" "site" {
  bucket = aws_s3_bucket.site.id

  index_document {
    suffix = "index.html"
  }
}

# Upload index.html to S3
resource "aws_s3_object" "index" {
  bucket       = aws_s3_bucket.site.id
  key          = "index.html"
  source       = "${path.module}/website/index.html"
  content_type = "text/html"
}

# Make the bucket publicly readable (optional, only if BlockPublicAccess is off)
resource "aws_s3_bucket_policy" "public" {
  bucket = aws_s3_bucket.site.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.site.arn}/*"
      }
    ]
  })
}

# Outputs
output "bucket_name" {
  value = aws_s3_bucket.site.bucket
}

output "website_url" {
  # Hardcode region to avoid deprecated warning
  value = "http://${aws_s3_bucket.site.bucket}.s3-website-us-east-1.amazonaws.com"
}


