#---------------------------------------------------------------
# AWS VPC Lattice Resource Policy
#---------------------------------------------------------------
#
# Amazon VPC Latticeのサービスネットワークまたはサービスに対する
# リソースベースポリシーをプロビジョニングするリソースです。
# リソースポリシーを使用して、他のAWSアカウントやプリンシパルに
# VPC Latticeリソースへのアクセス権限を付与できます。
#
# AWS公式ドキュメント:
#   - VPC LatticeとIAMの連携: https://docs.aws.amazon.com/vpc-lattice/latest/ug/security_iam_service-with-iam.html
#   - VPC Lattice認証ポリシー: https://docs.aws.amazon.com/vpc-lattice/latest/ug/auth-policies.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpclattice_resource_policy
#
# Provider Version: 6.28.0
# Generated: 2026-02-05
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_vpclattice_resource_policy" "example" {
  #-------------------------------------------------------------
  # リソース識別設定
  #-------------------------------------------------------------

  # resource_arn (Required)
  # 設定内容: ポリシーを作成するサービスネットワークまたはサービスのIDまたはARNを指定します。
  # 設定可能な値: 有効なVPC Latticeサービスネットワーク/サービスのARNまたはID
  # 関連機能: VPC Lattice リソースポリシー
  #   リソースベースポリシーを使用して、他のAWSアカウントやプリンシパルに
  #   サービスネットワークやサービスへのアクセス権限を付与します。
  #   AWS Resource Access Manager (RAM) との統合にも使用されます。
  #   - https://docs.aws.amazon.com/vpc-lattice/latest/ug/security_iam_service-with-iam.html
  resource_arn = aws_vpclattice_service_network.example.arn

  #-------------------------------------------------------------
  # ポリシー設定
  #-------------------------------------------------------------

  # policy (Required)
  # 設定内容: IAMポリシーをJSON形式で指定します。
  # 設定可能な値: 有効なIAMポリシーJSON文字列
  # 注意: ポリシー文字列に改行や空白行を含めることはできません。
  # 関連機能: VPC Lattice アクセス制御
  #   リソースベースポリシーにより、以下のようなアクションを許可できます:
  #   - vpc-lattice:CreateServiceNetworkVpcAssociation
  #   - vpc-lattice:CreateServiceNetworkServiceAssociation
  #   - vpc-lattice:GetServiceNetwork
  #   - その他のVPC Lattice APIアクション
  #   - https://docs.aws.amazon.com/vpc-lattice/latest/ug/security_iam_service-with-iam.html
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowServiceNetworkAccess"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::123456789012:root"
        }
        Action = [
          "vpc-lattice:CreateServiceNetworkVpcAssociation",
          "vpc-lattice:CreateServiceNetworkServiceAssociation",
          "vpc-lattice:GetServiceNetwork"
        ]
        Resource = aws_vpclattice_service_network.example.arn
      }
    ]
  })

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
# - id: リソースポリシーのID（resource_arnと同じ値）
#
#---------------------------------------------------------------
