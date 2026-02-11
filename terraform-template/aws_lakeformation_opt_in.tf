#---------------------------------------------------------------
# AWS Lake Formation Opt In
#---------------------------------------------------------------
#
# Lake Formation Opt Inリソースは、クロスアカウントのCloudTrailログに
# プリンシパルARNを含めるためのオプトイン設定を管理します。
#
# デフォルトでは、クロスアカウントのCloudTrailイベントには外部アカウントの
# プリンシパルIDのみが含まれますが、このリソースを使用することで、
# リソースオーナーアカウントが受信者アカウント内のプリンシパルARNを
# CloudTrailログで追跡できるようになります。
#
# 主な用途:
#   - 同じ組織やチーム内などの信頼された境界内でリソースを共有する場合に、
#     詳細な監査証跡を維持する
#   - クロスアカウントアクセスのセキュリティとコンプライアンス要件を満たす
#   - データレイクへのアクセスを細かいレベルで追跡する
#
# AWS公式ドキュメント:
#   - クロスアカウントCloudTrailログ: https://docs.aws.amazon.com/lake-formation/latest/dg/cross-account-logging.html
#   - Lake Formationクロスアカウントデータ共有: https://docs.aws.amazon.com/lake-formation/latest/dg/cross-account-permissions.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lakeformation_opt_in
#
# Provider Version: 6.28.0
# Generated: 2026-02-04
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_lakeformation_opt_in" "example" {
  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースが管理されるAWSリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定で指定されたリージョンがデフォルトで使用されます。
  # 用途: マルチリージョン環境で、特定のリージョンでのオプトイン設定を
  #       管理する場合に使用します。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # プリンシパル設定 (Required)
  #-------------------------------------------------------------

  # principal (Required)
  # 設定内容: Lake Formationプリンシパルを指定します。
  # サポートされるプリンシパル: IAMユーザーまたはIAMロール
  # 用途: クロスアカウントCloudTrailログにプリンシパルARNを含めることに
  #       オプトインするプリンシパルを定義します。
  # 注意: このプリンシパルは、共有リソースの受信者アカウント内のプリンシパルです。
  principal {
    # data_lake_principal (Required)
    # 設定内容: Lake Formationプリンシパルの識別子を指定します。
    # 設定可能な値: IAMユーザーまたはIAMロールのARN
    # 例: "arn:aws:iam::111122223333:role/ETL-Glue-Role"
    # 用途: CloudTrailログに含めるプリンシパルのARNを指定します。
    #       これにより、リソースオーナーは受信者アカウント内の
    #       どのプリンシパルがリソースにアクセスしたかを追跡できます。
    data_lake_principal = "arn:aws:iam::111122223333:role/ETL-Glue-Role"
  }

  #-------------------------------------------------------------
  # リソースデータ設定 (Required)
  #-------------------------------------------------------------

  # resource_data (Required)
  # 設定内容: リソースの構造を定義します。
  # 用途: オプトイン設定が適用されるLake Formationリソースを指定します。
  # 注意: 以下のリソースタイプのいずれか1つのみを指定する必要があります。
  resource_data {
    #-----------------------------------------------------------
    # カタログリソース (Optional)
    #-----------------------------------------------------------

    # catalog (Optional)
    # 設定内容: Data Catalogの識別子を指定します。
    # 用途: カタログレベルでのオプトイン設定を行う場合に使用します。
    # 省略時: アカウントIDがデフォルトで使用されます。
    # 注意: Data Catalogは、Lake Formation環境を管理するための永続的な
    #       メタデータストアであり、データベース定義、テーブル定義、
    #       その他の制御情報が含まれます。
    catalog {
      # id (Optional)
      # 設定内容: カタログリソースの識別子を指定します。
      # 設定可能な値: AWSアカウントID
      # 省略時: 呼び出し元のアカウントIDがデフォルトで使用されます。
      id = null
    }

    #-----------------------------------------------------------
    # データセルフィルターリソース (Optional)
    #-----------------------------------------------------------

    # data_cells_filter (Optional)
    # 設定内容: データセルフィルターを指定します。
    # 用途: 行レベルまたはセルレベルのアクセス制御を適用したリソースに
    #       対するオプトイン設定を行う場合に使用します。
    # 注意: データセルフィルターは、テーブル内の特定の行や列への
    #       アクセスを制限するために使用されます。
    # data_cells_filter {
    #   # name (Required)
    #   # 設定内容: データセルフィルターの名前を指定します。
    #   # 設定可能な値: データセルフィルターの一意の名前
    #   name = "example-filter"
    #
    #   # table_catalog_id (Required)
    #   # 設定内容: テーブルが属するカタログのIDを指定します。
    #   # 設定可能な値: AWSアカウントID
    #   table_catalog_id = "123456789012"
    #
    #   # table_name (Required)
    #   # 設定内容: テーブルの名前を指定します。
    #   # 設定可能な値: Glue Data Catalog内のテーブル名
    #   table_name = "example-table"
    #
    #   # database_name (Required)
    #   # 設定内容: Glue Data Catalog内のデータベース名を指定します。
    #   # 設定可能な値: Glue Data Catalog内のデータベース名
    #   database_name = "example-database"
    # }

    #-----------------------------------------------------------
    # データロケーションリソース (Optional)
    #-----------------------------------------------------------

    # data_location (Optional)
    # 設定内容: Amazon S3パスの場所を指定します。
    # 用途: S3ロケーションに対する権限が付与または取り消される場合の
    #       オプトイン設定を行う際に使用します。
    # data_location {
    #   # resource_arn (Required)
    #   # 設定内容: データロケーションリソースを一意に識別するARNを指定します。
    #   # 設定可能な値: S3バケットまたはパスのARN
    #   # 例: "arn:aws:s3:::example-bucket/data/"
    #   # 注意: このロケーションはLake Formationに登録されている必要があります。
    #   resource_arn = "arn:aws:s3:::example-bucket/data/"
    #
    #   # catalog_id (Optional)
    #   # 設定内容: ロケーションがLake Formationに登録されているData Catalogの
    #   #           識別子を指定します。
    #   # 設定可能な値: AWSアカウントID
    #   # 省略時: 呼び出し元のアカウントIDがデフォルトで使用されます。
    #   catalog_id = null
    # }

    #-----------------------------------------------------------
    # データベースリソース (Optional)
    #-----------------------------------------------------------

    # database (Optional)
    # 設定内容: リソースのデータベースを指定します。
    # 用途: データベースレベルでのオプトイン設定を行う場合に使用します。
    # 注意: データベースはData Catalogに対して一意であり、論理グループに
    #       編成された関連するテーブル定義のセットです。
    # database {
    #   # name (Required)
    #   # 設定内容: データベースリソースの名前を指定します。
    #   # 設定可能な値: Data Catalogに対して一意のデータベース名
    #   name = "example-database"
    #
    #   # catalog_id (Optional)
    #   # 設定内容: Data Catalogの識別子を指定します。
    #   # 設定可能な値: AWSアカウントID
    #   # 省略時: 呼び出し元のアカウントIDがデフォルトで使用されます。
    #   catalog_id = null
    # }

    #-----------------------------------------------------------
    # LF-Tag式リソース (Optional)
    #-----------------------------------------------------------

    # lf_tag_expression (Optional)
    # 設定内容: LF-Tag式を指定します。
    # 用途: LF-Tagベースのアクセス制御（LF-TBAC）を使用している場合の
    #       オプトイン設定を行う際に使用します。
    # 注意: LF-Tag式は、1つ以上のLF-Tagキー:値ペアで構成される
    #       論理式です。
    # lf_tag_expression {
    #   # name (Required)
    #   # 設定内容: 権限を付与するLF-Tag式の名前を指定します。
    #   # 設定可能な値: LF-Tag式の名前
    #   name = "example-lf-tag-expression"
    #
    #   # catalog_id (Optional)
    #   # 設定内容: Data Catalogの識別子を指定します。
    #   # 設定可能な値: AWSアカウントID
    #   # 省略時: 呼び出し元のアカウントIDがデフォルトで使用されます。
    #   catalog_id = null
    # }

    #-----------------------------------------------------------
    # LF-Tagポリシーリソース (Optional)
    #-----------------------------------------------------------

    # lf_tag_policy (Optional)
    # 設定内容: LF-Tagポリシーを指定します。
    # 用途: LF-Tagベースのアクセス制御を使用してリソースのポリシーを
    #       定義する場合に使用します。
    # 注意: LF-Tagポリシーは、リソースのLF-Tagポリシーを定義する
    #       LF-Tag条件または保存されたLF-Tag式のリストです。
    # lf_tag_policy {
    #   # resource_type (Required)
    #   # 設定内容: LF-Tagポリシーが適用されるリソースタイプを指定します。
    #   # 設定可能な値: "DATABASE" または "TABLE"
    #   resource_type = "DATABASE"
    #
    #   # catalog_id (Optional)
    #   # 設定内容: Data Catalogの識別子を指定します。
    #   # 設定可能な値: AWSアカウントID
    #   # 省略時: 呼び出し元のアカウントIDがデフォルトで使用されます。
    #   # 注意: Data Catalogは、Lake Formation環境を管理するための
    #   #       永続的なメタデータストアです。
    #   catalog_id = null
    #
    #   # expression (Required)
    #   # 設定内容: リソースのLF-Tagポリシーに適用されるLF-Tag条件または
    #   #           保存された式のリストを指定します。
    #   # 設定可能な値: LF-Tag条件のリスト
    #   # 注意: expressionとexpression_nameのいずれか1つのみを指定する必要があります。
    #   expression {
    #     # key (Required)
    #     # 設定内容: LF-Tagのキーを指定します。
    #     # 設定可能な値: LF-Tagのキー名
    #     key = "Environment"
    #
    #     # values (Required)
    #     # 設定内容: LF-Tagの値のリストを指定します。
    #     # 設定可能な値: LF-Tagの値のリスト
    #     values = ["Production", "Staging"]
    #   }
    #
    #   # expression_name (Optional)
    #   # 設定内容: 保存された式の名前を指定します。
    #   # 用途: 提供された場合、割り当てられたLF-Tagが提供されたExpressionName下の
    #   #       保存された式の式本文と一致するData Catalogリソースに対して
    #   #       権限が付与されます。
    #   # 注意: expressionとexpression_nameのいずれか1つのみを指定する必要があります。
    #   expression_name = null
    # }

    #-----------------------------------------------------------
    # テーブルリソース (Optional)
    #-----------------------------------------------------------

    # table (Optional)
    # 設定内容: リソースのテーブルを指定します。
    # 用途: テーブルレベルでのオプトイン設定を行う場合に使用します。
    # 注意: テーブルは、データを表すメタデータ定義です。
    #       テーブル権限をプリンシパルに付与および取り消すことができます。
    # table {
    #   # database_name (Required)
    #   # 設定内容: テーブルのデータベース名を指定します。
    #   # 設定可能な値: Data Catalogに対して一意のデータベース名
    #   # 注意: データベースは、論理グループに編成された関連するテーブル定義の
    #   #       セットです。
    #   database_name = "example-database"
    #
    #   # name (Optional)
    #   # 設定内容: テーブルの名前を指定します。
    #   # 設定可能な値: テーブル名
    #   # 注意: nameまたはwildcardのいずれか1つを指定する必要があります。
    #   name = "example-table"
    #
    #   # catalog_id (Optional)
    #   # 設定内容: Data Catalogの識別子を指定します。
    #   # 設定可能な値: AWSアカウントID
    #   # 省略時: 呼び出し元のアカウントIDがデフォルトで使用されます。
    #   catalog_id = null
    #
    #   # wildcard (Optional)
    #   # 設定内容: 指定されたデータベース下のすべてのテーブルを表すワイルドカードを
    #   #           使用するかどうかを示すブール値。
    #   # 設定可能な値: true または false
    #   # 用途: trueに設定すると、指定されたデータベース内のすべてのテーブルを
    #   #       表します。
    #   # 注意: TableResource$NameまたはTableResource$Wildcardの少なくとも
    #   #       1つが必要です。
    #   wildcard = null
    # }

    #-----------------------------------------------------------
    # テーブルウィズカラムズリソース (Optional)
    #-----------------------------------------------------------

    # table_with_columns (Optional)
    # 設定内容: 列を含むテーブルリソースを指定します。
    # 用途: 列レベルのアクセス制御を適用する場合に使用します。
    # 注意: このリソースに対する権限を持つプリンシパルは、Data Catalog内の
    #       テーブルの列からメタデータを選択し、Amazon S3内の基礎となる
    #       データにアクセスできます。
    # table_with_columns {
    #   # database_name (Required)
    #   # 設定内容: テーブルのデータベース名を指定します。
    #   # 設定可能な値: Data Catalogに対して一意のデータベース名
    #   # 注意: データベースは、論理グループに編成された関連するテーブル定義の
    #   #       セットです。
    #   database_name = "example-database"
    #
    #   # name (Required)
    #   # 設定内容: テーブルの名前を指定します。
    #   # 設定可能な値: テーブル名
    #   name = "example-table"
    #
    #   # catalog_id (Optional)
    #   # 設定内容: Data Catalogの識別子を指定します。
    #   # 設定可能な値: AWSアカウントID
    #   # 省略時: 呼び出し元のアカウントIDがデフォルトで使用されます。
    #   catalog_id = null
    #
    #   # column_names (Optional)
    #   # 設定内容: テーブルの列名のリストを指定します。
    #   # 設定可能な値: 列名のリスト
    #   # 注意: ColumnNamesまたはColumnWildcardの少なくとも1つが必要です。
    #   column_names = ["column1", "column2"]
    #
    #   # column_wildcard (Optional)
    #   # 設定内容: ColumnWildcardオブジェクトによって指定されたワイルドカードを
    #   #           使用します。
    #   # 用途: すべての列を指定する場合に使用します。
    #   # 注意: ColumnNamesまたはColumnWildcardの少なくとも1つが必要です。
    #   # column_wildcard {
    #   #   # excluded_column_names (Optional)
    #   #   # 設定内容: ワイルドカードから除外する列名のリストを指定します。
    #   #   # 設定可能な値: 列名のリスト
    #   #   # 用途: すべての列を含めるが、特定の列を除外する場合に使用します。
    #   #   excluded_column_names = ["sensitive_column"]
    #   # }
    # }
  }

  #-------------------------------------------------------------
  # その他の読み取り専用属性
  #-------------------------------------------------------------
  # このリソースは以下の属性もエクスポートします:
  #
  # - condition: Lake Formation条件（式を含む権限およびオプトインに適用されます）
  # - last_modified: レコードの最終変更日時
  # - last_updated: レコードを更新したユーザー
  #-------------------------------------------------------------
}

