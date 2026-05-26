# -----------------------------------------------------------------------------
# Module-Specific Variables
#
# Note: Standard labeling variables (enabled, namespace, tenant, environment,
# stage, name, delimiter, attributes, tags, label_order, etc.) are provided
# by context.tf via the tf-label module.
# -----------------------------------------------------------------------------

variable "bucket_id" {
  description = "ID (name) of the S3 bucket to attach the policy to"
  type        = string
}

variable "policy" {
  description = "JSON-encoded bucket policy document"
  type        = string
}
