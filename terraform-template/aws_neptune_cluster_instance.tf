#---------------------------------------------------------------
# AWS Neptune Cluster Instance
#---------------------------------------------------------------
#
# Amazon Neptune クラスターインスタンスリソースです。
# クラスターインスタンスは Neptune クラスター内の個々のインスタンスに固有の属性を定義します。
# Neptune はレプリケーションを自動管理するため、インスタンスを追加するだけで
# Neptune がレプリケーションを処理します。count メタパラメータを使用して
# 複数のインスタンスを作成し、同一の Neptune クラスターに参加させることができます。
#
# AWS公式ドキュメント:
#   - Neptune クラスターとインスタンス: https://docs.aws.amazon.com/neptune/latest/userguide/feature-overview-db-clusters.html
#   - Neptune エンドポイント: https://docs.aws.amazon.com/neptune/latest/userguide/feature-overview-endpoints.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/neptune_cluster_instance
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_neptune_cluster_instance" "example" {
  #-------------------------------------------------------------
  # クラスター設定
  #-------------------------------------------------------------

  # cluster_identifier (Required)
  # 設定内容: このインスタンスを起動する aws_neptune_cluster の識別子を指定します。
  cluster_identifier = "my-neptune-cluster"

  #-------------------------------------------------------------
  # インスタンスクラス設定
  #-------------------------------------------------------------

  # instance_class (Required)
  # 設定内容: 使用するインスタンスクラスを指定します。
  # 設定可能な値: db.r4.large, db.r4.xlarge, db.r4.2xlarge, db.r4.4xlarge, db.r4.8xlarge,
  #              db.r5.large, db.r5.xlarge, db.r5.2xlarge, db.r5.4xlarge, db.r5.8xlarge,
  #              db.r6g.large, db.r6g.xlarge, db.r6g.2xlarge, db.r6g.4xlarge, db.r6g.8xlarge,
  #              db.r8g.large, db.r8g.xlarge, db.r8g.2xlarge, db.r8g.4xlarge, db.r8g.8xlarge
  #              など。db.serverless を指定するとサーバーレスインスタンスになります。
  # 参考: https://docs.aws.amazon.com/neptune/latest/userguide/neptune-setup.html
  instance_class = "db.r5.large"

  #-------------------------------------------------------------
  # 識別子設定
  #-------------------------------------------------------------

  # identifier (Optional, Forces new resource)
  # 設定内容: Neptune インスタンスの識別子を指定します。
  # 省略時: Terraform がランダムな一意の識別子を割り当てます。
  # 注意: identifier_prefix と排他的（どちらか一方のみ指定可能）
  identifier = null

  # identifier_prefix (Optional, Forces new resource)
  # 設定内容: 指定されたプレフィックスで始まる一意の識別子を作成します。
  # 省略時: Terraform が一意のプレフィックスを自動生成します。
  # 注意: identifier と排他的（どちらか一方のみ指定可能）
  identifier_prefix = null

  #-------------------------------------------------------------
  # エンジン設定
  #-------------------------------------------------------------

  # engine (Optional)
  # 設定内容: Neptune インスタンスで使用するデータベースエンジン名を指定します。
  # 設定可能な値: "neptune"
  # 省略時: "neptune"
  engine = "neptune"

  # engine_version (Optional)
  # 設定内容: Neptune エンジンのバージョンを指定します。
  # 省略時: Neptune クラスターのエンジンバージョンを継承します。
  engine_version = null

  #-------------------------------------------------------------
  # ネットワーク設定
  #-------------------------------------------------------------

  # neptune_subnet_group_name (Optional)
  # 設定内容: この Neptune インスタンスに関連付けるサブネットグループを指定します。
  # 設定可能な値: 有効な Neptune サブネットグループ名
  # 省略時: Neptune クラスターのサブネットグループを継承します。
  # 注意: publicly_accessible = false の場合は必須。アタッチされた
  #       aws_neptune_cluster の neptune_subnet_group_name と一致している必要があります。
  neptune_subnet_group_name = null

  # availability_zone (Optional)
  # 設定内容: Neptune インスタンスを作成する EC2 アベイラビリティーゾーンを指定します。
  # 設定可能な値: 有効な AZ 名（例: "ap-northeast-1a"）
  # 省略時: AWS がアベイラビリティーゾーンを自動選択します。
  availability_zone = null

  # port (Optional)
  # 設定内容: DB が接続を受け付けるポート番号を指定します。
  # 省略時: 8182
  port = 8182

  # publicly_accessible (Optional)
  # 設定内容: インスタンスをパブリックアクセス可能にするかを指定します。
  # 設定可能な値:
  #   - true: パブリックアクセスを有効化
  #   - false (デフォルト): パブリックアクセスを無効化
  publicly_accessible = false

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # パラメータグループ設定
  #-------------------------------------------------------------

  # neptune_parameter_group_name (Optional)
  # 設定内容: このインスタンスに関連付ける Neptune パラメータグループ名を指定します。
  # 省略時: デフォルトの Neptune パラメータグループを使用
  neptune_parameter_group_name = null

  #-------------------------------------------------------------
  # バックアップ設定
  #-------------------------------------------------------------

  # preferred_backup_window (Optional)
  # 設定内容: 自動バックアップが有効な場合に自動バックアップが作成される毎日の時間範囲（UTC）を指定します。
  # 設定可能な値: "HH:MM-HH:MM" 形式（例: "04:00-09:00"）
  # 省略時: Neptune クラスターの設定を継承します。
  preferred_backup_window = null

  # skip_final_snapshot (Optional)
  # 設定内容: DB インスタンス削除前に最終 DB スナップショットを作成するかを指定します。
  # 設定可能な値:
  #   - true: 最終スナップショットを作成しない
  #   - false (デフォルト): 最終スナップショットを作成
  skip_final_snapshot = false

  #-------------------------------------------------------------
  # メンテナンス設定
  #-------------------------------------------------------------

  # preferred_maintenance_window (Optional)
  # 設定内容: システムメンテナンスを実行できる週次の時間範囲（UTC）を指定します。
  # 設定可能な値: "ddd:hh24:mi-ddd:hh24:mi" 形式（例: "Mon:00:00-Mon:03:00"）
  # 省略時: Neptune クラスターの設定を継承します。
  preferred_maintenance_window = null

  # apply_immediately (Optional)
  # 設定内容: インスタンスへの変更を即座に適用するか、次のメンテナンスウィンドウで適用するかを指定します。
  # 設定可能な値:
  #   - true: 即座に適用
  #   - false (デフォルト): 次のメンテナンスウィンドウで適用
  apply_immediately = false

  # auto_minor_version_upgrade (Optional)
  # 設定内容: メンテナンスウィンドウ中にインスタンスへのマイナーエンジンアップグレードを
  #           自動的に適用するかを指定します。
  # 設定可能な値:
  #   - true (デフォルト): 自動アップグレードを有効化
  #   - false: 自動アップグレードを無効化
  auto_minor_version_upgrade = true

  #-------------------------------------------------------------
  # フェイルオーバー設定
  #-------------------------------------------------------------

  # promotion_tier (Optional)
  # 設定内容: フェイルオーバーの優先度を指定します。より低い tier の読み取りレプリカが
  #           ライターに昇格する優先度が高くなります。
  # 設定可能な値: 0〜15 の整数
  # 省略時: 0
  promotion_tier = 0

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: インスタンスに割り当てるタグのマップを指定します。
  # プロバイダーレベルの default_tags 設定ブロックで定義されたタグと
  # 一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "my-neptune-instance"
    Environment = "production"
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト値を指定します。
  timeouts {
    # create (Optional)
    # 設定内容: 作成操作のタイムアウトを指定します。
    # 設定可能な値: Goの time.Duration 形式（例: "90m", "1h30m"）
    create = "90m"

    # update (Optional)
    # 設定内容: 更新操作のタイムアウトを指定します。
    # 設定可能な値: Goの time.Duration 形式（例: "90m", "1h30m"）
    update = "90m"

    # delete (Optional)
    # 設定内容: 削除操作のタイムアウトを指定します。
    # 設定可能な値: Goの time.Duration 形式（例: "90m", "1h30m"）
    delete = "90m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - address: インスタンスのホスト名（endpoint および port も参照）
#
# - arn: Neptune インスタンスの Amazon Resource Name (ARN)
#
# - dbi_resource_id: Neptune インスタンスのリージョン固有の不変識別子
#
# - endpoint: "address:port" 形式の接続エンドポイント
#
# - id: インスタンス識別子
#
# - kms_key_arn: Neptune クラスターに KMS 暗号化キーが設定されている場合のその ARN
#
# - storage_encrypted: Neptune クラスターが暗号化されているかを示すフラグ
#
# - storage_type: クラスターに関連するストレージタイプ（standard または iopt1）
#
# - tags_all: プロバイダーの default_tags から継承されたタグを含む全タグのマップ
#
# - writer: このインスタンスがライターかどうかを示すフラグ
#            false の場合、このインスタンスは読み取りレプリカです。
#---------------------------------------------------------------
