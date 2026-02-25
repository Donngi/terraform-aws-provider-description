#---------------------------------------------------------------
# Amazon S3 バケットポリシー
#---------------------------------------------------------------
#
# S3バケットにリソースベースのIAMポリシーをアタッチするリソースです。
# バケットポリシーを使用することで、バケットおよびオブジェクトへのアクセスを
# IAMエンティティ（ユーザー、ロール）やサービスに対して細かく制御できます。
# 同一バケットに対して aws_s3_bucket リソース内の policy 属性との併用は避けてください。
#
# AWS公式ドキュメント:
#   - バケットポリシー概要: https://docs.aws.amazon.com/AmazonS3/latest/userguide/bucket-policies.html
#   - バケットポリシーの例: https://docs.aws.amazon.com/AmazonS3/latest/userguide/example-bucket-policies.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_s3_bucket_policy" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # bucket (Required)
  # 設定内容: ポリシーを適用するS3バケットの名前を指定します。
  # 設定可能な値: 有効なS3バケット名
  # 注意: aws_s3_bucket リソースの bucket 属性を参照することを推奨します。
  bucket = aws_s3_bucket.example.id

  # policy (Required)
  # 設定内容: バケットに適用するIAMポリシードキュメントのJSON文字列を指定します。
  # 設定可能な値: 有効なIAMポリシーJSON文字列
  # 注意: aws_iam_policy_document データソースを使用してポリシーを構築することを推奨します。
  policy = data.aws_iam_policy_document.example.json

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: ポリシーが適用されたバケットの名前
#---------------------------------------------------------------
