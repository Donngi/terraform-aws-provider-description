#---------------------------------------------------------------
# AWS AppIntegrations Event Integration
#---------------------------------------------------------------
#
# Amazon AppIntegrationsのイベント統合をプロビジョニングするリソースです。
# イベント統合は、Amazon EventBridgeパートナーイベントソースからの
# イベントをキャプチャし、Amazon Connectなどのサービスと連携させます。
#
# AWS公式ドキュメント:
#   - AppIntegrations API Reference: https://docs.aws.amazon.com/connect/latest/APIReference/API_connect-app-integrations_EventIntegration.html
#   - EventBridge Partner Event Sources: https://docs.aws.amazon.com/eventbridge/latest/userguide/eb-saas.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appintegrations_event_integration
#
# Provider Version: 6.28.0
# Generated: 2026-01-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_appintegrations_event_integration" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required, Forces new resource)
  # 設定内容: イベント統合の名前を指定します。
  # 設定可能な値: 1-255文字の文字列（パターン: ^[a-zA-Z0-9\/\._\-]+$）
  name = "my-event-integration"

  # description (Optional)
  # 設定内容: イベント統合の説明を指定します。
  # 設定可能な値: 0-1000文字の文字列
  description = "Example Event Integration for partner events"

  #-------------------------------------------------------------
  # EventBridge設定
  #-------------------------------------------------------------

  # eventbridge_bus (Required)
  # 設定内容: イベントを受信するEventBridgeバスの名前を指定します。
  # 設定可能な値: 1-255文字の文字列（パターン: ^[a-zA-Z0-9\/\._\-]+$）
  # 注意: "default"バスまたはカスタムイベントバスの名前を指定可能
  eventbridge_bus = "default"

  #-------------------------------------------------------------
  # イベントフィルター設定
  #-------------------------------------------------------------

  # event_filter (Required)
  # 設定内容: イベントをフィルタリングするための設定ブロック。
  # 必須ブロック: 1つのevent_filterブロックを必ず指定する必要があります。
  event_filter {
    # source (Required)
    # 設定内容: イベントのソースを指定します。
    # 設定可能な値: 1-256文字の文字列
    # パターン: ^aws\.(partner\/.*|cases)$
    # 例:
    #   - "aws.partner/examplepartner.com" (パートナーイベントソース)
    #   - "aws.cases" (Amazon Connect Cases)
    source = "aws.partner/examplepartner.com"
  }

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  #   - キー: 1-128文字（aws:プレフィックスは使用不可、パターン: ^(?!aws:)[a-zA-Z+-=._:/]+$）
  #   - 値: 最大256文字
  #   - 最大200個のタグ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "Example Event Integration"
    Environment = "development"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: イベント統合のAmazon Resource Name (ARN)
#        パターン: ^arn:aws:[A-Za-z0-9][A-Za-z0-9_/.-]{0,62}:...
#
# - id: イベント統合の識別子（イベント統合の名前と同じ）
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
