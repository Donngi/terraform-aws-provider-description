# ================================================================================
# Terraform AWS Resource Template: aws_codebuild_webhook
# ================================================================================
# Generated: 2026-01-19
# Provider Version: 6.28.0
#
# 注意事項:
# - このテンプレートは生成時点での情報に基づいています
# - 最新の仕様や詳細については、必ず公式ドキュメントをご確認ください
# - AWS Provider公式ドキュメント: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codebuild_webhook
# ================================================================================

# aws_codebuild_webhook
# CodeBuildプロジェクトのWebhookを管理するリソース。
# ソースコードリポジトリからビルドをトリガーするために、CodeBuildサービスが受け入れるエンドポイントを作成します。
# プロジェクトのソースタイプによっては、CodeBuildサービスが実際のリポジトリWebhookの作成と削除も自動的に行います。
#
# 公式ドキュメント:
# - Resource: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codebuild_webhook
# - AWS API: https://docs.aws.amazon.com/codebuild/latest/APIReference/API_CreateWebhook.html
# - GitHub Webhook Events: https://docs.aws.amazon.com/codebuild/latest/userguide/github-webhook.html

resource "aws_codebuild_webhook" "example" {
  # ================================================================================
  # 必須パラメータ
  # ================================================================================

  # project_name - (必須) ビルドプロジェクトの名前
  # Type: string
  # このWebhookを関連付けるCodeBuildプロジェクトの名前を指定します。
  project_name = "example-project"

  # ================================================================================
  # オプションパラメータ
  # ================================================================================

  # build_type - (オプション) このWebhookがトリガーするビルドのタイプ
  # Type: string
  # 有効な値: BUILD, BUILD_BATCH
  # - BUILD: 単一のビルドをトリガー
  # - BUILD_BATCH: バッチビルドをトリガー
  # デフォルト: BUILD
  build_type = "BUILD"

  # branch_filter - (オプション) どのブランチをビルドするかを決定する正規表現
  # Type: string
  # デフォルトでは全てのブランチがビルドされます。
  # 注意: filter_groupの使用を推奨します（より柔軟なフィルタリングが可能）
  # 例: "^refs/heads/main$" (mainブランチのみ)
  # 参考: https://docs.aws.amazon.com/codebuild/latest/userguide/github-webhook.html
  branch_filter = "^refs/heads/(main|develop)$"

  # manual_creation - (オプション) 手動でのWebhook作成を行うかどうか
  # Type: bool
  # trueの場合、CodeBuildはGitHubにWebhookを作成せず、代わりにpayload_urlとsecret値を返します。
  # これらの値を使用して、GitHub内で手動でWebhookを作成できます。
  # GitHub Enterpriseなど、CodeBuildが自動でWebhookを作成できない場合に使用します。
  # デフォルト: false
  manual_creation = false

  # region - (オプション) このリソースが管理されるリージョン
  # Type: string
  # プロバイダー設定で設定されたリージョンがデフォルトで使用されます。
  # 明示的に指定することで、プロバイダーのリージョンと異なるリージョンでリソースを管理できます。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-east-1"

  # ================================================================================
  # ネストブロック: filter_group
  # ================================================================================

  # filter_group - (オプション) Webhookのトリガーに関する情報
  # 複数のfilter_groupを指定可能（set型）
  # いずれかのfilter_groupの条件が満たされた場合にビルドがトリガーされます。
  # 各filter_group内の全てのfilterが満たされる必要があります（AND条件）。
  # 参考: https://docs.aws.amazon.com/codebuild/latest/userguide/github-webhook.html

  # 例1: PUSHイベントでmainブランチへのプッシュ時にビルド
  filter_group {
    filter {
      # type - (必須) Webhookフィルターグループのタイプ
      # 有効な値: EVENT, BASE_REF, HEAD_REF, ACTOR_ACCOUNT_ID, FILE_PATH,
      #          COMMIT_MESSAGE, WORKFLOW_NAME, TAG_NAME, RELEASE_NAME
      # 少なくとも1つのfilter groupでEVENTタイプを指定する必要があります。
      type = "EVENT"

      # pattern - (必須) フィルターのパターン
      # EVENTタイプの場合: カンマ区切りのイベント文字列
      #   有効なイベント: PUSH, PULL_REQUEST_CREATED, PULL_REQUEST_UPDATED,
      #                  PULL_REQUEST_REOPENED, PULL_REQUEST_MERGED, WORKFLOW_JOB_QUEUED
      #   注: WORKFLOW_JOB_QUEUEDはGitHub & GitHub Enterpriseのみ対応
      # その他のタイプの場合: 正規表現
      pattern = "PUSH"

      # exclude_matched_pattern - (オプション) パターンに一致した場合にビルドをトリガーしないかどうか
      # Type: bool
      # trueに設定すると、指定されたフィルターはビルドをトリガーしません。
      # デフォルト: false
      # exclude_matched_pattern = false
    }

    filter {
      type    = "BASE_REF"
      pattern = "^refs/heads/main$"
    }
  }

  # 例2: プルリクエスト作成・更新時のビルド（特定のユーザーを除外）
  filter_group {
    filter {
      type    = "EVENT"
      pattern = "PULL_REQUEST_CREATED, PULL_REQUEST_UPDATED"
    }

    filter {
      type    = "BASE_REF"
      pattern = "^refs/heads/main$"
    }

    filter {
      type                    = "ACTOR_ACCOUNT_ID"
      pattern                 = "12345"
      exclude_matched_pattern = true
    }
  }

  # 例3: 特定のファイルパスに変更があった場合のビルド
  filter_group {
    filter {
      type    = "EVENT"
      pattern = "PUSH"
    }

    filter {
      type    = "FILE_PATH"
      pattern = "^src/.*\\.js$"
    }
  }

  # ================================================================================
  # ネストブロック: pull_request_build_policy
  # ================================================================================

  # pull_request_build_policy - (オプション) プルリクエストでビルドをトリガーする際のコメントベースの承認要件を定義
  # 最大1つまで指定可能
  # プルリクエストに対するビルドの承認ポリシーを設定します。
  # 参考: https://docs.aws.amazon.com/codebuild/latest/userguide/pull-request-build-policy.html

  pull_request_build_policy {
    # requires_comment_approval - (必須) プルリクエストでビルドをトリガーする前にコメントベースの承認が必要となるタイミング
    # Type: string
    # 有効な値:
    # - DISABLED: コメント承認を無効化
    # - ALL_PULL_REQUESTS: 全てのプルリクエストで承認が必要
    # - FORK_PULL_REQUESTS: フォークからのプルリクエストのみ承認が必要
    requires_comment_approval = "FORK_PULL_REQUESTS"

    # approver_roles - (オプション) コメント承認が必要な場合に承認権限を持つリポジトリロールのリスト
    # Type: set(string)
    # requires_comment_approvalがDISABLED以外の場合に指定可能
    # 有効な値とデフォルトはAWSドキュメントを参照してください。
    # 参考: https://docs.aws.amazon.com/codebuild/latest/userguide/pull-request-build-policy.html#pull-request-build-policy.configuration
    approver_roles = ["OWNER", "WRITE"]
  }

  # ================================================================================
  # ネストブロック: scope_configuration
  # ================================================================================

  # scope_configuration - (オプション) グローバルまたは組織のWebhookのスコープ設定
  # 最大1つまで指定可能
  # GitHub EnterpriseまたはGitHub組織全体に対してWebhookを設定する場合に使用します。

  scope_configuration {
    # name - (必須) エンタープライズまたは組織の名前
    # Type: string
    name = "my-organization"

    # scope - (必須) GitHub Webhookのスコープタイプ
    # Type: string
    # 有効な値:
    # - GITHUB_ORGANIZATION: GitHub組織レベルのWebhook
    # - GITHUB_GLOBAL: GitHub EnterpriseグローバルレベルのWebhook
    scope = "GITHUB_ORGANIZATION"

    # domain - (オプション) GitHub Enterpriseエンタープライズ組織のドメイン
    # Type: string
    # プロジェクトのソースタイプがGITHUB_ENTERPRISEの場合は必須です。
    # domain = "github.example.com"
  }
}

# ================================================================================
# Computed属性（出力のみ）
# ================================================================================
# 以下の属性は、Terraformによって自動的に計算され、参照可能です:
#
# - id (string): ビルドプロジェクトの名前
# - payload_url (string): WebhookイベントがCodeBuildに送信されるエンドポイントURL
#   manual_creation = trueの場合、この値を使用してGitHubで手動でWebhookを設定します。
#
# - secret (string, sensitive): 関連付けられたリポジトリのシークレットトークン
#   全てのソースタイプでCodeBuild APIから返されるわけではありません。
#   注意: secretはリソース作成時にのみ設定されるため、手動でローテーションした場合、
#         Terraformは後続の実行で変更を検出できません。
#         その場合はWebhookリソースをtaintして再作成する必要があります。
#
# - url (string): WebhookのURL
#
# 使用例:
# output "webhook_url" {
#   value = aws_codebuild_webhook.example.url
# }
#
# output "webhook_payload_url" {
#   value = aws_codebuild_webhook.example.payload_url
# }
