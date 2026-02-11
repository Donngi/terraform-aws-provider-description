#---------------------------------------------------------------
# Amazon Managed Grafana Workspace API Key
#---------------------------------------------------------------
#
# Amazon Managed GrafanaワークスペースのAPIキーをプロビジョニングするリソースです。
# APIキー（APIトークン）は、ワークスペースのHTTP APIへのリクエスト認証に使用されます。
# APIキーには有効期限（最大30日）と権限ロール（ADMIN/EDITOR/VIEWER）を設定できます。
#
# 注意: Grafana バージョン9以降では、APIキーの代わりにサービスアカウントの使用が
#       推奨されています。APIキーは将来のリリースで廃止される予定です。
#
# AWS公式ドキュメント:
#   - APIキーによる認証: https://docs.aws.amazon.com/grafana/latest/userguide/using-api-keys.html
#   - CreateWorkspaceApiKey API: https://docs.aws.amazon.com/grafana/latest/APIReference/API_CreateWorkspaceApiKey.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/grafana_workspace_api_key
#
# Provider Version: 6.28.0
# Generated: 2026-02-09
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_grafana_workspace_api_key" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # key_name (Required)
  # 設定内容: APIキーの名前を指定します。
  # 設定可能な値: 1〜100文字の文字列。ワークスペース内で一意である必要があります。
  # 参考: https://docs.aws.amazon.com/grafana/latest/APIReference/API_CreateWorkspaceApiKey.html
  key_name = "my-api-key"

  # key_role (Required)
  # 設定内容: APIキーに付与する権限ロールを指定します。
  # 設定可能な値:
  #   - "ADMIN": 最も広範な管理権限。ダッシュボード・フォルダ・データソース・ユーザー・
  #              チーム・プラグイン・組織設定すべてのフル操作が可能
  #   - "EDITOR": ダッシュボード・プレイリスト・フォルダのフル操作とExplore機能が利用可能。
  #               データソースやユーザー管理などの権限はなし
  #   - "VIEWER": ダッシュボード・プレイリストの閲覧のみ可能
  # 参考: https://docs.aws.amazon.com/grafana/latest/userguide/using-api-keys.html
  key_role = "VIEWER"

  #-------------------------------------------------------------
  # 有効期限設定
  #-------------------------------------------------------------

  # seconds_to_live (Required)
  # 設定内容: APIキーの有効期限を秒数で指定します。
  # 設定可能な値: 1〜2592000（最大30日間 = 30 * 24 * 60 * 60）
  # 注意: セキュリティの観点から、できるだけ短い有効期限を設定することが推奨されています。
  # 参考: https://docs.aws.amazon.com/grafana/latest/APIReference/API_CreateWorkspaceApiKey.html
  seconds_to_live = 3600

  #-------------------------------------------------------------
  # ワークスペース設定
  #-------------------------------------------------------------

  # workspace_id (Required)
  # 設定内容: APIキーを作成する対象のGrafanaワークスペースIDを指定します。
  # 設定可能な値: ワークスペースID（パターン: g-[0-9a-f]{10}）
  # 参考: https://docs.aws.amazon.com/grafana/latest/userguide/using-api-keys.html
  workspace_id = aws_grafana_workspace.example.id

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
# - id: リソースの識別子
#
# - key: APIキートークン（JSON形式）。この値をBearerトークンとして使用し、
#         ワークスペースへのHTTPリクエストを認証します。
#         ※ sensitive属性としてマークされています。
#---------------------------------------------------------------
