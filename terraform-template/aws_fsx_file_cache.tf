#---------------------------------------------------------------
# Amazon FSx File Cache
#---------------------------------------------------------------
#
# Amazon FSx File Cacheは、複数のデータリポジトリ（S3、NFS）からの
# 高速アクセスを提供するLustreベースのキャッシュレイヤーです。
# オンプレミスやクラウド上のデータソースに対して低レイテンシーな
# アクセスを実現し、ハイパフォーマンスコンピューティング（HPC）
# ワークロードに最適化されています。
#
# AWS公式ドキュメント:
#   - API Reference: https://docs.aws.amazon.com/fsx/latest/APIReference/API_CreateFileCache.html
#   - User Guide: https://docs.aws.amazon.com/fsx/latest/FileCacheGuide/managing-caches.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/fsx_file_cache
#
# Provider Version: 6.28.0
# Generated: 2026-01-27
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_fsx_file_cache" "example" {
  #---------------------------------------------------------------
  # 必須パラメータ
  #---------------------------------------------------------------

  # キャッシュのタイプ。
  # 現時点では "LUSTRE" のみがサポートされています。
  # Type: string
  # Required: Yes
  file_cache_type = "LUSTRE"

  # キャッシュタイプのバージョン。
  # 現時点では "2.12" のみがサポートされています。
  # Type: string
  # Required: Yes
  file_cache_type_version = "2.12"

  # キャッシュのストレージ容量（GiB単位）。
  # 有効な値: 1200 GiB、2400 GiB、または2400 GiBの倍数。
  # Type: number
  # Required: Yes
  storage_capacity = 1200

  # キャッシュがアクセス可能なサブネットIDのリスト。
  # 指定できるサブネットIDは1つのみです。
  # キャッシュは単一のアベイラビリティゾーンに配置されます。
  # Type: list(string)
  # Required: Yes
  subnet_ids = ["subnet-12345678"]

  #---------------------------------------------------------------
  # オプションパラメータ
  #---------------------------------------------------------------

  # キャッシュのタグをデータリポジトリアソシエーションに
  # コピーするかどうかを示すブール値フラグ。
  # デフォルト: false
  # Type: bool
  # Optional: Yes
  copy_tags_to_data_repository_associations = false

  # リソース識別子。
  # 指定しない場合、Terraformが自動的に一意のIDを生成します。
  # Type: string
  # Optional: Yes
  # id = "custom-id"

  # Amazon File Cacheのデータを暗号化するために使用する
  # AWS Key Management Service (KMS) キーのID。
  # 指定しない場合、アカウントのAmazon FSx管理KMSキーが使用されます。
  # Type: string
  # Optional: Yes
  # kms_key_id = "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"

  # このリソースが管理されるAWSリージョン。
  # 指定しない場合、プロバイダー設定のリージョンがデフォルトで使用されます。
  # Type: string
  # Optional: Yes
  # region = "us-east-1"

  # Amazon File Cacheアクセス用に作成されるすべての
  # ネットワークインターフェースに適用するセキュリティグループIDのリスト。
  # キャッシュへのネットワークアクセスを制御します。
  # Type: set(string)
  # Optional: Yes
  security_group_ids = ["sg-12345678"]

  # キャッシュに関連付けるタグのマップ。
  # provider default_tagsと併用可能です。
  # Type: map(string)
  # Optional: Yes
  tags = {
    Name        = "example-file-cache"
    Environment = "production"
    Purpose     = "HPC workload"
  }

  # プロバイダーレベルのdefault_tagsとマージされたタグ。
  # 通常は明示的に指定する必要はありません。
  # Type: map(string)
  # Optional: Yes (computed)
  # tags_all は自動的に計算されます

  #---------------------------------------------------------------
  # Data Repository Association (DRA) ブロック
  #---------------------------------------------------------------
  # キャッシュ作成時に作成されるデータリポジトリアソシエーション（DRA）の設定。
  # 最大8つのDRAを作成可能です。
  # すべてのDRAは同じタイプ（すべてS3またはすべてNFS）である必要があります。
  # キャッシュは異なるデータリポジトリタイプに同時にリンクできません。
  # Type: set (max_items: 8)
  # Optional: Yes

  data_repository_association {
    # キャッシュ上のパス。高レベルディレクトリ（例: /ns1/）または
    # サブディレクトリ（例: /ns1/subdir/）を指す必要があります。
    # DataRepositoryPathと1対1でマッピングされます。
    # 先頭のスラッシュが必須です。
    # 2つのDRAが重複するキャッシュパスを持つことはできません。
    # 注: DataRepositorySubdirectoriesが指定されている場合、
    # NFSのDRAでのみキャッシュパスをルート（/）に設定できます。
    # Type: string
    # Required: Yes
    file_cache_path = "/ns1"

    # キャッシュにリンクするS3またはNFSデータリポジトリへのパス。
    # NFSの場合: nfs://filer.domain.com形式
    # S3の場合: s3://bucket-name/prefix形式
    # Type: string
    # Required: Yes
    data_repository_path = "nfs://filer.domain.com"

    # データリポジトリアソシエーションにリンクされるNFSエクスポートのリスト。
    # エクスポートパスは /exportpath1 の形式です。
    # このパラメータを使用するには、DataRepositoryPathを
    # NFSファイルシステムのドメイン名として設定する必要があります。
    # NFSファイルシステムのドメイン名は、実質的にサブディレクトリのルートになります。
    # 注: S3データリポジトリではサポートされていません。
    # Type: set(string)
    # Optional: Yes
    # Maximum: 500
    data_repository_subdirectories = ["test", "test2"]

    # DRAにアタッチされるタグ。
    # copy_tags_to_data_repository_associations が true の場合、
    # キャッシュのタグがこのDRAにコピーされます。
    # Type: map(string)
    # Optional: Yes
    tags = {
      Name = "example-dra"
    }

    #---------------------------------------------------------------
    # NFS設定ブロック（NFSデータリポジトリの場合）
    #---------------------------------------------------------------
    # NFSデータリポジトリの設定。
    # data_repository_pathがNFSの場合に必要です。
    # Type: set
    # Optional: Yes

    nfs {
      # NFSデータリポジトリのネットワークファイルシステム（NFS）プロトコルのバージョン。
      # データリポジトリはNFSv3プロトコルをサポートしている必要があります。
      # サポートされる値: "NFS3"
      # Type: string
      # Required: Yes
      version = "NFS3"

      # NFSファイルシステムのドメイン名を解決するために使用される
      # DNSサーバーの最大2つのIPアドレスのリスト。
      # 指定されるIPアドレスは、顧客が管理し顧客のVPC内で実行される
      # DNSフォワーダーまたはリゾルバーのIPアドレス、または
      # オンプレミスのDNSサーバーのIPアドレスのいずれかです。
      # Type: set(string)
      # Optional: Yes
      # Maximum: 2 IP addresses
      dns_ips = ["192.168.0.1", "192.168.0.2"]
    }
  }

  #---------------------------------------------------------------
  # Lustre設定ブロック（必須）
  #---------------------------------------------------------------
  # file_cache_typeが "LUSTRE" の場合に必須の設定ブロック。
  # Type: set
  # Required: Yes (when file_cache_type is LUSTRE)

  lustre_configuration {
    # キャッシュのデプロイメントタイプ。
    # サポートされる値: "CACHE_1"
    # Type: string
    # Required: Yes
    deployment_type = "CACHE_1"

    # キャッシュストレージ容量の1テビバイト（TiB）あたりの
    # 読み取りおよび書き込みスループット量（MB/s/TiB）。
    # サポートされる値: 1000
    # Type: number
    # Required: Yes
    per_unit_storage_throughput = 1000

    # 毎週メンテナンスの開始時刻（UTC）。
    # 形式: "D:HH:MM"
    # D: 曜日（1=月曜日、7=日曜日）
    # HH: 時間（0-23、ゼロパディング）
    # MM: 分（0-59、ゼロパディング）
    # 例: "1:05:00" は月曜日の午前5時を示します
    # Type: string
    # Optional: Yes
    weekly_maintenance_start_time = "2:05:00"

    #---------------------------------------------------------------
    # メタデータ設定ブロック（必須）
    #---------------------------------------------------------------
    # Lustre MDT（メタデータターゲット）ストレージボリュームの設定。
    # Type: set (min_items: 1, max_items: 8)
    # Required: Yes

    metadata_configuration {
      # Lustre MDT（メタデータターゲット）ストレージボリュームの
      # ストレージ容量（GiB単位）。
      # サポートされる値: 2400 GiB
      # Type: number
      # Required: Yes
      storage_capacity = 2400
    }
  }

  #---------------------------------------------------------------
  # タイムアウト設定
  #---------------------------------------------------------------
  # リソース操作のタイムアウト設定。
  # Type: single block
  # Optional: Yes

  timeouts {
    # キャッシュ作成のタイムアウト。
    # デフォルト: 30m
    # Type: string
    # Optional: Yes
    # create = "30m"

    # キャッシュ更新のタイムアウト。
    # デフォルト: 30m
    # Type: string
    # Optional: Yes
    # update = "30m"

    # キャッシュ削除のタイムアウト。
    # デフォルト: 30m
    # Type: string
    # Optional: Yes
    # delete = "30m"
  }
}

