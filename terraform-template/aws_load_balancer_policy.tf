#---------------------------------------------------------------
# AWS Load Balancer Policy
#---------------------------------------------------------------
#
# Elastic Load Balancing のロードバランサーポリシーを管理するリソースです。
# ポリシーは ELB リスナーやバックエンドサーバーにアタッチでき、
# SSL/TLS ネゴシエーション、バックエンドサーバー認証、公開鍵などの設定を制御します。
#
# NOTE: このリソースは Classic Load Balancer (ELB) 専用です。
#       Application Load Balancer (ALB) や Network Load Balancer (NLB) では使用しません。
#
# 主なポリシータイプ:
#   - SSLNegotiationPolicyType: SSL/TLS プロトコルと暗号スイートの設定
#   - BackendServerAuthenticationPolicyType: バックエンドサーバーの認証設定
#   - PublicKeyPolicyType: バックエンドサーバー認証用の公開鍵設定
#
# AWS公式ドキュメント:
#   - ELB ポリシー概要: https://docs.aws.amazon.com/elasticloadbalancing/latest/classic/elb-security-policy-table.html
#   - SSL/TLS ポリシー: https://docs.aws.amazon.com/elasticloadbalancing/latest/classic/elb-ssl-security-policy.html
#   - バックエンド認証: https://docs.aws.amazon.com/elasticloadbalancing/latest/classic/elb-backend-security.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/load_balancer_policy
#
# Provider Version: 6.28.0
# Generated: 2026-02-04
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_load_balancer_policy" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # load_balancer_name (Required)
  # 設定内容: ポリシーを定義するロードバランサーの名前を指定します。
  # 設定可能な値: Classic Load Balancer の名前
  # 注意: このリソースは Classic Load Balancer 専用です。
  load_balancer_name = aws_elb.example.name

  # policy_name (Required)
  # 設定内容: ロードバランサーポリシーの名前を指定します。
  # 設定可能な値: 英数字とハイフンを含む文字列
  # 注意: 同じロードバランサー内で一意である必要があります。
  policy_name = "my-ssl-policy"

  # policy_type_name (Required)
  # 設定内容: ポリシーのタイプを指定します。
  # 設定可能な値:
  #   - "SSLNegotiationPolicyType": SSL/TLS ネゴシエーションポリシー
  #       TLS プロトコルバージョンと暗号スイートを制御します。
  #   - "BackendServerAuthenticationPolicyType": バックエンドサーバー認証ポリシー
  #       HTTPS/SSL バックエンド接続でのサーバー証明書検証を設定します。
  #   - "PublicKeyPolicyType": 公開鍵ポリシー
  #       バックエンドサーバー認証用の公開鍵を定義します。
  #   - "ProxyProtocolPolicyType": Proxy Protocol ポリシー
  #       TCP/SSL リスナーでクライアント接続情報を保持します。
  #   - "AppCookieStickinessPolicyType": アプリケーション Cookie スティッキネスポリシー
  #       アプリケーション生成の Cookie でセッション維持します。
  #   - "LBCookieStickinessPolicyType": ロードバランサー Cookie スティッキネスポリシー
  #       ロードバランサー生成の Cookie でセッション維持します。
  policy_type_name = "SSLNegotiationPolicyType"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効な AWS リージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # ポリシー属性設定
  #-------------------------------------------------------------

  # policy_attribute (Optional)
  # 設定内容: ポリシーに適用する属性を指定します。
  # 注意: 属性はポリシータイプによって異なります。
  #
  # SSLNegotiationPolicyType の場合:
  #   - Protocol-SSLv2, Protocol-SSLv3, Protocol-TLSv1, Protocol-TLSv1.1, Protocol-TLSv1.2
  #   - 各種暗号スイート (ECDHE-ECDSA-AES128-GCM-SHA256, AES128-SHA など)
  #   - Reference-Security-Policy: AWS 事前定義ポリシー
  #     (例: ELBSecurityPolicy-TLS-1-2-2017-01, ELBSecurityPolicy-2016-08)
  #
  # BackendServerAuthenticationPolicyType の場合:
  #   - PublicKeyPolicyName: 公開鍵ポリシーの名前
  #
  # PublicKeyPolicyType の場合:
  #   - PublicKey: PEM 形式の公開鍵 (改行なし)
  #
  # 参考: https://docs.aws.amazon.com/elasticloadbalancing/latest/classic/elb-security-policy-table.html

  # 例1: TLS 1.2 プロトコルの有効化
  policy_attribute {
    name  = "Protocol-TLSv1.2"
    value = "true"
  }

  # 例2: 特定の暗号スイートの有効化
  policy_attribute {
    name  = "ECDHE-ECDSA-AES128-GCM-SHA256"
    value = "true"
  }

  # 例3: AWS 事前定義セキュリティポリシーの参照
  # Note: Reference-Security-Policy を使用する場合、他の個別設定は不要です
  # policy_attribute {
  #   name  = "Reference-Security-Policy"
  #   value = "ELBSecurityPolicy-TLS-1-2-2017-01"
  # }

  # 例4: バックエンドサーバー認証ポリシーの場合
  # policy_attribute {
  #   name  = "PublicKeyPolicyName"
  #   value = aws_load_balancer_policy.public_key_policy.policy_name
  # }

  # 例5: 公開鍵ポリシーの場合
  # 公開鍵は以下のコマンドで CA 証明書から抽出できます:
  # $ cat ca-cert.pem | openssl x509 -pubkey -noout | grep -v '----' | tr -d '\n'
  # policy_attribute {
  #   name  = "PublicKey"
  #   value = file("public-key-file")
  # }
}

