#---------------------------------------------------------------
# AWS ELB Load Balancer Listener Policy
#---------------------------------------------------------------
#
# Classic Load Balancer（ELB）のリスナーにポリシーを関連付けるリソースです。
# SSL/TLSネゴシエーションポリシーやバックエンド認証ポリシー等を
# 特定のリスナーポートに割り当てることができます。
#
# AWS公式ドキュメント:
#   - Classic Load Balancer リスナー設定: https://docs.aws.amazon.com/elasticloadbalancing/latest/classic/elb-listener-config.html
#   - SSL ネゴシエーション設定: https://docs.aws.amazon.com/elasticloadbalancing/latest/classic/elb-ssl-security-policy.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/load_balancer_listener_policy
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_load_balancer_listener_policy" "example" {
  #-------------------------------------------------------------
  # ロードバランサー設定
  #-------------------------------------------------------------

  # load_balancer_name (Required)
  # 設定内容: ポリシーを関連付けるELB（Classic Load Balancer）の名前を指定します。
  # 設定可能な値: 既存のELBリソースの名前文字列
  load_balancer_name = "my-classic-load-balancer"

  # load_balancer_port (Required)
  # 設定内容: ポリシーを適用するロードバランサーのリスナーポート番号を指定します。
  # 設定可能な値: 有効なポート番号（例: 443, 8443）
  # 注意: 指定したポートに対応するリスナーが事前にELBに定義されている必要があります。
  load_balancer_port = 443

  #-------------------------------------------------------------
  # ポリシー設定
  #-------------------------------------------------------------

  # policy_names (Optional)
  # 設定内容: リスナーに適用するポリシー名の一覧を指定します。
  # 設定可能な値: aws_load_balancer_policyリソースで定義したポリシー名の文字列セット
  # 省略時: リスナーにはポリシーが適用されません。
  # 参考: https://docs.aws.amazon.com/elasticloadbalancing/latest/classic/elb-ssl-security-policy.html
  policy_names = [
    "my-ssl-negotiation-policy",
  ]

  #-------------------------------------------------------------
  # トリガー設定
  #-------------------------------------------------------------

  # triggers (Optional)
  # 設定内容: 任意のキーと値のマップを指定します。
  #           このマップの値が変更されると、リソースの更新がトリガーされます。
  # 設定可能な値: 任意の文字列キーと文字列値のマップ
  # 省略時: トリガーは設定されません。
  # 用途: ポリシー定義（aws_load_balancer_policy）の内容が変わっても
  #       このリソースが自動更新されない場合に、強制的な再適用を促すために使用します。
  triggers = {}

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するAWSリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用します。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: リソースのID（load_balancer_name:load_balancer_portの形式）
# - load_balancer_name: ポリシーが定義されているロードバランサーの名前
# - load_balancer_port: ポリシーが適用されているリスナーポート番号
#---------------------------------------------------------------
