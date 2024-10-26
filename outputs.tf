
# Outputs
# 
# Output values make information about your infrastructure available on the command line, 
# and can expose information for other Terraform configurations to use.
#================================================

output "buckets" {
  description = "S3 Buckets."
  value = {
    for bucket in aws_s3_bucket.bucket : bucket.tags.Name => tomap({
      "name"        = bucket.bucket,
      "description" = bucket.tags.Description
    })
  }
}

output "artifact_registries" {
  description = "Artifact Registries."
  value = {
    for registry in aws_ecr_repository.registry : registry.name => tomap({
      "name"        = registry.name,
      "arn"         = registry.arn,
      "description" = registry.tags.Description
    })
  }
}
