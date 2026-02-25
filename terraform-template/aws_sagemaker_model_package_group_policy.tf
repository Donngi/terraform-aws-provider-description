#---------------------------------------------------------------
# AWS SageMaker Model Package Group Policy
#---------------------------------------------------------------
#
# Amazon SageMaker AIのモデルパッケージグループに対するリソースポリシーを
# プロビジョニングするリソースです。リソースポリシーを使用して、
# モデルパッケージグループへのアクセスを他のAWSアカウントや
# IAMエンティティに対して制御できます。
#
# AWS公式ドキュメント:
#   - PutModelPackageGroupPolicy: https://docs.aws.amazon.com/sagemaker/latest/APIReference/API_PutModelPackageGroupPolicy.html
#   - モデルパッケージグループへのアクセス設定: https://docs.aws.amazon.com/sagemaker/latest/dg/model-registry-ram-discover.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sagemaker_model_package_group_policy
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_sagemaker_model_package_group_policy" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # model_package_group_name (Required)
  # 設定内容: リソースポリシーを設定するモデルパッケージグループの名前を指定します。
  # 設定可能な値: 既存のaws_sagemaker_model_package_groupリソースの名前
  # 参考: https://docs.aws.amazon.com/sagemaker/latest/APIReference/API_PutModelPackageGroupPolicy.html
  model_package_group_name = "example"

  # resource_policy (Required)
  # 設定内容: モデルパッケージグループへのアクセスを制御するリソースポリシーを
  #           JSON形式の文字列で指定します。
  # 設定可能な値: IAMポリシードキュメントのJSON文字列。
  #   aws_iam_policy_documentデータソースで生成したポリシーを
  #   jsonencode(jsondecode(data.aws_iam_policy_document.example.json)) で渡すことが推奨されます。
  # 注意: ポリシーにはモデルパッケージグループのARNをResourceとして指定する必要があります。
  # 参考: https://docs.aws.amazon.com/sagemaker/latest/APIReference/API_PutModelPackageGroupPolicy.html
  resource_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AddPermModelPackageGroup"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::123456789012:root"
        }
        Action = [
          "sagemaker:DescribeModelPackage",
          "sagemaker:ListModelPackages",
        ]
        Resource = "arn:aws:sagemaker:ap-northeast-1:123456789012:model-package-group/example"
      }
    ]
  })

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
# このリソースは以下の属性をエクスポートします:
#
# - id: モデルパッケージグループの名前（model_package_group_nameと同値）
#---------------------------------------------------------------
