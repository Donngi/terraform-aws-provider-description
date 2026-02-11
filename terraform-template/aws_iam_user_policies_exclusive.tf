#---------------------------------------------------------------
# AWS IAM User Policies Exclusive
#---------------------------------------------------------------
#
# IAMユーザーに割り当てられたインラインポリシーの排他的管理を維持する
# Terraformリソースです。このリソースは、IAMユーザーに割り当てられた
# インラインポリシーの排他的所有権を取得し、明示的に設定されていない
# インラインポリシーの削除を含めて管理します。
#
# 重要な注意事項:
#   - このリソースは、ユーザーに割り当てられたインラインポリシーの排他的
#     所有権を取得します。これには、明示的に設定されていないインラインポリシーの
#     削除が含まれます。
#   - 永続的なドリフトを防ぐために、このリソースと並行して管理される
#     aws_iam_user_policyリソースをpolicy_names引数に含めるようにしてください。
#   - このリソースの削除は、Terraformが設定されたインラインポリシー割り当ての
#     調整を管理しなくなることを意味します。ただし、ユーザーから設定された
#     ポリシーを削除することはありません。
#
# AWS公式ドキュメント:
#   - IAMポリシーの概要: https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies.html
#   - IAMユーザーへのポリシー追加: https://docs.aws.amazon.com/IAM/latest/UserGuide/id_users_change-permissions.html
#   - インラインポリシーとマネージドポリシー: https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies_managed-vs-inline.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user_policies_exclusive
#
# Provider Version: 6.28.0
# Generated: 2026-02-04
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_iam_user_policies_exclusive" "example" {
  #-------------------------------------------------------------
  # ユーザー設定
  #-------------------------------------------------------------

  # user_name (Required)
  # 設定内容: インラインポリシーを排他的に管理するIAMユーザー名を指定します。
  # 設定可能な値: 有効なIAMユーザー名（1-64文字の英数字と+, =, ,, ., @, -, _の文字）
  # 関連機能: IAM User Management
  #   IAMユーザーは、AWSリソースへのアクセス権限を持つエンティティです。
  #   各ユーザーには一意の名前があり、この名前を使用してポリシーを管理します。
  #   - https://docs.aws.amazon.com/IAM/latest/UserGuide/id_users.html
  # 参考: https://docs.aws.amazon.com/IAM/latest/APIReference/API_CreateUser.html
  user_name = "example-user"

  #-------------------------------------------------------------
  # ポリシー設定
  #-------------------------------------------------------------

  # policy_names (Required)
  # 設定内容: ユーザーに割り当てるインラインポリシー名のリストを指定します。
  # 設定可能な値: インラインポリシー名の文字列セット（各ポリシー名は1-128文字）
  # 動作仕様:
  #   - このリストに含まれるポリシーのみがユーザーに割り当てられます
  #   - ユーザーに既に割り当てられているが、このリストに含まれないポリシーは削除されます
  #   - 空のリスト[]を指定すると、すべてのインラインポリシーが削除されます
  # 関連機能: Inline Policy Management
  #   インラインポリシーは、特定のIAMユーザー、グループ、またはロールに直接
  #   埋め込まれるポリシーです。インラインポリシーは、そのアイデンティティとの間に
  #   厳密な1対1の関係を維持します。
  #   - https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies_managed-vs-inline.html
  # 注意:
  #   - aws_iam_user_policyリソースと併用する場合、そのポリシー名を必ず含めてください
  #   - policy_namesに含まれないポリシーは自動的に削除されます
  # 参考: https://docs.aws.amazon.com/IAM/latest/UserGuide/id_users_change-permissions.html
  policy_names = [
    "example-inline-policy-1",
    "example-inline-policy-2",
  ]
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは、引数として設定された値以外にエクスポートされる属性はありません。
#
# Terraform Stateには以下の情報が保存されます:
# - user_name: 管理対象のIAMユーザー名
# - policy_names: 管理対象のインラインポリシー名のセット
#---------------------------------------------------------------
