output "enabled" {
  description = "Whether the module is enabled."
  value       = local.enabled
}

output "bucket_id" {
  description = "ID of the bucket the policy is attached to"
  value       = try(aws_s3_bucket_policy.this[0].bucket, null)
}
