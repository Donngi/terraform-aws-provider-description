#---------------------------------------------------------------
# AWS Elastic Load Balancer Listener Policy
#---------------------------------------------------------------
#
# Classic Load Balancer (ELB)のリスナーにポリシーをアタッチするリソースです。
# リスナーポリシーは、SSL/TLS暗号化設定やプロキシプロトコル設定などを
# リスナーレベルで制御するために使用されます。
#
# 主な用途:
#   - SSL/TLS暗号化ポリシーの適用
#   - TLSプロトコルバージョンの制御
#   - 暗号スイートの選択
#   - セキュリティポリシーの一元管理
#
# AWS公式ドキュメント:
#   - ELB SSL/TLSリスナー: https://docs.aws.amazon.com/elasticloadbalancing/latest/classic/elb-listener-config.html
#   - SSL暗号設定: https://docs.aws.amazon.com/elasticloadbalancing/latest/classic/ssl-config-update.html
#   - 定義済みSSLセキュリティポリシー: https://docs.aws.amazon.com/elasticloadbalancing/latest/classic/elb-security-policy-table.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/load_balancer_listener_policy
#
# Provider Version: 6.28.0
# Generated: 2026-01-31
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
# 重要な制限事項:
#   - このリソースはClassic Load Balancer (ELB)専用です
#   - Application Load Balancer (ALB)やNetwork Load Balancer (NLB)では使用できません
#   - Classic Load Balancerは新規作成ではなくApplication Load Balancerの使用が推奨されています
#
#---------------------------------------------------------------

resource "aws_load_balancer_listener_policy" "example" {
  #-------------------------------------------------------------
  # 必須パラメータ
  #-------------------------------------------------------------

  # load_balancer_name (Required)
  # 設定内容: ポリシーをアタッチするClassic Load Balancerの名前を指定します。
  # 設定可能な値: 有効なELB名（1〜32文字の英数字とハイフン）
  # 注意: aws_elbリソースで作成したロードバランサーの名前を指定します
  # 関連リソース: aws_elb
  load_balancer_name = "example-elb"

  # load_balancer_port (Required)
  # 設定内容: ポリシーを適用するリスナーのポート番号を指定します。
  # 設定可能な値: 1〜65535の整数
  # 一般的な値:
  #   - 443: HTTPS/SSL接続用（最も一般的）
  #   - 80: HTTP接続用（ポリシー適用は稀）
  #   - 8443: カスタムHTTPS接続用
  # 注意: このポートは、ELBリスナー設定で定義されているポートと一致する必要があります
  load_balancer_port = 443

  # policy_names (Required)
  # 設定内容: リスナーに適用するポリシー名のリストを指定します。
  # 設定可能な値: aws_load_balancer_policyリソースで定義されたポリシー名の配列
  # 注意:
  #   - 空のリスト []を指定すると、リスナーからすべてのポリシーが削除されます
  #   - 複数のポリシーを適用する場合、順序が重要になることがあります
  #   - ポリシータイプによっては、1つのリスナーに複数適用できないものもあります
  # ポリシータイプ例:
  #   - SSLNegotiationPolicyType: SSL/TLS暗号化設定
  #   - PublicKeyPolicyType: バックエンド認証用の公開鍵
  #   - BackendServerAuthenticationPolicyType: バックエンド認証ポリシー
  policy_names = [
    "example-ssl-policy",
  ]

  #-------------------------------------------------------------
  # オプションパラメータ
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "ap-northeast-1"

  # triggers (Optional)
  # 設定内容: 変更時にリソースの更新をトリガーするための任意のキーと値のマップです。
  # 設定可能な値: 任意の文字列キーと値のマップ
  # 使用例:
  #   - ポリシー内容の変更を強制的に反映させたい場合
  #   - 手動でリソースを再作成したい場合
  # 注意: terraform taintコマンドの代替手段として使用できます
  # triggers = {
  #   policy_version = "v1"
  #   last_updated   = "2026-01-31"
  # }
}

