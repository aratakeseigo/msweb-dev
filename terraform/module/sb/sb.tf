locals{
  # イメージはタグを指定しないとlatestがついてエラーになるため、
  # 古いタグを指定しています。適宜変更するか、環境変更後にデプロイする必要があります。
  resource_prefix = "sb-${ var.stage }"
  securebox={
    lb_name = "${local.resource_prefix}"
    ecs_task_name = "${local.resource_prefix}"
    ecs_service_name = "${local.resource_prefix}-service"
    ecs_cluster_name = "${local.resource_prefix}-cluster"
    domain = "${ var.stage == "production" ? "" : "${ var.stage }." }securebox.${var.domain}"
    ecr_image_url = "843409087087.dkr.ecr.ap-northeast-1.amazonaws.com/securebox/sb:develop-67f7a99a87389049359e02c25b698839fc791450"
    log_group = "/ecs/${var.stage}/securebox/sb"
  }
}

resource "aws_s3_bucket" "securebox-bucket" {
  bucket = "securebox-${ var.stage }"
  versioning {
    enabled = true
  }
}


# クラスター
resource "aws_ecs_cluster" "securebox" {
  name = "${local.securebox.ecs_cluster_name}"
}


# ALB
# https://www.terraform.io/docs/providers/aws/d/lb.html
resource "aws_lb" "securebox" {
  load_balancer_type = "application"
  name               = "${local.securebox.lb_name}"

  security_groups = ["${var.alb_seculity_group_id}"]
  subnets         = "${var.aws_subnets}"
}


# Listener
# https://www.terraform.io/docs/providers/aws/r/lb_listener.html
resource "aws_lb_listener" "securebox" {
  # HTTPでのアクセスを受け付ける
  port              = "80"
  protocol          = "HTTP"

  # ALBのarnを指定します。
  load_balancer_arn = "${aws_lb.securebox.arn}"

  # "ok" という固定レスポンスを設定する(ダミー設定)
  default_action {
    type             = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      status_code  = "200"
      message_body = "ok"
    }
  }
}


resource "aws_ecs_task_definition" "securebox" {
  family = "${local.securebox.ecs_task_name}"

  # データプレーンの選択
  requires_compatibilities = ["FARGATE"]

  # ECSタスクが使用可能なリソースの上限
  # タスク内のコンテナはこの上限内に使用するリソースを収める必要があり、メモリが上限に達した場合OOM Killer にタスクがキルされる
  cpu    = 1024
  memory = 4096

  # ECSタスクのネットワークドライバ
  # Fargateを使用する場合は"awsvpc"決め打ち
  network_mode = "awsvpc"

  # Amazon ECS タスク実行 IAM ロール
  execution_role_arn = "${var.ecr_execution_role_arn}"


  # 起動するコンテナの定義
  container_definitions = <<EOL
[
  {
    "name": "${local.securebox.ecs_task_name}",
    "image": "${local.securebox.ecr_image_url}",
    "cpu": 1024,
    "memoryReservation": 4096,
    "portMappings": [
      {
        "containerPort": 3000
      }
    ],
    "environment": [
      {"name": "RAILS_ENV", "value": "production"},
      {"name": "RAILS_LOG_TO_STDOUT", "value": "true"},
      {
        "name": "RAILS_SERVE_STATIC_FILES",
        "value": "true"
      },
      {
        "name": "AWS_S3_BUCKET",
        "value": "securebox-${var.stage}"
      }
    ],
    "secrets": [
      {
        "name": "DATABASE_HOST",
        "valueFrom": "/ecs/${var.stage}/DATABASE_HOST"
      },
      {
        "name": "DATABASE_NAME",
        "valueFrom": "/ecs/${var.stage}/DATABASE_NAME"
      },
      {
        "name": "DATABASE_PASSWORD",
        "valueFrom": "/ecs/${var.stage}/DATABASE_PASSWORD"
      },
      {
        "name": "DATABASE_PORT",
        "valueFrom": "/ecs/${var.stage}/DATABASE_PORT"
      },
      {
        "name": "DATABASE_USERNAME",
        "valueFrom": "/ecs/${var.stage}/DATABASE_USERNAME"
      },
      {
        "name": "AWS_ACCESSKEY",
        "valueFrom": "/ecs/${var.stage}/AWS_ACCESSKEY"
      },
      {
        "name": "AWS_SECRET_KEY",
        "valueFrom": "/ecs/${var.stage}/AWS_SECRET_KEY"
      },
      {
        "name": "RAILS_MASTER_KEY",
        "valueFrom": "/ecs/${var.stage}/securebox/RAILS_MASTER_KEY"
      }    ],
    "logConfiguration": {
      "logDriver": "awslogs",
      "secretOptions": null,
      "options": {
        "awslogs-group": "${local.securebox.log_group}",
        "awslogs-region": "${var.aws_region}",
        "awslogs-stream-prefix": "ecs"
      }
    }
  }
]
EOL
}