#---------------------------------------------------------------
# 使用例: 基本的なオプトイン設定
#---------------------------------------------------------------
# 以下は、クロスアカウントCloudTrailログにプリンシパルARNを含めるための
# 基本的なオプトイン設定の例です。

# resource "aws_lakeformation_opt_in" "basic_example" {
#   # プリンシパルの設定
#   principal {
#     data_lake_principal = "arn:aws:iam::111122223333:role/DataLakeAccessRole"
#   }
#
#   # カタログレベルでのオプトイン
#   resource_data {
#     catalog {}
#   }
# }

#---------------------------------------------------------------
# 使用例: データベースレベルのオプトイン設定
#---------------------------------------------------------------
# 特定のデータベースに対するオプトイン設定の例です。

# resource "aws_lakeformation_opt_in" "database_example" {
#   principal {
#     data_lake_principal = "arn:aws:iam::111122223333:role/DatabaseAccessRole"
#   }
#
#   resource_data {
#     database {
#       name       = "sales_database"
#       catalog_id = "123456789012"
#     }
#   }
# }

#---------------------------------------------------------------
# 使用例: テーブルレベルのオプトイン設定
#---------------------------------------------------------------
# 特定のテーブルに対するオプトイン設定の例です。

# resource "aws_lakeformation_opt_in" "table_example" {
#   principal {
#     data_lake_principal = "arn:aws:iam::111122223333:role/TableAccessRole"
#   }
#
#   resource_data {
#     table {
#       database_name = "sales_database"
#       name          = "transactions"
#       catalog_id    = "123456789012"
#     }
#   }
# }

