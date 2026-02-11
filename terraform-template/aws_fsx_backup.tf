#---------------------------------------------------------------
# Amazon FSx Backup
#---------------------------------------------------------------
#
# AWS FSxファイルシステムまたはボリュームのバックアップを作成・管理するリソース。
# FSx for Lustre、FSx for Windows File Server、FSx for ONTAP、FSx for OpenZFSの
# バックアップをサポートし、データ保護と復旧要件に対応します。
#
# バックアップの種類:
#   - Lustre/Windows: file_system_id を使用
#   - ONTAP: volume_id を使用
#
# AWS公式ドキュメント:
#   - FSx for Windows - データ保護: https://docs.aws.amazon.com/fsx/latest/WindowsGuide/data-protection.html
#   - FSx for Lustre - バックアップ: https://docs.aws.amazon.com/fsx/latest/LustreGuide/using-backups-fsx.html
#   - FSx for ONTAP - ボリュームバックアップ: https://docs.aws.amazon.com/fsx/latest/ONTAPGuide/using-backups.html
#   - FSx for OpenZFS - バックアップ: https://docs.aws.amazon.com/fsx/latest/OpenZFSGuide/using-backups.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/fsx_backup
#
# Provider Version: 6.28.0
# Generated: 2026-01-27
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_fsx_backup" "example" {
  #---------------------------------------------------------------
  # Required/Optional Arguments
  #---------------------------------------------------------------

  # file_system_id - (Optional) ファイルシステムID
  # FSx for LustreまたはFSx for Windows File Serverのバックアップを作成する場合に必須。
  # file_system_idとvolume_idのどちらか一方を指定する必要があります。
  #
  # 対象ファイルシステム:
  #   - FSx for Lustre: 永続的ファイルシステムのみ（スクラッチファイルシステムは非対応）
  #   - FSx for Windows File Server: 全タイプ対応
  #
  # 注意事項:
  #   - Lustreの場合、S3データリポジトリにリンクされたファイルシステムはバックアップ非対応
  #   - バックアップはブロックレベルで増分バックアップとして実施されます
  #
  # Type: string
  # file_system_id = "fs-0123456789abcdef0"

  # volume_id - (Optional) ボリュームID
  # FSx for ONTAPボリュームのバックアップを作成する場合に必須。
  # file_system_idとvolume_idのどちらか一方を指定する必要があります。
  #
  # 対象ボリューム:
  #   - OntapVolumeType が read-write (RW) のボリュームのみ対応
  #
  # サポート対象外:
  #   - データ保護（DP）ボリューム
  #   - ロードシェアリングミラー（LSM）ボリューム
  #   - FlexCacheおよびSnapMirrorの宛先ボリューム
  #
  # Type: string
  # volume_id = "fsvol-0123456789abcdef0"

  # tags - (Optional) リソースタグ
  # バックアップに割り当てるタグのマップ。
  #
  # タグのコピー動作:
  #   - ボリュームの copy_tags_to_backups = true の場合、ボリュームのタグが自動コピーされます
  #   - ここでタグを1つ以上指定すると、ボリュームからのタグコピーは実行されません
  #
  # プロバイダーレベルのdefault_tagsと統合:
  #   - provider設定のdefault_tagsとマージされます
  #   - 同じキーの場合、このtagsの値が優先されます
  #
  # Type: map(string)
  # tags = {
  #   Name        = "example-fsx-backup"
  #   Environment = "production"
  #   Purpose     = "disaster-recovery"
  # }

  # region - (Optional) リージョン
  # このリソースを管理するAWSリージョン。
  #
  # デフォルト動作:
  #   - 指定しない場合、プロバイダー設定のリージョンが使用されます
  #
  # リージョン間の動作:
  #   - バックアップは作成されたリージョンに保存されます
  #   - 復元は同じリージョン内のファイルシステムにのみ可能です
  #   - クロスリージョン復元には、先にバックアップのコピーが必要です
  #
  # Type: string
  # Computed: true (デフォルトでプロバイダー設定から自動設定されます)
  # region = "us-east-1"

  # id - (Optional) リソースID
  # バックアップの一意の識別子。
  #
  # デフォルト動作:
  #   - 指定しない場合、AWSが自動的にIDを生成します
  #   - 通常、この属性を明示的に設定する必要はありません
  #
  # 用途:
  #   - インポート時に既存のバックアップIDを指定する場合に使用
  #   - 作成後はcomputed属性として参照可能
  #
  # Type: string
  # Computed: true (AWSが自動生成します)
  # id = "backup-0123456789abcdef0"

  # tags_all - (Optional) 全タグのマップ
  # リソースに割り当てられた全てのタグ（tagsとdefault_tagsの統合結果）。
  #
  # デフォルト動作:
  #   - 指定しない場合、tagsとプロバイダーのdefault_tagsが自動的にマージされます
  #   - 通常、この属性を明示的に設定する必要はありません
  #
  # 動作:
  #   - tags属性で指定したタグ
  #   - プロバイダーのdefault_tagsで指定したタグ
  #   - 上記の統合結果がtags_allとして自動計算されます
  #
  # 用途:
  #   - 作成後にcomputed属性として全タグを参照する場合に使用
  #   - 通常はtags属性の使用を推奨
  #
  # Type: map(string)
  # Computed: true (自動計算されます)
  # tags_all = {
  #   Name        = "example-fsx-backup"
  #   Environment = "production"
  #   ManagedBy   = "terraform"
  # }

  #---------------------------------------------------------------
  # Timeouts
  #---------------------------------------------------------------

  # timeouts - (Optional) タイムアウト設定
  # バックアップ作成・削除操作のタイムアウト時間を設定します。
  #
  # 推奨設定:
  #   - create: データ量が多い場合は長めに設定（デフォルトは通常十分）
  #   - delete: バックアップの削除は通常迅速に完了します
  #
  # timeouts {
  #   create = "30m"  # バックアップ作成のタイムアウト（デフォルト: 30分）
  #   delete = "30m"  # バックアップ削除のタイムアウト（デフォルト: 30分）
  # }
}

