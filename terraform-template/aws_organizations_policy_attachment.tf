#---------------------------------------------------------------
# AWS Organizations ポリシーアタッチメント
#---------------------------------------------------------------
#
# AWS Organizationsのポリシーを組織のアカウント、ルート、または組織単位（OU）に
# アタッチするためのリソースです。サービスコントロールポリシー（SCP）、
# リソースコントロールポリシー（RCP）、タグポリシー、バックアップポリシーなど、
# 様々なポリシータイプをターゲットに適用できます。
#
# AWS公式ドキュメント:
#   - AttachPolicy API: https://docs.aws.amazon.com/organizations/latest/APIReference/API_AttachPolicy.html
#   - ポリシーのアタッチ: https://docs.aws.amazon.com/organizations/latest/userguide/orgs_policies_attach.html
#   - Organizations概要: https://docs.aws.amazon.com/organizations/latest/userguide/orgs_introduction.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/organizations_policy_attachment
#
# Provider Version: 6.28.0
# Generated: 2026-02-02
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_organizations_policy_attachment" "example" {
  #---------------------------------------------------------------
  # 必須パラメータ
  #---------------------------------------------------------------

  # ポリシーID
  # アタッチするポリシーの一意の識別子（ID）を指定します。
  #
  # - 形式: "p-" で始まり、その後に英数字が続く文字列
  # - 例: "p-FullAWSAccess", "p-12345678"
  # - aws_organizations_policy リソースで作成したポリシーのIDを参照することが一般的です
  # - サービスコントロールポリシー、タグポリシー、バックアップポリシーなど、
  #   様々なポリシータイプのIDを指定できます
  #
  # 参考: https://docs.aws.amazon.com/organizations/latest/APIReference/API_AttachPolicy.html
  policy_id = "p-FullAWSAccess"

  # ターゲットID
  # ポリシーをアタッチする対象の一意の識別子（ID）を指定します。
  # ルート、組織単位（OU）、またはアカウント番号を指定できます。
  #
  # - ルートID: "r-" で始まり、その後に4〜32文字の小文字英数字が続く
  #   例: "r-a1b2", aws_organizations_organization.example.roots[0].id
  #
  # - 組織単位（OU）ID: "ou-" で始まり、ルートIDと8〜32文字の小文字英数字が続く
  #   例: "ou-a1b2-c3d4e5f6", aws_organizations_organizational_unit.example.id
  #
  # - アカウントID: 正確に12桁の数字
  #   例: "123456789012"
  #
  # ポリシーの変更は即座に有効になり、アタッチされたアカウント（または
  # アタッチされたルート/OU配下の全アカウント）のIAMユーザーとロールの
  # 権限に影響を与えます。
  #
  # 参考: https://docs.aws.amazon.com/organizations/latest/APIReference/API_AttachPolicy.html
  target_id = "123456789012"

  #---------------------------------------------------------------
  # オプションパラメータ
  #---------------------------------------------------------------

  # 削除時のスキップ設定
  # trueに設定すると、リソースの削除（destroy）時にポリシーをデタッチせず、
  # Terraformの状態からのみリソースを削除します。
  #
  # - デフォルト: false
  # - trueに設定すると、terraform destroyを実行してもポリシーのアタッチメントは
  #   AWSに残り続けます
  # - 用途: AWSの最低要件として1つのポリシーをアタッチしておく必要がある場合など、
  #   アタッチメントを保持しなければならない状況で使用します
  # - 注意: この設定を使用する場合は、手動でポリシーをデタッチする必要があります
  #
  # 例: 組織のルートに最低1つのSCPが必要な場合
  # skip_destroy = true
  skip_destroy = false
}

#---------------------------------------------------------------
# Attributes Reference（参照専用属性）
#---------------------------------------------------------------
# 以下の属性はリソース作成後に参照可能ですが、設定はできません。
#
# - id: ポリシーアタッチメントの識別子（形式: "target_id:policy_id"）
#   例: "123456789012:p-FullAWSAccess"
#   この値を使用してアタッチメントを一意に識別できます。
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# 使用例
#---------------------------------------------------------------

# 例1: アカウントへのSCPアタッチ
# resource "aws_organizations_policy_attachment" "account" {
#   policy_id = aws_organizations_policy.example.id
#   target_id = "123456789012"
# }

# 例2: 組織ルートへのポリシーアタッチ
# resource "aws_organizations_policy_attachment" "root" {
#   policy_id = aws_organizations_policy.example.id
#   target_id = aws_organizations_organization.example.roots[0].id
# }

# 例3: 組織単位（OU）へのポリシーアタッチ
# resource "aws_organizations_policy_attachment" "unit" {
#   policy_id = aws_organizations_policy.example.id
#   target_id = aws_organizations_organizational_unit.example.id
# }

# 例4: 削除時にアタッチメントを保持
# resource "aws_organizations_policy_attachment" "protected" {
#   policy_id    = aws_organizations_policy.example.id
#   target_id    = aws_organizations_organization.example.roots[0].id
#   skip_destroy = true
# }

#---------------------------------------------------------------
# 注意事項
#---------------------------------------------------------------
# 1. ポリシーのアタッチには organizations:AttachPolicy 権限が必要です
# 2. この操作は管理アカウントまたは委任管理者アカウントからのみ実行できます
# 3. ポリシーの変更は即座に有効になり、ターゲットのアカウントに影響します
# 4. 複数のポリシーを同じターゲットにアタッチできます
# 5. ポリシータイプによっては、ターゲットで有効化されている必要があります
#---------------------------------------------------------------
