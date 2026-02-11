#---------------------------------------------------------------
# AWS Proxy Protocol Policy
#---------------------------------------------------------------
#
# Classic Load Balancer (CLB) に対してプロキシプロトコル (Proxy Protocol) を有効化
# するポリシーリソースです。プロキシプロトコルを有効にすることで、CLB の背後にある
# バックエンドインスタンスがクライアントの接続情報（送信元 IP アドレス、送信元ポート等）
# を受け取れるようになります。
#
# プロキシプロトコルは、TCP または SSL リスナーを使用している場合にのみ使用可能です。
# HTTP/HTTPS リスナーの場合は、X-Forwarded-For ヘッダーが自動的に使用されます。
#
# NOTE: このリソースは Classic Load Balancer (aws_elb) 専用です。
#       Application Load Balancer (ALB) や Network Load Balancer (NLB) では使用できません。
#
# AWS公式ドキュメント:
#   - プロキシプロトコルの概要: https://docs.aws.amazon.com/elasticloadbalancing/latest/classic/enable-proxy-protocol.html
#   - Proxy Protocol 仕様: https://www.haproxy.org/download/1.8/doc/proxy-protocol.txt
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/proxy_protocol_policy
#
# Provider Version: 6.28.0
# Generated: 2026-02-04
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_proxy_protocol_policy" "example" {
  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効な AWS リージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 注意: 通常は省略可能。マルチリージョン構成の場合のみ指定を検討してください。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # ロードバランサー設定
  #-------------------------------------------------------------

  # load_balancer (Required)
  # 設定内容: プロキシプロトコルポリシーをアタッチする Classic Load Balancer の名前を指定します。
  # 設定可能な値: Classic Load Balancer (aws_elb) の名前文字列
  # 注意:
  #   - Application Load Balancer (ALB) や Network Load Balancer (NLB) には使用できません。
  #   - 指定する CLB は事前に作成しておく必要があります。
  #   - aws_elb.example.name のように、ELB リソースの name 属性を参照することを推奨します。
  # 例: aws_elb.lb.name
  load_balancer = aws_elb.lb.name

  #-------------------------------------------------------------
  # インスタンスポート設定
  #-------------------------------------------------------------

  # instance_ports (Required)
  # 設定内容: プロキシプロトコルを有効にするバックエンドインスタンスのポート番号のリストを指定します。
  # 設定可能な値: ポート番号の文字列リスト（例: ["25", "587", "8080"]）
  # 制約:
  #   - プロトコルが SSL または TCP のリスナーでのみ使用可能です。
  #   - HTTP/HTTPS リスナーでは使用できません（X-Forwarded-For ヘッダーが代わりに使用されます）。
  # 注意:
  #   - ポート番号は文字列として指定する必要があります（数値ではありません）。
  #   - 指定したポートでリッスンしているインスタンスは、プロキシプロトコルに対応している必要があります。
  #   - 複数のポートを指定することで、複数のサービスに対してプロキシプロトコルを有効化できます。
  # 例:
  #   - SMTP サーバー: ["25", "587"]
  #   - Web サーバー (SSL): ["8443"]
  #   - データベース: ["3306", "5432"]
  instance_ports = ["25", "587"]
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: ポリシーの ID（通常はポリシー名）
#
# - load_balancer: ポリシーがアタッチされている Load Balancer の名前
#---------------------------------------------------------------

#---------------------------------------------------------------
# 以下は、SMTP サーバー (ポート 25 と 587) を持つ Classic Load Balancer に
# プロキシプロトコルを有効化する完全な例です。
#
# resource "aws_elb" "smtp_lb" {
#   name               = "smtp-load-balancer"
#   availability_zones = ["us-east-1a", "us-east-1b"]
#
#   # SMTP ポート 25 のリスナー（標準メール送信）
#   listener {
#     instance_port     = 25
#     instance_protocol = "tcp"
#     lb_port           = 25
#     lb_protocol       = "tcp"
#   }
#---------------------------------------------------------------
