#---------------------------------------------------------------
# IAM Role Inline Policies Exclusive Management
#---------------------------------------------------------------
#
# IAMロールのインラインポリシーを排他的に管理するためのリソースです。
# このリソースは、指定されたインラインポリシーのみをロールに適用し、
# それ以外のインラインポリシーは自動的に削除します。
#
# 重要な注意事項:
#   - このリソースは、ロールに割り当てられたインラインポリシーの排他的な所有権を持ちます
#   - 明示的に設定されていないインラインポリシーは削除されます
#   - 永続的なドリフトを防ぐため、このリソースと併用する aws_iam_role_policy リソースは
#     必ず policy_names 引数に含める必要があります
#   - このリソースを削除すると、Terraform は設定されたインラインポリシーの管理を停止しますが、
#     ポリシー自体はロールから削除されません
#
# ユースケース:
#   - インラインポリシーの厳密な管理が必要な場合
#   - 予期しないポリシーの追加を防ぎたい場合
#   - Terraformで管理されていないインラインポリシーを自動削除したい場合
#   - インラインポリシーを完全に禁止したい場合（policy_names = [] を設定）
#
# AWS公式ドキュメント:
#   - IAM ロール: https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles.html
#   - IAM インラインポリシーとマネージドポリシー: https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies-choosing-managed-or-inline.html
#   - IAM Best Practices: https://docs.aws.amazon.com/IAM/latest/UserGuide/best-practices.html
#   - PutRolePolicy API: https://docs.aws.amazon.com/IAM/latest/APIReference/API_PutRolePolicy.html
#   - DeleteRolePolicy API: https://docs.aws.amazon.com/IAM/latest/APIReference/API_DeleteRolePolicy.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/iam_role_policies_exclusive
#
# Provider Version: 6.28.0
# Generated: 2026-02-04
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_iam_role_policies_exclusive" "example" {
  #---------------------------------------------------------------
  # 必須パラメータ
  #---------------------------------------------------------------

  # role_name (Required)
  # 設定内容: インラインポリシーを排他的に管理するIAMロールの名前を指定します。
  # 設定可能な値: 既存のIAMロール名
  # 用途: このロールに対するインラインポリシーの割り当てを排他的に制御します
  # 関連機能: IAM ロール
  #   IAMロールは、特定の権限を持つAWSアイデンティティです。
  #   ロールは、信頼されたエンティティ（ユーザー、アプリケーション、またはサービス）によって引き受けられます。
  #   - https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles.html
  #
  # 制約:
  #   - 形式: 英数字、プラス(+)、等号(=)、カンマ(,)、ピリオド(.)、アットマーク(@)、アンダースコア(_)、ハイフン(-)
  #   - 最大長: 64文字
  #
  # 例:
  #   role_name = "my-application-role"
  #   role_name = aws_iam_role.example.name
  role_name = aws_iam_role.example.name

  # policy_names (Required)
  # 設定内容: ロールに割り当てるインラインポリシー名のセットを指定します。
  # 設定可能な値: インラインポリシー名の文字列セット。空のセット [] を設定すると全インラインポリシーを削除
  # 用途: このリソースが管理するインラインポリシーを明示的に定義します
  # 動作: このリストに含まれないインラインポリシーは自動的にロールから削除されます
  # 関連機能: IAM インラインポリシー
  #   インラインポリシーは、ロールに直接埋め込まれるポリシーです。
  #   ポリシーとアイデンティティの間に厳密な1対1の関係を維持します。
  #   - https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies_managed-vs-inline.html
  #
  # 注意:
  #   - aws_iam_role_policy リソースで作成されたポリシーは、そのポリシー名をこのリストに含める必要があります
  #   - 空のリスト [] を設定すると、すべてのインラインポリシーが削除され、実質的にインラインポリシーの使用を禁止します
  #   - Terraformで管理されていないインラインポリシーがロールに追加された場合、次回の apply で削除されます
  #
  # 例:
  #   policy_names = [aws_iam_role_policy.example.name]
  #   policy_names = ["policy1", "policy2", "policy3"]
  #   policy_names = []  # すべてのインラインポリシーを禁止
  policy_names = [aws_iam_role_policy.example.name]
}


#---------------------------------------------------------------
# Attributes Reference (読み取り専用)
#---------------------------------------------------------------
#
# このリソースは、引数として設定された属性以外に追加のエクスポート属性はありません。
#
# 設定された属性:
#
# - role_name
#     インラインポリシーを管理しているIAMロール名
#

# 例1: 基本的な使用方法 - 特定のインラインポリシーのみを許可
resource "aws_iam_role_policies_exclusive" "basic_example" {
  role_name    = aws_iam_role.example.name
  policy_names = [aws_iam_role_policy.example.name]
}

resource "aws_iam_role_policy" "example" {
  name = "example-policy"
  role = aws_iam_role.example.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
#---------------------------------------------------------------
#
# 1. インラインポリシー vs マネージドポリシー
#    - 可能な限りマネージドポリシー（aws_iam_role_policy_attachment）を使用してください
#    - インラインポリシーは、ポリシーとロールの間に厳密な1対1の関係が必要な場合のみ使用
#    - 参考: https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies-choosing-managed-or-inline.html
#
# 2. 排他的管理の利点
#    - Terraformで管理されていないポリシーの自動削除により、設定のドリフトを防止
#    - セキュリティ要件の遵守を強制（例: インラインポリシーの完全禁止）
#    - インフラストラクチャの状態を宣言的に管理
#
# 3. 移行戦略
#    - 既存のロールに適用する前に、現在のインラインポリシーを確認してください
#    - 必要なポリシーをすべて policy_names に含めるか、aws_iam_role_policy で再作成してください
#    - テスト環境で最初に検証することを推奨します
#
# 4. aws_iam_role の inline_policy との競合回避
#    - このリソースは aws_iam_role の inline_policy 引数と併用できません
#    - 両方を使用すると永続的な差分が発生します
#    - インラインポリシーの管理には、このリソースまたは aws_iam_role_policy を使用してください
#
# 5. セキュリティのベストプラクティス
#    - 最小権限の原則に従ってポリシーを設計してください
#    - 定期的にポリシーを見直し、不要な権限を削除してください
#    - インラインポリシーの使用を最小限に抑え、可能な限りマネージドポリシーを優先してください
#
