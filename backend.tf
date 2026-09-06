# Remote state backend.
# Terraform does not allow variables here, so fill in real values
# (or better: pass them via `-backend-config` / partial config per environment,
# see environments/dev/backend.hcl and environments/prod/backend.hcl).

terraform {
  backend "s3" {
    # bucket         = "my-org-terraform-state"
    # key            = "boilerplate/terraform.tfstate"
    # region         = "eu-central-1"
    # dynamodb_table = "terraform-locks"
    # encrypt        = true
  }
}
