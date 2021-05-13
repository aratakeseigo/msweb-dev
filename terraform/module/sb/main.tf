
variable "domain" {
  description = "Route 53 で管理しているドメイン名"
  type        = string
  default = "alarmbox.jp"
}

# Route53 Hosted Zone
# https://www.terraform.io/docs/providers/aws/d/route53_zone.html
data "aws_route53_zone" "main" {
  name         = "${var.domain}"
  private_zone = false
}
