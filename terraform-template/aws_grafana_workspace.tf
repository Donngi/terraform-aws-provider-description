#---------------------------------------------------------------
# Amazon Managed Grafana Workspace
#---------------------------------------------------------------
#
# Amazon Managed Grafana のワークスペースをプロビジョニングするリソースです。
# ワークスペースはGrafanaサーバーの論理単位であり、ダッシュボードの作成・管理・
# 共有を行うための環境です。各AWSアカウントはリージョンごとに最大5つの
# ワークスペースを持つことができます。
#
# AWS公式ドキュメント:
#   - ワークスペースの作成: https://docs.aws.amazon.com/grafana/latest/userguide/AMG-create-workspace.html
#   - ワークスペースの設定: https://docs.aws.amazon.com/grafana/latest/userguide/AMG-configure-workspace.html
#   - ワークスペースの管理: https://docs.aws.amazon.com/grafana/latest/userguide/AMG-manage-workspaces-users.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/grafana_workspace
#
# Provider Version: 6.36.0
# Generated: 2026-03-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_grafana_workspace" "example" {
  #-------------------------------------------------------------
  # アカウントアクセス設定
  #-------------------------------------------------------------

  # account_access_type (Required)
  # 設定内容: ワークスペースのアカウントアクセスタイプを指定します。
  # 設定可能な値:
  #   - "CURRENT_ACCOUNT": 現在のAWSアカウントのみアクセス可能
  #   - "ORGANIZATION": AWS Organizationsの組織全体からアクセス可能。
  #                     この値を指定する場合は organizational_units も必須
  account_access_type = "CURRENT_ACCOUNT"

  #-------------------------------------------------------------
  # 認証設定
  #-------------------------------------------------------------

  # authentication_providers (Required)
  # 設定内容: ワークスペースの認証プロバイダーのリストを指定します。
  # 設定可能な値:
  #   - ["AWS_SSO"]: AWS IAM Identity Center (旧SSO) のみを使用
  #   - ["SAML"]: SAML 2.0 のみを使用
  #   - ["AWS_SSO", "SAML"]: 両方を使用
  # 参考: https://docs.aws.amazon.com/grafana/latest/userguide/AMG-create-workspace.html
  authentication_providers = ["SAML"]

  #-------------------------------------------------------------
  # 権限タイプ設定
  #-------------------------------------------------------------

  # permission_type (Required)
  # 設定内容: ワークスペースの権限タイプを指定します。
  # 設定可能な値:
  #   - "SERVICE_MANAGED": IAMロールとIAMポリシーアタッチメントを自動生成。
  #                        Grafanaがデータソースへのアクセス権限を自動管理
  #   - "CUSTOMER_MANAGED": IAMロールとIAMポリシーアタッチメントを手動管理。
  #                         role_arn で指定したロールを使用
  permission_type = "SERVICE_MANAGED"

  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Optional)
  # 設定内容: Grafanaワークスペースの名前を指定します。
  # 設定可能な値: 文字列
  # 省略時: Terraformが一意の名前を自動生成します。
  name = "example-grafana-workspace"

  # description (Optional)
  # 設定内容: ワークスペースの説明文を指定します。
  # 設定可能な値: 文字列
  # 省略時: 説明なし
  description = "Example Amazon Managed Grafana workspace"

  # grafana_version (Optional)
  # 設定内容: ワークスペースでサポートするGrafanaのバージョンを指定します。
  # 設定可能な値:
  #   - "8.4": Grafana 8.4
  #   - "9.4": Grafana 9.4
  #   - "10.4": Grafana 10.4（推奨。Prometheusアラートの確認やGrafanaアラートを利用する場合）
  # 省略時: 最新バージョンが自動的に使用されます。
  # 注意: バージョンのダウングレードはできません。
  # 参考: https://docs.aws.amazon.com/grafana/latest/userguide/AMG-workspace-version-update.html
  grafana_version = "10.4"

  #-------------------------------------------------------------
  # IAMロール設定
  #-------------------------------------------------------------

  # role_arn (Optional)
  # 設定内容: ワークスペースが引き受けるIAMロールのARNを指定します。
  # 設定可能な値: 有効なIAMロールARN
  # 省略時: permission_type = "SERVICE_MANAGED" の場合は自動的にロールが作成されます。
  # 注意: permission_type = "CUSTOMER_MANAGED" の場合は指定が推奨されます。
  role_arn = "arn:aws:iam::123456789012:role/grafana-workspace-role"

  #-------------------------------------------------------------
  # データソース設定
  #-------------------------------------------------------------

  # data_sources (Optional)
  # 設定内容: ワークスペースで使用するデータソースのリストを指定します。
  #           ここで指定したデータソースに対して、Grafanaが自動的にIAMロールと
  #           ポリシーを作成します。
  # 設定可能な値（複数指定可）:
  #   - "AMAZON_OPENSEARCH_SERVICE": Amazon OpenSearch Service
  #   - "ATHENA": Amazon Athena
  #   - "CLOUDWATCH": Amazon CloudWatch
  #   - "PROMETHEUS": Amazon Managed Service for Prometheus
  #   - "REDSHIFT": Amazon Redshift
  #   - "SITEWISE": AWS IoT SiteWise
  #   - "TIMESTREAM": Amazon Timestream
  #   - "TWINMAKER": AWS IoT TwinMaker
  #   - "XRAY": AWS X-Ray
  # 省略時: データソースなし（後から手動で設定することも可能）
  data_sources = ["CLOUDWATCH", "PROMETHEUS"]

  #-------------------------------------------------------------
  # 通知先設定
  #-------------------------------------------------------------

  # notification_destinations (Optional)
  # 設定内容: アラート通知の送信先のリストを指定します。
  #           指定したサービスに対してIAMロールと権限を自動作成します。
  # 設定可能な値:
  #   - "SNS": Amazon Simple Notification Service
  # 省略時: 通知先なし
  notification_destinations = ["SNS"]

  #-------------------------------------------------------------
  # Organizationsアクセス設定
  #-------------------------------------------------------------

  # organization_role_name (Optional)
  # 設定内容: AWS Organizationsのリソースへアクセスするためにワークスペースが
  #           使用するロール名を指定します。
  # 設定可能な値: 有効なIAMロール名
  # 省略時: account_access_type = "ORGANIZATION" の場合のみ使用
  organization_role_name = null

  # organizational_units (Optional)
  # 設定内容: ワークスペースがデータソースへのアクセスを許可される
  #           AWS Organizations の組織単位（OU）のリストを指定します。
  # 設定可能な値: 有効な組織単位IDのリスト（例: "ou-xxxx-xxxxxxxx"）
  # 省略時: account_access_type = "ORGANIZATION" の場合のみ使用
  organizational_units = null

  #-------------------------------------------------------------
  # CloudFormationスタックセット設定
  #-------------------------------------------------------------

  # stack_set_name (Optional)
  # 設定内容: ワークスペースで使用するIAMロールをプロビジョニングする
  #           AWS CloudFormationスタックセット名を指定します。
  # 設定可能な値: 有効なCloudFormationスタックセット名
  # 省略時: スタックセットを使用しない
  stack_set_name = null

  #-------------------------------------------------------------
  # 暗号化設定
  #-------------------------------------------------------------

  # kms_key_id (Optional)
  # 設定内容: ワークスペースデータを暗号化するためのAWS KMSキーのARNを指定します。
  #           カスタマーマネージドキー（CMK）によるデータ暗号化が必要な場合に設定します。
  # 設定可能な値: 有効なKMSキーARN（例: "arn:aws:kms:ap-northeast-1:123456789012:key/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"）
  # 省略時: AWS管理キーでデータが暗号化されます。
  kms_key_id = null

  #-------------------------------------------------------------
  # ワークスペース設定
  #-------------------------------------------------------------

  # configuration (Optional)
  # 設定内容: ワークスペースの設定文字列をJSON形式で指定します。
  #           Grafanaアラートの有効/無効、プラグイン管理の設定が可能です。
  # 設定可能な値: JSON形式の設定文字列。主要な設定項目:
  #   - plugins.pluginAdminEnabled (bool): プラグイン管理の有効/無効
  #   - unifiedAlerting.enabled (bool): Grafanaアラートの有効/無効
  # 省略時: デフォルト設定が使用されます。
  # 参考: https://docs.aws.amazon.com/grafana/latest/userguide/AMG-configure-workspace.html
  configuration = jsonencode({
    plugins = {
      pluginAdminEnabled = true
    }
    unifiedAlerting = {
      enabled = true
    }
  })

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
  # ネットワークアクセス制御設定
  #-------------------------------------------------------------

  # network_access_control (Optional)
  # 設定内容: ワークスペースへのネットワークアクセス制御の設定ブロックです。
  #           VPCエンドポイントとプレフィックスリストによるアクセス制限を設定します。
  # 関連機能: Amazon Managed Grafana ネットワークアクセス制御
  #   - https://docs.aws.amazon.com/grafana/latest/userguide/AMG-manage-workspaces-users.html
  network_access_control {

    # prefix_list_ids (Required)
    # 設定内容: アクセスを許可するプレフィックスリストIDの配列を指定します。
    # 設定可能な値: 有効なVPCプレフィックスリストIDのセット（例: "pl-xxxxxxxxxx"）
    prefix_list_ids = ["pl-12345678"]

    # vpce_ids (Required)
    # 設定内容: ワークスペースへのアクセスを許可するVPCエンドポイントIDの配列を指定します。
    #           指定できるのはGrafanaワークスペース用のインターフェースVPCエンドポイント
    #           （com.amazonaws.[region].grafana-workspace サービスエンドポイント）のみです。
    #           それ以外のVPCエンドポイントは無視されます。
    # 設定可能な値: 有効なVPCエンドポイントIDのセット（例: "vpce-xxxxxxxxxxxxxxxxx"）
    vpce_ids = ["vpce-12345678901234567"]
  }

  #-------------------------------------------------------------
  # VPC設定
  #-------------------------------------------------------------

  # vpc_configuration (Optional)
  # 設定内容: GrafanaワークスペースがVPC内のデータソースに接続するための
  #           VPC設定ブロックです。
  # 関連機能: Amazon VPCからのデータソース接続
  #   - https://docs.aws.amazon.com/grafana/latest/userguide/AMG-manage-workspaces-users.html
  vpc_configuration {

    # security_group_ids (Required)
    # 設定内容: Grafanaワークスペース用のAmazon VPCにアタッチする
    #           EC2セキュリティグループIDのリストを指定します。
    # 設定可能な値: 有効なセキュリティグループIDのセット
    security_group_ids = ["sg-12345678"]

    # subnet_ids (Required)
    # 設定内容: Grafanaワークスペース用のAmazon VPCに作成した
    #           EC2サブネットIDのリストを指定します。
    # 設定可能な値: 有効なサブネットIDのセット
    # 注意: 高可用性のため複数AZのサブネットを指定することを推奨します。
    subnet_ids = ["subnet-12345678", "subnet-87654321"]
  }

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 参考: プロバイダーレベルの default_tags 設定ブロックで定義されたタグと
  #       一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "example-grafana-workspace"
    Environment = "production"
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト時間の設定ブロックです。
  timeouts {

    # create (Optional)
    # 設定内容: リソース作成のタイムアウト時間を指定します。
    # 設定可能な値: Goのtime.Duration文字列形式（例: "30m", "1h"）
    # 省略時: プロバイダーのデフォルトタイムアウトを使用
    create = "30m"

    # update (Optional)
    # 設定内容: リソース更新のタイムアウト時間を指定します。
    # 設定可能な値: Goのtime.Duration文字列形式（例: "30m", "1h"）
    # 省略時: プロバイダーのデフォルトタイムアウトを使用
    update = "30m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: GrafanaワークスペースのAmazon Resource Name (ARN)
# - endpoint: Grafanaワークスペースのエンドポイント（アクセスURL）
# - saml_configuration_status: SAML設定のステータス
# - grafana_version: ワークスペースで実行中のGrafanaのバージョン
# - tags_all: プロバイダーの default_tags 設定から継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
