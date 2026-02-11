# ============================================================================
# AWS DataZone Environment Profile
# ============================================================================
# Generated: 2026-01-19
# Provider Version: 6.28.0
#
# 注意: このテンプレートは生成時点(2026-01-19)の情報に基づいています。
# 最新の仕様については以下の公式ドキュメントを確認してください。
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/datazone_environment_profile
# https://docs.aws.amazon.com/datazone/latest/userguide/create-environment-profile.html
# ============================================================================

resource "aws_datazone_environment_profile" "example" {
  # ============================================================================
  # Required Arguments
  # ============================================================================

  # AWS account region - 環境プロファイルを作成する対象のAWSリージョン
  # DataZone環境がデプロイされるリージョンを指定します。
  # 例: "us-east-1", "us-west-2", "ap-northeast-1"など
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html
  aws_account_region = "us-east-1"

  # Domain identifier - DataZoneドメインの識別子
  # 環境プロファイルが属するDataZoneドメインのIDを指定します。
  # このIDはaws_datazone_domainリソースから取得できます。
  # 参考: https://docs.aws.amazon.com/datazone/latest/userguide/working-with-blueprints.html
  domain_identifier = "dzd_xxxxxxxxxxxx"

  # Environment blueprint identifier - 環境ブループリントの識別子
  # 環境を作成する際に使用するブループリントのIDを指定します。
  # 標準的なブループリント:
  #   - DefaultDataLake: データレイク環境用
  #   - DefaultDataWarehouse: データウェアハウス環境用
  #   - AmazonSageMaker: SageMaker環境用
  # data.aws_datazone_environment_blueprintから取得するか、既存のIDを指定します。
  # 参考: https://docs.aws.amazon.com/datazone/latest/userguide/working-with-blueprints.html
  environment_blueprint_identifier = "xxxxxxxxxxxx"

  # Name - 環境プロファイルの名前
  # 環境プロファイルを識別するための名前を指定します。
  # プロジェクト内で一意である必要があります。
  # 制約: 1-64文字、英数字とハイフン(-)が使用可能
  # 参考: https://docs.aws.amazon.com/datazone/latest/userguide/create-environment-profile.html
  name = "example-environment-profile"

  # Project identifier - プロジェクトの識別子
  # 環境プロファイルが属するDataZoneプロジェクトのIDを指定します。
  # このIDはaws_datazone_projectリソースから取得できます。
  # 参考: https://docs.aws.amazon.com/datazone/latest/userguide/create-environment-profile.html
  project_identifier = "xxxxxxxxxxxx"

  # ============================================================================
  # Optional Arguments
  # ============================================================================

  # AWS account ID - AWSアカウントID
  # 環境プロファイルを作成する対象のAWSアカウントIDを指定します。
  # 省略した場合は、プロバイダー設定で使用されているアカウントIDが使用されます。
  # data.aws_caller_identity.current.account_idで取得可能です。
  # 例: "123456789012"
  aws_account_id = "123456789012"

  # Description - 環境プロファイルの説明
  # 環境プロファイルの目的や用途を説明するテキストを指定します。
  # 制約: 最大2048文字
  # 参考: https://docs.aws.amazon.com/datazone/latest/userguide/create-environment-profile.html
  description = "Example environment profile for data lake operations"

  # Region - 管理リージョン
  # このリソースが管理されるリージョンを指定します。
  # 省略した場合は、プロバイダー設定で指定されたリージョンが使用されます。
  # 注意: aws_account_regionとは異なり、これはTerraform管理用のリージョン設定です。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-east-1"

  # ============================================================================
  # Optional Blocks
  # ============================================================================

  # User parameters - 環境プロファイルのユーザーパラメータ
  # 環境ブループリントで定義されたパラメータに対する値を設定します。
  # ブループリントによって必要なパラメータは異なります。
  #
  # Data Lakeブループリントの一般的なパラメータ:
  #   - consumerGlueDbName: コンシューマー用のGlueデータベース名
  #   - producerGlueDbName: プロデューサー用のGlueデータベース名
  #
  # Data Warehouseブループリントの一般的なパラメータ:
  #   - redshiftClusterName: Redshiftクラスター名
  #   - redshiftServerlessWorkgroupName: Redshift Serverlessワークグループ名
  #   - databaseName: データベース名
  #
  # 参考: https://docs.aws.amazon.com/datazone/latest/userguide/create-environment-profile.html
  user_parameters {
    # Name - パラメータ名
    # 環境ブループリントで定義されているパラメータ名を指定します。
    name = "consumerGlueDbName"

    # Value - パラメータ値
    # 指定したパラメータに設定する値を文字列形式で指定します。
    value = "example_consumer_db"
  }

  # 複数のパラメータを設定する場合は、user_parametersブロックを繰り返します
  user_parameters {
    name  = "producerGlueDbName"
    value = "example_producer_db"
  }
}

# ============================================================================
# Computed Attributes (Read-only)
# ============================================================================
# 以下の属性は自動的に計算され、参照のみ可能です(設定不可):
#
# - id: 環境プロファイルの一意識別子
# - created_at: 環境プロファイルの作成日時(ISO 8601形式)
# - created_by: 環境プロファイルを作成したユーザー/サービスの識別子
# - updated_at: 環境プロファイルの最終更新日時(ISO 8601形式)
#
# これらの値は以下のように参照できます:
# aws_datazone_environment_profile.example.id
# aws_datazone_environment_profile.example.created_at
# aws_datazone_environment_profile.example.created_by
# aws_datazone_environment_profile.example.updated_at
# ============================================================================

# ============================================================================
# Output Examples
# ============================================================================
# output "environment_profile_id" {
#   description = "The ID of the DataZone environment profile"
#   value       = aws_datazone_environment_profile.example.id
# }
#
# output "environment_profile_created_at" {
#   description = "The creation timestamp of the environment profile"
#   value       = aws_datazone_environment_profile.example.created_at
# }
# ============================================================================
