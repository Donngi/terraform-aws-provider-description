#---------------------------------------------------------------
# AWS Lightsail Load Balancer
#---------------------------------------------------------------
#
# Amazon Lightsail のロードバランサーをプロビジョニングするリソースです。
# 複数の Lightsail インスタンスに受信トラフィックを分散し、
# アプリケーションの可用性とパフォーマンスを向上させます。
#
# AWS公式ドキュメント:
#   - Lightsail ロードバランサー概要: https://docs.aws.amazon.com/lightsail/latest/userguide/understanding-lightsail-load-balancers.html
#   - ロードバランサーの作成: https://docs.aws.amazon.com/lightsail/latest/userguide/create-lightsail-load-balancer-and-attach-lightsail-instances.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lightsail_lb
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_lightsail_lb" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required, Forces new resource)
  # 設定内容: Lightsail ロードバランサーの名前を指定します。
  # 設定可能な値: 文字列（Lightsail リソース命名規則に従った名前）
  name = "example-load-balancer"

  # instance_port (Required)
  # 設定内容: ロードバランサーが接続するインスタンスのポート番号を指定します。
  # 設定可能な値: 1〜65535 の整数値（例: HTTP の場合は 80、HTTPS の場合は 443）
  instance_port = 80

  #-------------------------------------------------------------
  # ヘルスチェック設定
  #-------------------------------------------------------------

  # health_check_path (Optional)
  # 設定内容: ロードバランサーがインスタンスの正常性を確認するためのパスを指定します。
  # 設定可能な値: 有効な URL パス文字列（例: "/", "/health", "/status"）
  # 省略時: "/" が使用されます。
  health_check_path = "/"

  #-------------------------------------------------------------
  # ネットワーク設定
  #-------------------------------------------------------------

  # ip_address_type (Optional)
  # 設定内容: ロードバランサーの IP アドレスタイプを指定します。
  # 設定可能な値:
  #   - "dualstack" (デフォルト): IPv4 と IPv6 の両方をサポート
  #   - "ipv4": IPv4 のみをサポート
  # 省略時: "dualstack" が使用されます。
  ip_address_type = "dualstack"

  # region (Optional)
  # 設定内容: このリソースを管理する AWS リージョンを指定します。
  # 設定可能な値: 有効な AWS リージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンが使用されます。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ。キーのみのタグは値に空文字列を指定します。
  # 省略時: タグなし
  # 注意: プロバイダーの default_tags 設定ブロックが存在する場合、
  #       一致するキーを持つタグはプロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "example-load-balancer"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: Lightsail ロードバランサーの Amazon Resource Name (ARN)
#
# - created_at: ロードバランサーが作成されたタイムスタンプ
#
# - dns_name: ロードバランサーの DNS 名
#
# - id: ロードバランサーの識別子（name と一致）
#
# - protocol: ロードバランサーのプロトコル
#
# - public_ports: ロードバランサーのパブリックポートリスト
#
# - support_code: ロードバランサーのサポートコード。Lightsail に関する問い合わせ時に
#                 サポートチームへのメールに含めることで、情報検索が迅速になります。
#
# - tags_all: プロバイダーの default_tags 設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