#---------------------------------------------------------------
# 使用例: SSL暗号化ポリシーの適用
#---------------------------------------------------------------
# この例では、Classic Load Balancerの443番ポート（HTTPS）に
# カスタムSSL暗号化ポリシーを適用します。

# # ステップ1: Classic Load Balancerを作成
# resource "aws_elb" "example" {
#   name               = "example-elb"
#   availability_zones = ["ap-northeast-1a", "ap-northeast-1c"]
#
#   # HTTPSリスナーを設定
#   listener {
#     instance_port      = 443
#     instance_protocol  = "http"
#     lb_port            = 443
#     lb_protocol        = "https"
#     ssl_certificate_id = "arn:aws:iam::123456789012:server-certificate/example-cert"
#   }
#
#   tags = {
#     Name = "example-elb"
#   }
# }
#
# # ステップ2: カスタムSSL暗号化ポリシーを定義
# resource "aws_load_balancer_policy" "example-ssl" {
#   load_balancer_name = aws_elb.example.name
#   policy_name        = "example-ssl-policy"
#   policy_type_name   = "SSLNegotiationPolicyType"
#
#   # TLS 1.2以上を強制
#   policy_attribute {
#     name  = "Protocol-TLSv1.2"
#     value = "true"
#   }
#
#   # 強力な暗号スイートのみを有効化
#   policy_attribute {
#     name  = "ECDHE-ECDSA-AES128-GCM-SHA256"
#     value = "true"
#   }
#
#   policy_attribute {
#     name  = "ECDHE-RSA-AES128-GCM-SHA256"
#     value = "true"
#   }
# }
#
# # ステップ3: リスナーにポリシーをアタッチ
# resource "aws_load_balancer_listener_policy" "example" {
#   load_balancer_name = aws_elb.example.name
#   load_balancer_port = 443
#
#   policy_names = [
#     aws_load_balancer_policy.example-ssl.policy_name,
#   ]
# }

#---------------------------------------------------------------
# 使用例: AWS定義済みセキュリティポリシーの適用
#---------------------------------------------------------------
# AWSが提供する定義済みセキュリティポリシーを使用する例です。
# カスタムポリシーを定義するよりも簡単で、AWSのベストプラクティスに準拠します。

# # Classic Load Balancerを作成
# resource "aws_elb" "production" {
#   name               = "production-elb"
#   availability_zones = ["ap-northeast-1a", "ap-northeast-1c"]
#
#   listener {
#     instance_port      = 443
#     instance_protocol  = "http"
#     lb_port            = 443
#     lb_protocol        = "https"
#     ssl_certificate_id = "arn:aws:iam::123456789012:server-certificate/production-cert"
#   }
#
#   tags = {
#     Name        = "production-elb"
#     Environment = "production"
#   }
# }
#
# # AWS定義済みセキュリティポリシー (ELBSecurityPolicy-TLS-1-2-2017-01) を使用
# resource "aws_load_balancer_policy" "production-ssl-tls-1-2" {
#   load_balancer_name = aws_elb.production.name
#   policy_name        = "production-ssl-policy"
#   policy_type_name   = "SSLNegotiationPolicyType"
#
#   # Reference-Security-Policyを使用してAWS定義済みポリシーを参照
#   policy_attribute {
#     name  = "Reference-Security-Policy"
#     value = "ELBSecurityPolicy-TLS-1-2-2017-01"
#   }
# }
#
# # リスナーにポリシーをアタッチ
# resource "aws_load_balancer_listener_policy" "production-https" {
#   load_balancer_name = aws_elb.production.name
#   load_balancer_port = 443
#
#   policy_names = [
#     aws_load_balancer_policy.production-ssl-tls-1-2.policy_name,
#   ]
# }

