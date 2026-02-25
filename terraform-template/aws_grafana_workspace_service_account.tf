#---------------------------------------------------------------
# Amazon Managed Grafana ワークスペース サービスアカウント
#---------------------------------------------------------------
#
# Amazon Managed Grafana ワークスペースにサービスアカウントを作成します。
# サービスアカウントは、人間ユーザーの代わりにプログラムからGrafana APIを
# 呼び出す際に使用するアカウントです。Grafanaのロールを割り当てることで、
# ワークスペースへのアクセス権限を付与します。
#
# AWS公式ドキュメント:
#   - Amazon Managed Grafana サービスアカウント:
#       https://docs.aws.amazon.com/grafana/latest/userguide/service-accounts.html
#   - Amazon Managed Grafana API:
#       https://docs.aws.amazon.com/grafana/latest/APIReference/Welcome.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/grafana_workspace_service_account
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_grafana_workspace_service_account" "example" {
  #-------------------------------------------------------------
  # ワークスペース設定
  #-------------------------------------------------------------

  # workspace_id (Required)
  # 設定内容: サービスアカウントを作成するGrafanaワークスペースのIDを指定します。
  # 設定可能な値: aws_grafana_workspace リソースの id 属性
  workspace_id = "g-xxxxxxxxxxxx"

  #-------------------------------------------------------------
  # サービスアカウント設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: サービスアカウントの名前を指定します。
  # 設定可能な値: Grafanaワークスペース内で一意の文字列
  name = "example-service-account"

  # grafana_role (Required)
  # 設定内容: サービスアカウントに付与するGrafanaのロールを指定します。
  # 設定可能な値:
  #   - "ADMIN": ワークスペースへの完全な管理アクセス権限
  #   - "EDITOR": ダッシュボードの作成・編集権限
  #   - "VIEWER": ダッシュボードの閲覧のみの権限
  grafana_role = "VIEWER"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: リソースを識別するID（workspace_id と service_account_id の組み合わせ）
# - service_account_id: 作成されたサービスアカウントのID
#---------------------------------------------------------------
