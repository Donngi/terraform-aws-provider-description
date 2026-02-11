#---------------------------------------------------------------
# AWS CloudWatch Log Destination
#---------------------------------------------------------------
#
# Amazon CloudWatch Logsの送信先（Destination）をプロビジョニングするリソースです。
# 送信先は、クロスアカウントサブスクリプションを使用して、あるAWSアカウントから
# 別のAWSアカウントにログイベントをストリーミングするために使用されます。
# 送信先は、Amazon Kinesis Data StreamまたはAmazon Data Firehoseをターゲットとして
# 設定できます。
#
# AWS公式ドキュメント:
#   - CloudWatch Logs Destinations: https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/CreateDestination.html
#   - クロスアカウントログサブスクリプション: https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/Cross-Account-Log_Subscription-New.html
#   - PutDestination API: https://docs.aws.amazon.com/AmazonCloudWatchLogs/latest/APIReference/API_PutDestination.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_destination
#
# Provider Version: 6.28.0
# Generated: 2026-01-19
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_cloudwatch_log_destination" "example" {
  #-------------------------------------------------------------
  # 名前設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: ログ送信先の名前を指定します。
  # 設定可能な値: 1-512文字の文字列
  # 注意: この名前は、他のアカウントがPutSubscriptionFilterでサブスクリプションを
  #       作成する際に使用されます。
  name = "my-log-destination"

  #-------------------------------------------------------------
  # IAMロール設定
  #-------------------------------------------------------------

  # role_arn (Required)
  # 設定内容: CloudWatch Logsがターゲットにデータを送信するための権限を持つ
  #           IAMロールのARNを指定します。
  # 設定可能な値: 有効なIAMロールARN
  # 関連機能: クロスアカウントログサブスクリプション
  #   CloudWatch LogsがKinesis Data StreamやFirehoseにPutRecordオペレーションを
  #   実行するための権限が必要です。IAMロールには適切な信頼ポリシーと
  #   アクセス許可ポリシーを設定する必要があります。
  #   - https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/CreateDestination.html
  role_arn = "arn:aws:iam::123456789012:role/CloudWatchLogsToKinesisRole"

  #-------------------------------------------------------------
  # ターゲット設定
  #-------------------------------------------------------------

  # target_arn (Required)
  # 設定内容: ログイベントの送信先となるターゲットリソースのARNを指定します。
  # 設定可能な値:
  #   - Amazon Kinesis Data StreamのARN
  #   - Amazon Data FirehoseのARN
  # 関連機能: ログデータのリアルタイムストリーミング
  #   送信先に関連付けられたサブスクリプションフィルターに一致するログイベントが、
  #   指定されたターゲットにリアルタイムでストリーミングされます。
  #   - https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/Subscriptions.html
  target_arn = "arn:aws:kinesis:ap-northeast-1:123456789012:stream/my-kinesis-stream"

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
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  #   - https://docs.aws.amazon.com/tag-editor/latest/userguide/tagging.html
  tags = {
    Name        = "my-log-destination"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: ログ送信先のAmazon Resource Name (ARN)
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------

#---------------------------------------------------------------
# 関連リソース
#---------------------------------------------------------------
# ログ送信先を使用するには、以下の関連リソースも設定が必要です:
#
# 1. aws_cloudwatch_log_destination_policy
#    送信先へのクロスアカウントアクセスを許可するためのアクセスポリシーを設定します。
#    PutDestinationだけではアクセスポリシーは設定されないため、クロスアカウントの
#    ユーザーがPutSubscriptionFilterを呼び出せるようにするには、
#    送信先の所有者がPutDestinationPolicyを呼び出す必要があります。
#
# 2. aws_iam_role
#    CloudWatch LogsがターゲットにPutRecordを実行するためのIAMロール。
#    以下の信頼ポリシーが必要です:
#---------------------------------------------------------------
