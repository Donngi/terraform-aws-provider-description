#---------------------------------------
# AWS EFS File System
#---------------------------------------
# Amazon Elastic File System (EFS) のファイルシステムリソース
# 複数のEC2インスタンスから同時マウント可能なNFSベースの共有ファイルストレージを提供
#
# 主な用途:
# - コンテナ環境での永続化ストレージ
# - Webサーバーの共有コンテンツ領域
# - ビッグデータ解析の共有データレイク
# - 開発環境でのコード共有
#
# 注意事項:
# - One Zone ストレージクラスを使用する場合は availability_zone_name を指定
# - 暗号化を有効にする場合は、作成後に無効化できない
# - パフォーマンスモードは作成後に変更不可
# - provisioned スループットモードを使用する場合は provisioned_throughput_in_mibps が必須
#
# 関連リソース:
# - aws_efs_mount_target: マウントターゲットの作成
# - aws_efs_access_point: アクセスポイントの設定
# - aws_efs_backup_policy: バックアップポリシーの設定
# - aws_efs_file_system_policy: リソースベースポリシーの設定
#
# 料金:
# - 使用したストレージ容量に基づく従量課金
# - ストレージクラス（Standard, IA, Archive）によって料金が異なる
# - Provisioned Throughput モードでは追加料金が発生
#
# Generated: 2026-02-17
# Terraform Registry: https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/efs_file_system
# AWS Provider Version: 6.28.0
# NOTE: このテンプレートは実際の使用前にプロジェクト要件に合わせて調整が必要です

