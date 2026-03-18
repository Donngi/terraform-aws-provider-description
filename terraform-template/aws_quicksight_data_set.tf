#---------------------------------------------------------------
# Amazon QuickSight Data Set
#---------------------------------------------------------------
#
# Amazon QuickSightのデータセットをプロビジョニングするリソースです。
# データセットは、QuickSightで分析やビジュアライゼーションを作成するための
# データソースを定義します。物理テーブル（S3、RDS、Redshift等）からデータを
# 取得し、論理テーブルでデータ変換を適用し、最終的な分析用データを提供します。
#
# AWS公式ドキュメント:
#   - QuickSight データセット: https://docs.aws.amazon.com/quicksight/latest/APIReference/API_DataSet.html
#   - データセット作成: https://docs.aws.amazon.com/quicksight/latest/APIReference/API_CreateDataSet.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/quicksight_data_set
#
# Provider Version: 6.36.0
# Generated: 2026-03-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_quicksight_data_set" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # data_set_id (Required, Forces new resource)
  # 設定内容: データセットの一意の識別子を指定します。
  # 設定可能な値: 文字列（データセットを識別するID）
  # 注意: 作成後の変更不可。変更すると新しいリソースが作成されます。
  data_set_id = "example-dataset-id"

  # name (Required)
  # 設定内容: データセットの表示名を指定します。
  # 設定可能な値: 文字列（QuickSightコンソールに表示される名前）
  name = "example-dataset-name"

  # import_mode (Required)
  # 設定内容: データのインポートモードを指定します。
  # 設定可能な値:
  #   - "SPICE": データをSPICE（Super-fast, Parallel, In-memory Calculation Engine）にインポート
  #   - "DIRECT_QUERY": データソースに直接クエリを実行（SPICEにインポートしない）
  # 関連機能: SPICE
  #   QuickSightのインメモリエンジン。データを高速に処理し、パフォーマンスを向上させます。
  #   DIRECT_QUERYは常に最新データにアクセスしますが、パフォーマンスはデータソースに依存します。
  import_mode = "SPICE"

  # aws_account_id (Optional, Forces new resource)
  # 設定内容: データセットを作成するAWSアカウントIDを指定します。
  # 設定可能な値: 12桁のAWSアカウントID
  # 省略時: Terraform AWSプロバイダーのアカウントIDが自動的に使用されます。
  # 注意: 作成後の変更不可。変更すると新しいリソースが作成されます。
  aws_account_id = null

  # use_as (Optional, Forces new resource)
  # 設定内容: データセットの用途を指定します。
  # 設定可能な値:
  #   - "RLS_RULES": 行レベルセキュリティ（RLS）ルールデータセットとして指定
  # 省略時: 通常のデータセットとして扱われます。
  # 注意: 作成後の変更不可。変更すると新しいリソースが作成されます。
  #        RLS_RULESを指定すると、このデータセットはQuickSightの分析やダッシュボードで
  #        行レベルのアクセス制御に使用されます。
  use_as = null

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
  # 物理テーブル設定
  #-------------------------------------------------------------

  # physical_table_map (Optional)
  # 設定内容: データソースから利用可能な物理テーブルを定義します。
  # 最大項目数: 32
  # 関連機能: Physical Table Map
  #   データの元となる物理テーブル（S3、RDS、カスタムSQL等）を定義します。
  #   複数の物理テーブルを定義し、logical_table_mapで結合や変換が可能です。
  physical_table_map {
    # physical_table_map_id (Required)
    # 設定内容: 物理テーブルマップのキーを指定します。
    # 設定可能な値: 一意の文字列ID
    physical_table_map_id = "example-physical-table-id"

    # s3_source (Optional)
    # 設定内容: S3データソースからデータを読み込む物理テーブルを定義します。
    # 注意: custom_sql、relational_table、s3_sourceのいずれか1つのみ指定可能
    s3_source {
      # data_source_arn (Required)
      # 設定内容: データソースのARNを指定します。
      # 設定可能な値: QuickSight Data SourceのARN
      data_source_arn = "arn:aws:quicksight:ap-northeast-1:123456789012:datasource/example-datasource-id"

      # input_columns (Required)
      # 設定内容: テーブルのカラムスキーマを定義します。
      # 最小項目数: 1
      # 最大項目数: 2048
      input_columns {
        # name (Required)
        # 設定内容: データソース内のカラム名を指定します。
        # 設定可能な値: 文字列
        name = "column1"

        # type (Required)
        # 設定内容: カラムのデータ型を指定します。
        # 設定可能な値: STRING、INTEGER、DECIMAL、DATETIME等
        type = "STRING"
      }

      # upload_settings (Required)
      # 設定内容: S3ソースファイルのフォーマット情報を設定します。
      upload_settings {
        # format (Optional)
        # 設定内容: ファイルフォーマットを指定します。
        # 設定可能な値: CSV、TSV、CLF、ELF、XLSX、JSON
        # 省略時: デフォルト値が使用されます。
        format = "JSON"

        # contains_header (Optional)
        # 設定内容: ファイルにヘッダー行が含まれているかを指定します。
        # 設定可能な値:
        #   - true: ファイルにヘッダー行が含まれる
        #   - false: ファイルにヘッダー行が含まれない
        # 省略時: デフォルト値が使用されます。
        contains_header = null

        # delimiter (Optional)
        # 設定内容: ファイル内の値の区切り文字を指定します。
        # 設定可能な値: カンマ、タブ等の区切り文字
        # 省略時: デフォルト値が使用されます。
        delimiter = null

        # start_from_row (Optional)
        # 設定内容: データの読み込みを開始する行番号を指定します。
        # 設定可能な値: 数値（行番号）
        # 省略時: 先頭行から読み込みます。
        start_from_row = null

        # text_qualifier (Optional)
        # 設定内容: テキスト修飾子を指定します。
        # 設定可能な値: DOUBLE_QUOTE、SINGLE_QUOTE
        # 省略時: デフォルト値が使用されます。
        text_qualifier = null
      }
    }

    # relational_table (Optional)
    # 設定内容: リレーショナルデータソース用の物理テーブルを定義します。
    # 注意: custom_sql、relational_table、s3_sourceのいずれか1つのみ指定可能
    # relational_table {
    #   # data_source_arn (Required)
    #   # 設定内容: データソースのARNを指定します。
    #   # 設定可能な値: QuickSight Data SourceのARN
    #   data_source_arn = "arn:aws:quicksight:ap-northeast-1:123456789012:datasource/example-datasource-id"
    #
    #   # name (Required)
    #   # 設定内容: リレーショナルテーブルの名前を指定します。
    #   # 設定可能な値: 文字列
    #   name = "example-table"
    #
    #   # catalog (Optional)
    #   # 設定内容: テーブルに関連付けられたカタログを指定します。
    #   # 設定可能な値: 文字列
    #   # 省略時: デフォルトのカタログが使用されます。
    #   catalog = null
    #
    #   # schema (Optional)
    #   # 設定内容: スキーマ名を指定します。
    #   # 設定可能な値: 文字列（リレーショナルデータベースエンジンに適用）
    #   # 省略時: デフォルトのスキーマが使用されます。
    #   schema = null
    #
    #   # input_columns (Required)
    #   # 設定内容: テーブルのカラムスキーマを定義します。
    #   # 最小項目数: 1
    #   # 最大項目数: 2048
    #   input_columns {
    #     # name (Required)
    #     # 設定内容: データソース内のカラム名を指定します。
    #     # 設定可能な値: 文字列
    #     name = "column1"
    #
    #     # type (Required)
    #     # 設定内容: カラムのデータ型を指定します。
    #     # 設定可能な値: STRING、INTEGER、DECIMAL、DATETIME等
    #     type = "STRING"
    #   }
    # }

    # custom_sql (Optional)
    # 設定内容: カスタムSQLクエリ結果から構築された物理テーブルを定義します。
    # 注意: custom_sql、relational_table、s3_sourceのいずれか1つのみ指定可能
    # custom_sql {
    #   # data_source_arn (Required)
    #   # 設定内容: データソースのARNを指定します。
    #   # 設定可能な値: QuickSight Data SourceのARN
    #   data_source_arn = "arn:aws:quicksight:ap-northeast-1:123456789012:datasource/example-datasource-id"
    #
    #   # name (Required)
    #   # 設定内容: SQLクエリ結果の表示名を指定します。
    #   # 設定可能な値: 文字列
    #   name = "custom-query-result"
    #
    #   # sql_query (Required)
    #   # 設定内容: 実行するSQLクエリを指定します。
    #   # 設定可能な値: SQL文字列
    #   sql_query = "SELECT * FROM example_table WHERE date > '2024-01-01'"
    #
    #   # columns (Optional)
    #   # 設定内容: SQLクエリ結果セットのカラムスキーマを定義します。
    #   # 最大項目数: 2048
    #   columns {
    #     # name (Required)
    #     # 設定内容: データソース内のカラム名を指定します。
    #     # 設定可能な値: 文字列
    #     name = "column1"
    #
    #     # type (Required)
    #     # 設定内容: カラムのデータ型を指定します。
    #     # 設定可能な値: STRING、INTEGER、DECIMAL、DATETIME等
    #     type = "STRING"
    #   }
    # }
  }

  #-------------------------------------------------------------
  # 論理テーブル設定
  #-------------------------------------------------------------

  # logical_table_map (Optional)
  # 設定内容: 物理テーブルのデータの結合と変換を設定します。
  # 最大項目数: 64
  # 関連機能: Logical Table Map
  #   物理テーブルのデータを結合、フィルタ、変換して最終的な分析用データを作成します。
  #   データ変換操作（キャスト、カラム作成、フィルタ等）を定義できます。
  # logical_table_map {
  #   # logical_table_map_id (Required)
  #   # 設定内容: 論理テーブルマップのキーを指定します。
  #   # 設定可能な値: 一意の文字列ID
  #   logical_table_map_id = "example-logical-table-id"
  #
  #   # alias (Required)
  #   # 設定内容: 論理テーブルの表示名を指定します。
  #   # 設定可能な値: 文字列
  #   alias = "example-logical-table"
  #
  #   # source (Required)
  #   # 設定内容: 論理テーブルのソースを定義します。
  #   source {
  #     # physical_table_id (Optional)
  #     # 設定内容: 物理テーブルIDを指定します。
  #     # 設定可能な値: physical_table_mapで定義したID
  #     # 省略時: デフォルト値が使用されます。
  #     physical_table_id = "example-physical-table-id"
  #
  #     # data_set_arn (Optional)
  #     # 設定内容: 親データセットのARNを指定します。
  #     # 設定可能な値: QuickSight Data SetのARN
  #     # 省略時: デフォルト値が使用されます。
  #     data_set_arn = null
  #
  #     # join_instruction (Optional)
  #     # 設定内容: 2つの論理テーブルの結合を指定します。
  #     # join_instruction {
  #     #   # left_operand (Required)
  #     #   # 設定内容: 結合の左側のオペランドを指定します。
  #     #   # 設定可能な値: 論理テーブルID
  #     #   left_operand = "left-table-id"
  #     #
  #     #   # right_operand (Required)
  #     #   # 設定内容: 結合の右側のオペランドを指定します。
  #     #   # 設定可能な値: 論理テーブルID
  #     #   right_operand = "right-table-id"
  #     #
  #     #   # on_clause (Required)
  #     #   # 設定内容: ON句で提供される結合命令を指定します。
  #     #   # 設定可能な値: 結合条件の文字列
  #     #   on_clause = "left_table.id = right_table.id"
  #     #
  #     #   # type (Required)
  #     #   # 設定内容: 結合のタイプを指定します。
  #     #   # 設定可能な値: INNER、OUTER、LEFT、RIGHT
  #     #   type = "INNER"
  #     #
  #     #   # left_join_key_properties (Optional)
  #     #   # 設定内容: 左側のオペランドの結合キープロパティを定義します。
  #     #   # left_join_key_properties {
  #     #   #   # unique_key (Optional)
  #     #   #   # 設定内容: 結合キーのカラムがテーブル内で一意であるかを示します。
  #     #   #   # 設定可能な値:
  #     #   #   #   - true: 一意キー（クエリパフォーマンスの最適化に使用）
  #     #   #   #   - false: 一意キーではない
  #     #   #   # 省略時: デフォルト値が使用されます。
  #     #   #   unique_key = null
  #     #   # }
  #     #
  #     #   # right_join_key_properties (Optional)
  #     #   # 設定内容: 右側のオペランドの結合キープロパティを定義します。
  #     #   # right_join_key_properties {
  #     #   #   # unique_key (Optional)
  #     #   #   # 設定内容: 結合キーのカラムがテーブル内で一意であるかを示します。
  #     #   #   # 設定可能な値:
  #     #   #   #   - true: 一意キー（クエリパフォーマンスの最適化に使用）
  #     #   #   #   - false: 一意キーではない
  #     #   #   # 省略時: デフォルト値が使用されます。
  #     #   #   unique_key = null
  #     #   # }
  #     # }
  #   }
  #
  #   # data_transforms (Optional)
  #   # 設定内容: 論理テーブルに適用する変換操作を定義します。
  #   # 最大項目数: 2048
  #   # data_transforms {
  #   #   # cast_column_type_operation (Optional)
  #   #   # 設定内容: カラムを異なる型にキャストする変換操作を定義します。
  #   #   # cast_column_type_operation {
  #   #   #   # column_name (Required)
  #   #   #   # 設定内容: カラム名を指定します。
  #   #   #   column_name = "column1"
  #   #   #
  #   #   #   # new_column_type (Required)
  #   #   #   # 設定内容: 新しいカラムデータ型を指定します。
  #   #   #   # 設定可能な値: STRING、INTEGER、DECIMAL、DATETIME
  #   #   #   new_column_type = "INTEGER"
  #   #   #
  #   #   #   # format (Optional)
  #   #   #   # 設定内容: 文字列からdatetime型へのキャスト時のフォーマットを指定します。
  #   #   #   # 省略時: デフォルト値が使用されます。
  #   #   #   format = null
  #   #   # }
  #   #
  #   #   # create_columns_operation (Optional)
  #   #   # 設定内容: 計算カラムを作成する操作を定義します。
  #   #   # create_columns_operation {
  #   #   #   # columns (Required)
  #   #   #   # 設定内容: 作成する計算カラムを定義します。
  #   #   #   # 最小項目数: 1、最大項目数: 128
  #   #   #   columns {
  #   #   #     # column_id (Required)
  #   #   #     # 設定内容: 計算カラムを識別する一意のIDを指定します。
  #   #   #     column_id = "calculated-column-1"
  #   #   #
  #   #   #     # column_name (Required)
  #   #   #     # 設定内容: カラム名を指定します。
  #   #   #     column_name = "calculated_column"
  #   #   #
  #   #   #     # expression (Required)
  #   #   #     # 設定内容: 計算カラムを定義する式を指定します。
  #   #   #     expression = "{column1} + {column2}"
  #   #   #   }
  #   #   # }
  #   #
  #   #   # filter_operation (Optional)
  #   #   # 設定内容: 条件に基づいて行をフィルタする操作を定義します。
  #   #   # filter_operation {
  #   #   #   # condition_expression (Required)
  #   #   #   # 設定内容: ブール値に評価される式を指定します（trueの行が保持される）。
  #   #   #   condition_expression = "{column1} > 100"
  #   #   # }
  #   #
  #   #   # project_operation (Optional)
  #   #   # 設定内容: カラムをプロジェクションする操作を定義します。
  #   #   # 注意: プロジェクション後の操作は、プロジェクトされたカラムのみ参照可能
  #   #   # project_operation {
  #   #   #   # projected_columns (Required)
  #   #   #   # 設定内容: プロジェクトするカラムのリストを指定します。
  #   #   #   projected_columns = ["column1", "column2"]
  #   #   # }
  #   #
  #   #   # rename_column_operation (Optional)
  #   #   # 設定内容: カラムをリネームする操作を定義します。
  #   #   # rename_column_operation {
  #   #   #   # column_name (Required)
  #   #   #   # 設定内容: リネームするカラムを指定します。
  #   #   #   column_name = "old_column_name"
  #   #   #
  #   #   #   # new_column_name (Required)
  #   #   #   # 設定内容: カラムの新しい名前を指定します。
  #   #   #   new_column_name = "new_column_name"
  #   #   # }
  #   #
  #   #   # tag_column_operation (Optional)
  #   #   # 設定内容: カラムに追加情報をタグ付けする操作を定義します。
  #   #   # tag_column_operation {
  #   #   #   # column_name (Required)
  #   #   #   # 設定内容: カラム名を指定します。
  #   #   #   column_name = "column1"
  #   #   #
  #   #   #   # tags (Required)
  #   #   #   # 設定内容: データセットカラムタグを定義します（地理空間タイプタグに使用）。
  #   #   #   # 最小項目数: 1、最大項目数: 16
  #   #   #   tags {
  #   #   #     # column_geographic_role (Optional)
  #   #   #     # 設定内容: カラムの地理空間ロールを指定します。
  #   #   #     # 設定可能な値: COUNTRY、STATE、COUNTY、CITY、POSTCODE、LONGITUDE、LATITUDE
  #   #   #     column_geographic_role = null
  #   #   #
  #   #   #     # column_description (Optional)
  #   #   #     # 設定内容: カラムの説明を定義します。
  #   #   #     # column_description {
  #   #   #     #   # text (Optional)
  #   #   #     #   # 設定内容: カラムの説明テキストを指定します。
  #   #   #     #   text = null
  #   #   #     # }
  #   #   #   }
  #   #   # }
  #   #
  #   #   # untag_column_operation (Optional)
  #   #   # 設定内容: カラムに関連付けられたタグを削除する変換操作を定義します。
  #   #   # untag_column_operation {
  #   #   #   # column_name (Required)
  #   #   #   # 設定内容: カラム名を指定します。
  #   #   #   column_name = "column1"
  #   #   #
  #   #   #   # tag_names (Required)
  #   #   #   # 設定内容: このカラムから削除するカラムタグを指定します。
  #   #   #   tag_names = ["GEOGRAPHIC_ROLE"]
  #   #   # }
  #   # }
  # }

  #-------------------------------------------------------------
  # カラムグループ設定
  #-------------------------------------------------------------

  # column_groups (Optional)
  # 設定内容: QuickSight機能で連携して動作するカラムのグループを定義します。
  # 最大項目数: 8
  # 関連機能: 現在は地理空間階層のみサポートされています。
  # column_groups {
  #   # geo_spatial_column_group (Optional)
  #   # 設定内容: 階層を示す地理空間カラムグループを定義します。
  #   geo_spatial_column_group {
  #     # columns (Required)
  #     # 設定内容: 階層内のカラムを指定します。
  #     # 設定可能な値: カラム名のリスト
  #     columns = ["country", "state", "city"]
  #
  #     # country_code (Required)
  #     # 設定内容: 国コードを指定します。
  #     # 設定可能な値: US
  #     country_code = "US"
  #
  #     # name (Required)
  #     # 設定内容: 階層の表示名を指定します。
  #     # 設定可能な値: 文字列
  #     name = "geographic-hierarchy"
  #   }
  # }

  #-------------------------------------------------------------
  # フィールドフォルダー設定
  #-------------------------------------------------------------

  # field_folders (Optional)
  # 設定内容: データセットのフィールドとネストされたサブフォルダーを含むフォルダーを定義します。
  # 最大項目数: 1000
  # 関連機能: データセット内のフィールドを整理し、グループ化するためのフォルダー構造を定義します。
  # field_folders {
  #   # field_folders_id (Required)
  #   # 設定内容: フィールドフォルダーマップのキーを指定します。
  #   # 設定可能な値: 一意の文字列ID
  #   field_folders_id = "example-field-folder-id"
  #
  #   # columns (Optional)
  #   # 設定内容: フォルダーに追加するカラム名の配列を指定します。
  #   # 設定可能な値: カラム名のリスト
  #   # 注意: カラムは1つのフォルダーにのみ所属可能
  #   columns = null
  #
  #   # description (Optional)
  #   # 設定内容: フィールドフォルダーの説明を指定します。
  #   # 設定可能な値: 文字列
  #   # 省略時: 説明なし
  #   description = null
  # }

  #-------------------------------------------------------------
  # リフレッシュプロパティ設定
  #-------------------------------------------------------------

  # refresh_properties (Optional)
  # 設定内容: データセットのリフレッシュプロパティを設定します。
  # 注意: import_modeがSPICEの場合のみ有効
  # 関連機能: SPICEデータセットの増分リフレッシュ設定を定義します。
  # refresh_properties {
  #   # refresh_configuration (Required)
  #   # 設定内容: データセットのリフレッシュ設定を定義します。
  #   refresh_configuration {
  #     # incremental_refresh (Required)
  #     # 設定内容: データセットの増分リフレッシュを定義します。
  #     incremental_refresh {
  #       # lookback_window (Required)
  #       # 設定内容: 増分リフレッシュ設定のルックバックウィンドウを設定します。
  #       lookback_window {
  #         # column_name (Required)
  #         # 設定内容: ルックバックウィンドウカラムの名前を指定します。
  #         # 設定可能な値: 文字列（タイムスタンプカラム名）
  #         column_name = "timestamp_column"
  #
  #         # size (Required)
  #         # 設定内容: ルックバックウィンドウカラムのサイズを指定します。
  #         # 設定可能な値: 数値
  #         size = 1
  #
  #         # size_unit (Required)
  #         # 設定内容: ルックバックウィンドウカラムに使用するサイズ単位を指定します。
  #         # 設定可能な値: HOUR、DAY、WEEK
  #         size_unit = "DAY"
  #       }
  #     }
  #   }
  # }

  #-------------------------------------------------------------
  # データセット使用構成設定
  #-------------------------------------------------------------

  # data_set_usage_configuration (Optional)
  # 設定内容: このデータセットをソースとして参照する子データセットに適用する使用構成を設定します。
  # data_set_usage_configuration {
  #   # disable_use_as_direct_query_source (Optional)
  #   # 設定内容: ダイレクトクエリの子データセットがこのデータセットをソースとして使用できるかを制御します。
  #   # 設定可能な値:
  #   #   - true: 使用不可
  #   #   - false: 使用可能
  #   # 省略時: デフォルト値が使用されます。
  #   disable_use_as_direct_query_source = null
  #
  #   # disable_use_as_imported_source (Optional)
  #   # 設定内容: QuickSightに保存された子データセットがこのデータセットをソースとして使用できるかを制御します。
  #   # 設定可能な値:
  #   #   - true: 使用不可
  #   #   - false: 使用可能
  #   # 省略時: デフォルト値が使用されます。
  #   disable_use_as_imported_source = null
  # }

  #-------------------------------------------------------------
  # カラムレベル権限設定
  #-------------------------------------------------------------

  # column_level_permission_rules (Optional)
  # 設定内容: カラムレベルのパーミッションルールのセットを定義します。
  # 関連機能: 特定のカラムへのアクセスを制限し、ユーザーやグループごとに
  #   異なるデータビューを提供します。
  # column_level_permission_rules {
  #   # column_names (Optional)
  #   # 設定内容: カラム名の配列を指定します。
  #   # 設定可能な値: カラム名のリスト
  #   column_names = null
  #
  #   # principals (Optional)
  #   # 設定内容: QuickSightユーザーまたはグループのARN配列を指定します。
  #   # 設定可能な値: QuickSightユーザーまたはグループのARNのリスト
  #   principals = null
  # }

  #-------------------------------------------------------------
  # 行レベル権限設定
  #-------------------------------------------------------------

  # row_level_permission_data_set (Optional)
  # 設定内容: 作成するデータの行レベルセキュリティ設定を定義します。
  # 関連機能: 行レベルでデータへのアクセスを制御し、ユーザーごとに異なるデータサブセットを提供します。
  # row_level_permission_data_set {
  #   # arn (Required)
  #   # 設定内容: RLSのパーミッションを含むデータセットのARNを指定します。
  #   # 設定可能な値: QuickSight Data SetのARN
  #   arn = "arn:aws:quicksight:ap-northeast-1:123456789012:dataset/example-rls-dataset-id"
  #
  #   # permission_policy (Required)
  #   # 設定内容: RLSのパーミッションを解釈する際のタイプを指定します。
  #   # 設定可能な値:
  #   #   - "GRANT_ACCESS": アクセスを許可
  #   #   - "DENY_ACCESS": アクセスを拒否
  #   permission_policy = "GRANT_ACCESS"
  #
  #   # format_version (Optional)
  #   # 設定内容: RLSのパーミッションデータセットのフォーマットバージョンを指定します。
  #   # 設定可能な値: VERSION_1、VERSION_2
  #   # 省略時: デフォルトのフォーマットバージョンが使用されます。
  #   format_version = null
  #
  #   # namespace (Optional)
  #   # 設定内容: RLSのパーミッションデータセットに関連付けられた名前空間を指定します。
  #   # 設定可能な値: 文字列
  #   # 省略時: デフォルトの名前空間が使用されます。
  #   namespace = null
  #
  #   # status (Optional)
  #   # 設定内容: 行レベルセキュリティパーミッションデータセットのステータスを指定します。
  #   # 設定可能な値:
  #   #   - "ENABLED": 有効
  #   #   - "DISABLED": 無効
  #   # 省略時: デフォルトのステータスが使用されます。
  #   status = null
  # }

  # row_level_permission_tag_configuration (Optional)
  # 設定内容: 行レベルセキュリティを設定するためのデータセット上のタグの構成を定義します。
  # 注意: 現在、匿名埋め込みでのみサポートされています。
  # row_level_permission_tag_configuration {
  #   # status (Optional)
  #   # 設定内容: 行レベルセキュリティタグのステータスを指定します。
  #   # 設定可能な値:
  #   #   - "ENABLED": 有効
  #   #   - "DISABLED": 無効
  #   # 省略時: デフォルトのステータスが使用されます。
  #   status = null
  #
  #   # tag_rules (Required)
  #   # 設定内容: 行レベルセキュリティに関連付けられたルールのセットを定義します。
  #   # 最小項目数: 1、最大項目数: 50
  #   tag_rules {
  #     # column_name (Required)
  #     # 設定内容: タグキーが割り当てられるカラム名を指定します。
  #     # 設定可能な値: 文字列
  #     column_name = "department"
  #
  #     # tag_key (Required)
  #     # 設定内容: タグの一意のキーを指定します。
  #     # 設定可能な値: 文字列
  #     tag_key = "Department"
  #
  #     # match_all_value (Optional)
  #     # 設定内容: データセットのカラム内のすべての値でフィルタするために使用する文字列を指定します。
  #     # 省略時: 使用されません。
  #     match_all_value = null
  #
  #     # tag_multi_value_delimiter (Optional)
  #     # 設定内容: 実行時に値を渡す際に値を区切るために使用する文字列を指定します。
  #     # 省略時: デフォルトの区切り文字が使用されます。
  #     tag_multi_value_delimiter = null
  #   }
  # }

  #-------------------------------------------------------------
  # 権限設定
  #-------------------------------------------------------------

  # permissions (Optional)
  # 設定内容: データセットのリソースパーミッションのセットを定義します。
  # 最大項目数: 64
  # 関連機能: データセットへのアクセス権限を管理し、誰がどのアクションを実行できるかを制御します。
  # permissions {
  #   # actions (Required)
  #   # 設定内容: 許可または取り消すIAMアクションのリストを指定します。
  #   # 設定可能な値: QuickSightのIAMアクションのリスト
  #   #   - quicksight:DescribeDataSet
  #   #   - quicksight:DescribeDataSetPermissions
  #   #   - quicksight:PassDataSet
  #   #   - quicksight:DescribeIngestion
  #   #   - quicksight:ListIngestions
  #   #   - quicksight:UpdateDataSet
  #   #   - quicksight:DeleteDataSet
  #   #   - quicksight:CreateIngestion
  #   #   - quicksight:CancelIngestion
  #   #   - quicksight:UpdateDataSetPermissions
  #   actions = [
  #     "quicksight:DescribeDataSet",
  #     "quicksight:DescribeDataSetPermissions",
  #     "quicksight:PassDataSet",
  #     "quicksight:DescribeIngestion",
  #     "quicksight:ListIngestions",
  #   ]
  #
  #   # principal (Required)
  #   # 設定内容: プリンシパルのARNを指定します。
  #   # 設定可能な値: QuickSightユーザー、グループ、またはネームスペースのARN
  #   principal = "arn:aws:quicksight:ap-northeast-1:123456789012:user/default/example-user"
  # }

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "example-dataset"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: データセットのAmazon Resource Name (ARN)
# - id: AWSアカウントIDとデータセットIDをカンマで結合した文字列
# - output_columns: 全データ準備・変換後の最終カラムセット
#   - name: カラム名 / description: カラム説明 / type: データ型
# - tags_all: プロバイダーのdefault_tagsを含む全タグのマップ
#---------------------------------------------------------------
