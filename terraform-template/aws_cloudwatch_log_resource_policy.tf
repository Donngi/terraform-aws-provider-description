################################################################################
# CloudWatch Logs Resource Policy
################################################################################
#
# 生成日: 2026-01-19
# Provider: hashicorp/aws v6.28.0
#
# 注意事項:
# - このテンプレートは生成時点（2026-01-19）の情報に基づいています
# - 最新の仕様や詳細については、必ず以下の公式ドキュメントをご確認ください
#   - Terraform AWS Provider: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_resource_policy
#   - AWS公式ドキュメント: https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/iam-access-control-overview-cwl.html
#

################################################################################
# リソース: aws_cloudwatch_log_resource_policy
################################################################################
# CloudWatch Logsのリソースポリシーを管理します。
# リソースポリシーは、他のAWSサービス（例: Route53, OpenSearch Service, VPC Flow Logs等）が
# CloudWatch Logsにログを書き込むための権限を付与するために使用されます。
#
# 参照: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_resource_policy
# 参照: https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/iam-access-control-overview-cwl.html

resource "aws_cloudwatch_log_resource_policy" "example" {
  ################################################################################
  # 必須パラメータ
  ################################################################################

  # policy_name - (Required) リソースポリシーの名前
  # リソースポリシーを識別するための一意の名前を指定します。
  # 同じ名前のポリシーが既に存在する場合は上書きされます。
  #
  # 参照: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_resource_policy#policy_name
  policy_name = "example-resource-policy"

  # policy_document - (Required) リソースポリシーの詳細（JSON形式）
  # プリンシパル（どのサービスや外部アカウント）がこのアカウントのログに
  # アクセスできるかを定義するIAMポリシードキュメントです。
  # 最大長: 5120文字
  #
  # 一般的な使用例:
  # - Route53クエリログ: route53.amazonaws.comサービスにlogs:CreateLogStream、logs:PutLogEventsを許可
  # - OpenSearch Service: es.amazonaws.comサービスにログ配信を許可
  # - VPC Flow Logs: vpc-flow-logs.amazonaws.comサービスにログ配信を許可
  #
  # 参照: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_resource_policy#policy_document
  # 参照: https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/iam-access-control-overview-cwl.html
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
          "logs:PutLogEvents"
        ]
        Resource = "arn:aws:logs:*:*:log-group:/aws/route53/*"
      }
    ]
  })

  ################################################################################
  # オプションパラメータ
  ################################################################################

  # id - (Optional) リソースポリシーの識別子
  # 通常は自動的に割り当てられます（policy_nameと同じ値）。
  # 明示的に指定することも可能ですが、一般的には省略します。
  #
  # Type: string
  # Computed: true（指定しない場合は自動計算）
  #
  # 参照: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_resource_policy#id
  # id = "example-resource-policy"

  # region - (Optional) このリソースが管理されるリージョン
  # デフォルトでは、プロバイダー設定で指定されたリージョンが使用されます。
  # 特定のリージョンでリソースポリシーを管理したい場合に明示的に指定できます。
  #
  # Type: string
  # Default: プロバイダーの設定リージョン
  # Computed: true（指定しない場合はプロバイダーのリージョンが使用される）
  #
  # リージョナルエンドポイント参照: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # プロバイダー設定参照: https://registry.terraform.io/providers/hashicorp/aws/latest/docs#aws-configuration-reference
  #
  # 参照: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_resource_policy#region
  # region = "us-east-1"
}

################################################################################
# 出力例
################################################################################
# このリソースから取得できる属性:
# - id: リソースポリシーの名前（CloudWatch Logs resource policyのID）
#
# 使用例:
# output "policy_id" {
#   value = aws_cloudwatch_log_resource_policy.example.id
# }

################################################################################
# 一般的な使用例
################################################################################

# 例1: Route53クエリログ用のリソースポリシー
# data "aws_iam_policy_document" "route53_query_logging" {
#   statement {
#     actions = [
#       "logs:CreateLogStream",
#       "logs:PutLogEvents",
#     ]
#     resources = ["arn:aws:logs:*:*:log-group:/aws/route53/*"]
#     principals {
#       identifiers = ["route53.amazonaws.com"]
#       type        = "Service"
#     }
#   }
# }
#
# resource "aws_cloudwatch_log_resource_policy" "route53_query_logging" {
#   policy_document = data.aws_iam_policy_document.route53_query_logging.json
#   policy_name     = "route53-query-logging-policy"
# }

# 例2: OpenSearch Service用のリソースポリシー
# data "aws_iam_policy_document" "opensearch_logging" {
#   statement {
#     actions = [
#       "logs:CreateLogStream",
#       "logs:PutLogEvents",
#       "logs:PutLogEventsBatch",
#     ]
#     resources = ["arn:aws:logs:*"]
#     principals {
#       identifiers = ["es.amazonaws.com"]
#       type        = "Service"
#     }
#   }
# }
#
# resource "aws_cloudwatch_log_resource_policy" "opensearch_logging" {
#   policy_document = data.aws_iam_policy_document.opensearch_logging.json
#   policy_name     = "opensearch-log-publishing-policy"
# }
