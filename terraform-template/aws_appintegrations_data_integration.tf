#---------------------------------------------------------------
# AWS AppIntegrations Data Integration
#---------------------------------------------------------------
#
# Amazon AppIntegrations の Data Integration リソースをプロビジョニングします。
# Data Integration は、外部データソース（Salesforce等）からデータを定期的に
# 取り込むための統合設定を定義します。主に Amazon Connect Customer Profiles
# などのサービスと連携して使用されます。
#
# AWS公式ドキュメント:
#   - AppIntegrations API Reference: https://docs.aws.amazon.com/appintegrations/latest/APIReference/Welcome.html
#   - CreateDataIntegration API: https://docs.aws.amazon.com/connect/latest/APIReference/API_connect-app-integrations_CreateDataIntegration.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appintegrations_data_integration
#
# Provider Version: 6.28.0
# Generated: 2026-01-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_appintegrations_data_integration" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: Data Integration の名前を指定します。
  # 設定可能な値: 1-255文字の文字列（英数字、スラッシュ、ドット、アンダースコア、ハイフン）
  # パターン: ^[a-zA-Z0-9/._-]+$
  name = "example-data-integration"

  # description (Optional)
  # 設定内容: Data Integration の説明を指定します。
  # 設定可能な値: 0-1000文字の文字列
  description = "Example data integration for Salesforce"

  #-------------------------------------------------------------
  # データソース設定
  #-------------------------------------------------------------

  # source_uri (Required)
  # 設定内容: データソースのURIを指定します。
  # 設定可能な値: データソースを識別するURI文字列（1-1000文字）
  # 例: Salesforceの場合は "Salesforce://AppFlow/{コネクタプロファイル名}"
  # 注意: AppFlow Connector Profile を事前に作成し、そのプロファイル名をURLに含めます。
  # 参考: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appflow_connector_profile
  source_uri = "Salesforce://AppFlow/example"

  #-------------------------------------------------------------
  # 暗号化設定
  #-------------------------------------------------------------

  # kms_key (Required)
  # 設定内容: Data Integration のデータ暗号化に使用する KMS キーの ARN を指定します。
  # 設定可能な値: 有効な KMS キー ARN（1-255文字）
  # 注意: KMS キーは Data Integration と同じリージョンに存在する必要があります。
  kms_key = "arn:aws:kms:ap-northeast-1:123456789012:key/12345678-1234-1234-1234-123456789012"

  #-------------------------------------------------------------
  # スケジュール設定
  #-------------------------------------------------------------

  # schedule_config (Required)
  # 設定内容: データの取得名とその頻度を定義するブロックです。
  schedule_config {
    # first_execution_from (Required)
    # 設定内容: 最初のフロー実行でインポートするオブジェクトの開始日を指定します。
    # 設定可能な値:
    #   - Unix/epoch タイムスタンプ（ミリ秒単位）: 例 "1439788442681"
    #   - ISO-8601形式: 例 "2023-01-01T00:00:00Z"
    # 注意: 過去の日時を指定する必要があります。この日時より前に作成または更新された
    #       データはダウンロードされません。
    first_execution_from = "1439788442681"

    # object (Required)
    # 設定内容: データソースから取得するオブジェクトの名前を指定します。
    # 設定可能な値: 1-255文字の文字列
    # 例: Salesforceの場合は "Account", "Case", "Lead" など
    object = "Account"

    # schedule_expression (Required)
    # 設定内容: データソースからデータを取得する頻度を指定します。
    # 設定可能な値: rate式形式の文字列（1-255文字）
    # 例:
    #   - "rate(1 hour)": 1時間ごと
    #   - "rate(3 hours)": 3時間ごと
    #   - "rate(1 day)": 1日ごと
    schedule_expression = "rate(1 hour)"
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
  # 設定可能な値: キーと値のペアのマップ（最大200エントリ）
  #   - キー: 1-128文字（"aws:"で始まるキーは使用不可）
  #   - 値: 最大256文字
  # 注意: プロバイダーレベルの default_tags 設定ブロックで定義されたタグと
  #       一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "example-data-integration"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: Data Integration の Amazon Resource Name (ARN)
#
# - id: Data Integration の識別子
#
# - tags_all: プロバイダーの default_tags 設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
