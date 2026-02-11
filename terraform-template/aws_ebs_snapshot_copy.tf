#---------------------------------------------------------------
# EBS スナップショットコピー
#---------------------------------------------------------------
#
# 既存のEBSスナップショットの正確なコピーを作成します。
# スナップショットは同一リージョン内、別リージョン、またはLocal Zoneにコピーできます。
# 暗号化されたスナップショットのコピーは暗号化された状態を保持し、
# 未暗号化のスナップショットを暗号化してコピーすることも可能です。
#
# AWS公式ドキュメント:
#   - CopySnapshot API: https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_CopySnapshot.html
#   - EBS スナップショットのコピー: https://docs.aws.amazon.com/ebs/latest/userguide/ebs-copy-snapshot.html
#   - 暗号化とスナップショットコピー: https://docs.aws.amazon.com/ebs/latest/userguide/ebs-copy-snapshot.html#creating-encrypted-snapshots
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ebs_snapshot_copy
#
# Provider Version: 6.28.0
# Generated: 2026-01-31
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_ebs_snapshot_copy" "example" {
  #---------------------------------------------------------------
  # 必須パラメータ
  #---------------------------------------------------------------

  # コピー元スナップショットID
  # EBSスナップショットのID（例: snap-1234567890abcdef0）
  # このスナップショットがコピーされます
  source_snapshot_id = "snap-1234567890abcdef0"

  # ソースリージョン
  # コピー元スナップショットが存在するリージョンのID
  # 例: us-west-1, ap-northeast-1
  # クロスリージョンコピーの場合は必須
  source_region = "us-west-1"

  #---------------------------------------------------------------
  # オプションパラメータ
  #---------------------------------------------------------------

  # スナップショットの説明
  # EBSスナップショットの目的や内容を説明するテキスト
  # 例: "Production database backup copy for DR"
  description = null

  # 暗号化設定
  # 未暗号化のスナップショットを暗号化してコピーする場合にtrueを指定
  # 暗号化されたスナップショットのコピーは自動的に暗号化されるため、
  # その場合はこのパラメータを省略可能
  # デフォルトの暗号化設定が有効な場合は自動的に暗号化されます
  # 注意: falseを設定することはできません
  encrypted = null

  # KMSキーID
  # Amazon EBS暗号化に使用するAWS KMSキーの識別子
  # 指定しない場合、デフォルトのAWS KMSキーが使用されます
  # KmsKeyIdを指定する場合、encryptedをtrueに設定する必要があります
  #
  # 以下の形式で指定可能:
  # - キーID: 1234abcd-12ab-34cd-56ef-1234567890ab
  # - キーエイリアス: alias/ExampleAlias
  # - キーARN: arn:aws:kms:us-east-1:012345678910:key/1234abcd-12ab-34cd-56ef-1234567890ab
  # - エイリアスARN: arn:aws:kms:us-east-1:012345678910:alias/ExampleAlias
  kms_key_id = null

  # ストレージティア
  # スナップショットのストレージ階層を指定
  # 有効な値: "archive", "standard"
  # デフォルト: "standard"
  # アーカイブティアを使用すると、低頻度アクセスのスナップショットのコストを削減できます
  storage_tier = null

  # 完了期間（分）
  # 時間ベースのスナップショットコピーを開始するための完了期間を15分単位で指定
  # 時間ベースのスナップショットコピー操作は指定された期間内に完了します
  #
  # 有効範囲: 15〜2880分（15分刻み）
  # 指定しない場合、スナップショットコピー操作はベストエフォートベースで完了します
  #
  # 注意: Local ZoneやOutpostへ/からのコピーではサポートされていません
  #
  # 詳細: https://docs.aws.amazon.com/ebs/latest/userguide/time-based-copies.html
  completion_duration_minutes = null

  # 永続的復元
  # アーカイブされたスナップショットを永続的に復元するかどうかを指定
  # trueに設定すると、アーカイブティアからスタンダードティアに永続的に復元されます
  # 一時的な復元の場合はtemporary_restore_daysを使用します
  permanent_restore = null

  # 一時的復元日数
  # アーカイブされたスナップショットを一時的に復元する日数を指定
  # 一時的な復元の場合のみ必須
  # 指定した期間後、スナップショットは自動的に再アーカイブされます
  temporary_restore_days = null

  # リージョン
  # このリソースが管理されるリージョン
  # 指定しない場合、プロバイダー設定のリージョンがデフォルトとして使用されます
  #
  # 詳細: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  # タグ
  # スナップショットに適用するタグのマップ
  # プロバイダーのdefault_tags設定ブロックで定義されたタグとキーが一致する場合、
  # このタグが優先されます
  #
  # 例:
  # tags = {
  #   Name        = "production-db-snapshot-copy"
  #   Environment = "production"
  #   Purpose     = "disaster-recovery"
  # }
  tags = null

  # すべてのタグ（Computed）
  # リソースに割り当てられたすべてのタグのマップ
  # プロバイダーのdefault_tags設定ブロックから継承されたタグを含みます
  # このパラメータは読み取り専用のため、設定しないでください
  # tags_all = null

  # ID（Computed）
  # スナップショットID（例: snap-59fcb34e）
  # Terraformによって自動的に設定されます
  # 明示的に設定することも可能ですが、通常は自動生成に任せることを推奨します
  # id = null

  #---------------------------------------------------------------
  # タイムアウト設定
  #---------------------------------------------------------------

  timeouts {
    # 作成タイムアウト
    # リソース作成操作のタイムアウト時間
    # デフォルト: 適切な時間が自動設定されます
    # 例: "10m", "1h"
    create = null

    # 削除タイムアウト
    # リソース削除操作のタイムアウト時間
    # デフォルト: 適切な時間が自動設定されます
    # 例: "10m", "1h"
    delete = null
  }
}

