#---------------------------------------------------------------
# Lightsail Load Balancer Stickiness Policy
#---------------------------------------------------------------
#
# Lightsailロードバランサーのセッション粘着性（スティッキネス）ポリシーを管理します。
# セッション粘着性を有効にすることで、ユーザーセッションが一貫して同じバックエンド
# インスタンスにルーティングされるようになり、サーバー上でセッションデータをローカルに
# 保存するアプリケーション（例：ショッピングカートを含むEコマースサイト）のセッション
# 状態を維持できます。
#
# AWS公式ドキュメント:
#   - Enable session persistence for Lightsail load balancers: https://docs.aws.amazon.com/lightsail/latest/userguide/enable-session-stickiness-persistence-or-change-cookie-duration.html
#   - Load balancers FAQ: https://docs.aws.amazon.com/lightsail/latest/userguide/amazon-lightsail-faq-load-balancers.html
#   - Understanding Lightsail load balancers: https://docs.aws.amazon.com/lightsail/latest/userguide/understanding-lightsail-load-balancers.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lightsail_lb_stickiness_policy
#
# Provider Version: 6.28.0
# Generated: 2026-01-28
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_lightsail_lb_stickiness_policy" "example" {
  #---------------------------------------------------------------
  # Required Arguments
  #---------------------------------------------------------------

  # lb_name - (Required) セッション粘着性を有効にするロードバランサーの名前。
  # 既存のLightsailロードバランサーのリソース名を指定します。
  # 例: aws_lightsail_lb.example.name
  lb_name = "example-load-balancer"

  # cookie_duration - (Required) Cookie の有効期間（秒単位）。
  # この値により、セッション粘着性の持続時間が決まります。
  # ユーザーの最後のリクエストから指定された秒数が経過すると、
  # セッションの粘着性は失われ、次のリクエストは通常のロードバランシング
  # アルゴリズムに基づいて新しいターゲットインスタンスにルーティングされます。
  #
  # 一般的な値:
  #   - 900秒（15分）: 短いセッション向け
  #   - 3600秒（1時間）: 標準的なウェブアプリケーション
  #   - 86400秒（24時間）: 長時間のセッション向け
  #
  # 注意:
  #   - ロードバランサーはCookieの有効期限を更新しません
  #   - この時間が経過すると自動的にセッションが切れます
  cookie_duration = 900

  # enabled - (Required) ロードバランサーのセッション粘着性を有効にするかどうか。
  # true: セッション粘着性を有効化（推奨：セッション状態を保持する必要がある場合）
  # false: セッション粘着性を無効化（デフォルトのラウンドロビン動作に戻る）
  #
  # 使用シナリオ:
  #   - true: ショッピングカート、ユーザー設定、ログイン状態など、
  #           サーバー側でセッションデータを保持するアプリケーション
  #   - false: ステートレスなアプリケーション、または外部データストア
  #           （Redis、データベースなど）でセッションを管理する場合
  enabled = true

  #---------------------------------------------------------------
  # Optional Arguments
  #---------------------------------------------------------------

  # id - (Optional) リソースのID。
  # 指定しない場合は、Terraformが自動的に一意のIDを生成します。
  # 通常は明示的に設定する必要はありません。
  #
  # 注意: このフィールドはcomputedでもあるため、指定しなくても
  # リソース作成後に自動的に値が設定されます（lb_nameと同じ値）
  # id = "example-load-balancer"

  # region - (Optional) このリソースが管理されるAWSリージョン。
  # 指定しない場合は、プロバイダー設定で指定されたリージョンが使用されます。
  #
  # リージョナルエンドポイント:
  #   https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  #
  # プロバイダー設定リファレンス:
  #   https://registry.terraform.io/providers/hashicorp/aws/latest/docs#aws-configuration-reference
  #
  # 例: "us-east-1", "ap-northeast-1", "eu-west-1"
  #
  # 注意: 通常はプロバイダーレベルで設定するため、明示的な指定は不要です
  # region = "us-east-1"
}

#---------------------------------------------------------------
# Attributes Reference
#---------------------------------------------------------------
# このリソースは、上記の引数に加えて以下の属性をエクスポートします:
#
# - id - ロードバランサーの名前（lb_name と同じ値）
#
# これらの属性は computed のみであり、設定ファイルで指定することはできません。
# 他のリソースやデータソースで参照する際に使用できます。
#
# 使用例:
#   output "stickiness_policy_id" {
#     value = aws_lightsail_lb_stickiness_policy.example.id
#   }
#---------------------------------------------------------------

#---------------------------------------------------------------
# Import
#---------------------------------------------------------------
# 既存のLightsail Load Balancer Stickiness Policyは、
# ロードバランサー名を使用してインポートできます:
#
#   terraform import aws_lightsail_lb_stickiness_policy.example example-load-balancer
#
# インポート後、terraform state show コマンドで現在の設定を確認できます:
#
#   terraform state show aws_lightsail_lb_stickiness_policy.example
#---------------------------------------------------------------
