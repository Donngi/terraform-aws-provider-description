#---------------------------------------------------------------
# AWS DataZone Environment
#---------------------------------------------------------------
#
# Amazon DataZone Environmentをプロビジョニングするリソースです。
# DataZone Environmentは、プロジェクト内で構成されたリソース（S3バケット、
# Glueデータベース、Athenaワークグループなど）のコレクションであり、
# それらのリソースを操作できる関連IAMプリンシパルを持ちます。
#
# AWS公式ドキュメント:
#   - DataZone環境の作成: https://docs.aws.amazon.com/datazone/latest/userguide/create-new-environment.html
#   - DataZone環境の編集: https://docs.aws.amazon.com/datazone/latest/userguide/edit-environment.html
#   - DataZone環境の削除: https://docs.aws.amazon.com/datazone/latest/userguide/delete-environment.html
#   - Athenaでの使用: https://docs.aws.amazon.com/athena/latest/ug/datazone-using.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/datazone_environment
#
# Provider Version: 6.28.0
# Generated: 2026-01-31
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_datazone_environment" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: 環境の名前を指定します。
  # 設定可能な値: 文字列（プロジェクト内で一意である必要があります）
  # 関連機能: Amazon DataZone Environment
  #   環境は、プロジェクト内で構成されたリソースのコレクションです。
  #   S3バケット、Glueデータベース、Athenaワークグループなどのリソースを含み、
  #   それらのリソースを操作できる関連IAMプリンシパルを持ちます。
  #   - https://docs.aws.amazon.com/datazone/latest/userguide/create-new-environment.html
  name = "example-environment"

  # description (Optional)
  # 設定内容: 環境の説明を指定します。
  # 設定可能な値: 文字列（最大2048文字）
  # 省略時: 説明なし
  description = "Development environment for data analytics"

  #-------------------------------------------------------------
  # ドメインとプロジェクト設定
  #-------------------------------------------------------------

  # domain_identifier (Required)
  # 設定内容: 環境が存在するDataZoneドメインのIDを指定します。
  # 設定可能な値: DataZoneドメインID（aws_datazone_domain.example.idなど）
  # 関連機能: Amazon DataZone Domain
  #   DataZoneドメインは、データカタログ、ビジネス用語集、プロジェクト、
  #   環境を管理するトップレベルのコンテナです。
  domain_identifier = "dzd-1234567890abcdef0"

  # project_identifier (Required)
  # 設定内容: 環境が存在するプロジェクトのIDを指定します。
  # 設定可能な値: DataZoneプロジェクトID（aws_datazone_project.example.idなど）
  # 関連機能: Amazon DataZone Project
  #   プロジェクトは、ユーザーがビジネスユースケースに取り組み、
  #   データアセットにアクセスするためのコラボレーションスペースです。
  #   - https://docs.aws.amazon.com/datazone/latest/userguide/working-with-projects.html
  project_identifier = "prj-1234567890abcdef0"

  # profile_identifier (Required)
  # 設定内容: 環境の作成に使用する環境プロファイルのIDを指定します。
  # 設定可能な値: DataZone環境プロファイルID（aws_datazone_environment_profile.example.idなど）
  # 関連機能: Amazon DataZone Environment Profile
  #   環境プロファイルは環境作成のテンプレートであり、AWSアカウント、リージョン、
  #   ブループリント（Data LakeまたはData Warehouse）などの配置情報を埋め込みます。
  #   - https://docs.aws.amazon.com/datazone/latest/userguide/create-environment-profile.html
  profile_identifier = "prof-1234567890abcdef0"

  #-------------------------------------------------------------
  # アカウントとリージョン設定
  #-------------------------------------------------------------

  # account_identifier (Optional)
  # 設定内容: 環境が存在するAWSアカウントのIDを指定します。
  # 設定可能な値: 12桁のAWSアカウントID
  # 省略時: 現在のアカウントが使用されます
  # 関連機能: クロスアカウント環境
  #   別のAWSアカウントにリソースをデプロイする場合に指定します。
  #   適切な信頼関係とIAMロールの設定が必要です。
  account_identifier = null

  # account_region (Optional)
  # 設定内容: 環境が存在するAWSリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: 現在のリージョンが使用されます
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  account_region = null

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # ブループリント設定
  #-------------------------------------------------------------

  # blueprint_identifier (Optional)
  # 設定内容: 環境の作成に使用するブループリントのIDを指定します。
  # 設定可能な値: DataZoneブループリントID
  # 省略時: 環境プロファイルから自動的に設定されます
  # 関連機能: Amazon DataZone Environment Blueprint
  #   ブループリントは、環境に含まれるAWSリソースのタイプを定義します。
  #   組み込みブループリント（Data Lake、Data Warehouse）またはカスタム
  #   ブループリントを使用できます。
  blueprint_identifier = null

  #-------------------------------------------------------------
  # ビジネス用語集設定
  #-------------------------------------------------------------

  # glossary_terms (Optional)
  # 設定内容: この環境で使用できるビジネス用語集の用語を指定します。
  # 設定可能な値: DataZone用語集用語IDのリスト
  # 省略時: 用語集の用語は関連付けられません
  # 関連機能: Amazon DataZone Business Glossary
  #   ビジネス用語集を環境に関連付けることで、データガバナンスと
  #   メタデータ管理を強化できます。
  glossary_terms = null

  #-------------------------------------------------------------
  # ユーザーパラメータ設定
  #-------------------------------------------------------------
  # 注意: user_parametersの変更はリソースの再作成を引き起こします。

  # user_parameters (Optional, Forces new resource)
  # 設定内容: 環境で使用されるユーザーパラメータを指定します。
  # 設定可能な値: name と value のペアのリスト
  # 省略時: パラメータなし
  # 関連機能: Environment User Parameters
  #   環境プロファイルで定義されたパラメータに値を指定します。
  #   Data Lakeブループリントの場合: consumerGlueDbName, producerGlueDbName, workgroupName
  #   Data Warehouseブループリントの場合: redshiftClusterName, databaseName など
  # 注意: user_parametersの値を変更すると、環境が再作成されます。
  #       本番環境では慎重に変更してください。
  user_parameters {
    # name (Optional)
    # 設定内容: 環境プロファイルパラメータの名前を指定します。
    # 設定可能な値: 文字列（環境プロファイルで定義されたパラメータ名）
    name = "consumerGlueDbName"

    # value (Optional)
    # 設定内容: 環境プロファイルパラメータの値を指定します。
    # 設定可能な値: 文字列
    value = "consumer_database"
  }

  user_parameters {
    name  = "producerGlueDbName"
    value = "producer_database"
  }

  user_parameters {
    name  = "workgroupName"
    value = "analytics_workgroup"
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  timeouts {
    # create (Optional)
    # 設定内容: 環境作成のタイムアウト時間を指定します。
    # 設定可能な値: 期間文字列（例: "30m", "1h"）
    # 省略時: 30分
    # 注意: 環境の作成には、リソースのプロビジョニングに時間がかかる場合があります。
    create = "30m"

    # update (Optional)
    # 設定内容: 環境更新のタイムアウト時間を指定します。
    # 設定可能な値: 期間文字列（例: "30m", "1h"）
    # 省略時: 30分
    update = "30m"

    # delete (Optional)
    # 設定内容: 環境削除のタイムアウト時間を指定します。
    # 設定可能な値: 期間文字列（例: "30m", "1h"）
    # 省略時: 30分
    # 注意: 環境を削除する前に、すべてのデータソースとサブスクリプション
    #       ターゲットを削除する必要があります。
    #       - https://docs.aws.amazon.com/datazone/latest/userguide/delete-environment.html
    delete = "30m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: 環境のID
#
# - created_at: 環境が作成された時刻
#
# - created_by: 環境を作成したユーザー
#
# - provider_environment: 環境のプロバイダー
#
# - provisioned_resources: 環境のプロビジョニングされたリソース
#   各リソースには以下の属性があります:
#   - name: リソースの名前
#   - provider: リソースのプロバイダー
#   - type: リソースのタイプ
#   - value: リソースの値
#
# - last_deployment: 環境の最後のデプロイメントの詳細
#   以下の属性があります:
#   - deployment_id: デプロイメントのID
#   - deployment_status: デプロイメントのステータス
#   - deployment_type: デプロイメントのタイプ
#---------------------------------------------------------------
