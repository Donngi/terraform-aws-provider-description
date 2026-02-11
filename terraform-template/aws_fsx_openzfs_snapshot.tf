#---------------------------------------------------------------
# Amazon FSx for OpenZFS Snapshot
#---------------------------------------------------------------
#
# Amazon FSx for OpenZFS スナップショットのリソースを管理します。
# スナップショットは特定の時点のボリュームの読み取り専用イメージで、
# 誤削除や変更からデータを保護します。
#
# AWS公式ドキュメント:
#   - Protecting your data with snapshots: https://docs.aws.amazon.com/fsx/latest/OpenZFSGuide/snapshots-openzfs.html
#   - CreateSnapshot API: https://docs.aws.amazon.com/fsx/latest/APIReference/API_CreateSnapshot.html
#   - Protecting your Amazon FSx for OpenZFS data: https://docs.aws.amazon.com/fsx/latest/OpenZFSGuide/protecting-data.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/fsx_openzfs_snapshot
#
# Provider Version: 6.28.0
# Generated: 2026-01-27
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_fsx_openzfs_snapshot" "example" {
  # (Required) スナップショットの名前
  # 最大203文字の英数字と _ - : . の記号を使用可能
  name = "example-snapshot"

  # (Required) スナップショット対象のボリュームID
  # ルートボリュームまたは子ボリュームのIDを指定可能
  # ルートボリュームの場合: aws_fsx_openzfs_file_system.example.root_volume_id
  # 子ボリュームの場合: aws_fsx_openzfs_volume.example.id
  volume_id = "fsvol-0123456789abcdef0"

  # (Optional) リソースに割り当てるタグのマップ
  # プロバイダーの default_tags が設定されている場合、
  # マッチするキーのタグはプロバイダーレベルで上書きされます
  tags = {
    Name        = "example-snapshot"
    Environment = "production"
  }

  # (Optional) このリソースが管理されるAWSリージョン
  # 未指定の場合、プロバイダー設定のリージョンがデフォルトで使用されます
  # region = "us-east-1"

  # (Optional) タイムアウト設定
  # 各オペレーションのタイムアウト時間を設定可能
  timeouts {
    # (Optional) スナップショット作成のタイムアウト時間
    # デフォルト: 30m
    create = "30m"

    # (Optional) スナップショット更新のタイムアウト時間
    # デフォルト: 30m
    update = "30m"

    # (Optional) スナップショット削除のタイムアウト時間
    # デフォルト: 30m
    delete = "30m"

    # (Optional) スナップショット読み取りのタイムアウト時間
    # デフォルト: 30m
    read = "30m"
  }
}

#---------------------------------------------------------------
# Attributes Reference
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします（computed only）:
#
# - arn - スナップショットのAmazon Resource Name
# - creation_time - スナップショットの作成時刻
# - id - スナップショットの識別子（例: fsvolsnap-12345678）
# - tags_all - プロバイダーの default_tags を含む、リソースに割り当てられた全タグのマップ
#---------------------------------------------------------------
