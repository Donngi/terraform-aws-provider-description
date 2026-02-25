#---------------------------------------------------------------
# AWS Glue Catalog Database
#---------------------------------------------------------------
#
# AWS Glue データカタログにデータベースをプロビジョニングするリソースです。
# データカタログのデータベースは、メタデータテーブルを整理・管理するための
# 論理的なコンテナとして機能します。Amazon Athena、AWS Glue ETL、
# Amazon Redshift Spectrum などの AWS サービスと統合して利用されます。
#
# AWS公式ドキュメント:
#   - データベースの作成: https://docs.aws.amazon.com/glue/latest/dg/define-database.html
#   - データカタログの概要: https://docs.aws.amazon.com/glue/latest/dg/populate-data-catalog.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/glue_catalog_database
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_glue_catalog_database" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: データベースの名前を指定します。
  # 設定可能な値: 小文字英字、数字、アンダースコアが使用可能な文字列
  # 注意: Amazon Athena からアクセスする場合は英数字とアンダースコアのみ使用推奨
  name = "my_catalog_database"

  # catalog_id (Optional)
  # 設定内容: データベースを作成する Glue カタログの ID を指定します。
  # 設定可能な値: 有効な AWS アカウント ID
  # 省略時: プロバイダーに設定されている AWS アカウント ID が使用されます
  catalog_id = null

  # description (Optional)
  # 設定内容: データベースの説明文を指定します。
  # 設定可能な値: 任意の文字列
  # 省略時: 説明なし
  description = "My Glue catalog database"

  # location_uri (Optional)
  # 設定内容: データベースのロケーション URI を指定します（例: HDFS パス）。
  # 設定可能な値: 有効な URI 文字列（例: s3://my-bucket/path/）
  # 省略時: ロケーションは設定されません
  location_uri = null

  # parameters (Optional)
  # 設定内容: データベースのパラメーターとプロパティを定義するキーバリューペアのマップを指定します。
  # 設定可能な値: 文字列のキーバリューマップ
  # 省略時: パラメーターは設定されません
  parameters = {}

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
  # テーブルデフォルトパーミッション設定
  #-------------------------------------------------------------

  # create_table_default_permission (Optional)
  # 設定内容: データベース内のテーブルに対してプリンシパルに付与するデフォルトパーミッションの設定ブロックです。
  # 関連機能: AWS Lake Formation
  #   Lake Formation でのアクセス制御と連携してテーブルへのデフォルト権限を管理します。
  #   - https://docs.aws.amazon.com/glue/latest/dg/define-database.html
  create_table_default_permission {

    # permissions (Optional)
    # 設定内容: プリンシパルに付与するパーミッションのセットを指定します。
    # 設定可能な値:
    #   - "ALL": 全パーミッション
    #   - "SELECT": データ選択パーミッション
    #   - "ALTER": テーブル変更パーミッション
    #   - "DROP": テーブル削除パーミッション
    #   - "DELETE": データ削除パーミッション
    #   - "INSERT": データ挿入パーミッション
    #   - "CREATE_DATABASE": データベース作成パーミッション
    #   - "CREATE_TABLE": テーブル作成パーミッション
    #   - "DATA_LOCATION_ACCESS": データロケーションアクセスパーミッション
    # 省略時: パーミッションは設定されません
    permissions = ["SELECT"]

    # principal (Optional)
    # 設定内容: パーミッションを付与するプリンシパルの設定ブロックです。
    # 省略時: プリンシパルは設定されません
    principal {

      # data_lake_principal_identifier (Optional)
      # 設定内容: Lake Formation プリンシパルの識別子を指定します。
      # 設定可能な値:
      #   - "IAM_ALLOWED_PRINCIPALS": IAM 許可プリンシパル（IAM ユーザーとロール）
      #   - IAM ユーザー ARN（例: arn:aws:iam::123456789012:user/myuser）
      #   - IAM ロール ARN（例: arn:aws:iam::123456789012:role/myrole）
      # 省略時: 識別子は設定されません
      data_lake_principal_identifier = "IAM_ALLOWED_PRINCIPALS"
    }
  }

  #-------------------------------------------------------------
  # フェデレーテッドデータベース設定
  #-------------------------------------------------------------

  # federated_database (Optional)
  # 設定内容: AWS Glue データカタログ外部のエンティティを参照するフェデレーテッドデータベースの設定ブロックです。
  # 関連機能: Glue フェデレーテッドカタログ
  #   外部メタストア（例: Apache Hive Metastore）とのフェデレーション連携を設定します。
  #   - https://docs.aws.amazon.com/glue/latest/dg/populate-data-catalog.html
  # 注意: federated_database と target_database は同時に設定できません
  federated_database {

    # connection_name (Optional)
    # 設定内容: 外部メタストアへの接続名を指定します。
    # 設定可能な値: 有効な Glue 接続名
    # 省略時: 接続名は設定されません
    connection_name = "my-external-metastore-connection"

    # identifier (Optional)
    # 設定内容: フェデレーテッドデータベースの一意の識別子を指定します。
    # 設定可能な値: 外部メタストアでのデータベース識別子文字列
    # 省略時: 識別子は設定されません
    identifier = "external-database-id"
  }

  #-------------------------------------------------------------
  # ターゲットデータベース設定（リソースリンク）
  #-------------------------------------------------------------

  # target_database (Optional)
  # 設定内容: リソースリンク用のターゲットデータベースの設定ブロックです。
  #   このデータベースを別のデータカタログデータベースへのリンクとして設定します。
  # 関連機能: データベースリソースリンク
  #   ローカルまたは共有データベースへのリンクを作成し、クロスアカウントアクセスを実現します。
  #   リソースリンクは現在 AWS Lake Formation でのみ利用可能です。
  #   - https://docs.aws.amazon.com/glue/latest/dg/define-database.html
  # 注意: target_database と federated_database は同時に設定できません
  target_database {

    # catalog_id (Required)
    # 設定内容: データベースが存在するデータカタログの ID を指定します。
    # 設定可能な値: 有効な AWS アカウント ID
    catalog_id = "123456789012"

    # database_name (Required)
    # 設定内容: リンク先のカタログデータベース名を指定します。
    # 設定可能な値: 有効な Glue データベース名の文字列
    database_name = "target_database_name"

    # region (Optional)
    # 設定内容: ターゲットデータベースが存在するリージョンを指定します。
    # 設定可能な値: 有効な AWS リージョンコード（例: ap-northeast-1, us-east-1）
    # 省略時: 現在のリージョンが使用されます
    region = null
  }

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 省略時: タグは設定されません
  tags = {
    Name        = "my-catalog-database"
    Environment = "production"
    ManagedBy   = "terraform"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: Glue カタログデータベースの Amazon Resource Name (ARN)
# - id: カタログ ID とデータベース名を組み合わせた識別子
# - tags_all: プロバイダーの default_tags 設定から継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
