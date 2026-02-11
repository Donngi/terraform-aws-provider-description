#---------------------------------------------------------------
# AWS API Gateway Account
#---------------------------------------------------------------
#
# API Gateway アカウント設定をプロビジョニングするリソースです。
# この設定はリージョン単位で適用され、主にCloudWatch Logsへのログ出力を
# 有効化するためのIAMロールを設定します。
#
# 注意: このリソースはAWSアカウントのAPI Gatewayサービス全体に影響する
# グローバル設定です。リージョンごとに1つのみ設定可能です。
#
# AWS公式ドキュメント:
#   - API Gateway CloudWatch Logsの設定: https://docs.aws.amazon.com/apigateway/latest/developerguide/set-up-logging.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_account
#
# Provider Version: 6.28.0
# Generated: 2026-01-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_api_gateway_account" "example" {
  #-------------------------------------------------------------
  # CloudWatch Logs ロール設定
  #-------------------------------------------------------------

  # cloudwatch_role_arn (Optional)
  # 設定内容: CloudWatch LogsへのAPI Gatewayログ出力に使用するIAMロールのARNを指定します。
  # 設定可能な値: 有効なIAMロールARN
  # 省略時: CloudWatch Logsへのログ出力が無効になります。
  # 関連機能: API Gateway CloudWatch Logs統合
  #   API Gatewayの実行ログやアクセスログをCloudWatch Logsに出力するには、
  #   適切な権限を持つIAMロールを設定する必要があります。
  #   IAMロールには `apigateway.amazonaws.com` を信頼されたエンティティとして設定し、
  #   `AmazonAPIGatewayPushToCloudWatchLogs` マネージドポリシーをアタッチします。
  #   - https://docs.aws.amazon.com/apigateway/latest/developerguide/set-up-logging.html
  # 注意: ログ出力はAPI Gatewayステージレベルで個別に有効化・無効化が可能です。
  cloudwatch_role_arn = aws_iam_role.api_gateway_cloudwatch.arn

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
# 関連リソース: IAMロール（CloudWatch Logs用）
#---------------------------------------------------------------
# API GatewayがCloudWatch Logsにログを書き込むために必要なIAMロールの例

data "aws_iam_policy_document" "api_gateway_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["apigateway.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "api_gateway_cloudwatch" {
  name               = "api_gateway_cloudwatch_global"
  assume_role_policy = data.aws_iam_policy_document.api_gateway_assume_role.json
}

resource "aws_iam_role_policy_attachment" "api_gateway_cloudwatch" {
  role       = aws_iam_role.api_gateway_cloudwatch.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonAPIGatewayPushToCloudWatchLogs"
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - api_key_version: アカウントで使用されるAPIキーのバージョン
#
# - features: アカウントでサポートされている機能のリスト
#
# - throttle_settings: アカウントレベルのスロットリング設定
#   - burst_limit: API Gatewayが1秒あたりにAPIを呼び出せる絶対最大回数（RPS）
#   - rate_limit: API Gatewayが1秒あたりにAPIを呼び出せる平均回数（RPS）
#
# - id (非推奨): リソースID
#---------------------------------------------------------------
