#--------------------------------------------------
# CodeBuild Webhook
#--------------------------------------------------
# CodeBuildプロジェクトに対するWebhook設定を管理します。
# GitHubやBitbucketなどのソースリポジトリからのイベントをトリガーとして
# ビルドを自動実行するための連携を構成します。
#
# 主な用途:
# - プルリクエストやプッシュイベントでの自動ビルド
# - ブランチやファイルパスによるフィルタリング
# - プルリクエストのビルド承認ポリシーの設定
#
# Provider Version: 6.28.0
# Generated: 2026-02-12
# Terraform Registry: https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/codebuild_webhook
#
# NOTE: このテンプレートはAWS Provider v6.28.0のスキーマから生成されています。
#       実際の利用環境に応じて、不要なパラメータは削除してください。
#--------------------------------------------------

resource "aws_codebuild_webhook" "example" {
  #---------------------------------------
  # 基本設定
  #---------------------------------------
  # 設定内容: Webhookを設定するCodeBuildプロジェクト名
  # 設定可能な値: 既存のCodeBuildプロジェクト名
  # 省略時: (必須項目)
  project_name = "example-project"

  #---------------------------------------
  # ビルド制御設定
  #---------------------------------------
  # 設定内容: フィルタリングするブランチ名のパターン
  # 設定可能な値: ブランチ名またはブランチ名のパターン（正規表現）
  # 省略時: すべてのブランチが対象
  # 注意: GitHubおよびGitHub Enterprise Serverでのみ使用可能
  branch_filter = "^refs/heads/main$"

  # 設定内容: ビルドのタイプ
  # 設定可能な値:
  #   - BUILD: 通常のビルド
  #   - BUILD_BATCH: バッチビルド
  # 省略時: BUILD
  build_type = "BUILD"

  # 設定内容: Webhookを手動で作成するかどうか
  # 設定可能な値:
  #   - true: Terraform外でWebhookが既に作成済み
  #   - false: Terraformが自動的にWebhookを作成
  # 省略時: false
  # 注意: trueの場合、ソースプロバイダ側での手動設定が必要
  manual_creation = false

  # 設定内容: リソースが管理されるAWSリージョン
  # 設定可能な値: AWSリージョンコード（us-east-1, ap-northeast-1など）
  # 省略時: プロバイダーで設定されたリージョン
  region = "us-east-1"

  #---------------------------------------
  # フィルタグループ設定
  #---------------------------------------
  # 設定内容: Webhookイベントをフィルタリングする条件のグループ
  # 構成: 複数のフィルタグループを設定可能（OR条件）
  # 注意: 各グループ内のfilterはAND条件として評価される
  filter_group {
    # 設定内容: イベントフィルタリングの個別条件
    # 構成: 複数のfilterを設定可能（このグループ内ではAND条件）
    filter {
      # 設定内容: フィルタパターン
      # 設定可能な値: イベントタイプに応じた正規表現パターン
      # 省略時: (必須項目)
      pattern = "PUSH"

      # 設定内容: フィルタのタイプ
      # 設定可能な値:
      #   - EVENT: Webhookイベントタイプ（PUSH, PULL_REQUEST_CREATED, PULL_REQUEST_UPDATED, PULL_REQUEST_MERGED, PULL_REQUEST_REOPENED）
      #   - BASE_REF: プルリクエストのベースブランチ
      #   - HEAD_REF: プルリクエストのヘッドブランチまたはプッシュされたブランチ
      #   - ACTOR_ACCOUNT_ID: GitHubアクターのアカウントID
      #   - FILE_PATH: 変更されたファイルのパス
      #   - COMMIT_MESSAGE: コミットメッセージ
      #   - TAG_NAME: Gitタグ名
      #   - RELEASE_NAME: リリース名
      # 省略時: (必須項目)
      type = "EVENT"

      # 設定内容: パターンマッチを除外するかどうか
      # 設定可能な値:
      #   - true: パターンに一致しない場合にビルドを実行
      #   - false: パターンに一致する場合にビルドを実行
      # 省略時: false
      exclude_matched_pattern = false
    }

    filter {
      pattern = "^refs/heads/main$"
      type    = "HEAD_REF"
    }
  }

  # 設定内容: 別のフィルタグループ（OR条件で評価）
  filter_group {
    filter {
      pattern = "PULL_REQUEST_CREATED|PULL_REQUEST_UPDATED"
      type    = "EVENT"
    }
  }

  #---------------------------------------
  # プルリクエストビルドポリシー設定
  #---------------------------------------
  # 設定内容: プルリクエストに対するビルドの承認ポリシー
  # 構成: 最大1つまで設定可能
  # 注意: GitHubおよびGitHub Enterpriseでのみ使用可能
  pull_request_build_policy {
    # 設定内容: コメントによる承認が必要かどうか
    # 設定可能な値:
    #   - ENABLE: コメント承認が必須
    #   - DISABLE: コメント承認は不要
    # 省略時: (必須項目)
    # 注意: ENABLEの場合、承認者がコメントすることでビルドが開始
    requires_comment_approval = "ENABLE"

    # 設定内容: ビルドを承認できるIAMロールのARN
    # 設定可能な値: IAMロールARNのセット
    # 省略時: すべてのユーザーが承認可能
    # 注意: GitHubチームまたはユーザーに関連付けられたIAMロールを指定
    approver_roles = [
      "arn:aws:iam::123456789012:role/CodeBuildApprover"
    ]
  }

  #---------------------------------------
  # スコープ設定
  #---------------------------------------
  # 設定内容: Webhookのスコープ設定（GitHubのみ）
  # 構成: 最大1つまで設定可能
  # 注意: GitHub App統合を使用する場合に設定
  scope_configuration {
    # 設定内容: スコープの名前
    # 設定可能な値: GitHubの組織名またはユーザー名
    # 省略時: (必須項目)
    name = "example-org"

    # 設定内容: スコープのタイプ
    # 設定可能な値:
    #   - GITHUB_ORGANIZATION: GitHub組織
    #   - GITHUB_GLOBAL: グローバルスコープ
    # 省略時: (必須項目)
    scope = "GITHUB_ORGANIZATION"

    # 設定内容: GitHubドメイン（GitHub Enterpriseの場合）
    # 設定可能な値: GitHub Enterpriseのドメイン名
    # 省略時: パブリックGitHub（github.com）を使用
    domain = "github.example.com"
  }
}

#---------------------------------------
# Attributes Reference（参照専用属性）
#---------------------------------------
# 以下の属性はリソース作成後に参照可能です:
#
# - id: WebhookのID（通常はproject_nameと同じ）
# - payload_url: WebhookのペイロードURL（ソースプロバイダに設定するURL）
# - secret: Webhookの署名検証用シークレット（センシティブ情報）
# - url: WebhookのURL（payload_urlのエイリアス）
