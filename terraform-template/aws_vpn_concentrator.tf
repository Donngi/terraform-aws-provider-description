#---------------------------------------------------------------
# AWS VPN コンセントレーター
#---------------------------------------------------------------
#
# Transit Gateway に接続された VPN コンセントレーターを
# プロビジョニングするリソースです。
# VPN コンセントレーターは Transit Gateway のアタッチメントとして機能し、
# VPN 接続のトラフィックを集約・管理します。
#
# AWS公式ドキュメント:
#   - Transit Gateway VPN アタッチメント: https://docs.aws.amazon.com/vpc/latest/tgw/tgw-vpn-attachments.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpn_concentrator
#
# Provider Version: 6.28.0
# Generated: 2026-02-19
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_vpn_concentrator" "example" {
  #-------------------------------------------------------------
  # Transit Gateway 設定
  #-------------------------------------------------------------

  # transit_gateway_id (Required)
  # 設定内容: VPN コンセントレーターをアタッチする Transit Gateway の ID を指定します。
  # 設定可能な値: 有効な Transit Gateway ID（例: tgw-12345678）
  # 省略時: 省略不可（必須項目）
  transit_gateway_id = "tgw-12345678"

  # type (Required)
  # 設定内容: VPN コンセントレーターのタイプを指定します。
  # 設定可能な値: サポートされる VPN コンセントレーターのタイプ文字列
  # 省略時: 省略不可（必須項目）
  type = "ipsec.1"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用します。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 省略時: タグなしで作成されます。
  # 注意: プロバイダーレベルの default_tags 設定ブロックで定義されたタグと
  #       一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "example-vpn-concentrator"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - vpn_concentrator_id: VPN コンセントレーターの ID
# - transit_gateway_attachment_id: Transit Gateway アタッチメントの ID
# - tags_all: プロバイダーの default_tags 設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
