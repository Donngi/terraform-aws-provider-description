#---------------------------------------------------------------
# Amazon S3 Tables - Namespace
#---------------------------------------------------------------
#
# Amazon S3 Tables のネームスペースを管理するリソースです。
# ネームスペースはテーブルバケット内のテーブルを整理・分類するための
# 論理的なグルーピング単位です。
#
# 主な特徴:
#   - テーブルバケット内にテーブルをグループ化する階層構造を提供
#   - Apache Iceberg 互換のネームスペース管理
#   - テーブル作成時の名前空間プレフィックスとして使用
#
# AWS公式ドキュメント:
#   - S3 Tables ネームスペース概要: https://docs.aws.amazon.com/AmazonS3/latest/userguide/s3-tables-namespace.html
#   - API リファレンス: https://docs.aws.amazon.com/AmazonS3/latest/API/API_s3Buckets_CreateNamespace.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3tables_namespace
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_s3tables_namespace" "example" {
  #-------------------------------------------------------------
  # 必須設定
  #-------------------------------------------------------------

  # namespace (Required)
  # 設定内容: 作成するネームスペースの名前を指定します。
  # 設定可能な値: 有効なネームスペース名の文字列
  namespace = "example-namespace"

  # table_bucket_arn (Required)
  # 設定内容: ネームスペースを作成するテーブルバケットの ARN を指定します。
  # 設定可能な値: 有効な S3 Tables テーブルバケットの ARN
  table_bucket_arn = aws_s3tables_table_bucket.example.arn

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional, Computed)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効な AWS リージョンコード (例: us-east-1, ap-northeast-1)
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - created_at: ネームスペースが作成された日時 (RFC3339 形式)。
# - created_by: ネームスペースを作成したプリンシパルの識別子。
# - owner_account_id: ネームスペースを所有する AWS アカウント ID。
#---------------------------------------------------------------
