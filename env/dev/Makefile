GITLAB_DOMAIN = gitlab.sikademo.com
GITLAB_PROJECT_ID = 2
STATE_NAME = dev

lock:
	rm -rf .terraform.lock.hcl
	terraform providers lock \
		-platform=darwin_amd64 \
		-platform=darwin_arm64 \
		-platform=linux_amd64 \
		-platform=linux_arm64 \
		-platform=windows_amd64
	git add .terraform.lock.hcl
	git commit -m "[auto] chore(env/dev): Update Terraform lock .terraform.lock.hcl" .terraform.lock.hcl

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
