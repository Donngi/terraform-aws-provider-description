#---------------------------------------------------------------
# AWS Lake Formation Data Lake Settings
#---------------------------------------------------------------
#
# AWS Lake Formationのデータレイク設定を管理するリソースです。
# データレイク管理者の指定、デフォルトのデータベース・テーブル作成権限の設定、
# 外部データフィルタリングの許可設定、クロスアカウントアクセス設定などを行います。
#
# 注意: Lake Formationはデータレイクの細かなアクセス制御を提供します。
#       後方互換性のため「IAMAllowedPrincipals」プリンシパルが導入されています。
#       admins、create_database_default_permissions、create_table_default_permissions、
#       parameters、trusted_resource_ownersを省略すると、その設定はクリアされます。
#
# AWS公式ドキュメント:
#   - Lake Formation DataLakeSettings API: https://docs.aws.amazon.com/lake-formation/latest/APIReference/API_DataLakeSettings.html
#   - Lake Formation セットアップ: https://docs.aws.amazon.com/lake-formation/latest/dg/initial-lf-config.html
#   - デフォルトセキュリティ設定の変更: https://docs.aws.amazon.com/lake-formation/latest/dg/change-settings.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lakeformation_data_lake_settings
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_lakeformation_data_lake_settings" "example" {
  #-------------------------------------------------------------
  # カタログ設定
  #-------------------------------------------------------------

  # catalog_id (Optional)
  # 設定内容: データカタログのIDを指定します。
  # 設定可能な値: AWSアカウントID（12桁の数字）
  # 省略時: 現在のAWSアカウントIDが使用されます。
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
  # 管理者設定
  #-------------------------------------------------------------

  # admins (Optional)
  # 設定内容: データレイク管理者として指定するIAMプリンシパル（ユーザーまたはロール）のARNセットを指定します。
  # 設定可能な値: IAMユーザーまたはIAMロールのARN文字列のセット
  # 省略時: データレイク管理者は設定されません（省略した場合は既存の設定がクリアされます）。
  # 注意: adminsに指定されたプリンシパルはLake FormationのPutDataLakeSettingアクションを実行できます。
  # 参考: https://docs.aws.amazon.com/lake-formation/latest/dg/permissions-reference.html
  admins = [
    "arn:aws:iam::123456789012:role/DataLakeAdminRole",
  ]

  # read_only_admins (Optional)
  # 設定内容: データレイクリソースへの読み取り専用アクセスのみを持つIAMプリンシパルのARNセットを指定します。
  # 設定可能な値: IAMユーザーまたはIAMロールのARN文字列のセット
  # 省略時: 読み取り専用管理者は設定されません（省略した場合は既存の設定がクリアされます）。
  # 参考: https://docs.aws.amazon.com/lake-formation/latest/dg/permissions-reference.html
  read_only_admins = []

  #-------------------------------------------------------------
  # デフォルト権限設定
  #-------------------------------------------------------------

  # create_database_default_permissions (Optional, 最大3ブロック)
  # 設定内容: 新規作成されるデータベースに対するデフォルトのプリンシパル権限を最大3件設定します。
  # 省略時: 設定がクリアされます（省略した場合は既存の設定がクリアされます）。
  # 注意: IAMのみによるアクセス制御を強制する場合はprincipalをIAM_ALLOWED_PRINCIPALSに、
  #       permissionsをALLに設定します。
  # 参考: https://docs.aws.amazon.com/lake-formation/latest/dg/lf-permissions-reference.html
  create_database_default_permissions {
    # principal (Optional)
    # 設定内容: 権限を付与するプリンシパルを指定します。
    # 設定可能な値: IAMユーザー/ロールのARN、または "IAM_ALLOWED_PRINCIPALS"
    # 省略時: Terraformがデフォルト値を設定します。
    principal = "IAM_ALLOWED_PRINCIPALS"

    # permissions (Optional)
    # 設定内容: プリンシパルに付与するデータベース権限のセットを指定します。
    # 設定可能な値:
    #   - "ALL": 全権限
    #   - "SELECT": データの参照
    #   - "ALTER": テーブル定義の変更
    #   - "DROP": テーブルの削除
    #   - "DELETE": データの削除
    #   - "INSERT": データの挿入
    #   - "DESCRIBE": テーブル定義の参照
    #   - "CREATE_TABLE": テーブルの作成
    # 省略時: Terraformがデフォルト値を設定します。
    # 参考: https://docs.aws.amazon.com/lake-formation/latest/dg/lf-permissions-reference.html
    permissions = ["ALL"]
  }

  # create_table_default_permissions (Optional, 最大3ブロック)
  # 設定内容: 新規作成されるテーブルに対するデフォルトのプリンシパル権限を最大3件設定します。
  # 省略時: 設定がクリアされます（省略した場合は既存の設定がクリアされます）。
  # 注意: IAMのみによるアクセス制御を強制する場合はprincipalをIAM_ALLOWED_PRINCIPALSに、
  #       permissionsをALLに設定します。
  # 参考: https://docs.aws.amazon.com/lake-formation/latest/dg/lf-permissions-reference.html
  create_table_default_permissions {
    # principal (Optional)
    # 設定内容: 権限を付与するプリンシパルを指定します。
    # 設定可能な値: IAMユーザー/ロールのARN、または "IAM_ALLOWED_PRINCIPALS"
    # 省略時: Terraformがデフォルト値を設定します。
    principal = "IAM_ALLOWED_PRINCIPALS"

    # permissions (Optional)
    # 設定内容: プリンシパルに付与するテーブル権限のセットを指定します。
    # 設定可能な値:
    #   - "ALL": 全権限
    #   - "SELECT": データの参照
    #   - "ALTER": テーブル定義の変更
    #   - "DROP": テーブルの削除
    #   - "DELETE": データの削除
    #   - "INSERT": データの挿入
    #   - "DESCRIBE": テーブル定義の参照
    # 省略時: Terraformがデフォルト値を設定します。
    # 参考: https://docs.aws.amazon.com/lake-formation/latest/dg/lf-permissions-reference.html
    permissions = ["ALL"]
  }

  #-------------------------------------------------------------
  # 外部データフィルタリング設定
  #-------------------------------------------------------------

  # allow_external_data_filtering (Optional)
  # 設定内容: Amazon EMRクラスターがLake Formationで管理するデータにアクセスすることを許可するかを指定します。
  # 設定可能な値:
  #   - true: EMRクラスターによる外部データフィルタリングを許可
  #   - false: EMRクラスターによる外部データフィルタリングを禁止
  # 省略時: falseとして扱われます。
  # 参考: https://docs.aws.amazon.com/lake-formation/latest/APIReference/API_DataLakeSettings.html
  allow_external_data_filtering = false

  # allow_full_table_external_data_access (Optional)
  # 設定内容: 呼び出し元がフルデータアクセス権限を持つ場合に、
  #           サードパーティのクエリエンジンがセッションタグなしにデータアクセス認証情報を
  #           取得することを許可するかを指定します。
  # 設定可能な値:
  #   - true: セッションタグなしのデータアクセス認証情報取得を許可
  #   - false: セッションタグなしのデータアクセス認証情報取得を禁止
  # 省略時: falseとして扱われます。
  # 参考: https://docs.aws.amazon.com/lake-formation/latest/APIReference/API_DataLakeSettings.html
  allow_full_table_external_data_access = false

  # external_data_filtering_allow_list (Optional)
  # 設定内容: データフィルタリングを実行するAmazon EMRクラスターを持つAWSアカウントのIDセットを指定します。
  # 設定可能な値: AWSアカウントID（12桁の数字）の文字列セット
  # 省略時: 設定がクリアされます（省略した場合は既存の設定がクリアされます）。
  # 注意: allow_external_data_filteringがtrueの場合に有効です。
  # 参考: https://docs.aws.amazon.com/lake-formation/latest/APIReference/API_DataLakeSettings.html
  external_data_filtering_allow_list = []

  # authorized_session_tag_value_list (Optional)
  # 設定内容: Lake FormationのAdmin APIにアクセスする特権プロセスが使用する
  #           セッションタグの許容値リストを指定します。
  # 設定可能な値: セッションタグの値の文字列リスト（例: "Amazon EMR"）
  # 省略時: 設定がクリアされます（省略した場合は既存の設定がクリアされます）。
  # 参考: https://docs.aws.amazon.com/lake-formation/latest/APIReference/API_DataLakeSettings.html
  authorized_session_tag_value_list = []

  #-------------------------------------------------------------
  # クロスアカウント設定
  #-------------------------------------------------------------

  # trusted_resource_owners (Optional)
  # 設定内容: 呼び出し元のアカウントがユーザーアクセス詳細（ユーザーARN）を
  #           共有するために使用できるリソース所有者アカウントIDのリストを指定します。
  # 設定可能な値: AWSアカウントID（12桁の数字）の文字列リスト
  # 省略時: 設定がクリアされます（省略した場合は既存の設定がクリアされます）。
  # 参考: https://docs.aws.amazon.com/lake-formation/latest/APIReference/API_DataLakeSettings.html
  trusted_resource_owners = []

  #-------------------------------------------------------------
  # 追加パラメーター設定
  #-------------------------------------------------------------

  # parameters (Optional)
  # 設定内容: データレイクの追加設定を指定するキーと値のマップです。
  # 設定可能な値:
  #   - CROSS_ACCOUNT_VERSION: クロスアカウント共有のバージョンを指定します。
  #     設定可能な値: "1", "2", "3", "4"
  #     "1": デフォルト（新規アカウントの初期値）
  #     "3"以上: Lake Formation タグベースのアクセス制御(LF-TBAC)クロスアカウント共有をサポート
  #   - SET_CONTEXT: 読み取り専用。常に"TRUE"が返されます。
  # 省略時: 設定がクリアされ、CROSS_ACCOUNT_VERSIONは"1"に戻ります。
  # 注意: このリソースを破棄するとCROSS_ACCOUNT_VERSIONは"1"に戻ります。
  # 参考: https://docs.aws.amazon.com/lake-formation/latest/APIReference/API_DataLakeSettings.html
  parameters = {
    "CROSS_ACCOUNT_VERSION" = "1"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: データカタログのID（catalog_idと同値）。
#---------------------------------------------------------------
