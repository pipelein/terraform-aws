ENV ?= dev

.PHONY: init plan apply destroy fmt validate

init:
	terraform init -backend-config=environments/$(ENV)/backend.hcl -reconfigure

plan:
	terraform plan -var-file=environments/$(ENV)/terraform.tfvars

apply:
	terraform apply -var-file=environments/$(ENV)/terraform.tfvars

destroy:
	terraform destroy -var-file=environments/$(ENV)/terraform.tfvars

fmt:
	terraform fmt -recursive

validate:
	terraform validate
