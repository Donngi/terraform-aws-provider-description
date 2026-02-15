#---------------------------------------------------------------
# AWS CloudWatch Composite Alarm (複合アラーム)
#---------------------------------------------------------------
#
# 複数のCloudWatchアラームを組み合わせて、より高度なアラーム条件を定義するリソースです。
# 複合アラームは他のアラームの状態を評価し、Boolean論理（AND、OR、NOT）を使って
# 自身の状態を判定します。
#
# 主な用途:
#   - 複数のメトリックアラームを統合した統一的なアラート通知
#   - 複雑なアラーム条件の実装（例: 複数のメトリックが同時に閾値を超えた場合）
#   - アラームノイズの削減（集約レベルでのみアクション実行）
#   - アクション抑制（特定の条件下でアラームアクションを無効化）
#
# NOTE: 複合アラーム間に循環依存関係を作成することはできません。
#       他の複合アラームに依存されているアラームは削除できません。
#
# AWS公式ドキュメント:
#   - Composite Alarms概要: https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/alarm-combining.html
#   - Composite Alarm作成: https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/Create_Composite_Alarm.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_composite_alarm
#
# Provider Version: 6.28.0
# Generated: 2026-02-12
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_cloudwatch_composite_alarm" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # alarm_name (Required)
  # 設定内容: 複合アラームの名前を指定します。
  # 設定可能な値: リージョン内で一意の名前（1～255文字）
  # 注意: この名前はリージョン内で一意である必要があります。
  alarm_name = "example-composite-alarm"

  # alarm_description (Optional)
  # 設定内容: 複合アラームの説明を指定します。
  # 設定可能な値: 任意の文字列（最大1024文字）
  # 省略時: 説明なし
  alarm_description = "This is a composite alarm!"

  #-------------------------------------------------------------
  # アラームルール設定
  #-------------------------------------------------------------

  # alarm_rule (Required)
  # 設定内容: この複合アラームの状態を決定するために評価される他のアラームを指定する式を設定します。
  # 設定可能な値: アラーム名を使ったBoolean論理式（AND、OR、NOT、ALARM()関数）
  # 構文例:
  #   - ALARM(alarm-name)
  #   - ALARM(alarm-name) AND ALARM(alarm-name2)
  #   - ALARM(alarm-name) OR ALARM(alarm-name2)
  #   - NOT ALARM(alarm-name)
  # 注意: 最大10240文字
  # 関連機能: Composite Alarm構文
  #   - https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/Create_Composite_Alarm.html
  alarm_rule = <<-EOF
    ALARM(${aws_cloudwatch_metric_alarm.alpha.alarm_name}) OR
    ALARM(${aws_cloudwatch_metric_alarm.bravo.alarm_name})
  EOF

  #-------------------------------------------------------------
  # アクション設定
  #-------------------------------------------------------------

  # actions_enabled (Optional, Forces new resource)
  # 設定内容: 複合アラームの状態が変化したときにアクションを実行するかどうかを指定します。
  # 設定可能な値:
  #   - true: アクションを実行
  #   - false: アクションを実行しない
  # 省略時: true
  # 注意: この設定を変更すると、リソースが再作成されます。
  actions_enabled = true

  # alarm_actions (Optional)
  # 設定内容: このアラームが他の状態からALARM状態に遷移したときに実行するアクションのセットを指定します。
  # 設定可能な値: アクションのARNリスト（最大5個）
  # 対応アクション:
  #   - Amazon SNS topic ARN
  #   - AWS Lambda function ARN
  #   - AWS Systems Manager OpsCenter ARN
  #   - AWS Systems Manager Incident Manager ARN
  alarm_actions = [
    aws_sns_topic.example.arn
  ]

  # ok_actions (Optional)
  # 設定内容: このアラームが他の状態からOK状態に遷移したときに実行するアクションのセットを指定します。
  # 設定可能な値: アクションのARNリスト（最大5個）
  ok_actions = [
    aws_sns_topic.example.arn
  ]

  # insufficient_data_actions (Optional)
  # 設定内容: このアラームが他の状態からINSUFFICIENT_DATA状態に遷移したときに実行するアクションのセットを指定します。
  # 設定可能な値: アクションのARNリスト（最大5個）
  insufficient_data_actions = []

  #-------------------------------------------------------------
  # アクション抑制設定
  #-------------------------------------------------------------

  # actions_suppressor (Optional)
  # 設定内容: 抑制アラームがALARM状態にあるときに複合アラームのアクションを抑制する設定を指定します。
  # 関連機能: Actions Suppression
  #   特定の条件下（例: メンテナンス中、デプロイ中）でアラームアクションを一時的に無効化できます。
  #   - https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/alarm-combining.html
  actions_suppressor {
    # alarm (Required)
    # 設定内容: 抑制アラームの名前またはARNを指定します。
    # 設定可能な値: AlarmNameまたはAmazon Resource Name (ARN)
    alarm = "suppressor-alarm"

    # extension_period (Required)
    # 設定内容: 抑制アラームがALARM状態から抜けた後、複合アラームがアクションを実行するまでの最大待機時間（秒）を指定します。
    # 設定可能な値: 0～86400秒（0～24時間）
    extension_period = 10

    # wait_period (Required)
    # 設定内容: 複合アラームが抑制アラームがALARM状態になるまで待機する最大時間（秒）を指定します。
    # 設定可能な値: 0～86400秒（0～24時間）
    # 注意: この時間が経過すると、複合アラームは抑制アラームの状態に関わらずアクションを実行します。
    wait_period = 20
  }

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 注意: 複合アラームと参照されるすべてのアラームは同じリージョンに存在する必要があります。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: アラームに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ（最大50タグ）
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "example-composite-alarm"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: 複合アラームのAmazon Resource Name (ARN)
#
# - id: 複合アラームリソースのID（alarm_nameと同じ）
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
