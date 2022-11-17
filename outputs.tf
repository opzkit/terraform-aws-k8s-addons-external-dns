output "permissions" {
  value = {
    name      = "external-dns"
    namespace = "kube-system"
    aws = {
      inline_policy = <<EOT
    [
      {
        "Effect": "Allow",
        "Action": [
          "route53:ChangeResourceRecordSets"
        ],
        "Resource": [
          "arn:aws:route53:::hostedzone/*"
        ]
      },
      {
        "Effect": "Allow",
        "Action": [
          "route53:ListHostedZones",
          "route53:ListResourceRecordSets"
        ],
        "Resource": [
          "*"
        ]
      }
    ]
    EOT
    }
  }

}

output "addon" {
  value = {
    name : "external-dns"
    version : "0.13.1"
    content : local.yaml
  }
}
