#---------------------------------------------------------------
# Amazon Managed Grafana Role Association
#---------------------------------------------------------------
#
# Amazon Managed Grafana ワークスペースに対するユーザーまたはグループの
# ロール割り当てを管理するリソース。AWS IAM Identity Center または SAML で
# 認証されたユーザー/グループに対して、ADMIN、EDITOR、VIEWER のいずれかの
# ロールを付与できます。
#
# AWS公式ドキュメント:
#   - User roles: https://docs.aws.amazon.com/grafana/latest/userguide/Grafana-user-roles.html
#   - Manage user and group access: https://docs.aws.amazon.com/grafana/latest/userguide/AMG-manage-users-and-groups-AMG.html
#   - UpdateInstruction API: https://docs.aws.amazon.com/grafana/latest/APIReference/API_UpdateInstruction.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/grafana_role_association
#
# Provider Version: 6.28.0
# Generated: 2026-01-27
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_grafana_role_association" "example" {
  #---------------------------------------------------------------
  # Required Arguments
  #---------------------------------------------------------------

  # (Required) Grafana ワークスペースに割り当てるロール。
  #
  # 有効な値:
  #   - ADMIN:  データソース、ユーザー、チーム、フォルダの管理が可能。
  #             Editor ロールの全ての権限を含む。
  #   - EDITOR: ダッシュボード、パネル、アラートルールの表示・編集・作成が可能。
  #             プレイリストの作成・更新・削除、Explore へのアクセス、
  #             通知チャネルの管理が可能。Viewer ロールの全ての権限を含む。
  #   - VIEWER: ダッシュボードの表示のみ可能。編集や管理操作は不可。
  #
  # 参照: https://docs.aws.amazon.com/grafana/latest/APIReference/API_UpdateInstruction.html#ManagedGrafana-Type-UpdateInstruction-role
  role = "ADMIN"

  # (Required) ロールを割り当てる Amazon Managed Grafana ワークスペースの ID。
  #
  # 形式: g-[0-9a-f]{10}
  # 例: g-1234567890
  #
  # aws_grafana_workspace リソースの id 属性を参照することが一般的です。
  workspace_id = aws_grafana_workspace.example.id

  #---------------------------------------------------------------
  # Optional Arguments
  #---------------------------------------------------------------

  # (Optional) 指定されたロールを割り当てる AWS IAM Identity Center グループの ID リスト。
  #
  # - user_ids と group_ids の少なくとも一方を指定する必要があります。
  # - IAM Identity Center で認証を行うワークスペースでのみ使用可能です。
  # - グループに所属するユーザー全員に対してロールが適用されます。
  #
  # 例: ["90a6f1a1-d0e1-7032-5ab6-example1", "90a6f1a1-d0e1-7032-5ab6-example2"]
  group_ids = []

  # (Optional) 指定されたロールを割り当てる AWS IAM Identity Center ユーザーの ID リスト。
  #
  # - user_ids と group_ids の少なくとも一方を指定する必要があります。
  # - IAM Identity Center で認証を行うワークスペースでのみ使用可能です。
  # - SAML 認証のワークスペースでは、アサーション属性でロールを定義します。
  #
  # 例: ["90a6f1a1-d0e1-7032-5ab6-user001", "90a6f1a1-d0e1-7032-5ab6-user002"]
  user_ids = []

  # (Optional) このリソースが管理されるリージョン。
  #
  # - 指定しない場合、プロバイダー設定のリージョンがデフォルトで使用されます。
  # - 明示的にリージョンを指定する場合に使用します。
  #
  # 参照: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-east-1"

  #---------------------------------------------------------------
  # Timeouts Block (Optional)
  #---------------------------------------------------------------

  # リソースの作成・削除時のタイムアウト設定。
  timeouts {
    # (Optional) リソース作成時のタイムアウト。
    # デフォルト: タイムアウトなし
    # 形式: "10m" (10分), "1h" (1時間) など
    # create = "10m"

    # (Optional) リソース削除時のタイムアウト。
    # デフォルト: タイムアウトなし
    # 形式: "10m" (10分), "1h" (1時間) など
    # delete = "10m"
  }
}

#---------------------------------------------------------------
# Attributes Reference
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: リソースの一意な識別子 (computed)
#     形式: {workspace_id}/{role}
#     例: g-1234567890/ADMIN
#
# - region: リソースが管理されているリージョン (computed)
#     指定した場合はその値、指定しない場合はプロバイダー設定のリージョン
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# 使用例
#---------------------------------------------------------------

# Example: IAM Identity Center ユーザーに Admin ロールを割り当て
# resource "aws_grafana_role_association" "admin_users" {
#   role         = "ADMIN"
#   user_ids     = ["90a6f1a1-d0e1-7032-5ab6-user001"]
#   workspace_id = aws_grafana_workspace.example.id
# }

# Example: IAM Identity Center グループに Editor ロールを割り当て
# resource "aws_grafana_role_association" "editor_group" {
#   role         = "EDITOR"
#   group_ids    = ["90a6f1a1-d0e1-7032-5ab6-group001"]
#   workspace_id = aws_grafana_workspace.example.id
# }

# Example: 複数のユーザーに Viewer ロールを割り当て
# resource "aws_grafana_role_association" "viewer_users" {
#   role = "VIEWER"
#   user_ids = [
#     "90a6f1a1-d0e1-7032-5ab6-user002",
#     "90a6f1a1-d0e1-7032-5ab6-user003",
#   ]
#   workspace_id = aws_grafana_workspace.example.id
# }

#---------------------------------------------------------------
# 重要な注意事項
#---------------------------------------------------------------
#
# 1. IAM Identity Center の前提条件:
#    - このリソースを使用するには、Amazon Managed Grafana ワークスペースが
#      IAM Identity Center 認証を使用している必要があります。
#    - SAML 認証のワークスペースでは、ロールはアサーション属性で定義します。
#
# 2. 必要な IAM ポリシー:
#    - AWSGrafanaWorkspacePermissionManagementV2 または同等の権限が必要です。
#    - IAM Identity Center ユーザーの場合、追加のポリシーが必要になる場合があります。
#
# 3. user_ids と group_ids:
#    - 少なくとも一方を指定する必要があります。
#    - 両方を同時に指定することも可能です。
#
# 4. ロールの競合:
#    - 同じワークスペースに対して、同じロールを持つ複数の
#      aws_grafana_role_association リソースを作成できます。
#    - 異なるユーザー/グループセットに対して同じロールを割り当てる場合は
#      別々のリソースを作成します。
#
# 5. ロールの権限階層:
#    - ADMIN > EDITOR > VIEWER の順に権限が広がります。
#    - ユーザーに複数のロールを割り当てた場合、最も高い権限が適用されます。
#
#---------------------------------------------------------------
