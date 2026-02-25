#---------------------------------------------------------------
# AWS LB Listener Certificate
#---------------------------------------------------------------
#
# Application Load Balancer（ALB）のHTTPSリスナーに追加の証明書を関連付ける
# リソースです。リスナーのデフォルト証明書を置き換えるものではなく、
# Server Name Indication（SNI）を使用した複数ドメイン対応のために
# 追加証明書をアタッチする際に使用します。
#
# AWS公式ドキュメント:
#   - ALBリスナー証明書の概要: https://docs.aws.amazon.com/elasticloadbalancing/latest/application/create-https-listener.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener_certificate
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_lb_listener_certificate" "example" {
  #-------------------------------------------------------------
  # リスナー設定
  #-------------------------------------------------------------

  # listener_arn (Required, Forces new resource)
  # 設定内容: 証明書をアタッチするALBリスナーのARNを指定します。
  # 設定可能な値: 有効なALBリスナーのARN
  # 注意: HTTPSまたはTLSリスナーのARNを指定してください。
  #       リスナーを再作成する場合は、このリソースも再作成されます。
  listener_arn = "arn:aws:elasticloadbalancing:ap-northeast-1:123456789012:listener/app/my-alb/1234567890abcdef/1234567890abcdef"

  #-------------------------------------------------------------
  # 証明書設定
  #-------------------------------------------------------------

  # certificate_arn (Required, Forces new resource)
  # 設定内容: リスナーにアタッチするACM証明書またはIAMサーバー証明書のARNを指定します。
  # 設定可能な値: 有効なACM証明書またはIAMサーバー証明書のARN
  # 注意: 証明書を変更する場合は、このリソースが再作成されます。
  #       リスナーのデフォルト証明書の変更にはaws_lb_listenerリソースを使用してください。
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
# - id: listener_arn と certificate_arn を「_」で結合した文字列
#---------------------------------------------------------------
