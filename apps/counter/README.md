## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_cloudflare"></a> [cloudflare](#requirement\_cloudflare) | 3.19.0 |
| <a name="requirement_digitalocean"></a> [digitalocean](#requirement\_digitalocean) | 2.21.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_cloudflare"></a> [cloudflare](#provider\_cloudflare) | 3.19.0 |
| <a name="provider_digitalocean"></a> [digitalocean](#provider\_digitalocean) | 2.21.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_backend"></a> [backend](#module\_backend) | ../../modules/vm | n/a |
| <a name="module_db"></a> [db](#module\_db) | ../../modules/redis | n/a |

## Resources

| Name | Type |
|------|------|
| [cloudflare_record.counter](https://registry.terraform.io/providers/cloudflare/cloudflare/3.19.0/docs/resources/record) | resource |
| [digitalocean_loadbalancer.counter](https://registry.terraform.io/providers/digitalocean/digitalocean/2.21.0/docs/resources/loadbalancer) | resource |
| [digitalocean_vpc.main](https://registry.terraform.io/providers/digitalocean/digitalocean/2.21.0/docs/resources/vpc) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_backend_count"></a> [backend\_count](#input\_backend\_count) | Nuber of counter VM instances | `number` | `2` | no |
| <a name="input_cloudflare_zone_id"></a> [cloudflare\_zone\_id](#input\_cloudflare\_zone\_id) | n/a | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name of the counter instance | `string` | n/a | yes |
| <a name="input_ssh_keys"></a> [ssh\_keys](#input\_ssh\_keys) | n/a | `list(number)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_domain"></a> [domain](#output\_domain) | n/a |
| <a name="output_ip"></a> [ip](#output\_ip) | n/a |
