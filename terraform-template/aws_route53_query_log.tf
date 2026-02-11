#---------------------------------------------------------------
# Amazon Route 53 Query Logging Configuration
#---------------------------------------------------------------
#
# Route 53のホストゾーンに対するDNSクエリログ設定を管理するリソースです。
# クエリログを有効にすることで、以下の情報を記録できます:
#   - クエリを受信したRoute 53エッジロケーション
#   - クエリされたドメイン名またはサブドメイン
#   - DNSレコードタイプ (A、AAAAなど)
#   - DNSレスポンスコード (NoError、ServFailなど)
#
# 重要な制約事項:
#   1. CloudWatch Logs ログループは us-east-1 リージョンに作成する必要があります
#   2. Route 53がログを書き込むための適切なリソースポリシーが必要です
#   3. クエリログを有効にできるのはパブリックホストゾーンのみです
#   4. プライベートホストゾーンには対応していません
#
# AWS公式ドキュメント:
#   - DNSクエリログの設定: https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/query-logs.html
#   - クエリログ形式: https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/query-logs-format.html
#   - CreateQueryLoggingConfig API: https://docs.aws.amazon.com/Route53/latest/APIReference/API_CreateQueryLoggingConfig.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_query_log
#
# Provider Version: 6.28.0
# Generated: 2026-02-03
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# 前提条件: us-east-1リージョンのCloudWatch Logs設定
#---------------------------------------------------------------
# Route 53クエリログは必ずus-east-1リージョンのCloudWatch Logsに
# 送信する必要があるため、プロバイダーエイリアスを使用します

provider "aws" {
  alias  = "us-east-1"
  region = "us-east-1"
}

# CloudWatch Logsログループの作成
resource "aws_cloudwatch_log_group" "route53_query_log" {
  provider = aws.us-east-1

  # ログループ名は /aws/route53/ プレフィックスを推奨
  name = "/aws/route53/${aws_route53_zone.example.name}"

  # ログの保持期間 (日数)
  retention_in_days = 30

  tags = {
    Name        = "route53-query-log"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# CloudWatch Logs リソースポリシーの設定
#---------------------------------------------------------------
# Route 53がCloudWatch Logsにログを書き込むための権限を付与

# IAMポリシードキュメントの定義
data "aws_iam_policy_document" "route53_query_logging_policy" {
  statement {
    # Route 53に必要な権限
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    # /aws/route53/ 配下の全てのログループへのアクセスを許可
    resources = ["arn:aws:logs:*:*:log-group:/aws/route53/*"]

    # Route 53サービスをプリンシパルとして指定
    principals {
      identifiers = ["route53.amazonaws.com"]
      type        = "Service"
    }
  }
}

# CloudWatch Logsリソースポリシーの作成
resource "aws_cloudwatch_log_resource_policy" "route53_query_logging_policy" {
  provider = aws.us-east-1

  # ポリシー名
  policy_name = "route53-query-logging-policy"

  # ポリシードキュメントのJSON
  policy_document = data.aws_iam_policy_document.route53_query_logging_policy.json
}

#---------------------------------------------------------------
# Route 53 ホストゾーンの作成
#---------------------------------------------------------------
# クエリログを設定するパブリックホストゾーン

resource "aws_route53_zone" "example" {
  # ドメイン名
  name = "example.com"

  # パブリックホストゾーンとして作成 (デフォルト)
  # プライベートホストゾーンにはクエリログを設定できません
  comment = "Public hosted zone for example.com"

  tags = {
    Name        = "example-zone"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Route 53 クエリログ設定
#---------------------------------------------------------------

resource "aws_route53_query_log" "example" {
  #-------------------------------------------------------------
  # 必須パラメータ
  #-------------------------------------------------------------

  # cloudwatch_log_group_arn (Required)
  # 設定内容: クエリログを送信するCloudWatch LogsログループのARNを指定します。
  # 設定可能な値: 有効なCloudWatch LogsログループのARN
  # 制約事項:
  #   - ログループは us-east-1 リージョンに存在する必要があります
  #   - ログループ名は /aws/route53/ プレフィックスを推奨します
  # 関連機能: CloudWatch Logs
  #   DNSクエリログはCloudWatch Logsに記録され、分析やモニタリングに使用できます。
  #   ログには、クエリ日時、エッジロケーション、クエリタイプ、レスポンスコードなどが含まれます。
  #   - https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/query-logs.html
  cloudwatch_log_group_arn = aws_cloudwatch_log_group.route53_query_log.arn

  # zone_id (Required)
  # 設定内容: クエリログを有効にするRoute 53ホストゾーンのIDを指定します。
  # 設定可能な値: 有効なRoute 53パブリックホストゾーンのID
  # 制約事項:
  #   - パブリックホストゾーンのみサポート
  #   - プライベートホストゾーンにはクエリログを設定できません
  #   - 1つのホストゾーンには1つのクエリログ設定のみ可能
  # 関連機能: Route 53 Hosted Zone
  #   ホストゾーンのDNSクエリを記録します。エッジロケーションごとにログストリームが作成されます。
  #   - https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/hosted-zones-working-with.html
  zone_id = aws_route53_zone.example.zone_id

  #-------------------------------------------------------------
  # 依存関係の設定
  #-------------------------------------------------------------
  # CloudWatch Logsリソースポリシーが作成されてから
  # クエリログ設定を作成する必要があります
  depends_on = [aws_cloudwatch_log_resource_policy.route53_query_logging_policy]

  #-------------------------------------------------------------
  # id (Optional, Computed)
  #-------------------------------------------------------------
  # 設定内容: クエリログ設定のID
  # 注意: 通常は明示的に設定する必要はありません。Terraformが自動管理します
  id = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: クエリログ設定のAmazon Resource Name (ARN)
#   フォーマット: arn:aws:route53:::queryloggingconfig/<ID>
#
# - id: クエリログ設定のID
#   他のリソースから参照する際に使用します
#
#---------------------------------------------------------------
# クエリログの形式
#---------------------------------------------------------------
# CloudWatch Logsに記録されるクエリログには以下の情報が含まれます:
#
# 1. version: ログフォーマットのバージョン番号
# 2. account_id: AWSアカウントID
# 3. region: クエリに応答したRoute 53エッジロケーションのリージョン
# 4. vpc_id: VPCからのクエリの場合、VPC ID (パブリッククエリの場合は "-")
# 5. query_timestamp: クエリのタイムスタンプ (ISO 8601形式)
# 6. hosted_zone_id: ホストゾーンID
# 7. query_name: クエリされたドメイン名
# 8. query_type: DNSレコードタイプ (A、AAAA、MX、TXTなど)
# 9. response_code: DNSレスポンスコード (NoError、NXDomain、ServFailなど)
#---------------------------------------------------------------
