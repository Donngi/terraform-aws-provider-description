#---------------------------------------------------------------
# Classic Load Balancer Cookie Stickiness Policy
#---------------------------------------------------------------
#
# Classic Load Balancer (ELB) のクッキーベースのセッション固定
# (スティッキーセッション) ポリシーを管理します。このポリシーにより、
# ロードバランサーは特定のユーザーセッションを同じバックエンドインスタンスに
# ルーティングし続けることができます。
#
# セッション固定の仕組み:
# - ロードバランサーが AWSELB という特別なクッキーを生成
# - クッキーにはルーティング先のインスタンス情報が含まれる
# - クッキーの有効期限はこのポリシーで設定した期間
# - クッキーが存在する間、同じインスタンスにリクエストが送信される
#
# 注意事項:
# - HTTP/HTTPS リスナーでのみ使用可能
# - ポリシー作成後、set-load-balancer-policies-of-listener で
#   リスナーに関連付ける必要があります
# - Classic Load Balancer (aws_elb) 専用のリソースです
# - Application/Network Load Balancer では使用できません
#
# AWS公式ドキュメント:
#   - Classic Load Balancer のスティッキーセッション設定: https://docs.aws.amazon.com/elasticloadbalancing/latest/classic/elb-sticky-sessions.html
#   - CreateLBCookieStickinessPolicy API: https://docs.aws.amazon.com/elasticloadbalancing/2012-06-01/APIReference/API_CreateLBCookieStickinessPolicy.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_cookie_stickiness_policy
#
# Provider Version: 6.28.0
# Generated: 2026-01-28
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_lb_cookie_stickiness_policy" "example" {
  #---------------------------------------------------------------
  # 必須パラメータ
  #---------------------------------------------------------------

  # (必須) スティッキーポリシーの名前
  # - ロードバランサー内で一意である必要があります
  # - ポリシーを識別するための任意の名前を指定
  # - 例: "my-duration-cookie-policy"
  name = "example-stickiness-policy"

  # (必須) ポリシーをアタッチするロードバランサーの名前または ID
  # - aws_elb リソースの name または id を指定
  # - 例: aws_elb.main.name または aws_elb.main.id
  load_balancer = "example-load-balancer"

  # (必須) ポリシーを適用するロードバランサーのポート番号
  # - リスナーとして設定されているポート番号を指定
  # - HTTP は 80、HTTPS は 443 が一般的
  # - 指定したポートは既にリスナーとして存在している必要があります
  # - 例: 80, 443, 8080
  lb_port = 80

  #---------------------------------------------------------------
  # オプションパラメータ
  #---------------------------------------------------------------

  # (オプション) クッキーの有効期限 (秒単位)
  # - セッションクッキーが無効とみなされるまでの時間を指定
  # - 指定しない場合、ブラウザセッションの継続期間中有効
  # - ロードバランサーはクッキーの有効期限を更新しません
  # - クッキー期限切れ後は新しいインスタンスへのルーティングが可能
  # - 例: 600 (10分), 3600 (1時間), 86400 (24時間)
  # cookie_expiration_period = 600

  # (オプション) このリソースを管理するリージョン
  # - 指定しない場合はプロバイダー設定のリージョンが使用されます
  # - 通常は指定不要です
  # region = "us-east-1"
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用)
#---------------------------------------------------------------
# 以下の属性は Terraform によって自動的に設定され、
# 他のリソースから参照可能です。
#
# - id
#   ポリシーの ID
#   形式: "{load_balancer}:{policy_name}"
#   例: aws_lb_cookie_stickiness_policy.example.id
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# 使用例
#---------------------------------------------------------------
# resource "aws_elb" "main" {
#   name               = "example-elb"
#   availability_zones = ["us-east-1a", "us-east-1b"]
#
#   listener {
#     instance_port     = 8000
#     instance_protocol = "http"
#     lb_port           = 80
#     lb_protocol       = "http"
#   }
#
#   health_check {
#     healthy_threshold   = 2
#     unhealthy_threshold = 2
#     timeout             = 3
#     target              = "HTTP:8000/"
#     interval            = 30
#   }
#
#   tags = {
#     Name = "example-elb"
#   }
# }
#
# resource "aws_lb_cookie_stickiness_policy" "example" {
#   name                     = "example-stickiness-policy"
#   load_balancer            = aws_elb.main.id
#   lb_port                  = 80
#   cookie_expiration_period = 600  # 10分
# }
#
# # ポリシーをリスナーに関連付け (AWS CLI で実行)
# # aws elb set-load-balancer-policies-of-listener \
# #   --load-balancer-name example-elb \
# #   --load-balancer-port 80 \
# #   --policy-names example-stickiness-policy
#---------------------------------------------------------------

#---------------------------------------------------------------
# 補足情報
#---------------------------------------------------------------
# スティッキーセッションの動作:
# 1. ロードバランサーがリクエストを受信
# 2. AWSELB クッキーの有無を確認
# 3. クッキーあり: クッキーに記載されたインスタンスにルーティング
# 4. クッキーなし: ロードバランシングアルゴリズムで選択
# 5. レスポンスに新しい AWSELB クッキーを挿入
#
# CORS対応:
# - CORS リクエストの場合、SameSite=None; Secure 属性が必要
# - ロードバランサーは AWSELBCORS という追加クッキーも作成
# - クライアントは両方のクッキーを受け取ります
#
# インスタンス障害時の動作:
# - 障害インスタンスへのルーティングは停止
# - 新しい正常なインスタンスが選択される
# - セッションは新しいインスタンスに「固定」される
#
# 制約事項:
# - duration-based セッションでは secure/HttpOnly フラグは設定不可
# - アンダースコアは %5F に URI エンコードされます
# - 異なるバックエンドポートのリスナーに切り替えると固定が失われます
#---------------------------------------------------------------
