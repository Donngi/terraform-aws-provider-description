#---------------------------------------------------------------
# Load Balancer SSL Negotiation Policy
#---------------------------------------------------------------
#
# Classic Load Balancer（ELB）のSSL/TLSネゴシエーションポリシーを定義します。
# このリソースは、クライアントとロードバランサー間のSSL接続時に使用される
# 暗号化アルゴリズム（SSL ciphers）とプロトコル（TLS 1.0/1.1/1.2等）を
# 制御するためのカスタムセキュリティポリシーを作成します。
#
# 用途:
#   - PCI DSS、SOC等のコンプライアンス要件に準拠したSSL設定の実装
#   - 脆弱な暗号化方式の無効化とセキュアなプロトコルの強制
#   - Server Order Preferenceによるサーバー側での暗号スイート選択制御
#
# 注意事項:
#   - このリソースはClassic Load Balancer（aws_elb）専用です
#   - Application/Network Load Balancerではaws_lb_listenerのssl_policyを使用してください
#   - AWS Certificate Manager(ACM)の証明書を使用する場合は、RSA暗号スイートを含める必要があります
#
# AWS公式ドキュメント:
#   - SSL negotiation configurations for Classic Load Balancers:
#     https://docs.aws.amazon.com/elasticloadbalancing/latest/classic/elb-ssl-security-policy.html
#   - HTTPS listeners for your Classic Load Balancer:
#     https://docs.aws.amazon.com/elasticloadbalancing/latest/classic/elb-https-load-balancers.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_ssl_negotiation_policy
#
# Provider Version: 6.28.0
# Generated: 2026-01-28
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_lb_ssl_negotiation_policy" "example" {
  #---------------------------------------------------------------
  # 必須パラメータ
  #---------------------------------------------------------------

  # ポリシーの名前
  # - SSL negotiation policyの識別子として使用されます
  # - 同一ロードバランサー内で一意である必要があります
  name = "custom-ssl-policy"

  # ポリシーを適用するロードバランサーの名前またはARN
  # - aws_elb.example.id または aws_elb.example.name を指定します
  # - Classic Load Balancer（ELB）のリソースIDを参照します
  load_balancer = aws_elb.example.id

  # ポリシーを適用するロードバランサーのポート番号
  # - 443 等、SSLリスナーが設定されているポートを指定します
  # - aws_elbのlistenerブロックで定義されたlb_portと一致する必要があります
  # - このポートにアクティブなHTTPS/SSLリスナーが存在する必要があります
  lb_port = 443

  #---------------------------------------------------------------
  # オプションパラメータ
  #---------------------------------------------------------------

  # リソースのID（通常は自動生成されるため指定不要）
  # - Terraform内部での識別子として使用されます
  # - 明示的に指定することも可能ですが、通常は自動計算値を使用します
  # id = null

  # リージョン設定
  # - このリソースが管理されるAWSリージョンを指定します
  # - 省略時はプロバイダー設定のリージョンが使用されます
  # - マルチリージョン構成で明示的に指定する場合に使用します
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-east-1"

  # 再デプロイトリガー（Map of strings）
  # - このマップの値が変更されると、ポリシーの再デプロイが強制的に実行されます
  # - terraform taintコマンドを使用せずに再デプロイを実行したい場合に使用します
  # - 任意のキーと値のペアを設定可能です
  # 例:
  # triggers = {
  #   redeployment = "force-update-20260128"
  #   version      = "1.0"
  # }
  # triggers = null

  #---------------------------------------------------------------
  # SSL/TLS属性設定（attributeブロック）
  #---------------------------------------------------------------
  # SSL negotiation policyの個別属性を定義します。
  # 各attributeブロックは特定のSSLプロトコル、暗号化方式、オプションの
  # 有効/無効を制御します。
  #
  # 設定可能な属性の種類:
  #   1. プロトコル: Protocol-TLSv1, Protocol-TLSv1.1, Protocol-TLSv1.2
  #   2. 暗号化方式: ECDHE-RSA-AES128-GCM-SHA256, AES128-GCM-SHA256 等
  #   3. オプション: Server-Defined-Cipher-Order（Server Order Preference）
  #
  # 詳細な属性リストは以下を参照:
  # https://docs.aws.amazon.com/elasticloadbalancing/latest/classic/elb-ssl-security-policy.html
  #
  # セキュリティ推奨事項:
  #   - TLS 1.2以上のみを有効化（TLS 1.0/1.1は非推奨）
  #   - ECDHE系の暗号化方式を優先（Forward Secrecyをサポート）
  #   - RC4, DES等の脆弱な暗号化方式は無効化
  #   - Server-Defined-Cipher-Orderを有効化してサーバー側で暗号スイート選択

  # TLS 1.0プロトコルを無効化（セキュリティのため推奨）
  attribute {
    name  = "Protocol-TLSv1"
    value = "false"
  }

  # TLS 1.1プロトコルを無効化（セキュリティのため推奨）
  attribute {
    name  = "Protocol-TLSv1.1"
    value = "false"
  }

  # TLS 1.2プロトコルを有効化（推奨）
  attribute {
    name  = "Protocol-TLSv1.2"
    value = "true"
  }

  # Server Order Preference（サーバー定義暗号順序）を有効化
  # - trueの場合、ロードバランサー側の暗号スイート順序が優先されます
  # - クライアント側ではなくサーバー側で安全な暗号スイートを選択可能
  attribute {
    name  = "Server-Defined-Cipher-Order"
    value = "true"
  }

  # 推奨される暗号化方式の例（必要に応じて追加）
  # ECDHE-RSA-AES128-GCM-SHA256（TLS 1.2、Forward Secrecy対応）
  attribute {
    name  = "ECDHE-RSA-AES128-GCM-SHA256"
    value = "true"
  }

  # AES128-GCM-SHA256（TLS 1.2対応）
  attribute {
    name  = "AES128-GCM-SHA256"
    value = "true"
  }

  # 脆弱な暗号化方式の無効化例
  # EDH-RSA-DES-CBC3-SHA（3DES、脆弱性あり）
  attribute {
    name  = "EDH-RSA-DES-CBC3-SHA"
    value = "false"
  }

  # 追加の暗号化方式設定例（コメントアウト状態）
  # ECDHE-ECDSA-AES128-GCM-SHA256
  # attribute {
  #   name  = "ECDHE-ECDSA-AES128-GCM-SHA256"
  #   value = "true"
  # }

  # ECDHE-RSA-AES256-GCM-SHA384
  # attribute {
  #   name  = "ECDHE-RSA-AES256-GCM-SHA384"
  #   value = "true"
  # }

  # AES256-GCM-SHA384
  # attribute {
  #   name  = "AES256-GCM-SHA384"
  #   value = "true"
  # }
}

