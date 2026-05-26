# tf-atom-s3-bucket-policy-aws

[![CI](https://github.com/PlatformStackPulse/tf-atom-s3-bucket-policy-aws/actions/workflows/ci.yml/badge.svg)](https://github.com/PlatformStackPulse/tf-atom-s3-bucket-policy-aws/actions/workflows/ci.yml)
[![Release](https://github.com/PlatformStackPulse/tf-atom-s3-bucket-policy-aws/actions/workflows/auto-release.yml/badge.svg)](https://github.com/PlatformStackPulse/tf-atom-s3-bucket-policy-aws/actions/workflows/auto-release.yml)
[![CodeQL](https://github.com/PlatformStackPulse/tf-atom-s3-bucket-policy-aws/actions/workflows/codeql.yml/badge.svg)](https://github.com/PlatformStackPulse/tf-atom-s3-bucket-policy-aws/actions/workflows/codeql.yml)
[![Changelog](https://github.com/PlatformStackPulse/tf-atom-s3-bucket-policy-aws/actions/workflows/changelog.yml/badge.svg)](https://github.com/PlatformStackPulse/tf-atom-s3-bucket-policy-aws/actions/workflows/changelog.yml)

---

## Purpose

Attaches an IAM policy document to an S3 bucket, controlling who can access the bucket and what actions they can perform. This atom receives the bucket ID from the bucket atom and applies the policy independently.

## Architecture

```
┌─────────────────────────────────────────────────┐
│           Molecule Layer                        │
│  ┌──────────────┐    ┌────────────────────┐    │
│  │ s3-bucket    │───▶│ THIS MODULE        │    │
│  │ (bucket_id)  │    │ s3-bucket-policy   │    │
│  └──────────────┘    │ (attaches policy)  │    │
│                      └────────────────────┘    │
└─────────────────────────────────────────────────┘
```

## Scope

| In Scope | Out of Scope |
|----------|--------------|
| `aws_s3_bucket_policy` resource | Bucket creation (→ `tf-atom-s3-bucket-aws`) |
| JSON policy document attachment | Public access block (→ `tf-atom-s3-bucket-public-access-block-aws`) |
| Conditional creation (`enabled`) | Policy document generation (caller provides) |

## Features

- **Single-resource atom** — one `aws_s3_bucket_policy`, no side effects
- **Context propagation** — inherits namespace/environment/name for consistent labeling
- **Conditional creation** — `enabled = false` creates zero resources
- **Composable** — receives `bucket_id` from companion bucket atom
- **Tested** — unit tests for enabled and disabled scenarios
- **Flexible** — accepts any valid JSON policy document

## Usage

```hcl
module "bucket_policy" {
  source = "github.com/PlatformStackPulse/tf-atom-s3-bucket-policy-aws?ref=v1.0.0"

  context   = module.this.context
  bucket_id = module.bucket.bucket_id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Sid       = "EnforceSSL"
      Effect    = "Deny"
      Principal = "*"
      Action    = "s3:*"
      Resource  = ["${module.bucket.bucket_arn}", "${module.bucket.bucket_arn}/*"]
      Condition = { Bool = { "aws:SecureTransport" = "false" } }
    }]
  })
}
```

## Related Atoms

| Atom | Purpose |
|------|---------|
| [`tf-atom-s3-bucket-aws`](https://github.com/PlatformStackPulse/tf-atom-s3-bucket-aws) | Creates the bucket |
| [`tf-atom-s3-bucket-public-access-block-aws`](https://github.com/PlatformStackPulse/tf-atom-s3-bucket-public-access-block-aws) | Block public access |
| [`tf-atom-s3-bucket-encryption-aws`](https://github.com/PlatformStackPulse/tf-atom-s3-bucket-encryption-aws) | Server-side encryption |

## Module Documentation

<!-- BEGIN_TF_DOCS -->
<!-- END_TF_DOCS -->
