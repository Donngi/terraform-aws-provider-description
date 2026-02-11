#---------------------------------------------------------------
# Amazon EFS Replication Configuration
#---------------------------------------------------------------
#
# EFSファイルシステムのレプリケーションを設定するリソース。
# 既存のEFSファイルシステムを同じリージョンまたは別のリージョンに
# レプリカとして複製する。レプリケーションを作成すると、ソースファイル
# システムが新しい読み取り専用の宛先ファイルシステムにレプリケートされる。
# このリソースを削除すると、レプリケーションは停止するが、宛先ファイル
# システムは削除されない点に注意。
#
# AWS公式ドキュメント:
#   - Configuring replication to new EFS file system: https://docs.aws.amazon.com/efs/latest/ug/create-replication.html
#   - Configuring replication to existing EFS file system: https://docs.aws.amazon.com/efs/latest/ug/replicate-existing-destination.html
#   - Viewing replication details: https://docs.aws.amazon.com/efs/latest/ug/monitoring-replication-status.html
#   - API Reference - ReplicationConfigurationDescription: https://docs.aws.amazon.com/efs/latest/ug/API_ReplicationConfigurationDescription.html
#   - API Reference - DestinationToCreate: https://docs.aws.amazon.com/efs/latest/ug/API_DestinationToCreate.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/efs_replication_configuration
#
# Provider Version: 6.28.0
# Generated: 2026-01-27
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_efs_replication_configuration" "example" {
  #---------------------------------------------------------------
  # Required Arguments
  #---------------------------------------------------------------

  # (必須) レプリケーション元となるファイルシステムのID。
  # EFSファイルシステムのIDを指定する（例: fs-12345678）。
  # 1つのファイルシステムは1つのレプリケーション設定のみに属することができる。
  # また、宛先ファイルシステムは別のレプリケーション設定のソースとして使用できない。
  source_file_system_id = "fs-12345678"

  #---------------------------------------------------------------
  # Optional Arguments
  #---------------------------------------------------------------

  # (オプション) このリソースが管理されるリージョン。
  # 指定しない場合、プロバイダー設定のリージョンがデフォルトで使用される。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-east-1"

  # (オプション) Terraformによるリソース識別子。
  # 通常は指定不要。Terraformが自動的に管理する。
  # id = null

  #---------------------------------------------------------------
  # Destination Block (Required)
  #---------------------------------------------------------------
  # レプリカの宛先設定を定義する。1つのみ指定可能。

  destination {
    # (オプション) レプリカを作成するアベイラビリティーゾーン名。
    # 指定すると、レプリカはOne Zoneストレージとして作成される。
    # 省略するとリージョナルストレージが使用される。
    # 例: "us-west-2b"
    # One Zoneファイルシステムは、すべてのAWSリージョンの
    # すべてのアベイラビリティーゾーンで利用可能ではない点に注意。
    # availability_zone_name = "us-west-2b"

    # (オプション) レプリケーション先の既存ファイルシステムのID。
    # 指定しない場合、EFSがデフォルト設定で新しいファイルシステムを作成する。
    # 既存のファイルシステムを指定する場合、そのファイルシステムの
    # レプリケーション上書き保護を事前に無効化する必要がある。
    # 既存のファイルシステムにレプリケートすると、宛先の既存データは
    # ソースファイルシステムのデータに一致するように書き換えられる。
    # 例: "fs-87654321"
    # file_system_id = "fs-87654321"

    # (オプション) レプリカファイルシステムの暗号化に使用するKMSキー。
    # Key ID、ARN、エイリアス、またはエイリアスARNを指定可能。
    # 省略した場合、EFSのデフォルトKMSキー「/aws/elasticfilesystem」が使用される。
    # 宛先ファイルシステム作成後、KMSキーは変更できない点に注意。
    # ソースファイルシステムが暗号化されている場合、宛先ファイルシステムも
    # 暗号化する必要がある。
    # 例: "1234abcd-12ab-34cd-56ef-1234567890ab" または "arn:aws:kms:..."
    # kms_key_id = "1234abcd-12ab-34cd-56ef-1234567890ab"

    # (オプション) レプリカを作成するリージョン。
    # 省略可能。クロスリージョンレプリケーションを行う場合に指定する。
    # 例: "us-west-2"
    # region = "us-west-2"
  }

  #---------------------------------------------------------------
  # Timeouts Block (Optional)
  #---------------------------------------------------------------
  # リソース作成・削除のタイムアウト設定。

  # timeouts {
  #   # (オプション) リソース作成のタイムアウト時間。
  #   # デフォルトは20分。初期同期の時間はソースファイルシステムの
  #   # サイズとファイル数に依存する。
  #   # 例: "30m"
  #   create = "20m"
  #
  #   # (オプション) リソース削除のタイムアウト時間。
  #   # デフォルトは20分。
  #   # 例: "30m"
  #   delete = "20m"
  # }
}

