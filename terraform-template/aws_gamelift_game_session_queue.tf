###############################################################################################
# Terraform Template: aws_gamelift_game_session_queue
###############################################################################################
# Provider Version: 6.28.0
# Generated: 2026-02-17
# Terraform Registry: https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/gamelift_game_session_queue
#
# 概要:
#   このリソースは、Amazon GameLift のゲームセッションキューを作成します。
#   ゲームセッションキューは、複数のフリートやエイリアスにわたってゲームセッションの
#   配置を管理し、プレイヤーのレイテンシーに基づいて最適なフリートを選択します。
#
# 主な用途:
#   - 複数リージョンにまたがるゲームセッションの配置管理
#   - プレイヤーレイテンシーに基づくフリート選択の自動化
#   - ゲームセッション配置通知の設定（SNS連携）
#   - タイムアウトポリシーによるリクエスト管理
#
# 制限事項:
#   - player_latency_policy は複数定義可能だが、最後のポリシーは policy_duration_seconds を省略すること
#   - destinations に指定できるのはフリートまたはエイリアスの ARN のみ
#   - notification_target には SNS トピックの ARN を指定する
#
# 関連ドキュメント:
#   - https://docs.aws.amazon.com/gamelift/latest/developerguide/queues-creating.html
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/gamelift_game_session_queue
#
# NOTE:
#   player_latency_policy を複数設定する場合は、最後のポリシー（キューがタイムアウトするまで
#   有効なポリシー）に policy_duration_seconds を省略してください。省略したポリシーは
#   キューのタイムアウトまで継続して適用されます。
#
###############################################################################################

#-------
# リソース定義
#-------
resource "aws_gamelift_game_session_queue" "example" {

  #-------
  # 基本設定
  #-------
  # 設定内容: セッションキューの名前
  # 設定可能な値: 1～128文字の英数字、ハイフン、アンダースコア
  # 省略時: 必須項目のため指定が必要
  name = "example-game-session-queue"

  # 設定内容: ゲームセッションリクエストがキューに留まることができる最大時間（秒）
  # 設定可能な値: 0以上の整数（秒単位）
  # 省略時: タイムアウトなし
  timeout_in_seconds = 60

  #-------
  # 配置先設定
  #-------
  # 設定内容: ゲームセッションの配置先となるフリートまたはエイリアスの ARN リスト
  # 設定可能な値: GameLift フリートまたはエイリアスの ARN の配列（優先順に記載）
  # 省略時: 配置先なし
  destinations = [
    "arn:aws:gamelift:us-east-1:123456789012:fleet/fleet-12345678-1234-1234-1234-123456789012",
    "arn:aws:gamelift:eu-west-1:123456789012:fleet/fleet-87654321-4321-4321-4321-876543210987",
  ]

  #-------
  # 通知設定
  #-------
  # 設定内容: ゲームセッション配置通知を受け取る SNS トピックの ARN
  # 設定可能な値: SNS トピックの ARN
  # 省略時: 配置通知なし
  notification_target = "arn:aws:sns:us-east-1:123456789012:game-session-queue-notifications"

  #-------
  # カスタムイベントデータ設定
  #-------
  # 設定内容: このキューに関連するすべてのイベントに追加されるカスタムデータ
  # 設定可能な値: 任意の文字列（最大256文字）
  # 省略時: カスタムデータなし
  custom_event_data = "game=example,version=1.0"

  #-------
  # プレイヤーレイテンシーポリシー設定
  #-------
  # 設定内容: プレイヤーレイテンシーに基づくフリート選択ポリシー
  # 設定可能な値: 1つ以上の player_latency_policy ブロック
  # 省略時: レイテンシーポリシーなし
  # 注意: 複数設定する場合は最後のポリシーの policy_duration_seconds を省略すること
  player_latency_policy {
    # 設定内容: 許容されるプレイヤーの最大レイテンシー（ミリ秒）
    # 設定可能な値: 1以上の整数（ミリ秒単位）
    # 省略時: 必須項目のため指定が必要
    maximum_individual_player_latency_milliseconds = 100

    # 設定内容: このポリシーが適用される期間（秒）
    # 設定可能な値: 1以上の整数（秒単位）
    # 省略時: キューがタイムアウトするまで継続適用（最後のポリシーに設定）
    policy_duration_seconds = 5
  }

  player_latency_policy {
    # 設定内容: 許容されるプレイヤーの最大レイテンシー（ミリ秒）
    # 設定可能な値: 1以上の整数（ミリ秒単位）
    # 省略時: 必須項目のため指定が必要
    maximum_individual_player_latency_milliseconds = 200

    # 設定内容: このポリシーが適用される期間（秒）
    # 省略時: キューのタイムアウトまで継続適用（最後のポリシーでは省略推奨）
    # policy_duration_seconds = 10
  }

  #-------
  # リージョン設定
  #-------
  # 設定内容: このリソースを管理するリージョン
  # 設定可能な値: AWS リージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定のリージョンを使用
  region = "us-east-1"

  #-------
  # タグ設定
  #-------
  # 設定内容: リソースに付与するタグ
  # 設定可能な値: キーと値のペアのマップ
  # 省略時: タグなし
  tags = {
    Name        = "example-game-session-queue"
    Environment = "production"
    ManagedBy   = "Terraform"
  }
}

###############################################################################################
# Attributes Reference（参照可能な属性）
###############################################################################################
# このリソースでは以下の属性を参照できます:
#
# - id
#   セッションキューの名前（name と同じ値）
#
# - arn
#   セッションキューの ARN
#   形式: arn:aws:gamelift:<region>:<account-id>:gamesessionqueue/<queue-name>
#
# - region
#   このリソースが管理されているリージョン
#
# - tags_all
#   プロバイダーの default_tags とマージされたすべてのタグ
#
###############################################################################################
