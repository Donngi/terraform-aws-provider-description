#---------------------------------------------------------------
# Amazon S3 Tables Table Policy
#---------------------------------------------------------------
#
# Amazon S3 Tablesのテーブルポリシー（リソースベースポリシー）を管理するリソースです。
# テーブルポリシーは特定のテーブルへのアクセス権限をテーブルレベルで制御します。
# テーブルバケットポリシーと組み合わせて、きめ細かなアクセス制御が可能です。
#
# AWS公式ドキュメント:
#   - S3 Tablesのリソースベースポリシー: https://docs.aws.amazon.com/AmazonS3/latest/userguide/s3-tables-resource-based-policies.html
#   - テーブルポリシーの管理: https://docs.aws.amazon.com/AmazonS3/latest/userguide/s3-tables-table-policy.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3tables_table_policy
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_s3tables_table_policy" "example" {
  #-------------------------------------------------------------
  # テーブル識別設定
  #-------------------------------------------------------------

  # table_bucket_arn (Required, Forces new resource)
  # 設定内容: このテーブルポリシーが属するテーブルバケットのARNを指定します。
  # 設定可能な値: 有効なS3 TablesテーブルバケットのARN
  # 参考: https://docs.aws.amazon.com/AmazonS3/latest/userguide/s3-tables-resource-based-policies.html
  table_bucket_arn = "arn:aws:s3tables:ap-northeast-1:123456789012:bucket/example-bucket"

  # namespace (Required, Forces new resource)
  # 設定内容: テーブルが属するネームスペース名を指定します。
  # 設定可能な値: 1〜255文字の文字列。小文字英数字とアンダースコアのみ使用可能。
  #   先頭および末尾は小文字英字または数字でなければなりません。
  namespace = "example_namespace"

  # name (Required, Forces new resource)
  # 設定内容: ポリシーを適用するテーブルの名前を指定します。
  # 設定可能な値: 1〜255文字の文字列。小文字英数字とアンダースコアのみ使用可能。
  #   先頭および末尾は小文字英字または数字でなければなりません。
  name = "example_table"

  #-------------------------------------------------------------
  # ポリシー設定
  #-------------------------------------------------------------

  # resource_policy (Required)
  # 設定内容: テーブルに適用するリソースベースポリシーをJSON形式で指定します。
  # 設定可能な値: AWS IAMポリシードキュメントのJSON文字列
  # 注意: テーブルへの書き込みや削除操作を行うポリシーには、
  #   GetTableMetadataLocation と UpdateTableMetadataLocation の権限も含めることを推奨します。
  # 参考: https://docs.aws.amazon.com/AmazonS3/latest/userguide/s3-tables-resource-based-policies.html
  resource_policy = data.aws_iam_policy_document.example.json

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するAWSリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用します。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは追加のエクスポート属性を持ちません。
# リソース識別にはリソースブロック内の引数（table_bucket_arn, namespace, name）を参照します。
#---------------------------------------------------------------
