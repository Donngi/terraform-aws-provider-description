#---------------------------------------------------------------
# AWS Redshift Data Statement
#---------------------------------------------------------------
#
# AWS Redshift Data Statementを実行するリソースです。
# このリソースは、Amazon RedshiftクラスターまたはRedshift Serverless
# ワークグループに対してSQLステートメントを実行します。
# Secrets ManagerまたはTemporary Credentialsを使用した認証をサポートします。
#
# AWS公式ドキュメント:
#   - Redshift Data API概要: https://docs.aws.amazon.com/redshift/latest/mgmt/data-api.html
#   - Data APIの使用: https://docs.aws.amazon.com/redshift/latest/mgmt/data-api-calling.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/redshiftdata_statement
#
# Provider Version: 6.28.0
# Generated: 2026-02-03
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_redshiftdata_statement" "example" {
  #-------------------------------------------------------------
  # 基本設定（必須）
  #-------------------------------------------------------------

  # database (Required)
  # 設定内容: 接続先のデータベース名を指定します。
  # 設定可能な値: 文字列（データベース名）
  # 注意: Redshiftクラスターまたはワークグループ内に存在する
  #       データベース名を指定する必要があります。
  database = "dev"

  # sql (Required)
  # 設定内容: 実行するSQLステートメントを指定します。
  # 設定可能な値: 文字列（SQLコマンド）
  # 注意: 単一のSQLステートメントまたはセミコロンで区切られた
  #       複数のステートメントを指定できます。
  # 例:
  #   - DDL: "CREATE TABLE users (id INT, name VARCHAR(100));"
  #   - DML: "INSERT INTO users VALUES (1, 'John');"
  #   - DQL: "SELECT * FROM users;"
  sql = "CREATE GROUP group_name;"

  #-------------------------------------------------------------
  # クラスター接続設定（Option 1: クラスター接続）
  #-------------------------------------------------------------

  # cluster_identifier (Optional)
  # 設定内容: Redshiftクラスターの識別子を指定します。
  # 設定可能な値: 文字列（クラスター識別子）
  # 注意: クラスターに接続する場合は必須です。
  #       workgroup_nameとは排他的です（どちらか一方のみ指定）。
  #       Secrets Managerまたはtemporary credentialsを使用した認証が必要です。
  # 参考: https://docs.aws.amazon.com/redshift/latest/mgmt/working-with-clusters.html
  cluster_identifier = "my-redshift-cluster"

  # db_user (Optional)
  # 設定内容: データベースユーザー名を指定します。
  # 設定可能な値: 文字列（ユーザー名）
  # 注意: クラスター接続時に使用します。
  #       Temporary credentialsを使用する場合に指定します。
  #       Secret ARNを使用する場合は不要です。
  db_user = "admin"

  #-------------------------------------------------------------
  # Serverless接続設定（Option 2: Serverless接続）
  #-------------------------------------------------------------

  # workgroup_name (Optional)
  # 設定内容: Redshift Serverlessワークグループの名前を指定します。
  # 設定可能な値: 文字列（ワークグループ名）
  # 注意: Serverlessワークグループに接続する場合は必須です。
  #       cluster_identifierとは排他的です（どちらか一方のみ指定）。
  #       Secrets Managerまたはtemporary credentialsを使用した認証が必要です。
  # 参考: https://docs.aws.amazon.com/redshift/latest/mgmt/serverless-workgroup-overview.html
  # workgroup_name = "my-serverless-workgroup"

  #-------------------------------------------------------------
  # 認証設定
  #-------------------------------------------------------------

  # secret_arn (Optional)
  # 設定内容: データベースアクセスを有効にするSecrets ManagerシークレットのARNまたは名前を指定します。
  # 設定可能な値: 文字列（シークレットARNまたは名前）
  # 注意: Secrets Managerを使用した認証を行う場合に指定します。
  #       シークレットには、Redshiftクラスターまたはワークグループへの
  #       アクセス情報（ユーザー名、パスワード等）が含まれている必要があります。
  # 参考: https://docs.aws.amazon.com/secretsmanager/latest/userguide/intro.html
  # secret_arn = "arn:aws:secretsmanager:us-east-1:123456789012:secret:redshift-credentials-AbCdEf"

  #-------------------------------------------------------------
  # ステートメント設定
  #-------------------------------------------------------------

  # statement_name (Optional)
  # 設定内容: SQLステートメントの名前を指定します。
  # 設定可能な値: 文字列
  # 省略時: 自動生成された名前が使用されます
  # 用途: クエリを識別するための名前を付けることができます。
  #       CloudWatch Logsやクエリ履歴での識別に役立ちます。
  statement_name = "create-group-statement"

  # with_event (Optional)
  # 設定内容: SQLステートメントの実行後にAmazon EventBridgeイベントバスに
  #          イベントを送信するかどうかを指定します。
  # 設定可能な値: true / false
  # 省略時: false
  # 用途: ステートメント実行の完了を他のサービスに通知したい場合に使用します。
  # 参考: https://docs.aws.amazon.com/eventbridge/latest/userguide/eb-what-is.html
  with_event = false

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # パラメータ設定（オプション）
  #-------------------------------------------------------------

  # parameters (Optional)
  # 設定内容: SQLステートメントで使用するパラメータを指定します。
  # 用途: プリペアドステートメントのようにパラメータ化されたクエリを実行する場合に使用します。
  # 注意: 複数のparametersブロックを指定できます（各パラメータごとに1つ）
  parameters {
    # name (Required)
    # 設定内容: パラメータの名前を指定します。
    # 設定可能な値: 文字列
    name = "param1"

    # value (Required)
    # 設定内容: パラメータの値を指定します。
    # 設定可能な値: 文字列
    value = "value1"
  }

  # 複数のパラメータを指定する例
  # parameters {
  #   name  = "param2"
  #   value = "value2"
  # }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト時間を指定します。
  timeouts {
    # create (Optional)
    # 設定内容: リソース作成のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列（例: "30m", "1h"）
    # 省略時: デフォルトのタイムアウト時間が使用されます
    # 注意: 長時間実行されるSQLステートメント（大規模なデータロードなど）の場合は、
    #       適切に調整してください。
    create = "30m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: Redshift Data Statement IDです。
#       このIDを使用して、ステートメントの実行状態や結果を取得できます。
#---------------------------------------------------------------

#---------------------------------------------------------------
# 使用例: Redshiftクラスターへの接続
#---------------------------------------------------------------
# resource "aws_redshiftdata_statement" "cluster_example" {
#   cluster_identifier = aws_redshift_cluster.example.cluster_identifier
#   database           = aws_redshift_cluster.example.database_name
#   db_user            = aws_redshift_cluster.example.master_username
#   sql                = "CREATE TABLE users (id INT, name VARCHAR(100));"
#   statement_name     = "create-users-table"
# }

#---------------------------------------------------------------
# 使用例: Redshift Serverlessワークグループへの接続
#---------------------------------------------------------------
# resource "aws_redshiftdata_statement" "serverless_example" {
#   workgroup_name = aws_redshiftserverless_workgroup.example.workgroup_name
#   database       = "dev"
#   sql            = "CREATE GROUP analysts;"
#   statement_name = "create-analysts-group"
# }

#---------------------------------------------------------------
# 使用例: Secrets Managerを使用した認証
#---------------------------------------------------------------
# resource "aws_redshiftdata_statement" "secrets_manager_example" {
#   cluster_identifier = aws_redshift_cluster.example.cluster_identifier
#   database           = "dev"
#   secret_arn         = aws_secretsmanager_secret.redshift_creds.arn
#   sql                = "SELECT * FROM information_schema.tables;"
#   statement_name     = "list-tables"
# }

#---------------------------------------------------------------
# 使用例: パラメータ化されたクエリ
#---------------------------------------------------------------
# resource "aws_redshiftdata_statement" "parameterized_example" {
#   cluster_identifier = aws_redshift_cluster.example.cluster_identifier
#   database           = "dev"
#   db_user            = "admin"
#   sql                = "SELECT * FROM users WHERE status = :status AND created_at > :created_date;"
#   statement_name     = "query-active-users"
#
#   parameters {
#     name  = "status"
#     value = "active"
#   }
#
#   parameters {
#     name  = "created_date"
#     value = "2026-01-01"
#   }
# }

#---------------------------------------------------------------
# 注意事項
#---------------------------------------------------------------
# 1. 接続方法の選択:
#    - クラスター接続: cluster_identifier + db_user または secret_arn
#    - Serverless接続: workgroup_name + secret_arn または Temporary Credentials
#
# 2. 認証方法:
#    - Temporary Credentials: db_userを指定（IAMロールベース）
#    - Secrets Manager: secret_arnを指定
#
# 3. ステートメント実行:
#    - Data APIは非同期実行です
#    - 実行状態の確認にはAWS CLIまたはSDKを使用する必要があります
#    - 長時間実行されるクエリの場合はタイムアウト設定を調整してください
#
# 4. パラメータ:
#    - パラメータ名はコロン(:)で始める必要があります（SQL内）
#    - parameters ブロックではコロンなしの名前を指定します
#
# 5. EventBridge統合:
#    - with_event = true に設定すると、ステートメント実行完了時に
#      EventBridgeイベントが発行されます
#    - イベントドリブンなワークフローの構築に便利です
#---------------------------------------------------------------
