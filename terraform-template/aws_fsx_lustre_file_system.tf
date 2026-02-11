#---------------------------------------------------------------
# Amazon FSx for Lustre File System
#---------------------------------------------------------------
#
# Amazon FSx for Lustreファイルシステムを作成・管理するリソース。
# 高性能な並列ファイルシステムで、機械学習、HPC、メディア処理などの
# ワークロードに最適化されています。
#
# AWS公式ドキュメント:
#   - FSx for Lustre ユーザーガイド: https://docs.aws.amazon.com/fsx/latest/LustreGuide/what-is.html
#   - ストレージ容量の管理: https://docs.aws.amazon.com/fsx/latest/LustreGuide/managing-storage-capacity.html
#   - パフォーマンス: https://docs.aws.amazon.com/fsx/latest/LustreGuide/performance.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/fsx_lustre_file_system
#
# Provider Version: 6.28.0
# Generated: 2026-01-27
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_fsx_lustre_file_system" "example" {
  #---------------------------------------------------------------
  # 必須パラメータ
  #---------------------------------------------------------------

  # サブネットID（必須）
  # ファイルシステムがアクセス可能なサブネットのIDリスト
  # 現在、FSx for Lustreは単一サブネットのみサポート
  # ファイルサーバーはこのサブネットのアベイラビリティゾーンに起動される
  subnet_ids = ["subnet-12345678"]

  #---------------------------------------------------------------
  # オプションパラメータ - 基本設定
  #---------------------------------------------------------------

  # リージョン（オプション）
  # このリソースが管理されるAWSリージョン
  # 未指定の場合、プロバイダー設定のリージョンがデフォルト
  # region = "us-east-1"

  # ストレージ容量（オプション）
  # ファイルシステムのストレージ容量（GiB単位）
  # 最小値は1200 GiB
  # バックアップから作成する場合を除き、基本的に必須
  # SCRATCH_2、PERSISTENT_1、PERSISTENT_2デプロイメントタイプでは更新可能
  # 増加時は6時間の待機時間が必要で、スループット容量も自動増加する
  # storage_capacity = 1200

  # デプロイメントタイプ（オプション）
  # ファイルシステムのデプロイメントタイプ
  # 有効な値: SCRATCH_1, SCRATCH_2, PERSISTENT_1, PERSISTENT_2
  # - SCRATCH_1/SCRATCH_2: 一時的なストレージ、コスト最適化、データは複製されない
  # - PERSISTENT_1/PERSISTENT_2: 長期ストレージ、高可用性、データは複製される
  # deployment_type = "PERSISTENT_1"

  # ストレージタイプ（オプション）
  # ファイルシステムのストレージタイプ
  # 有効な値: SSD, HDD, INTELLIGENT_TIERING
  # デフォルトはSSD
  # HDDはPERSISTENT_1デプロイメントタイプでのみサポート
  # INTELLIGENT_TIERINGはPERSISTENT_2で、data_read_cache_configurationとmetadata_configurationが必須
  # storage_type = "SSD"

  #---------------------------------------------------------------
  # オプションパラメータ - パフォーマンス設定
  #---------------------------------------------------------------

  # ユニットストレージスループット（オプション）
  # 1TiB（テビバイト）あたりの読み書きスループット（MB/s/TiB）
  # PERSISTENT_1およびPERSISTENT_2デプロイメントタイプで必須
  # PERSISTENT_1 + SSD: 50, 100, 200
  # PERSISTENT_1 + HDD: 12, 40
  # PERSISTENT_2 + SSD: 125, 250, 500, 1000
  # per_unit_storage_throughput = 50

  # スループット容量（オプション）
  # INTELLIGENT_TIERINGストレージタイプに必要なスループット（MBps単位）
  # 4000または4000の倍数である必要がある
  # throughput_capacity = 4000

  # ドライブキャッシュタイプ（オプション）
  # HDDストレージタイプでプロビジョニングされたPERSISTENT_1ファイルシステムで使用されるドライブキャッシュのタイプ
  # HDDストレージタイプの場合は必須
  # 有効な値: READ, NONE
  # drive_cache_type = "READ"

  # EFA有効化（オプション）
  # Elastic Fabric Adapter（EFA）とGPUDirect Storage（GDS）のサポートを追加
  # 作成時に設定する必要があり、後から変更不可
  # これを設定すると、per_unit_storage_throughputの変更が防止される
  # deployment_typeがPERSISTENT_2、metadata_configurationが使用され、EFA対応のセキュリティグループがアタッチされている場合のみサポート
  # efa_enabled = false

  #---------------------------------------------------------------
  # オプションパラメータ - データ圧縮
  #---------------------------------------------------------------

  # データ圧縮タイプ（オプション）
  # ファイルシステムのデータ圧縮設定
  # 有効な値: LZ4, NONE
  # デフォルトはNONE
  # 設定を解除するとNONEに戻る
  # data_compression_type = "NONE"

  #---------------------------------------------------------------
  # オプションパラメータ - S3データリポジトリ統合（PERSISTENT_1のみ）
  #---------------------------------------------------------------
  # 注意: auto_import_policy, export_path, import_path, imported_file_chunk_sizeは
  #      PERSISTENT_2デプロイメントタイプではサポートされていません
  #      代わりにaws_fsx_data_repository_associationを使用してください

  # インポートパス（オプション）
  # FSx for Lustreファイルシステムのデータリポジトリとして使用するS3 URI（オプションのプレフィックス付き）
  # 例: s3://example-bucket/optional-prefix/
  # PERSISTENT_1デプロイメントタイプでのみサポート
  # import_path = "s3://my-bucket/my-prefix/"

  # エクスポートパス（オプション）
  # Amazon FSxファイルシステムのルートがエクスポートされるS3 URI（オプションのプレフィックス付き）
  # import_path引数と同じS3バケットを使用する必要がある
  # import_pathと同じ値に設定すると、エクスポート時にファイルを上書きする
  # デフォルトは s3://{IMPORT BUCKET}/FSxLustre{CREATION TIMESTAMP}
  # PERSISTENT_1デプロイメントタイプでのみサポート
  # export_path = "s3://my-bucket/my-export-prefix/"

  # インポートされたファイルチャンクサイズ（オプション）
  # データリポジトリからインポートされたファイルについて、
  # ストライプカウントと単一物理ディスク上の最大データ量（MiB単位）を決定
  # import_path引数と一緒にのみ指定可能
  # デフォルトは1024、最小1、最大512000
  # PERSISTENT_1デプロイメントタイプでのみサポート
  # imported_file_chunk_size = 1024

  # 自動インポートポリシー（オプション）
  # リンクされたS3バケット内でオブジェクトを追加または変更したときに、
  # Amazon FSxがファイルとディレクトリリストを最新に保つ方法を設定
  # 詳細: https://docs.aws.amazon.com/fsx/latest/LustreGuide/autoimport-data-repo.html
  # PERSISTENT_1デプロイメントタイプでのみサポート
  # auto_import_policy = null

  #---------------------------------------------------------------
  # オプションパラメータ - バックアップ設定
  #---------------------------------------------------------------

  # バックアップID（オプション）
  # ファイルシステムの作成元となるソースバックアップのID
  # 既存のバックアップからファイルシステムを復元する場合に使用
  # backup_id = null

  # 自動バックアップ保持日数（オプション）
  # 自動バックアップを保持する日数
  # 0に設定すると自動バックアップが無効化される
  # 最大90日まで保持可能
  # PERSISTENT_1およびPERSISTENT_2デプロイメントタイプでのみ有効
  # automatic_backup_retention_days = 0

  # 日次自動バックアップ開始時刻（オプション）
  # 日次の自動バックアップを実行する時刻（HH:MM形式）
  # HHは時間（0-23のゼロパディング）、MMは分（ゼロパディング）
  # 例: 05:00は午前5時を指定
  # PERSISTENT_1およびPERSISTENT_2デプロイメントタイプでのみ有効
  # automatic_backup_retention_daysの設定が必要
  # daily_automatic_backup_start_time = null

  # バックアップへのタグのコピー（オプション）
  # ファイルシステムのタグをバックアップにコピーするかどうかを示すブール値
  # PERSISTENT_1およびPERSISTENT_2デプロイメントタイプで適用可能
  # デフォルトはfalse
  # copy_tags_to_backups = false

  # 最終バックアップのタグ（オプション）
  # ファイルシステムの最終バックアップに適用するタグのマップ
  # 注意: Scratchデプロイメントタイプの場合、削除時の最終バックアップは常にスキップされ、
  #      この引数は設定されていても使用されません
  # final_backup_tags = {}

  # 最終バックアップをスキップ（オプション）
  # 有効にすると、ファイルシステム削除時のデフォルトの最終バックアップがスキップされる
  # この設定は、リソースを削除する前に個別に適用する必要がある
  # デフォルトはtrue
  # 注意: Scratchデプロイメントタイプの場合、削除時の最終バックアップは常にスキップされ、
  #      この引数は設定されていても使用されません
  # skip_final_backup = true

  #---------------------------------------------------------------
  # オプションパラメータ - Lustreバージョン
  #---------------------------------------------------------------

  # ファイルシステムタイプバージョン（オプション）
  # 作成するファイルシステムのLustreバージョンを設定
  # SCRATCH_1、SCRATCH_2、PERSISTENT_1デプロイメントタイプの場合、有効な値は2.10
  # すべてのデプロイメントタイプで2.12が有効
  # file_system_type_version = null

  #---------------------------------------------------------------
  # オプションパラメータ - 暗号化
  #---------------------------------------------------------------

  # KMSキーID（オプション）
  # 保存時にファイルシステムを暗号化するためのKMS KeyのARN
  # PERSISTENT_1およびPERSISTENT_2デプロイメントタイプで適用可能
  # デフォルトはAWS管理のKMSキー
  # kms_key_id = null

  #---------------------------------------------------------------
  # オプションパラメータ - ネットワーク設定
  #---------------------------------------------------------------

  # セキュリティグループID（オプション）
  # ファイルシステムアクセス用に作成されたネットワークインターフェースに適用されるセキュリティグループのIDリスト
  # これらのセキュリティグループはすべてのネットワークインターフェースに適用される
  # security_group_ids = []

  #---------------------------------------------------------------
  # オプションパラメータ - メンテナンス
  #---------------------------------------------------------------

  # 週次メンテナンス開始時刻（オプション）
  # 週次メンテナンスを実行する優先開始時刻（d:HH:MM形式、UTC タイムゾーン）
  # 例: 1:05:00は月曜日の午前5:00 UTCを指定
  # weekly_maintenance_start_time = null

  #---------------------------------------------------------------
  # オプションパラメータ - タグ
  #---------------------------------------------------------------

  # タグ（オプション）
  # ファイルシステムに割り当てるタグのマップ
  # プロバイダーのdefault_tags設定ブロックが存在する場合、
  # 一致するキーを持つタグはプロバイダーレベルで定義されたタグを上書きする
  # tags = {
  #   Name        = "my-fsx-lustre"
  #   Environment = "production"
  # }

  # 全タグ（オプション）
  # リソースに割り当てられたタグのマップ（プロバイダーのdefault_tags設定ブロックから継承されたタグを含む）
  # このパラメータはcomputed属性でもあるため、通常は明示的に設定しない
  # tags_all = {}

  # ID（オプション）
  # ファイルシステムの識別子（例: fs-12345678）
  # このパラメータはcomputed属性でもあるため、通常は明示的に設定しない
  # id = null

  #---------------------------------------------------------------
  # ネストブロック - データリードキャッシュ設定
  #---------------------------------------------------------------
  # INTELLIGENT_TIERINGストレージクラス使用時のSSD読み取りキャッシュ設定

  # data_read_cache_configuration {
  #   # サイジングモード（必須）
  #   # キャッシュのサイジングモード
  #   # 有効な値: NO_CACHE, USER_PROVISIONED, PROPORTIONAL_TO_THROUGHPUT_CAPACITY
  #   sizing_mode = "NO_CACHE"
  #
  #   # サイズ（オプション）
  #   # ファイルシステムのSSD読み取りキャッシュのサイズ（GiB単位）
  #   # sizing_modeがUSER_PROVISIONEDの場合は必須
  #   # size = null
  # }

  #---------------------------------------------------------------
  # ネストブロック - ログ設定
  #---------------------------------------------------------------
  # Amazon FSx for Lustreファイルシステム作成時に使用されるLustreログ設定
  # ロギングを有効にすると、Lustreはファイルシステムのデータリポジトリのエラーイベントと警告イベントをCloudWatch Logsに記録

  # log_configuration {
  #   # 宛先（オプション）
  #   # ログの宛先を指定するAmazon Resource Name（ARN）
  #   # CloudWatch Logsログストリームの名前は /aws/fsx プレフィックスで始まる必要がある
  #   # 宛先を指定しない場合、Amazon FSxはCloudWatch Logsの /aws/fsx/lustre ログストリームを作成・使用
  #   # destination = null
  #
  #   # レベル（オプション）
  #   # Amazon FSxによってログに記録されるデータリポジトリイベントを設定
  #   # 有効な値: WARN_ONLY, FAILURE_ONLY, ERROR_ONLY, WARN_ERROR, DISABLED
  #   # デフォルトはDISABLED
  #   # level = "DISABLED"
  # }

  #---------------------------------------------------------------
  # ネストブロック - メタデータ設定
  #---------------------------------------------------------------
  # PERSISTENT_2デプロイメントタイプを使用するAmazon FSx for Lustreファイルシステムの
  # Lustreメタデータパフォーマンス設定

  # metadata_configuration {
  #   # モード（オプション）
  #   # ファイルシステムのメタデータ構成のモード
  #   # 有効な値: AUTOMATIC, USER_PROVISIONED
  #   # INTELLIGENT_TIERINGストレージタイプの場合、USER_PROVISIONEDに設定する必要がある
  #   # mode = "AUTOMATIC"
  #
  #   # IOPS（オプション）
  #   # メタデータ用にプロビジョニングされたIOPS量
  #   # このパラメータはmodeがUSER_PROVISIONEDに設定されている場合のみ使用
  #   # 有効な値: 1500, 3000, 6000、および12000から192000までの12000刻みの値
  #   # INTELLIGENT_TIERINGストレージタイプの場合、有効な値は6000または12000
  #   # 警告: iopsの値を高い値から低い値に更新すると、リソースの再作成が強制される
  #   #      ファイルシステム上のすべてのデータは再作成時に失われる
  #   # iops = null
  # }

  #---------------------------------------------------------------
  # ネストブロック - Root Squash設定
  #---------------------------------------------------------------
  # Amazon FSx for Lustreファイルシステム作成時に使用されるLustre root squash設定
  # 有効にすると、root squashはファイルシステムにrootユーザーとしてアクセスしようとする
  # クライアントからのrootレベルアクセスを制限

  # root_squash_configuration {
  #   # Root Squash（オプション）
  #   # ファイルシステムのユーザーID（UID）とグループID（GID）を設定してroot squashを有効化
  #   # フォーマット: UID:GID（例: 365534:65534）
  #   # UIDとGIDの値は0から4294967294の範囲
  #   # root_squash = null
  #
  #   # No Squash NID（オプション）
  #   # root squashが有効な場合、オプションでroot squashが適用されないクライアントのNID配列を指定可能
  #   # クライアントNIDは、クライアントを一意に識別するために使用されるLustre Network Identifier
  #   # NIDは単一アドレスまたはアドレス範囲として指定可能:
  #   #   1. 単一アドレス: クライアントのIPアドレスの後にLustreネットワークIDを指定（例: 10.0.1.6@tcp）
  #   #   2. アドレス範囲: ダッシュで範囲を区切って指定（例: 10.0.[2-10].[1-255]@tcp）
  #   # no_squash_nids = []
  # }

  #---------------------------------------------------------------
  # ネストブロック - タイムアウト設定
  #---------------------------------------------------------------

  # timeouts {
  #   # 作成タイムアウト（オプション）
  #   # ファイルシステム作成のタイムアウト時間
  #   # create = null
  #
  #   # 更新タイムアウト（オプション）
  #   # ファイルシステム更新のタイムアウト時間
  #   # update = null
  #
  #   # 削除タイムアウト（オプション）
  #   # ファイルシステム削除のタイムアウト時間
  #   # delete = null
  # }
}