#---------------------------------------------------------------
# Attributes Reference
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします（computed属性）:
#
# arn - バックアップのAmazon Resource Name (ARN)
#   例: arn:aws:fsx:us-east-1:123456789012:backup/backup-0123456789abcdef0
#
# id - バックアップの識別子
#   例: backup-0123456789abcdef0
#   このIDはバックアップの管理・参照に使用されます
#
# kms_key_id - 暗号化キーID
#   バックアップデータの暗号化に使用されるAWS KMSキーのID。
#   ファイルシステム/ボリュームの暗号化設定を継承します。
#
# owner_id - 所有者アカウントID
#   バックアップを作成したAWSアカウントの識別子。
#
# type - バックアップタイプ
#   バックアップの種類を示す文字列。
#   取りうる値:
#     - AUTOMATIC: 自動日次バックアップ
#     - USER_INITIATED: ユーザーが手動で作成したバックアップ
#     - AWS_BACKUP: AWS Backupサービスで作成されたバックアップ
#
# tags_all - 全てのタグ
#   リソースに割り当てられた全タグのマップ。
#   プロバイダーのdefault_tagsから継承されたタグも含まれます。
#
#---------------------------------------------------------------
# Usage Examples
#---------------------------------------------------------------
#
# 1. FSx for Lustre ファイルシステムのバックアップ:
#
#   resource "aws_fsx_backup" "lustre_backup" {
#     file_system_id = aws_fsx_lustre_file_system.example.id
#     tags = {
#       Name = "lustre-backup"
#       Type = "user-initiated"
#     }
#   }
#
# 2. FSx for ONTAP ボリュームのバックアップ:
#
#   resource "aws_fsx_backup" "ontap_volume_backup" {
#     volume_id = aws_fsx_ontap_volume.example.id
#     tags = {
#       Name        = "ontap-volume-backup"
#       Application = "database"
#     }
#   }
#
# 3. FSx for Windows File Server のバックアップ (タイムアウト設定付き):
#
#   resource "aws_fsx_backup" "windows_backup" {
#     file_system_id = aws_fsx_windows_file_system.example.id
#     region         = "us-west-2"
#
#     tags = {
#       Name        = "windows-fs-backup"
#       Environment = "production"
#     }
#
#     timeouts {
#       create = "45m"
#       delete = "10m"
#     }
#   }
#
#---------------------------------------------------------------
# Important Notes
#---------------------------------------------------------------
#
# バックアップの特性:
#   - 全てのバックアップは増分バックアップ（前回バックアップからの変更分のみ保存）
#   - Amazon S3に保存され、99.999999999% (11 9's) の耐久性を実現
#   - 複数のアベイラビリティゾーンに冗長保存されます
#
# バックアップの保持:
#   - 自動日次バックアップ: 0-90日間の保持期間設定可能
#   - ユーザー作成バックアップ: 削除するまで永続的に保持
#   - AWS Backupで作成: 無制限の保持オプション、ソースFS削除後も保持
#
# バックアップの制限事項:
#   - Lustreスクラッチファイルシステム: バックアップ非対応
#   - LustreでS3リンクFS: バックアップ非対応（S3が一次リポジトリのため）
#   - ONTAPオフラインボリューム: バックアップ作成不可
#
# パフォーマンス考慮事項:
#   - バックアップ時間は変更データ量に依存（ストレージ容量ではない）
#   - 初回バックアップはデータ量に応じて数分〜数時間
#   - 2回目以降の増分バックアップは変更量が少なければ数秒で完了
#
# コスト最適化:
#   - ONTAPバックアップはストレージ効率の最適化を保持
#   - 増分バックアップにより重複データを保存せずコストを削減
#
# 復元:
#   - バックアップと同じリージョン内のFSにのみ復元可能
#   - クロスリージョン復元にはバックアップのコピーが必要
#   - ONTAP第2世代FSでは復元中の読み取りアクセスが可能
#
#---------------------------------------------------------------
