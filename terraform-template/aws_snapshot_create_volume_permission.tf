################################################################################
# AWS Snapshot Create Volume Permission
################################################################################
# EBSスナップショットから他のAWSアカウントがボリュームを作成できるように
# 権限を付与するリソース。クロスアカウントでのスナップショット共有に使用。
#
# 主な用途:
# - 別アカウントへのスナップショット共有
# - マルチアカウント環境でのデータ共有
# - バックアップデータの組織間共有
#
# 制約事項:
# - スナップショットの所有者アカウントは指定不可
# - 共有先アカウントは有効なAWSアカウントIDである必要がある
# - 権限付与後も、共有先は元のスナップショットIDを知る必要がある
#
# 注意事項:
# - スナップショットが暗号化されている場合、KMSキーの共有も必要
# - 権限削除後も既に作成されたボリュームには影響しない
# - スナップショットを削除すると、全ての権限も削除される
#
# 公式ドキュメント:
# https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/snapshot_create_volume_permission
################################################################################

resource "aws_snapshot_create_volume_permission" "example" {
  ################################################################################
  # 必須パラメータ
  ################################################################################

  # snapshot_id - (必須) EBSスナップショットID
  #
  # 権限を付与する対象のスナップショット。
  #
  # 設定例:
  # - snapshot_id = "snap-1234567890abcdef0"
  # - snapshot_id = aws_ebs_snapshot.backup.id
  #
  # 注意事項:
  # - 自身が所有するスナップショットである必要がある
  # - 存在しないスナップショットIDは指定不可
  # - 削除されたスナップショットは自動的に権限も削除される
  snapshot_id = "snap-1234567890abcdef0"

  # account_id - (必須) AWSアカウントID
  #
  # ボリューム作成権限を付与するAWSアカウントのID（12桁の数字）。
  #
  # 設定例:
  # - account_id = "123456789012"
  # - account_id = data.aws_caller_identity.sharing_target.account_id
  #
  # 注意事項:
  # - スナップショット所有者のアカウントIDは指定不可
  # - 有効なAWSアカウントIDである必要がある（12桁の数字）
  # - 同じスナップショットに対して同じアカウントIDは1つのみ
  account_id = "123456789012"

  ################################################################################
  # オプションパラメータ
  ################################################################################

  # region - (オプション) リソース管理リージョン
  #
  # このリソースが管理されるAWSリージョン。
  # 未指定の場合、プロバイダー設定のリージョンが使用される。
  #
  # 設定例:
  # - region = "us-west-2"
  # - region = "ap-northeast-1"
  #
  # 注意事項:
  # - スナップショットと同じリージョンを指定する必要がある
  # - リージョン間でのスナップショット共有は、まずコピーが必要
  # region = "us-west-2"

  ################################################################################
  # タイムアウト設定
  ################################################################################

  timeouts {
    # create - 権限付与のタイムアウト（デフォルト: 20分）
    #
    # 設定例:
    # - create = "10m"
    # - create = "30m"
    # create = "20m"

    # delete - 権限削除のタイムアウト（デフォルト: 5分）
    #
    # 設定例:
    # - delete = "5m"
    # - delete = "10m"
    # delete = "5m"
  }
}

################################################################################
# 出力値
################################################################################

# output "snapshot_permission_id" {
#   description = "スナップショット権限のID（snapshot_id-account_idの組み合わせ）"
#   value       = aws_snapshot_create_volume_permission.example.id
# }

################################################################################
# 使用例: 暗号化スナップショットの共有
################################################################################
#
# # 共有元アカウントでの設定
#
# resource "aws_ebs_volume" "source" {
#   availability_zone = "us-west-2a"
#   size              = 100
#   encrypted         = true
#   kms_key_id        = aws_kms_key.example.arn
#
#   tags = {
#     Name = "source-volume"
#   }
# }
#
# resource "aws_ebs_snapshot" "encrypted" {
#   volume_id = aws_ebs_volume.source.id
#
#   tags = {
#     Name = "encrypted-snapshot"
#   }
# }
#
# # スナップショットの権限付与
# resource "aws_snapshot_create_volume_permission" "sharing" {
#   snapshot_id = aws_ebs_snapshot.encrypted.id
#   account_id  = "123456789012"  # 共有先アカウントID
# }
#
# # KMSキーの権限も付与
# resource "aws_kms_grant" "snapshot_sharing" {
#   name              = "snapshot-sharing-grant"
#   key_id            = aws_kms_key.example.id
#   grantee_principal = "arn:aws:iam::123456789012:root"
#   operations = [
#     "Decrypt",
#     "CreateGrant"
#   ]
# }

################################################################################
# 使用例: 複数アカウントへの共有
################################################################################
#
# locals {
#   sharing_accounts = [
#     "123456789012",
#     "234567890123",
#     "345678901234"
#   ]
# }
#
# resource "aws_ebs_snapshot" "shared" {
#   volume_id = aws_ebs_volume.data.id
#
#   tags = {
#     Name = "multi-account-shared-snapshot"
#   }
# }
#
# resource "aws_snapshot_create_volume_permission" "multi_account" {
#   for_each = toset(local.sharing_accounts)
#
#   snapshot_id = aws_ebs_snapshot.shared.id
#   account_id  = each.value
# }

################################################################################
# 使用例: 組織内共有
################################################################################
#
# # 組織内の全アカウントを取得
# data "aws_organizations_organization" "main" {}
#
# # アクティブなアカウントのみを抽出
# locals {
#   active_accounts = [
#     for account in data.aws_organizations_organization.main.accounts :
#     account.id
#     if account.status == "ACTIVE" && account.id != data.aws_caller_identity.current.account_id
#   ]
# }
#
# data "aws_caller_identity" "current" {}
#
# resource "aws_ebs_snapshot" "org_shared" {
#   volume_id = aws_ebs_volume.org_data.id
#
#   tags = {
#     Name        = "org-shared-snapshot"
#     SharedScope = "organization"
#   }
# }
#
# resource "aws_snapshot_create_volume_permission" "org_sharing" {
#   for_each = toset(local.active_accounts)
#
#   snapshot_id = aws_ebs_snapshot.org_shared.id
#   account_id  = each.value
# }

################################################################################
# 使用例: 共有先での利用（別アカウント）
################################################################################
#
# # 共有先アカウントでの設定
# # 注意: スナップショットIDは共有元から別途通知される必要がある
#
# data "aws_ebs_snapshot" "shared" {
#   snapshot_ids = ["snap-1234567890abcdef0"]
#   owners       = ["987654321098"]  # 共有元アカウントID
# }
#
# resource "aws_ebs_volume" "from_shared" {
#   availability_zone = "us-west-2a"
#   snapshot_id       = data.aws_ebs_snapshot.shared.id
#
#   tags = {
#     Name   = "volume-from-shared-snapshot"
#     Source = "shared-snapshot"
#   }
# }
