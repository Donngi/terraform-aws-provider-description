#---------------------------------------------------------------
# Amazon FinSpace Kx Database
#---------------------------------------------------------------
#
# Amazon FinSpace Kx Database リソースを管理します。
# FinSpace Kx Environmentに属するkdbデータベースを作成・管理するために使用します。
#
# 重要: Amazon FinSpaceサービスは2026年10月7日以降サポート終了予定です。
#        2025年10月7日以降、新規顧客の受付は終了しています。
#
# AWS公式ドキュメント:
#   - KxDatabaseConfiguration API: https://docs.aws.amazon.com/finspace/latest/management-api/API_KxDatabaseConfiguration.html
#   - Database maintenance: https://docs.aws.amazon.com/finspace/latest/userguide/finspace-managed-kdb-databases-dbmaint.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/finspace_kx_database
#
# Provider Version: 6.28.0
# Generated: 2026-01-27
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_finspace_kx_database" "example" {
  #---------------------------------------------------------------
  # 必須パラメータ
  #---------------------------------------------------------------

  # (必須) FinSpace Kx EnvironmentのID
  # この環境内にkdbデータベースが作成されます
  # 例: "n3cqv4rp3jy3c4x"
  environment_id = "your-kx-environment-id"

  # (必須) kdbデータベースの名前
  # 3〜63文字で、英数字、ハイフン、アンダースコアが使用可能
  # 先頭と末尾は英数字である必要があります
  # パターン: ^[a-zA-Z0-9][a-zA-Z0-9-_]*[a-zA-Z0-9]$
  # 例: "my-tf-kx-database", "trading_database"
  name = "my-kx-database"

  #---------------------------------------------------------------
  # オプションパラメータ
  #---------------------------------------------------------------

  # (オプション) kdbデータベースの説明
  # データベースの目的や用途を記述します
  # 例: "Trading data storage for market analytics"
  description = "Example database description"

  # (オプション) リージョン指定
  # このリソースが管理されるAWSリージョン
  # 指定しない場合、プロバイダー設定のリージョンが使用されます
  # 例: "us-east-1", "ap-northeast-1"
  # region = "us-east-1"

  # (オプション) リソースタグ
  # Key-Value形式でリソースにタグを付与
  # provider default_tagsと組み合わせて使用可能
  # 例:
  # tags = {
  #   Environment = "production"
  #   Project     = "trading-platform"
  #   Team        = "quant-analytics"
  # }
  tags = {
    Name = "example-kx-database"
  }

  # (オプション) タグの完全なマップ
  # default_tagsと統合されたタグセットを明示的に制御する場合に使用
  # 通常はprovider設定のdefault_tagsにより自動的に管理されます
  # tags_all = {}

  # (オプション) リソースID
  # カンマ区切りの文字列: "environment_id,database_name"
  # 通常は自動的に生成されるため、明示的な指定は不要です
  # id = "environment_id,database_name"

  #---------------------------------------------------------------
  # Timeouts
  #---------------------------------------------------------------
  # リソース操作のタイムアウト設定
  timeouts {
    # データベース作成時のタイムアウト
    # デフォルト: 30分
    # create = "30m"

    # データベース更新時のタイムアウト
    # デフォルト: 30分
    # update = "30m"

    # データベース削除時のタイムアウト
    # デフォルト: 30分
    # delete = "30m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用)
#---------------------------------------------------------------
# 以下の属性はリソース作成後に参照可能です:
#
# - arn
#   Amazon Resource Name (ARN) identifier of the KX database
#   形式: arn:aws:finspace:region:account-id:kx-environment/environment-id/kx-database/database-name
#
# - id
#   A comma-delimited string joining environment ID and database name
#   形式: "environment_id,database_name"
#
# - created_timestamp
#   データベースがFinSpaceで作成されたタイムスタンプ
#   エポックタイム（秒）で表現されます
#   例: 1635768000 (2021年11月1日 12:00:00 PM UTC)
#
# - last_modified_timestamp
#   データベースが最後に更新されたタイムスタンプ
#   エポックタイム（秒）で表現されます
#   例: 1635768000 (2021年11月1日 12:00:00 PM UTC)
#
# - tags_all
#   provider default_tagsとマージされたすべてのタグのマップ
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# 使用例: 完全な構成
#---------------------------------------------------------------
# resource "aws_kms_key" "example" {
#   description             = "Example KMS Key for FinSpace"
#   deletion_window_in_days = 7
# }
#
# resource "aws_finspace_kx_environment" "example" {
#   name       = "my-tf-kx-environment"
#   kms_key_id = aws_kms_key.example.arn
# }
#
# resource "aws_finspace_kx_database" "example" {
#   environment_id = aws_finspace_kx_environment.example.id
#   name           = "my-tf-kx-database"
#   description    = "Trading data storage for market analytics"
#
#   tags = {
#     Environment = "production"
#     Project     = "trading-platform"
#     Team        = "quant-analytics"
#   }
# }
#
# # 出力例: データベース情報の参照
# output "kx_database_arn" {
#   description = "ARN of the FinSpace Kx Database"
#   value       = aws_finspace_kx_database.example.arn
# }
#
# output "kx_database_id" {
#   description = "ID of the FinSpace Kx Database"
#   value       = aws_finspace_kx_database.example.id
# }
#---------------------------------------------------------------
