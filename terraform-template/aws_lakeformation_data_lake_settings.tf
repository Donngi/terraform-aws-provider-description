################################################################################
# AWS Lake Formation Data Lake Settings
################################################################################
# Lake Formation データレイク設定リソース
# データレイク管理者の指定と、データベース/テーブル作成時のデフォルト権限を管理
#
# 参考:
# - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lakeformation_data_lake_settings
# - https://docs.aws.amazon.com/lake-formation/latest/dg/change-settings.html
# - https://docs.aws.amazon.com/lake-formation/latest/dg/upgrade-glue-lake-formation.html
# - https://docs.aws.amazon.com/lake-formation/latest/dg/lf-permissions-reference.html
#
# 重要な注意事項:
# - Lake Formationは既存のIAM/Glue権限との後方互換性のため IAMAllowedPrincipals プリンシパルを導入
# - admins, create_database_default_permissions, create_table_default_permissions,
#   parameters, trusted_resource_owners を省略すると設定がクリアされる
# - リソースを削除すると CROSS_ACCOUNT_VERSION が "1" にリセットされる
################################################################################

resource "aws_lakeformation_data_lake_settings" "example" {
  ############################################################################
  # 基本設定
  ############################################################################

  # カタログID
  # Data Catalog の識別子（デフォルトはアカウントID）
  # catalog_id = "123456789012"

  # リージョン
  # このリソースを管理するリージョン
  # デフォルトはプロバイダー設定のリージョン
  # region = "us-east-1"

  ############################################################################
  # データレイク管理者
  ############################################################################

  # データレイク管理者のARNリスト
  # Lake Formation のデータレイク管理者として指定するIAMユーザーまたはロールのARN
  # 例: ["arn:aws:iam::123456789012:user/admin", "arn:aws:iam::123456789012:role/LakeFormationAdmin"]
  #
  # 設定例:
  # admins = [
  #   "arn:aws:iam::123456789012:user/lake-admin",
  #   "arn:aws:iam::123456789012:role/LakeFormationAdminRole"
  # ]

  # 読み取り専用管理者のARNリスト
  # リソースに対して表示アクセスのみを持つIAMユーザーまたはロールのARN
  # read_only_admins = ["arn:aws:iam::123456789012:role/ReadOnlyAdmin"]

  ############################################################################
  # デフォルト権限設定
  ############################################################################

  # データベース作成時のデフォルト権限
  # 新しいデータベースが作成された際に自動的に付与される権限（最大3つまで）
  #
  # IAMのみで制御する場合の設定:
  # create_database_default_permissions {
  #   principal   = "IAM_ALLOWED_PRINCIPALS"
  #   permissions = ["ALL"]
  # }
  #
  # 特定のプリンシパルに権限を付与する例:
  # create_database_default_permissions {
  #   principal = "arn:aws:iam::123456789012:user/data-engineer"
  #   permissions = ["SELECT", "ALTER", "DROP"]
  # }
  #
  # create_database_default_permissions {
  #   principal = "arn:aws:iam::123456789012:role/DataAnalystRole"
  #   permissions = ["SELECT", "DESCRIBE"]
  # }
  #
  # 有効な権限: ALL, SELECT, ALTER, DROP, DELETE, INSERT, DESCRIBE, CREATE_TABLE

  # テーブル作成時のデフォルト権限
  # 新しいテーブルが作成された際に自動的に付与される権限（最大3つまで）
  #
  # IAMのみで制御する場合の設定:
  # create_table_default_permissions {
  #   principal   = "IAM_ALLOWED_PRINCIPALS"
  #   permissions = ["ALL"]
  # }
  #
  # 特定のプリンシパルに権限を付与する例:
  # create_table_default_permissions {
  #   principal = "arn:aws:iam::123456789012:role/ETLRole"
  #   permissions = ["ALL"]
  # }
  #
  # create_table_default_permissions {
  #   principal = "arn:aws:iam::123456789012:user/analyst"
  #   permissions = ["SELECT", "DESCRIBE"]
  # }
  #
  # 有効な権限: ALL, SELECT, ALTER, DROP, DELETE, INSERT, DESCRIBE

  ############################################################################
  # 外部データフィルタリング設定（EMR連携）
  ############################################################################

  # 外部データフィルタリングの許可
  # Amazon EMRクラスタがLake Formationで管理されているデータにアクセスできるようにする
  # allow_external_data_filtering = true

  # 外部データフィルタリング許可リスト
  # データフィルタリングを実行するEMRクラスタを持つAWSアカウントIDのリスト
  # 例: 自アカウントとサードパーティアカウント
  # external_data_filtering_allow_list = [
  #   "123456789012",  # 自アカウント
  #   "210987654321"   # サードパーティアカウント
  # ]

  # 承認されたセッションタグ値リスト
  # Lake Formationは、ロールを引き受ける際にユーザーのロールにタグを付けるため、
  # EMRまたはサードパーティ統合による特権プロセスに依存します
  # authorized_session_tag_value_list = ["Amazon EMR"]

  # フルテーブル外部データアクセスの許可
  # 呼び出し元が完全なデータアクセス権限を持っている場合に、
  # サードパーティのクエリエンジンがセッションタグなしでデータアクセス認証情報を取得できるようにする
  # allow_full_table_external_data_access = true

  ############################################################################
  # 詳細設定
  ############################################################################

  # パラメータ
  # 追加設定のキー・バリューマップ
  # CROSS_ACCOUNT_VERSION: クロスアカウントアクセスのバージョン (1, 2, 3, 4)
  # - 新規アカウントでは "1" がデフォルト
  # - リソース削除時に "1" にリセットされる
  # - SET_CONTEXT: TRUE が返される
  #
  # parameters = {
  #   CROSS_ACCOUNT_VERSION = "3"
  # }

  # 信頼されたリソース所有者
  # 呼び出し元のアカウントがユーザーアクセスの詳細（ユーザーARN）を共有できる
  # リソース所有アカウントIDのリスト
  # trusted_resource_owners = ["123456789012", "210987654321"]

  ############################################################################
  # 使用例シナリオ
  ############################################################################

  # シナリオ 1: データレイク管理者のみ設定
  # admins = [
  #   "arn:aws:iam::123456789012:user/admin",
  #   "arn:aws:iam::123456789012:role/AdminRole"
  # ]

  # シナリオ 2: デフォルト権限を設定
  # admins = ["arn:aws:iam::123456789012:user/admin"]
  # create_database_default_permissions {
  #   principal   = "arn:aws:iam::123456789012:user/engineer"
  #   permissions = ["SELECT", "ALTER", "DROP"]
  # }
  # create_table_default_permissions {
  #   principal   = "arn:aws:iam::123456789012:role/ETLRole"
  #   permissions = ["ALL"]
  # }

  # シナリオ 3: EMRアクセスを有効化
  # admins                                = ["arn:aws:iam::123456789012:user/admin"]
  # allow_external_data_filtering         = true
  # external_data_filtering_allow_list    = ["123456789012", "210987654321"]
  # authorized_session_tag_value_list     = ["Amazon EMR"]
  # allow_full_table_external_data_access = true
  # create_database_default_permissions {
  #   principal   = "arn:aws:iam::123456789012:user/engineer"
  #   permissions = ["SELECT", "ALTER", "DROP"]
  # }
  # create_table_default_permissions {
  #   principal   = "arn:aws:iam::123456789012:role/ETLRole"
  #   permissions = ["ALL"]
  # }

  # シナリオ 4: クロスアカウントバージョンの変更
  # parameters = {
  #   CROSS_ACCOUNT_VERSION = "3"
  # }
}

