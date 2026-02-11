#---------------------------------------------------------------
# AWS IAM Group Policies Exclusive
#---------------------------------------------------------------
#
# IAMグループに関連付けられたインラインポリシーの排他的管理を行う
# Terraformリソースです。このリソースを使用することで、指定した
# インラインポリシーのみをグループに保持し、それ以外のインライン
# ポリシーを自動的に削除することができます。
#
# 主な特徴:
# - グループのインラインポリシーに対する完全な制御
# - Terraform管理外のポリシーの自動削除（ドリフト検出と修正）
# - インラインポリシーの完全禁止も可能（policy_names = []）
# - マネージドポリシーには影響しない
#
# 重要な注意事項:
# 1. 排他的所有権の取得
#    このリソースは指定されたグループのインラインポリシーに対する
#    排他的所有権を取得します。明示的にpolicy_namesに含まれていない
#    インラインポリシーは、次回のapply時に自動的に削除されます。
#
# 2. aws_iam_group_policyとの併用
#    aws_iam_group_policyリソースでインラインポリシーを作成している場合、
#    必ずそのポリシー名をpolicy_namesに含める必要があります。
#    含めない場合、aws_iam_group_policyで作成したポリシーも削除されます。
#
# 3. リソース削除時の動作
#    このリソースを削除（terraform destroy）しても、グループから
#    インラインポリシーは削除されません。Terraformによる排他的管理が
#    停止されるだけです。ポリシーを完全に削除したい場合は、削除前に
#    policy_names = [] に設定してapplyしてください。
#
# 4. マネージドポリシーとの違い
#    このリソースはインラインポリシーのみを管理します。
#    マネージドポリシー（aws_iam_policy_attachmentなどで割り当て）
#    には一切影響しません。
#
# ユースケース:
# - グループのインラインポリシーを厳密に管理したい場合
# - 意図しないポリシーの追加を防止したい場合
# - インラインポリシーを完全に禁止したい場合（セキュリティポリシー）
# - マルチアカウント環境でポリシーの一貫性を保ちたい場合
# - コンプライアンス要件によりポリシーの厳格な管理が必要な場合
#
# AWS公式ドキュメント:
#   - Managed policies and inline policies: https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies_managed-vs-inline.html
#   - IAM identities (users, user groups, and roles): https://docs.aws.amazon.com/IAM/latest/UserGuide/id.html
#   - ListGroupPolicies API: https://docs.aws.amazon.com/IAM/latest/APIReference/API_ListGroupPolicies.html
#   - PutGroupPolicy API: https://docs.aws.amazon.com/IAM/latest/APIReference/API_PutGroupPolicy.html
#   - DeleteGroupPolicy API: https://docs.aws.amazon.com/IAM/latest/APIReference/API_DeleteGroupPolicy.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/iam_group_policies_exclusive
#
# Provider Version: 6.28.0
# Generated: 2026-02-04
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_iam_group_policies_exclusive" "example" {
  #-------------------------------------------------------------
  # グループ名の指定 (Required)
  #-------------------------------------------------------------

  # group_name (Required)
  # 設定内容: インラインポリシーを排他的に管理するIAMグループの名前を指定します。
  # 設定可能な値: 既存のIAMグループ名（1〜128文字）
  # 使用可能文字: 英数字（大文字小文字）および + = , . @ - _
  # 制約事項:
  #   - グループは事前に作成されている必要があります
  #   - スペースは使用できません
  #   - 同一アカウント内でユニークである必要があります
  #
  # 推奨事項:
  #   - aws_iam_groupリソースで作成したグループを参照する場合は、
  #     aws_iam_group.example.name のように指定してください
  #   - ハードコードされた文字列ではなく、リソース参照を使用することで
  #     グループ名の変更に対する柔軟性が向上します
  #
  # 例:
  #   group_name = "developers"
  #   group_name = aws_iam_group.developers.name
  #   group_name = "prod-admin-group"
  #
  # 参考: https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_iam-quotas.html
  group_name = "example-group"

  #-------------------------------------------------------------
  # 許可するインラインポリシー名のリスト (Required)
  #-------------------------------------------------------------

  # policy_names (Required)
  # 設定内容: グループに保持を許可するインラインポリシーの名前のリストを指定します。
  # データ型: set(string) - 文字列のセット（重複なし）
  # 空のリスト: [] を指定するとすべてのインラインポリシーが削除されます
  #
  # 動作の詳細:
  #   1. このリストに含まれるポリシー名のみが保持されます
  #   2. リストに含まれないインラインポリシーは自動的に削除されます
  #   3. aws_iam_group_policyリソースで作成したポリシーも
  #      ここに含めない限り削除されます
  #   4. マネージドポリシー（aws_iam_policy_attachmentなど）は
  #      影響を受けません
  #
  # ユースケース別の設定例:
  #
  # 1. 特定のインラインポリシーのみを許可:
  #    policy_names = [
  #      aws_iam_group_policy.s3_read.name,
  #      aws_iam_group_policy.cloudwatch_logs.name
  #    ]
  #
  # 2. インラインポリシーを完全に禁止（ベストプラクティス）:
  #    policy_names = []
  #    理由: マネージドポリシーの使用が推奨されるため
  #
  # 3. 動的なポリシー管理:
  #    policy_names = concat(
  #      [aws_iam_group_policy.base.name],
  #      var.additional_policies
  #    )
  #
  # セキュリティのベストプラクティス:
  #   - インラインポリシーよりもマネージドポリシーの使用を推奨
  #   - 必要最小限のポリシーのみを許可
  #   - 定期的にポリシーの見直しを実施
  #   - 監査ログ（CloudTrail）でポリシー変更を追跡
  #
  # 注意事項:
  #   - ポリシー名の大文字小文字は区別されます
  #   - 存在しないポリシー名を指定してもエラーにはなりません
  #   - 空のリストを設定すると、既存のすべてのインラインポリシーが削除されます
  #
  # 参考:
  #   - Why use managed policies: https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies_managed-vs-inline.html#choosing-managed-or-inline
  #   - IAM policy best practices: https://docs.aws.amazon.com/IAM/latest/UserGuide/best-practices.html
  policy_names = [
    # 例: aws_iam_group_policy.example.name,
    # 例: "custom-inline-policy",
  ]

  #-------------------------------------------------------------
  # ライフサイクル設定
  #-------------------------------------------------------------

  # 重要な注意事項:
  # このリソースを削除（terraform destroy）した場合、グループから
  # インラインポリシーは削除されません。Terraformによる排他的管理が
  # 停止されるだけです。
  #
  # ポリシーを完全に削除したい場合の手順:
  # 1. policy_names = [] に設定
  # 2. terraform apply を実行（ポリシーが削除される）
  # 3. その後、このリソースを削除（terraform destroy）
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
#
# このリソースは追加のcomputed属性をエクスポートしません。
# 入力として指定したgroup_nameとpolicy_namesのみが利用可能です。
#

#---------------------------------------------------------------
#
# セキュリティのベストプラクティスとして、インラインポリシーを
# 完全に禁止し、マネージドポリシーのみを使用する構成です。
#
# resource "aws_iam_group" "developers" {
#   name = "developers"
#   path = "/engineering/"
# }
#
# resource "aws_iam_group_policies_exclusive" "no_inline_policies" {
#   group_name   = aws_iam_group.developers.name
#   policy_names = []
# }
#
# # マネージドポリシーは通常通り使用可能
# resource "aws_iam_group_policy_attachment" "developer_access" {
#---------------------------------------------------------------
