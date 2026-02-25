#---------------------------------------------------------------
# Amazon Verified Permissions Policy Template
#---------------------------------------------------------------
#
# Amazon Verified Permissionsのポリシーテンプレートを管理するリソース。
# ポリシーテンプレートはCedarポリシー言語で記述され、?principalや?resourceなどの
# プレースホルダーを含む。テンプレートからポリシーを作成することで、
# 複数のアクセス制御ポリシーを効率的に管理できる。
#
# AWS公式ドキュメント:
#   - Amazon Verified Permissions policy templates: https://docs.aws.amazon.com/verifiedpermissions/latest/userguide/policy-templates.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/verifiedpermissions_policy_template
#
# Provider Version: 6.28.0
# Generated: 2026-02-19
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
# Attributes Reference:
# - id                  : ポリシーストアIDとポリシーテンプレートIDをコロンで結合した値
# - created_date        : ポリシーテンプレートが作成された日時（ISO 8601形式）
# - policy_template_id  : ポリシーテンプレートの一意識別子
#
#---------------------------------------------------------------

resource "aws_verifiedpermissions_policy_template" "example" {
  #-------------------------------------------------------------
  # ポリシーストア設定
  #-------------------------------------------------------------

  # 設定内容: ポリシーテンプレートを所属させるポリシーストアのID
  # 設定可能な値: aws_verifiedpermissions_policy_storeリソースのidを参照
  # 省略時: 設定必須
  policy_store_id = aws_verifiedpermissions_policy_store.example.id

  #-------------------------------------------------------------
  # テンプレート定義
  #-------------------------------------------------------------

  # 設定内容: Cedarポリシー言語で記述されたポリシーテンプレート本文
  # 設定可能な値: ?principalや?resourceなどのプレースホルダーを含むCedarポリシー文字列
  # 省略時: 設定必須
  statement = <<-EOF
    permit(
      principal == ?principal,
      action in [ExampleCo::Action::"view"],
      resource == ?resource
    );
  EOF

  #-------------------------------------------------------------
  # メタデータ
  #-------------------------------------------------------------

  # 設定内容: ポリシーテンプレートの説明文
  # 設定可能な値: 任意の文字列
  # 省略時: 省略可能
  description = "example policy template"

  # 設定内容: リソースを管理するAWSリージョン
  # 設定可能な値: "us-east-1"、"ap-northeast-1" などのリージョンコード
  # 省略時: プロバイダー設定のリージョンを使用
  region = null
}
