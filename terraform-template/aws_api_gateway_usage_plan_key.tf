#---------------------------------------------------------------
# AWS API Gateway Usage Plan Key
#---------------------------------------------------------------
#
# Amazon API GatewayのUsage Plan Key (使用量プランキー) をプロビジョニングするリソースです。
# 既存のAPIキーを使用量プランに関連付けることで、そのAPIキーに対して
# 使用量プランで定義されたスロットリング制限やクォータ制限を適用します。
#
# 主な機能:
#   - 既存のAPIキーを使用量プランに関連付け
#   - APIキーごとに異なる使用量制限を適用
#   - 複数の顧客やアプリケーションごとにAPI利用を管理
#
# 制限事項:
#   - APIキーは、各APIステージにつき1つの使用量プランにのみ関連付け可能
#   - key_typeは現在「API_KEY」のみサポート
#   - 使用量プランとAPIキーは事前に作成されている必要がある
#
# AWS公式ドキュメント:
#   - 使用量プランの設定: https://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-create-usage-plans.html
#   - CreateUsagePlanKey API: https://docs.aws.amazon.com/apigateway/latest/api/API_CreateUsagePlanKey.html
#   - 使用量プランとAPIキー: https://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-api-usage-plans.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_usage_plan_key
#
# Provider Version: 6.28.0
# Generated: 2026-02-11
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_api_gateway_usage_plan_key" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # usage_plan_id (Required)
  # 設定内容: APIキーを関連付ける使用量プランのIDを指定します。
  # 設定可能な値: aws_api_gateway_usage_plan リソースのID
  # 用途: このIDで識別される使用量プランに、APIキーを関連付けます。
  usage_plan_id = aws_api_gateway_usage_plan.example.id

  # key_id (Required)
  # 設定内容: 使用量プランに関連付けるAPIキーのIDを指定します。
  # 設定可能な値: aws_api_gateway_api_key リソースのID
  # 用途: このAPIキーに対して、使用量プランで定義されたスロットリングやクォータが適用されます。
  key_id = aws_api_gateway_api_key.example.id

  # key_type (Required)
  # 設定内容: 関連付けるキーのタイプを指定します。
  # 設定可能な値: API_KEY（現在サポートされている唯一のタイプ）
  # 用途: 使用量プランに関連付けるキーの種類を識別します。
  key_type = "API_KEY"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するAWSリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1, us-west-2）
  # 省略時: プロバイダー設定で指定されたリージョンが使用されます。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: 使用量プランキーのID
#
# - name: 使用量プランキーの名前
#       使用量プランに関連付けられたAPIキーの名前が自動的に設定されます。
#
# - value: 使用量プランキーの値
#         使用量プランに関連付けられたAPIキーの実際の値（APIキー文字列）が自動的に設定されます。
#         この値はセキュリティ上の理由から慎重に扱う必要があります。
#---------------------------------------------------------------
