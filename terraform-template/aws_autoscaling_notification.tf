#---------------------------------------
# AWS AutoScaling 通知設定
#---------------------------------------
#
# AutoScalingグループで発生するライフサイクルイベント（インスタンス起動・終了など）を
# Amazon SNSトピック経由で通知する設定を管理します。
# 複数のAutoScalingグループに対して同一の通知設定を適用できます。
#
# 主な用途:
# - インスタンスの起動・終了イベントの監視
# - 起動・終了エラーの検知と通知
# - 運用チームへのリアルタイム通知
#
# 関連リソース:
# - aws_autoscaling_group: 通知対象のAutoScalingグループ
# - aws_sns_topic: 通知送信先のSNSトピック
#
# 公式ドキュメント:
# https://docs.aws.amazon.com/autoscaling/ec2/userguide/ec2-auto-scaling-sns-notifications.html
#
# Terraform AWS Provider Documentation:
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_notification
#
# Provider Version: 6.28.0
# Generated: 2026-02-11
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------

#---------------------------------------
# 基本設定
#---------------------------------------

resource "aws_autoscaling_notification" "example" {
  # 通知対象のAutoScalingグループ名リスト
  # 設定内容: 通知を受け取るAutoScalingグループの名前のセット
  # 設定可能な値: 有効なAutoScalingグループ名のリスト
  # 省略時: 設定不可（必須）
  group_names = [
    # aws_autoscaling_group.example.name,
  ]

  # 通知を送信するSNSトピックのARN
  # 設定内容: 通知メッセージを送信するAmazon SNSトピックのARN
  # 設定可能な値: 有効なSNSトピックARN（arn:aws:sns:region:account-id:topic-name）
  # 省略時: 設定不可（必須）
  # topic_arn = aws_sns_topic.example.arn
  topic_arn = "arn:aws:sns:ap-northeast-1:123456789012:example-topic"

  #---------------------------------------
  # 通知イベント設定
  #---------------------------------------

  # 通知するイベントタイプのリスト
  # 設定内容: AutoScalingイベント発生時に通知を送信するイベントタイプのセット
  # 設定可能な値:
  #   - autoscaling:EC2_INSTANCE_LAUNCH            : インスタンス起動成功
  #   - autoscaling:EC2_INSTANCE_LAUNCH_ERROR      : インスタンス起動失敗
  #   - autoscaling:EC2_INSTANCE_TERMINATE         : インスタンス終了成功
  #   - autoscaling:EC2_INSTANCE_TERMINATE_ERROR   : インスタンス終了失敗
  #   - autoscaling:TEST_NOTIFICATION              : テスト通知
  # 省略時: 設定不可（必須）
  notifications = [
    "autoscaling:EC2_INSTANCE_LAUNCH",
    "autoscaling:EC2_INSTANCE_TERMINATE",
    "autoscaling:EC2_INSTANCE_LAUNCH_ERROR",
    "autoscaling:EC2_INSTANCE_TERMINATE_ERROR",
  ]

  #---------------------------------------
  # リージョン設定
  #---------------------------------------

  # リソースを管理するAWSリージョン
  # 設定内容: このリソースを作成・管理するリージョン
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null
}

#---------------------------------------
# Attributes Reference
#---------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: 通知設定の識別子（形式: <topic_arn>:<group_name_1>:<group_name_2>:...）
# - group_names: 通知対象のAutoScalingグループ名のセット
# - notifications: 通知対象のイベントタイプのセット
# - topic_arn: 通知送信先のSNSトピックARN
# - region: リソースが管理されているAWSリージョン
