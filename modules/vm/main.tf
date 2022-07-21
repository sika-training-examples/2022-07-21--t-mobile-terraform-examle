terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "2.21.0"
    }
  }
}

variable "name" {
  type        = string
  description = "Name of VM"
}

variable "image" {
  type = string
}

variable "region" {
  type    = string
  default = "fra1"
}

variable "size" {
  type    = string
  default = "s-1vcpu-1gb"
}

variable "ssh_keys" {
  type    = list(number)
  default = []
}

variable "user_data" {
  type        = string
  description = "User data for cloud init"
  default     = null
}

resource "digitalocean_droplet" "this" {
  image     = var.image
  name      = var.name
  region    = var.region
  size      = var.size
  ssh_keys  = var.ssh_keys
  user_data = var.user_data
}

output "ip" {
  value = digitalocean_droplet.this.ipv4_address
}

output "digitalocean_droplet" {
  value = digitalocean_droplet.this
}
