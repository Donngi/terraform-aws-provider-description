#---------------------------------------------------------------
# GameLift Game Session Queue
#---------------------------------------------------------------
#
# ゲームセッションの配置処理を行うキューリソースをプロビジョニングします。
# 複数のフリート/エイリアスに対して新しいゲームセッションを効率的に配置し、
# プレイヤーレイテンシ、フリート容量、コスト最適化などを考慮した
# セッション配置を実現します。
#
# AWS公式ドキュメント:
#   - GameSessionQueue API Reference: https://docs.aws.amazon.com/gameliftservers/latest/apireference/API_GameSessionQueue.html
#   - Configure game session placement: https://docs.aws.amazon.com/gameliftservers/latest/developerguide/queues-intro.html
#   - Create a game session queue: https://docs.aws.amazon.com/gameliftservers/latest/developerguide/queues-creating.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/gamelift_game_session_queue
#
# Provider Version: 6.28.0
# Generated: 2026-01-27
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_gamelift_game_session_queue" "example" {
  #---------------------------------------------------------------
  # 必須パラメータ
  #---------------------------------------------------------------

  # (Required) ゲームセッションキューの名前
  # - 各リージョン内で一意である必要があります
  # - 英数字とハイフンのみ使用可能（1〜128文字）
  # - キュー名はARNの一部として使用されます
  name = "example-session-queue"

  #---------------------------------------------------------------
  # オプション - 基本設定
  #---------------------------------------------------------------

  # (Optional) ゲームセッション配置先のフリート/エイリアスARNのリスト
  # - 配置優先順位に従ってリスト順に記載します
  # - フリートARNまたはフリートエイリアスARNを指定可能
  # - 複数リージョンのフリートを含めることでグローバルな配置が可能
  # - マルチロケーションキューの構築により低レイテンシを実現
  destinations = [
    # "arn:aws:gamelift:us-west-2::fleet/fleet-12345678-1234-1234-1234-123456789012",
    # "arn:aws:gamelift:eu-central-1::alias/alias-12345678-1234-1234-1234-123456789012",
  ]

  # (Optional) ゲームセッションリクエストがキューに残る最大時間（秒）
  # - この時間を超えるとステータスが "TIMED_OUT" に変更されます
  # - 最小値: 10秒
  # - 最大値: 600秒（10分）
  # - 未設定の場合、デフォルトのタイムアウト値が適用されます
  timeout_in_seconds = 60

  # (Optional) このゲームセッションキューに関連する全イベントに追加される情報
  # - カスタムメタデータやトラッキング情報を含めることができます
  # - 最大256文字
  # - イベント通知と組み合わせて使用することで追跡が容易になります
  # custom_event_data = "environment=production,game_mode=ranked"

  # (Optional) ゲームセッション配置通知を受信するSNSトピックARN
  # - 配置の成功/失敗/タイムアウトなどのイベント通知を受信
  # - 配置プロセスの監視とトラブルシューティングに有用
  # - FIFO トピック（.fifo サフィックス）もサポート
  # - 参考: https://docs.aws.amazon.com/gamelift/latest/developerguide/queue-notification.html
  # notification_target = "arn:aws:sns:us-west-2:123456789012:game-session-notifications"

  # (Optional) このリソースを管理するAWSリージョン
  # - 未指定の場合、プロバイダー設定のリージョンが使用されます
  # - マルチリージョン構成の場合、明示的に指定することを推奨
  # - 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-west-2"

  #---------------------------------------------------------------
  # オプション - プレイヤーレイテンシポリシー
  #---------------------------------------------------------------

  # (Optional) プレイヤーレイテンシに基づいてフリートを選択するポリシー
  # - 複数のポリシーを定義し、段階的にレイテンシ上限を緩和できます
  # - 最も低いレイテンシ値から順に評価されます
  # - GameLiftが配置できない場合、次のポリシーが適用されます

  # 第1段階: 最初の5秒間は100ms以下を要求
  player_latency_policy {
    # (Required) 任意のプレイヤーに許容される最大レイテンシ値（ミリ秒）
    maximum_individual_player_latency_milliseconds = 100

    # (Optional) このポリシーが適用される期間（秒）
    # - 未設定の場合、キューがタイムアウトするまで適用されます
    policy_duration_seconds = 5
  }

  # 第2段階: 第1段階で配置できなかった場合、200msまで許容
  player_latency_policy {
    maximum_individual_player_latency_milliseconds = 200
    # policy_duration_seconds を設定しない場合、キューがタイムアウトするまで適用
  }

  #---------------------------------------------------------------
  # オプション - タグ
  #---------------------------------------------------------------

  # (Optional) リソースに適用するタグのキー・バリューマップ
  # - プロバイダーの default_tags と統合されます
  # - 同じキーがある場合、このタグが優先されます
  # - コスト管理、リソース管理、アクセス制御に活用できます
  tags = {
    Name        = "example-session-queue"
    Environment = "production"
    GameTitle   = "my-game"
    ManagedBy   = "terraform"
  }

  # (Optional) プロバイダーのdefault_tagsを含む全タグのマップ
  # - 通常は自動的に管理されるため、明示的な設定は不要です
  # - Computed属性として出力で参照可能
  # tags_all = {}
}

#---------------------------------------------------------------
# Attributes Reference（出力専用属性）
#---------------------------------------------------------------
# 以下の属性は Terraform によって自動的に設定され、
# 他のリソースへの参照や出力値として使用できます。
#
# - arn
#     ゲームセッションキューのAmazon Resource Name (ARN)
#     形式: arn:aws:gamelift:<region>::gamesessionqueue/<queue-name>
#     例: aws_gamelift_game_session_queue.example.arn
#
# - id
#     ゲームセッションキューの一意の識別子（通常は name と同じ）
#     例: aws_gamelift_game_session_queue.example.id
#
# - tags_all
#     リソースに割り当てられた全タグのマップ
#     プロバイダーの default_tags を含む
#     例: aws_gamelift_game_session_queue.example.tags_all
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# 使用例とベストプラクティス
#---------------------------------------------------------------
#
# 1. マルチリージョン配置
#    - 複数リージョンのフリートを destinations に含めることで
#      グローバルなプレイヤー体験を提供
#    - プレイヤーレイテンシポリシーと組み合わせて最適な配置を実現
#
# 2. レイテンシポリシーの段階的緩和
#    - 厳しいレイテンシ要件から開始し、時間経過で緩和
#    - 配置成功率とプレイヤー体験のバランスを調整
#
# 3. SNS通知の活用
#    - 配置の成功/失敗をリアルタイムで監視
#    - カスタムイベントデータでコンテキスト情報を追加
#
# 4. Spotフリートとの連携
#    - コスト最適化のためにSpotフリートを優先配置先に設定
#    - オンデマンドフリートをフォールバックとして設定
#
# 5. エイリアスの使用
#    - destinations にはフリート直接参照ではなくエイリアスを推奨
#    - フリート更新時のダウンタイムを最小化
#
#---------------------------------------------------------------
