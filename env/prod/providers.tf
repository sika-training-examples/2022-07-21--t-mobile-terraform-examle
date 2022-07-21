terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "2.21.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "3.1.1"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "3.19.0"
    }
  }
}

variable "digitalocean_token" {}

provider "digitalocean" {
  token = var.digitalocean_token
}

variable "cloudflare_api_token" {}

provider "cloudflare" {
  api_token = var.cloudflare_api_token

}