#---------------------------------------------------------------
# Attributes Reference（参照専用の属性）
#---------------------------------------------------------------
# 以下の属性はリソース作成後に参照可能ですが、入力パラメータとしては設定できません:
#
# - arn                    : ファイルシステムのAmazon Resource Name
#                           例: arn:aws:fsx:us-west-2:123456789012:file-system/fs-12345678
#
# - dns_name               : ファイルシステムのDNS名
#                           例: fs-12345678.fsx.us-west-2.amazonaws.com
#
# - mount_name             : ファイルシステムをマウントする際に使用される値
#                           長さは1〜8文字
#
# - network_interface_ids  : ファイルシステムがアクセス可能なElastic Network Interfaceの識別子セット
#                           最初に返されるネットワークインターフェースがプライマリネットワークインターフェース
#                           参考: https://docs.aws.amazon.com/fsx/latest/LustreGuide/mounting-on-premises.html
#
# - owner_id               : ファイルシステムを作成したAWSアカウント識別子
#
# - vpc_id                 : ファイルシステムのVirtual Private Cloudの識別子
#
# 使用例:
# output "fsx_lustre_dns_name" {
#   value       = aws_fsx_lustre_file_system.example.dns_name
#   description = "FSx for Lustre ファイルシステムのDNS名"
# }
#
# output "fsx_lustre_mount_name" {
#   value       = aws_fsx_lustre_file_system.example.mount_name
#   description = "マウント時に使用される値"
# }
