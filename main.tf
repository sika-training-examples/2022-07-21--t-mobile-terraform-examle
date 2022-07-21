resource "digitalocean_ssh_key" "default" {
  name       = "ondrejsika"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCslNKgLyoOrGDerz9pA4a4Mc+EquVzX52AkJZz+ecFCYZ4XQjcg2BK1P9xYfWzzl33fHow6pV/C6QC3Fgjw7txUeH7iQ5FjRVIlxiltfYJH4RvvtXcjqjk8uVDhEcw7bINVKVIS856Qn9jPwnHIhJtRJe9emE7YsJRmNSOtggYk/MaV2Ayx+9mcYnA/9SBy45FPHjMlxntoOkKqBThWE7Tjym44UNf44G8fd+kmNYzGw9T5IKpH1E1wMR+32QJBobX6d7k39jJe8lgHdsUYMbeJOFPKgbWlnx9VbkZh+seMSjhroTgniHjUl8wBFgw0YnhJ/90MgJJL4BToxu9PVnH"
}

locals {
  ssh_keys = [
    digitalocean_ssh_key.default.id,
  ]
}

module "redis" {
  source = "./modules/redis"
  name   = "counter"
}

module "vms" {
  count = 2

  source    = "./modules/vm"
  name      = "counter-${count.index}"
  image     = "docker-20-04"
  ssh_keys  = local.ssh_keys
  user_data = <<EOT
#cloud-config
runcmd:
  - |
    docker pull -q ondrejsika/counter-tmobile
    docker run --name counter -d -p 80:80 -e REDIS="${module.redis.uri}" ondrejsika/counter-tmobile
EOT
}

output "redis-uri" {
  value     = module.redis.uri
  sensitive = true
}

output "ips" {
  value = {
    for key, val in module.vms :
    key => val.ip
  }
}