#---------------------------------------------------------------
# Attributes Reference（Read-only属性）
#---------------------------------------------------------------
# 以下の属性はリソース作成後に参照可能です（computed属性）:
#
# - id
#     ポリシーのID（自動生成）
#     例: output "policy_id" { value = aws_lb_ssl_negotiation_policy.example.id }
#
# - name
#     ポリシーの名前（入力値と同じ）
#
# - load_balancer
#     ポリシーが適用されているロードバランサーの名前（入力値と同じ）
#
# - lb_port
#     ポリシーが適用されているポート番号（入力値と同じ）
#
# - attribute
#     設定されたSSL negotiation属性のリスト
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# 使用例: Classic Load BalancerとSSL Negotiation Policyの連携
#---------------------------------------------------------------
# resource "aws_elb" "example" {
#   name               = "example-elb"
#   availability_zones = ["us-east-1a", "us-east-1b"]
#
#   listener {
#     instance_port      = 8000
#     instance_protocol  = "https"
#     lb_port            = 443
#     lb_protocol        = "https"
#     ssl_certificate_id = "arn:aws:iam::123456789012:server-certificate/certName"
#   }
#
#   health_check {
#     healthy_threshold   = 2
#     unhealthy_threshold = 2
#     timeout             = 3
#     target              = "HTTPS:8000/"
#     interval            = 30
#   }
#
#   tags = {
#     Name = "example-elb"
#   }
# }
#
# resource "aws_lb_ssl_negotiation_policy" "example" {
#   name          = "example-ssl-policy"
#   load_balancer = aws_elb.example.id
#   lb_port       = 443
#
#   attribute {
#     name  = "Protocol-TLSv1.2"
#     value = "true"
#   }
#
#   attribute {
#     name  = "Server-Defined-Cipher-Order"
#     value = "true"
#   }
# }
#---------------------------------------------------------------
