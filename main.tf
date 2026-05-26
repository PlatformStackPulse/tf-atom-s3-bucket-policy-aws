# -----------------------------------------------------
# Atom: S3 Bucket Policy
# Attaches a JSON policy document to an S3 bucket.
# -----------------------------------------------------
resource "aws_s3_bucket_policy" "this" {
  count = module.this.enabled ? 1 : 0

  bucket = var.bucket_id
  policy = var.policy
}
