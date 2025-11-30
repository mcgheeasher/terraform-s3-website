variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "website_index" {
  description = "Path to index.html"
  type        = string
  default     = "${path.module}/website/index.html"
}
