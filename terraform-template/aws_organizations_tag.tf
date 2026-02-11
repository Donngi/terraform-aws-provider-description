#---------------------------------------------------------------
# AWS Organizations Tag
#---------------------------------------------------------------
#
# AWS Organizationsリソース（アカウント、組織単位、ポリシー、ルート等）に
# 個別のタグを管理するリソースです。
# このリソースは、Terraform外部で作成されたOrganizationsリソース
# （例: AWS Control Towerによって暗黙的に作成されたアカウント）にタグを
# 付与する場合に使用します。
#
# AWS公式ドキュメント:
#   - Organizationsリソースのタグ付け: https://docs.aws.amazon.com/organizations/latest/userguide/orgs_tagging.html
#   - タグの追加・更新・削除: https://docs.aws.amazon.com/organizations/latest/userguide/add-tag.html
#   - TagResource API: https://docs.aws.amazon.com/organizations/latest/APIReference/API_TagResource.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/organizations_tag
#
# Provider Version: 6.28.0
# Generated: 2026-02-02
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_organizations_tag" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # resource_id (Required)
  # 設定内容: タグを付与するOrganizationsリソースのIDを指定します。
  # 設定可能な値: 有効なOrganizationsリソースID
  #   - AWSアカウントID（例: 123456789012）
  #   - 組織単位ID（例: ou-xxxx-yyyyyyyy）
  #   - ポリシーID（例: p-xxxxxxxxxxxx）
  #   - ルートID（例: r-xxxx）
  # 関連機能: AWS Organizations タグ付け
  #   AWS Organizations内の各種リソースにタグを追加することで、
  #   識別・整理・検索を容易にします。タグは、アカウント、組織単位（OU）、
  #   ポリシー、組織のルートに対して適用可能です。
  #   - https://docs.aws.amazon.com/organizations/latest/userguide/orgs_tagging.html
  # 注意: このリソースは、親リソースを管理するTerraformリソース
  #       （例: aws_organizations_account）と組み合わせて使用しないでください。
  #       併用すると、永続的な差分が発生します。ただし、同じ設定内で親リソースを
  #       作成する必要がある場合は、親リソースのlifecycleブロックに
  #       ignore_changes = [tags] を追加してください。
  resource_id = "ou-xxxx-yyyyyyyy"

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # key (Required)
  # 設定内容: タグのキー（名前）を指定します。
  # 設定可能な値: 最大128文字の文字列（大文字・小文字を区別）
  # 関連機能: AWS Organizations タグ
  #   タグはキーと値のペアで構成されます。キーは大文字小文字を区別し、
  #   最大128文字まで指定可能です。タグを使用することで、リソースの
  #   カスタム属性ラベルを追加し、識別・整理・検索が容易になります。
  #   - https://docs.aws.amazon.com/organizations/latest/userguide/orgs_tagging.html
  key = "Environment"

  # value (Required)
  # 設定内容: タグの値を指定します。
  # 設定可能な値: 最大256文字の文字列（大文字・小文字を区別）
  # 関連機能: AWS Organizations タグ
  #   タグ値は大文字小文字を区別し、最大256文字まで指定可能です。
  #   タグ値を使用して、リソースの分類や属性情報を詳細に記録できます。
  #   - https://docs.aws.amazon.com/organizations/latest/userguide/orgs_tagging.html
  value = "Production"

  #-------------------------------------------------------------
  # ID設定
  #-------------------------------------------------------------

  # id (Optional, Computed)
  # 設定内容: リソースの識別子を指定します。
  # 設定可能な値: Organizationsリソース識別子とキーをカンマ（,）で区切った文字列
  # 省略時: Terraformが自動的に「resource_id,key」の形式で生成します
  # 注意: 通常は省略し、Terraformに自動生成させることを推奨します
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: Organizationsリソース識別子とキーをカンマ（,）で区切った文字列
#       形式: resource_id,key
#       例: ou-xxxx-yyyyyyyy,Environment
#---------------------------------------------------------------

#---------------------------------------------------------------
# 使用上の注意事項
#---------------------------------------------------------------
# 1. 親リソースとの併用に関する注意:
#    - aws_organizations_accountなどの親リソースと併用すると、永続的な差分が発生
#    - 親リソース側でignore_changes = [tags]を設定することで回避可能
#
# 2. プロバイダーignore_tags設定:
#    - このリソースはプロバイダーのignore_tags設定を使用しません
#
# 3. 実行権限:
#    - このAPIは管理アカウントまたは委任管理者アカウントからのみ呼び出し可能
#    - 必要な権限: organizations:TagResource
#
# 4. 使用例:
#---------------------------------------------------------------