# ELB Target Group
# https://www.terraform.io/docs/providers/aws/r/lb_target_group.html
resource "aws_lb_target_group" "securebox" {
  name = "${local.securebox.ecs_service_name}"

  # ターゲットグループを作成するVPC
  vpc_id = "${var.aws_vpc_id}"

  # ALBからECSタスクのコンテナへトラフィックを振り分ける設定
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"

  # コンテナへの死活監視設定
  health_check  {
    port = 3000
    path = "/ok.html"
  }
}

# ECS Service
# https://www.terraform.io/docs/providers/aws/r/ecs_service.html
resource "aws_ecs_service" "securebox" {
  name = "${local.securebox.ecs_service_name}"

  # 依存関係の記述。
  # "aws_lb_listener_rule.main" リソースの作成が完了するのを待ってから当該リソースの作成を開始する。
  depends_on = [aws_lb_listener_rule.securebox-https]

  # 当該ECSサービスを配置するECSクラスターの指定
  cluster = "${aws_ecs_cluster.securebox.name}"

  # データプレーンとしてFargateを使用する
  launch_type = "FARGATE"

  # 実環境と違っても変更対象としない
  lifecycle {
    ignore_changes = [
      # desired_count,
      task_definition,
    ]
  }

  # ECSタスクの起動数を定義
  desired_count = "1"

  # 起動するECSタスクのタスク定義
  task_definition = "${aws_ecs_task_definition.securebox.arn}"
  deployment_minimum_healthy_percent = 100
  deployment_maximum_percent         = 200

  # ECSタスクへ設定するネットワークの設定
  network_configuration  {
    # タスクの起動を許可するサブネット
    subnets         = "${var.aws_subnets}"
    # タスクに紐付けるセキュリティグループ
    security_groups = ["${var.ecs_seculity_group_id}"]
    # パブリックIPの割当
    assign_public_ip = "true"
  }

  # ECSタスクの起動後に紐付けるELBターゲットグループ
  load_balancer {
      target_group_arn = "${aws_lb_target_group.securebox.arn}"
      container_name   = "${local.securebox.ecs_task_name}"
      container_port   = "3000"
    }
}


resource "aws_route53_record" "securebox" {
  zone_id = "${data.aws_route53_zone.main.id}"
  name    = "${local.securebox.domain}"
  type    = "A"
  alias {
    name                   = aws_lb.securebox.dns_name
    zone_id                = aws_lb.securebox.zone_id
    evaluate_target_health = true
  }
}

############## HTTPS化 ##############
# ACM
# https://www.terraform.io/docs/providers/aws/r/acm_certificate.html
resource "aws_acm_certificate" "securebox" {
  domain_name = "${local.securebox.domain}"

  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

# Route53 record
# https://www.terraform.io/docs/providers/aws/r/route53_record.html
resource "aws_route53_record" "securebox-validation" {
  depends_on = [aws_acm_certificate.securebox]

  zone_id = "${data.aws_route53_zone.main.id}"

  ttl = 60

  name    = "${aws_acm_certificate.securebox.domain_validation_options.0.resource_record_name}"
  type    = "${aws_acm_certificate.securebox.domain_validation_options.0.resource_record_type}"
  records = ["${aws_acm_certificate.securebox.domain_validation_options.0.resource_record_value}"]
}

# ACM Validate
# https://www.terraform.io/docs/providers/aws/r/acm_certificate_validation.html
resource "aws_acm_certificate_validation" "securebox-https-cert" {
  certificate_arn = "${aws_acm_certificate.securebox.arn}"

  validation_record_fqdns = ["${aws_route53_record.securebox-validation.fqdn}"]
}

##########################
# HTTPSでリスナーを作成
# Listener
# https://www.terraform.io/docs/providers/aws/r/lb_listener.html
resource "aws_lb_listener" "securebox-https" {
  depends_on = [aws_acm_certificate.securebox]

  # ALBのarnを指定します。
  load_balancer_arn = "${aws_lb.securebox.arn}"

  certificate_arn = "${aws_acm_certificate.securebox.arn}"

  port     = "443"
  protocol = "HTTPS"

  default_action {
    type             = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      status_code  = "404"
    }
  }
}

# 受け付けるパスを指定(最大５パターン)
resource "aws_lb_listener_rule" "securebox-https" {
  listener_arn = "${aws_lb_listener.securebox-https.arn}"
  # 受け取ったトラフィックをターゲットグループへ受け渡す
  action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.securebox.id}"
  }

  # ターゲットグループへ受け渡すトラフィックの条件
  condition {
    path_pattern {
      values = ["*"]
    }
  }
}

# httpをリダイレクト
resource "aws_lb_listener_rule" "securebox-http_to_https" {
  listener_arn = "${aws_lb_listener.securebox.arn}"

  action {
    type = "redirect"
     redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
  condition {
    path_pattern {
      values = ["*"]
    }
  }
}
