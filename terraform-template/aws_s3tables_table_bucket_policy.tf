#---------------------------------------------------------------
# Amazon S3 Tables - Table Bucket Policy
#---------------------------------------------------------------
#
# Amazon S3 Tables のテーブルバケットポリシーを管理するリソースです。
# リソースベースポリシーをテーブルバケットにアタッチし、
# アクセス制御を詳細に設定できます。
#
# 主な特徴:
#   - JSON形式のリソースベースポリシーをテーブルバケットに設定
#   - IAMポリシードキュメントを使用したアクセス制御
#   - クロスアカウントアクセスや条件付きアクセス制御に対応
#
# AWS公式ドキュメント:
#   - S3 Tables テーブルバケットポリシー概要: https://docs.aws.amazon.com/AmazonS3/latest/userguide/s3-tables-bucket-policies.html
#   - S3 Tables APIリファレンス: https://docs.aws.amazon.com/AmazonS3/latest/API/API_s3Buckets_PutTableBucketPolicy.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3tables_table_bucket_policy
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_s3tables_table_bucket_policy" "example" {
  #-------------------------------------------------------------
  # 必須設定
  #-------------------------------------------------------------

  # table_bucket_arn (Required, Forces new resource)
  # 設定内容: このポリシーを所有するテーブルバケットのARNを指定します。
  # 設定可能な値: 有効なS3 Tablesテーブルバケットの ARN
  # 注意: この値を変更するとリソースが再作成されます
  # 関連機能: S3 Tables テーブルバケット
  #   ポリシーを適用するテーブルバケットを指定。
  #   - https://docs.aws.amazon.com/AmazonS3/latest/userguide/s3-tables-bucket-policies.html
  table_bucket_arn = aws_s3tables_table_bucket.example.arn

  # resource_policy (Required)
  # 設定内容: テーブルバケットに適用するAWSリソースベースポリシーをJSON形式で指定します。
  # 設定可能な値: JSON形式のIAMポリシードキュメント文字列
  # 注意: data.aws_iam_policy_document を使用してポリシードキュメントを構築することを推奨します
  # 関連機能: IAMポリシードキュメント
  #   テーブルバケットへのアクセス制御を定義。Principalやアクション、条件を設定可能。
  #   - https://docs.aws.amazon.com/AmazonS3/latest/userguide/s3-tables-bucket-policies.html
  resource_policy = data.aws_iam_policy_document.example.json

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional, Computed)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード (例: us-east-1, ap-northeast-1)
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは追加の読み取り専用属性をエクスポートしません。
# 設定した引数の値はそのまま参照可能です:
#
# - table_bucket_arn: ポリシーが適用されたテーブルバケットのARN
# - resource_policy: 設定されたリソースベースポリシーのJSON文字列
#---------------------------------------------------------------
