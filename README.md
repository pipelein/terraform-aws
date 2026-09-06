# Terraform Boilerplate

Minimal, opinionated starting point for an AWS Terraform project. No real
resources included — replace `modules/example_module` and wire it up in
`main.tf`.

## Structure

```
.
├── main.tf                  # root module entry point (calls child modules)
├── variables.tf              # root-level input variables
├── outputs.tf                 # root-level outputs
├── providers.tf                # provider configuration
├── versions.tf                  # Terraform + provider version constraints
├── backend.tf                    # remote state backend (S3 + DynamoDB), partial config
├── terraform.tfvars.example        # sample vars file - copy and fill in
├── modules/
│   └── example_module/              # reusable module skeleton
│       ├── main.tf
│       ├── variables.tf
│       ├── outputs.tf
│       └── versions.tf
├── environments/
│   ├── dev/
│   │   ├── backend.hcl               # per-env backend config (for -backend-config)
│   │   └── terraform.tfvars           # per-env variable values
│   └── prod/
│       ├── backend.hcl
│       └── terraform.tfvars
├── .github/workflows/terraform-ci.yml  # fmt/validate/plan on PRs
├── Makefile                              # convenience wrappers
└── .gitignore
```

## Prerequisites

- Terraform >= 1.7.0
- AWS credentials available (env vars, `~/.aws/credentials`, or SSO profile)
- An S3 bucket + DynamoDB table for remote state (create these once, manually
  or via a separate bootstrap config — don't manage your own state backend
  with itself)

## Usage

Initialize and work against a specific environment using the `ENV` variable
(defaults to `dev`):

```bash
make init ENV=dev
make plan ENV=dev
make apply ENV=dev
```

Without `make`, the equivalent raw commands:

```bash
terraform init -backend-config=environments/dev/backend.hcl
terraform plan  -var-file=environments/dev/terraform.tfvars
terraform apply -var-file=environments/dev/terraform.tfvars
```

To target prod, swap `dev` for `prod` (`ENV=prod` or the file paths above).

## Adding a module

1. Create `modules/<name>/` with `main.tf`, `variables.tf`, `outputs.tf`,
   `versions.tf`.
2. Reference it from root `main.tf`:
   ```hcl
   module "<name>" {
     source       = "./modules/<name>"
     project_name = var.project_name
     environment  = var.environment
   }
   ```

## Notes

- State is never stored locally in this setup — backend is S3 with DynamoDB
  locking. Fill in real bucket/table names in `environments/*/backend.hcl`
  before running `init`.
- `.tfvars` files are committed here for convenience since they hold no
  secrets; if yours will, keep them out of git and inject via CI secrets or
  a secrets manager instead.
- CI runs `fmt -check`, `validate`, and `plan` against the `dev` environment
  on every pull request touching `.tf`/`.tfvars` files.
