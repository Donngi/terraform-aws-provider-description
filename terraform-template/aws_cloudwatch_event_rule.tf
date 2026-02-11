#---------------------------------------------------------------
# AWS CloudWatch Event Rule (EventBridge Rule)
#---------------------------------------------------------------
#
# Amazon EventBridgeのルールをプロビジョニングするリソースです。
# EventBridgeルールは、イベントバスに配信されたイベントに対して
# どのようなアクションを実行するかを決定します。
# イベントパターンに基づくマッチングルールと、スケジュールに基づく
# 定期実行ルールの2種類があります。
#
# Note: EventBridgeは以前CloudWatch Eventsと呼ばれていました。
#       機能は同一です。
#
# AWS公式ドキュメント:
#   - EventBridge Rules: https://docs.aws.amazon.com/eventbridge/latest/userguide/eb-rules.html
#   - イベントパターン構文: https://docs.aws.amazon.com/eventbridge/latest/userguide/eb-create-pattern.html
#   - スケジュール式: https://docs.aws.amazon.com/eventbridge/latest/userguide/eb-scheduled-rule-pattern.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_rule
#
# Provider Version: 6.28.0
# Generated: 2026-01-19
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_cloudwatch_event_rule" "example" {
  #-------------------------------------------------------------
  # 名前設定
  #-------------------------------------------------------------

  # name (Optional, Forces new resource)
  # 設定内容: ルールの名前を指定します。
  # 設定可能な値: 文字列
  # 省略時: Terraformがランダムな一意の名前を生成します。
  # 注意: name_prefixと排他的（どちらか一方のみ指定可能）
  name = "capture-aws-sign-in"

  # name_prefix (Optional, Forces new resource)
  # 設定内容: ルール名のプレフィックスを指定します。
  # 設定可能な値: 38文字以下の文字列。Terraformが後ろにランダムなサフィックスを追加します。
  # 注意: nameと排他的（どちらか一方のみ指定可能）
  # 注意: 生成されるサフィックスの長さのため、38文字以下にする必要があります。
  name_prefix = null

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
  # イベントバス設定
  #-------------------------------------------------------------

  # event_bus_name (Optional, Forces new resource)
  # 設定内容: このルールを関連付けるイベントバスの名前またはARNを指定します。
  # 設定可能な値:
  #   - イベントバス名: カスタムイベントバスの名前
  #   - イベントバスARN: イベントバスの完全なARN
  # 省略時: "default" イベントバスが使用されます
  # 注意: schedule_expressionはデフォルトイベントバスでのみ使用可能
  event_bus_name = null

  #-------------------------------------------------------------
  # トリガー条件設定
  #-------------------------------------------------------------

  # schedule_expression (Optional)
  # 設定内容: スケジュールに基づいてルールを実行するための式を指定します。
  # 設定可能な値:
  #   - cron式: cron(分 時 日 月 曜日 年)
  #     例: cron(0 20 * * ? *)  # 毎日20:00 UTC
  #         cron(0/15 * * * ? *)  # 15分ごと
  #   - rate式: rate(値 単位)
  #     例: rate(5 minutes)  # 5分ごと
  #         rate(1 hour)     # 1時間ごと
  #         rate(1 day)      # 1日ごと
  # 関連機能: EventBridge スケジュール式
  #   cron式またはrate式を使用してルールの実行タイミングを定義します。
  #   - https://docs.aws.amazon.com/eventbridge/latest/userguide/eb-scheduled-rule-pattern.html
  # 注意: schedule_expressionまたはevent_patternのいずれか1つ以上が必要
  # 注意: デフォルトイベントバスでのみ使用可能
  # 注意: stateが"ENABLED_WITH_ALL_CLOUDTRAIL_MANAGEMENT_EVENTS"の場合は使用不可
  schedule_expression = null

  # event_pattern (Optional)
  # 設定内容: ルールがマッチするイベントを定義するJSONオブジェクトを指定します。
  # 設定可能な値: JSON形式のイベントパターン
  # 関連機能: EventBridge イベントパターン
  #   イベントの構造とフィールドを定義し、マッチするイベントをターゲットに送信します。
  #   - https://docs.aws.amazon.com/eventbridge/latest/userguide/eb-create-pattern.html
  # 注意: schedule_expressionまたはevent_patternのいずれか1つ以上が必要
  # 注意: イベントパターンのサイズはデフォルトで2048文字、
  #       サービスクォータ増加リクエストにより4096文字まで拡張可能
  event_pattern = jsonencode({
    detail-type = [
      "AWS Console Sign In via CloudTrail"
    ]
  })

  #-------------------------------------------------------------
  # 説明設定
  #-------------------------------------------------------------

  # description (Optional)
  # 設定内容: ルールの説明を指定します。
  # 設定可能な値: 文字列
  description = "Capture each AWS Console Sign In"

  #-------------------------------------------------------------
  # ロール設定
  #-------------------------------------------------------------

  # role_arn (Optional)
  # 設定内容: ターゲット呼び出しに使用するIAMロールのARNを指定します。
  # 設定可能な値: 有効なIAMロールARN
  # 用途: ターゲットがEventBridgeからの呼び出しを受け入れるために
  #       必要な権限を持つロールを指定します。
  #       例えば、Kinesis Data Streamsやステップファンクションへの
  #       イベント配信時に必要です。
  role_arn = null

  #-------------------------------------------------------------
  # 状態設定
  #-------------------------------------------------------------

  # state (Optional)
  # 設定内容: ルールの状態を指定します。
  # 設定可能な値:
  #   - "DISABLED": ルールを無効化
  #   - "ENABLED" (デフォルト): CloudTrailが配信するイベントを除く全イベントに対してルールを有効化
  #   - "ENABLED_WITH_ALL_CLOUDTRAIL_MANAGEMENT_EVENTS": CloudTrailが配信する
  #       イベントを含む全イベントに対してルールを有効化
  # 注意: is_enabledと排他的（どちらか一方のみ指定可能）
  # 注意: "ENABLED_WITH_ALL_CLOUDTRAIL_MANAGEMENT_EVENTS"はschedule_expressionと併用不可
  state = "ENABLED"

  # is_enabled (Optional, Deprecated)
  # 設定内容: ルールを有効にするかどうかを指定します。
  # 設定可能な値:
  #   - true (デフォルト): ルールを有効化
  #   - false: ルールを無効化
  # 注意: このプロパティは非推奨です。代わりに"state"を使用してください。
  # 注意: stateと排他的（どちらか一方のみ指定可能）
  # is_enabled = true

  #-------------------------------------------------------------
  # 削除設定
  #-------------------------------------------------------------

  # force_destroy (Optional)
  # 設定内容: AWSが作成したマネージドルールを削除するために使用します。
  # 設定可能な値:
  #   - true: マネージドルールの削除を許可
  #   - false (デフォルト): マネージドルールの削除を禁止
  # 用途: AWSサービスが自動作成したマネージドルールを削除する場合に使用
  # 注意: マネージドルールを削除すると、それに依存する機能が動作しなくなる可能性があります
  force_destroy = false

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "capture-aws-sign-in"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: ルールの名前
#
# - arn: ルールのAmazon Resource Name (ARN)
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
