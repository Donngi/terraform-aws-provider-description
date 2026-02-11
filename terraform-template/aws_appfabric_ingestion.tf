#---------------------------------------------------------------
# AWS AppFabric Ingestion
#---------------------------------------------------------------
#
# AWS AppFabricのIngestion（取り込み）をプロビジョニングするリソースです。
# Ingestionは、SaaSアプリケーションから監査ログを取得し、Amazon S3や
# Amazon Data Firehoseなどの送信先に配信するためのデータ取り込み設定を定義します。
#
# AWS公式ドキュメント:
#   - AppFabric概要: https://docs.aws.amazon.com/appfabric/latest/adminguide/what-is-appfabric.html
#   - 用語と概念: https://docs.aws.amazon.com/appfabric/latest/adminguide/terminology.html
#   - CreateIngestion API: https://docs.aws.amazon.com/appfabric/latest/api/API_CreateIngestion.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appfabric_ingestion
#
# Provider Version: 6.28.0
# Generated: 2026-01-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_appfabric_ingestion" "example" {
  #-------------------------------------------------------------
  # 必須設定
  #-------------------------------------------------------------

  # app (Required)
  # 設定内容: 監査ログを取り込むアプリケーションの名前を指定します。
  # 設定可能な値:
  #   - "SLACK": Slack
  #   - "ASANA": Asana
  #   - "JIRA": Jira
  #   - "M365": Microsoft 365
  #   - "M365AUDITLOGS": Microsoft 365 監査ログ
  #   - "ZOOM": Zoom
  #   - "ZENDESK": Zendesk
  #   - "OKTA": Okta
  #   - "GOOGLE": Google Workspace
  #   - "DROPBOX": Dropbox
  #   - "SMARTSHEET": Smartsheet
  #   - "CISCO": Cisco
  # 参照: https://docs.aws.amazon.com/appfabric/latest/api/API_CreateIngestion.html#appfabric-CreateIngestion-request-app
  app = "OKTA"

  # app_bundle_arn (Required)
  # 設定内容: Ingestionを作成するApp BundleのARNを指定します。
  # 設定可能な値: 有効なAppFabric App Bundle ARN
  # 関連機能: AppFabric App Bundle
  #   App Bundleは、アプリ認証とIngestionを格納するコンテナです。
  #   各AWSアカウントでリージョンごとに1つのApp Bundleを作成できます。
  #   - https://docs.aws.amazon.com/appfabric/latest/adminguide/terminology.html
  app_bundle_arn = "arn:aws:appfabric:ap-northeast-1:123456789012:appbundle/a1b2c3d4-5678-90ab-cdef-EXAMPLE11111"

  # tenant_id (Required)
  # 設定内容: アプリケーションテナントのIDを指定します。
  # 設定可能な値: 1〜1024文字の文字列（アプリケーションによって形式が異なる）
  # 例:
  #   - Okta: "example.okta.com"
  #   - Microsoft 365: Azure ADのテナントID
  #   - GitHub Enterprise: "enterprise:{enterprise_id}"
  #   - GitHub Organization: "organization:{organization_id}"
  # 注意: テナントIDはアプリ認証とIngestionを識別するために使用されます。
  tenant_id = "example.okta.com"

  # ingestion_type (Required)
  # 設定内容: Ingestionのタイプを指定します。
  # 設定可能な値:
  #   - "auditLog": 監査ログの取り込み
  # 関連機能: AppFabric Ingestion
  #   Ingestionは、アプリケーションの公開APIを通じて監査ログを取得し、
  #   1つ以上の送信先に配信するプロセスです。
  #   - https://docs.aws.amazon.com/appfabric/latest/adminguide/terminology.html
  ingestion_type = "auditLog"

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
  # 設定可能な値: キーと値のペアのマップ（最大50個）
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "example-ingestion"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: IngestionのAmazon Resource Name (ARN)
#
# - id: Ingestionの識別子
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
