#---------------------------------------------------------------
# AWS DynamoDB Table
#---------------------------------------------------------------
#
# Amazon DynamoDB テーブルをプロビジョニングするリソースです。
# DynamoDB はフルマネージドの NoSQL データベースサービスで、
# あらゆる規模でミリ秒単位のパフォーマンスを提供します。
# キーバリュー型とドキュメント型のデータモデルをサポートし、
# サーバーレスアプリケーションやゲームなど幅広いユースケースに対応します。
#
# NOTE: autoscaling policy を使用する場合、read_capacity と write_capacity に
#       lifecycle ignore_changes を設定することを推奨します。
#
# NOTE: aws_dynamodb_table_replica リソースと併用する場合、replica ブロックに
#       lifecycle ignore_changes を設定することを推奨します。
#
# NOTE: GSI の autoscaling でドリフトが発生する場合は、実験的リソース
#       aws_dynamodb_global_secondary_index の使用を検討してください。
#
# AWS公式ドキュメント:
#   - DynamoDB 概要: https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/Introduction.html
#   - テーブルの操作: https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/WorkingWithTables.html
#   - グローバルテーブル: https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/GlobalTables.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_table
#
# Provider Version: 6.38.0
# Generated: 2026-03-26
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_dynamodb_table" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required, Forces new resource)
  # 設定内容: テーブルの名前を指定します。リージョン内で一意である必要があります。
  # 設定可能な値: 3〜255文字の文字列
  name = "example-table"

  #-------------------------------------------------------------
  # 課金モード・キャパシティ設定
  #-------------------------------------------------------------

  # billing_mode (Optional)
  # 設定内容: 読み取り/書き込みスループットの課金方式を指定します。
  # 設定可能な値:
  #   - "PROVISIONED" (デフォルト): プロビジョンドキャパシティモード。
  #                                 事前にキャパシティを指定し、その分だけ課金されます。
  #   - "PAY_PER_REQUEST": オンデマンドキャパシティモード。
  #                        実際の使用量に基づいて課金されます。
  billing_mode = "PROVISIONED"

  # read_capacity (Optional)
  # 設定内容: プロビジョンドモードでの読み取りキャパシティユニット（RCU）を指定します。
  # 設定可能な値: 正の整数
  # 注意: billing_mode が "PROVISIONED" の場合は必須です。
  #       autoscaling を使用する場合は lifecycle ignore_changes に追加を推奨。
  read_capacity = 20

  # write_capacity (Optional)
  # 設定内容: プロビジョンドモードでの書き込みキャパシティユニット（WCU）を指定します。
  # 設定可能な値: 正の整数
  # 注意: billing_mode が "PROVISIONED" の場合は必須です。
  #       autoscaling を使用する場合は lifecycle ignore_changes に追加を推奨。
  write_capacity = 20

  #-------------------------------------------------------------
  # キー設定
  #-------------------------------------------------------------

  # hash_key (Optional, Forces new resource)
  # 設定内容: パーティションキー（ハッシュキー）として使用する属性名を指定します。
  # 注意: attribute ブロックでも同じ属性を定義する必要があります。
  hash_key = "UserId"

  # range_key (Optional, Forces new resource)
  # 設定内容: ソートキー（レンジキー）として使用する属性名を指定します。
  # 注意: attribute ブロックでも同じ属性を定義する必要があります。
  range_key = "GameTitle"

  #-------------------------------------------------------------
  # ストリーム設定
  #-------------------------------------------------------------

  # stream_enabled (Optional)
  # 設定内容: DynamoDB Streams を有効にするかを指定します。
  # 設定可能な値:
  #   - true: ストリームを有効化
  #   - false: ストリームを無効化
  # 関連機能: DynamoDB Streams
  #   テーブルの変更をキャプチャし、Lambda などで処理できます。
  stream_enabled = false

  # stream_view_type (Optional)
  # 設定内容: ストリームレコードに含める情報を指定します。
  # 設定可能な値:
  #   - "KEYS_ONLY": 変更されたアイテムのキー属性のみ
  #   - "NEW_IMAGE": 変更後のアイテム全体
  #   - "OLD_IMAGE": 変更前のアイテム全体
  #   - "NEW_AND_OLD_IMAGES": 変更前後両方のアイテム全体
  # 注意: stream_enabled が true の場合のみ有効です。
  stream_view_type = null

  #-------------------------------------------------------------
  # テーブルクラス設定
  #-------------------------------------------------------------

  # table_class (Optional)
  # 設定内容: テーブルのストレージクラスを指定します。
  # 設定可能な値:
  #   - "STANDARD" (デフォルト): 標準クラス。頻繁にアクセスされるデータ向け。
  #   - "STANDARD_INFREQUENT_ACCESS": 低頻度アクセスクラス。
  #                                   アクセス頻度が低いデータ向けでストレージコストが低い。
  table_class = "STANDARD"

  #-------------------------------------------------------------
  # 削除保護設定
  #-------------------------------------------------------------

  # deletion_protection_enabled (Optional)
  # 設定内容: 削除保護を有効にするかを指定します。
  # 設定可能な値:
  #   - true: 削除保護を有効化。API や Terraform からの削除を防止。
  #   - false (デフォルト): 削除保護を無効化
  deletion_protection_enabled = false

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効な AWS リージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # リストア設定（Point-in-Time Recovery からの復元）
  #-------------------------------------------------------------

  # restore_backup_arn (Optional)
  # 設定内容: リストア元の DynamoDB バックアップの ARN を指定します。
  # 注意: バックアップからテーブルを復元する場合に使用します。
  restore_backup_arn = null

  # restore_source_name (Optional)
  # 設定内容: リストア元のテーブル名を指定します。
  # 注意: 既存テーブルの名前と一致する必要があります。
  restore_source_name = null

  # restore_source_table_arn (Optional)
  # 設定内容: リストア元テーブルの ARN を指定します。
  # 注意: クロスリージョンリストアの場合に必須です。
  restore_source_table_arn = null

  # restore_date_time (Optional)
  # 設定内容: Point-in-Time Recovery の復元ポイントの日時を指定します。
  # 設定可能な値: ISO 8601 形式の日時文字列（例: "2024-01-15T12:00:00Z"）
  restore_date_time = null

  # restore_to_latest_time (Optional)
  # 設定内容: 最新の復元ポイントにリストアするかを指定します。
  # 設定可能な値:
  #   - true: 最新の復元ポイントを使用
  #   - false: restore_date_time で指定した時点を使用
  restore_to_latest_time = null

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: プロバイダーの default_tags 設定ブロックで定義されたタグと
  #           一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "example-table"
    Environment = "production"
  }

  # tags_all (Optional, Computed)
  # 設定内容: プロバイダーの default_tags から継承されたタグを含む全タグのマップです。
  # 注意: 通常は明示的に設定せず、Terraform が自動計算します。
  # tags_all = {}

  #-------------------------------------------------------------
  # attribute ブロック (Required)
  #-------------------------------------------------------------
  # 設定内容: テーブルやインデックスで使用するキー属性を定義します。
  # 注意: hash_key, range_key, およびインデックスで使用する属性のみ定義が必要です。
  #       非キー属性は定義不要です（スキーマレスなため）。

  attribute {
    # name (Required)
    # 設定内容: 属性の名前を指定します。
    name = "UserId"

    # type (Required)
    # 設定内容: 属性のデータ型を指定します。
    # 設定可能な値:
    #   - "S": 文字列（String）
    #   - "N": 数値（Number）
    #   - "B": バイナリ（Binary）
    type = "S"
  }

  attribute {
    name = "GameTitle"
    type = "S"
  }

  attribute {
    name = "TopScore"
    type = "N"
  }

  #-------------------------------------------------------------
  # global_secondary_index ブロック (Optional)
  #-------------------------------------------------------------
  # 設定内容: グローバルセカンダリインデックス（GSI）を定義します。
  # GSI は異なるパーティションキーとソートキーを使用してテーブルをクエリできます。
  # 注意: GSI の数は通常テーブルあたり 20 までです（クォータ引き上げ可能）。

  global_secondary_index {
    # name (Required)
    # 設定内容: インデックスの名前を指定します。
    name = "GameTitleIndex"

    # hash_key (Optional, 非推奨)
    # 設定内容: GSI のパーティションキーとして使用する属性名を指定します。
    # 注意: 非推奨。key_schema の使用を推奨します。key_schema と排他的です。
    #       attribute ブロックで定義されている必要があります。
    hash_key = "GameTitle"

    # range_key (Optional, 非推奨)
    # 設定内容: GSI のソートキーとして使用する属性名を指定します。
    # 注意: 非推奨。key_schema の使用を推奨します。key_schema と排他的です。
    #       attribute ブロックで定義されている必要があります。
    range_key = "TopScore"

    # key_schema (Optional)
    # 設定内容: GSI のキースキーマを定義します。マルチ属性キーパターンをサポートします。
    # 注意: hash_key / range_key と排他的です。hash_key を指定しない場合は必須です。
    #       HASH キーと RANGE キーをそれぞれ最大 4 つまで指定可能です。
    #       参考: https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/GSI.DesignPattern.MultiAttributeKeys.html
    # key_schema {
    #   # attribute_name (Required)
    #   # 設定内容: キーとして使用する属性名を指定します。
    #   attribute_name = "GameTitle"
    #
    #   # key_type (Required)
    #   # 設定内容: キーの種類を指定します。
    #   # 設定可能な値:
    #   #   - "HASH": パーティションキー（最大 4 つ）
    #   #   - "RANGE": ソートキー（最大 4 つ）
    #   key_type = "HASH"
    # }
    # key_schema {
    #   attribute_name = "TopScore"
    #   key_type       = "RANGE"
    # }

    # projection_type (Required)
    # 設定内容: インデックスに射影する属性のセットを指定します。
    # 設定可能な値:
    #   - "ALL": すべての属性をインデックスに射影
    #   - "KEYS_ONLY": テーブルとインデックスのキー属性のみ射影
    #   - "INCLUDE": non_key_attributes で指定した属性とキー属性を射影
    projection_type = "INCLUDE"

    # non_key_attributes (Optional)
    # 設定内容: インデックスに射影する非キー属性のリストを指定します。
    # 注意: projection_type が "INCLUDE" の場合のみ必要です。
    #       attribute ブロックで定義する必要はありません。
    non_key_attributes = ["UserId"]

    # read_capacity (Optional)
    # 設定内容: GSI の読み取りキャパシティユニット（RCU）を指定します。
    # 注意: billing_mode が "PROVISIONED" の場合に設定します。
    read_capacity = 10

    # write_capacity (Optional)
    # 設定内容: GSI の書き込みキャパシティユニット（WCU）を指定します。
    # 注意: billing_mode が "PROVISIONED" の場合に設定します。
    write_capacity = 10

    # on_demand_throughput (Optional)
    # 設定内容: オンデマンドモードでの GSI の最大スループットを設定します。
    # on_demand_throughput {
    #   # max_read_request_units (Optional)
    #   # 設定内容: 最大読み取りリクエストユニットを指定します。
    #   # 設定可能な値: 1以上の整数。削除する場合は -1 を指定。
    #   max_read_request_units = 100
    #
    #   # max_write_request_units (Optional)
    #   # 設定内容: 最大書き込みリクエストユニットを指定します。
    #   # 設定可能な値: 1以上の整数。削除する場合は -1 を指定。
    #   max_write_request_units = 100
    # }

    # warm_throughput (Optional)
    # 設定内容: GSI のウォームスループットを設定します。
    # warm_throughput {
    #   # read_units_per_second (Optional)
    #   # 設定内容: 1秒あたりのウォーム読み取りユニットを指定します。
    #   # 設定可能な値: 整数。最小値は 12000（デフォルト）。
    #   read_units_per_second = 12000
    #
    #   # write_units_per_second (Optional)
    #   # 設定内容: 1秒あたりのウォーム書き込みユニットを指定します。
    #   # 設定可能な値: 整数。最小値は 4000（デフォルト）。
    #   write_units_per_second = 4000
    # }
  }

  #-------------------------------------------------------------
  # local_secondary_index ブロック (Optional, Forces new resource)
  #-------------------------------------------------------------
  # 設定内容: ローカルセカンダリインデックス（LSI）を定義します。
  # LSI はテーブルと同じパーティションキーを持ち、異なるソートキーを使用します。
  # 注意: LSI はテーブル作成時にのみ定義可能です。後から追加・削除はできません。
  #       LSI の数はテーブルあたり最大 5 です。

  local_secondary_index {
    # name (Required)
    # 設定内容: インデックスの名前を指定します。
    name = "LocalIndex"

    # range_key (Required)
    # 設定内容: LSI のソートキーとして使用する属性名を指定します。
    # 注意: attribute ブロックで定義されている必要があります。
    range_key = "TopScore"

    # projection_type (Required)
    # 設定内容: インデックスに射影する属性のセットを指定します。
    # 設定可能な値:
    #   - "ALL": すべての属性をインデックスに射影
    #   - "KEYS_ONLY": テーブルとインデックスのキー属性のみ射影
    #   - "INCLUDE": non_key_attributes で指定した属性とキー属性を射影
    projection_type = "KEYS_ONLY"

    # non_key_attributes (Optional)
    # 設定内容: インデックスに射影する非キー属性のリストを指定します。
    # 注意: projection_type が "INCLUDE" の場合のみ必要です。
    non_key_attributes = null
  }

  #-------------------------------------------------------------
  # on_demand_throughput ブロック (Optional)
  #-------------------------------------------------------------
  # 設定内容: オンデマンドモードでのテーブルの最大スループットを設定します。
  # 関連機能: オンデマンドキャパシティモード使用時のスループット上限設定

  # on_demand_throughput {
  #   # max_read_request_units (Optional)
  #   # 設定内容: 最大読み取りリクエストユニットを指定します。
  #   # 設定可能な値: 1以上の整数。削除する場合は -1 を指定。
  #   max_read_request_units = 100
  #
  #   # max_write_request_units (Optional)
  #   # 設定内容: 最大書き込みリクエストユニットを指定します。
  #   # 設定可能な値: 1以上の整数。削除する場合は -1 を指定。
  #   max_write_request_units = 100
  # }

  #-------------------------------------------------------------
  # warm_throughput ブロック (Optional)
  #-------------------------------------------------------------
  # 設定内容: テーブルのウォームスループットを設定します。
  # 関連機能: Warm Throughput
  #   テーブルやインデックスが瞬時にサポートできる読み書き操作数を設定します。

  # warm_throughput {
  #   # read_units_per_second (Optional)
  #   # 設定内容: 1秒あたりのウォーム読み取りユニットを指定します。
  #   # 設定可能な値: 整数。最小値は 12000（デフォルト）。
  #   # 注意: ベーステーブルの場合、この値を減少させるとリソースが再作成されます。
  #   read_units_per_second = 12000
  #
  #   # write_units_per_second (Optional)
  #   # 設定内容: 1秒あたりのウォーム書き込みユニットを指定します。
  #   # 設定可能な値: 整数。最小値は 4000（デフォルト）。
  #   # 注意: ベーステーブルの場合、この値を減少させるとリソースが再作成されます。
  #   write_units_per_second = 4000
  # }

  #-------------------------------------------------------------
  # ttl ブロック (Optional)
  #-------------------------------------------------------------
  # 設定内容: Time to Live (TTL) を設定します。
  # 関連機能: DynamoDB TTL
  #   指定した時刻を過ぎたアイテムを自動的に削除します。
  #   https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/TTL.html

  ttl {
    # attribute_name (Optional)
    # 設定内容: TTL タイムスタンプを格納する属性名を指定します。
    # 注意: enabled が true の場合は必須です。
    #       属性の値は Unix エポック時間（秒）の数値である必要があります。
    attribute_name = "TimeToExist"

    # enabled (Optional)
    # 設定内容: TTL を有効にするかを指定します。
    # 設定可能な値:
    #   - true: TTL を有効化
    #   - false (デフォルト): TTL を無効化
    enabled = true
  }

  #-------------------------------------------------------------
  # point_in_time_recovery ブロック (Optional)
  #-------------------------------------------------------------
  # 設定内容: Point-in-Time Recovery (PITR) を設定します。
  # 関連機能: DynamoDB Point-in-Time Recovery
  #   継続的なバックアップを自動的に作成し、任意の時点に復元できます。
  #   https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/PointInTimeRecovery.html

  point_in_time_recovery {
    # enabled (Required)
    # 設定内容: PITR を有効にするかを指定します。
    # 設定可能な値:
    #   - true: PITR を有効化
    #   - false: PITR を無効化
    # 注意: 新規テーブルで有効化するまで 10 分程度かかる場合があります。
    enabled = true

    # recovery_period_in_days (Optional)
    # 設定内容: 連続バックアップを保持する日数を指定します。
    # 設定可能な値: 整数
    # 省略時: 35 日
    recovery_period_in_days = 35
  }

  #-------------------------------------------------------------
  # server_side_encryption ブロック (Optional)
  #-------------------------------------------------------------
  # 設定内容: サーバーサイド暗号化を設定します。
  # 関連機能: DynamoDB 暗号化
  #   保存時の暗号化設定。AWS 所有キー、AWS マネージドキー、
  #   またはカスタマーマネージドキーを選択できます。
  #   https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/EncryptionAtRest.html

  server_side_encryption {
    # enabled (Required)
    # 設定内容: AWS KMS マネージドキーを使用した暗号化を有効にするかを指定します。
    # 設定可能な値:
    #   - true: KMS マネージドキー（デフォルトまたはカスタム CMK）を使用
    #   - false: AWS 所有キー（DEFAULT）を使用
    # 注意: false の場合も暗号化は常に有効です（AWS 所有キー使用）。
    enabled = true

    # kms_key_arn (Optional)
    # 設定内容: 暗号化に使用する KMS CMK の ARN を指定します。
    # 省略時: AWS マネージド DynamoDB キー (alias/aws/dynamodb) を使用
    # 注意: デフォルトキーの ARN は terraform state には含まれません。
    kms_key_arn = null
  }

  #-------------------------------------------------------------
  # replica ブロック (Optional)
  #-------------------------------------------------------------
  # 設定内容: DynamoDB Global Tables V2 (version 2019.11.21) のレプリカを設定します。
  # 関連機能: DynamoDB Global Tables
  #   マルチリージョンでの自動レプリケーションを提供します。
  #   https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/GlobalTables.html
  # 注意: レプリカを使用する場合、stream_enabled = true かつ
  #       stream_view_type = "NEW_AND_OLD_IMAGES" が推奨されます。
  #       aws_dynamodb_table_replica リソースと併用する場合は
  #       lifecycle ignore_changes に replica を追加してください。

  # replica {
  #   # region_name (Required)
  #   # 設定内容: レプリカを作成するリージョン名を指定します。
  #   region_name = "us-east-2"
  #
  #   # kms_key_arn (Optional)
  #   # 設定内容: レプリカの暗号化に使用する KMS CMK の ARN を指定します。
  #   # 注意: この値を変更するとレプリカが再作成されます。
  #   kms_key_arn = null
  #
  #   # point_in_time_recovery (Optional)
  #   # 設定内容: レプリカの PITR を有効にするかを指定します。
  #   # 設定可能な値:
  #   #   - true: PITR を有効化
  #   #   - false (デフォルト): PITR を無効化
  #   point_in_time_recovery = false
  #
  #   # deletion_protection_enabled (Optional)
  #   # 設定内容: レプリカの削除保護を有効にするかを指定します。
  #   # 設定可能な値:
  #   #   - true: 削除保護を有効化
  #   #   - false (デフォルト): 削除保護を無効化
  #   deletion_protection_enabled = false
  #
  #   # propagate_tags (Optional)
  #   # 設定内容: グローバルテーブルのタグをレプリカに伝播するかを指定します。
  #   # 設定可能な値:
  #   #   - true: タグを伝播
  #   #   - false (デフォルト): タグを伝播しない
  #   # 注意: true から false に変更しても、既存のタグは削除されません。
  #   propagate_tags = false
  #
  #   # consistency_mode (Optional)
  #   # 設定内容: グローバルテーブルの整合性モードを指定します。
  #   # 設定可能な値:
  #   #   - "EVENTUAL" (デフォルト): 結果整合性モード
  #   #   - "STRONG": 強整合性モード（Multi-Region Strong Consistency）
  #   # 注意: STRONG を使用する場合、3 つのレプリカまたは 2 レプリカ + witness が必要。
  #   consistency_mode = "EVENTUAL"
  # }

  #-------------------------------------------------------------
  # global_table_witness ブロック (Optional)
  #-------------------------------------------------------------
  # 設定内容: Multi-Region Strong Consistency (MRSC) デプロイメントの
  #           ウィットネスリージョンを設定します。
  # 注意: 1 つの replica ブロック（consistency_mode = "STRONG"）と
  #       組み合わせて使用する必要があります。
  #       他の組み合わせではプロビジョニングに失敗します。

  # global_table_witness {
  #   # region_name (Optional)
  #   # 設定内容: MRSC グローバルテーブルのウィットネスとして機能する
  #   #           AWS リージョン名を指定します。
  #   region_name = "us-west-2"
  # }

  #-------------------------------------------------------------
  # import_table ブロック (Optional)
  #-------------------------------------------------------------
  # 設定内容: Amazon S3 からデータをインポートして新規テーブルを作成します。
  # 関連機能: DynamoDB Import from S3
  #   https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/S3DataImport.HowItWorks.html

  # import_table {
  #   # input_format (Required)
  #   # 設定内容: ソースデータの形式を指定します。
  #   # 設定可能な値:
  #   #   - "CSV": CSV 形式
  #   #   - "DYNAMODB_JSON": DynamoDB JSON 形式
  #   #   - "ION": Amazon Ion 形式
  #   input_format = "CSV"
  #
  #   # input_compression_type (Optional)
  #   # 設定内容: 入力データの圧縮タイプを指定します。
  #   # 設定可能な値:
  #   #   - "GZIP": GZIP 圧縮
  #   #   - "ZSTD": Zstandard 圧縮
  #   #   - "NONE": 圧縮なし
  #   input_compression_type = "NONE"
  #
  #   # s3_bucket_source (Required)
  #   # 設定内容: インポート元の S3 バケット情報を指定します。
  #   s3_bucket_source {
  #     # bucket (Required)
  #     # 設定内容: インポート元の S3 バケット名を指定します。
  #     bucket = "my-import-bucket"
  #
  #     # bucket_owner (Optional)
  #     # 設定内容: S3 バケットの所有者アカウント ID を指定します。
  #     bucket_owner = null
  #
  #     # key_prefix (Optional)
  #     # 設定内容: インポート対象 S3 オブジェクトの共通キープレフィックスを指定します。
  #     key_prefix = "data/"
  #   }
  #
  #   # input_format_options (Optional)
  #   # 設定内容: インポートデータの形式オプションを指定します。
  #   input_format_options {
  #     csv {
  #       # delimiter (Optional)
  #       # 設定内容: CSV ファイルの区切り文字を指定します。
  #       delimiter = ","
  #
  #       # header_list (Optional)
  #       # 設定内容: CSV ファイルのヘッダーリストを指定します。
  #       # 注意: すべてのソース CSV ファイルに共通のヘッダーを指定する場合に使用します。
  #       header_list = ["UserId", "GameTitle", "TopScore"]
  #     }
  #   }
  # }

  #-------------------------------------------------------------
  # timeouts ブロック (Optional)
  #-------------------------------------------------------------
  # 設定内容: リソース操作のタイムアウト値を指定します。

  timeouts {
    # create (Optional)
    # 設定内容: 作成操作のタイムアウトを指定します。
    # 設定可能な値: "30m" などの duration 文字列
    create = "30m"

    # update (Optional)
    # 設定内容: 更新操作のタイムアウトを指定します。
    # 設定可能な値: "60m" などの duration 文字列
    update = "60m"

    # delete (Optional)
    # 設定内容: 削除操作のタイムアウトを指定します。
    # 設定可能な値: "10m" などの duration 文字列
    delete = "10m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: テーブルの Amazon Resource Name (ARN)
# - id: テーブル名（name と同じ値）
# - stream_arn: Table Stream の ARN（stream_enabled = true の場合のみ）
# - stream_label: ストリームのタイムスタンプ（ISO 8601 形式）
#                 stream_enabled = true の場合のみ利用可能
# - tags_all: default_tags を含む全タグのマップ
# - replica.*.arn: レプリカの ARN
# - replica.*.stream_arn: レプリカの Table Stream の ARN
# - replica.*.stream_label: レプリカのストリームのタイムスタンプ
#
#---------------------------------------------------------------
