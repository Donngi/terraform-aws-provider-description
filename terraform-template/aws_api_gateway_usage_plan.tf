#---------------------------------------------------------------
# AWS API Gateway Usage Plan
#---------------------------------------------------------------
#
# Amazon API GatewayのUsage Plan (使用量プラン) をプロビジョニングするリソースです。
# Usage Planは、APIへのアクセス権を持つクライアントを指定し、
# オプションでリクエストレートとクォータの制限を設定できます。
#
# 注意: クライアントは設定したターゲットを超える場合があります。
# コスト管理にUsage Planを頼らず、AWS BudgetsやAWS WAFの使用を推奨します。
#
# AWS公式ドキュメント:
#   - Usage Plan概要: https://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-api-usage-plans.html
#   - スロットリング: https://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-request-throttling.html
#   - API リファレンス: https://docs.aws.amazon.com/apigateway/latest/api/API_UsagePlan.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_usage_plan
#
# Provider Version: 6.28.0
# Generated: 2026-01-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_api_gateway_usage_plan" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: Usage Planの名前を指定します。
  # 設定可能な値: 任意の文字列
  name = "my-usage-plan"

  # description (Optional)
  # 設定内容: Usage Planの説明を指定します。
  # 設定可能な値: 任意の文字列
  # 省略時: 説明なし
  description = "My API usage plan"

  # product_code (Optional)
  # 設定内容: AWS MarketplaceでSaaS製品として関連付けるためのプロダクト識別子を指定します。
  # 設定可能な値: AWS Marketplaceのプロダクトコード文字列
  # 省略時: Marketplaceとの関連付けなし
  # 用途: APIをAWS Marketplace経由で販売する場合に使用
  product_code = null

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
  # APIステージ設定
  #-------------------------------------------------------------

  # api_stages (Optional)
  # 設定内容: Usage Planに関連付けるAPIステージを指定します。
  # 複数のAPIステージを関連付けることができます。
  api_stages {
    # api_id (Required)
    # 設定内容: 関連付けるREST APIのIDを指定します。
    # 設定可能な値: aws_api_gateway_rest_api リソースのID
    api_id = aws_api_gateway_rest_api.example.id

    # stage (Required)
    # 設定内容: 関連付けるステージ名を指定します。
    # 設定可能な値: aws_api_gateway_stage リソースのステージ名
    stage = aws_api_gateway_stage.example.stage_name

    # throttle (Optional)
    # 設定内容: 特定のAPIメソッド単位でのスロットリング設定を指定します。
    # メソッドレベルで異なるスロットリング制限を設定できます。
    throttle {
      # path (Required)
      # 設定内容: スロットリングを適用するAPIパスとメソッドを指定します。
      # 設定可能な値: "リソースパス/HTTPメソッド" 形式（例: "/pets/GET", "/users/POST"）
      path = "/pets/GET"

      # burst_limit (Optional)
      # 設定内容: このメソッドのバースト制限（同時リクエスト数の上限）を指定します。
      # 設定可能な値: 正の整数
      # 省略時: Usage Plan全体のthrottle_settingsまたはデフォルト値を使用
      # 関連機能: トークンバケットアルゴリズム
      #   バースト制限は、トークンバケットの容量を表します。
      burst_limit = 10

      # rate_limit (Optional)
      # 設定内容: このメソッドの定常状態でのリクエストレート（RPS）を指定します。
      # 設定可能な値: 正の数値（小数可）
      # 省略時: Usage Plan全体のthrottle_settingsまたはデフォルト値を使用
      # 関連機能: トークンバケットアルゴリズム
      #   レート制限は、トークンバケットにトークンが追加される速度を表します。
      rate_limit = 5.0
    }
  }

  #-------------------------------------------------------------
  # クォータ設定
  #-------------------------------------------------------------

  # quota_settings (Optional)
  # 設定内容: 指定された期間内の最大リクエスト数を制限します。
  # 用途: APIの使用量を一定期間で制限したい場合に使用
  quota_settings {
    # limit (Required)
    # 設定内容: 指定期間内に許可される最大リクエスト数を指定します。
    # 設定可能な値: 正の整数
    limit = 1000

    # period (Required)
    # 設定内容: クォータが適用される期間を指定します。
    # 設定可能な値:
    #   - "DAY": 1日単位でリセット
    #   - "WEEK": 1週間単位でリセット
    #   - "MONTH": 1ヶ月単位でリセット
    period = "WEEK"

    # offset (Optional)
    # 設定内容: 最初の期間で制限から差し引くリクエスト数を指定します。
    # 設定可能な値: 0以上の整数
    # 省略時: 0
    # 用途: 期間の途中から使用量カウントを開始する場合に使用
    offset = 0
  }

  #-------------------------------------------------------------
  # スロットリング設定（Usage Plan全体）
  #-------------------------------------------------------------

  # throttle_settings (Optional)
  # 設定内容: Usage Plan全体に適用されるスロットリング制限を指定します。
  # 関連機能: API Gatewayスロットリング
  #   トークンバケットアルゴリズムを使用してリクエストをスロットリングします。
  #   制限を超えると、クライアントは 429 Too Many Requests エラーを受け取ります。
  #   - https://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-request-throttling.html
  throttle_settings {
    # burst_limit (Optional)
    # 設定内容: バースト制限（同時リクエスト数の上限）を指定します。
    # 設定可能な値: 正の整数
    # 省略時: アカウントレベルのデフォルト値を使用
    # 注意: この値はアカウントレベルの制限を超えることはできません。
    burst_limit = 100

    # rate_limit (Optional)
    # 設定内容: 定常状態でのリクエストレート（リクエスト/秒）を指定します。
    # 設定可能な値: 正の数値（小数可）
    # 省略時: アカウントレベルのデフォルト値を使用
    # 注意: この値はアカウントレベルの制限を超えることはできません。
    rate_limit = 50.0
  }

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  #   - キー: [a-zA-Z+-=._:/] で構成、最大128文字、"aws:"で始めることは不可
  #   - 値: 最大256文字
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "my-usage-plan"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: Usage PlanのID
#
# - arn: Usage PlanのAmazon Resource Name (ARN)
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
