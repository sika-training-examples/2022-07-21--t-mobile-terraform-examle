data "digitalocean_ssh_keys" "all" {}

locals {
  cloudflare_zone_id = "f2c00168a7ecd694bb1ba017b332c019"
  ssh_keys           = data.digitalocean_ssh_keys.all.ssh_keys.*.id
}

module "counter" {
  source             = "../../apps/counter"
  name               = "prod"
  cloudflare_zone_id = local.cloudflare_zone_id
  ssh_keys           = local.ssh_keys
}
