#---------------------------------------------------------------
# AWS Lake Formation Resource LF-Tag
#---------------------------------------------------------------
#
# AWS Lake FormationのデータカタログリソースにLF-Tagを割り当てるリソースです。
# データベース・テーブル・カラムといったリソースにLF-Tagキーと値を関連付けることで、
# タグベースのアクセス制御（LF-TBAC: Lake Formation Tag-Based Access Control）を実現します。
# LF-TagはAWS Glue Data Catalogリソースへのアクセス制御を細かく管理するために使用されます。
#
# AWS公式ドキュメント:
#   - タグベースアクセス制御: https://docs.aws.amazon.com/lake-formation/latest/dg/tag-based-access-control.html
#   - LF-Tagのリソースへの割り当て: https://docs.aws.amazon.com/lake-formation/latest/dg/TBAC-assigning-tags.html
#   - AddLFTagsToResource API: https://docs.aws.amazon.com/lake-formation/latest/APIReference/API_AddLFTagsToResource.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lakeformation_resource_lf_tag
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_lakeformation_resource_lf_tag" "example" {
  #-------------------------------------------------------------
  # カタログ設定
  #-------------------------------------------------------------

  # catalog_id (Optional)
  # 設定内容: LF-Tagの割り当て先リソースが属するデータカタログのIDを指定します。
  # 設定可能な値: 有効なAWSアカウントID（12桁の数字）
  # 省略時: プロバイダーに設定されたAWSアカウントIDが使用されます。
  catalog_id = null

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用します。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # LF-Tag設定
  #-------------------------------------------------------------

  # lf_tag (Required)
  # 設定内容: リソースに割り当てるLF-Tagを指定するブロックです。
  #   1つ以上のLF-Tagを指定できます。
  # 参考: https://docs.aws.amazon.com/lake-formation/latest/dg/TBAC-assigning-tags.html
  lf_tag {

    # key (Required)
    # 設定内容: 割り当てるLF-Tagのキー名を指定します。
    # 設定可能な値: 事前にaws_lakeformation_lf_tagで定義されたキー名の文字列
    key = "module"

    # value (Required)
    # 設定内容: 割り当てるLF-Tagの値を指定します。
    # 設定可能な値: 対象キーで定義された値のリストに含まれる文字列
    value = "Orders"

    # catalog_id (Optional)
    # 設定内容: LF-Tagが定義されているデータカタログのIDを指定します。
    # 設定可能な値: 有効なAWSアカウントID（12桁の数字）
    # 省略時: Terraformによって自動計算された値が使用されます。
    catalog_id = null
  }

  #-------------------------------------------------------------
  # データベースリソース設定
  #-------------------------------------------------------------

  # database (Optional)
  # 設定内容: LF-Tagを割り当てるデータベースリソースを指定するブロックです。
  #   database, table, table_with_columns のいずれか1つを指定する必要があります。
  # 参考: https://docs.aws.amazon.com/lake-formation/latest/dg/TBAC-assigning-tags.html
  database {

    # name (Required)
    # 設定内容: LF-Tagを割り当てるデータベースの名前を指定します。
    # 設定可能な値: AWS Glue Data Catalogの有効なデータベース名
    name = "example_database"

    # catalog_id (Optional)
    # 設定内容: データベースが属するデータカタログのIDを指定します。
    # 設定可能な値: 有効なAWSアカウントID（12桁の数字）
    # 省略時: プロバイダーに設定されたAWSアカウントIDが使用されます。
    catalog_id = null
  }

  #-------------------------------------------------------------
  # テーブルリソース設定
  #-------------------------------------------------------------

  # table (Optional)
  # 設定内容: LF-Tagを割り当てるテーブルリソースを指定するブロックです。
  #   database, table, table_with_columns のいずれか1つを指定する必要があります。
  # 参考: https://docs.aws.amazon.com/lake-formation/latest/dg/TBAC-assigning-tags.html
  # table {

  #   # database_name (Required)
  #   # 設定内容: テーブルが属するデータベースの名前を指定します。
  #   # 設定可能な値: AWS Glue Data Catalogの有効なデータベース名
  #   database_name = "example_database"

  #   # name (Optional)
  #   # 設定内容: LF-Tagを割り当てる特定のテーブル名を指定します。
  #   # 設定可能な値: AWS Glue Data Catalogの有効なテーブル名
  #   # 省略時: wildcardをtrueに設定することでデータベース内の全テーブルを対象にできます。
  #   name = "example_table"

  #   # wildcard (Optional)
  #   # 設定内容: データベース内の全テーブルを対象とするかどうかを指定します。
  #   # 設定可能な値: true（全テーブルを対象）/ false（特定テーブルのみ）
  #   # 省略時: falseとして扱われます。nameを指定した場合はfalseを使用してください。
  #   wildcard = false

  #   # catalog_id (Optional)
  #   # 設定内容: テーブルが属するデータカタログのIDを指定します。
  #   # 設定可能な値: 有効なAWSアカウントID（12桁の数字）
  #   # 省略時: プロバイダーに設定されたAWSアカウントIDが使用されます。
  #   catalog_id = null
  # }

  #-------------------------------------------------------------
  # カラムフィルター付きテーブルリソース設定
  #-------------------------------------------------------------

  # table_with_columns (Optional)
  # 設定内容: 特定のカラムを対象にLF-Tagを割り当てるテーブルリソースを指定するブロックです。
  #   database, table, table_with_columns のいずれか1つを指定する必要があります。
  # 参考: https://docs.aws.amazon.com/lake-formation/latest/dg/TBAC-assigning-tags.html
  # table_with_columns {

  #   # database_name (Required)
  #   # 設定内容: テーブルが属するデータベースの名前を指定します。
  #   # 設定可能な値: AWS Glue Data Catalogの有効なデータベース名
  #   database_name = "example_database"

  #   # name (Required)
  #   # 設定内容: LF-Tagを割り当てるテーブルの名前を指定します。
  #   # 設定可能な値: AWS Glue Data Catalogの有効なテーブル名
  #   name = "example_table"

  #   # column_names (Optional)
  #   # 設定内容: LF-Tagを割り当てるカラム名のセットを指定します。
  #   # 設定可能な値: カラム名の文字列セット
  #   # 省略時: column_wildcardを使用して対象カラムを指定してください。
  #   column_names = ["column1", "column2"]

  #   # catalog_id (Optional)
  #   # 設定内容: テーブルが属するデータカタログのIDを指定します。
  #   # 設定可能な値: 有効なAWSアカウントID（12桁の数字）
  #   # 省略時: プロバイダーに設定されたAWSアカウントIDが使用されます。
  #   catalog_id = null

  #   # column_wildcard (Optional)
  #   # 設定内容: 除外カラムを指定したワイルドカード設定ブロックです。
  #   #   特定カラムを除くすべてのカラムにLF-Tagを割り当てる場合に使用します。
  #   # 注意: column_namesとcolumn_wildcardはいずれか一方を使用してください。
  #   column_wildcard {

  #     # excluded_column_names (Optional)
  #     # 設定内容: LF-Tag割り当てから除外するカラム名のセットを指定します。
  #     # 設定可能な値: 除外するカラム名の文字列セット
  #     # 省略時: 全カラムにLF-Tagが割り当てられます。
  #     excluded_column_names = ["ssn", "credit_card"]
  #   }
  # }

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

    # delete (Optional)
    # 設定内容: リソース削除操作のタイムアウト時間を指定します。
    # 設定可能な値: 時間単位のサフィックスを含む文字列（例: "30s", "5m", "2h45m"）
    #   有効な時間単位: "s"（秒）、"m"（分）、"h"（時間）
    # 省略時: プロバイダーのデフォルトタイムアウトを使用
    delete = "20m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: プロバイダーが生成する識別子。
#        リソース種別・カタログID・データベース名・テーブル名・タグキーと値を組み合わせた文字列。
#---------------------------------------------------------------
