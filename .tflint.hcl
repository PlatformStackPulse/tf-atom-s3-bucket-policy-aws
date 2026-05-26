plugin "terraform" {
  enabled = true
  preset  = "recommended"
}

# Atom pattern: context.tf provides tf-label variables
rule "terraform_standard_module_structure" {
  enabled = false
}

plugin "aws" {
  enabled = true
  version = "0.37.0"
  source  = "github.com/terraform-linters/tflint-ruleset-aws"
}
