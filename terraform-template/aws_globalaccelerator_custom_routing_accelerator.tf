################################################################################
# AWS Global Accelerator - Custom Routing Accelerator
# リソース: aws_globalaccelerator_custom_routing_accelerator
# Provider Version: 6.28.0
#
# 概要:
# AWS Global Accelerator のカスタムルーティングアクセラレータを作成します。
# カスタムルーティングアクセラレータは、独自のアプリケーションロジックを使用して
# ユーザートラフィックを VPC サブネット内の特定の EC2 インスタンスに直接ルーティング
# できます。ゲームアプリケーションや VoIP セッションなど、複数のユーザーを特定の
# EC2 インスタンスとポートの同じセッションで対話させる必要があるアプリケーションに
# 最適です。
#
# ユースケース:
# - ゲームサーバーのマッチメイキング
# - VoIP アプリケーション
# - リアルタイムマルチプレイヤーアプリケーション
# - 特定の EC2 インスタンスへの決定論的なトラフィックルーティング
#
# 注意事項:
# - カスタムルーティングアクセラレータは IPv4 アドレスのみをサポート
# - デフォルトでは全ての VPC サブネット宛先はトラフィックを受信できない設定
# - Global Accelerator API を通じて特定の宛先へのトラフィックを許可/拒否可能
# - アクセラレータが削除されると、静的 IP アドレスは失われます
#
# 参考ドキュメント:
# - https://docs.aws.amazon.com/global-accelerator/latest/dg/about-custom-routing-accelerators.html
# - https://docs.aws.amazon.com/global-accelerator/latest/dg/about-custom-routing-how-it-works.html
# - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/globalaccelerator_custom_routing_accelerator
################################################################################

