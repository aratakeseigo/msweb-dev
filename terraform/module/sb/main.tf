# tfvarsの値を２次加工する
locals{

  ecs_cluster_name = "securebox-${ var.stage }-cluster"

}

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

# クラスター
resource "aws_ecs_cluster" "securebox" {
  name = "${local.ecs_cluster_name}"
}
