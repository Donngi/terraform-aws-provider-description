#---------------------------------------------------------------
# AWS DynamoDB Contributor Insights
#---------------------------------------------------------------
#
# DynamoDBテーブルまたはグローバルセカンダリインデックス(GSI)に対して
# CloudWatch Contributor Insightsを有効化するリソースです。
# Contributor Insightsは、DynamoDBテーブルやインデックスで最も頻繁に
# アクセスされるアイテムやスロットリングされるアイテムをリアルタイムで
# 特定・分析するための診断ツールです。
#
# AWS公式ドキュメント:
#   - Contributor Insights概要: https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/contributorinsights.html
#   - Contributor Insightsの仕組み: https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/contributorinsights_HowItWorks.html
#   - 使用開始ガイド: https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/contributorinsights_tutorial.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_contributor_insights
#
# Provider Version: 6.28.0
# Generated: 2026-01-22
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_dynamodb_contributor_insights" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # table_name (Required)
  # 設定内容: Contributor Insightsを有効にするDynamoDBテーブルの名前を指定します。
  # 設定可能な値: 既存のDynamoDBテーブル名
  # 注意: テーブルは事前に作成されている必要があります
  table_name = "example-table"

  # index_name (Optional)
  # 設定内容: Contributor Insightsを有効にするグローバルセカンダリインデックス(GSI)の名前を指定します。
  # 設定可能な値: 対象テーブルに存在するGSI名
  # 省略時: テーブル本体のみが対象となります
  # 注意: GSIに対してContributor Insightsを有効にする場合に指定します。
  #       テーブルとGSIの両方を監視する場合は、それぞれ別のリソースを作成する必要があります。
  index_name = null

  # mode (Optional)
  # 設定内容: CloudWatch Contributor Insightsのモードを指定します。
  # 設定可能な値:
  #   - "ACCESSED_AND_THROTTLED_KEYS": アクセスとスロットリングの両方を追跡（包括的なモニタリング）
  #   - "THROTTLED_KEYS": スロットリングされたキーのみを追跡（コスト最適化モード）
  # 省略時: デフォルト動作が適用されます
  # 関連機能: CloudWatch Contributor Insights モード
  #   - ACCESSED_AND_THROTTLED_KEYS: 最もアクセスされたアイテムと最もスロットリングされた
  #     アイテムの両方を特定できます。完全な可視性が必要な場合に推奨。
  #   - THROTTLED_KEYS: スロットリング問題の特定と解決に特化し、監視コストを最小化します。
  #     本番環境での継続的なスロットリング検出に推奨。
  #   - https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/contributorinsights_HowItWorks.html#contributorinsights_HowItWorks.Modes
  mode = null

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソースの作成・削除操作のタイムアウト時間を指定します。
  timeouts {
    # create (Optional)
    # 設定内容: リソース作成時のタイムアウト時間を指定します。
    # 設定可能な値: Goのtime.ParseDuration形式（例: "5m", "10m", "1h"）
    # 省略時: Terraformのデフォルトタイムアウト値が適用されます
    create = null

    # delete (Optional)
    # 設定内容: リソース削除時のタイムアウト時間を指定します。
    # 設定可能な値: Goのtime.ParseDuration形式（例: "5m", "10m", "1h"）
    # 省略時: Terraformのデフォルトタイムアウト値が適用されます
    delete = null
  }
}

#---------------------------------------------------------------
# # テーブル本体のContributor Insights
# resource "aws_dynamodb_contributor_insights" "table" {
#   table_name = aws_dynamodb_table.example.name
#   mode       = "THROTTLED_KEYS"
# }
#
# # GSIのContributor Insights
# resource "aws_dynamodb_contributor_insights" "gsi" {
#   table_name = aws_dynamodb_table.example.name
#   index_name = "example-gsi"
#   mode       = "THROTTLED_KEYS"
# }
#---------------------------------------------------------------

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: テーブル名またはテーブル名/インデックス名の組み合わせ
#
#---------------------------------------------------------------
