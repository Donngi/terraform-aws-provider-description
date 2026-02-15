#-------
# AWS CodeStar Notifications - Notification Rule (通知ルール)
#-------
# 用途: CodeCommit、CodeBuild、CodePipeline等のAWSリソースイベントをSNS/Chatbotに通知
# 制限事項:
#   - 最大10個のターゲットまで設定可能
#   - 作成時は最低1つのターゲットが必須
#   - イベントタイプはリソース種別により異なる
# 参考: https://docs.aws.amazon.com/codestar-notifications/latest/userguide/
# Provider Version: 6.28.0
# Generated: 2026-02-13
# Terraform Registry: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codestarnotifications_notification_rule
# NOTE: このテンプレートは参考例です。実際の環境に合わせて適宜修正してください。
#-------

resource "aws_codestarnotifications_notification_rule" "example" {
  #-------
  # 基本設定
  #-------
  # 設定内容: 通知ルールの名前
  # 制約事項: リソース作成後の変更は新規リソース作成となる
  name = "example-notification-rule"

  # 設定内容: 通知する詳細レベル
  # 設定可能な値:
  #   - BASIC: 最小限の情報（イベント発生の通知のみ）
  #   - FULL: 詳細情報（イベントの詳細情報を含む）
  detail_type = "BASIC"

  # 設定内容: 監視対象のAWSリソースARN
  # 対象例: CodeCommit Repository, CodeBuild Project, CodePipeline等
  # 注意事項: リソース削除時は事前に通知ルールを削除推奨
  resource = "arn:aws:codecommit:ap-northeast-1:123456789012:example-repo"

  # 設定内容: 通知するイベントタイプのリスト
  # イベント例（CodeCommit）:
  #   - codecommit-repository-comments-on-commits: コミットへのコメント
  #   - codecommit-repository-pull-request-created: プルリクエスト作成
  #   - codecommit-repository-pull-request-merged: プルリクエストマージ
  # イベント例（CodeBuild）:
  #   - codebuild-project-build-state-failed: ビルド失敗
  #   - codebuild-project-build-state-succeeded: ビルド成功
  # イベント例（CodePipeline）:
  #   - codepipeline-pipeline-pipeline-execution-failed: パイプライン実行失敗
  #   - codepipeline-pipeline-pipeline-execution-succeeded: パイプライン実行成功
  # 参考: https://docs.aws.amazon.com/codestar-notifications/latest/userguide/concepts.html#concepts-api
  event_type_ids = [
    "codecommit-repository-comments-on-commits",
    "codecommit-repository-pull-request-created"
  ]

  #-------
  # 通知先設定
  #-------
  # 設定内容: 通知先ターゲットの設定（最大10個）
  # 要件: 作成時は最低1つ必須
  target {
    # 設定内容: 通知先のARN
    # SNSの場合: SNSトピックARN
    # Chatbotの場合: ChatbotクライアントARN
    # 注意事項: SNSトピックには適切なポリシーが必要（codestar-notifications.amazonaws.comからのPublish許可）
    address = "arn:aws:sns:ap-northeast-1:123456789012:notifications"

    # 設定内容: 通知先のタイプ
    # 設定可能な値:
    #   - SNS: Amazon SNSトピック（デフォルト）
    #   - AWSChatbotSlack: AWS Chatbot（Slack）
    #   - AWSChatbotMicrosoftTeams: AWS Chatbot（Microsoft Teams）
    # 省略時: SNS
    type = "SNS"
  }

  # 複数ターゲットの例（Slack統合）
  # target {
  #   address = "arn:aws:chatbot::123456789012:chat-configuration/slack/example-slack-channel"
  #   type    = "AWSChatbotSlack"
  # }

  #-------
  # 状態管理
  #-------
  # 設定内容: 通知ルールの有効/無効状態
  # 設定可能な値:
  #   - ENABLED: 有効（通知を送信）
  #   - DISABLED: 無効（通知を送信しない）
  # 省略時: ENABLED
  # 用途: 一時的な通知停止やメンテナンス時に使用
  status = "ENABLED"

  #-------
  # リージョン設定
  #-------
  # 設定内容: このリソースを管理するAWSリージョン
  # 省略時: プロバイダーのリージョン設定を使用
  # 用途: クロスリージョン構成で明示的なリージョン指定が必要な場合に使用
  region = "ap-northeast-1"

  #-------
  # タグ設定
  #-------
  # 設定内容: リソースに付与するタグのマップ
  # 用途: コスト配分、リソース管理、アクセス制御等
  # 注意事項: default_tags設定がある場合はマージされる
  tags = {
    Name        = "example-notification-rule"
    Environment = "production"
    Service     = "codecommit"
  }
}

#-------
# Attributes Reference (参照可能な属性)
#-------
# - id: 通知ルールのARN
# - arn: 通知ルールのARN
# - tags_all: 全てのタグ（default_tags含む）
# - target[].status: 各ターゲットの状態（自動設定）
