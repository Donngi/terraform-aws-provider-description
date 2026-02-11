#---------------------------------------------------------------
# AWS ALB Listener Certificate
#---------------------------------------------------------------
#
# Application Load Balancer (ALB) リスナーに追加のSSL/TLS証明書を
# アタッチするためのリソースです。
#
# このリソースは追加証明書用であり、リスナーのデフォルト証明書を
# 置き換えるものではありません。SNI (Server Name Indication) を使用して、
# 単一のリスナーで複数のドメインに対応する場合に使用します。
#
# 注意: aws_alb_listener_certificate は aws_lb_listener_certificate の
# エイリアスです。機能は同一です。
#
# AWS公式ドキュメント:
#   - HTTPS リスナーの作成: https://docs.aws.amazon.com/elasticloadbalancing/latest/application/create-https-listener.html
#   - リスナー証明書の更新: https://docs.aws.amazon.com/elasticloadbalancing/latest/application/listener-update-certificates.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener_certificate
#
# Provider Version: 6.28.0
# Generated: 2026-01-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_alb_listener_certificate" "example" {
  #-------------------------------------------------------------
  # 必須設定
  #-------------------------------------------------------------

  # listener_arn (Required, Forces new resource)
  # 設定内容: 証明書をアタッチするリスナーのARNを指定します。
  # 設定可能な値: 有効なALBリスナーのARN
  # 注意: HTTPSまたはTLSプロトコルを使用するリスナーである必要があります。
  listener_arn = "arn:aws:elasticloadbalancing:ap-northeast-1:123456789012:listener/app/my-alb/50dc6c495c0c9188/a1b2c3d4e5f67890"

  # certificate_arn (Required, Forces new resource)
  # 設定内容: リスナーにアタッチする証明書のARNを指定します。
  # 設定可能な値: ACM (AWS Certificate Manager) またはIAMの有効な証明書ARN
  # 関連機能: SNI (Server Name Indication)
  #   単一のリスナーで複数のドメインをホストする場合、SNIを使用して
  #   クライアントのリクエストに応じた適切な証明書を返すことができます。
  #   - https://docs.aws.amazon.com/elasticloadbalancing/latest/application/create-https-listener.html
  certificate_arn = "arn:aws:acm:ap-northeast-1:123456789012:certificate/12345678-1234-1234-1234-123456789012"

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
# - id: listener_arn と certificate_arn を `_` で連結した値
#---------------------------------------------------------------
