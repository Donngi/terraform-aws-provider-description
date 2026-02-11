#---------------------------------------------------------------
# Amazon Elastic File System (EFS) File System
#---------------------------------------------------------------
#
# Amazon EFS（Elastic File System）のファイルシステムリソースを作成します。
# EFSは、複数のEC2インスタンスから同時にマウント可能なフルマネージド型の
# NFSファイルシステムサービスです。自動的にスケールし、使った分だけ
# 課金されます。
#
# AWS公式ドキュメント:
#   - Amazon EFS User Guide: https://docs.aws.amazon.com/efs/latest/ug/
#   - API Reference: https://docs.aws.amazon.com/efs/latest/ug/API_Operations.html
#   - Lifecycle Management: https://docs.aws.amazon.com/efs/latest/ug/API_LifecyclePolicy.html
#   - File System Protection: https://docs.aws.amazon.com/efs/latest/ug/API_FileSystemProtectionDescription.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/efs_file_system
#
# Provider Version: 6.28.0
# Generated: 2026-01-27
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_efs_file_system" "example" {
  #---------------------------------------------------------------
  # 基本設定
  #---------------------------------------------------------------

  # creation_token - (Optional) ファイルシステム作成時の冪等性を保証するための
  # 一意な名前（最大64文字）。指定しない場合はTerraformが自動生成します。
  # 同じcreation_tokenで作成要求を送信すると、既存のファイルシステムが
  # 返されます。
  # https://docs.aws.amazon.com/efs/latest/ug/
  creation_token = "my-product"

  #---------------------------------------------------------------
  # 可用性とストレージクラス
  #---------------------------------------------------------------

  # availability_zone_name - (Optional) ファイルシステムを作成する
  # AWS Availability Zone。One Zoneストレージクラスを使用する
  # ファイルシステムを作成する際に使用します。指定しない場合は、
  # リージョン全体で利用可能なスタンダードストレージクラスが使用されます。
  # https://docs.aws.amazon.com/efs/latest/ug/availability-durability.html
  # availability_zone_name = "us-east-1a"

  # region - (Optional) このリソースが管理されるリージョン。
  # 未指定の場合、プロバイダー設定のリージョンがデフォルトとなります。
  # https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-east-1"

  #---------------------------------------------------------------
  # 暗号化設定
  #---------------------------------------------------------------

  # encrypted - (Optional) trueの場合、ファイルシステムが暗号化されます。
  # EFSでは保存時の暗号化がサポートされており、AWS KMSを使用して
  # データを暗号化できます。デフォルトはfalseですが、セキュリティのため
  # 有効化を推奨します。
  encrypted = true

  # kms_key_id - (Optional) KMS暗号化キーのARN。kms_key_idを指定する場合は、
  # encryptedをtrueに設定する必要があります。未指定の場合、AWSが管理する
  # デフォルトのEFS用KMSキー（aws/elasticfilesystem）が使用されます。
  # kms_key_id = "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"

  #---------------------------------------------------------------
  # パフォーマンス設定
  #---------------------------------------------------------------

  # performance_mode - (Optional) ファイルシステムのパフォーマンスモード。
  # 選択肢:
  #   - "generalPurpose" (デフォルト): 低レイテンシが必要な汎用ワークロード向け
  #   - "maxIO": 高いスループットとIOPSが必要なワークロード向け（レイテンシは若干高い）
  # 注意: 作成後の変更はできません。
  performance_mode = "generalPurpose"

  # throughput_mode - (Optional) ファイルシステムのスループットモード。
  # 選択肢:
  #   - "bursting" (デフォルト): ストレージサイズに応じてスループットがバースト
  #   - "provisioned": 固定スループットを事前プロビジョニング
  #   - "elastic": ワークロードに応じて自動スケール（推奨）
  # provisionedを使用する場合は、provisioned_throughput_in_mibpsも設定が必要です。
  throughput_mode = "bursting"

  # provisioned_throughput_in_mibps - (Optional) プロビジョニングする
  # スループット（MiB/s単位）。throughput_modeが"provisioned"の場合のみ適用されます。
  # 最小値は1 MiB/s、最大値はリージョンによって異なります。
  # provisioned_throughput_in_mibps = 100

  #---------------------------------------------------------------
  # タグ
  #---------------------------------------------------------------

  # tags - (Optional) ファイルシステムに割り当てるタグのマップ。
  # プロバイダーのdefault_tags設定ブロックが存在する場合、
  # 同じキーのタグはここで指定した値で上書きされます。
  tags = {
    Name        = "MyProduct"
    Environment = "production"
    ManagedBy   = "terraform"
  }

  # tags_all - (Optional) プロバイダーのdefault_tagsを含む、
  # リソースに割り当てられる全てのタグのマップ。
  # 通常、このフィールドは明示的に設定する必要はありません。
  # Terraformが自動的に管理します。
  # tags_all = {}

  # id - (Optional) ファイルシステムを識別するID（例: fs-ccfc0d65）。
  # 通常、このフィールドは明示的に設定する必要はありません。
  # Terraformがリソース作成時に自動的に設定します。
  # id = "fs-ccfc0d65"

  #---------------------------------------------------------------
  # ライフサイクルポリシー
  #---------------------------------------------------------------
  # ファイルシステムのライフサイクル管理ポリシーを定義します。
  # 最大3つのライフサイクルポリシーを設定可能です。
  # https://docs.aws.amazon.com/efs/latest/ug/API_LifecyclePolicy.html

  lifecycle_policy {
    # transition_to_ia - (Optional) ファイルをIA（Infrequent Access）
    # ストレージクラスに移行するまでの期間。IAストレージクラスは
    # アクセス頻度の低いファイルのコスト削減に有効です。
    # 有効な値: AFTER_1_DAY, AFTER_7_DAYS, AFTER_14_DAYS, AFTER_30_DAYS,
    #          AFTER_60_DAYS, AFTER_90_DAYS, AFTER_180_DAYS, AFTER_270_DAYS,
    #          AFTER_365_DAYS
    transition_to_ia = "AFTER_30_DAYS"
  }

  # lifecycle_policy {
  #   # transition_to_primary_storage_class - (Optional) ファイルを
  #   # 低頻度アクセスストレージからプライマリストレージクラスに移行する
  #   # ポリシー。ファイルにアクセスがあった際の自動移行を制御します。
  #   # 有効な値: AFTER_1_ACCESS
  #   transition_to_primary_storage_class = "AFTER_1_ACCESS"
  # }

  # lifecycle_policy {
  #   # transition_to_archive - (Optional) ファイルをArchiveストレージクラスに
  #   # 移行するまでの期間。Archiveは最も低コストなストレージクラスです。
  #   # 注意: transition_to_ia、Elastic Throughput、General Purposeパフォーマンス
  #   # モードが必要です。
  #   # 有効な値: AFTER_1_DAY, AFTER_7_DAYS, AFTER_14_DAYS, AFTER_30_DAYS,
  #   #          AFTER_60_DAYS, AFTER_90_DAYS, AFTER_180_DAYS, AFTER_270_DAYS,
  #   #          AFTER_365_DAYS
  #   transition_to_archive = "AFTER_90_DAYS"
  # }

  #---------------------------------------------------------------
  # ファイルシステム保護設定
  #---------------------------------------------------------------
  # ファイルシステムの保護設定を定義します。
  # https://docs.aws.amazon.com/efs/latest/ug/API_FileSystemProtectionDescription.html

  # protection {
  #   # replication_overwrite - (Optional) レプリケーション上書き保護が
  #   # 有効かどうかを示します。ENABLEDの場合、レプリケーション先の
  #   # ファイルシステムへの直接書き込みが防止されます。
  #   # 有効な値: ENABLED, DISABLED
  #   replication_overwrite = "ENABLED"
  # }
}

