resource "random_id" "bucket_id" {
  byte_length = 4
}

resource "aws_s3_bucket" "site" {
  bucket = "tf-s3-website-${random_id.bucket_id.hex}"
  acl    = "public-read"
  force_destroy = true

  website {
    index_document = "index.html"
    error_document = "index.html"
  }

  tags = {
    Name = "Terraform S3 Static Website"
    Env  = "home-lab"
  }
}

resource "aws_s3_bucket_public_access_block" "block" {
  bucket = aws_s3_bucket.site.id

  block_public_acls   = false
  block_public_policy = false
  ignore_public_acls  = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_object" "index" {
  bucket = aws_s3_bucket.site.id
  key    = "index.html"
  content = file(var.website_index)
  content_type = "text/html"
  acl = "public-read"
}

output "website_url" {
  value = aws_s3_bucket.site.website_endpoint
}
