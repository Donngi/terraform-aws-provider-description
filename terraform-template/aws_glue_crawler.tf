#---------------------------------------------------------------
# AWS Glue Crawler
#---------------------------------------------------------------
#
# AWS Glue Data Catalogにデータベースとテーブルをプロビジョニングするための
# クローラーリソースです。クローラーはS3、JDBC、DynamoDB、MongoDB、Hudi、
# Iceberg、Delta Lake、カタログテーブルなどの複数のデータソースをスキャンし、
# スキーマを自動的に推測してData Catalogに登録します。
#
# AWS公式ドキュメント:
#   - Using crawlers to populate the Data Catalog: https://docs.aws.amazon.com/glue/latest/dg/add-crawler.html
#   - Configuring a crawler: https://docs.aws.amazon.com/glue/latest/dg/define-crawler.html
#   - Crawlers and classifiers API: https://docs.aws.amazon.com/glue/latest/dg/aws-glue-api-crawler.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/glue_crawler
#
# Provider Version: 6.28.0
# Generated: 2026-01-27
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_glue_crawler" "example" {
  #---------------------------------------------------------------
  # 必須パラメータ
  #---------------------------------------------------------------

  # クローラー名
  # 英数字とアンダースコアのみ使用可能。最大128文字。
  name = "example-crawler"

  # クローラーが使用するIAMロールのARN
  # データストアへのアクセス権限とData Catalogへの書き込み権限が必要。
  role = "arn:aws:iam::123456789012:role/AWSGlueServiceRole"

  # クローラーが書き込むGlue Data Catalogデータベース名
  # 事前に作成されている必要があります。
  database_name = "my_database"

  #---------------------------------------------------------------
  # オプションパラメータ
  #---------------------------------------------------------------

  # クローラーの説明
  description = "Example crawler for data discovery"

  # クローラーのスケジュール（cron形式）
  # 例: "cron(0 1 * * ? *)" は毎日午前1時に実行
  # 例: "cron(0/15 * * * ? *)" は15分ごとに実行
  schedule = null

  # カスタム分類器のリスト
  # クローラーがデータのスキーマを推測する際に使用する分類器の名前を指定。
  # ビルトイン分類器の前に実行されます。
  classifiers = []

  # クローラーの設定（JSON形式）
  # TableGroupingPolicy（CombineCompatibleSchemas等）、
  # Partitions設定、Grouping設定などを指定可能。
  # 例: jsonencode({ Version = 1, Grouping = { TableGroupingPolicy = "CombineCompatibleSchemas" } })
  configuration = null

  # テーブル名のプレフィックス
  # クローラーが作成するテーブル名の先頭に付与されます。最大64文字。
  table_prefix = null

  # セキュリティ設定名
  # 暗号化設定を含むGlueセキュリティ設定の名前を指定。
  security_configuration = null

  # リソースタグ
  # Key-Valueペアでリソースにタグを付与します。
  tags = {
    Environment = "production"
    Project     = "data-lake"
  }

  # リージョン指定
  # このリソースを管理するAWSリージョン。
  # 未指定の場合はプロバイダー設定のリージョンが使用されます。
  region = null

  #---------------------------------------------------------------
  # データソース設定（少なくとも1つ必須）
  #---------------------------------------------------------------
  # 注意: dynamodb_target, jdbc_target, s3_target, mongodb_target,
  #       catalog_target, hudi_target, iceberg_target, delta_target
  #       のいずれか少なくとも1つを指定する必要があります。

  #---------------------------------------------------------------
  # S3ターゲット
  #---------------------------------------------------------------
  # Amazon S3バケット内のデータをクロールします。
  # 最も一般的に使用されるデータソースです。

  s3_target {
    # S3パス（必須）
    # クロール対象のS3バケットパス。例: s3://bucket-name/prefix/
    path = "s3://my-data-bucket/data/"

    # VPC内のS3データにアクセスするための接続名（オプション）
    connection_name = null

    # 除外パターンのリスト（オプション）
    # Globパターンでクロール対象から除外するパスを指定。
    # 例: ["**.tmp", "**_backup/**"]
    exclusions = []

    # サンプルサイズ（オプション）
    # 各リーフフォルダでクロールするファイル数。1〜249の整数。
    # 未設定の場合は全ファイルをクロールします。
    sample_size = null

    # S3通知用SQS ARN（オプション）
    # EventBridgeやS3イベント通知と連携してイベント駆動クロールを実現。
    event_queue_arn = null

    # デッドレターキューSQS ARN（オプション）
    # イベント処理に失敗した場合のDLQ。
    dlq_event_queue_arn = null
  }

  #---------------------------------------------------------------
  # DynamoDBターゲット
  #---------------------------------------------------------------
  # Amazon DynamoDBテーブルをクロールします。

  # dynamodb_target {
  #   # DynamoDBテーブル名（必須）
  #   path = "my-dynamodb-table"
  #
  #   # 全レコードをスキャンするか（オプション）
  #   # true: 全レコードをスキャン（低スループットテーブルでは時間がかかる）
  #   # false: サンプルレコードをスキャン
  #   # デフォルト: true
  #   scan_all = true
  #
  #   # スキャンレート（オプション）
  #   # 設定された読み取りキャパシティユニットの使用率（0.1〜1.5）
  #   # 例: 0.5 = 50%のキャパシティを使用
  #   scan_rate = null
  # }

  #---------------------------------------------------------------
  # JDBCターゲット
  #---------------------------------------------------------------
  # JDBC接続経由でリレーショナルデータベースをクロールします。

  # jdbc_target {
  #   # JDBC接続名（必須）
  #   # 事前に作成されたGlue接続の名前。
  #   connection_name = "my-jdbc-connection"
  #
  #   # JDBCパス（必須）
  #   # データベース名とテーブルパターン。例: "database-name/%"（全テーブル）
  #   path = "my_database/%"
  #
  #   # 除外パターン（オプション）
  #   # クロール対象から除外するテーブルパターン。
  #   exclusions = []
  #
  #   # 追加メタデータの有効化（オプション）
  #   # "RAWTYPES": ネイティブレベルのデータ型を取得
  #   # "COMMENTS": カラムやテーブルのコメントを取得
  #   enable_additional_metadata = []
  # }

  #---------------------------------------------------------------
  # MongoDBターゲット
  #---------------------------------------------------------------
  # MongoDB / Amazon DocumentDBをクロールします。

  # mongodb_target {
  #   # MongoDB接続名（必須）
  #   connection_name = "my-mongodb-connection"
  #
  #   # MongoDBパス（必須）
  #   # データベース名とコレクションパターン。例: "database-name/%"
  #   path = "my_mongodb_database/%"
  #
  #   # 全ドキュメントをスキャンするか（オプション）
  #   # デフォルト: true
  #   scan_all = true
  # }

  #---------------------------------------------------------------
  # カタログターゲット
  #---------------------------------------------------------------
  # 既存のGlue Data Catalogテーブルをクロールして同期します。

  # catalog_target {
  #   # データベース名（必須）
  #   # 同期対象のGlueデータベース名
  #   database_name = "source_database"
  #
  #   # テーブルリスト（必須）
  #   # 同期対象のテーブル名リスト
  #   tables = ["table1", "table2"]
  #
  #   # S3カタログテーブル用の接続名（オプション）
  #   # NETWORK接続タイプと組み合わせてVPC内のS3データにアクセス
  #   connection_name = null
  #
  #   # イベントキューARN（オプション）
  #   # 有効なAmazon SQS ARN
  #   event_queue_arn = null
  #
  #   # デッドレターキューARN（オプション）
  #   dlq_event_queue_arn = null
  # }
  #
  # 注意: catalog_targetのdelete_behaviorは"DEPRECATE_IN_DATABASE"をサポートしません。
  # 注意: catalog_target用のconfigurationはデフォルトで
  #       { "Grouping": { "TableGroupingPolicy": "CombineCompatibleSchemas" } } が設定されます。

  #---------------------------------------------------------------
  # Hudiターゲット
  #---------------------------------------------------------------
  # Apache Hudiテーブルをクロールします。

  # hudi_target {
  #   # Hudiメタデータフォルダを含むS3パス（必須）
  #   # 例: ["s3://bucket/hudi-table-path"]
  #   paths = ["s3://my-bucket/hudi/"]
  #
  #   # Hudi接続名（オプション）
  #   connection_name = null
  #
  #   # 除外パターン（オプション）
  #   exclusions = []
  #
  #   # 最大トラバース深度（必須）
  #   # S3パス内でHudiメタデータフォルダを検索する最大深度（1〜20）
  #   maximum_traversal_depth = 3
  # }

  #---------------------------------------------------------------
  # Icebergターゲット
  #---------------------------------------------------------------
  # Apache Icebergテーブルをクロールします。

  # iceberg_target {
  #   # Icebergメタデータフォルダを含むS3パス（必須）
  #   paths = ["s3://my-bucket/iceberg/"]
  #
  #   # Iceberg接続名（オプション）
  #   connection_name = null
  #
  #   # 除外パターン（オプション）
  #   exclusions = []
  #
  #   # 最大トラバース深度（必須）
  #   # 1〜20の整数
  #   maximum_traversal_depth = 3
  # }

  #---------------------------------------------------------------
  # Deltaターゲット
  #---------------------------------------------------------------
  # Delta Lakeテーブルをクロールします。

  # delta_target {
  #   # Deltaテーブルへのパスリスト（必須）
  #   delta_tables = ["s3://my-bucket/delta-table/"]
  #
  #   # マニフェストファイルを書き込むか（必須）
  #   # Deltaテーブルパスにマニフェストファイルを書き込むかどうか
  #   write_manifest = true
  #
  #   # Delta接続名（オプション）
  #   connection_name = null
  #
  #   # ネイティブDeltaテーブルを作成するか（オプション）
  #   create_native_delta_table = null
  # }

  #---------------------------------------------------------------
  # スキーマ変更ポリシー
  #---------------------------------------------------------------
  # クローラーがスキーマ変更を検出した際の動作を制御します。

  schema_change_policy {
    # 削除動作（オプション）
    # クローラーが削除されたオブジェクトを検出した際の動作
    # - "LOG": ログに記録するのみ
    # - "DELETE_FROM_DATABASE": Data Catalogから削除
    # - "DEPRECATE_IN_DATABASE": 非推奨としてマーク（デフォルト）
    delete_behavior = "DEPRECATE_IN_DATABASE"

    # 更新動作（オプション）
    # スキーマ変更を検出した際の動作
    # - "LOG": ログに記録するのみ
    # - "UPDATE_IN_DATABASE": Data Catalogを更新（デフォルト）
    update_behavior = "UPDATE_IN_DATABASE"
  }

  #---------------------------------------------------------------
  # Lake Formation設定
  #---------------------------------------------------------------
  # AWS Lake Formation統合設定

  # lake_formation_configuration {
  #   # アカウントID（オプション）
  #   # クロスアカウントクロールの場合は必須。
  #   # 同一アカウント内のクロールの場合は省略可能。
  #   account_id = null
  #
  #   # Lake Formation認証情報を使用するか（オプション）
  #   # true: IAMロールの代わりにLake Formation認証情報を使用
  #   use_lake_formation_credentials = false
  # }

  #---------------------------------------------------------------
  # リネージュ設定
  #---------------------------------------------------------------
  # データリネージュ（系譜）トラッキングの設定

  # lineage_configuration {
  #   # クローラーリネージュ設定（オプション）
  #   # - "ENABLE": データリネージュを有効化
  #   # - "DISABLE": データリネージュを無効化（デフォルト）
  #   crawler_lineage_settings = "DISABLE"
  # }

  #---------------------------------------------------------------
  # 再クロールポリシー
  #---------------------------------------------------------------
  # クローラーの再実行動作を制御します。

  # recrawl_policy {
  #   # 再クロール動作（オプション）
  #   # - "CRAWL_EVERYTHING": 全データセットを再クロール（デフォルト）
  #   # - "CRAWL_NEW_FOLDERS_ONLY": 前回実行後に追加されたフォルダのみクロール
  #   # - "CRAWL_EVENT_MODE": SQS経由でS3が通知した内容のみクロール
  #   recrawl_behavior = "CRAWL_EVERYTHING"
  # }
}

#---------------------------------------------------------------
# Attributes Reference（出力専用属性）
#---------------------------------------------------------------
# 以下の属性はリソース作成後に参照可能ですが、入力パラメータとしては
# 使用できません（computed only）。
#
# - id: クローラー名
# - arn: クローラーのARN
# - tags_all: プロバイダーのdefault_tags設定を含む全タグのマップ
#---------------------------------------------------------------
