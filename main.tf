terraform {
  backend "http" {}
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "2.21.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "3.1.1"
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
  lifecycle {
    ignore_changes = [
      ssh_keys,
    ]
  }

  count = 2

  image    = local.DEBIAN_IMAGE
  name     = "example${count.index}"
  region   = local.REGION
  size     = "s-1vcpu-1gb"
  ssh_keys = local.admin_ssh_keys
}

output "example-ip" {
  value = digitalocean_droplet.example.*.ipv4_address
}

locals {
  VM_TYPE_1 = {
    image = "debian-11-x64"
    size  = "s-1vcpu-1gb"
  }
  VM_TYPE_2 = {
    image = "debian-10-x64"
    size  = "s-1vcpu-2gb"
  }
}

resource "digitalocean_droplet" "foo" {
  lifecycle {
    ignore_changes = [
      ssh_keys,
    ]
  }

  for_each = {
    "a" = local.VM_TYPE_1
    "c" = local.VM_TYPE_2
    "f" = {
      image = "debian-9-x64"
      size  = "c-2"
    }
  }

  image    = each.value.image
  name     = "foo-${each.key}"
  region   = local.REGION
  size     = each.value.size
  ssh_keys = local.admin_ssh_keys
}

output "foo-ip" {
  value = {
    for key, val in digitalocean_droplet.foo :
    key => val.ipv4_address
  }
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

locals {
  db_host     = digitalocean_database_cluster.example.host
  db_port     = digitalocean_database_cluster.example.port
  db_user     = digitalocean_database_cluster.example.user
  db_password = digitalocean_database_cluster.example.password
}

resource "digitalocean_database_db" "example-foo" {
  lifecycle {
    prevent_destroy = true
  }

  cluster_id = digitalocean_database_cluster.example.id
  name       = "foo"

  provisioner "local-exec" {
    # command = "slu postgres ping -H ${local.db_host} -P ${local.db_port} -u ${local.db_user} -p ${local.db_password} -n ${self.name}"
    command = "echo slu postgres ping -H ${local.db_host} -P ${local.db_port} -u ${local.db_user} -p ${local.db_password} -n ${self.name}"
  }
}

resource "digitalocean_droplet" "web" {
  lifecycle {
    ignore_changes = [
      ssh_keys
    ]
  }

  image    = local.DEBIAN_IMAGE
  name     = "web"
  region   = local.REGION
  size     = "s-1vcpu-1gb"
  ssh_keys = local.admin_ssh_keys

  connection {
    type = "ssh"
    user = "root"
    host = self.ipv4_address
  }

  provisioner "remote-exec" {
    inline = [
      "apt-get update",
      "apt-get install -y nginx",
    ]
  }

  provisioner "file" {
    content     = "<h1>Hello T-Mobile"
    destination = "/var/www/html/index.html"
  }
}

resource "digitalocean_droplet" "web2" {
  lifecycle {
    create_before_destroy = true
    ignore_changes = [
      ssh_keys,
      user_data,
    ]
  }

  ssh_keys  = local.admin_ssh_keys
  image     = local.DEBIAN_IMAGE
  name      = "web2"
  region    = local.REGION
  size      = "s-1vcpu-1gb"
  user_data = <<EOT
#cloud-config
ssh_pwauth: yes
password: asdfasdf2020
chpasswd:
  expire: false
write_files:
- path: /html/index.html
  permissions: "0755"
  owner: root:root
  content: |
    <h1>Hello from Cloud Init
runcmd:
  - |
    apt update
    apt install -y nginx
    cp /html/index.html /var/www/html/index.html
EOT
}

output "web2-ip" {
  value = digitalocean_droplet.web2.ipv4_address
}
