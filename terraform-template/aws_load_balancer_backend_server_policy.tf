#---------------------------------------------------------------
# AWS Load Balancer Backend Server Policy (Classic Load Balancer)
#---------------------------------------------------------------
#
# Classic Load Balancer (CLB) のバックエンドサーバーポートにポリシーを
# アタッチするリソースです。
# バックエンドサーバーとの HTTPS/SSL 通信における認証ポリシーを管理します。
#
# NOTE: このリソースは Classic Load Balancer (CLB) 専用です。
#       バックエンドサーバー認証ポリシー（BackendServerAuthenticationPolicyType）を
#       特定のインスタンスポートに紐付けるために使用します。
#
# 主な用途:
#   - CLB からバックエンドインスタンスへの HTTPS 通信時のサーバー証明書検証
#   - PublicKeyPolicyType を組み合わせた CA 公開鍵ベースの認証設定
#
# AWS公式ドキュメント:
#   - バックエンドサーバー認証: https://docs.aws.amazon.com/elasticloadbalancing/latest/classic/elb-create-https-ssl-load-balancer.html
#   - CLB ポリシー: https://docs.aws.amazon.com/elasticloadbalancing/latest/classic/elb-security-policy-table.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/load_balancer_backend_server_policy
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_load_balancer_backend_server_policy" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # load_balancer_name (Required)
  # 設定内容: ポリシーをアタッチする Classic Load Balancer の名前を指定します。
  # 設定可能な値: aws_elb リソースの name 属性の値
  # 注意: 指定する CLB が事前に存在している必要があります。
  load_balancer_name = aws_elb.example.name

  # instance_port (Required)
  # 設定内容: ポリシーを適用するバックエンドインスタンスのポート番号を指定します。
  # 設定可能な値: 有効なポート番号（例: 443, 8443）
  # 注意: CLB のリスナー設定で定義されたインスタンスポートと一致させる必要があります。
  instance_port = 443

  #-------------------------------------------------------------
  # ポリシー設定
  #-------------------------------------------------------------

  # policy_names (Optional)
  # 設定内容: バックエンドサーバーポートに適用するポリシー名のリストを指定します。
  # 設定可能な値: aws_load_balancer_policy リソースで定義したポリシー名の文字列セット
  # 省略時: ポリシーが適用されない状態になります。
  # 注意: 通常は BackendServerAuthenticationPolicyType のポリシーを指定します。
  policy_names = [
    aws_load_balancer_policy.example.policy_name,
  ]

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効な AWS リージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用します。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: ポリシーの ID
#
# - load_balancer_name: ポリシーが定義されているロードバランサー名
#
# - instance_port: ポリシーが適用されているバックエンドインスタンスポート
#---------------------------------------------------------------
