terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "2.21.0"
    }
  }
}

variable "name" {
  type = string
}


variable "region" {
  type    = string
  default = "fra1"
}

variable "size" {
  type    = string
  default = "db-s-1vcpu-1gb"
}

resource "digitalocean_database_cluster" "this" {
  name       = var.name
  engine     = "redis"
  version    = "6"
  size       = var.size
  region     = var.region
  node_count = 1
}

output "uri" {
  value = digitalocean_database_cluster.this.uri
}