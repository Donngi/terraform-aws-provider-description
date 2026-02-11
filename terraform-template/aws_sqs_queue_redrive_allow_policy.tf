#---------------------------------------------------------------
# AWS SQS Queue Redrive Allow Policy
#---------------------------------------------------------------
#
# SQSキューのRedrive Allow Policy（デッドレターキューへのリドライブ許可ポリシー）を
# 管理するためのリソースです。
# このポリシーにより、どのソースキューがこのキューをデッドレターキューとして
# 使用できるかを制御できます。
#
# AWS公式ドキュメント:
#   - SQS デッドレターキュー: https://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSDeveloperGuide/sqs-dead-letter-queues.html
#   - SetQueueAttributes API: https://docs.aws.amazon.com/AWSSimpleQueueService/latest/APIReference/API_SetQueueAttributes.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue_redrive_allow_policy
#
# Provider Version: 6.28.0
# Generated: 2026-02-09
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_sqs_queue_redrive_allow_policy" "example" {
  #-------------------------------------------------------------
  # キューURL設定
  #-------------------------------------------------------------

  # queue_url (Required)
  # 設定内容: Redrive Allow Policyを適用するSQSキュー（デッドレターキュー）のURLを指定します。
  # 設定可能な値: 有効なSQSキューURL
  # 関連機能: Amazon SQS デッドレターキュー
  #   デッドレターキュー（DLQ）は、正常に処理できなかったメッセージを
  #   受信するためのキューです。Redrive Allow Policyは、このDLQに対して
  #   どのソースキューからメッセージのリドライブを許可するかを制御します。
  #   - https://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSDeveloperGuide/sqs-dead-letter-queues.html
  queue_url = aws_sqs_queue.example.id

  #-------------------------------------------------------------
  # Redrive Allow Policy設定
  #-------------------------------------------------------------

  # redrive_allow_policy (Required)
  # 設定内容: JSON形式のRedrive Allow Policyを指定します。
  # 設定可能な値: 以下のフィールドを含むJSONオブジェクト
  #   - redrivePermission: リドライブの許可レベル
  #     - "allowAll": すべてのソースキューからのリドライブを許可
  #     - "byQueue": sourceQueueArnsで指定したキューのみ許可
  #     - "denyAll": すべてのソースキューからのリドライブを拒否
  #   - sourceQueueArns: (redrivePermission が "byQueue" の場合に必須)
  #     リドライブを許可するソースキューのARNリスト
  # 関連機能: Amazon SQS デッドレターキューのアクセス制御
  #   Redrive Allow Policyにより、意図しないキューからの
  #   デッドレターキューへのメッセージ送信を防止できます。
  #   セキュリティのベストプラクティスとして、"byQueue"を使用して
  #   明示的に許可するソースキューを指定することを推奨します。
  #   - https://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSDeveloperGuide/sqs-dead-letter-queues.html
  redrive_allow_policy = jsonencode({
    redrivePermission = "byQueue"
    sourceQueueArns   = [aws_sqs_queue.src.arn]
  })

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
# 関連リソースの例
#---------------------------------------------------------------
# 以下は、デッドレターキューとソースキューの構成例です。
# 実際の使用時は、適切なキュー名やmaxReceiveCountを指定してください。
#---------------------------------------------------------------

resource "aws_sqs_queue" "example" {
  name = "example-dlq"
}

resource "aws_sqs_queue" "src" {
  name = "example-source-queue"

  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.example.arn
    maxReceiveCount     = 4
  })
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: キューURLと同じ値
#
#---------------------------------------------------------------
