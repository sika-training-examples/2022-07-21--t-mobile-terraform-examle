terraform {
  required_providers {
    gitlab = {
      source  = "gitlabhq/gitlab"
      version = "3.16.1"
    }
  }
}

variable "gitlab_token" {}

provider "gitlab" {
  base_url = "https://gitlab.sikademo.com/api/v4"
  token    = var.gitlab_token
}

resource "gitlab_project_variable" "vars" {
  for_each = {
    "ONDREJSIKA_TOKEN" = var.gitlab_token
  }

  project   = 2
  key       = each.key
  value     = each.value
  protected = false
}


resource "gitlab_project_variable" "files" {
  for_each = {
    "CORE_TFVARS" = file("../env/core/terraform.tfvars")
    "DEV_TFVARS"  = file("../env/dev/terraform.tfvars")
    "PROD_TFVARS" = file("../env/prod/terraform.tfvars")
  }

  project       = 2
  key           = each.key
  value         = each.value
  variable_type = "file"
  protected     = false
}
