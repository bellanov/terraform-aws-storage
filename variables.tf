# Variables
# 
# Input variables allow you to customize modules without altering their source code.
#================================================

variable "artifact_registries" {
  description = "Artifact Registries."
  type = map(object({
    description = string
  }))
  default = {}
}

variable "buckets" {
  description = "S3 Buckets."
  type = map(object({
    description = string
  }))
  default = {}
}
