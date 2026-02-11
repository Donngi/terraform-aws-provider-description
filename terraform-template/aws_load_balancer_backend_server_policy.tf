#---------------------------------------------------------------
# ELB Backend Server Policy
#---------------------------------------------------------------
#
# Classic Load BalancerのバックエンドEC2インスタンスにポリシーを適用する
# リソース。主にバックエンドサーバー認証ポリシーを適用する際に使用します。
#
# バックエンドサーバー認証を有効にすることで、ロードバランサーと
# インスタンス間の通信が暗号化され、かつ各インスタンスが正しい
# 公開鍵を持っていることを保証できます。
#
# AWS公式ドキュメント:
#   - Listeners for Classic Load Balancer: https://docs.aws.amazon.com/elasticloadbalancing/latest/classic/elb-listener-config.html
#   - SDK Code Examples: https://docs.aws.amazon.com/code-library/latest/ug/elastic-load-balancing_example_elastic-load-balancing_CreateLoadBalancerPolicy_section.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/load_balancer_backend_server_policy
#
# Provider Version: 6.28.0
# Generated: 2026-01-28
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_load_balancer_backend_server_policy" "example" {
  #---------------------------------------------------------------
  # Required Parameters
  #---------------------------------------------------------------

  # (Required) ロードバランサーの名前
  # ポリシーを適用するClassic Load Balancerの名前を指定します。
  # 他のリソースから参照する場合は aws_elb.example.name のように記述します。
  load_balancer_name = "example-lb"

  # (Required) インスタンスポート番号
  # ポリシーを適用するバックエンドインスタンスのポート番号を指定します。
  # 通常はHTTPS通信を行うポート（443など）を指定します。
  # 例: 443（HTTPS）、8443（カスタムHTTPS）
  instance_port = 443

  #---------------------------------------------------------------
  # Optional Parameters
  #---------------------------------------------------------------

  # (Optional) ポリシー名のリスト
  # バックエンドサーバーに適用するポリシー名のリストを指定します。
  # 主にBackendServerAuthenticationPolicyTypeタイプのポリシーを指定します。
  # aws_load_balancer_policy リソースで定義したポリシー名を参照します。
  #
  # 典型的な使用例:
  # - バックエンド認証ポリシーの適用
  # - 公開鍵ベースの認証設定
  #
  # 例:
  # policy_names = [
  #   aws_load_balancer_policy.backend_auth_policy.policy_name,
  # ]
  policy_names = []

  # (Optional) リージョン
  # このリソースを管理するAWSリージョンを指定します。
  # 指定しない場合は、プロバイダー設定で指定されたリージョンが使用されます。
  #
  # 参考:
  # - Regional Endpoints: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # - Provider Configuration: https://registry.terraform.io/providers/hashicorp/aws/latest/docs#aws-configuration-reference
  #
  # 例: region = "us-east-1"
  # region = null

  # (Optional) ID
  # Terraformによって自動生成されるリソースのID。
  # 通常は指定する必要はありませんが、インポート時などに使用できます。
  # id = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用)
#---------------------------------------------------------------
#
# このリソースでは以下の属性を参照可能です:
#
# - id: ポリシーのID（computed）
# - load_balancer_name: ポリシーが定義されているロードバランサー名（computed）
# - instance_port: ポリシーが適用されているバックエンドポート（computed）
#
# 参照例:
# output "policy_id" {
#   value = aws_load_balancer_backend_server_policy.example.id
# }
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# Example: Complete Backend Authentication Setup
#---------------------------------------------------------------
#
# バックエンドサーバー認証を有効にする完全な設定例:
#
# # Classic Load Balancer
# resource "aws_elb" "example" {
#   name               = "example-elb"
#   availability_zones = ["us-east-1a", "us-east-1b"]
#
#   listener {
#     instance_port      = 443
#     instance_protocol  = "https"
#     lb_port            = 443
#     lb_protocol        = "https"
#     ssl_certificate_id = "arn:aws:iam::123456789012:server-certificate/example-cert"
#   }
# }
#
# # 公開鍵ポリシー（CA証明書の公開鍵）
# resource "aws_load_balancer_policy" "pubkey_policy" {
#   load_balancer_name = aws_elb.example.name
#   policy_name        = "example-pubkey-policy"
#   policy_type_name   = "PublicKeyPolicyType"
#
#   # CA証明書から公開鍵を抽出:
#   # cat ca-cert.pem | openssl x509 -pubkey -noout | grep -v '\-\-\-\-' | tr -d '\n' > pubkey
#   policy_attribute {
#     name  = "PublicKey"
#     value = file("pubkey")
#   }
# }
#
# # バックエンド認証ポリシー
# resource "aws_load_balancer_policy" "backend_auth_policy" {
#   load_balancer_name = aws_elb.example.name
#   policy_name        = "example-backend-auth-policy"
#   policy_type_name   = "BackendServerAuthenticationPolicyType"
#
#   policy_attribute {
#     name  = "PublicKeyPolicyName"
#     value = aws_load_balancer_policy.pubkey_policy.policy_name
#   }
# }
#
# # バックエンドサーバーポリシーの適用
# resource "aws_load_balancer_backend_server_policy" "example" {
#   load_balancer_name = aws_elb.example.name
#   instance_port      = 443
#
#   policy_names = [
#     aws_load_balancer_policy.backend_auth_policy.policy_name,
#   ]
# }
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# Important Notes
#---------------------------------------------------------------
#
# 1. Classic Load Balancer専用
#    - このリソースはClassic Load Balancer (ELB) 専用です
#    - Application Load Balancer (ALB) やNetwork Load Balancer (NLB) では使用できません
#
# 2. HTTPS/SSLバックエンド接続
#    - バックエンド認証はHTTPSまたはSSLプロトコルを使用するバックエンド接続で
#      のみ有効です
#    - リスナー設定で instance_protocol を "https" または "ssl" にする必要があります
#
# 3. 証明書の準備
#    - バックエンド認証には、インスタンス側に適切なSSL証明書が必要です
#    - CA証明書の公開鍵をPublicKeyPolicyTypeポリシーで登録する必要があります
#
# 4. ポリシーの事前作成
#    - このリソースを使用する前に、aws_load_balancer_policyリソースで
#      適用するポリシーを作成しておく必要があります
#
# 5. セキュリティ要件
#    - PCI DSS、SOXなどのコンプライアンス基準を満たす場合に有効です
#    - 全てのネットワーク通信を暗号化し、特定の暗号スイートのみを許可できます
#
#---------------------------------------------------------------