#---------------------------------------------------------------
# Attributes Reference
#---------------------------------------------------------------
# 以下の属性はリソース作成後に参照可能です（computed-only）。
# テンプレートには記載しませんが、他のリソースから参照する際に使用できます。
#
# - arn - ファイルシステムのAmazon Resource Name
#   例: aws_efs_file_system.example.arn
#
# - availability_zone_id - ファイルシステムのOne Zoneストレージクラスが
#   存在するAvailability ZoneのID
#   例: aws_efs_file_system.example.availability_zone_id
#
# - dns_name - ファイルシステムのDNS名
#   例: fs-12345678.efs.us-east-1.amazonaws.com
#   マウント時に使用: aws_efs_file_system.example.dns_name
#   https://docs.aws.amazon.com/efs/latest/ug/mounting-fs-mount-cmd-dns-name.html
#
# - name - ファイルシステムのNameタグの値
#   例: aws_efs_file_system.example.name
#
# - number_of_mount_targets - ファイルシステムが持つマウントターゲットの現在数
#   例: aws_efs_file_system.example.number_of_mount_targets
#
# - owner_id - ファイルシステムを作成したAWSアカウントID
#   IAMユーザーが作成した場合、そのユーザーが属する親アカウントがオーナー
#   例: aws_efs_file_system.example.owner_id
#
# - size_in_bytes - ファイルシステムに保存されているデータの最新の
#   計測サイズ（バイト単位）。正確な値ではなく、ある時点の近似値です。
#   オブジェクト構造:
#     - value: ファイルシステム全体のサイズ（バイト）
#     - value_in_ia: IAストレージクラスのサイズ（バイト）
#     - value_in_standard: Standardストレージクラスのサイズ（バイト）
#   例: aws_efs_file_system.example.size_in_bytes[0].value
#---------------------------------------------------------------