#---------------------------------------------------------------
# 使用例: LF-Tagポリシーを使用したオプトイン設定
#---------------------------------------------------------------
# LF-Tagベースのアクセス制御を使用したオプトイン設定の例です。

# resource "aws_lakeformation_opt_in" "lf_tag_example" {
#   principal {
#     data_lake_principal = "arn:aws:iam::111122223333:role/LFTagAccessRole"
#   }
#
#   resource_data {
#     lf_tag_policy {
#       resource_type = "DATABASE"
#       catalog_id    = "123456789012"
#       expression {
#         key    = "Environment"
#         values = ["Production"]
#       }
#     }
#   }
# }

#---------------------------------------------------------------
# 重要な注意事項
#---------------------------------------------------------------
# 1. オプトイン設定は、クロスアカウントデータ共有のセキュリティと
#    監査要件を満たすために重要です。
#
# 2. 共有リソースの受信者として、自分のCloudTrailログでプリンシパルARNを
#    確認するには、オーナーアカウントとプリンシパルARNを共有することに
#    オプトインする必要があります。
#
# 3. リソースリンクを介したデータアクセスの場合、受信者アカウントには
#    2つのイベントがログに記録されます（リソースリンクアクセスと
#    ターゲットリソースアクセス）。
#
# 4. リソースオーナーは、Lake Formationコンソールの設定で受信者アカウントIDを
#    入力する必要があります。
#
# 5. この機能は、同じ組織やチーム内などの信頼された境界内でリソースを
#    共有する場合に特に有用です。
#
# 6. CloudTrailイベントには、lakeFormationPrincipalフィールドが含まれ、
#    Amazon Athena、Amazon Redshift Spectrum、またはAWS Glueジョブを通じて
#    クエリを実行するエンドロールまたはユーザーを表します。
#---------------------------------------------------------------
