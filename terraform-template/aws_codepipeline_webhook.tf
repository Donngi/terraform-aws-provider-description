#-------
# CodePipeline Webhook
# https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/codepipeline_webhook
#
# Provider Version: 6.28.0
# Generated: 2026-02-13
#
# NOTE:
# CodePipelineとソースコードリポジトリ（GitHub等）を連携するためのWebhookリソース。
# リポジトリでのプッシュやプルリクエストイベントを検知してパイプラインを自動実行する。
# 認証方式はGitHub HMAC推奨、IPアドレス制限も併用可能。
# フィルター条件で特定ブランチやファイルパスのみを対象にできる。
#-------

#-------
# 基本設定
#-------
resource "aws_codepipeline_webhook" "example" {
  # Webhook名
  # 設定内容: CodePipeline Webhookの一意な名前
  name = "example-webhook"

  # ターゲットパイプライン
  # 設定内容: Webhookがトリガーする対象のCodePipelineパイプライン名
  target_pipeline = "example-pipeline"

  # ターゲットアクション
  # 設定内容: Webhookがトリガーする対象のパイプラインアクション名（通常はSource）
  target_action = "Source"

  # 認証方式
  # 設定内容: Webhookの認証方式
  # 設定可能な値:
  #   - GITHUB_HMAC: GitHub HMAC署名による認証
  #   - IP: 送信元IPアドレスによる認証
  #   - UNAUTHENTICATED: 認証なし（非推奨）
  authentication = "GITHUB_HMAC"

  #-------
  # 認証設定
  #-------
  authentication_configuration {
    # シークレットトークン
    # 設定内容: GitHub HMAC認証で使用するシークレットトークン
    # 省略時: authentication="GITHUB_HMAC"の場合は必須
    # 注意: 機密情報のため環境変数やSecrets Managerから取得推奨
    secret_token = var.webhook_secret_token

    # 許可IPアドレス範囲
    # 設定内容: IP認証で許可するIPアドレス範囲（CIDR形式）
    # 省略時: authentication="IP"の場合は必須
    # allowed_ip_range = "192.0.2.0/24"
  }

  #-------
  # フィルター設定
  #-------
  # Webhookペイロードのフィルタリング条件（最大5個まで設定可能）
  filter {
    # JSONパス
    # 設定内容: Webhookペイロード内の評価対象フィールドへのJSONPath式
    # 例: "$.ref"（Gitリファレンス）、"$.head_commit.message"（コミットメッセージ）
    json_path = "$.ref"

    # マッチ条件
    # 設定内容: json_pathで指定したフィールドと一致すべき値
    # 例: "refs/heads/main"（mainブランチのみ）、"refs/heads/feature/*"（featureブランチ）
    match_equals = "refs/heads/{Branch}"
  }

  # 複数のフィルター条件を設定する例（AND条件）
  # filter {
  #   json_path    = "$.head_commit.modified"
  #   match_equals = "path/to/file"
  # }

  #-------
  # タグ設定
  #-------
  # リソースタグ
  # 設定内容: Webhookに付与するタグ（Key-Value形式）
  # 省略時: タグなし
  tags = {
    Environment = "production"
    ManagedBy   = "terraform"
  }

  #-------
  # リージョン設定
  #-------
  # AWSリージョン
  # 設定内容: Webhookを作成するAWSリージョン
  # 省略時: プロバイダー設定のリージョンを使用
  region = "us-east-1"
}

#-------
# Attributes Reference
#-------
# 以下の属性がエクスポートされ、他のリソースから参照可能:
#
# - id: Webhook名（nameと同じ）
# - arn: WebhookのARN（Amazon Resource Name）
# - url: WebhookエンドポイントのURL（GitHubリポジトリ設定で使用）
# - tags_all: デフォルトタグを含む全てのタグのマップ
