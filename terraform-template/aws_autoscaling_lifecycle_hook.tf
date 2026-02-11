#---------------------------------------------------------------
# AWS Auto Scaling Lifecycle Hook
#---------------------------------------------------------------
#
# Amazon EC2 Auto Scaling グループにライフサイクルフックを追加するリソースです。
# ライフサイクルフックを使用すると、インスタンスの起動時や終了時にカスタムアクション
# （ソフトウェアのインストール、ELBへの登録、データのバックアップ等）を実行できます。
#
# AWS公式ドキュメント:
#   - ライフサイクルフック概要: https://docs.aws.amazon.com/autoscaling/ec2/userguide/lifecycle-hooks.html
#   - ライフサイクルフックの動作: https://docs.aws.amazon.com/autoscaling/ec2/userguide/lifecycle-hooks-overview.html
#   - ライフサイクルフックの追加: https://docs.aws.amazon.com/autoscaling/ec2/userguide/adding-lifecycle-hooks.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_lifecycle_hook
#
# Provider Version: 6.28.0
# Generated: 2026-01-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_autoscaling_lifecycle_hook" "example" {
  #-------------------------------------------------------------
  # 基本設定（必須）
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: ライフサイクルフックの名前を指定します。
  # 設定可能な値: 文字列（Auto Scalingグループ内で一意である必要があります）
  name = "example-lifecycle-hook"

  # autoscaling_group_name (Required)
  # 設定内容: ライフサイクルフックを割り当てるAuto Scalingグループの名前を指定します。
  # 設定可能な値: 既存のAuto Scalingグループ名
  autoscaling_group_name = "example-asg"

  # lifecycle_transition (Required)
  # 設定内容: ライフサイクルフックをアタッチするインスタンスの状態遷移を指定します。
  # 設定可能な値:
  #   - "autoscaling:EC2_INSTANCE_LAUNCHING": インスタンス起動時（スケールアウト時）
  #   - "autoscaling:EC2_INSTANCE_TERMINATING": インスタンス終了時（スケールイン時）
  # 関連機能: Auto Scaling インスタンスライフサイクル
  #   インスタンスは起動から終了まで様々な状態を遷移します。
  #   ライフサイクルフックを使用すると、Pending:Wait または Terminating:Wait 状態で
  #   カスタムアクションを実行できます。
  #   - https://docs.aws.amazon.com/autoscaling/ec2/userguide/ec2-auto-scaling-lifecycle.html
  lifecycle_transition = "autoscaling:EC2_INSTANCE_LAUNCHING"

  #-------------------------------------------------------------
  # タイムアウト・デフォルト結果設定
  #-------------------------------------------------------------

  # default_result (Optional)
  # 設定内容: ライフサイクルフックがタイムアウトした場合、または予期しないエラーが
  #          発生した場合にAuto Scalingグループが実行するアクションを定義します。
  # 設定可能な値:
  #   - "CONTINUE": インスタンスをライフサイクルの次の状態に移行させます
  #   - "ABANDON": インスタンスを破棄し、新しいインスタンスを起動します（起動時）
  #                または、終了処理を中止せず続行します（終了時）
  # 省略時: "ABANDON"
  # 注意: 起動フックで "ABANDON" を指定すると、インスタンスが終了されます。
  #       終了フックで "ABANDON" を指定すると、他の終了フックの処理なしに終了します。
  default_result = "CONTINUE"

  # heartbeat_timeout (Optional)
  # 設定内容: ライフサイクルフックがタイムアウトするまでの待機時間（秒）を指定します。
  # 設定可能な値: 30 - 7200 (秒)
  # 省略時: 3600 (1時間)
  # 関連機能: ライフサイクルフックのハートビート
  #   インスタンスはタイムアウトまで待機状態を維持します。
  #   CompleteLifecycleAction APIを呼び出して早期に状態を遷移させたり、
  #   RecordLifecycleActionHeartbeat APIでタイムアウトを延長できます。
  #   グローバルタイムアウトは48時間、またはハートビートタイムアウトの100倍のいずれか短い方です。
  #   - https://docs.aws.amazon.com/autoscaling/ec2/userguide/lifecycle-hooks.html
  heartbeat_timeout = 2000

  #-------------------------------------------------------------
  # 通知設定
  #-------------------------------------------------------------

  # notification_metadata (Optional)
  # 設定内容: Auto Scalingが通知ターゲットにメッセージを送信する際に含める
  #          追加情報を指定します。
  # 設定可能な値: 任意の文字列（JSON形式が推奨）
  # 用途: Lambda関数やその他の通知ターゲットで使用するカスタムデータを渡す場合に使用
  notification_metadata = jsonencode({
    action      = "configure"
    environment = "production"
  })

  # notification_target_arn (Optional)
  # 設定内容: Auto Scalingがインスタンスの遷移状態を通知するために使用する
  #          通知ターゲットのARNを指定します。
  # 設定可能な値:
  #   - Amazon SQS キューのARN（例: arn:aws:sqs:us-east-1:123456789012:my-queue）
  #   - Amazon SNS トピックのARN（例: arn:aws:sns:us-east-1:123456789012:my-topic）
  #   - AWS Lambda 関数のARN（例: arn:aws:lambda:us-east-1:123456789012:function:my-function）
  # 関連機能: ライフサイクルフック通知
  #   デフォルトでは Amazon EventBridge に通知が送信されます。
  #   このパラメータを指定すると、SQS、SNS、または Lambda に直接通知を送信できます。
  #   - https://docs.aws.amazon.com/autoscaling/ec2/userguide/adding-lifecycle-hooks.html
  notification_target_arn = "arn:aws:sqs:ap-northeast-1:123456789012:lifecycle-hook-queue"

  # role_arn (Optional)
  # 設定内容: Auto Scalingグループが指定された通知ターゲットに発行できるようにする
  #          IAMロールのARNを指定します。
  # 設定可能な値: 適切な権限を持つIAMロールのARN
  # 注意: notification_target_arn を指定する場合は必須です。
  #       ロールには、通知ターゲット（SQS、SNS、Lambda）への発行権限が必要です。
  # 関連機能: IAMロールによる通知ターゲットへのアクセス
  #   Auto Scalingサービスがこのロールを引き受けて通知を送信します。
  #   - https://docs.aws.amazon.com/autoscaling/ec2/userguide/adding-lifecycle-hooks.html
  role_arn = "arn:aws:iam::123456789012:role/AutoScalingLifecycleHookRole"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: ライフサイクルフックの識別子
#       （autoscaling_group_name と name の組み合わせ）
#---------------------------------------------------------------

#---------------------------------------------------------------
# 注意事項
#---------------------------------------------------------------
# Terraformでは2つの方法でライフサイクルフックを追加できます:
#
# 1. aws_autoscaling_group リソースの initial_lifecycle_hook 属性
# 2. このリソース (aws_autoscaling_lifecycle_hook)
#
# このリソースで追加されたフックは、Auto Scalingグループが作成された後、
# 初期インスタンスが起動された後に追加されます。これにより、意図しない
# 動作が発生する可能性があります。
#
# 全インスタンスでフックを実行する必要がある場合は、aws_autoscaling_group
# の initial_lifecycle_hook を使用してください。ただし、両方で同じフックを
# 重複して定義しないよう注意してください。
#---------------------------------------------------------------
