#---------------------------------------------------------------
# AWS Glue Crawler
#---------------------------------------------------------------
#
# AWS Glue Crawlerをプロビジョニングするリソースです。
# クローラーはデータストアに接続してスキーマを検出し、
# AWS Glueデータカタログにデータベースとテーブル定義を自動作成・更新します。
# S3、DynamoDB、JDBC（RDS等）、MongoDB、Delta Lake、Iceberg、Hudiなど
# 多様なデータソースに対応しています。
#
# AWS公式ドキュメント:
#   - AWS Glue Crawlerの概要: https://docs.aws.amazon.com/glue/latest/dg/add-crawler.html
#   - クローラーの設定: https://docs.aws.amazon.com/glue/latest/dg/define-crawler.html
#   - サポートデータソース: https://docs.aws.amazon.com/glue/latest/dg/crawler-data-stores.html
#   - クローラー動作のカスタマイズ: https://docs.aws.amazon.com/glue/latest/dg/crawler-configuration.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/glue_crawler
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_glue_crawler" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: クローラーの一意な名前を指定します。
  # 設定可能な値: 英数字、ハイフン、アンダースコアを含む文字列
  name = "example-crawler"

  # database_name (Required)
  # 設定内容: クローラーが検出したメタデータを書き込むGlueデータカタログのデータベース名を指定します。
  # 設定可能な値: 既存のGlueデータカタログデータベース名
  database_name = "example_database"

  # role (Required)
  # 設定内容: クローラーがデータストアにアクセスするために使用するIAMロールのARNまたは名前を指定します。
  # 設定可能な値: 有効なIAMロールARNまたはロール名
  # 参考: https://docs.aws.amazon.com/glue/latest/dg/crawler-prereqs.html
  role = "arn:aws:iam::123456789012:role/AWSGlueServiceRole-example"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # 説明・分類子設定
  #-------------------------------------------------------------

  # description (Optional)
  # 設定内容: クローラーの説明文を指定します。
  # 設定可能な値: 任意の文字列
  # 省略時: 説明なし
  description = "Example Glue Crawler"

  # classifiers (Optional)
  # 設定内容: クローラーがデータフォーマットを識別するために使用するカスタム分類子のリストを指定します。
  # 設定可能な値: 既存のGlue分類子名のリスト
  # 省略時: Glueの組み込み分類子（CSV、JSON、Avro、Parquet、ORC等）を使用
  # 参考: https://docs.aws.amazon.com/glue/latest/dg/add-classifier.html
  classifiers = []

  #-------------------------------------------------------------
  # スケジュール設定
  #-------------------------------------------------------------

  # schedule (Optional)
  # 設定内容: クローラーを定期実行するためのcron式を指定します。
  # 設定可能な値: cron形式の文字列（例: "cron(0 1 * * ? *)" で毎日午前1時に実行）
  # 省略時: スケジュールなし（手動実行のみ）
  # 参考: https://docs.aws.amazon.com/glue/latest/dg/schedule-crawler.html
  schedule = "cron(0 1 * * ? *)"

  #-------------------------------------------------------------
  # テーブルプレフィックス設定
  #-------------------------------------------------------------

  # table_prefix (Optional)
  # 設定内容: クローラーがデータカタログに作成するテーブル名に付与するプレフィックスを指定します。
  # 設定可能な値: 任意の文字列
  # 省略時: プレフィックスなし
  table_prefix = null

  #-------------------------------------------------------------
  # セキュリティ設定
  #-------------------------------------------------------------

  # security_configuration (Optional)
  # 設定内容: クローラーが使用するセキュリティ設定の名前を指定します。
  # 設定可能な値: 既存のGlueセキュリティ設定名
  # 省略時: セキュリティ設定なし（暗号化なし）
  # 参考: https://docs.aws.amazon.com/glue/latest/dg/console-security-configurations.html
  security_configuration = null

  #-------------------------------------------------------------
  # クローラー動作設定（JSON）
  #-------------------------------------------------------------

  # configuration (Optional)
  # 設定内容: クローラーのバージョン管理されたJSON設定文字列を指定します。
  # 設定可能な値: 有効なJSON文字列。主な設定項目:
  #   - Version: 設定バージョン（例: 1.0）
  #   - Grouping.TableGroupingPolicy: テーブルグルーピングポリシー
  #     "CombineCompatibleSchemas": 互換スキーマを1テーブルに結合
  #     "UseTableLevelProperties": テーブルレベルプロパティを使用
  #   - CrawlerOutput.Partitions: パーティション処理設定
  # 省略時: デフォルト設定を使用
  # 注意: catalog_target使用時はデフォルトで
  #       {"Grouping":{"TableGroupingPolicy":"CombineCompatibleSchemas"}} が設定されます
  # 参考: https://docs.aws.amazon.com/glue/latest/dg/crawler-configuration.html
  configuration = jsonencode({
    Version = 1.0
    Grouping = {
      TableGroupingPolicy = "CombineCompatibleSchemas"
    }
    CrawlerOutput = {
      Partitions = { AddOrUpdateBehavior = "InheritFromTable" }
    }
  })

  #-------------------------------------------------------------
  # S3ターゲット設定
  #-------------------------------------------------------------

  # s3_target (Optional)
  # 設定内容: クローラーがクロールするAmazon S3パスの設定ブロックです。
  # 注意: dynamodb_target、jdbc_target、s3_target、mongodb_target、catalog_target
  #       のうち少なくとも1つを指定する必要があります。
  # 参考: https://docs.aws.amazon.com/glue/latest/dg/crawler-data-stores.html
  s3_target {

    # path (Required)
    # 設定内容: クロール対象のAmazon S3パスを指定します。
    # 設定可能な値: s3://バケット名/プレフィックス 形式のパス
    path = "s3://example-bucket/data/"

    # connection_name (Optional)
    # 設定内容: VPC内のS3データにアクセスするための接続名を指定します。
    # 設定可能な値: 既存のGlue接続名
    # 省略時: 接続なし（パブリックS3バケットへの直接アクセス）
    connection_name = null

    # exclusions (Optional)
    # 設定内容: クロール対象から除外するglobパターンのリストを指定します。
    # 設定可能な値: globパターン文字列のリスト（例: "**.csv", "temp/**"）
    # 省略時: 除外なし（全ファイルをクロール）
    exclusions = []

    # sample_size (Optional)
    # 設定内容: データセットのサンプリング時に各リーフフォルダでクロールするファイル数を指定します。
    # 設定可能な値: 1から249の整数
    # 省略時: 全ファイルをクロール
    sample_size = null

    # event_queue_arn (Optional)
    # 設定内容: S3通知を受信するSQSキューのARNを指定します。
    # 設定可能な値: 有効なSQSキューARN
    # 省略時: イベントベースのクロールを使用しない
    event_queue_arn = null

    # dlq_event_queue_arn (Optional)
    # 設定内容: デッドレターSQSキューのARNを指定します。
    # 設定可能な値: 有効なSQSキューARN
    # 省略時: デッドレターキューなし
    dlq_event_queue_arn = null
  }

  #-------------------------------------------------------------
  # DynamoDBターゲット設定
  #-------------------------------------------------------------

  # dynamodb_target (Optional)
  # 設定内容: クローラーがクロールするDynamoDBテーブルの設定ブロックです。
  # dynamodb_target {

    # path (Required)
    # 設定内容: クロール対象のDynamoDBテーブル名を指定します。
    # 設定可能な値: 既存のDynamoDBテーブル名
    # path = "example-dynamodb-table"

    # scan_all (Optional)
    # 設定内容: 全レコードをスキャンするか、テーブルから行をサンプリングするかを指定します。
    # 設定可能な値:
    #   - true: 全レコードをスキャン（スループットが低いテーブルでは時間がかかる場合があります）
    #   - false: サンプリング
    # 省略時: true
    # scan_all = true

    # scan_rate (Optional)
    # 設定内容: クローラーが使用する設定済み読み取りキャパシティユニットの割合を指定します。
    # 設定可能な値: null、または0.1から1.5の数値
    # scan_rate = null

  # }

  #-------------------------------------------------------------
  # JDBCターゲット設定
  #-------------------------------------------------------------

  # jdbc_target (Optional)
  # 設定内容: クローラーがクロールするJDBCデータソースの設定ブロックです。
  # jdbc_target {

    # connection_name (Required)
    # 設定内容: JDBCターゲットへの接続に使用するGlue接続の名前を指定します。
    # 設定可能な値: 既存のGlue JDBC接続名
    # connection_name = "example-jdbc-connection"

    # path (Required)
    # 設定内容: JDBCターゲットのパスを指定します（データベース名/%またはデータベース名/テーブル名）。
    # 設定可能な値: "データベース名/%" （データベース内全テーブル）または "データベース名/テーブル名"
    # path = "database-name/%"

    # exclusions (Optional)
    # 設定内容: クロール対象から除外するglobパターンのリストを指定します。
    # 設定可能な値: globパターン文字列のリスト
    # 省略時: 除外なし
    # exclusions = []

    # enable_additional_metadata (Optional)
    # 設定内容: テーブルレスポンスで追加メタデータを有効にするかを指定します。
    # 設定可能な値:
    #   - "RAWTYPES": ネイティブレベルのデータ型を提供
    #   - "COMMENTS": 列やテーブルに関連するコメントを提供
    # 省略時: 追加メタデータなし
    # enable_additional_metadata = []

  # }

  #-------------------------------------------------------------
  # MongoDBターゲット設定
  #-------------------------------------------------------------

  # mongodb_target (Optional)
  # 設定内容: クローラーがクロールするAmazon DocumentDBまたはMongoDBターゲットの設定ブロックです。
  # mongodb_target {

    # connection_name (Required)
    # 設定内容: Amazon DocumentDBまたはMongoDBターゲットへの接続に使用するGlue接続の名前を指定します。
    # 設定可能な値: 既存のGlue MongoDB接続名
    # connection_name = "example-mongodb-connection"

    # path (Required)
    # 設定内容: Amazon DocumentDBまたはMongoDBターゲットのパスを指定します（データベース名/コレクション名）。
    # 設定可能な値: "データベース名/%" （データベース内全コレクション）または "データベース名/コレクション名"
    # path = "database-name/%"

    # scan_all (Optional)
    # 設定内容: 全レコードをスキャンするか、テーブルから行をサンプリングするかを指定します。
    # 設定可能な値:
    #   - true: 全レコードをスキャン
    #   - false: サンプリング
    # 省略時: true
    # scan_all = true

  # }

  #-------------------------------------------------------------
  # カタログターゲット設定
  #-------------------------------------------------------------

  # catalog_target (Optional)
  # 設定内容: クローラーがクロールするGlueデータカタログテーブルの設定ブロックです。
  # 注意: catalog_target使用時、schema_change_policyのdelete_behaviorは
  #       "DEPRECATE_IN_DATABASE"をサポートしません。
  # catalog_target {

    # database_name (Required)
    # 設定内容: 同期するGlueデータベースの名前を指定します。
    # 設定可能な値: 既存のGlueデータベース名
    # database_name = "example-catalog-database"

    # tables (Required)
    # 設定内容: 同期するカタログテーブルのリストを指定します。
    # 設定可能な値: 既存のGlueカタログテーブル名のリスト
    # tables = ["example-table"]

    # connection_name (Optional)
    # 設定内容: NETWORKコネクションタイプと組み合わせてS3バックアップのデータカタログテーブルを
    #           ターゲットにする場合の接続名を指定します。
    # 設定可能な値: 既存のGlue接続名
    # 省略時: 接続なし
    # connection_name = null

    # event_queue_arn (Optional)
    # 設定内容: 有効なAmazon SQS ARNを指定します。
    # 設定可能な値: 有効なSQSキューARN
    # 省略時: イベントベースのクロールを使用しない
    # event_queue_arn = null

    # dlq_event_queue_arn (Optional)
    # 設定内容: 有効なAmazon SQS ARNを指定します（デッドレターキュー）。
    # 設定可能な値: 有効なSQSキューARN
    # 省略時: デッドレターキューなし
    # dlq_event_queue_arn = null

  # }

  #-------------------------------------------------------------
  # Delta Lakeターゲット設定
  #-------------------------------------------------------------

  # delta_target (Optional)
  # 設定内容: クローラーがクロールするDelta Lakeテーブルの設定ブロックです。
  # delta_target {

    # delta_tables (Required)
    # 設定内容: Delta Lakeテーブルへの Amazon S3 パスのリストを指定します。
    # 設定可能な値: s3://バケット名/プレフィックス 形式のパスのセット
    # delta_tables = ["s3://example-bucket/delta-tables/"]

    # write_manifest (Required)
    # 設定内容: Delta Lakeテーブルパスにマニフェストファイルを書き込むかを指定します。
    # 設定可能な値:
    #   - true: マニフェストファイルを書き込む
    #   - false: マニフェストファイルを書き込まない
    # write_manifest = false

    # connection_name (Optional)
    # 設定内容: Delta Lakeターゲットへの接続に使用するGlue接続の名前を指定します。
    # 設定可能な値: 既存のGlue接続名
    # 省略時: 接続なし
    # connection_name = null

    # create_native_delta_table (Optional)
    # 設定内容: ネイティブDelta Lakeテーブルを作成するかを指定します。
    # 設定可能な値:
    #   - true: ネイティブDelta Lakeテーブルを作成
    #   - false: シンクテーブルを作成
    # create_native_delta_table = false

  # }

  #-------------------------------------------------------------
  # Apache Icebergターゲット設定
  #-------------------------------------------------------------

  # iceberg_target (Optional)
  # 設定内容: クローラーがクロールするApache Icebergテーブルの設定ブロックです。
  # iceberg_target {

    # paths (Required)
    # 設定内容: Icebergメタデータフォルダを含むAmazon S3パスのセットを指定します。
    # 設定可能な値: s3://バケット名/プレフィックス 形式のパスのセット
    # paths = ["s3://example-bucket/iceberg-tables/"]

    # maximum_traversal_depth (Required)
    # 設定内容: クローラーがIcebergメタデータフォルダを探索するための最大深度を指定します。
    # 設定可能な値: 1から20の整数
    # maximum_traversal_depth = 10

    # connection_name (Optional)
    # 設定内容: Icebergターゲットへの接続に使用するGlue接続の名前を指定します。
    # 設定可能な値: 既存のGlue接続名
    # 省略時: 接続なし
    # connection_name = null

    # exclusions (Optional)
    # 設定内容: クロール対象から除外するglobパターンのリストを指定します。
    # 設定可能な値: globパターン文字列のリスト
    # 省略時: 除外なし
    # exclusions = []

  # }

  #-------------------------------------------------------------
  # Apache Hudiターゲット設定
  #-------------------------------------------------------------

  # hudi_target (Optional)
  # 設定内容: クローラーがクロールするApache Hudiテーブルの設定ブロックです。
  # hudi_target {

    # paths (Required)
    # 設定内容: Hudiメタデータフォルダを含むAmazon S3パスのセットを指定します。
    # 設定可能な値: s3://バケット名/プレフィックス 形式のパスのセット
    # paths = ["s3://example-bucket/hudi-tables/"]

    # maximum_traversal_depth (Required)
    # 設定内容: クローラーがHudiメタデータフォルダを探索するための最大深度を指定します。
    # 設定可能な値: 1から20の整数
    # maximum_traversal_depth = 10

    # connection_name (Optional)
    # 設定内容: Hudiターゲットへの接続に使用するGlue接続の名前を指定します。
    # 設定可能な値: 既存のGlue接続名
    # 省略時: 接続なし
    # connection_name = null

    # exclusions (Optional)
    # 設定内容: クロール対象から除外するglobパターンのリストを指定します。
    # 設定可能な値: globパターン文字列のリスト
    # 省略時: 除外なし
    # exclusions = []

  # }

  #-------------------------------------------------------------
  # スキーマ変更ポリシー設定
  #-------------------------------------------------------------

  # schema_change_policy (Optional)
  # 設定内容: クローラーがスキーマの変更や削除されたオブジェクトを検出した際の動作を設定するブロックです。
  # 参考: https://docs.aws.amazon.com/glue/latest/dg/crawler-configuration.html
  schema_change_policy {

    # delete_behavior (Optional)
    # 設定内容: クローラーが削除されたオブジェクトを検出したときの動作を指定します。
    # 設定可能な値:
    #   - "LOG": ログに記録するのみ（テーブルを削除しない）
    #   - "DELETE_FROM_DATABASE": データカタログからテーブルを削除
    #   - "DEPRECATE_IN_DATABASE": テーブルを非推奨としてマーク（catalog_targetでは使用不可）
    # 省略時: "DEPRECATE_IN_DATABASE"
    delete_behavior = "LOG"

    # update_behavior (Optional)
    # 設定内容: クローラーが変更されたスキーマを検出したときの動作を指定します。
    # 設定可能な値:
    #   - "LOG": ログに記録するのみ（スキーマを更新しない）
    #   - "UPDATE_IN_DATABASE": データカタログのスキーマを更新
    # 省略時: "UPDATE_IN_DATABASE"
    update_behavior = "UPDATE_IN_DATABASE"
  }

  #-------------------------------------------------------------
  # 再クロールポリシー設定
  #-------------------------------------------------------------

  # recrawl_policy (Optional)
  # 設定内容: クローラーの再クロール動作を設定するブロックです。
  # 参考: https://docs.aws.amazon.com/glue/latest/dg/crawler-configuration.html
  recrawl_policy {

    # recrawl_behavior (Optional)
    # 設定内容: データセット全体を再クロールするか、前回のクロール以降に追加されたフォルダのみ
    #           クロールするか、またはSQS経由でS3からクローラーに通知された内容のみクロールするかを指定します。
    # 設定可能な値:
    #   - "CRAWL_EVERYTHING": データセット全体を再クロール（デフォルト）
    #   - "CRAWL_NEW_FOLDERS_ONLY": 前回のクロール以降に追加されたフォルダのみクロール
    #   - "CRAWL_EVENT_MODE": SQSがクローラーに通知した内容のみクロール
    # 省略時: "CRAWL_EVERYTHING"
    recrawl_behavior = "CRAWL_EVERYTHING"
  }

  #-------------------------------------------------------------
  # Lake Formation設定
  #-------------------------------------------------------------

  # lake_formation_configuration (Optional)
  # 設定内容: Lake Formationの認証情報設定ブロックです。
  # 参考: https://docs.aws.amazon.com/glue/latest/dg/crawler-configuration.html
  lake_formation_configuration {

    # account_id (Optional)
    # 設定内容: クロスアカウントクロールに必要なアカウントIDを指定します。
    # 設定可能な値: 12桁のAWSアカウントID
    # 省略時: 同一アカウントのクロールでは省略可能（Terraformが自動設定）
    account_id = null

    # use_lake_formation_credentials (Optional)
    # 設定内容: IAMロールの認証情報の代わりにLake Formationの認証情報を使用するかを指定します。
    # 設定可能な値:
    #   - true: Lake Formationの認証情報を使用
    #   - false: IAMロールの認証情報を使用
    # 省略時: false
    use_lake_formation_credentials = false
  }

  #-------------------------------------------------------------
  # データ系譜設定
  #-------------------------------------------------------------

  # lineage_configuration (Optional)
  # 設定内容: クローラーのデータ系譜（リネージュ）設定ブロックです。
  lineage_configuration {

    # crawler_lineage_settings (Optional)
    # 設定内容: クローラーのデータ系譜を有効にするかを指定します。
    # 設定可能な値:
    #   - "ENABLE": データ系譜を有効化
    #   - "DISABLE": データ系譜を無効化
    # 省略時: "DISABLE"
    crawler_lineage_settings = "DISABLE"
  }

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 参考: プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #       一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "example-crawler"
    Environment = "production"
    ManagedBy   = "terraform"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: クローラーのAmazon Resource Name (ARN)
# - id: クローラー名（nameと同一）
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
