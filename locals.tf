locals {
  yaml = templatefile("${path.module}/external-dns.yaml", {
    name       = var.name
    region     = var.region
    account_id = var.account_id
  })
}
