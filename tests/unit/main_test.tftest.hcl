# Unit Tests for tf-atom-s3-bucket-policy-aws

mock_provider "aws" {}

run "creates_policy_when_enabled" {
  variables {
    name        = "test"
    environment = "dev"
    namespace   = "unit"
    enabled     = true
    bucket_id   = "my-test-bucket"
    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [{
        Sid       = "AllowSSLOnly"
        Effect    = "Deny"
        Principal = "*"
        Action    = "s3:*"
        Resource  = ["arn:aws:s3:::my-test-bucket", "arn:aws:s3:::my-test-bucket/*"]
        Condition = { Bool = { "aws:SecureTransport" = "false" } }
      }]
    })
  }

  assert {
    condition     = aws_s3_bucket_policy.this[0].bucket == "my-test-bucket"
    error_message = "Policy should be attached to the specified bucket"
  }

  assert {
    condition     = output.bucket_id != null
    error_message = "bucket_id output should not be null when enabled"
  }
}

run "creates_nothing_when_disabled" {
  variables {
    name        = "test"
    environment = "dev"
    namespace   = "unit"
    enabled     = false
    bucket_id   = "my-test-bucket"
    policy      = "{}"
  }

  assert {
    condition     = length(aws_s3_bucket_policy.this) == 0
    error_message = "No policy should be created when disabled"
  }

  assert {
    condition     = output.bucket_id == null
    error_message = "bucket_id output should be null when disabled"
  }
}
