#---------------------------------------------------------------
# AWS API Gateway REST API Policy
#---------------------------------------------------------------
#
# Amazon API Gateway REST APIにリソースポリシーをアタッチするリソースです。
# リソースポリシーはJSONポリシードキュメントで、特定のプリンシパル（通常は
# IAMロールやグループ）がAPIを呼び出せるかどうかを制御します。
#
# リソースポリシーを使用して、以下からのAPI呼び出しを許可できます:
#   - 指定したAWSアカウントのユーザー
#   - 指定したソースIPアドレス範囲またはCIDRブロック
#   - 指定したVPCまたはVPCエンドポイント（任意のアカウント）
#
# AWS公式ドキュメント:
#   - リソースポリシーによるアクセス制御: https://docs.aws.amazon.com/apigateway/latest/developerguide/apigateway-resource-policies.html
#   - リソースポリシーの例: https://docs.aws.amazon.com/apigateway/latest/developerguide/apigateway-resource-policies-examples.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_rest_api_policy
#
# Provider Version: 6.28.0
# Generated: 2026-01-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_api_gateway_rest_api_policy" "example" {
  #-------------------------------------------------------------
  # REST API ID設定
  #-------------------------------------------------------------

  # rest_api_id (Required)
  # 設定内容: ポリシーをアタッチするREST APIのIDを指定します。
  # 設定可能な値: aws_api_gateway_rest_apiリソースのid属性
  rest_api_id = aws_api_gateway_rest_api.example.id

  #-------------------------------------------------------------
  # ポリシー設定
  #-------------------------------------------------------------

  # policy (Required)
  # 設定内容: API Gatewayへのアクセスを制御するJSON形式のポリシードキュメントを指定します。
  # 設定可能な値: 有効なIAMポリシードキュメント（JSON形式）
  # 関連機能: API Gatewayリソースポリシー
  #   リソースポリシーを使用して、特定のIPアドレス、AWSアカウント、
  #   VPCエンドポイントからのアクセスを制御できます。
  #   - https://docs.aws.amazon.com/apigateway/latest/developerguide/apigateway-resource-policies.html
  # 参考: TerraformでIAMポリシードキュメントを構築する方法については以下を参照
  #   - https://learn.hashicorp.com/terraform/aws/iam-policy
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
# ポリシードキュメント例
#---------------------------------------------------------------
# 以下は特定のIPアドレスからのアクセスのみを許可するポリシーの例です。

data "aws_iam_policy_document" "example" {
  statement {
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    actions   = ["execute-api:Invoke"]
    resources = ["${aws_api_gateway_rest_api.example.execution_arn}/*"]

    condition {
      test     = "IpAddress"
      variable = "aws:SourceIp"
      values   = ["123.123.123.123/32"]
    }
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: REST APIのID
#---------------------------------------------------------------
