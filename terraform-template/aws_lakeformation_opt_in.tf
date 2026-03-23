#---------------------------------------------------------------
# AWS Lake Formation Opt In
#---------------------------------------------------------------
#
# AWS Lake Formation のハイブリッドアクセスモードにおいて、特定のプリンシパルを
# Lake Formation 権限管理の対象として選択（オプトイン）するリソースです。
# ハイブリッドアクセスモードでは、オプトインしたプリンシパルは Lake Formation 権限と
# IAM 権限の両方でデータカタログリソースへのアクセスが制御されます。
# オプトインしていないプリンシパルは引き続き IAM 権限のみでアクセスできます。
#
# AWS公式ドキュメント:
#   - ハイブリッドアクセスモード: https://docs.aws.amazon.com/lake-formation/latest/dg/hybrid-access-mode.html
#   - クロスアカウントデータ共有: https://docs.aws.amazon.com/lake-formation/latest/dg/cross-account-permissions.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lakeformation_opt_in
#
# Provider Version: 6.37.0
# Generated: 2026-03-20
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
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # プリンシパル設定
  #-------------------------------------------------------------

  # principal (Required)
  # 設定内容: Lake Formation 権限管理にオプトインする IAM プリンシパルの設定ブロックです。
  #   サポートされるプリンシパルは IAM ユーザーまたは IAM ロールです。
  # 参考: https://docs.aws.amazon.com/lake-formation/latest/dg/hybrid-access-mode.html
  principal {

    # data_lake_principal_identifier (Required)
    # 設定内容: Lake Formation プリンシパルの識別子を指定します。
    # 設定可能な値: IAM ユーザーまたは IAM ロールの ARN
    #   例: "arn:aws:iam::123456789012:user/example-user"
    #       "arn:aws:iam::123456789012:role/example-role"
    data_lake_principal_identifier = "arn:aws:iam::123456789012:role/example-role"
  }

  #-------------------------------------------------------------
  # リソースデータ設定
  #-------------------------------------------------------------

  # resource_data (Required)
  # 設定内容: オプトイン対象のデータカタログリソースの種別と詳細を指定する設定ブロックです。
  #   以下のサブブロックのうち、いずれか1つを指定します:
  #   catalog / data_cells_filter / data_location / database /
  #   lf_tag / lf_tag_expression / lf_tag_policy / table / table_with_columns
  resource_data {

    #-------------------------------------------------------------
    # カタログ設定
    #-------------------------------------------------------------

    # catalog (Optional)
    # 設定内容: データカタログ全体をリソース対象とする場合の設定ブロックです。
    # 参考: https://docs.aws.amazon.com/lake-formation/latest/dg/hybrid-access-mode.html
    catalog {

      # id (Optional)
      # 設定内容: データカタログの識別子を指定します。
      # 設定可能な値: AWSアカウントID（文字列）
      # 省略時: 呼び出し元のアカウント ID が使用されます。
      id = null
    }

    #-------------------------------------------------------------
    # データセルフィルター設定
    #-------------------------------------------------------------

    # data_cells_filter (Optional)
    # 設定内容: データセルフィルターをリソース対象とする場合の設定ブロックです。
    #   特定のデータベース・テーブルに紐付いたフィルターを指定します。
    data_cells_filter {

      # database_name (Optional)
      # 設定内容: フィルターが属するデータベース名を指定します。
      # 設定可能な値: Glue データカタログ内のデータベース名（文字列）
      database_name = null

      # name (Optional)
      # 設定内容: データセルフィルターの名前を指定します。
      # 設定可能な値: フィルター名（文字列）
      name = null

      # table_catalog_id (Optional)
      # 設定内容: テーブルが属するカタログの ID を指定します。
      # 設定可能な値: AWSアカウントID（文字列）
      # 省略時: 呼び出し元のアカウント ID が使用されます。
      table_catalog_id = null

      # table_name (Optional)
      # 設定内容: フィルターが対象とするテーブル名を指定します。
      # 設定可能な値: テーブル名（文字列）
      table_name = null
    }

    #-------------------------------------------------------------
    # データロケーション設定
    #-------------------------------------------------------------

    # data_location (Optional)
    # 設定内容: Amazon S3 パスのデータロケーションをリソース対象とする場合の設定ブロックです。
    # 参考: https://docs.aws.amazon.com/lake-formation/latest/dg/hybrid-access-mode.html
    data_location {

      # resource_arn (Required)
      # 設定内容: データロケーションリソースを一意に識別する ARN を指定します。
      # 設定可能な値: 有効な Amazon S3 バケットまたはプレフィックスの ARN
      #   例: "arn:aws:s3:::example-bucket"
      resource_arn = "arn:aws:s3:::example-bucket"

      # catalog_id (Optional)
      # 設定内容: ロケーションが Lake Formation に登録されているカタログの識別子を指定します。
      # 設定可能な値: AWSアカウントID（文字列）
      # 省略時: 呼び出し元のアカウント ID が使用されます。
      catalog_id = null
    }

    #-------------------------------------------------------------
    # データベース設定
    #-------------------------------------------------------------

    # database (Optional)
    # 設定内容: データカタログ内のデータベースをリソース対象とする場合の設定ブロックです。
    # 参考: https://docs.aws.amazon.com/lake-formation/latest/dg/hybrid-access-mode.html
    database {

      # name (Required)
      # 設定内容: データベースリソースの名前を指定します。データカタログ内で一意です。
      # 設定可能な値: Glue データカタログ内のデータベース名（文字列）
      name = "example_database"

      # catalog_id (Optional)
      # 設定内容: データカタログの識別子を指定します。
      # 設定可能な値: AWSアカウントID（文字列）
      # 省略時: 呼び出し元のアカウント ID が使用されます。
      catalog_id = null
    }

    #-------------------------------------------------------------
    # LF タグ設定
    #-------------------------------------------------------------

    # lf_tag (Optional)
    # 設定内容: リソースに関連付けられた LF タグのキーと値をリソース対象とする場合の設定ブロックです。
    # 参考: https://docs.aws.amazon.com/lake-formation/latest/dg/hybrid-access-mode.html
    lf_tag {

      # key (Required)
      # 設定内容: LF タグのキーを指定します。
      # 設定可能な値: タグキー名（文字列）
      key = "environment"

      # values (Required)
      # 設定内容: LF タグの値のセットを指定します。少なくとも1つの値が必要です。
      # 設定可能な値: タグ値の文字列セット（各値は1〜255文字）
      values = ["production"]

      # catalog_id (Optional)
      # 設定内容: データカタログの識別子を指定します。
      # 設定可能な値: AWSアカウントID（文字列）
      # 省略時: 呼び出し元のアカウント ID が使用されます。
      catalog_id = null
    }

    #-------------------------------------------------------------
    # LF タグ式設定
    #-------------------------------------------------------------

    # lf_tag_expression (Optional)
    # 設定内容: 保存された LF タグ式をリソース対象とする場合の設定ブロックです。
    #   1つ以上の LF タグキー:バリューペアで構成される論理式です。
    # 参考: https://docs.aws.amazon.com/lake-formation/latest/dg/hybrid-access-mode.html
    lf_tag_expression {

      # name (Required)
      # 設定内容: 権限を付与する LF タグ式の名前を指定します。
      # 設定可能な値: LF タグ式名（文字列）
      name = "example-lf-tag-expression"

      # catalog_id (Optional)
      # 設定内容: データカタログの識別子を指定します。
      # 設定可能な値: AWSアカウントID（文字列）
      # 省略時: 呼び出し元のアカウント ID が使用されます。
      catalog_id = null
    }

    #-------------------------------------------------------------
    # LF タグポリシー設定
    #-------------------------------------------------------------

    # lf_tag_policy (Optional)
    # 設定内容: LF タグ条件または保存された LF タグ式の一覧でリソースの
    #   LF タグポリシーを定義する場合の設定ブロックです。
    # 参考: https://docs.aws.amazon.com/lake-formation/latest/dg/hybrid-access-mode.html
    lf_tag_policy {

      # resource_type (Required)
      # 設定内容: LF タグポリシーが適用されるリソースタイプを指定します。
      # 設定可能な値:
      #   - "DATABASE": データベースリソースに適用
      #   - "TABLE": テーブルリソースに適用
      resource_type = "TABLE"

      # catalog_id (Optional)
      # 設定内容: データカタログの識別子を指定します。
      # 設定可能な値: AWSアカウントID（文字列）
      # 省略時: 呼び出し元のアカウント ID が使用されます。
      catalog_id = null

      # expression (Optional)
      # 設定内容: リソースの LF タグポリシーに適用する LF タグ条件または
      #   保存済み式のリストを指定します。
      # 設定可能な値: LF タグ条件の文字列リスト
      # 注意: expression_name と排他的（どちらか一方のみ指定可能）
      expression = null

      # expression_name (Optional)
      # 設定内容: 保存された LF タグ式の名前を指定します。
      #   指定した場合、保存済み式の本文に一致する LF タグが割り当てられた
      #   データカタログリソースに権限が付与されます。
      # 設定可能な値: 保存済み LF タグ式名（文字列）
      # 注意: expression と排他的（どちらか一方のみ指定可能）
      expression_name = null
    }

    #-------------------------------------------------------------
    # テーブル設定
    #-------------------------------------------------------------

    # table (Optional)
    # 設定内容: データカタログ内のテーブルをリソース対象とする場合の設定ブロックです。
    # 参考: https://docs.aws.amazon.com/lake-formation/latest/dg/hybrid-access-mode.html
    table {

      # database_name (Required)
      # 設定内容: テーブルが属するデータベースの名前を指定します。データカタログ内で一意です。
      # 設定可能な値: Glue データカタログ内のデータベース名（文字列）
      database_name = "example_database"

      # name (Optional)
      # 設定内容: テーブルの名前を指定します。
      # 設定可能な値: テーブル名（文字列）
      # 注意: name または wildcard のいずれか一方を指定する必要があります。
      name = null

      # wildcard (Optional)
      # 設定内容: 指定されたデータベース配下のすべてのテーブルを対象とするかを指定します。
      # 設定可能な値:
      #   - true: データベース配下のすべてのテーブルを対象
      #   - false: 特定のテーブルのみを対象
      # 注意: name または wildcard のいずれか一方を指定する必要があります。
      wildcard = false

      # catalog_id (Optional)
      # 設定内容: データカタログの識別子を指定します。
      # 設定可能な値: AWSアカウントID（文字列）
      # 省略時: 呼び出し元のアカウント ID が使用されます。
      catalog_id = null
    }

    #-------------------------------------------------------------
    # カラム付きテーブル設定
    #-------------------------------------------------------------

    # table_with_columns (Optional)
    # 設定内容: データカタログ内の特定のカラムを持つテーブルをリソース対象とする場合の設定ブロックです。
    #   このリソースに対する権限を持つプリンシパルは、データカタログのテーブルのカラムから
    #   メタデータと Amazon S3 の基盤データを選択できます。
    # 参考: https://docs.aws.amazon.com/lake-formation/latest/dg/hybrid-access-mode.html
    table_with_columns {

      # database_name (Required)
      # 設定内容: テーブルが属するデータベースの名前を指定します。データカタログ内で一意です。
      # 設定可能な値: Glue データカタログ内のデータベース名（文字列）
      database_name = "example_database"

      # name (Required)
      # 設定内容: テーブルの名前を指定します。
      # 設定可能な値: テーブル名（文字列）
      name = "example_table"

      # catalog_id (Optional)
      # 設定内容: データカタログの識別子を指定します。
      # 設定可能な値: AWSアカウントID（文字列）
      # 省略時: 呼び出し元のアカウント ID が使用されます。
      catalog_id = null

      # column_names (Optional)
      # 設定内容: テーブルのカラム名のリストを指定します。
      # 設定可能な値: カラム名の文字列セット
      # 注意: column_names または column_wildcard のいずれか一方を指定する必要があります。
      column_names = null

      #-------------------------------------------------------------
      # カラムワイルドカード設定
      #-------------------------------------------------------------

      # column_wildcard (Optional)
      # 設定内容: カラムのワイルドカードを指定する場合の設定ブロックです。
      #   column_names の代わりに使用します。
      # 注意: column_names または column_wildcard のいずれか一方を指定する必要があります。
      column_wildcard {

        # excluded_column_names (Optional)
        # 設定内容: ワイルドカード適用から除外するカラム名のセットを指定します。
        # 設定可能な値: 除外するカラム名の文字列セット
        # 省略時: すべてのカラムがワイルドカードの対象になります。
        excluded_column_names = null
      }
    }
  }

  #-------------------------------------------------------------
  # 条件設定（読み取り専用）
  #-------------------------------------------------------------

  # condition - このブロックは読み取り専用です（computed only）。
  # 設定内容: 権限およびオプトインに適用される Lake Formation 条件式を保持します。
  #   Terraform によって自動的に設定されるブロックのため、手動での設定はできません。
  #   - expression: Lake Formation が評価する条件式の内容（string, computed only）
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - last_modified: レコードの最終変更日時
#
# - last_updated_by: レコードを最後に更新したユーザー
#
# - condition ブロック: 権限およびオプトインに適用される Lake Formation 条件式ブロック。
#   - expression (string): 条件式の内容（読み取り専用）
#
#---------------------------------------------------------------
