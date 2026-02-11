#---------------------------------------------------------------
# AWS RAM Principal Association
#---------------------------------------------------------------
#
# AWS Resource Access Manager (RAM) のプリンシパル関連付けを
# プロビジョニングするリソースです。
# RAMリソース共有と、AWSアカウント/Organization/OUとの関連付けを管理します。
#
# 動作はAWS Organizationsとの統合状態により異なります:
#
# [RAM Sharing with AWS Organizations が有効な場合]
# - 同じOrganization内のアカウント/Org/OU:
#   招待なしで自動的にリソースが利用可能になります
# - Organization外のアカウント:
#   リソース共有の招待が送信され、受諾が必要です
#
# [RAM Sharing with AWS Organizations が無効な場合]
# - Organization/OUプリンシパルは使用できません
# - アカウントIDプリンシパルには招待が送信され、受諾が必要です
#
# AWS公式ドキュメント:
#   - RAM Principal Association: https://docs.aws.amazon.com/ram/latest/userguide/working-with-sharing.html
#   - Organizations統合: https://docs.aws.amazon.com/ram/latest/userguide/getting-started-sharing.html#getting-started-sharing-orgs
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ram_principal_association
#
# Provider Version: 6.28.0
# Generated: 2026-02-04
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_ram_principal_association" "example" {
  #-------------------------------------------------------------
  # 必須設定
  #-------------------------------------------------------------

  # principal (Required)
  # 設定内容: リソース共有に関連付けるプリンシパルを指定します。
  # 設定可能な値:
  #   - AWSアカウントID: 12桁の数字 (例: "111111111111")
  #   - AWS Organizations Organization ARN:
  #     "arn:aws:organizations::123456789012:organization/o-xxxxx"
  #   - AWS Organizations Organizational Unit (OU) ARN:
  #     "arn:aws:organizations::123456789012:ou/o-xxxxx/ou-xxxxx"
  # 注意:
  #   - Organization/OU ARNを使用する場合、RAM Sharing with AWS Organizationsが有効である必要があります
  #   - 外部アカウントと共有する場合、リソース共有のallow_external_principals=trueが必要です
  # 関連機能: AWS Resource Access Manager
  #   複数のAWSアカウント間でAWSリソースを安全に共有するサービス。
  #   - https://docs.aws.amazon.com/ram/latest/userguide/what-is.html
  principal = "111111111111"

  # resource_share_arn (Required)
  # 設定内容: プリンシパルを関連付けるRAMリソース共有のARNを指定します。
  # 設定可能な値: 有効なRAMリソース共有のARN
  # 関連機能: RAM Resource Share
  #   共有するリソースをまとめて管理するコンテナ。
  #   - https://docs.aws.amazon.com/ram/latest/userguide/working-with-sharing.html
  resource_share_arn = aws_ram_resource_share.example.arn

  #-------------------------------------------------------------
  # オプション設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考:
  #   - Regional Endpoints: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  #   - Provider Configuration: https://registry.terraform.io/providers/hashicorp/aws/latest/docs#aws-configuration-reference
  # region = "us-east-1"
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: リソース共有のARNとプリンシパルをカンマで結合した文字列
#   形式: "<resource_share_arn>,<principal>"
#   例: aws_ram_principal_association.example.id
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# 使用例 1: AWSアカウントIDとの関連付け
#---------------------------------------------------------------
# 別のAWSアカウントとリソースを共有する基本的な例

# resource "aws_ram_resource_share" "account_share" {
#   name                      = "example-account-share"
#   allow_external_principals = true  # 外部アカウントとの共有を許可
#
#   tags = {
#     Name        = "example-account-share"
#     Environment = "production"
#   }
# }
#
# resource "aws_ram_principal_association" "account_share" {
#   principal          = "123456789012"  # 共有先のアカウントID
#   resource_share_arn = aws_ram_resource_share.account_share.arn
# }

#---------------------------------------------------------------
# 使用例 2: AWS Organizationとの関連付け
#---------------------------------------------------------------
# Organization全体とリソースを共有する例
# (RAM Sharing with AWS Organizationsが有効である必要があります)

