#---------------------------------------------------------------
# AWS Keyspaces (Amazon Keyspaces) テーブル
#---------------------------------------------------------------
#
# Amazon Keyspaces (Apache Cassandra 互換) のテーブルをプロビジョニングするリソースです。
# Amazon Keyspaces はサーバーレスでスケーラブルな Cassandra 互換データベースサービスで、
# Cassandra Query Language (CQL) を使用してテーブルとデータを操作できます。
# 高可用性、自動スケーリング、完全マネージドなインフラを提供します。
#
# 主なユースケース:
#   - IoT デバイスデータの時系列ストレージ
#   - ユーザープロファイルやセッション管理
#   - 大量の書き込みが発生するアプリケーション
#   - 既存の Cassandra ワークロードの移行
#
# 重要な注意事項:
#   - テーブルを作成する前に aws_keyspaces_keyspace リソースでキースペースを作成する必要があります
#   - schema_definition ブロックは必須です（テーブル作成後の変更は制限があります）
#   - schema_definition 内の partition_key と column ブロックは最低1つ必要です
#
# AWS公式ドキュメント:
#   - Amazon Keyspaces 概要: https://docs.aws.amazon.com/keyspaces/latest/devguide/what-is-keyspaces.html
#   - テーブル作成: https://docs.aws.amazon.com/keyspaces/latest/devguide/getting-started.tables.html
#   - キャパシティモード: https://docs.aws.amazon.com/keyspaces/latest/devguide/ReadWriteCapacityMode.html
#   - 暗号化: https://docs.aws.amazon.com/keyspaces/latest/devguide/EncryptionAtRest.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/keyspaces_table
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_keyspaces_table" "example" {
  #---------------------------------------------------------------
  # 基本設定
  #---------------------------------------------------------------

  # keyspace_name (Required)
  # 設定内容: テーブルを作成するキースペース名を指定します。
  # 設定可能な値: 既存の Amazon Keyspaces キースペース名の文字列
  # 注意: aws_keyspaces_keyspace リソースで事前に作成されている必要があります
  keyspace_name = "example_keyspace"

  # table_name (Required)
  # 設定内容: 作成するテーブルの名前を指定します。
  # 設定可能な値: Cassandra のテーブル命名規則に従った文字列（英小文字、数字、アンダースコア）
  # 注意: キースペース内で一意である必要があります
  table_name = "example_table"

  #---------------------------------------------------------------
  # スキーマ定義
  #---------------------------------------------------------------

  # schema_definition ブロック (Required)
  # 設定内容: テーブルのスキーマ（列定義、パーティションキー、クラスタリングキー）を定義します。
  # 注意: テーブル作成後にスキーマを変更するとリソースが再作成される場合があります
  schema_definition {
    # column ブロック (Required, 1つ以上)
    # 設定内容: テーブルの列を定義します。パーティションキー、クラスタリングキー、
    #           静的列として使用する列も含めてすべてここで定義します。
    column {
      # name (Required)
      # 設定内容: 列の名前を指定します。
      # 設定可能な値: Cassandra の識別子規則に従った文字列
      name = "id"

      # type (Required)
      # 設定内容: 列のデータ型を指定します。
      # 設定可能な値:
      #   - プリミティブ型: "ascii", "bigint", "blob", "boolean", "counter",
      #                     "date", "decimal", "double", "float", "inet",
      #                     "int", "smallint", "text", "time", "timestamp",
      #                     "timeuuid", "tinyint", "uuid", "varchar", "varint"
      #   - コレクション型: "list<text>", "map<text, text>", "set<text>" など
      type = "uuid"
    }

    column {
      name = "created_at"
      type = "timestamp"
    }

    column {
      name = "data"
      type = "text"
    }

    # partition_key ブロック (Required, 1つ以上)
    # 設定内容: テーブルのパーティションキー列を指定します。
    #           パーティションキーはデータの分散先ノードを決定します。
    # 注意: column ブロックで定義済みの列名を指定する必要があります
    partition_key {
      # name (Required)
      # 設定内容: パーティションキーとして使用する列名を指定します。
      # 設定可能な値: column ブロックで定義した列名
      name = "id"
    }

    # clustering_key ブロック (Optional)
    # 設定内容: テーブルのクラスタリングキー（ソートキー）を定義します。
    #           パーティション内でのデータのソート順序を制御します。
    # 注意: column ブロックで定義済みの列名を指定する必要があります
    clustering_key {
      # name (Required)
      # 設定内容: クラスタリングキーとして使用する列名を指定します。
      # 設定可能な値: column ブロックで定義した列名
      name = "created_at"

      # order_by (Required)
      # 設定内容: クラスタリングキーのソート順序を指定します。
      # 設定可能な値:
      #   - "ASC": 昇順（デフォルト）
      #   - "DESC": 降順
      order_by = "DESC"
    }

    # static_column ブロック (Optional)
    # 設定内容: 静的列を定義します。静的列はパーティション内のすべての行で共有される値です。
    # 注意: クラスタリングキーが存在するテーブルでのみ有効です
    # static_column {
    #   # name (Required)
    #   # 設定内容: 静的列として定義する列名を指定します。
    #   # 設定可能な値: column ブロックで定義した列名
    #   name = "shared_data"
    # }
  }

  #---------------------------------------------------------------
  # キャパシティ設定
  #---------------------------------------------------------------

  # capacity_specification ブロック (Optional)
  # 設定内容: テーブルの読み取り・書き込みキャパシティの設定を行います。
  # 省略時: プロビジョンドモード（PAY_PER_REQUEST が設定されます）
  capacity_specification {
    # throughput_mode (Optional, Computed)
    # 設定内容: テーブルのスループットモードを指定します。
    # 設定可能な値:
    #   - "PAY_PER_REQUEST": オンデマンドモード。使用した分だけ課金されます
    #   - "PROVISIONED": プロビジョンドモード。事前にキャパシティを指定します
    # 省略時: Terraform が自動決定します（通常 PAY_PER_REQUEST）
    throughput_mode = "PAY_PER_REQUEST"

    # read_capacity_units (Optional)
    # 設定内容: プロビジョンドモードでの1秒あたりの読み取りキャパシティユニット数を指定します。
    # 設定可能な値: 正の整数
    # 省略時: throughput_mode が "PAY_PER_REQUEST" の場合は不要です
    # 注意: throughput_mode = "PROVISIONED" の場合に設定します
    read_capacity_units = null

    # write_capacity_units (Optional)
    # 設定内容: プロビジョンドモードでの1秒あたりの書き込みキャパシティユニット数を指定します。
    # 設定可能な値: 正の整数
    # 省略時: throughput_mode が "PAY_PER_REQUEST" の場合は不要です
    # 注意: throughput_mode = "PROVISIONED" の場合に設定します
    write_capacity_units = null
  }

  #---------------------------------------------------------------
  # 暗号化設定
  #---------------------------------------------------------------

  # encryption_specification ブロック (Optional)
  # 設定内容: テーブルの保存時暗号化（Encryption at Rest）を設定します。
  # 省略時: AWS が管理するキー（SERVICE_MANAGED）による暗号化が適用されます
  encryption_specification {
    # type (Optional, Computed)
    # 設定内容: 暗号化に使用するキーの種類を指定します。
    # 設定可能な値:
    #   - "AWS_OWNED_KMS_KEY": AWS が所有・管理するキーを使用（追加費用なし）
    #   - "CUSTOMER_MANAGED_KMS_KEY": カスタマーマネージドキー（CMK）を使用
    # 省略時: Terraform が自動決定します
    type = "AWS_OWNED_KMS_KEY"

    # kms_key_identifier (Optional)
    # 設定内容: カスタマーマネージドキーの ARN またはエイリアスを指定します。
    # 設定可能な値: KMS キーの ARN 文字列（例: arn:aws:kms:region:account:key/key-id）
    # 省略時: type が "AWS_OWNED_KMS_KEY" の場合は不要です
    # 注意: type = "CUSTOMER_MANAGED_KMS_KEY" の場合に必須です
    kms_key_identifier = null
  }

  #---------------------------------------------------------------
  # ポイントインタイムリカバリ設定
  #---------------------------------------------------------------

  # point_in_time_recovery ブロック (Optional)
  # 設定内容: Point-in-Time Recovery (PITR) の設定を行います。
  #           有効にすると継続的なバックアップが作成され、任意の時点へのリストアが可能になります。
  point_in_time_recovery {
    # status (Optional, Computed)
    # 設定内容: PITR の有効・無効を指定します。
    # 設定可能な値:
    #   - "ENABLED": PITR を有効化（過去35日間の任意の時点にリストア可能）
    #   - "DISABLED": PITR を無効化
    # 省略時: Terraform が自動決定します
    status = "ENABLED"
  }

  #---------------------------------------------------------------
  # TTL 設定
  #---------------------------------------------------------------

  # ttl ブロック (Optional)
  # 設定内容: テーブルの Time to Live (TTL) 機能を設定します。
  #           TTL を有効にすると、指定した期間が経過したアイテムを自動的に削除できます。
  ttl {
    # status (Required)
    # 設定内容: TTL の有効・無効を指定します。
    # 設定可能な値:
    #   - "ENABLED": TTL を有効化
    #   - "DISABLED": TTL を無効化
    # 注意: TTL を有効にした後は無効に戻せません
    status = "ENABLED"
  }

  #---------------------------------------------------------------
  # クライアントサイドタイムスタンプ設定
  #---------------------------------------------------------------

  # client_side_timestamps ブロック (Optional)
  # 設定内容: クライアントサイドタイムスタンプ機能を設定します。
  #           有効にすると、クライアントが提供するタイムスタンプを使用した
  #           より細粒度のバージョン管理が可能になります。
  client_side_timestamps {
    # status (Required)
    # 設定内容: クライアントサイドタイムスタンプの有効・無効を指定します。
    # 設定可能な値:
    #   - "ENABLED": クライアントサイドタイムスタンプを有効化
    # 注意: 一度有効にすると無効に戻せません
    status = "ENABLED"
  }

  #---------------------------------------------------------------
  # コメント設定
  #---------------------------------------------------------------

  # comment ブロック (Optional)
  # 設定内容: テーブルに付与するコメントを設定します。
  comment {
    # message (Optional, Computed)
    # 設定内容: テーブルのコメントメッセージを指定します。
    # 設定可能な値: 任意の文字列
    # 省略時: Terraform が自動決定します
    message = "Example Keyspaces table for demonstration"
  }

  #---------------------------------------------------------------
  # デフォルト TTL 設定
  #---------------------------------------------------------------

  # default_time_to_live (Optional)
  # 設定内容: テーブルのデフォルト TTL（秒）を指定します。
  #           個別の行に TTL が設定されていない場合、このデフォルト値が適用されます。
  # 設定可能な値: 0（無効）または正の整数（秒単位）
  # 省略時: デフォルト TTL なし（0 相当）
  # 注意: ttl ブロックで TTL を有効化している必要があります
  default_time_to_live = 86400 # 24時間

  #---------------------------------------------------------------
  # リージョン設定
  #---------------------------------------------------------------

  # region (Optional, Computed)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効な AWS リージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #---------------------------------------------------------------
  # タグ設定
  #---------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに付与するタグをキーと値のペアで指定します。
  # 設定可能な値: 最大50個のキーと値のペア。キーは最大128文字、値は最大256文字
  # 省略時: タグなし
  tags = {
    Name        = "example-keyspaces-table"
    Environment = "development"
    ManagedBy   = "Terraform"
  }

  #---------------------------------------------------------------
  # タイムアウト設定
  #---------------------------------------------------------------

  # timeouts ブロック (Optional)
  # 設定内容: リソース操作のタイムアウト値を指定します。
  timeouts {
    # create (Optional)
    # 設定内容: 作成操作のタイムアウトを指定します。
    # 設定可能な値: "30m" などの duration 文字列
    create = "10m"

    # update (Optional)
    # 設定内容: 更新操作のタイムアウトを指定します。
    # 設定可能な値: "30m" などの duration 文字列
    update = "10m"

    # delete (Optional)
    # 設定内容: 削除操作のタイムアウトを指定します。
    # 設定可能な値: "10m" などの duration 文字列
    delete = "10m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn
#     テーブルの Amazon Resource Name (ARN)
#     例: arn:aws:cassandra:ap-northeast-1:123456789012:/keyspace/example_keyspace/table/example_table
#
# - id
#     キースペース名とテーブル名の組み合わせ（keyspace_name/table_name）
#
# - tags_all
#     プロバイダーの default_tags を含む全タグのマップ
#
#---------------------------------------------------------------
