## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_cloudflare"></a> [cloudflare](#requirement\_cloudflare) | 3.19.0 |
| <a name="requirement_digitalocean"></a> [digitalocean](#requirement\_digitalocean) | 2.21.0 |
| <a name="requirement_null"></a> [null](#requirement\_null) | 3.1.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_digitalocean"></a> [digitalocean](#provider\_digitalocean) | 2.21.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_counter"></a> [counter](#module\_counter) | ../../apps/counter | n/a |

## Resources

| Name | Type |
|------|------|
| [digitalocean_ssh_keys.all](https://registry.terraform.io/providers/digitalocean/digitalocean/2.21.0/docs/data-sources/ssh_keys) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cloudflare_api_token"></a> [cloudflare\_api\_token](#input\_cloudflare\_api\_token) | n/a | `any` | n/a | yes |
| <a name="input_digitalocean_token"></a> [digitalocean\_token](#input\_digitalocean\_token) | n/a | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_domain"></a> [domain](#output\_domain) | n/a |
