#---------------------------------------------------------------
# S3 Access Grants Instance Resource Policy
#---------------------------------------------------------------
#
# S3 Access Grants インスタンスのリソースポリシーを管理します。
# リソースポリシーを使用して、S3 Access Grants インスタンスへの
# クロスアカウントアクセスを管理できます。
#
# S3 Access Grants を使用すると、以下にAmazon S3データへのアクセスを許可できます：
# - アカウント内のIAMアイデンティティ
# - 他のAWSアカウントのIAMアイデンティティ
# - AWS IAM Identity Centerインスタンスのディレクトリユーザーまたはグループ
#
# クロスアカウントアクセスを設定するには、リソースポリシーを使用して
# 他のアカウントに対してS3 Access Grantsインスタンスへのアクセスを許可します。
# その後、グラントを使用してS3データ（バケット、プレフィックス、またはオブジェクト）へのアクセスを許可します。
#
# AWS公式ドキュメント:
#   - S3 Access Grants cross-account access: https://docs.aws.amazon.com/AmazonS3/latest/userguide/access-grants-cross-accounts.html
#   - Access control in Amazon S3: https://docs.aws.amazon.com/AmazonS3/latest/userguide/access-management.html
#   - DeleteAccessGrantsInstanceResourcePolicy API: https://docs.aws.amazon.com/AmazonS3/latest/API/API_control_DeleteAccessGrantsInstanceResourcePolicy.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3control_access_grants_instance_resource_policy
#
# Provider Version: 6.28.0
# Generated: 2026-02-03
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_s3control_access_grants_instance_resource_policy" "example" {
  #---------------------------------------------------------------
  # Required Parameters
  #---------------------------------------------------------------

  # policy - (必須) S3 Access Grants インスタンスのリソースポリシードキュメント
  #
  # JSON形式のIAMポリシードキュメントを指定します。
  # このポリシーにより、他のAWSアカウントのIAMプリンシパルが
  # このS3 Access Grantsインスタンスにアクセスできるようになります。
  #
  # クロスアカウントアクセスで許可される主なアクション：
  # - s3:GetAccessGrantsInstanceForPrefix: 特定のプレフィックスを含むS3 Access Grantsインスタンスを取得
  # - s3:ListAccessGrants: アクセスグラントのリストを取得
  # - s3:ListAccessGrantsLocations: アクセスグラントロケーションのリストを取得
  # - s3:ListCallerAccessGrants: 呼び出し元のアクセスグラントを一覧表示
  # - s3:GetDataAccess: S3 Access Grantsを通じて付与されたアクセスに基づいて一時的な認証情報をリクエスト
  #
  # 例：
  # policy = jsonencode({
  #   Version = "2012-10-17"
  #   Id      = "S3AccessGrantsPolicy"
  #   Statement = [{
  #     Sid    = "AllowAccessToS3AccessGrants"
  #     Effect = "Allow"
  #     Principal = {
  #       AWS = "arn:aws:iam::444455556666:root"
  #     }
  #     Action = [
  #       "s3:ListAccessGrants",
  #       "s3:ListAccessGrantsLocations",
  #       "s3:GetDataAccess",
  #       "s3:GetAccessGrantsInstanceForPrefix"
  #     ]
  #     Resource = aws_s3control_access_grants_instance.example.access_grants_instance_arn
  #   }]
  # })
  #
  # タイプ: string
  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "S3AccessGrantsPolicy"
    Statement = [{
      Sid    = "AllowAccessToS3AccessGrants"
      Effect = "Allow"
      Principal = {
        AWS = "123456789456"
      }
      Action = [
        "s3:ListAccessGrants",
        "s3:ListAccessGrantsLocations",
        "s3:GetDataAccess"
      ]
      Resource = "*"
    }]
  })

  #---------------------------------------------------------------
  # Optional Parameters
  #---------------------------------------------------------------

  # account_id - (任意) S3 Access Grants インスタンスのAWSアカウントID
  #
  # このパラメータを指定しない場合、Terraform AWSプロバイダーの
  # アカウントIDが自動的に使用されます。
  #
  # 明示的に指定する場合は、12桁のAWSアカウントIDを文字列として設定します。
  #
  # 例: "111122223333"
  #
  # タイプ: string
  # デフォルト: 自動的に決定されるプロバイダーのアカウントID
  # account_id = "111122223333"

  # region - (任意) このリソースが管理されるAWSリージョン
  #
  # このパラメータを指定しない場合、プロバイダー設定で設定された
  # リージョンがデフォルトとして使用されます。
  #
  # S3 Access Grantsインスタンスは各リージョンごとに作成する必要があります。
  # 複数のリージョンでデータを共有する場合は、各リージョンで
  # S3 Access Grantsインスタンスとリソースポリシーを設定する必要があります。
  #
  # 詳細: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  #
  # 例: "us-west-2"
  #
  # タイプ: string
  # デフォルト: プロバイダー設定のリージョン
  # region = "us-west-2"
}

#---------------------------------------------------------------
# Attributes Reference
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします：
#
# - id: S3 Access Grants インスタンスリソースポリシーの識別子（computed only）
#       このIDは、Terraformの状態管理とリソース参照に使用されます。
