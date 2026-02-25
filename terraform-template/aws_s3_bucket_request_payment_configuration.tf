#---------------------------------------------------------------
# Amazon S3 Bucket Request Payment Configuration
#---------------------------------------------------------------
#
# Amazon S3バケットのリクエスト支払い設定をプロビジョニングするリソースです。
# Requester Pays（リクエスター支払い）機能を使用することで、バケット所有者ではなく
# データをリクエストしたユーザーがダウンロード費用とリクエスト費用を負担する設定が可能です。
#
# 注意事項:
# - このリソースを削除すると、バケットの payer 設定がS3デフォルト（バケット所有者）にリセットされます
# - このリソースはS3ディレクトリバケットでは使用できません
# - Requester Pays を有効にすると、匿名アクセスは無効になります
#
# AWS公式ドキュメント:
#   - Requester Pays バケット概要: https://docs.aws.amazon.com/AmazonS3/latest/dev/RequesterPaysBuckets.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_request_payment_configuration
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_s3_bucket_request_payment_configuration" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # bucket (Required, Forces new resource)
  # 設定内容: リクエスト支払い設定を適用するバケットの名前を指定します。
  # 設定可能な値: 既存のS3バケット名
  # 注意: この値を変更すると、新しいリソースが作成されます（既存のリソースは削除されます）
  bucket = "my-bucket-name"

  # payer (Required)
  # 設定内容: ダウンロード費用とリクエスト費用を負担する主体を指定します。
  # 設定可能な値:
  #   - "BucketOwner": バケット所有者が費用を負担する（デフォルト動作）
  #   - "Requester"  : データをリクエストしたユーザーが費用を負担する
  payer = "Requester"

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
