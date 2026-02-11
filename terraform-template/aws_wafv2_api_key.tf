#---------------------------------------------------------------
# AWS WAFv2 API Key
#---------------------------------------------------------------
#
# AWS WAF CAPTCHA JavaScript API統合用のAPIキーをプロビジョニングするリソースです。
# APIキーは、クライアントアプリケーションドメインがAWS WAF CAPTCHA APIを使用する
# 権限を持っていることを検証するために使用されます。
#
# AWS公式ドキュメント:
#   - Managing API keys for the JS CAPTCHA API: https://docs.aws.amazon.com/waf/latest/developerguide/waf-js-captcha-api-key.html
#   - CreateAPIKey API: https://docs.aws.amazon.com/waf/latest/APIReference/API_CreateAPIKey.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_api_key
#
# Provider Version: 6.28.0
# Generated: 2026-02-06
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_wafv2_api_key" "example" {
  #-------------------------------------------------------------
  # スコープ設定
  #-------------------------------------------------------------

  # scope (Required)
  # 設定内容: このAPIキーがAmazon CloudFrontディストリビューション用か、
  #          リージョナルアプリケーション用かを指定します。
  # 設定可能な値:
  #   - "CLOUDFRONT": Amazon CloudFrontディストリビューション用。
  #                   グローバルに使用可能で、クライアントは最も近いリージョンから
  #                   CAPTCHAパズルをロードでき、レイテンシを削減できます。
  #                   CloudFrontを使用する場合、リージョンはus-east-1を指定する必要があります。
  #   - "REGIONAL": リージョナルアプリケーション用（ALB、API Gateway等）。
  #                 指定したリージョンでのみ使用可能です。
  # 関連機能: AWS WAF CAPTCHA JavaScript API統合
  #   CAPTCHAの配置や特性をカスタマイズするためにAPIキーが必要です。
  #   - https://docs.aws.amazon.com/waf/latest/developerguide/waf-js-captcha-api-key.html
  scope = "REGIONAL"

  #-------------------------------------------------------------
  # トークンドメイン設定
  #-------------------------------------------------------------

  # token_domains (Required)
  # 設定内容: APIキーを使用できるクライアントアプリケーションドメインを指定します。
  # 設定可能な値: 有効なドメイン名のセット。最大5ドメインまで指定可能。
  #              パブリックサフィックス（.com, .co.jp等）は使用できません。
  # 関連機能: AWS WAF CAPTCHA JavaScript API統合
  #   CAPTCHA APIをJavaScriptクライアントから呼び出す際に、
  #   現在のクライアントのドメインを含むAPIキーを提供する必要があります。
  #   APIキーには、トークンドメインリストのいずれかのドメインと完全一致するか、
  #   または頂点ドメイン（apex domain）と一致するドメインが含まれている必要があります。
  #   例: トークンドメインがmySubdomain.myApex.comの場合、
  #       mySubdomain.myApex.com（完全一致）またはmyApex.com（頂点ドメイン）が一致します。
  #   - https://docs.aws.amazon.com/waf/latest/developerguide/waf-js-captcha-api-key.html
  # 注意: 一度作成したAPIキーは変更できません。変更が必要な場合は新しいキーを生成してください。
  #       削除後、全リージョンでキーの使用が無効になるまで最大24時間かかります。
  token_domains = ["example.com"]

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 関連機能: AWS WAF リージョン選択
  #   CLOUDFRONTスコープのAPIキーはus-east-1で作成する必要があります。
  #   REGIONALスコープのAPIキーは作成したリージョンでのみ使用可能です。
  #   グローバルなオーディエンスが期待される場合、CLOUDFRONTスコープのAPIキーを使用すると、
  #   クライアントは最も近いリージョンからCAPTCHAパズルをロードでき、レイテンシを削減できます。
  #   - https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # 注意: scopeが"CLOUDFRONT"の場合、regionはus-east-1（N. Virginia）を指定する必要があります。
  region = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - api_key: 生成された暗号化APIキー。
#            この値はセンシティブであり、JavaScriptクライアントの
#            CAPTCHA統合で使用します。
#            Terraformのstateファイルにも保存されるため、
#            stateファイルの適切な管理が必要です。
#---------------------------------------------------------------
