#---------------------------------------------------------------
# Amazon EBS Fast Snapshot Restore
#---------------------------------------------------------------
#
# EBS Fast Snapshot Restore (FSR)を管理するTerraformリソースです。
# FSRを有効化すると、スナップショットから作成されるEBSボリュームが
# 初期化の遅延なしに即座にフルパフォーマンスを提供できるようになります。
#
# 主な特徴:
# - スナップショットごと、アベイラビリティゾーンごとに有効化
# - 16TiB以下のスナップショットでサポート
# - リージョンあたり最大5つのスナップショットで有効化可能
# - 有効化している間、分単位で課金（最低1時間）
#
# AWS公式ドキュメント:
#   - Amazon EBS fast snapshot restore:
#     https://docs.aws.amazon.com/ebs/latest/userguide/ebs-fast-snapshot-restore.html
#   - Configure fast snapshot restore:
#     https://docs.aws.amazon.com/ebs/latest/userguide/manage-fsr-enable.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ebs_fast_snapshot_restore
#
# Provider Version: 6.28.0
# Generated: 2026-01-28
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_ebs_fast_snapshot_restore" "example" {
  #---------------------------------------------------------------
  # Required Attributes
  #---------------------------------------------------------------

  # availability_zone - (Required) アベイラビリティゾーン
  # Fast Snapshot Restoreを有効化するアベイラビリティゾーンを指定します。
  # FSRはスナップショットごと、AZごとに有効化する必要があります。
  # 例: "us-west-2a", "ap-northeast-1a"
  availability_zone = "us-west-2a"

  # snapshot_id - (Required) スナップショットID
  # Fast Snapshot Restoreを有効化する対象のEBSスナップショットのIDを指定します。
  # 16TiB以下のスナップショットでのみサポートされます。
  # 例: "snap-1234567890abcdef0"
  snapshot_id = aws_ebs_snapshot.example.id


  #---------------------------------------------------------------
  # Optional Attributes
  #---------------------------------------------------------------

  # region - (Optional) リージョン
  # このリソースを管理するAWSリージョンを指定します。
  # 指定しない場合は、プロバイダー設定のリージョンが使用されます。
  # 例: "us-west-2", "ap-northeast-1"
  # region = "us-west-2"


  #---------------------------------------------------------------
  # Timeouts
  #---------------------------------------------------------------
  # リソースの作成・削除操作のタイムアウト設定です。
  # Fast Snapshot Restoreの有効化には時間がかかる場合があります。
  # 状態が"enabling" -> "optimizing" -> "enabled"と遷移します。

  timeouts {
    # create - (Optional) 作成タイムアウト
    # Fast Snapshot Restoreの有効化にかかる最大時間を指定します。
    # デフォルトは10分です。
    # 形式: "30s", "5m", "2h45m"など
    # create = "10m"

    # delete - (Optional) 削除タイムアウト
    # Fast Snapshot Restoreの無効化にかかる最大時間を指定します。
    # デフォルトは10分です。
    # 形式: "30s", "5m", "2h45m"など
    # delete = "10m"
  }
}


#---------------------------------------------------------------
# Attributes Reference
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします（computed only）:
#
# - id
#   リソースID。"availability_zone,snapshot_id"の形式
#   例: "us-west-2a,snap-1234567890abcdef0"
#
# - state
#   Fast Snapshot Restoreの状態
#   可能な値: "enabling", "optimizing", "enabled", "disabling", "disabled"
#   - enabling: 有効化処理中
#   - optimizing: 最適化処理中（この段階でもボリューム作成は可能）
#   - enabled: 完全に有効化され、フルパフォーマンスを提供
#   - disabling: 無効化処理中
#   - disabled: 無効化済み
#
#---------------------------------------------------------------


#---------------------------------------------------------------
# 使用例
#---------------------------------------------------------------

# Example 1: 基本的な使用例
resource "aws_ebs_snapshot" "example" {
  volume_id = aws_ebs_volume.example.id

  tags = {
    Name = "example-snapshot"
  }
}

resource "aws_ebs_volume" "example" {
  availability_zone = "us-west-2a"
  size              = 40

  tags = {
    Name = "example-volume"
  }
}

resource "aws_ebs_fast_snapshot_restore" "example_basic" {
  availability_zone = "us-west-2a"
  snapshot_id       = aws_ebs_snapshot.example.id
}

# Example 2: 複数のアベイラビリティゾーンで有効化
resource "aws_ebs_fast_snapshot_restore" "multi_az" {
  for_each = toset([
    "us-west-2a",
    "us-west-2b",
    "us-west-2c"
  ])

  availability_zone = each.key
  snapshot_id       = aws_ebs_snapshot.example.id
}

# Example 3: タイムアウト設定のカスタマイズ
resource "aws_ebs_fast_snapshot_restore" "custom_timeout" {
  availability_zone = "us-west-2a"
  snapshot_id       = aws_ebs_snapshot.example.id

  timeouts {
    create = "15m"
    delete = "15m"
  }
}


#---------------------------------------------------------------
# 重要な注意事項
#---------------------------------------------------------------
#
# 1. 課金について
#    - Fast Snapshot Restoreは有効化している間、分単位で課金されます
#    - 最低課金時間は1時間です
#    - 共有されたスナップショットでFSRを有効化した場合、
#      課金されるのは有効化したアカウントです（所有者ではありません）
#
# 2. クォータ
#    - リージョンあたり最大5つのスナップショットでFSRを有効化可能
#    - 自分が所有するスナップショットと共有されたスナップショットの両方がカウントされます
#
# 3. 制約
#    - 16TiB以下のスナップショットでのみサポート
#    - AWS Outposts、Local Zones、Wavelength Zonesではサポートされません
#    - 64,000 IOPS または 1,000 MiB/s を超えるパフォーマンスのボリュームには、
#      初期化を推奨します
#
# 4. ボリューム作成クレジット
#    - FSRにはクレジットバケットの概念があります
#    - スナップショットサイズに基づいて、クレジットバケットのサイズと
#      補充レートが決まります
#    - クレジットが不足すると、フルパフォーマンスでボリュームを作成できません
#
# 5. 状態遷移
#    - enabling -> optimizing -> enabled
#    - optimizing状態でもボリューム作成は可能ですが、
#      enabled状態でフルパフォーマンスが得られます
#
#---------------------------------------------------------------