#---------------------------------------------------------------
# 利用可能なAWS定義済みSSLセキュリティポリシー
#---------------------------------------------------------------
# Reference-Security-Policyで指定可能なポリシー:
#
# - ELBSecurityPolicy-TLS-1-0-2015-04
#     TLS 1.0以上をサポート（古いクライアント互換性重視）
#
# - ELBSecurityPolicy-TLS-1-1-2017-01
#     TLS 1.1以上をサポート（中程度のセキュリティ）
#
# - ELBSecurityPolicy-TLS-1-2-2017-01 (推奨)
#     TLS 1.2以上をサポート（高セキュリティ）
#
# - ELBSecurityPolicy-TLS-1-2-Ext-2018-06
#     TLS 1.2以上、拡張暗号スイート対応（最高セキュリティ）
#
# - ELBSecurityPolicy-FS-1-2-2019-08
#     Forward Secrecy対応（PFS: Perfect Forward Secrecy）
#
# - ELBSecurityPolicy-FS-1-2-Res-2019-08
#     Forward Secrecy + 制限付き暗号スイート
#
# 詳細: https://docs.aws.amazon.com/elasticloadbalancing/latest/classic/elb-security-policy-table.html
#---------------------------------------------------------------

#---------------------------------------------------------------
# 使用例: ポリシーの削除（リスナーからすべてのポリシーを削除）
#---------------------------------------------------------------
# リスナーから明示的にすべてのポリシーを削除する場合は、
# policy_namesに空のリストを指定します。

# resource "aws_load_balancer_listener_policy" "remove-all-policies" {
#   load_balancer_name = aws_elb.example.name
#   load_balancer_port = 443
#
#   # 空のリストを指定してすべてのポリシーを削除
#   policy_names = []
# }

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: ポリシーのID
#     形式: "{load_balancer_name}:{load_balancer_port}"
#     例: "example-elb:443"
#     参照方法: aws_load_balancer_listener_policy.example.id
#
# - load_balancer_name: ポリシーが定義されているロードバランサーの名前
#     参照方法: aws_load_balancer_listener_policy.example.load_balancer_name
#
# - load_balancer_port: ポリシーが適用されているリスナーポート番号
#     参照方法: aws_load_balancer_listener_policy.example.load_balancer_port
#
# 使用例:
#   output "listener_policy_id" {
#     description = "リスナーポリシーID"
#     value       = aws_load_balancer_listener_policy.example.id
#   }
#
#   output "applied_port" {
#     description = "ポリシーが適用されているポート"
#     value       = aws_load_balancer_listener_policy.example.load_balancer_port
#   }
#---------------------------------------------------------------

#---------------------------------------------------------------
# Import (既存リソースのインポート)
#---------------------------------------------------------------
# 既存のリスナーポリシーをTerraform管理下にインポートする場合:
#
# terraform import aws_load_balancer_listener_policy.example example-elb:443
#
# 形式: {load_balancer_name}:{load_balancer_port}
#---------------------------------------------------------------

#---------------------------------------------------------------
# ベストプラクティスと推奨事項
#---------------------------------------------------------------
# 1. セキュリティポリシーの選択:
#    - 本番環境では TLS 1.2以上を強制することを推奨
#    - AWS定義済みポリシー（Reference-Security-Policy）の使用を推奨
#    - レガシークライアントサポートが必要な場合のみTLS 1.0/1.1を許可
#
# 2. ポリシーの管理:
#    - aws_load_balancer_policyリソースでポリシーを定義
#    - このリソースでリスナーにポリシーをアタッチ
#    - 複数のリスナーで同じポリシーを再利用可能
#
# 3. 移行の推奨:
#    - Classic Load Balancerは新規作成ではなくALB/NLBを推奨
#    - 既存のELBの場合は、この移行ガイドを参照:
#      https://docs.aws.amazon.com/elasticloadbalancing/latest/userguide/migrate-to-application-load-balancer.html
#
# 4. 監視とコンプライアンス:
#    - CloudWatch Metricsでリスナーのトラフィックを監視
#    - AWS Config Rulesでセキュリティポリシーのコンプライアンスを確認
#    - 定期的にセキュリティポリシーを見直し、最新の推奨事項に従う
#
# 5. トラブルシューティング:
#    - ポリシー適用後は接続テストを実施
#    - SSL/TLS handshakeエラーが発生する場合は暗号スイートを確認
#    - ポリシー変更は即座に反映されます（ダウンタイムなし）
#---------------------------------------------------------------
