#---------------------------------------------------------------
# AWS Redshift Data Statement
#---------------------------------------------------------------
#
# Amazon Redshift Data APIを使用してRedshiftクラスターまたは
# Redshift Serverlessワークグループに対してSQL文を実行するリソースです。
# JDBC/ODBCドライバー不要でHTTPベースのAPIからSQLを実行できます。
#
# AWS公式ドキュメント:
#   - Redshift Data API: https://docs.aws.amazon.com/redshift/latest/mgmt/data-api.html
#   - ExecuteStatement APIリファレンス: https://docs.aws.amazon.com/redshift-data/latest/APIReference/API_ExecuteStatement.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/redshiftdata_statement
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_redshiftdata_statement" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # database (Required)
  # 設定内容: SQL文を実行するデータベースの名前を指定します。
  # 設定可能な値: 有効なRedshiftデータベース名の文字列
  database = "dev"

  # sql (Required)
  # 設定内容: 実行するSQL文のテキストを指定します。
  # 設定可能な値: DMLまたはDDLのSQL文字列
  # 注意: 名前付きパラメーターを使用する場合は parameters ブロックと合わせて使用
  sql = "CREATE GROUP group_name;"

  #-------------------------------------------------------------
  # 接続先設定
  #-------------------------------------------------------------

  # cluster_identifier (Optional)
  # 設定内容: 接続先のRedshiftクラスターのクラスター識別子を指定します。
  # 設定可能な値: 有効なRedshiftクラスター識別子の文字列
  # 省略時: workgroup_name を指定する場合は省略可能
  # 注意: Secrets Managerまたは一時的な認証情報を使用してクラスターに接続する場合に必須
  cluster_identifier = null

  # workgroup_name (Optional)
  # 設定内容: 接続先のRedshift Serverlessワークグループ名を指定します。
  # 設定可能な値: 有効なRedshift Serverlessワークグループ名の文字列
  # 省略時: cluster_identifier を指定する場合は省略可能
  # 注意: Secrets Managerまたは一時的な認証情報を使用してServerlessワークグループに接続する場合に必須
  workgroup_name = null

  #-------------------------------------------------------------
  # 認証設定
  #-------------------------------------------------------------

  # db_user (Optional)
  # 設定内容: SQL文の実行に使用するデータベースユーザー名を指定します。
  # 設定可能な値: 有効なRedshiftデータベースユーザー名の文字列
  # 省略時: secret_arn を使用した認証の場合は省略可能
  db_user = null

  # secret_arn (Optional)
  # 設定内容: データベースへのアクセスを有効にするシークレットの名前またはARNを指定します。
  # 設定可能な値: AWS Secrets Managerに登録された有効なシークレットARNまたは名前
  # 省略時: db_user を使用した一時的な認証情報方式を使用
  # 参考: https://docs.aws.amazon.com/redshift/latest/mgmt/data-api.html
  secret_arn = null

  #-------------------------------------------------------------
  # ステートメント設定
  #-------------------------------------------------------------

  # statement_name (Optional)
  # 設定内容: SQL文に付与する名前を指定します。クエリの識別に使用されます。
  # 設定可能な値: 任意の文字列
  # 省略時: 名前なしでSQL文が実行されます
  statement_name = null

  # with_event (Optional)
  # 設定内容: SQL文の実行後にAmazon EventBridgeイベントバスにイベントを送信するかを指定します。
  # 設定可能な値:
  #   - true: SQL文実行後にEventBridgeにイベントを送信
  #   - false: EventBridgeへのイベント送信なし
  # 省略時: false
  # 参考: https://docs.aws.amazon.com/eventbridge/latest/userguide/eb-what-is.html
  with_event = false

  #-------------------------------------------------------------
  # パラメーター設定
  #-------------------------------------------------------------

  # parameters (Optional)
  # 設定内容: SQL文で使用する名前付きパラメーターのリストを指定するブロックです。
  # 注意: sql フィールドでパラメーター参照（例: :param_name）を使用する場合に指定
  # 参考: https://docs.aws.amazon.com/redshift/latest/mgmt/pass-sql-statements.html
  parameters {
    # name (Required)
    # 設定内容: パラメーターの名前を指定します。SQL文内の :name 形式の参照と対応します。
    # 設定可能な値: 任意の文字列
    name = "param_name"

    # value (Required)
    # 設定内容: パラメーターの値を指定します。
    # 設定可能な値: 任意の文字列
    value = "param_value"
  }

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
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト時間を指定するブロックです。
  timeouts {
    # create (Optional)
    # 設定内容: リソース作成時のタイムアウト時間を指定します。
    # 設定可能な値: "60s", "10m", "2h" などの時間文字列
    # 省略時: プロバイダーのデフォルトタイムアウトを使用
    create = "10m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: RedshiftデータステートメントのID
#---------------------------------------------------------------
