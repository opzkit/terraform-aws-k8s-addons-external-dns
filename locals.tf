locals {
  version = "0.14.0"
  yaml = templatefile("${path.module}/external-dns.yaml", {
    name       = var.name
    prefix     = var.txt_prefix
    region     = var.region
    account_id = var.account_id
  })
}
