#---------------------------------------------------------------
# Amazon QuickSight IAM Policy Assignment
#---------------------------------------------------------------
#
# Amazon QuickSightのユーザーまたはグループにIAMポリシーを割り当てるための
# リソースです。QuickSightのアクセス制御を管理し、特定のユーザーやグループに
# AWS IAMポリシーを適用することで、QuickSightリソースへのアクセス権限を制御します。
#
# AWS公式ドキュメント:
#   - QuickSight API Operations for IAMPolicy Assignments: https://docs.aws.amazon.com/quicksight/latest/APIReference/controlling-access.html
#   - QuickSight Namespace Operations: https://docs.aws.amazon.com/quicksight/latest/developerguide/namespace-operations.html
#   - Permissions for QuickSight Resources: https://docs.aws.amazon.com/quicksight/latest/APIReference/qs-api-permissions.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/quicksight_iam_policy_assignment
#
# Provider Version: 6.28.0
# Generated: 2026-02-04
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_quicksight_iam_policy_assignment" "example" {
  #---------------------------------------------------------------
  # 必須パラメータ
  #---------------------------------------------------------------

  # assignment_name - (Required) アサインメントの名前
  # QuickSight IAMポリシー割り当てを識別するための名前を指定します。
  # この名前は、後で割り当てを参照する際に使用されます。
  # AWSアカウント内で一意である必要があります。
  assignment_name = "example-assignment"

  # assignment_status - (Required) アサインメントのステータス
  # 有効な値: ENABLED, DISABLED, DRAFT
  # - ENABLED: アサインメントを有効化し、指定したIAMポリシーをユーザー/グループに適用
  # - DISABLED: アサインメントを無効化し、ポリシーの適用を停止
  # - DRAFT: ドラフト状態で保存し、後で有効化可能
  assignment_status = "ENABLED"

  #---------------------------------------------------------------
  # オプションパラメータ
  #---------------------------------------------------------------

  # aws_account_id - (Optional, Forces new resource) AWSアカウントID
  # デフォルト: Terraform AWSプロバイダーのアカウントIDが自動的に使用されます
  # 異なるAWSアカウントのQuickSightリソースを管理する場合に明示的に指定します。
  # この値を変更すると新しいリソースが作成されます（リソースの再作成）。
  # aws_account_id = "123456789012"

  # namespace - (Optional) アサインメントを含むネームスペース
  # デフォルト: "default"
  # QuickSightのネームスペースは、ユーザーとグループを論理的に分離するための
  # コンテナです。マルチテナンシー環境で異なるクライアントやチームを
  # 分離する際に使用します。
  # namespace = "default"

  # policy_arn - (Optional) 割り当てるIAMポリシーのARN
  # Amazon QuickSightのユーザーおよびグループに適用するIAMポリシーのARNを指定します。
  # AWS管理ポリシーまたはカスタマー管理ポリシーのARNを使用できます。
  # 例: "arn:aws:iam::123456789012:policy/QuickSightAccessPolicy"
  # policy_arn = aws_iam_policy.example.arn

  # region - (Optional) このリソースが管理されるリージョン
  # デフォルト: プロバイダー設定で指定されたリージョンが使用されます
  # 明示的にリージョンを指定する必要がある場合に設定します。
  # QuickSightの割り当てはリージョン固有です。
  # region = "us-east-1"

  #---------------------------------------------------------------
  # ネストブロック
  #---------------------------------------------------------------

  # identities - (Optional) ポリシーを割り当てるQuickSightユーザー、グループ、またはその両方
  # IAMポリシーを適用する対象のQuickSightユーザーおよびグループを指定します。
  # ユーザーとグループの両方を指定することも、どちらか一方のみを指定することも可能です。
  # 少なくとも1つのユーザーまたはグループを指定することが推奨されます。
  identities {
    # user - (Optional) ポリシーを割り当てるQuickSightユーザー名の配列
    # QuickSightに登録されているユーザー名のリストを指定します。
    # ユーザー名は大文字小文字を区別します。
    # 例: ["user1@example.com", "user2@example.com"]
    # user = [aws_quicksight_user.example.user_name]

    # group - (Optional) ポリシーを割り当てるQuickSightグループ名の配列
    # QuickSightに存在するグループ名のリストを指定します。
    # グループ名は大文字小文字を区別します。
    # グループレベルで共有することで、より多くのプリンシパルに対して
    # 効率的にアクセスを管理できます。
    # 例: ["DataAnalysts", "DashboardViewers"]
    # group = ["example-group"]
  }
}

#---------------------------------------------------------------
# Attributes Reference
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします（computed属性）:
#
# - assignment_id
#   アサインメントのIDです。
#
# - id
#   AWSアカウントID、ネームスペース、アサインメント名をカンマ区切りで
#   結合した文字列です。
#   形式: "<aws_account_id>,<namespace>,<assignment_name>"
#
# 使用例:
#   output "assignment_id" {
#     value = aws_quicksight_iam_policy_assignment.example.assignment_id
#   }
#
#   output "assignment_full_id" {
#     value = aws_quicksight_iam_policy_assignment.example.id
#   }
#---------------------------------------------------------------