resource "aws_globalaccelerator_custom_routing_accelerator" "example" {
  ################################################################################
  # 必須パラメータ
  ################################################################################

  # アクセラレータ名
  # カスタムルーティングアクセラレータの名前を指定します。
  #
  # 用途: アクセラレータを識別するための分かりやすい名前
  # 例: "game-server-accelerator", "voip-accelerator"
  name = "example-custom-routing-accelerator"

  ################################################################################
  # オプションパラメータ - アクセラレータ設定
  ################################################################################

  # IP アドレスタイプ
  # アクセラレータがサポートする IP アドレスタイプを指定します。
  # カスタムルーティングアクセラレータの場合、値は "IPV4" である必要があります。
  #
  # 有効値: "IPV4"
  # デフォルト: "IPV4"
  #
  # 注意: カスタムルーティングアクセラレータは IPv4 のみをサポート
  ip_address_type = "IPV4"

  # IP アドレス
  # BYOIP (Bring Your Own IP) アクセラレータに使用する IP アドレスを指定します。
  # 指定しない場合、サービスが IP アドレスを自動的に割り当てます。
  #
  # 有効値: 1 または 2 つの IPv4 アドレス
  #
  # 用途:
  # - 独自の IP アドレス範囲を使用する場合
  # - 既存の IP アドレスを維持する必要がある場合
  #
  # 注意:
  # - BYOIP を使用するには、事前に IP アドレス範囲を AWS にプロビジョニングする必要があります
  # - 指定しない場合、Global Accelerator が自動的に 2 つの静的 IPv4 アドレスを提供
  ip_addresses = []  # 例: ["1.2.3.4", "5.6.7.8"]

  # 有効化フラグ
  # アクセラレータが有効かどうかを示します。
  #
  # 有効値: true, false
  # デフォルト: true
  #
  # 用途:
  # - アクセラレータを一時的に無効化する場合
  # - メンテナンス時にトラフィックを停止する場合
  #
  # 注意: false に設定すると、トラフィックのルーティングが停止されます
  enabled = true

  ################################################################################
  # オプションパラメータ - アクセラレータ属性
  ################################################################################

  # アクセラレータの属性
  # フローログなどのアクセラレータ属性を設定します。
  attributes {
    # フローログ有効化フラグ
    # フローログを有効にするかどうかを指定します。
    #
    # 有効値: true, false
    # デフォルト: false
    #
    # 用途:
    # - トラフィックフローの監視と分析
    # - セキュリティ監査
    # - トラブルシューティング
    #
    # 注意: true に設定する場合、flow_logs_s3_bucket と flow_logs_s3_prefix が必須
    flow_logs_enabled = false

    # フローログ S3 バケット名
    # フローログを保存する Amazon S3 バケットの名前を指定します。
    # flow_logs_enabled が true の場合は必須です。
    #
    # 用途: フローログの保存先 S3 バケット
    # 例: "my-accelerator-flow-logs-bucket"
    #
    # 注意:
    # - バケットは事前に作成されている必要があります
    # - 適切なバケットポリシーで Global Accelerator からの書き込みを許可する必要があります
    flow_logs_s3_bucket = ""  # 例: "example-flow-logs-bucket"

    # フローログ S3 プレフィックス
    # Amazon S3 バケット内のフローログの保存場所のプレフィックスを指定します。
    # flow_logs_enabled が true の場合は必須です。
    #
    # 用途: S3 バケット内でのフローログの整理
    # 例: "flow-logs/", "accelerator-logs/2024/"
    #
    # 注意: プレフィックスの末尾にスラッシュを含めることを推奨
    flow_logs_s3_prefix = ""  # 例: "flow-logs/"
  }

  ################################################################################
  # タグ
  ################################################################################

  # リソースタグ
  # アクセラレータに割り当てるタグのマップを指定します。
  #
  # 用途:
  # - リソースの分類と管理
  # - コスト配分
  # - 自動化とフィルタリング
  #
  # 注意:
  # - provider の default_tags が設定されている場合、マージされます
  # - tags で指定したタグが優先されます
  tags = {
    Name        = "example-custom-routing-accelerator"
    Environment = "production"
    Application = "gaming"
    ManagedBy   = "terraform"
  }

  ################################################################################
  # 出力属性 (読み取り専用)
  ################################################################################

  # 以下の属性は Terraform によって自動的に設定され、他のリソースで参照可能です:
  #
  # id
  # - アクセラレータの Amazon Resource Name (ARN)
  # - 例: "arn:aws:globalaccelerator::123456789012:accelerator/a1234567-abcd-1234-efgh-1234567890ab"
  #
  # arn
  # - アクセラレータの Amazon Resource Name (ARN)
  # - id と同じ値
  #
  # dns_name
  # - アクセラレータの DNS 名
  # - 例: "a5d53ff5ee6bca4ce.awsglobalaccelerator.com"
  # - 用途: クライアントアプリケーションがこの DNS 名を使用してアクセラレータに接続
  #
  # hosted_zone_id
  # - Global Accelerator の Route 53 ゾーン ID
  # - 値: "Z2BJ6XQ5FK7U4H" (固定値)
  # - 用途: Route 53 エイリアスレコードセットを作成する際に使用
  #
  # ip_sets
  # - アクセラレータに関連付けられた IP アドレスセット
  # - 以下の属性を含む:
  #   - ip_addresses: IP アドレスセット内の IP アドレスのリスト
  #   - ip_family: IP アドレスセットに含まれる IP アドレスのタイプ ("IPv4")
  #
  # tags_all
  # - リソースに割り当てられた全てのタグ (provider の default_tags を含む)
}

################################################################################
# 出力例
################################################################################

# アクセラレータ ARN
output "accelerator_id" {
  description = "カスタムルーティングアクセラレータの ARN"
  value       = aws_globalaccelerator_custom_routing_accelerator.example.id
}

output "accelerator_arn" {
  description = "カスタムルーティングアクセラレータの ARN"
  value       = aws_globalaccelerator_custom_routing_accelerator.example.arn
}

# DNS 名
output "accelerator_dns_name" {
  description = "アクセラレータの DNS 名"
  value       = aws_globalaccelerator_custom_routing_accelerator.example.dns_name
}

# ホストゾーン ID
output "accelerator_hosted_zone_id" {
  description = "Global Accelerator の Route 53 ゾーン ID"
  value       = aws_globalaccelerator_custom_routing_accelerator.example.hosted_zone_id
}

# IP アドレス
output "accelerator_ip_addresses" {
  description = "アクセラレータに割り当てられた IP アドレスのリスト"
  value       = aws_globalaccelerator_custom_routing_accelerator.example.ip_sets[0].ip_addresses
}

