#---------------------------------------------------------------
# AWS Chatbot Slack Channel Configuration
#---------------------------------------------------------------
#
# AWS Chatbot（現Amazon Q Developer in chat applications）のSlackチャンネル設定を
# プロビジョニングするリソースです。SlackワークスペースとAWSアカウントを連携し、
# チャンネル経由でAWSリソースの監視・操作・通知受信を可能にします。
#
# AWS公式ドキュメント:
#   - AWS Chatbot概要: https://docs.aws.amazon.com/chatbot/latest/adminguide/what-is.html
#   - Slackセットアップチュートリアル: https://docs.aws.amazon.com/chatbot/latest/adminguide/slack-setup.html
#   - API Reference: https://docs.aws.amazon.com/chatbot/latest/APIReference/API_CreateSlackChannelConfiguration.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/chatbot_slack_channel_configuration
#
# Provider Version: 6.28.0
# Generated: 2026-01-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_chatbot_slack_channel_configuration" "example" {
  #-------------------------------------------------------------
  # 基本設定（必須）
  #-------------------------------------------------------------

  # configuration_name (Required)
  # 設定内容: Slackチャンネル設定の名前を指定します。
  # 設定可能な値: 1-128文字の文字列（英数字、ハイフン、アンダースコアのみ）
  # 注意: アカウント内で一意である必要があり、作成後は変更できません。
  configuration_name = "my-slack-channel-config"

  # iam_role_arn (Required)
  # 設定内容: AWS Chatbotが引き受けるユーザー定義のIAMロールのARNを指定します。
  # 設定可能な値: 有効なIAMロールARN
  # 注意: サービスリンクロールではなく、ユーザーが作成したロールを指定します。
  #       このロールにより、チャンネルメンバーがSlack経由で実行できるAWS操作が決まります。
  # 関連機能: AWS Chatbot IAMポリシー
  #   チャンネルロールまたはユーザーロールの設定により、Slack経由での
  #   AWS操作権限を制御します。
  #   - https://docs.aws.amazon.com/chatbot/latest/adminguide/chatbot-iam-policies.html
  iam_role_arn = "arn:aws:iam::123456789012:role/my-chatbot-role"

  # slack_channel_id (Required)
  # 設定内容: SlackチャンネルのIDを指定します。
  # 設定可能な値: Slackチャンネル固有のID文字列（例: C07EZ1ABC23）
  # 取得方法: Slackで対象チャンネル名を右クリック → リンクをコピー → URLの末尾がチャンネルID
  # 注意: パブリック・プライベートチャンネルの両方に対応しています。
  slack_channel_id = "C07EZ1ABC23"

  # slack_team_id (Required)
  # 設定内容: AWS Chatbotで認可されたSlackワークスペースのIDを指定します。
  # 設定可能な値: Slackワークスペース固有のID文字列（例: T07EA123LEP）
  # 注意: 事前にAWS ChatbotコンソールでSlackワークスペースの認可が必要です。
  slack_team_id = "T07EA123LEP"

  #-------------------------------------------------------------
  # オプション設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  # guardrail_policy_arns (Optional)
  # 設定内容: チャンネルガードレールとして適用するIAMポリシーARNのリストを指定します。
  # 設定可能な値: IAMポリシーARNのリスト
  # 省略時: AWS管理ポリシー「AdministratorAccess」がデフォルトで適用されます。
  # 関連機能: チャンネルガードレール
  #   チャンネルメンバーが利用可能なアクションを制限するポリシーです。
  #   IAMロールの権限とガードレールの両方で許可されたアクションのみ実行可能です。
  #   - https://docs.aws.amazon.com/chatbot/latest/adminguide/understanding-permissions.html#channel-guardrails
  guardrail_policy_arns = [
    "arn:aws:iam::aws:policy/ReadOnlyAccess"
  ]

  # logging_level (Optional)
  # 設定内容: AWS Chatbotのログレベルを指定します。
  # 設定可能な値:
  #   - "ERROR": エラーレベルのログのみ記録
  #   - "INFO": 情報レベル以上のログを記録
  #   - "NONE": ログを記録しない
  # 関連機能: Amazon CloudWatch Logs連携
  #   AWS Chatbotの操作ログをCloudWatch Logsに出力できます。
  #   - https://docs.aws.amazon.com/chatbot/latest/adminguide/cloudwatch-logs.html
  logging_level = "ERROR"

  # sns_topic_arns (Optional)
  # 設定内容: AWS Chatbotに通知を配信するSNSトピックのARNを指定します。
  # 設定可能な値: SNSトピックARNのセット
  # 用途: CloudWatch Alarms、AWS Health、Security Hubなど各種AWSサービスからの
  #       通知をSlackチャンネルで受信するために使用します。
  # 関連機能: AWS Chatbot通知
  #   SNSトピック経由で様々なAWSサービスからの通知を受信できます。
  #   - https://docs.aws.amazon.com/chatbot/latest/adminguide/related-services.html
  sns_topic_arns = [
    "arn:aws:sns:ap-northeast-1:123456789012:my-alerts-topic"
  ]

  # user_authorization_required (Optional)
  # 設定内容: チャット設定でユーザーロール要件を有効にするかを指定します。
  # 設定可能な値:
  #   - true: ユーザーロールが必要。各ユーザーが自分のロールを選択する必要があります。
  #   - false: チャンネルロールを使用。全メンバーが同じ権限を持ちます。
  # 関連機能: ロール設定
  #   チャンネルロール: 全メンバーに同一権限を付与（同じアクションを行うチームに適合）
  #   ユーザーロール: メンバーごとに異なる権限を設定可能（多様なメンバー構成に適合）
  #   - https://docs.aws.amazon.com/chatbot/latest/adminguide/understanding-permissions.html#role-settings
  user_authorization_required = false

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  tags = {
    Name        = "my-slack-channel-config"
    Environment = "production"
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  timeouts {
    # create (Optional)
    # 設定内容: リソース作成時のタイムアウト時間を指定します。
    # 設定可能な値: 時間を表す文字列（例: "30s", "5m", "1h"）
    # 省略時: デフォルトのタイムアウトが適用されます。
    create = "5m"

    # update (Optional)
    # 設定内容: リソース更新時のタイムアウト時間を指定します。
    # 設定可能な値: 時間を表す文字列（例: "30s", "5m", "1h"）
    # 省略時: デフォルトのタイムアウトが適用されます。
    update = "5m"

    # delete (Optional)
    # 設定内容: リソース削除時のタイムアウト時間を指定します。
    # 設定可能な値: 時間を表す文字列（例: "30s", "5m", "1h"）
    # 省略時: デフォルトのタイムアウトが適用されます。
    delete = "5m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - chat_configuration_arn: Slackチャンネル設定のAmazon Resource Name (ARN)
#
# - slack_channel_name: Slackチャンネルの名前
#
# - slack_team_name: Slackワークスペース（チーム）の名前
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