#---------------------------------------------------------------
# Attributes Reference
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートする（computed only）:
#
# - creation_time
#     レプリケーション設定が作成された日時のタイムスタンプ。
#
# - destination[0].file_system_id
#     レプリカのファイルシステムID（fs-XXXXXXXX形式）。
#     新しいファイルシステムが作成された場合に利用可能。
#
# - destination[0].status
#     レプリケーションのステータス。
#     値: ENABLED（有効）、ENABLING（有効化中）、DELETING（削除中）、
#         PAUSING（一時停止中）、PAUSED（一時停止）、ERROR（エラー）
#
# - original_source_file_system_arn
#     レプリケーション設定における元のソースEFSファイルシステムのARN。
#
# - source_file_system_arn
#     レプリケーション設定における現在のソースファイルシステムのARN。
#
# - source_file_system_region
#     ソースEFSファイルシステムが配置されているAWSリージョン。
#
#---------------------------------------------------------------
# 使用例
#---------------------------------------------------------------
# 例1: 新しいリージョナルファイルシステムへのレプリケーション
#
# resource "aws_efs_file_system" "source" {
#   creation_token = "source-fs"
#   encrypted      = true
# }
#
# resource "aws_efs_replication_configuration" "example" {
#   source_file_system_id = aws_efs_file_system.source.id
#
#   destination {
#     region = "us-west-2"
#   }
# }
#
# 例2: One Zoneストレージへのレプリケーション（KMS暗号化指定）
#
# resource "aws_efs_replication_configuration" "one_zone" {
#   source_file_system_id = aws_efs_file_system.source.id
#
#   destination {
#     availability_zone_name = "us-west-2b"
#     kms_key_id             = "1234abcd-12ab-34cd-56ef-1234567890ab"
#   }
# }
#
# 例3: 既存のファイルシステムへのレプリケーション
#
# resource "aws_efs_replication_configuration" "to_existing" {
#   source_file_system_id = aws_efs_file_system.source.id
#
#   destination {
#     file_system_id = "fs-87654321"
#     region         = "us-west-2"
#   }
# }
#
#---------------------------------------------------------------
# 重要な注意事項
#---------------------------------------------------------------
# 1. このリソースを削除しても、宛先ファイルシステムは削除されない。
# 2. ファイルシステムは1つのレプリケーション設定にのみ属することができる。
# 3. 宛先ファイルシステムは別のレプリケーション設定のソースとして使用不可。
# 4. 初期同期の時間はソースファイルシステムのサイズとファイル数に依存する。
# 5. レプリケーション作成後、宛先ファイルシステムをマウントするには
#    マウントターゲットを作成する必要がある。
# 6. 宛先ファイルシステム作成後、KMSキーは変更できない。
# 7. ソースが暗号化されている場合、宛先も暗号化する必要がある。
# 8. 既存ファイルシステムへのレプリケーションでは、宛先の既存データが
#    ソースに一致するように変更される。
#---------------------------------------------------------------
