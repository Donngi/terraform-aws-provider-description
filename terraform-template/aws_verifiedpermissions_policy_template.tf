#---------------------------------------------------------------
# Amazon Verified Permissions ポリシーテンプレート
#---------------------------------------------------------------
#
# Amazon Verified Permissionsのポリシーテンプレートを管理するリソースです。
# ポリシーテンプレートは、プリンシパルとリソースのプレースホルダーを含む
# ポリシーの設計図であり、複数のエンティティに対して同じポリシーを
# 使用できるようにします。テンプレートリンクポリシーを作成することで、
# 特定のプリンシパルとリソースに対してインスタンス化されます。
# テンプレートへの変更は、リンクされたすべてのポリシーに即座に反映されます。
#
# AWS公式ドキュメント:
#   - ポリシーテンプレートとテンプレートリンクポリシー: https://docs.aws.amazon.com/verifiedpermissions/latest/userguide/policy-templates.html
#   - ポリシーテンプレートの作成: https://docs.aws.amazon.com/verifiedpermissions/latest/userguide/policy-templates-create.html
#   - CreatePolicyTemplate API: https://docs.aws.amazon.com/verifiedpermissions/latest/apireference/API_CreatePolicyTemplate.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/verifiedpermissions_policy_template
#
# Provider Version: 6.28.0
# Generated: 2026-02-05
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_verifiedpermissions_policy_template" "example" {
  #---------------------------------------------------------------
  # 必須パラメータ
  #---------------------------------------------------------------

  # ポリシーストアのID
  # ポリシーテンプレートが属するポリシーストアを指定します。
  # ポリシーストアは、すべてのVerified Permissions操作の前提条件となります。
  # 例: "PS1234567890abcdef"
  policy_store_id = "POLICY_STORE_ID"

  # ポリシーステートメント
  # Cedarポリシー言語で記述されたポリシーテンプレートの内容を定義します。
  # プリンシパル(?principal)とリソース(?resource)のプレースホルダーを含めることができます。
  # これらのプレースホルダーは、テンプレートリンクポリシーを作成する際に
  # 具体的な値で置き換えられます。
  #
  # 例: "permit (principal in ?principal, action in PhotoFlash::Action::\"FullPhotoAccess\", resource == ?resource) unless { resource.IsPrivate };"
  #
  # Cedarポリシー言語の構文:
  # - effect: permit または forbid
  # - principal: ポリシーが適用される主体（ユーザー、ロールなど）
  # - action: 許可または禁止されるアクション
  # - resource: アクセス対象のリソース
  # - condition: オプションの条件句（when/unless）
  statement = "POLICY_STATEMENT"

  #---------------------------------------------------------------
  # オプションパラメータ
  #---------------------------------------------------------------

  # ポリシーテンプレートの説明
  # ポリシーテンプレートの目的や用途を説明する任意のテキストです。
  # テンプレートの管理と識別を容易にするために推奨されます。
  # 例: "写真へのフルアクセス権限を付与するテンプレート"
  description = null

  # リージョン
  # このリソースが管理されるAWSリージョンを指定します。
  # 指定しない場合、プロバイダー設定のリージョンがデフォルトで使用されます。
  # Amazon Verified Permissionsは特定のリージョンでのみ利用可能です。
  # 例: "us-east-1", "ap-northeast-1"
  region = null
}

#---------------------------------------------------------------
# Attributes Reference
#---------------------------------------------------------------
# 以下の属性は、リソース作成後に参照可能です（computed）:
#
# - id
#     リソースの一意識別子
#     形式: policy_store_id:policy_template_id
#
# - policy_template_id
#     ポリシーテンプレートの一意ID
#     テンプレートリンクポリシーを作成する際に使用します
#
# - created_date
#     ポリシーテンプレートが作成された日時
#     RFC3339形式のタイムスタンプ
#---------------------------------------------------------------
