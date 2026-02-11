#---------------------------------------------------------------
# AWS SQS Queue Redrive Policy
#---------------------------------------------------------------
#
# Amazon SQSキューのRedriveポリシー（デッドレターキュー設定）をプロビジョニングするリソースです。
# デッドレターキューのARNを参照しながらRedriveポリシーを設定できます。
# 標準キューまたはFIFOキュー用の専用デッドレターキューを設定する際に有用で、
# Redriveポリシーを設定する前にデッドレターキューが存在する必要がある場合に使用します。
#
# AWS公式ドキュメント:
#   - Amazon SQSのデッドレターキューの使用: https://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSDeveloperGuide/sqs-dead-letter-queues.html
#   - デッドレターキューのRedriveの設定: https://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSDeveloperGuide/sqs-configure-dead-letter-queue-redrive.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue_redrive_policy
#
# Provider Version: 6.28.0
# Generated: 2026-02-05
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_sqs_queue_redrive_policy" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # queue_url (Required)
  # 設定内容: Redriveポリシーを適用するSQSキューのURLを指定します。
  # 設定可能な値: 有効なSQSキューのURL（通常、aws_sqs_queue.id属性から取得）
  # 注意: これはソースキュー（メッセージが最初に送信されるキュー）のURLです。
  #       デッドレターキューのURLではありません。
  queue_url = "https://sqs.ap-northeast-1.amazonaws.com/123456789012/example-queue"

  # redrive_policy (Required)
  # 設定内容: SQSキュー用のJSON形式のRedriveポリシーを指定します。
  # 設定可能な値: 以下の2つのキーと値のペアを含むJSONエンコードされた文字列
  #   - deadLetterTargetArn: デッドレターキューのARN（メッセージの移動先）
  #   - maxReceiveCount: メッセージがデッドレターキューに移動されるまでに
  #                      ソースキューから受信できる最大回数
  # 関連機能: Amazon SQS デッドレターキュー
  #   デッドレターキュー（DLQ）は、ソースキューが正常に処理できないメッセージを
  #   対象とするために使用されます。DLQは、メッセージが処理に失敗した際の診断や
  #   デバッグに役立ちます。Redriveポリシーは、メッセージがDLQに移動される条件を定義します。
  #   - https://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSDeveloperGuide/sqs-dead-letter-queues.html
  # 注意:
  #   - maxReceiveCountの値が低すぎると、1回の失敗でメッセージがDLQに移動される可能性があります
  #   - 標準キューの場合、maxReceiveCountが3より大きい場合、3回以上受信されて削除されない
  #     メッセージはキューの後ろに移動されます
  #   - FIFOキューでDLQを使用すると、メッセージや操作の厳密な順序が崩れる可能性があるため、
  #     順序が重要でない場合を除き推奨されません
  redrive_policy = jsonencode({
    deadLetterTargetArn = "arn:aws:sqs:ap-northeast-1:123456789012:example-dlq"
    maxReceiveCount     = 4
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

  #-------------------------------------------------------------
  # ID設定
  #-------------------------------------------------------------

  # id (Optional, Computed)
  # 設定内容: リソースの識別子を指定します。
  # 設定可能な値: 任意の文字列
  # 省略時: Terraformが自動的にキューURLを使用して生成します
  # 注意: 通常は省略して、Terraformに自動生成させることを推奨します
  id = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは、上記の引数に加えて特別な読み取り専用属性はエクスポートしません。
# id属性は、指定されない場合、キューURLが使用されます。
#---------------------------------------------------------------
