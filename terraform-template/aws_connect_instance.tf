# Terraform AWS Provider Resource: aws_connect_instance
#
# リソースタイプ: aws_connect_instance
# 最終更新日: 2026-02-13
# AWS Provider Version: 6.28.0
# Generated: 2026-02-13
# Terraform Registry: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/connect_instance
#
# 本リソースは、Amazon Connect インスタンスを作成・管理します。
# Amazon Connect は、顧客とのやり取りを簡単かつスケーラブルに管理できる
# クラウドベースのコンタクトセンターサービスです。
#
# NOTE:
# - Amazon Connect は、30日間で最大100個のインスタンス作成・削除の制限があります
# - 例: 80個作成して20個削除した場合、次の作成・削除まで30日間待つ必要があります
# - インスタンスの作成・削除は慎重に行ってください
#
# 参照: https://docs.aws.amazon.com/connect/latest/adminguide/amazon-connect-get-started.html
# 参照: https://docs.aws.amazon.com/connect/latest/adminguide/amazon-connect-service-limits.html#feature-limits

#-----------------------------------------------------------------------
# 基本設定
#-----------------------------------------------------------------------

resource "aws_connect_instance" "example" {
  # 設定内容: ID管理タイプの指定（必須）
  # 設定可能な値:
  #   - SAML: SAML 2.0ベースの認証を使用
  #   - CONNECT_MANAGED: Amazon Connect が管理するユーザーディレクトリを使用
  #   - EXISTING_DIRECTORY: 既存の AWS Directory Service ディレクトリを使用
  identity_management_type = "CONNECT_MANAGED"

  # 設定内容: 着信通話の有効化（必須）
  # 設定可能な値: true または false
  inbound_calls_enabled = true

  # 設定内容: 発信通話の有効化（必須）
  # 設定可能な値: true または false
  outbound_calls_enabled = true

  #-----------------------------------------------------------------------
  # インスタンス識別設定
  #-----------------------------------------------------------------------

  # 設定内容: インスタンスのエイリアス名
  # 省略時: directory_id が指定されている場合は省略可能
  # 注意: directory_id を指定しない場合は必須
  instance_alias = "my-connect-instance"

  # 設定内容: 既存ディレクトリのID
  # 省略時: 新規にディレクトリが作成されます
  # 注意: identity_management_type が EXISTING_DIRECTORY の場合に使用
  directory_id = "d-1234567890"

  #-----------------------------------------------------------------------
  # 機能設定
  #-----------------------------------------------------------------------

  # 設定内容: 自動音声最適化の有効化
  # 設定可能な値: true または false
  # 省略時: true
  auto_resolve_best_voices_enabled = true

  # 設定内容: コンタクトフローログの有効化
  # 設定可能な値: true または false
  # 省略時: false
  contact_flow_logs_enabled = false

  # 設定内容: Contact Lens 機能の有効化
  # 設定可能な値: true または false
  # 省略時: true
  # 注意: Contact Lens は、通話分析や感情分析などの高度な機能を提供します
  contact_lens_enabled = true

  # 設定内容: アーリーメディア（早期音声）の有効化
  # 設定可能な値: true または false
  # 省略時: outbound_calls_enabled が true の場合は true
  # 注意: 発信通話開始前に音声ガイダンスを再生できます
  early_media_enabled = true

  # 設定内容: マルチパーティ会議通話の有効化
  # 設定可能な値: true または false
  # 省略時: false
  multi_party_conference_enabled = false

  #-----------------------------------------------------------------------
  # リージョン設定
  #-----------------------------------------------------------------------

  # 設定内容: リソースが管理されるAWSリージョン
  # 省略時: プロバイダー設定のリージョンが使用されます
  # 参照: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = "us-east-1"

  #-----------------------------------------------------------------------
  # タグ設定
  #-----------------------------------------------------------------------

  # 設定内容: インスタンスに付与するタグ
  # 省略時: タグなし
  # 注意: provider の default_tags と統合されます
  tags = {
    Name        = "MyConnectInstance"
    Environment = "production"
    ManagedBy   = "Terraform"
  }

  #-----------------------------------------------------------------------
  # タイムアウト設定
  #-----------------------------------------------------------------------

  # timeouts {
  #   # 設定内容: インスタンス作成のタイムアウト時間
  #   # 省略時: デフォルトのタイムアウト値が使用されます
  #   create = "5m"
  #
  #   # 設定内容: インスタンス削除のタイムアウト時間
  #   # 省略時: デフォルトのタイムアウト値が使用されます
  #   delete = "5m"
  # }
}

#-----------------------------------------------------------------------
# Attributes Reference
#-----------------------------------------------------------------------
# 以下の属性がエクスポートされ、他のリソースから参照可能です:
#
# - id: インスタンスの一意識別子
# - arn: インスタンスのAmazon Resource Name (ARN)
# - created_time: インスタンスが作成された日時
# - service_role: インスタンスのサービスロール
# - status: インスタンスの状態
# - tags_all: リソースに割り当てられた全てのタグ（provider default_tags を含む）
#
# 参照例:
#   aws_connect_instance.example.id
#   aws_connect_instance.example.arn
#   aws_connect_instance.example.status
