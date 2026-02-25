#-------
# AWS User Notifications - Event Rule (イベントルール)
#-------
# 用途: AWS User Notificationsの通知設定にイベントルールを関連付け、特定のAWSイベントを通知に変換する
# 制限事項:
#   - event_typeはCloudWatch Alarm State Change等のAWSイベント名を正確に指定する必要がある
#   - sourceはaws.([a-z0-9-])+の形式に準拠する必要がある（例: aws.cloudwatch）
#   - regionsはリージョンパターン ([a-z]{1,2})-([a-z]{1,15}-)+([0-9]) に準拠する必要がある
#   - event_patternはJSON文字列で最大4096文字まで指定可能
# 参考: https://docs.aws.amazon.com/notifications/latest/userguide/
# Provider Version: 6.28.0
# Generated: 2026-02-18
# Terraform Registry: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/notifications_event_rule
# NOTE: このテンプレートは参考例です。実際の環境に合わせて適宜修正してください。
#-------

resource "aws_notifications_event_rule" "example" {
  #-------
  # イベントソース設定
  #-------
  # 設定内容: イベントの送信元AWSサービスを識別するソース名
  # 設定可能な値:
  #   - aws.cloudwatch: CloudWatchアラームイベント
  #   - aws.ec2: EC2インスタンス状態変更イベント
  #   - aws.rds: RDSデータベースイベント
  #   - aws.s3: S3バケットイベント
  #   - aws.codecommit: CodeCommitリポジトリイベント
  #   - aws.codepipeline: CodePipelineパイプラインイベント
  # 制約事項: aws.([a-z0-9-])+ のパターンに準拠、1〜36文字
  source = "aws.cloudwatch"

  # 設定内容: マッチさせるAWSイベントの種類
  # 設定可能な値（例）:
  #   - CloudWatch Alarm State Change: CloudWatchアラームの状態変化
  #   - EC2 Instance State-change Notification: EC2インスタンス状態変化
  #   - RDS DB Instance Event: RDSインスタンスイベント
  #   - AWS Health Event: AWSヘルスイベント
  # 制約事項: ([a-zA-Z0-9 -()])+ のパターンに準拠、1〜128文字
  event_type = "CloudWatch Alarm State Change"

  # 設定内容: このイベントルールを適用するAWSリージョンのセット
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 制約事項: 各リージョンは ([a-z]{1,2})-([a-z]{1,15}-)+([0-9]) のパターンに準拠、2〜25文字
  # 注意事項: 複数のリージョンにまたがる監視が可能
  regions = ["us-east-1", "us-west-2"]

  # 設定内容: 関連付ける通知設定のARN
  # 制約事項: arn:aws:notifications::[0-9]{12}:configuration/[a-z0-9]{27} のパターンに準拠
  # 用途: aws_notifications_notification_configuration リソースのARNを指定
  notification_configuration_arn = "arn:aws:notifications::123456789012:configuration/example0000000000000000000"

  #-------
  # イベントパターン設定
  #-------
  # 設定内容: マッチさせるイベントの詳細条件をJSON文字列で定義
  # 省略時: 全てのevent_typeイベントにマッチ
  # 制約事項: 最大4096文字
  # 用途: 特定のアラーム状態や特定のリソースのみを通知対象とする場合に使用
  # 例: CloudWatchアラームがALARMになった場合のみ通知
  event_pattern = jsonencode({
    detail = {
      state = {
        value = ["ALARM"]
      }
    }
  })
}

#-------
# Attributes Reference (参照可能な属性)
#-------
# - id: イベントルールのARN
# - arn: イベントルールのARN
