# -----------------------------------------------------
# Example: S3 Bucket Policy Atom Usage
# -----------------------------------------------------

provider "aws" {
  region = "eu-west-2"
}

module "s3_bucket_policy" {
  source = "../../"

  namespace   = "psp"
  environment = "dev"
  name        = "assets"

  bucket_id = "psp-dev-assets"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Sid       = "EnforceSSL"
      Effect    = "Deny"
      Principal = "*"
      Action    = "s3:*"
      Resource = [
        "arn:aws:s3:::psp-dev-assets",
        "arn:aws:s3:::psp-dev-assets/*"
      ]
      Condition = {
        Bool = { "aws:SecureTransport" = "false" }
      }
    }]
  })
}

output "bucket_id" {
  value = module.s3_bucket_policy.bucket_id
}
