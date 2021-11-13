# terraform-aws-k8s-addons-external-dns

A terraform module which provides
the [IRSA external permissions](https://kops.sigs.k8s.io/cluster_spec/#service-account-issuer-discovery-and-aws-iam-roles-for-service-accounts-irsa)
and the [custom addon](https://kops.sigs.k8s.io/addons/#custom-addons)
for [external-dns](https://github.com/kubernetes-sigs/external-dns) to be used together
with [opzkit/k8s/aws](https://registry.terraform.io/modules/opzkit/k8s/aws/latest).