################################################################################
# 出力値
################################################################################

# リソースID
output "lakeformation_data_lake_settings_id" {
  description = "Lake Formation データレイク設定のID"
  value       = aws_lakeformation_data_lake_settings.example.id
}

# データレイク管理者
output "lakeformation_data_lake_settings_admins" {
  description = "設定されているデータレイク管理者のARNリスト"
  value       = aws_lakeformation_data_lake_settings.example.admins
}

# 読み取り専用管理者
output "lakeformation_data_lake_settings_read_only_admins" {
  description = "設定されている読み取り専用管理者のARNリスト"
  value       = aws_lakeformation_data_lake_settings.example.read_only_admins
}

# パラメータ
output "lakeformation_data_lake_settings_parameters" {
  description = "Lake Formation の設定パラメータ"
  value       = aws_lakeformation_data_lake_settings.example.parameters
}

# 信頼されたリソース所有者
output "lakeformation_data_lake_settings_trusted_resource_owners" {
  description = "信頼されたリソース所有者のアカウントIDリスト"
  value       = aws_lakeformation_data_lake_settings.example.trusted_resource_owners
}

# 外部データフィルタリング許可リスト
output "lakeformation_data_lake_settings_external_data_filtering_allow_list" {
  description = "外部データフィルタリングを許可されたアカウントIDリスト"
  value       = aws_lakeformation_data_lake_settings.example.external_data_filtering_allow_list
}

# 承認されたセッションタグ値
output "lakeformation_data_lake_settings_authorized_session_tag_value_list" {
  description = "承認されたセッションタグ値のリスト"
  value       = aws_lakeformation_data_lake_settings.example.authorized_session_tag_value_list
}
