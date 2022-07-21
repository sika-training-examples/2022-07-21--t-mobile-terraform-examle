resource "null_resource" "prevent_destroy" {
  lifecycle {
    prevent_destroy = true
  }
  depends_on = [
    digitalocean_database_db.example-foo,
  ]
}
