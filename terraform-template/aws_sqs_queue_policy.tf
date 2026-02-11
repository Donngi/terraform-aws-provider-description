#---------------------------------------------------------------
# AWS SQS Queue Policy
#---------------------------------------------------------------
#
# Amazon SQSキューのリソースベースポリシーをプロビジョニングするリソースです。
# キューポリシーは、どのAWSアカウント・IAMユーザー・ロールがキューに対して
# どのアクションを実行できるかを制御するアクセスポリシーを定義します。
#
# AWS公式ドキュメント:
#   - SQSアクセスポリシーの概要: https://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSDeveloperGuide/sqs-overview-of-managing-access.html
#   - SQSアクセスポリシーの設定: https://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSDeveloperGuide/sqs-configure-add-permissions.html
#   - SQSポリシーの基本例: https://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSDeveloperGuide/sqs-basic-examples-of-sqs-policies.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue_policy
#
# Provider Version: 6.28.0
# Generated: 2026-02-09
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_sqs_queue_policy" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # queue_url (Required)
  # 設定内容: ポリシーを適用するSQSキューのURLを指定します。
  # 設定可能な値: 有効なSQSキューURL
  # 注意: aws_sqs_queueリソースのidまたはurl属性を参照して指定するのが一般的です。
  queue_url = aws_sqs_queue.example.id

  #-------------------------------------------------------------
  # ポリシー設定
  #-------------------------------------------------------------

  # policy (Required)
  # 設定内容: SQSキューに適用するJSON形式のアクセスポリシーを指定します。
  # 設定可能な値: 有効なIAMポリシーJSON文字列
  # 関連機能: SQSリソースベースポリシー
  #   どのAWSアカウント・ユーザー・ロールがキューに対してSendMessage、
  #   ReceiveMessage、DeleteMessage等のアクションを実行できるかを制御します。
  #   - https://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSDeveloperGuide/sqs-overview-of-managing-access.html
  # 注意: ポリシーに Version = "2012-10-17" を明示的に指定しないと、
  #       AWSがキューの作成・更新時に無限にハングする可能性があります。
  #       aws_iam_policy_documentデータソースまたはjsonencode関数での
  #       ポリシー構築が推奨されます。
  # 参考: https://learn.hashicorp.com/terraform/aws/iam-policy
  policy = data.aws_iam_policy_document.example.json

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
# - id: SQSキューのURL
#---------------------------------------------------------------
