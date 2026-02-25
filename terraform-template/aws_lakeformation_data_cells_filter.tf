#---------------------------------------------------------------
# AWS Lake Formation Data Cells Filter
#---------------------------------------------------------------
#
# AWS Lake FormationのData Cells Filterをプロビジョニングするリソースです。
# Data Cells FilterはAWS Glue Data Catalogのテーブルに対して列レベル・行レベル・
# セルレベルのアクセス制御を実装するためのフィルターを定義します。
# フィルターを使用することで、特定の列や行のみをプリンシパルに公開できます。
#
# AWS公式ドキュメント:
#   - データフィルタリングとセルレベルセキュリティ: https://docs.aws.amazon.com/lake-formation/latest/dg/data-filtering.html
#   - データフィルターの管理: https://docs.aws.amazon.com/lake-formation/latest/dg/managing-filters.html
#   - CreateDataCellsFilter API: https://docs.aws.amazon.com/lake-formation/latest/APIReference/API_CreateDataCellsFilter.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lakeformation_data_cells_filter
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_lakeformation_data_cells_filter" "example" {
  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するAWSリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # テーブルデータフィルター設定
  #-------------------------------------------------------------

  # table_data (Required)
  # 設定内容: Data Cells Filterの詳細設定ブロックです。
  #   フィルターの対象テーブル、列フィルター、行フィルターを定義します。
  # 参考: https://docs.aws.amazon.com/lake-formation/latest/dg/data-filtering.html
  table_data {

    #-----------------------------------------------------------
    # フィルター識別設定
    #-----------------------------------------------------------

    # name (Required)
    # 設定内容: Data Cells Filterの名前を指定します。
    # 設定可能な値: 文字列
    name = "example-filter"

    # table_catalog_id (Required)
    # 設定内容: フィルター対象テーブルが属するData CatalogのIDを指定します。
    # 設定可能な値: AWSアカウントID（12桁の数字）
    table_catalog_id = "123456789012"

    # database_name (Required)
    # 設定内容: フィルター対象テーブルが属するデータベース名を指定します。
    # 設定可能な値: AWS Glue Data Catalogの有効なデータベース名
    database_name = "example_database"

    # table_name (Required)
    # 設定内容: フィルター対象のテーブル名を指定します。
    # 設定可能な値: AWS Glue Data Catalogの有効なテーブル名
    table_name = "example_table"

    #-----------------------------------------------------------
    # 列フィルター設定
    #-----------------------------------------------------------

    # column_names (Optional)
    # 設定内容: アクセスを許可する列名のセットを指定します。
    # 設定可能な値: 列名の文字列セット
    # 省略時: Terraformによって自動計算された値が使用されます
    # 注意: column_namesとcolumn_wildcardはいずれか一方を使用してください。
    #       column_namesを指定した場合、列レベルセキュリティが適用されます。
    column_names = ["column1", "column2"]

    # version_id (Optional)
    # 設定内容: Data Cells FilterのバージョンIDを指定します。
    # 設定可能な値: バージョンIDの文字列
    # 省略時: Terraformによって自動計算された値が使用されます
    version_id = null

    #-----------------------------------------------------------
    # 列ワイルドカード設定
    #-----------------------------------------------------------

    # column_wildcard (Optional)
    # 設定内容: 除外する列を指定したワイルドカード設定ブロックです。
    #   特定の列を除外し、残りの全列へのアクセスを許可する場合に使用します。
    # 注意: column_namesとcolumn_wildcardはいずれか一方を使用してください。
    # 参考: https://docs.aws.amazon.com/lake-formation/latest/dg/data-filtering.html
    column_wildcard {

      # excluded_column_names (Optional)
      # 設定内容: アクセスから除外する列名のセットを指定します。
      # 設定可能な値: 除外する列名の文字列セット
      # 省略時: 全列へのアクセスが許可されます（空のワイルドカード）
      excluded_column_names = ["ssn", "credit_card"]
    }

    #-----------------------------------------------------------
    # 行フィルター設定
    #-----------------------------------------------------------

    # row_filter (Optional)
    # 設定内容: 行レベルフィルタリングのためのPartiQLフィルター式設定ブロックです。
    #   特定の条件に合致する行のみへのアクセスを許可する場合に使用します。
    # 参考: https://docs.aws.amazon.com/lake-formation/latest/dg/data-filtering.html
    row_filter {

      # filter_expression (Optional)
      # 設定内容: 行レベルフィルタリングのPartiQL述語式を指定します。
      # 設定可能な値: 有効なPartiQL述語式の文字列（例: "column='value'"）
      # 省略時: Terraformによって自動計算された値が使用されます
      # 注意: filter_expressionとall_rows_wildcardはいずれか一方を指定してください。
      #       行フィルターなしで列レベルのフィルタリングのみを適用する場合は
      #       all_rows_wildcardを使用してください。
      # 参考: https://docs.aws.amazon.com/lake-formation/latest/dg/data-filtering-notes.html
      filter_expression = "department='Marketing'"

      # all_rows_wildcard (Optional)
      # 設定内容: 全行を対象とするワイルドカード設定ブロックです。
      #   行レベルフィルタリングなしに列レベルのフィルタリングのみを適用する場合に使用します。
      # 注意: filter_expressionとall_rows_wildcardはいずれか一方を指定してください。
      #       空のブロック {} として指定します。
      # all_rows_wildcard {}
    }
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト時間を設定するブロックです。
  timeouts {

    # create (Optional)
    # 設定内容: リソース作成操作のタイムアウト時間を指定します。
    # 設定可能な値: 時間単位のサフィックスを含む文字列（例: "30s", "5m", "2h45m"）
    #   有効な時間単位: "s"（秒）、"m"（分）、"h"（時間）
    # 省略時: プロバイダーのデフォルトタイムアウトを使用
    create = "20m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: プロバイダーが生成する識別子。
#        database_name,name,table_catalog_id,table_name の形式で構成されます。
#---------------------------------------------------------------
