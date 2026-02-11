#
# Terraform Template: aws_codepipeline_webhook
#
# Generated: 2026-01-19
# Provider Version: hashicorp/aws 6.28.0
#
# Note: このテンプレートは生成時点の情報に基づいています。
#       最新の仕様については公式ドキュメントを確認してください。
#       https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codepipeline_webhook
#

resource "aws_codepipeline_webhook" "example" {
  # ====================
  # 必須パラメータ
  # ====================

  # Webhook の名前
  # 1-100文字のパターン: [A-Za-z0-9.@\-_]+
  # https://docs.aws.amazon.com/codepipeline/latest/APIReference/API_WebhookDefinition.html
  name = "test-webhook-github-bar"

  # 認証タイプ
  # 有効な値: "IP", "GITHUB_HMAC", "UNAUTHENTICATED"
  # - IP: IP アドレス範囲によるフィルタリング (authentication_configuration で allowed_ip_range が必須)
  # - GITHUB_HMAC: GitHub の HMAC 署名による認証 (authentication_configuration で secret_token が必須)
  # - UNAUTHENTICATED: 認証なし (セキュリティ上推奨されません)
  # セキュリティのため、各 webhook に一意のシークレットトークンを生成することを推奨
  # https://docs.aws.amazon.com/codepipeline/latest/APIReference/API_WebhookDefinition.html
  authentication = "GITHUB_HMAC"

  # Webhook を接続するパイプライン内のアクション名
  # パイプラインのソース (最初の) ステージのアクションである必要があります
  # 1-100文字のパターン: [A-Za-z0-9.@\-_]+
  # https://docs.aws.amazon.com/codepipeline/latest/APIReference/API_WebhookDefinition.html
  target_action = "Source"

  # Webhook を接続するパイプラインの名前
  # 1-100文字のパターン: [A-Za-z0-9.@\-_]+
  # https://docs.aws.amazon.com/codepipeline/latest/APIReference/API_WebhookDefinition.html
  target_pipeline = "tf-test-pipeline"

  # ====================
  # オプションパラメータ
  # ====================

  # リソース ID
  # オプション。指定しない場合は ARN が使用されます (computed)
  # id = ""

  # リージョン指定
  # このリソースが管理されるリージョン
  # デフォルトではプロバイダー設定のリージョンが使用されます
  # https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-east-1"

  # リソースタグ
  # キーと値のマップ形式でタグを指定
  # provider の default_tags 設定ブロックと併用可能
  # https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  tags = {
    Environment = "production"
    Project     = "example-project"
  }

  # 全タグ (default_tags を含む)
  # プロバイダーレベルで設定された default_tags とマージされた全タグのマップ
  # このフィールドは computed であり、通常は明示的に設定しません
  # tags_all = {}

  # ====================
  # ネストブロック: authentication_configuration
  # ====================
  # 認証設定ブロック
  # authentication が "IP" または "GITHUB_HMAC" の場合は必須
  # max_items: 1
  # https://docs.aws.amazon.com/codepipeline/latest/APIReference/API_WebhookAuthConfiguration.html

  authentication_configuration {
    # GitHub リポジトリ webhook の共有シークレット
    # GITHUB_HMAC 認証の場合に必須
    # GitHub の repository webhook の configuration ブロックで secret として設定する値
    # セキュリティのため、各 webhook に一意のトークンを生成することを推奨
    # 1-100文字、レスポンスでは編集されます (sensitive)
    # https://docs.aws.amazon.com/codepipeline/latest/APIReference/API_WebhookAuthConfiguration.html
    secret_token = "super-secret-token"

    # IP フィルタリング用の有効な CIDR ブロック
    # IP 認証の場合に必須
    # 1-100文字
    # https://docs.aws.amazon.com/codepipeline/latest/APIReference/API_WebhookAuthConfiguration.html
    # allowed_ip_range = "0.0.0.0/0"
  }

  # ====================
  # ネストブロック: filter
  # ====================
  # Webhook URL に送信される POST リクエストの body/payload に適用されるルール
  # 定義された全てのルールが一致する必要があります
  # min_items: 1, max_items: 5
  # https://docs.aws.amazon.com/codepipeline/latest/APIReference/API_WebhookFilterRule.html

  filter {
    # フィルタリング対象の JSON パス
    # JSON Path 形式で指定
    # https://github.com/json-path/JsonPath
    json_path = "$.ref"

    # マッチさせる値
    # 例: "refs/heads/{Branch}" (ブランチ名にマッチ)
    # AWS ドキュメント: https://docs.aws.amazon.com/codepipeline/latest/APIReference/API_WebhookFilterRule.html
    match_equals = "refs/heads/{Branch}"
  }

  # 複数のフィルタールールを定義可能 (最大5つ)
  # filter {
  #   json_path    = "$.repository.name"
  #   match_equals = "my-repository"
  # }
}

# ====================
# Computed Attributes (参照のみ)
# ====================
# これらの属性は Terraform によって自動的に計算され、出力として使用できます
# テンプレート内で値を設定することはできません

# output "webhook_arn" {
#   description = "CodePipeline webhook の ARN"
#   value       = aws_codepipeline_webhook.example.arn
# }

# output "webhook_url" {
#   description = "CodePipeline webhook の URL。このエンドポイントに POST イベントを送信してターゲットをトリガーします"
#   value       = aws_codepipeline_webhook.example.url
# }

# ====================
# 使用例: GitHub との統合
# ====================
# GitHub リポジトリ webhook と連携する完全な例

# locals {
#   webhook_secret = "super-secret-token"  # 本番環境では SSM Parameter Store や環境変数から取得することを推奨
# }

# resource "aws_codepipeline" "example" {
#   name     = "tf-test-pipeline"
#   role_arn = aws_iam_role.codepipeline_role.arn
#
#   artifact_store {
#     location = aws_s3_bucket.codepipeline_bucket.bucket
#     type     = "S3"
#   }
#
#   stage {
#     name = "Source"
#
#     action {
#       name             = "Source"
#       category         = "Source"
#       owner            = "ThirdParty"
#       provider         = "GitHub"
#       version          = "1"
#       output_artifacts = ["source_output"]
#
#       configuration = {
#         Owner  = "my-organization"
#         Repo   = "my-repo"
#         Branch = "main"
#       }
#     }
#   }
#
#   stage {
#     name = "Build"
#
#     action {
#       name            = "Build"
#       category        = "Build"
#       owner           = "AWS"
#       provider        = "CodeBuild"
#       input_artifacts = ["source_output"]
#       version         = "1"
#
#       configuration = {
#         ProjectName = "my-project"
#       }
#     }
#   }
# }

# resource "github_repository_webhook" "example" {
#   repository = "my-repo"
#   name       = "web"
#
#   configuration {
#     url          = aws_codepipeline_webhook.example.url
#     content_type = "json"
#     insecure_ssl = false
#     secret       = local.webhook_secret
#   }
#
#   events = ["push"]
# }

# ====================
# 参考リンク
# ====================
# Terraform AWS Provider Documentation:
#   https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codepipeline_webhook
#
# AWS API Reference:
#   https://docs.aws.amazon.com/codepipeline/latest/APIReference/API_WebhookDefinition.html
#   https://docs.aws.amazon.com/codepipeline/latest/APIReference/API_WebhookAuthConfiguration.html
#   https://docs.aws.amazon.com/codepipeline/latest/APIReference/API_WebhookFilterRule.html
#   https://docs.aws.amazon.com/codepipeline/latest/APIReference/API_PutWebhook.html
