GITLAB_DOMAIN = gitlab.sikademo.com
GITLAB_PROJECT_ID = 2
STATE_NAME = main

fmt:
	terraform fmt -recursive

fmt-check:
	terraform fmt -check -recursive

fmt-check-diff:
	terraform fmt -check -diff -recursive

setup-git-hooks:
	rm -rf .git/hooks
	(cd .git && ln -s ../.git-hooks hooks)

lock:
	rm -rf .terraform.lock.hcl
	terraform providers lock \
		-platform=darwin_amd64 \
		-platform=darwin_arm64 \
		-platform=linux_amd64 \
		-platform=linux_arm64 \
		-platform=windows_amd64
	git add .terraform.lock.hcl
	git commit -m "[auto] chore(terraform.lock.hcl): Update Terraform lock" .terraform.lock.hcl

tf-init:
ifndef GITLAB_USERNAME
	$(error GITLAB_USERNAME is undefined)
endif
ifndef GITLAB_TOKEN
	$(error GITLAB_TOKEN is undefined)
endif
	terraform init \
		-backend-config="address=https://${GITLAB_DOMAIN}/api/v4/projects/${GITLAB_PROJECT_ID}/terraform/state/${STATE_NAME}" \
		-backend-config="lock_address=https://${GITLAB_DOMAIN}/api/v4/projects/${GITLAB_PROJECT_ID}/terraform/state/${STATE_NAME}/lock" \
		-backend-config="unlock_address=https://${GITLAB_DOMAIN}/api/v4/projects/${GITLAB_PROJECT_ID}/terraform/state/${STATE_NAME}/lock" \
		-backend-config="username=${GITLAB_USERNAME}" \
		-backend-config="password=${GITLAB_TOKEN}" \
		-backend-config="lock_method=POST" \
		-backend-config="unlock_method=DELETE" \
		-backend-config="retry_wait_min=5"

gen-docs:
	# Generate the docs for environments
	terraform-docs markdown ./env/core > ./env/core/README.md
	git add ./env/core/README.md
	terraform-docs markdown ./env/dev > ./env/dev/README.md
	git add ./env/dev/README.md
	terraform-docs markdown ./env/prod > ./env/prod/README.md
	git add ./env/prod/README.md

	# Generate the docs for apps
	terraform-docs markdown ./apps/counter > ./apps/counter/README.md
	git add ./apps/counter/README.md

	# Generate the docs for modules
	terraform-docs markdown ./modules/vm > ./modules/vm/README.md
	git add ./modules/vm/README.md
	terraform-docs markdown ./modules/redis > ./modules/redis/README.md
	git add ./modules/redis/README.md

	# Commit
	git commit -m "[auto] docs: Terraform generated docs"
