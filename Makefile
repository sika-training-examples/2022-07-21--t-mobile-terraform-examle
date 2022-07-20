lock:
	rm -rf .terraform.lock.hcl
	terraform providers lock \
		-platform=darwin_amd64 \
		-platform=darwin_arm64 \
		-platform=linux_amd64 \
		-platform=linux_arm64 \
		-platform=windows_amd64 \
		-platform=windows_arm64
	git add .terraform.lock.hcl
	git commit -m "[auto] chore(terraform.lock.hcl): Update Terraform lock" .terraform.lock.hcl
