#---------------------------------------------------------------
# AWS LB Cookie Stickiness Policy (Classic Load Balancer)
#---------------------------------------------------------------
#
# Classic Load Balancer (CLB) のロードバランサー生成 Cookie を使用した
# スティッキネスポリシーを管理するリソースです。
# このポリシーにより、同一クライアントからのリクエストを同じバックエンドインスタンスに
# 転送し続けるセッション固定（スティッキネス）を実現します。
#
# NOTE: このリソースは Classic Load Balancer (CLB) 専用です。
#       Application Load Balancer (ALB) のスティッキネスには、
#       aws_lb_target_group リソースの stickiness ブロックを使用してください。
#
# Cookie の動作:
#   - ロードバランサーが自動的に Cookie を生成・管理します。
#   - アプリケーション側での Cookie 実装は不要です。
#   - cookie_expiration_period を設定することで Cookie の有効期限を制御できます。
#   - 省略時はブラウザセッション中のみ有効な Cookie が生成されます。
#
# AWS公式ドキュメント:
#   - スティッキーセッション: https://docs.aws.amazon.com/elasticloadbalancing/latest/classic/elb-sticky-sessions.html
#   - CLB ポリシー: https://docs.aws.amazon.com/elasticloadbalancing/latest/classic/elb-sticky-sessions.html#enable-sticky-sessions-duration
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_cookie_stickiness_policy
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_lb_cookie_stickiness_policy" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: スティッキネスポリシーの名前を指定します。
  # 設定可能な値: 英数字とハイフンを含む文字列
  # 注意: 同じロードバランサー内で一意である必要があります。
  name = "my-lb-cookie-stickiness-policy"

  # load_balancer (Required)
  # 設定内容: ポリシーを適用する Classic Load Balancer の名前を指定します。
  # 設定可能な値: aws_elb リソースの name 属性の値
  # 注意: このリソースは Classic Load Balancer 専用です。
  load_balancer = aws_elb.example.name

  # lb_port (Required)
  # 設定内容: ポリシーを適用するロードバランサーのリスナーポートを指定します。
  # 設定可能な値: 有効なポート番号（例: 80, 443）
  # 注意: ポートは CLB リスナーで定義されているポートと一致する必要があります。
  lb_port = 80

  #-------------------------------------------------------------
  # Cookie 設定
  #-------------------------------------------------------------

  # cookie_expiration_period (Optional)
  # 設定内容: ロードバランサーが生成する Cookie の有効期間（秒）を指定します。
  # 設定可能な値: 正の整数（秒単位）
  # 省略時: ブラウザセッションが終了するまで有効な Cookie を生成します（セッション Cookie）。
  # 注意: 0 を指定した場合はセッション Cookie と同等の動作になります。
  cookie_expiration_period = 3600

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効な AWS リージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用します。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: ポリシーの ID
#
# - name: スティッキネスポリシーの名前
#
# - load_balancer: ポリシーが定義されているロードバランサー名
#
# - lb_port: ポリシーが適用されているリスナーポート
#
# - cookie_expiration_period: Cookie の有効期間（秒）
#---------------------------------------------------------------