# resource "aws_ram_resource_share" "org_share" {
#   name = "example-org-share"
#
#   tags = {
#     Name        = "example-org-share"
#     Environment = "production"
#   }
# }
#
# resource "aws_ram_principal_association" "org_share" {
#   principal          = aws_organizations_organization.example.arn
#   resource_share_arn = aws_ram_resource_share.org_share.arn
# }

#---------------------------------------------------------------
# 使用例 3: Organizational Unit (OU) との関連付け
#---------------------------------------------------------------
# 特定のOUとリソースを共有する例
# (RAM Sharing with AWS Organizationsが有効である必要があります)

# resource "aws_ram_resource_share" "ou_share" {
#   name = "example-ou-share"
#
#   tags = {
#     Name        = "example-ou-share"
#     Environment = "production"
#   }
# }
#
# resource "aws_ram_principal_association" "ou_share" {
#   principal          = "arn:aws:organizations::123456789012:ou/o-xxxxx/ou-xxxxx"
#   resource_share_arn = aws_ram_resource_share.ou_share.arn
# }

#---------------------------------------------------------------
# 使用例 4: 複数プリンシパルとの関連付け
#---------------------------------------------------------------
# 複数のアカウントと同じリソース共有を関連付ける例

# variable "shared_account_ids" {
#   description = "リソースを共有するアカウントIDのリスト"
#   type        = list(string)
#   default     = ["111111111111", "222222222222", "333333333333"]
# }
#
# resource "aws_ram_resource_share" "multi_account" {
#   name                      = "example-multi-account-share"
#   allow_external_principals = true
#
#   tags = {
#     Name        = "example-multi-account-share"
#     Environment = "production"
#   }
# }
#
# resource "aws_ram_principal_association" "multi_account" {
#   for_each = toset(var.shared_account_ids)
#
#   principal          = each.value
#   resource_share_arn = aws_ram_resource_share.multi_account.arn
# }

#---------------------------------------------------------------
# 使用例 5: VPCサブネットを共有する完全な例
#---------------------------------------------------------------
# VPCサブネットを別アカウントと共有する実践的な例

# # リソース共有の作成
# resource "aws_ram_resource_share" "subnet_share" {
#   name                      = "vpc-subnet-share"
#   allow_external_principals = true
#
#   tags = {
#     Name        = "vpc-subnet-share"
#     Purpose     = "Share VPC subnets for multi-account architecture"
#     Environment = "production"
#   }
# }
#
# # サブネットをリソース共有に追加
# resource "aws_ram_resource_association" "subnet_share" {
#   resource_arn       = aws_subnet.example.arn
#   resource_share_arn = aws_ram_resource_share.subnet_share.arn
# }
#
# # アカウントをプリンシパルとして関連付け
# resource "aws_ram_principal_association" "subnet_share" {
#   principal          = "123456789012"
#   resource_share_arn = aws_ram_resource_share.subnet_share.arn
#
#   # リソース関連付けが完了してから実行
#   depends_on = [aws_ram_resource_association.subnet_share]
# }

#---------------------------------------------------------------
# 参考情報
#---------------------------------------------------------------
#
# リソース共有の招待受諾:
#   外部アカウントからの招待を受諾するには、aws_ram_resource_share_accepterリソースを使用します。
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ram_resource_share_accepter
#
# RAM Sharing with AWS Organizationsの有効化:
#   AWS OrganizationsコンソールまたはAWS CLIで設定できます。
#   - https://docs.aws.amazon.com/ram/latest/userguide/getting-started-sharing.html#getting-started-sharing-orgs
#
# 共有可能なリソースタイプ:
#   - VPCサブネット
#   - Transit Gateway
#   - License Manager ライセンス設定
#   - Route 53 Resolver ルールとエンドポイント
#   - その他多数のAWSリソース
#   リソース共有にはaws_ram_resource_associationを使用します。
#
# ベストプラクティス:
#   - Organization全体よりも特定のOUやアカウントとの共有を推奨
#   - 最小権限の原則に従い、必要なリソースのみを共有
#   - タグを使用してリソース共有を適切に分類・管理
#   - allow_external_principalsは必要な場合のみ有効化
#   - リソース共有の監査ログをCloudTrailで記録
#
#---------------------------------------------------------------