resource "aws_efs_file_system" "example" {

  #---------------------------------------
  # 基本設定
  #---------------------------------------

  # 作成トークン
  # 設定内容: ファイルシステム作成時の一意の識別子（最大64文字）
  # 設定可能な値: 英数字、ハイフン、アンダースコアで構成される文字列
  # 省略時: Terraform によって自動生成される
  creation_token = "my-efs-token"

  # リージョン
  # 設定内容: ファイルシステムを作成するAWSリージョン
  # 設定可能な値: us-east-1, ap-northeast-1 等の有効なリージョンコード
  # 省略時: プロバイダー設定のリージョンが使用される
  region = "ap-northeast-1"

  #---------------------------------------
  # ストレージクラス設定
  #---------------------------------------

  # アベイラビリティゾーン名
  # 設定内容: One Zone ストレージクラスを使用する場合のAZ名
  # 設定可能な値: 例: ap-northeast-1a, us-east-1b
  # 省略時: 複数AZに跨るファイルシステムが作成される（Standard ストレージクラス）
  # 注意: One Zone 使用時は単一AZにデータが保存されるため冗長性が低下
  availability_zone_name = "ap-northeast-1a"

  #---------------------------------------
  # 暗号化設定
  #---------------------------------------

  # 暗号化有効化
  # 設定内容: 保存時の暗号化を有効にするかどうか
  # 設定可能な値: true（有効）, false（無効）
  # 省略時: false
  # 注意: 作成後に暗号化の有効/無効を変更できない
  encrypted = true

  # KMSキーID
  # 設定内容: 暗号化に使用するAWS KMSキーのARN
  # 設定可能な値: KMSキーのARN（例: arn:aws:kms:region:account-id:key/key-id）
  # 省略時: AWS管理のEFS用デフォルトキー（aws/elasticfilesystem）が使用される
  # 注意: このパラメータを指定する場合は encrypted = true が必須
  kms_key_id = "arn:aws:kms:ap-northeast-1:123456789012:key/12345678-1234-1234-1234-123456789012"

  #---------------------------------------
  # パフォーマンス設定
  #---------------------------------------

  # パフォーマンスモード
  # 設定内容: ファイルシステムのパフォーマンス特性
  # 設定可能な値:
  #   - generalPurpose: 低レイテンシが必要なワークロード向け（推奨）
  #   - maxIO: 高スループット、大量の並列処理が必要なワークロード向け
  # 省略時: generalPurpose
  # 注意: 作成後に変更不可。transition_to_archive を使用する場合は generalPurpose が必須
  performance_mode = "generalPurpose"

  # スループットモード
  # 設定内容: ファイルシステムのスループット配信モード
  # 設定可能な値:
  #   - bursting: ストレージ容量に応じたバースト可能なスループット
  #   - provisioned: 固定のプロビジョニングスループット
  #   - elastic: ワークロードに応じて自動的にスケール
  # 省略時: bursting
  # 注意: transition_to_archive を使用する場合は elastic が必須
  throughput_mode = "bursting"

  # プロビジョニングスループット
  # 設定内容: プロビジョニングするスループット（MiB/s単位）
  # 設定可能な値: 1 ～ 3414（MiB/s）の数値
  # 省略時: 設定なし
  # 注意: throughput_mode = "provisioned" の場合のみ有効
  provisioned_throughput_in_mibps = 100

  #---------------------------------------
  # ライフサイクルポリシー
  #---------------------------------------

  # ライフサイクルポリシー（最大3つまで設定可能）
  # lifecycle_policy {
  #   # IAストレージクラスへの移行
  #   # 設定内容: ファイルがアクセスされなくなってから低頻度アクセス（IA）ストレージクラスに移行するまでの期間
  #   # 設定可能な値: AFTER_1_DAY, AFTER_7_DAYS, AFTER_14_DAYS, AFTER_30_DAYS, AFTER_60_DAYS, AFTER_90_DAYS, AFTER_180_DAYS, AFTER_270_DAYS, AFTER_365_DAYS
  #   # 省略時: IA への自動移行は行われない
  #   transition_to_ia = "AFTER_30_DAYS"
  #
  #   # アーカイブストレージクラスへの移行
  #   # 設定内容: ファイルがアクセスされなくなってからアーカイブストレージクラスに移行するまでの期間
  #   # 設定可能な値: AFTER_1_DAY, AFTER_7_DAYS, AFTER_14_DAYS, AFTER_30_DAYS, AFTER_60_DAYS, AFTER_90_DAYS, AFTER_180_DAYS, AFTER_270_DAYS, AFTER_365_DAYS
  #   # 省略時: アーカイブへの自動移行は行われない
  #   # 注意: transition_to_ia の設定、elastic スループットモード、generalPurpose パフォーマンスモードが必須
  #   transition_to_archive = "AFTER_90_DAYS"
  #
  #   # プライマリストレージクラスへの移行
  #   # 設定内容: IA/アーカイブストレージクラスからプライマリストレージクラスに戻すタイミング
  #   # 設定可能な値: AFTER_1_ACCESS（1回アクセスされたら即座に戻す）
  #   # 省略時: 自動的にプライマリストレージクラスに戻らない
  #   transition_to_primary_storage_class = "AFTER_1_ACCESS"
  # }

  #---------------------------------------
  # 保護設定
  #---------------------------------------

  # ファイルシステム保護設定
  # protection {
  #   # レプリケーション上書き保護
  #   # 設定内容: レプリケーション先ファイルシステムでの上書き保護を有効にするかどうか
  #   # 設定可能な値: ENABLED（有効）, DISABLED（無効）
  #   # 省略時: DISABLED
  #   # 注意: レプリケーション先のファイルシステムでのみ有効
  #   replication_overwrite = "DISABLED"
  # }

  #---------------------------------------
  # タグ設定
  #---------------------------------------

  # タグ
  # 設定内容: ファイルシステムに付与するタグのマップ
  # 設定可能な値: キーと値のペアで構成されるマップ（最大50タグ）
  # 省略時: タグなし
  # 注意: Name タグを設定すると name 属性として参照可能
  tags = {
    Name        = "my-efs"
    Environment = "production"
    ManagedBy   = "terraform"
  }
}

#---------------------------------------
# Attributes Reference（参照可能な属性）
#---------------------------------------
# resource作成後に参照可能な属性値
#
# arn                     : ファイルシステムのARN
# availability_zone_id    : One Zone ストレージクラスが存在するAZの識別子
# dns_name                : ファイルシステムのDNS名（マウント時に使用）
# id                      : ファイルシステムID（例: fs-12345678）
# name                    : Name タグの値
# number_of_mount_targets : 現在のマウントターゲット数
# owner_id                : ファイルシステムを作成したAWSアカウントID
# size_in_bytes           : 最新の測定されたデータサイズ（バイト単位）のリスト
#   - value               : ファイルシステムの総データサイズ
#   - value_in_ia         : IA ストレージクラスのデータサイズ
#   - value_in_standard   : Standard ストレージクラスのデータサイズ
# tags_all                : プロバイダーのデフォルトタグを含む全てのタグ
