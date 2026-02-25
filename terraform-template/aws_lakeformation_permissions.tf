#---------------------------------------------------------------
# AWS Lake Formation Permissions
#---------------------------------------------------------------
#
# AWS Lake Formationのアクセス権限を管理するリソースです。
# IAMプリンシパル（ユーザー、ロール）に対して、データカタログ、データベース、
# テーブル、データロケーション、LF-Tag、データセルフィルターなど
# 様々なリソースへのアクセス権限を付与します。
#
# 注意: このリソースは「許可型」モデルで権限を管理します。
#       データベース、テーブルのいずれか1つのブロックのみを指定できます。
#       catalog_resource, data_location, database, table, table_with_columns,
#       lf_tag, lf_tag_policy, data_cells_filter のうち1つのみ指定してください。
#
# AWS公式ドキュメント:
#   - Lake Formation GrantPermissions API: https://docs.aws.amazon.com/lake-formation/latest/APIReference/API_GrantPermissions.html
#   - Lake Formation 権限リファレンス: https://docs.aws.amazon.com/lake-formation/latest/dg/lf-permissions-reference.html
#   - Lake Formation セキュリティ: https://docs.aws.amazon.com/lake-formation/latest/dg/security.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lakeformation_permissions
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_lakeformation_permissions" "example" {
  #-------------------------------------------------------------
  # プリンシパル設定
  #-------------------------------------------------------------

  # principal (Required)
  # 設定内容: 権限を付与するIAMプリンシパルのARNを指定します。
  # 設定可能な値: IAMユーザー/ロールのARN（例: "arn:aws:iam::123456789012:role/MyRole"）
  #               Lake Formation Data Access（"IAM_ALLOWED_PRINCIPALS"）
  principal = "arn:aws:iam::123456789012:role/MyRole"

  #-------------------------------------------------------------
  # 権限設定
  #-------------------------------------------------------------

  # permissions (Required)
  # 設定内容: プリンシパルに付与するLake Formation権限のセットを指定します。
  # 設定可能な値:
  #   - "ALL": 全権限（リソースタイプに依存）
  #   - "SELECT": テーブルデータの参照
  #   - "ALTER": テーブル定義の変更
  #   - "DROP": テーブルの削除
  #   - "DELETE": データの削除
  #   - "INSERT": データの挿入
  #   - "DESCRIBE": リソース定義の参照
  #   - "CREATE_TABLE": テーブルの作成（データベースリソースに対して）
  #   - "CREATE_DATABASE": データベースの作成（カタログリソースに対して）
  #   - "DATA_LOCATION_ACCESS": S3データロケーションへのアクセス
  #   - "CREATE_TAG": LF-Tagの作成
  #   - "ASSOCIATE": LF-Tagのリソースへの関連付け
  #   - "GRANT_WITH_LF_TAG_EXPRESSION": LF-Tag式を使った権限付与
  # 参考: https://docs.aws.amazon.com/lake-formation/latest/dg/lf-permissions-reference.html
  permissions = ["SELECT", "DESCRIBE"]

  # permissions_with_grant_option (Optional)
  # 設定内容: 他のプリンシパルへの権限付与を可能にする権限のセットを指定します。
  # 設定可能な値: permissionsと同じ値のセット（permissionsのサブセットである必要があります）
  # 省略時: 権限付与オプションなしとして扱われます。
  # 注意: ここに指定した権限はpermissionsにも含まれている必要があります。
  permissions_with_grant_option = []

  #-------------------------------------------------------------
  # カタログ設定
  #-------------------------------------------------------------

  # catalog_id (Optional)
  # 設定内容: 権限を付与するデータカタログのIDを指定します。
  # 設定可能な値: AWSアカウントID（12桁の数字）
  # 省略時: 現在のAWSアカウントIDが使用されます。
  catalog_id = null

  # catalog_resource (Optional)
  # 設定内容: カタログリソース全体に対して権限を付与するかを指定します。
  # 設定可能な値:
  #   - true: カタログリソース全体に権限を付与
  #   - false: カタログリソース全体への権限付与を行わない
  # 省略時: falseとして扱われます。
  # 注意: catalog_resourceをtrueにする場合、他のリソース指定ブロックは指定できません。
  catalog_resource = false

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
  # データロケーション設定
  #-------------------------------------------------------------

  # data_location (Optional, 最大1ブロック)
  # 設定内容: S3データロケーションに対する権限を設定します。
  # 注意: data_locationを指定する場合、database/table等の他のリソースブロックは指定できません。
  data_location {
    # arn (Required)
    # 設定内容: 権限を付与するS3バケットまたはプレフィックスのARNを指定します。
    # 設定可能な値: S3バケット/プレフィックスのARN（例: "arn:aws:s3:::my-data-lake-bucket"）
    arn = "arn:aws:s3:::my-data-lake-bucket"

    # catalog_id (Optional)
    # 設定内容: データロケーションを所有するAWSアカウントのIDを指定します。
    # 設定可能な値: AWSアカウントID（12桁の数字）
    # 省略時: 現在のAWSアカウントIDが使用されます。
    catalog_id = null
  }

  #-------------------------------------------------------------
  # データベース設定
  #-------------------------------------------------------------

  # database (Optional, 最大1ブロック)
  # 設定内容: Glueデータカタログのデータベースに対する権限を設定します。
  # 注意: databaseを指定する場合、data_location/table等の他のリソースブロックは指定できません。
  database {
    # name (Required)
    # 設定内容: 権限を付与するデータベース名を指定します。
    # 設定可能な値: 既存のGlueデータベース名
    name = "my_database"

    # catalog_id (Optional)
    # 設定内容: データベースを所有するAWSアカウントのIDを指定します。
    # 設定可能な値: AWSアカウントID（12桁の数字）
    # 省略時: 現在のAWSアカウントIDが使用されます。
    catalog_id = null
  }

  #-------------------------------------------------------------
  # テーブル設定
  #-------------------------------------------------------------

  # table (Optional, 最大1ブロック)
  # 設定内容: Glueデータカタログのテーブルに対する権限を設定します。
  # 注意: tableを指定する場合、database/table_with_columns等の他のリソースブロックは指定できません。
  table {
    # database_name (Required)
    # 設定内容: テーブルが属するデータベース名を指定します。
    # 設定可能な値: 既存のGlueデータベース名
    database_name = "my_database"

    # name (Optional)
    # 設定内容: 権限を付与するテーブル名を指定します。
    # 設定可能な値: 既存のGlueテーブル名
    # 省略時: wildcardがtrueの場合、全テーブルが対象になります。
    # 注意: nameまたはwildcardのどちらか一方を指定する必要があります。
    name = null

    # wildcard (Optional)
    # 設定内容: データベース内の全テーブルに対して権限を付与するかを指定します。
    # 設定可能な値:
    #   - true: データベース内の全テーブルに権限を付与
    #   - false: nameで指定した特定テーブルに権限を付与
    # 省略時: falseとして扱われます。
    # 注意: nameまたはwildcardのどちらか一方を指定する必要があります。
    wildcard = false

    # catalog_id (Optional)
    # 設定内容: テーブルを所有するAWSアカウントのIDを指定します。
    # 設定可能な値: AWSアカウントID（12桁の数字）
    # 省略時: 現在のAWSアカウントIDが使用されます。
    catalog_id = null
  }

  #-------------------------------------------------------------
  # カラム指定テーブル設定
  #-------------------------------------------------------------

  # table_with_columns (Optional, 最大1ブロック)
  # 設定内容: Glueデータカタログのテーブルの特定カラムに対する権限を設定します。
  # 注意: table_with_columnsを指定する場合、table等の他のリソースブロックは指定できません。
  table_with_columns {
    # database_name (Required)
    # 設定内容: テーブルが属するデータベース名を指定します。
    # 設定可能な値: 既存のGlueデータベース名
    database_name = "my_database"

    # name (Required)
    # 設定内容: 権限を付与するテーブル名を指定します。
    # 設定可能な値: 既存のGlueテーブル名
    name = "my_table"

    # column_names (Optional)
    # 設定内容: 権限を付与するカラム名のセットを指定します。
    # 設定可能な値: テーブルに存在するカラム名の文字列セット
    # 省略時: excludedcolumn_namesまたはwildcardを使用します。
    # 注意: column_namesまたはexcluded_column_names/wildcardのどちらか一方を指定します。
    column_names = ["column1", "column2"]

    # excluded_column_names (Optional)
    # 設定内容: 権限から除外するカラム名のセットを指定します。
    # 設定可能な値: テーブルに存在するカラム名の文字列セット
    # 省略時: column_namesまたはwildcardを使用します。
    # 注意: excluded_column_namesを使う場合、wildcardをtrueにする必要があります。
    excluded_column_names = []

    # wildcard (Optional)
    # 設定内容: 全カラムに対して権限を付与するかを指定します。
    # 設定可能な値:
    #   - true: 全カラムに権限を付与（excluded_column_namesと併用可能）
    #   - false: column_namesで指定したカラムに権限を付与
    # 省略時: falseとして扱われます。
    wildcard = false

    # catalog_id (Optional)
    # 設定内容: テーブルを所有するAWSアカウントのIDを指定します。
    # 設定可能な値: AWSアカウントID（12桁の数字）
    # 省略時: 現在のAWSアカウントIDが使用されます。
    catalog_id = null
  }

  #-------------------------------------------------------------
  # LF-Tag設定
  #-------------------------------------------------------------

  # lf_tag (Optional, 最大1ブロック)
  # 設定内容: LF-Tag自体に対する権限を設定します（タグの管理権限）。
  # 注意: lf_tagを指定する場合、database/table等の他のリソースブロックは指定できません。
  lf_tag {
    # key (Required)
    # 設定内容: 権限を付与するLF-Tagのキーを指定します。
    # 設定可能な値: 既存のLF-Tagキー名
    key = "environment"

    # values (Required)
    # 設定内容: 権限を付与するLF-Tagの値セットを指定します。
    # 設定可能な値: LF-Tagキーに定義されている値の文字列セット
    values = ["production", "staging"]

    # catalog_id (Optional)
    # 設定内容: LF-Tagを所有するAWSアカウントのIDを指定します。
    # 設定可能な値: AWSアカウントID（12桁の数字）
    # 省略時: 現在のAWSアカウントIDが使用されます。
    catalog_id = null
  }

  #-------------------------------------------------------------
  # LF-Tagポリシー設定
  #-------------------------------------------------------------

  # lf_tag_policy (Optional, 最大1ブロック)
  # 設定内容: LF-Tag式に一致するリソースに対する権限を設定します（タグベースのアクセス制御）。
  # 注意: lf_tag_policyを指定する場合、database/table等の他のリソースブロックは指定できません。
  lf_tag_policy {
    # resource_type (Required)
    # 設定内容: LF-Tag式の対象リソースタイプを指定します。
    # 設定可能な値:
    #   - "DATABASE": データベースリソースを対象
    #   - "TABLE": テーブルリソースを対象
    resource_type = "TABLE"

    # catalog_id (Optional)
    # 設定内容: LF-Tagポリシーを所有するAWSアカウントのIDを指定します。
    # 設定可能な値: AWSアカウントID（12桁の数字）
    # 省略時: 現在のAWSアカウントIDが使用されます。
    catalog_id = null

    # expression (Required, 1件以上)
    # 設定内容: 権限適用対象を絞り込むLF-Tag式を指定します。
    # 注意: 複数のexpressionはAND条件として評価されます。
    expression {
      # key (Required)
      # 設定内容: フィルタリングに使用するLF-Tagのキーを指定します。
      # 設定可能な値: 既存のLF-Tagキー名
      key = "environment"

      # values (Required)
      # 設定内容: フィルタリングに使用するLF-Tagの値セットを指定します。
      # 設定可能な値: LF-Tagキーに定義されている値の文字列セット（OR条件として評価）
      values = ["production"]
    }
  }

  #-------------------------------------------------------------
  # データセルフィルター設定
  #-------------------------------------------------------------

  # data_cells_filter (Optional, 最大1ブロック)
  # 設定内容: データセルフィルターに対する権限を設定します（行/列レベルのアクセス制御）。
  # 注意: data_cells_filterを指定する場合、database/table等の他のリソースブロックは指定できません。
  data_cells_filter {
    # table_catalog_id (Required)
    # 設定内容: データセルフィルターのテーブルが属するカタログのIDを指定します。
    # 設定可能な値: AWSアカウントID（12桁の数字）
    table_catalog_id = "123456789012"

    # database_name (Required)
    # 設定内容: データセルフィルターのテーブルが属するデータベース名を指定します。
    # 設定可能な値: 既存のGlueデータベース名
    database_name = "my_database"

    # table_name (Required)
    # 設定内容: データセルフィルターが適用されるテーブル名を指定します。
    # 設定可能な値: 既存のGlueテーブル名
    table_name = "my_table"

    # name (Required)
    # 設定内容: 権限を付与するデータセルフィルターの名前を指定します。
    # 設定可能な値: 既存のデータセルフィルター名
    name = "my_data_cells_filter"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: 権限のID（principal, catalog_id, リソース識別子から生成）。
#---------------------------------------------------------------