#---------------------------------------------------------------

# 例: TLS 1.1 以降のみを許可する SSL ポリシー
resource "aws_load_balancer_policy" "tls_11_plus" {
  load_balancer_name = aws_elb.example.name
  policy_name        = "tls-1-1-plus-policy"
  policy_type_name   = "SSLNegotiationPolicyType"

  # AWS 事前定義ポリシーを使用
  policy_attribute {
    name  = "Reference-Security-Policy"
    value = "ELBSecurityPolicy-TLS-1-1-2017-01"
  }
}

#---------------------------------------------------------------

# ステップ1: 公開鍵ポリシーの作成
resource "aws_load_balancer_policy" "backend_public_key" {
  load_balancer_name = aws_elb.example.name
  policy_name        = "backend-ca-public-key-policy"
  policy_type_name   = "PublicKeyPolicyType"

  # CA 証明書の公開鍵を設定
  policy_attribute {
    name  = "PublicKey"
    value = file("backend-ca-pubkey")
  }
}

# ステップ2: バックエンドサーバー認証ポリシーの作成
resource "aws_load_balancer_policy" "backend_auth" {
  load_balancer_name = aws_elb.example.name
  policy_name        = "backend-server-auth-policy"
  policy_type_name   = "BackendServerAuthenticationPolicyType"

  # 公開鍵ポリシーを参照
  policy_attribute {
    name  = "PublicKeyPolicyName"
    value = aws_load_balancer_policy.backend_public_key.policy_name
  }
}

# ステップ3: ポリシーをバックエンドサーバーにアタッチ
resource "aws_load_balancer_backend_server_policy" "backend_policies" {
  load_balancer_name = aws_elb.example.name
  instance_port      = 443

  policy_names = [
    aws_load_balancer_policy.backend_auth.policy_name,
  ]
}

#---------------------------------------------------------------

# 例: 特定のプロトコルと暗号スイートのみを許可
resource "aws_load_balancer_policy" "custom_ssl" {
  load_balancer_name = aws_elb.example.name
  policy_name        = "custom-ssl-policy"
  policy_type_name   = "SSLNegotiationPolicyType"

  # TLS 1.2 のみを有効化
  policy_attribute {
    name  = "Protocol-TLSv1.2"
    value = "true"
  }

  # 推奨される暗号スイートを有効化
  policy_attribute {
    name  = "ECDHE-ECDSA-AES128-GCM-SHA256"
    value = "true"
  }

  policy_attribute {
    name  = "ECDHE-RSA-AES128-GCM-SHA256"
    value = "true"
  }

  policy_attribute {
    name  = "ECDHE-ECDSA-AES256-GCM-SHA384"
    value = "true"
  }

  policy_attribute {
    name  = "ECDHE-RSA-AES256-GCM-SHA384"
    value = "true"
  }
}

# ポリシーをリスナーにアタッチ
resource "aws_load_balancer_listener_policy" "ssl_listener" {
  load_balancer_name = aws_elb.example.name
  load_balancer_port = 443

  policy_names = [
    aws_load_balancer_policy.custom_ssl.policy_name,
  ]
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: ポリシーの ID (形式: "{load_balancer_name}:{policy_name}")
#
# - policy_name: スティッキネスポリシーの名前
#
# - policy_type_name: ポリシーのポリシータイプ
#
# - load_balancer_name: ポリシーが定義されているロードバランサー名
#---------------------------------------------------------------

#---------------------------------------------------------------
# 補足情報
#---------------------------------------------------------------
#
# ポリシーのアタッチ方法:
#
# 1. リスナーへのアタッチ:
#    aws_load_balancer_listener_policy リソースを使用して、
#    特定のリスナーポートにポリシーをアタッチします。
#    主に SSL/TLS ネゴシエーションポリシーで使用します。
#
# 2. バックエンドサーバーへのアタッチ:
#    aws_load_balancer_backend_server_policy リソースを使用して、
#    特定のインスタンスポートにポリシーをアタッチします。
#    主にバックエンドサーバー認証ポリシーで使用します。
#
# AWS 事前定義 SSL セキュリティポリシー一覧:
#   - ELBSecurityPolicy-2016-08: TLS 1.0 以降をサポート
#   - ELBSecurityPolicy-TLS-1-1-2017-01: TLS 1.1 以降をサポート
#   - ELBSecurityPolicy-TLS-1-2-2017-01: TLS 1.2 のみをサポート
#   - ELBSecurityPolicy-TLS-1-2-Ext-2018-06: TLS 1.2 の拡張版
#   - ELBSecurityPolicy-FS-2018-06: Forward Secrecy 暗号スイートのみ
#   - ELBSecurityPolicy-2015-05: レガシー (非推奨)
#
