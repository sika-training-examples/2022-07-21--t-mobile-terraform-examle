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

resource "digitalocean_reserved_ip" "this" {
  region = var.region
}

resource "digitalocean_droplet" "this" {
  image    = var.image
  name     = var.name
  region   = var.region
  size     = var.size
  ssh_keys = var.ssh_keys
}

resource "digitalocean_reserved_ip_assignment" "this" {
  ip_address = digitalocean_reserved_ip.this.ip_address
  droplet_id = digitalocean_droplet.this.id
}

output "ip" {
  value = digitalocean_reserved_ip.this.ip_address
}

output "digitalocean_droplet" {
  value = digitalocean_droplet.this
}