#---------------------------------------------------------------
# Attributes Reference（参照専用属性）
#---------------------------------------------------------------
#
# 以下の属性はリソース作成後に参照可能ですが、入力パラメータとしては
# 設定できません（Computed-only属性）:
#
# - arn
#   EBSスナップショットのAmazon Resource Name (ARN)
#
# - data_encryption_key_id
#   スナップショットのデータ暗号化キー識別子
#
# - outpost_arn
#   OutpostのARN（Outpostにコピーされた場合）
#
# - owner_alias
#   スナップショット所有者を示すAmazon管理リストの値
#   可能な値: amazon, aws-marketplace, microsoft
#
# - owner_id
#   スナップショット所有者のAWSアカウントID
#
# - volume_id
#   ボリュームID（任意のソースボリュームIDが設定されます）
#   注意: このボリュームIDは任意の値であり、いかなる目的にも使用しないでください
#
# - volume_size
#   ドライブのサイズ（GiB単位）
#
#---------------------------------------------------------------
# 使用例
#---------------------------------------------------------------
#
# 基本的な使用例:
#
# resource "aws_ebs_snapshot_copy" "example" {
#   source_snapshot_id = "snap-1234567890abcdef0"
#   source_region      = "us-west-2"
#
#   tags = {
#     Name = "My Snapshot Copy"
#   }
# }
#
# 暗号化されたスナップショットのコピー:
#
# resource "aws_ebs_snapshot_copy" "encrypted_copy" {
#   source_snapshot_id = "snap-1234567890abcdef0"
#   source_region      = "us-west-2"
#   encrypted          = true
#   kms_key_id         = "arn:aws:kms:us-east-1:012345678910:key/12345678-1234-1234-1234-123456789012"
#
#   tags = {
#     Name = "Encrypted Snapshot Copy"
#   }
# }
#
# 時間ベースのスナップショットコピー:
#
# resource "aws_ebs_snapshot_copy" "time_based_copy" {
#   source_snapshot_id          = "snap-1234567890abcdef0"
#   source_region               = "us-west-2"
#   completion_duration_minutes = 60  # 1時間以内に完了
#
#   tags = {
#     Name = "Time-based Snapshot Copy"
#   }
# }
#
#---------------------------------------------------------------
