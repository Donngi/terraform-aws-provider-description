#---------------------------------------------------------------
# AWS Grafana Workspace Service Account Token
#---------------------------------------------------------------
#
# Amazon Managed Grafanaワークスペースのサービスアカウントトークンを作成するための
# リソースです。サービスアカウントトークンは、GrafanaのHTTP APIへの認証に使用される
# 生成された文字列であり、ダッシュボードのプロビジョニング、設定、レポート生成などの
# 自動化ワークロードに利用されます。
#
# 注意: サービスアカウントトークンは更新できません。属性を変更すると、Terraformは
#       既存のトークンを削除して新しいトークンを作成します。
#
# サービスアカウントはGrafana 9.x以降で利用可能であり、APIキーに代わる
# 推奨される認証方法です。サービスアカウントには以下の利点があります:
#   - 複数のトークンを関連付けることが可能
#   - 特定のユーザーに紐付かないため、ユーザーが削除されても認証が維持される
#   - サービスアカウント単位で権限を付与可能
#   - トークンごとに個別の監査・管理が可能
#
# AWS公式ドキュメント:
#   - サービスアカウント: https://docs.aws.amazon.com/grafana/latest/userguide/service-accounts.html
#   - API認証: https://docs.aws.amazon.com/grafana/latest/userguide/authenticating-grafana-apis.html
#   - API Reference: https://docs.aws.amazon.com/grafana/latest/APIReference/API_CreateWorkspaceServiceAccountToken.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/grafana_workspace_service_account_token
#
# Provider Version: 6.28.0
# Generated: 2026-02-09
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_grafana_workspace_service_account_token" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required, Forces new resource)
  # 設定内容: サービスアカウントトークンの名前を指定します。
  # 設定可能な値: 文字列（ワークスペース内で一意である必要があります）
  # 注意: トークンの名前を変更すると、既存のトークンが削除され新しいトークンが作成されます。
  name = "example-key"

  # service_account_id (Required, Forces new resource)
  # 設定内容: トークンを作成するサービスアカウントのIDを指定します。
  # 設定可能な値: サービスアカウントID文字列
  # 注意: aws_grafana_workspace_service_accountリソースの
  #       service_account_id属性を参照することが推奨されます。
  service_account_id = aws_grafana_workspace_service_account.example.service_account_id

  # workspace_id (Required, Forces new resource)
  # 設定内容: サービスアカウントトークンが関連付けられるGrafanaワークスペースのIDを指定します。
  # 設定可能な値: ワークスペースID文字列
  # 注意: aws_grafana_workspaceリソースのid属性を参照することが推奨されます。
  workspace_id = aws_grafana_workspace.example.id

  # seconds_to_live (Required, Forces new resource)
  # 設定内容: トークンの有効期間を秒数で指定します。
  # 設定可能な値: 数値（最大30日間 = 2592000秒）
  # 注意: 有効期間が経過すると、トークンは自動的に期限切れとなります。
  #       期限切れのトークンもクォータにカウントされるため、
  #       不要になったトークンは削除してクォータを解放してください。
  # 例:
  #   - 3600: 1時間
  #   - 86400: 1日
  #   - 604800: 7日
  #   - 2592000: 30日
  seconds_to_live = 3600

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: サービスアカウントトークンのID
#
# - service_account_token_id: 指定されたGrafanaワークスペース内の
#     サービスアカウントトークンの識別子
#
# - created_at: サービスアカウントトークンが作成された日時を示すタイムスタンプ
#
# - expires_at: サービスアカウントトークンが期限切れになる日時を示すタイムスタンプ
#
# - key (Sensitive): サービスアカウントトークンのキー文字列。
#     GrafanaのHTTP APIへのリクエストの認証・認可に使用されます。
#     この値は作成時にのみ取得可能であり、後から参照することはできません。
#     AWS Secrets Managerなどに安全に保管することが推奨されます。
#---------------------------------------------------------------
