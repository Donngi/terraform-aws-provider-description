#---------------------------------------------------------------
# AWS Auto Scaling Notification
#---------------------------------------------------------------
#
# Auto Scalingグループに対するSNS通知を設定するリソースです。
# 指定したAuto Scalingグループでインスタンスの起動・終了などのイベントが
# 発生した際に、SNSトピックへ通知を送信します。
#
# AWS公式ドキュメント:
#   - Amazon EC2 Auto Scaling通知設定: https://docs.aws.amazon.com/autoscaling/ec2/userguide/ec2-auto-scaling-sns-notifications.html
#   - NotificationConfiguration API: https://docs.aws.amazon.com/autoscaling/ec2/APIReference/API_NotificationConfiguration.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_notification
#
# Provider Version: 6.28.0
# Generated: 2026-01-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_autoscaling_notification" "example" {
  #-------------------------------------------------------------
  # 対象Auto Scalingグループ設定
  #-------------------------------------------------------------

  # group_names (Required)
  # 設定内容: 通知を設定するAuto Scalingグループの名前リストを指定します。
  # 設定可能な値: Auto Scalingグループ名の文字列セット
  # 注意: 複数のAuto Scalingグループに同じ通知設定を適用できます。
  group_names = [
    "my-autoscaling-group-1",
    "my-autoscaling-group-2",
  ]

  #-------------------------------------------------------------
  # 通知タイプ設定
  #-------------------------------------------------------------

  # notifications (Required)
  # 設定内容: 通知をトリガーするイベントタイプのリストを指定します。
  # 設定可能な値:
  #   - "autoscaling:EC2_INSTANCE_LAUNCH": インスタンスの起動成功時
  #   - "autoscaling:EC2_INSTANCE_LAUNCH_ERROR": インスタンスの起動失敗時
  #   - "autoscaling:EC2_INSTANCE_TERMINATE": インスタンスの終了成功時
  #   - "autoscaling:EC2_INSTANCE_TERMINATE_ERROR": インスタンスの終了失敗時
  #   - "autoscaling:TEST_NOTIFICATION": テスト通知
  # 参考: https://docs.aws.amazon.com/autoscaling/ec2/APIReference/API_NotificationConfiguration.html
  notifications = [
    "autoscaling:EC2_INSTANCE_LAUNCH",
    "autoscaling:EC2_INSTANCE_LAUNCH_ERROR",
    "autoscaling:EC2_INSTANCE_TERMINATE",
    "autoscaling:EC2_INSTANCE_TERMINATE_ERROR",
  ]

  #-------------------------------------------------------------
  # SNSトピック設定
  #-------------------------------------------------------------

  # topic_arn (Required)
  # 設定内容: 通知を送信するSNSトピックのARNを指定します。
  # 設定可能な値: 有効なSNSトピックARN
  # 注意: SNSトピックはAuto Scalingグループと同じリージョンに存在する必要があります。
  topic_arn = "arn:aws:sns:ap-northeast-1:123456789012:my-autoscaling-notifications"

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
# 関連リソース例
#---------------------------------------------------------------
# 通常、このリソースは以下のリソースと組み合わせて使用します:
#
# resource "aws_sns_topic" "autoscaling_notifications" {
#   name = "autoscaling-notifications"
# }
#
# resource "aws_autoscaling_group" "example" {
#   name = "my-autoscaling-group"
#   # ... 他の設定
# }
#---------------------------------------------------------------
