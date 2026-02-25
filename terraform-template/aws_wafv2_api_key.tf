#---------------------------------------------------------------
# AWS WAFv2 API Key
#---------------------------------------------------------------
#
# AWS WAFv2のAPIキーをプロビジョニングするリソースです。
# APIキーはJavaScriptアプリケーションでのCAPTCHA APIインテグレーションに使用します。
# 指定したトークンドメインに対して暗号化されたAPIキーが生成され、
# JavaScriptのCAPTCHAパズルの配置や特性をカスタマイズする際に利用できます。
#
# AWS公式ドキュメント:
#   - WAFv2 APIキー作成: https://docs.aws.amazon.com/waf/latest/APIReference/API_CreateAPIKey.html
#   - トークンドメインの設定: https://docs.aws.amazon.com/waf/latest/developerguide/waf-tokens-domains.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_api_key
#
# Provider Version: 6.28.0
# Generated: 2026-02-22
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
  # 設定内容: APIキーを適用する対象リソースの種別を指定します。
  # 設定可能な値:
  #   - "CLOUDFRONT": Amazon CloudFrontディストリビューション向け
  #   - "REGIONAL": リージョナルアプリケーション（ALB、API Gatewayなど）向け
  # 注意: "CLOUDFRONT"を指定する場合はリージョンをus-east-1に設定する必要があります。
  # 参考: https://docs.aws.amazon.com/waf/latest/APIReference/API_CreateAPIKey.html
  scope = "REGIONAL"

  #-------------------------------------------------------------
  # トークンドメイン設定
  #-------------------------------------------------------------

  # token_domains (Required)
  # 設定内容: APIキーを使用するドメインの一覧を指定します。
  # 設定可能な値: ドメイン名の文字列セット（例: "example.com"）
  #   - 最大5ドメインまで指定可能
  #   - パブリックサフィックスのみのドメインは指定不可
  #   - 各ドメインは1〜253文字で一致する必要があります
  # 参考: https://docs.aws.amazon.com/waf/latest/developerguide/waf-tokens-domains.html
  token_domains = ["example.com"]

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用します。
  # 注意: scope が "CLOUDFRONT" の場合は us-east-1 を指定する必要があります。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - api_key: 生成された暗号化済みAPIキーの値。センシティブな値のためAPIレスポンスには含まれません。
#            JavaScriptのCAPTCHA APIインテグレーションで使用します。
#---------------------------------------------------------------
