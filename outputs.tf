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
          "route53:ListResourceRecordSets",
          "route53:ListTagsForResource"
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
    version : "0.14.0"
    content : local.yaml
  }
}
