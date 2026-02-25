#---------------------------------------------------------------
# S3 Access Grants Instance Resource Policy
#---------------------------------------------------------------
#
# S3 Access Grantsインスタンスのリソースポリシーを管理するリソースです。
# リソースポリシーを使用して、S3 Access Grantsインスタンスへの
# クロスアカウントアクセスを制御できます。
# S3 Access Grantsインスタンスが存在するアカウントから、
# 別のAWSアカウントに対してアクセスを許可する際に使用します。
#
# AWS公式ドキュメント:
#   - S3 Access Grantsのクロスアカウントアクセス: https://docs.aws.amazon.com/AmazonS3/latest/userguide/access-grants-cross-account.html
#   - S3 Access Grantsインスタンスの操作: https://docs.aws.amazon.com/AmazonS3/latest/userguide/access-grants-instance.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3control_access_grants_instance_resource_policy
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_s3control_access_grants_instance_resource_policy" "example" {
  #-------------------------------------------------------------
  # ポリシー設定
  #-------------------------------------------------------------

  # policy (Required)
  # 設定内容: S3 Access Grantsインスタンスに適用するリソースポリシーのJSONドキュメントを指定します。
  # 設定可能な値: IAMポリシーJSON文字列
  #             - Principal: アクセスを許可するAWSアカウントIDやIAMエンティティ
  #             - Action: s3:ListAccessGrants, s3:ListAccessGrantsLocations, s3:GetDataAccess など
  #             - Resource: S3 Access Grantsインスタンスの ARN
  # 省略時: 省略不可（必須項目）
  # 参考: https://docs.aws.amazon.com/AmazonS3/latest/userguide/access-grants-cross-account.html
  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "S3AccessGrantsPolicy"
    Statement = [{
      Sid    = "AllowAccessToS3AccessGrants"
      Effect = "Allow"
      Principal = {
        AWS = "123456789012"
      }
      Action = [
        "s3:ListAccessGrants",
        "s3:ListAccessGrantsLocations",
        "s3:GetDataAccess"
      ]
      Resource = "arn:aws:s3:ap-northeast-1:123456789012:access-grants/default"
    }]
  })

  #-------------------------------------------------------------
  # アカウント設定
  #-------------------------------------------------------------

  # account_id (Optional)
  # 設定内容: S3 Access Grantsインスタンスが属するAWSアカウントIDを指定します。
  # 設定可能な値: 12桁のAWSアカウントID（例: "123456789012"）
  # 省略時: Terraform AWSプロバイダーで自動的に決定されるアカウントIDを使用
  account_id = null

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するAWSリージョンを指定します。
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
# - id: S3 Access Grantsインスタンスリソースポリシーの識別子（account_idと同値）
#---------------------------------------------------------------
