#---------------------------------------------------------------
# Amazon Managed Grafana Workspace Service Account
#---------------------------------------------------------------
#
# Amazon Managed Grafana ワークスペースのサービスアカウントを作成します。
# サービスアカウントは、Grafana HTTP APIでの認証に使用され、
# ダッシュボードのプロビジョニング、設定、レポート生成などの
# 自動化されたワークロードを実行するために使用されます。
#
# 注意事項:
#   - サービスアカウントは Grafana 9.x 以降でのみ使用可能です
#   - サービスアカウントは課金対象のユーザーとしてカウントされます
#   - サービスアカウントの属性を変更すると、Terraform は既存のものを削除し新しいものを作成します
#   - サービスアカウントは API キーに代わる主要な認証方法として推奨されています
#
# AWS公式ドキュメント:
#   - Use service accounts to authenticate with the Grafana HTTP APIs: https://docs.aws.amazon.com/grafana/latest/userguide/service-accounts.html
#   - CreateWorkspaceServiceAccount API: https://docs.aws.amazon.com/grafana/latest/APIReference/API_CreateWorkspaceServiceAccount.html
#   - User roles: https://docs.aws.amazon.com/grafana/latest/userguide/Grafana-user-roles.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/grafana_workspace_service_account
#
# Provider Version: 6.28.0
# Generated: 2026-01-27
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_grafana_workspace_service_account" "example" {
  #---------------------------------------------------------------
  # 必須パラメータ
  #---------------------------------------------------------------

  # サービスアカウントの名前
  # - ワークスペース内で一意である必要があります
  # - この名前はサービスアカウントに関連付けられる ID を決定します
  # - 一貫性のある命名規則を使用することを推奨します（例: "example-admin", "automation-editor"）
  # - サービスアカウントのスケーリングと保守を容易にするため、規則的な命名を心がけてください
  # - 表示名はいつでも変更可能です
  name = "example-admin"

  # サービスアカウントの権限レベル
  # - このサービスアカウントに使用する Grafana ロールを指定します
  # - 有効な値: "ADMIN", "EDITOR", "VIEWER"
  # - ADMIN: データソース、ユーザー、チーム、フォルダの管理が可能で、すべての機能へのフルアクセス権を持つ
  # - EDITOR: コンテンツの表示、編集、作成が可能だが、データソースやユーザーの管理はできない
  # - VIEWER: コンテンツの表示のみが可能
  # - 各ロールの詳細な権限については、以下のドキュメントを参照してください
  #   https://docs.aws.amazon.com/grafana/latest/userguide/Grafana-user-roles.html
  grafana_role = "ADMIN"

  # サービスアカウントが関連付けられる Grafana ワークスペース
  # - このサービスアカウントが属する Amazon Managed Grafana ワークスペースの ID を指定します
  # - 通常は aws_grafana_workspace リソースの id 属性を参照します
  workspace_id = aws_grafana_workspace.example.id

  #---------------------------------------------------------------
  # オプションパラメータ
  #---------------------------------------------------------------

  # リージョン設定
  # - このリソースが管理されるリージョンを指定します
  # - 省略した場合、プロバイダー設定で指定されたリージョンがデフォルトで使用されます
  # - リージョナルエンドポイントの詳細: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-east-1"
}

#---------------------------------------------------------------
# Attributes Reference (computed only - 読み取り専用属性)
#---------------------------------------------------------------
#
# このリソースは以下の属性をエクスポートします:
#
# - id
#   リソースの識別子（形式は通常 workspace_id:service_account_id）
#
# - service_account_id
#   指定された Grafana ワークスペース内でのサービスアカウントの識別子
#   この ID は、サービスアカウントトークンの作成時などに使用されます
#
#---------------------------------------------------------------
# 使用例: サービスアカウントトークンの作成
#---------------------------------------------------------------
#
# サービスアカウントを作成した後、通常はアクセストークンを生成して
# アプリケーションやツール（Terraform、CI/CD パイプラインなど）から
# Grafana API にアクセスするために使用します。
#
# トークンの作成方法:
#   1. Grafana コンソールにサインインし、「Administration」メニューを選択
#   2. 「Users and Access」を展開し、「Service accounts」を選択
#   3. 対象のサービスアカウントを選択
#   4. 「Add service account token」を選択
#   5. トークン名と有効期限（最大30日）を入力
#   6. 「Generate token」を選択
#
# または、AWS API を使用してプログラマティックに作成:
#   - CreateWorkspaceServiceAccountToken API を使用
#   - https://docs.aws.amazon.com/grafana/latest/APIReference/API_CreateWorkspaceServiceAccountToken.html
#
# 注意: サービスアカウントは複数のトークンを持つことができます。
#       同じ権限を使用する複数のアプリケーションがある場合や、
#       トークンのローテーションが必要な場合に便利です。
#
#---------------------------------------------------------------
# 制限事項とクォータ
#---------------------------------------------------------------
#
# - サービスアカウントトークンには数量制限があります（有効期限が切れたトークンも含む）
# - トークンを削除することでクォータから除外されます
# - 詳細: https://docs.aws.amazon.com/grafana/latest/userguide/AMG_quotas.html
#
#---------------------------------------------------------------
