# -----------------------------------------------------------------------------
# Unit tests for tf-atom-s3-bucket-policy-aws
#
# Uses a mock AWS provider so no real credentials or resources are needed.
# All assertions target values that are KNOWN at plan time (input pass-throughs,
# the tf-label id string, and resource counts) — never computed attributes that
# would be unknown under a mock provider.
# -----------------------------------------------------------------------------

mock_provider "aws" {}

variables {
  # Standard tf-label context inputs
  namespace = "eg"
  stage     = "test"
  name      = "thing"

  # Module-specific required inputs
  bucket_id = "eg-test-thing-bucket"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Sid       = "EnforceSSL"
      Effect    = "Deny"
      Principal = "*"
      Action    = "s3:*"
      Resource = [
        "arn:aws:s3:::eg-test-thing-bucket",
        "arn:aws:s3:::eg-test-thing-bucket/*",
      ]
      Condition = { Bool = { "aws:SecureTransport" = "false" } }
    }]
  })
}

run "creates_when_enabled" {
  command = plan

  assert {
    condition     = length(aws_s3_bucket_policy.this) == 1
    error_message = "Exactly one aws_s3_bucket_policy should be created when enabled"
  }

  assert {
    condition     = aws_s3_bucket_policy.this[0].bucket == "eg-test-thing-bucket"
    error_message = "Policy must be attached to the bucket_id that was passed in"
  }

  assert {
    condition     = aws_s3_bucket_policy.this[0].policy == var.policy
    error_message = "Attached policy document must match the policy input"
  }

  assert {
    condition     = module.this.id == "eg-test-thing"
    error_message = "tf-label id must be namespace-stage-name (eg-test-thing)"
  }

  assert {
    condition     = output.enabled == true
    error_message = "enabled output must be true when the module is enabled"
  }
}

run "disabled_creates_nothing" {
  command = plan

  variables {
    enabled = false
  }

  assert {
    condition     = length(aws_s3_bucket_policy.this) == 0
    error_message = "No aws_s3_bucket_policy should be created when enabled = false"
  }

  assert {
    condition     = output.bucket_id == null
    error_message = "bucket_id output must be null when the module is disabled"
  }

  assert {
    condition     = output.enabled == false
    error_message = "enabled output must be false when the module is disabled"
  }
}
