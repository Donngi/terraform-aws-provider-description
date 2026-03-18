#---------------------------------------------------------------
# Amazon S3 Bucket Accelerate Configuration
#---------------------------------------------------------------
#
# Amazon S3バケットの転送アクセラレーション設定をプロビジョニングするリソースです。
# 転送アクセラレーションを有効にすることで、Amazon CloudFrontのグローバルに分散した
# エッジロケーションを経由して、S3バケットへの高速なデータ転送が可能になります。
#
# 注意事項:
# - このリソースはS3ディレクトリバケットでは使用できません
# - 転送アクセラレーションを使用するには追加のコストが発生します
# - バケット名にピリオド（.）を含む場合、転送アクセラレーションは使用できません
# - 転送アクセラレーションを有効にすると、エンドポイントが変更されます
#   （例: s3-accelerate.amazonaws.com）
#
# AWS公式ドキュメント:
#   - 転送アクセラレーション概要: https://docs.aws.amazon.com/AmazonS3/latest/userguide/transfer-acceleration.html
#   - 要件: https://docs.aws.amazon.com/AmazonS3/latest/userguide/transfer-acceleration.html#transfer-acceleration-requirements
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_accelerate_configuration
#
# Provider Version: 6.36.0
# Generated: 2026-03-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_s3_bucket_accelerate_configuration" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # bucket (Required, Forces new resource)
  # 設定内容: 転送アクセラレーション設定を適用するバケットの名前を指定します。
  # 設定可能な値: 既存のS3バケット名
  # 注意: この値を変更すると、新しいリソースが作成されます（既存のリソースは削除されます）
  bucket = "my-bucket-name"

  # status (Required)
  # 設定内容: バケットの転送アクセラレーションの状態を指定します。
  # 設定可能な値:
  #   - "Enabled" : 転送アクセラレーションを有効化する
  #   - "Suspended": 転送アクセラレーションを一時停止する
  status = "Enabled"

  # expected_bucket_owner (Optional, Forces new resource, Deprecated)
  # 設定内容: バケットの予期される所有者のAWSアカウントIDを指定します。
  # 設定可能な値: 12桁のAWSアカウントID
  # 省略時: バケット所有者の検証を行いません
  # 注意: このフィールドは非推奨です。指定したアカウントIDとバケットの実際の所有者が異なる場合、エラーが発生します
  expected_bucket_owner = null

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
# - id: bucket、または bucket と expected_bucket_owner をカンマ（,）で区切った文字列
#---------------------------------------------------------------
