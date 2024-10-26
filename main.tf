# Module Definition
# 
# Contains the main set of configuration for the module.
#================================================

# Random string used to uniquely identify infrastructure, enabling the reusability of names.
resource "random_string" "code" {
  length  = 8
  upper   = false
  special = false
}

# Iterate over list of buckets and procure the resources.
resource "aws_s3_bucket" "bucket" {
  for_each = var.buckets
  bucket   = "${each.key}-${random_string.code.result}"

  tags = {
    "Name"        = each.key
    "Description" = each.value.description
  }
}

# Disable public access to the bucket.
resource "aws_s3_bucket_public_access_block" "bucket" {
  for_each = aws_s3_bucket.bucket
  bucket   = each.value.bucket

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Define the lifecycle rules of bucket contents.
resource "aws_s3_bucket_lifecycle_configuration" "lifecycle" {
  for_each = aws_s3_bucket.bucket
  bucket   = each.value.bucket

  # Delete objects after 30 days
  rule {
    id     = "expire-objects"
    status = "Enabled"

    filter {}
    expiration {
      days = 30
    }
  }

  # Abort incomplete multipart uploads after 1 day
  rule {
    id     = "abort-multipart-uploads"
    status = "Enabled"

    filter {}
    abort_incomplete_multipart_upload {
      days_after_initiation = 1
    }
  }
}

# Iterate over list of artifact registries and procure the resources.
resource "aws_ecr_repository" "registry" {
  for_each = var.artifact_registries

  name                 = each.key
  image_tag_mutability = "MUTABLE"
  tags = {
    "Name"        = each.key
    "Description" = each.value.description
  }
}