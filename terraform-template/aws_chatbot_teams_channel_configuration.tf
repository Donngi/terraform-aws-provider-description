#---------------------------------------------------------------
# AWS Chatbot Microsoft Teams Channel Configuration
#---------------------------------------------------------------
#
# AWS ChatbotのMicrosoft Teamsチャンネル設定をプロビジョニングするリソースです。
# このリソースにより、AWS ChatbotをMicrosoft Teamsチャンネルと統合し、
# AWSサービスからの通知の受信やAWSリソースの管理コマンドの実行が可能になります。
#
# AWS公式ドキュメント:
#   - AWS Chatbot概要: https://docs.aws.amazon.com/chatbot/latest/adminguide/what-is.html
#   - Microsoft Teamsセットアップ: https://docs.aws.amazon.com/chatbot/latest/adminguide/teams-setup.html
#   - CreateMicrosoftTeamsChannelConfiguration API: https://docs.aws.amazon.com/chatbot/latest/APIReference/API_CreateMicrosoftTeamsChannelConfiguration.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/chatbot_teams_channel_configuration
#
# Provider Version: 6.28.0
# Generated: 2026-01-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_chatbot_teams_channel_configuration" "example" {
  #-------------------------------------------------------------
  # 必須設定
  #-------------------------------------------------------------

  # channel_id (Required)
  # 設定内容: Microsoft TeamsチャンネルのIDを指定します。
  # 設定可能な値: 文字列（19%3から始まり、thread.tacv2またはthread.skypeで終わる形式）
  # 取得方法: Microsoft Teamsでチャンネルを右クリックし、リンクをコピー。
  #           URLの/channel/以降がチャンネルIDです。
  # 例: "19%3Ae5eace25j32023jga835103358eapge3t8235%40thread.tacv2"
  channel_id = "C07EZ1ABC23"

  # configuration_name (Required)
  # 設定内容: Microsoft Teamsチャンネル設定の名前を指定します。
  # 設定可能な値: 1-36文字の文字列（英数字、ハイフン、アンダースコア）
  # 注意: アカウント内で一意である必要があります。作成後は変更できません。
  configuration_name = "my-teams-channel-config"

  # iam_role_arn (Required)
  # 設定内容: AWS Chatbotの権限を定義するIAMロールのARNを指定します。
  # 設定可能な値: 有効なIAMロールARN
  # 注意: これはユーザー定義のロールであり、AWS Chatbotがこのロールを引き受けます。
  #       サービスリンクロールではありません。
  # 関連機能: AWS Chatbot IAMロール設定
  #   チャンネルメンバーがAWSリソースに対して実行できるアクションを制御します。
  #   - https://docs.aws.amazon.com/chatbot/latest/adminguide/editing-iam-roles-for-chatbot.html
  iam_role_arn = "arn:aws:iam::123456789012:role/AWSChatbotRole"

  # team_id (Required)
  # 設定内容: AWS Chatbotで承認されたMicrosoft TeamsのチームIDを指定します。
  # 設定可能な値: GUID形式の文字列（例: "74361522-da01-538d-aa2e-ac7918c6bb92"）
  # 取得方法: AWS Chatbotコンソールで初回認証フローを実行後、
  #           コンソールからチームIDをコピーして使用します。
  team_id = "74361522-da01-538d-aa2e-ac7918c6bb92"

  # tenant_id (Required)
  # 設定内容: Microsoft TeamsテナントのIDを指定します。
  # 設定可能な値: GUID形式の文字列（例: "5fe61832-9f46-403b-a7db-cf9cf2e38199"）
  # 取得方法: Microsoft TeamsチャンネルURLのtenantIdパラメータから取得できます。
  tenant_id = "5fe61832-9f46-403b-a7db-cf9cf2e38199"

  #-------------------------------------------------------------
  # オプション設定
  #-------------------------------------------------------------

  # channel_name (Optional)
  # 設定内容: Microsoft Teamsチャンネルの名前を指定します。
  # 設定可能な値: 文字列
  # 省略時: 自動的に取得されます（computed）
  channel_name = "aws-notifications"

  # team_name (Optional)
  # 設定内容: Microsoft Teamsチームの名前を指定します。
  # 設定可能な値: 文字列
  # 省略時: 自動的に取得されます（computed）
  team_name = "DevOps Team"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # 通知設定
  #-------------------------------------------------------------

  # sns_topic_arns (Optional)
  # 設定内容: AWS Chatbotに通知を配信するSNSトピックのARNリストを指定します。
  # 設定可能な値: SNSトピックARNのセット
  # 省略時: 空のリスト
  # 関連機能: Amazon SNS通知
  #   CloudWatchアラーム、AWS Health、Security Hubなど様々なAWSサービスから
  #   Microsoft Teamsチャンネルに通知を送信できます。
  #   - https://docs.aws.amazon.com/chatbot/latest/adminguide/related-services.html
  sns_topic_arns = [
    "arn:aws:sns:ap-northeast-1:123456789012:chatbot-notifications"
  ]

  #-------------------------------------------------------------
  # セキュリティ・ガードレール設定
  #-------------------------------------------------------------

  # guardrail_policy_arns (Optional)
  # 設定内容: チャンネルガードレールとして適用するIAMポリシーARNのリストを指定します。
  # 設定可能な値: IAMポリシーARNのリスト
  # 省略時: AWS管理ポリシー「AdministratorAccess」がデフォルトで適用されます
  # 関連機能: AWS Chatbot ガードレールポリシー
  #   チャンネルメンバーが実行できるアクションの上限を定義します。
  #   IAMロールとガードレールの交差部分が実際の権限になります。
  #   - https://docs.aws.amazon.com/chatbot/latest/adminguide/understanding-permissions.html
  guardrail_policy_arns = [
    "arn:aws:iam::aws:policy/ReadOnlyAccess"
  ]

  # user_authorization_required (Optional)
  # 設定内容: チャット設定でユーザーロール要件を有効にするかを指定します。
  # 設定可能な値:
  #   - true: ユーザーはコマンド実行前に自分のIAMロールを選択する必要があります
  #   - false: チャンネルロールが全メンバーに適用されます
  # 省略時: false（チャンネルロールを使用）
  # 関連機能: AWS Chatbot ロール設定
  #   ユーザーロールを有効にすると、チャンネルメンバーごとに
  #   異なる権限レベルを設定できます。
  #   - https://docs.aws.amazon.com/chatbot/latest/adminguide/understanding-permissions.html#role-settings
  user_authorization_required = false

  #-------------------------------------------------------------
  # ログ設定
  #-------------------------------------------------------------

  # logging_level (Optional)
  # 設定内容: Amazon CloudWatch Logsに記録するログレベルを指定します。
  # 設定可能な値:
  #   - "ERROR": エラーのみをログ出力
  #   - "INFO": 情報レベル以上をログ出力
  #   - "NONE": ログを無効化
  # 省略時: "NONE"
  # 関連機能: Amazon CloudWatch Logs
  #   AWS Chatbotのアクティビティを監視・デバッグするために使用します。
  #   CloudWatch Logsの利用には追加料金が発生します。
  #   - https://docs.aws.amazon.com/chatbot/latest/adminguide/cloudwatch-logs.html
  logging_level = "ERROR"

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 注意: プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #       一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "my-teams-channel-config"
    Environment = "production"
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  timeouts {
    # create (Optional)
    # 設定内容: リソース作成時のタイムアウト時間を指定します。
    # 設定可能な値: 期間を表す文字列（例: "30s", "5m", "2h45m"）
    # 有効な時間単位: "s"（秒）, "m"（分）, "h"（時間）
    create = "5m"

    # update (Optional)
    # 設定内容: リソース更新時のタイムアウト時間を指定します。
    # 設定可能な値: 期間を表す文字列（例: "30s", "5m", "2h45m"）
    # 有効な時間単位: "s"（秒）, "m"（分）, "h"（時間）
    update = "5m"

    # delete (Optional)
    # 設定内容: リソース削除時のタイムアウト時間を指定します。
    # 設定可能な値: 期間を表す文字列（例: "30s", "5m", "2h45m"）
    # 有効な時間単位: "s"（秒）, "m"（分）, "h"（時間）
    # 注意: 削除タイムアウトは、destroy操作前に変更がstateに保存される場合のみ適用されます。
    delete = "5m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - chat_configuration_arn: Microsoft Teamsチャンネル設定のARN
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
