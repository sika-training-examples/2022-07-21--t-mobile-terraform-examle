terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "2.21.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "3.19.0"
    }
  }
}

variable "name" {
  type        = string
  description = "Name of the counter instance"
}

variable "cloudflare_zone_id" {
  type = string
}

variable "backend_count" {
  type        = number
  description = "Nuber of counter VM instances"
  default     = 2
}

variable "ssh_keys" {
  type    = list(number)
  default = []
}

locals {
  prefix = "counter-${var.name}"
}

module "db" {
  source = "../../modules/redis"
  name   = local.prefix
}

module "backend" {
  count = var.backend_count

  source    = "../../modules/vm"
  name      = "${local.prefix}-${count.index}"
  image     = "docker-20-04"
  ssh_keys  = var.ssh_keys
  user_data = <<EOT
#cloud-config
runcmd:
  - |
    docker pull -q ondrejsika/counter-tmobile
    docker run --name counter -d -p 80:80 --hostname ${local.prefix}-${count.index} -e REDIS="${module.db.uri}" ondrejsika/counter-tmobile
EOT
}

resource "digitalocean_loadbalancer" "counter" {
  name   = local.prefix
  region = "fra1"

  forwarding_rule {
    entry_port     = 80
    entry_protocol = "http"

    target_port     = 80
    target_protocol = "http"
  }

  healthcheck {
    port     = 80
    protocol = "tcp"
  }

  droplet_ids = module.backend.*.digitalocean_droplet.id
}

output "ip" {
  value = digitalocean_loadbalancer.counter.ip
}

resource "cloudflare_record" "counter" {
  zone_id = var.cloudflare_zone_id
  name    = local.prefix
  value   = digitalocean_loadbalancer.counter.ip
  type    = "A"
}

output "domain" {
  value = cloudflare_record.counter.hostname
}
