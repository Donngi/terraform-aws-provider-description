#---------------------------------------------------------------
# Amazon Managed Grafana Workspace
#---------------------------------------------------------------
#
# Amazon Managed Grafana ワークスペースを作成・管理するリソース。
# Grafana は、メトリクス、ログ、トレースを可視化するためのオープンソースの
# 分析・監視プラットフォームです。Amazon Managed Grafana は、Grafana の
# フルマネージド版で、インフラ管理の負担なく利用できます。
#
# AWS公式ドキュメント:
#   - Amazon Managed Grafana User Guide: https://docs.aws.amazon.com/grafana/latest/userguide/what-is-Amazon-Managed-Service-Grafana.html
#   - Configure workspace: https://docs.aws.amazon.com/grafana/latest/userguide/AMG-configure-workspace.html
#   - Create workspace: https://docs.aws.amazon.com/grafana/latest/userguide/AMG-create-workspace.html
#   - Network access control: https://docs.aws.amazon.com/grafana/latest/userguide/AMG-configure-nac.html
#   - Manage permissions: https://docs.aws.amazon.com/grafana/latest/userguide/AMG-manage-permissions.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/grafana_workspace
#
# Provider Version: 6.28.0
# Generated: 2026-01-27
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_grafana_workspace" "example" {
  #---------------------------------------------------------------
  # 必須パラメータ
  #---------------------------------------------------------------

  # アカウントアクセスタイプ
  # ワークスペースがアクセスできるアカウントの範囲を指定します。
  # - CURRENT_ACCOUNT: 現在のAWSアカウントのみ
  # - ORGANIZATION: AWS Organizationsの組織全体
  # ORGANIZATION を指定する場合は organizational_units も必要です。
  account_access_type = "CURRENT_ACCOUNT"

  # 認証プロバイダー
  # ユーザーがワークスペースにアクセスする際の認証方式を指定します。
  # 有効な値:
  # - AWS_SSO: AWS IAM Identity Center (旧 AWS SSO)
  # - SAML: SAML 2.0
  # 両方を同時に指定することも可能です。
  authentication_providers = ["SAML"]

  # アクセス許可タイプ
  # ワークスペースのIAMロールと権限の管理方式を指定します。
  # - SERVICE_MANAGED: IAMロールとポリシーを自動生成
  # - CUSTOMER_MANAGED: 既存のIAMロールを使用（role_arnの指定が必要）
  permission_type = "SERVICE_MANAGED"

  #---------------------------------------------------------------
  # オプションパラメータ
  #---------------------------------------------------------------

  # ワークスペース設定
  # JSON形式でワークスペースの詳細設定を指定します。
  # 設定可能な項目:
  # - plugins.pluginAdminEnabled: プラグイン管理の有効化
  # - unifiedAlerting.enabled: Grafanaアラート機能の有効化
  # 詳細: https://docs.aws.amazon.com/grafana/latest/userguide/AMG-configure-workspace.html
  configuration = jsonencode({
    plugins = {
      pluginAdminEnabled = true
    }
    unifiedAlerting = {
      enabled = true
    }
  })

  # データソース
  # ワークスペースで利用可能なAWSデータソースを指定します。
  # 有効な値:
  # - AMAZON_OPENSEARCH_SERVICE
  # - ATHENA
  # - CLOUDWATCH
  # - PROMETHEUS
  # - REDSHIFT
  # - SITEWISE
  # - TIMESTREAM
  # - TWINMAKER
  # - XRAY
  data_sources = ["CLOUDWATCH", "PROMETHEUS"]

  # ワークスペースの説明
  # ワークスペースの用途や目的を記述します。
  description = "Example Grafana workspace"

  # Grafanaバージョン
  # サポートされるバージョン: 8.4, 9.4, 10.4
  # 未指定の場合は最新バージョンが使用されます。
  grafana_version = "10.4"

  # ID
  # Terraform管理用のID。通常は computed 属性として自動生成されますが、
  # 明示的に指定することも可能です。
  # id = "g-xxxxxxxxxxxx"

  # ワークスペース名
  # ワークスペースを識別するための名前。
  # 未指定の場合は自動生成されます。
  name = "example-workspace"

  # 通知先
  # Amazon Managed Grafana が作成する IAM ロールと権限を使用する通知先。
  # 現在サポートされている値: SNS
  notification_destinations = ["SNS"]

  # 組織ロール名
  # AWS Organizations経由でデータソースにアクセスする際に使用するロール名。
  # account_access_type が ORGANIZATION の場合に使用します。
  # organization_role_name = "GrafanaOrgRole"

  # 組織単位
  # ワークスペースがデータソースへのアクセスを許可されている
  # AWS Organizations の組織単位(OU)のリスト。
  # account_access_type が ORGANIZATION の場合に指定します。
  # organizational_units = ["ou-xxxx-xxxxxxxx"]

  # リージョン
  # このリソースを管理するAWSリージョン。
  # 未指定の場合はプロバイダー設定のリージョンが使用されます。
  # 詳細: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-east-1"

  # IAMロールARN
  # permission_type が CUSTOMER_MANAGED の場合に必須。
  # ワークスペースが assume する IAM ロールの ARN を指定します。
  # SERVICE_MANAGED の場合は自動的にロールが作成されるため不要です。
  # role_arn = "arn:aws:iam::123456789012:role/GrafanaWorkspaceRole"

  # CloudFormation StackSet名
  # ワークスペースの IAM ロールをプロビジョニングする
  # AWS CloudFormation StackSet の名前。
  # stack_set_name = "GrafanaStackSet"

  # タグ
  # リソースに付与するタグ。
  # provider の default_tags と統合されます。
  tags = {
    Environment = "development"
    ManagedBy   = "terraform"
  }

  # すべてのタグ（読み取り専用）
  # provider の default_tags を含む全タグのマップ。
  # 通常は computed 属性として自動生成されます。
  # tags_all は明示的に指定する必要はありません。

  #---------------------------------------------------------------
  # ネストブロック: network_access_control
  #---------------------------------------------------------------
  # ワークスペースへのネットワークアクセスを制限する設定。
  # VPCエンドポイントまたはプレフィックスリストを使用して、
  # 特定のIPアドレス範囲またはVPCからのアクセスのみを許可できます。
  # 最大1つまで指定可能。
  # 詳細: https://docs.aws.amazon.com/grafana/latest/userguide/AMG-configure-nac.html

  # network_access_control {
  #   # プレフィックスリストID
  #   # Amazon VPC コンソールで作成したプレフィックスリストのIDを指定。
  #   # 形式: pl-xxxxxxxxx
  #   # プレフィックスリスト1つにつき最大100のIPアドレス範囲を含めることができます。
  #   # Amazon Managed Grafana は IPv4 アドレスのみをサポート。
  #   prefix_list_ids = ["pl-12345678"]
  #
  #   # VPCエンドポイントID
  #   # Grafana ワークスペース用のインターフェイス VPC エンドポイント ID。
  #   # 形式: vpce-xxxxxxxxx
  #   # サービスエンドポイント: com.amazonaws.[region].grafana-workspace
  #   # 他のVPCエンドポイントは無視されます。
  #   vpce_ids = ["vpce-12345678"]
  # }

  #---------------------------------------------------------------
  # ネストブロック: vpc_configuration
  #---------------------------------------------------------------
  # Amazon VPC 内のデータソースに接続するための設定。
  # ワークスペースがプライベートサブネット内のデータソースに
  # アクセスできるようにします。
  # 最大1つまで指定可能。

  # vpc_configuration {
  #   # セキュリティグループID
  #   # ワークスペースが接続する Amazon VPC にアタッチされた
  #   # Amazon EC2 セキュリティグループ ID のリスト。
  #   security_group_ids = ["sg-12345678"]
  #
  #   # サブネットID
  #   # ワークスペースが接続するために Amazon VPC 内に作成された
  #   # Amazon EC2 サブネット ID のリスト。
  #   # 複数のアベイラビリティゾーンにまたがるサブネットを推奨。
  #   subnet_ids = ["subnet-12345678", "subnet-87654321"]
  # }

  #---------------------------------------------------------------
  # タイムアウト設定
  #---------------------------------------------------------------

  timeouts {
    # 作成タイムアウト
    # ワークスペース作成のタイムアウト時間。
    # デフォルトは 30分。
    create = "30m"

    # 更新タイムアウト
    # ワークスペース更新のタイムアウト時間。
    # デフォルトは 30分。
    update = "30m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# 以下の属性はリソース作成後に参照可能です:
#
# - arn
#   Grafana ワークスペースの Amazon Resource Name (ARN)
#   例: arn:aws:grafana:us-east-1:123456789012:workspace/g-xxxxxxxxxxxx
#
# - endpoint
#   Grafana ワークスペースのエンドポイント URL
#   例: https://g-xxxxxxxxxxxx.grafana-workspace.us-east-1.amazonaws.com
#
# - grafana_version
#   ワークスペースで実行されている Grafana のバージョン
#   例: 10.4
#
# - saml_configuration_status
#   SAML設定のステータス
#   値: CONFIGURED または NOT_CONFIGURED
#
# - tags_all
#   provider の default_tags を含む、リソースに割り当てられた全タグのマップ
#
#---------------------------------------------------------------
