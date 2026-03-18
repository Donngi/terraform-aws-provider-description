#---------------------------------------------------------------
# AWS CloudWatch Log Resource Policy
#---------------------------------------------------------------
#
# CloudWatch Logsのリソースポリシーをプロビジョニングするリソースです。
# リソースポリシーは、他のAWSサービス（Route 53、Elasticsearch等）が
# CloudWatch Logsのロググループにログを配信する際に必要なアクセス許可を
# 定義します。
#
# AWS公式ドキュメント:
#   - CloudWatch Logsアクセス管理: https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/iam-access-control-overview-cwl.html
#   - リソースポリシーの使用: https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/AWS-logs-and-resource-policy.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_resource_policy
#
# Provider Version: 6.36.0
# Generated: 2026-03-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_cloudwatch_log_resource_policy" "example" {
  #-------------------------------------------------------------
  # ポリシー識別設定
  #-------------------------------------------------------------

  # policy_name (Optional)
  # 設定内容: CloudWatch Logsリソースポリシーの名前を指定します。
  # 設定可能な値: 文字列（policy_nameまたはresource_arnのいずれか一方を必ず指定）
  # 省略時: resource_arnを指定する場合は省略可能
  # 注意: アカウントスコープのポリシーではpolicy_nameが必須です。
  #       policy_name指定のリソースポリシーはリージョンあたり10個までに制限されています。
  policy_name = "example-log-resource-policy"

  # resource_arn (Optional)
  # 設定内容: リソースポリシーを関連付けるCloudWatch Logsリソースの ARN を指定します。
  # 設定可能な値: 有効なCloudWatch Logsロググループ ARN（policy_nameまたはresource_arnのいずれか一方を必ず指定）
  # 省略時: policy_nameを指定する場合は省略可能
  # 注意: リソーススコープのポリシーではresource_arnが必須です。
  #       ロググループ ARN ごとに1つのポリシーのみ関連付けできます。
  resource_arn = null

  #-------------------------------------------------------------
  # ポリシードキュメント設定
  #-------------------------------------------------------------

  # policy_document (Required)
  # 設定内容: IAMポリシードキュメント形式のJSON文字列を指定します。
  # 設定可能な値: 有効なJSON形式のIAMポリシードキュメント（最大5120文字）
  # 省略時: 設定不可（必須項目）
  # 注意: aws_iam_policy_documentデータソースを使用してポリシーを生成することを推奨します。
  #       Principal、Action、Resource、Effectを含む有効なIAMポリシー形式が必要です。
  policy_document = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "route53.amazonaws.com"
        }
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents",
        ]
        Resource = "arn:aws:logs:*:*:log-group:/aws/route53/*"
      }
    ]
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
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id          - resource_arn未指定時はポリシー名、指定時はロググループ ARN
# - policy_scope - ポリシーのスコープ（"ACCOUNT" または "RESOURCE"）
# - revision_id - リソースポリシーのリビジョンID（リソーススコープのポリシーのみ）
#---------------------------------------------------------------
