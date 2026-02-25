#---------------------------------------------------------------
# AWS RAM リソース関連付け
#---------------------------------------------------------------
#
# AWS Resource Access Manager (RAM) のリソース共有にリソースを関連付けるリソースです。
# aws_ram_resource_share で作成したリソース共有に、共有対象のAWSリソースを紐付けます。
#
# 注意: EC2サブネット等の一部リソースは、AWS Organizations全体のRAM機能が
# 有効なOrganizationsメンバーアカウント内でのみ共有できます。
#
# AWS公式ドキュメント:
#   - RAM リソース共有の管理: https://docs.aws.amazon.com/ram/latest/userguide/working-with-sharing.html
#   - RAM APIリファレンス (ResourceShareAssociation): https://docs.aws.amazon.com/ram/latest/APIReference/API_ResourceShareAssociation.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ram_resource_association
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_ram_resource_association" "example" {
  #-------------------------------------------------------------
  # リソース設定
  #-------------------------------------------------------------

  # resource_arn (Required)
  # 設定内容: RAMリソース共有に関連付けるリソースのARNを指定します。
  # 設定可能な値: 共有可能なAWSリソースの有効なARN（例: EC2サブネット、Transit Gateway等）
  # 参考: https://docs.aws.amazon.com/ram/latest/userguide/working-with-sharing.html
  resource_arn = "arn:aws:ec2:ap-northeast-1:123456789012:subnet/subnet-0123456789abcdef0"

  # resource_share_arn (Required)
  # 設定内容: リソースを関連付けるRAMリソース共有のARNを指定します。
  # 設定可能な値: 有効なRAMリソース共有のARN
  # 参考: https://docs.aws.amazon.com/ram/latest/APIReference/API_ResourceShareAssociation.html
  resource_share_arn = "arn:aws:ram:ap-northeast-1:123456789012:resource-share/12345678-1234-1234-1234-123456789012"

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
# - id: リソース共有のAmazon Resource Name (ARN)
#---------------------------------------------------------------
