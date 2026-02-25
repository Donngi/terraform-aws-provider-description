#---------------------------------------------------------------
# AWS Organizations Policy Attachment
#---------------------------------------------------------------
#
# AWS Organizations のポリシーをアカウント・ルート・組織単位（OU）に
# アタッチするリソースです。SCP（サービスコントロールポリシー）や
# タグポリシー等のOrganizationsポリシーをターゲットに適用します。
#
# AWS公式ドキュメント:
#   - AWS Organizations ポリシー: https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_policies.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/organizations_policy_attachment
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_organizations_policy_attachment" "example" {
  #-------------------------------------------------------------
  # ポリシー設定
  #-------------------------------------------------------------

  # policy_id (Required)
  # 設定内容: アタッチするAWS Organizationsポリシーの一意識別子（ID）を指定します。
  # 設定可能な値: 有効なOrganizationsポリシーID（例: p-xxxxxxxxxx）
  # 参考: https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_policies.html
  policy_id = "p-xxxxxxxxxx"

  #-------------------------------------------------------------
  # ターゲット設定
  #-------------------------------------------------------------

  # target_id (Required)
  # 設定内容: ポリシーをアタッチする対象のルート・OU・アカウントの一意識別子を指定します。
  # 設定可能な値:
  #   - ルートID（例: r-xxxxxxxxxx）
  #   - 組織単位（OU）ID（例: ou-xxxx-xxxxxxxx）
  #   - AWSアカウントID（例: 123456789012）
  # 参考: https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_policies_attach.html
  target_id = "r-xxxxxxxxxx"

  #-------------------------------------------------------------
  # ライフサイクル設定
  #-------------------------------------------------------------

  # skip_destroy (Optional)
  # 設定内容: Terraform destroy時にポリシーのデタッチを行わないかを指定します。
  # 設定可能な値:
  #   - true: destroy時にポリシーをデタッチせず、Terraform stateからのみ削除します
  #   - false (デフォルト): destroy時にポリシーをターゲットからデタッチします
  # 省略時: false
  # 用途: AWSが1つ以上のポリシーアタッチメントを必須とする場合（最低1つのSCPアタッチが必要なルート等）に使用
  skip_destroy = false
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: ポリシーアタッチメントの識別子（policy_id:target_id の形式）
#---------------------------------------------------------------
