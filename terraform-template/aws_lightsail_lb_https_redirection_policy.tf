#---------------------------------------------------------------
# AWS Lightsail Load Balancer HTTPS Redirection Policy
#---------------------------------------------------------------
#
# Amazon Lightsail ロードバランサーのHTTPからHTTPSへの自動リダイレクト
# ポリシーを管理するリソースです。
# このリソースを使用することで、ロードバランサーへのHTTPトラフィックを
# 自動的にHTTPSにリダイレクトするよう設定できます。
# HTTPS リダイレクトを有効にする前に、有効な証明書をロードバランサーに
# アタッチしておく必要があります。
#
# AWS公式ドキュメント:
#   - Lightsail ロードバランサーのHTTPSリダイレクト設定: https://docs.aws.amazon.com/lightsail/latest/userguide/amazon-lightsail-configure-load-balancer-https-redirection.html
#   - Lightsail ロードバランサーの概要: https://docs.aws.amazon.com/lightsail/latest/userguide/understanding-lightsail-load-balancers.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lightsail_lb_https_redirection_policy
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_lightsail_lb_https_redirection_policy" "example" {
  #-------------------------------------------------------------
  # ロードバランサー設定
  #-------------------------------------------------------------

  # lb_name (Required)
  # 設定内容: HTTPからHTTPSへのリダイレクトを設定するロードバランサーの名前を指定します。
  # 設定可能な値: 既存のLightsailロードバランサーの名前文字列
  # 注意: リダイレクトを有効にする前に、有効なSSL/TLS証明書がロードバランサーに
  #       アタッチされている必要があります。
  lb_name = "example-load-balancer"

  #-------------------------------------------------------------
  # リダイレクト有効化設定
  #-------------------------------------------------------------

  # enabled (Required)
  # 設定内容: HTTPからHTTPSへのリダイレクトを有効にするかどうかを指定します。
  # 設定可能な値:
  #   - true: HTTPトラフィックをHTTPSへ自動リダイレクトします
  #   - false: HTTPからHTTPSへのリダイレクトを無効化します
  # 関連機能: Lightsail ロードバランサー HTTPSリダイレクト
  #   ロードバランサーへのHTTPリクエストを自動的にHTTPSにリダイレクトする機能。
  #   有効化には事前にSSL/TLS証明書のアタッチが必要です。
  #   - https://docs.aws.amazon.com/lightsail/latest/userguide/amazon-lightsail-configure-load-balancer-https-redirection.html
  enabled = true

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
# - id: ロードバランサーの名前（lb_name と同じ値）
#---------------------------------------------------------------
