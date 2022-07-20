terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "2.21.0"
    }
  }
}

variable "digitalocean_token" {}

provider "digitalocean" {
  token = var.digitalocean_token
}

resource "digitalocean_ssh_key" "default" {
  name       = "ondrejsika"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCslNKgLyoOrGDerz9pA4a4Mc+EquVzX52AkJZz+ecFCYZ4XQjcg2BK1P9xYfWzzl33fHow6pV/C6QC3Fgjw7txUeH7iQ5FjRVIlxiltfYJH4RvvtXcjqjk8uVDhEcw7bINVKVIS856Qn9jPwnHIhJtRJe9emE7YsJRmNSOtggYk/MaV2Ayx+9mcYnA/9SBy45FPHjMlxntoOkKqBThWE7Tjym44UNf44G8fd+kmNYzGw9T5IKpH1E1wMR+32QJBobX6d7k39jJe8lgHdsUYMbeJOFPKgbWlnx9VbkZh+seMSjhroTgniHjUl8wBFgw0YnhJ/90MgJJL4BToxu9PVnH"
}

locals {
  REGION       = "fra1"
  DEBIAN_IMAGE = "debian-11-x64"
  admin_ssh_keys = [
    digitalocean_ssh_key.default.id,
  ]
}

resource "digitalocean_droplet" "example" {
  image    = local.DEBIAN_IMAGE
  name     = "example"
  region   = local.REGION
  size     = "s-1vcpu-1gb"
  ssh_keys = local.admin_ssh_keys
}

output "example-ip" {
  value = digitalocean_droplet.example.ipv4_address
}

resource "digitalocean_database_cluster" "example" {
  name       = "example"
  engine     = "pg"
  version    = "13"
  size       = "db-s-1vcpu-1gb"
  region     = local.REGION
  node_count = 1
}

output "db-conn" {
  value     = digitalocean_database_cluster.example.uri
  sensitive = true
}