#---------------------------------------------------------------
# Attributes Reference
#---------------------------------------------------------------
# 以下の属性は、リソース作成後に参照可能です（computed only）:
#
# - arn
#   Type: string
#   リソースのAmazon Resource Name (ARN)。
#   例: arn:aws:fsx:us-east-1:123456789012:file-cache/fc-0123456789abcdef0
#
# - data_repository_association_ids
#   Type: set(string)
#   このキャッシュに関連付けられているデータリポジトリアソシエーションのIDのリスト。
#
# - dns_name
#   Type: string
#   キャッシュのDomain Name System (DNS) 名。
#   クライアントがキャッシュをマウントする際に使用します。
#
# - file_cache_id
#   Type: string
#   システムが生成したキャッシュの一意のID。
#   例: fc-0123456789abcdef0
#
# - id
#   Type: string
#   システムが生成したキャッシュの一意のID（file_cache_idと同じ値）。
#
# - network_interface_ids
#   Type: set(string)
#   キャッシュに関連付けられているネットワークインターフェースIDのリスト。
#
# - owner_id
#   Type: string
#   キャッシュを所有するAWSアカウントID。
#
# - vpc_id
#   Type: string
#   キャッシュが配置されている仮想プライベートクラウド（VPC）のID。
#
#---------------------------------------------------------------
