locals {
  zone       = "example.com"
  name       = "k8s.${local.zone}"
  region     = "eu-west-1"
  account_id = "012345678901"
}

resource "aws_iam_role" "kubernetes_admin" {
  assume_role_policy = jsonencode({
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Condition = {}
        Effect    = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${local.account_id}:root"
        }
      },
    ]
    Version = "2012-10-17"
  })
  description = "Kubernetes administrator role (for AWS IAM Authenticator for Kubernetes)."
}

module "external_dns" {
  source     = "../.."
  account_id = local.account_id
  name       = local.name
  region     = local.region
}

module "state_store" {
  source           = "github.com/opzkit/terraform-aws-kops-state-store?ref=v0.6.1"
  state_store_name = "some-kops-storage-s3-bucket"
}

module "k8s-network" {
  source              = "github.com/opzkit/terraform-aws-k8s-network?ref=v0.2.1"
  name                = local.name
  region              = local.region
  public_subnet_zones = ["a", "b", "c"]
  vpc_cidr            = "172.20.0.0/16"
}

module "k8s" {
  depends_on         = [module.state_store]
  source             = "github.com/opzkit/terraform-aws-k8s?ref=v0.32.0"
  name               = local.name
  region             = local.region
  dns_zone           = local.zone
  kubernetes_version = "1.21.5"
  control_plane = {
    size = {
      a : {
        min : 1
        max : 2
      }
      b : {
        min : 1
        max : 2
      }
      c : {
        min : 1
        max : 2
      }
    }
  }
  vpc_id             = module.k8s-network.vpc.id
  public_subnets     = module.k8s-network.subnets.public
  iam_role_mappings  = {}
  bucket_state_store = module.state_store.bucket
  admin_ssh_key      = "../dummy_ssh_private"
  service_account_external_permissions = [
    module.external_dns.permissions
  ]
  extra_addons = module.external_dns.addons
}