# IP ファミリー
output "accelerator_ip_family" {
  description = "IP アドレスセットのタイプ"
  value       = aws_globalaccelerator_custom_routing_accelerator.example.ip_sets[0].ip_family
}

################################################################################
# 使用例: フローログ有効化
################################################################################

# resource "aws_s3_bucket" "flow_logs" {
#   bucket = "my-accelerator-flow-logs"
# }
#
# resource "aws_s3_bucket_policy" "flow_logs" {
#   bucket = aws_s3_bucket.flow_logs.id
#
#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Sid    = "AWSLogDeliveryWrite"
#         Effect = "Allow"
#         Principal = {
#           Service = "globalaccelerator.amazonaws.com"
#         }
#         Action   = "s3:PutObject"
#         Resource = "${aws_s3_bucket.flow_logs.arn}/*"
#       }
#     ]
#   })
# }
#
# resource "aws_globalaccelerator_custom_routing_accelerator" "with_flow_logs" {
#   name            = "accelerator-with-flow-logs"
#   ip_address_type = "IPV4"
#   enabled         = true
#
#   attributes {
#     flow_logs_enabled   = true
#     flow_logs_s3_bucket = aws_s3_bucket.flow_logs.bucket
#     flow_logs_s3_prefix = "flow-logs/"
#   }
#
#   depends_on = [aws_s3_bucket_policy.flow_logs]
# }

################################################################################
# 使用例: BYOIP (Bring Your Own IP)
################################################################################

# # 注意: BYOIP を使用するには、事前に IP アドレス範囲を AWS にプロビジョニングする必要があります
# resource "aws_globalaccelerator_custom_routing_accelerator" "byoip" {
#   name            = "byoip-accelerator"
#   ip_address_type = "IPV4"
#   ip_addresses    = ["192.0.2.1", "192.0.2.2"]  # 事前にプロビジョニングされた BYOIP アドレス
#   enabled         = true
#
#   tags = {
#     Name = "byoip-custom-routing-accelerator"
#   }
# }

################################################################################
# 関連リソース
################################################################################

# カスタムルーティングアクセラレータを完全に機能させるには、以下のリソースも必要です:
#
# 1. aws_globalaccelerator_custom_routing_listener
#    - カスタムルーティングアクセラレータのリスナーを定義
#    - ポート範囲とプロトコルを指定
#
# 2. aws_globalaccelerator_custom_routing_endpoint_group
#    - エンドポイントグループを定義
#    - VPC サブネットエンドポイントを指定
#    - 宛先ポート範囲とプロトコルを設定
#
# 3. aws_globalaccelerator_custom_routing_endpoint
#    - VPC サブネット内の特定のエンドポイントを定義
#
# 完全な設定例:
# accelerator → listener → endpoint_group → subnet endpoints

################################################################################
# インポート
################################################################################

# 既存のカスタムルーティングアクセラレータは ARN を使用してインポートできます:
# terraform import aws_globalaccelerator_custom_routing_accelerator.example arn:aws:globalaccelerator::123456789012:accelerator/a1234567-abcd-1234-efgh-1234567890ab

################################################################################
# ベストプラクティス
################################################################################

# 1. フローログの有効化
#    - セキュリティ監査とトラブルシューティングのためにフローログを有効化
#    - S3 バケットのライフサイクルポリシーでログを管理
#
# 2. タグ付け戦略
#    - 環境、アプリケーション、コスト配分のための一貫したタグ付け
#    - Name タグを必ず設定
#
# 3. IAM ポリシー
#    - アクセラレータの削除を制限する IAM ポリシーを設定
#    - 最小権限の原則に従う
#
# 4. 監視とアラート
#    - CloudWatch メトリクスで接続数とトラフィックを監視
#    - 異常なトラフィックパターンに対するアラートを設定
#
# 5. 高可用性
#    - Global Accelerator は 2 つの静的 IP アドレスを提供 (異なるネットワークゾーン)
#    - クライアントアプリケーションで両方の IP アドレスを使用したリトライロジックを実装
#
# 6. コスト最適化
#    - 使用していないアクセラレータは無効化または削除
#    - フローログの保存期間を適切に設定
