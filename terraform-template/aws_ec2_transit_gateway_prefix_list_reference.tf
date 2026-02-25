#-----------------------------------------------------------------------
# AWS EC2 Transit Gateway Prefix List Reference
#-----------------------------------------------------------------------
# Provider Version: 6.28.0
# Generated: 2025-01-XX
# NOTE: このテンプレートはAWS Provider v6.28.0のスキーマから生成されています
#
# Transit Gateway Prefix List Referenceは、プレフィックスリストを使用して
# Transit Gatewayルートテーブル内に複数のCIDRブロックへのルーティングを
# 一括で定義するために使用します。
#
# 主な用途:
# - プレフィックスリストを使用した効率的なルーティング管理
# - VPCアタッチメントへのトラフィック転送の定義
# - ブラックホールルートによるトラフィックドロップの設定
# - 複数のCIDRブロックへの一括ルーティング設定
#
# 補足事項:
# - 各プレフィックスリストとルートテーブルの組み合わせは一意である必要があります
# - blackholeとtransit_gateway_attachment_idは排他的な設定です
# - プレフィックスリストの変更は自動的にルーティングに反映されます
#
# AWS公式ドキュメント:
# https://docs.aws.amazon.com/vpc/latest/tgw/tgw-prefix-lists.html
#
# Terraform AWS Provider ドキュメント:
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_prefix_list_reference

#-----------------------------------------------------------------------
# 基本設定
#-----------------------------------------------------------------------

resource "aws_ec2_transit_gateway_prefix_list_reference" "example" {
  # 設定内容: プレフィックスリストのID
  # 設定可能な値: EC2 Managed Prefix ListのリソースID (pl-xxxxxxxxxxxxxxxxx)
  # 省略時: 必須項目のため指定が必要
  prefix_list_id = aws_ec2_managed_prefix_list.example.id

  # 設定内容: Transit Gatewayルートテーブルのリソース識別子
  # 設定可能な値: Transit Gateway Route TableのリソースID (tgw-rtb-xxxxxxxxxxxxxxxxx)
  # 省略時: 必須項目のため指定が必要
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.example.id

  #-----------------------------------------------------------------------
  # ルーティング先の設定
  #-----------------------------------------------------------------------

  # 設定内容: トラフィックの転送先となるTransit Gatewayアタッチメント
  # 設定可能な値: Transit Gateway AttachmentのリソースID (tgw-attach-xxxxxxxxxxxxxxxxx)
  # 省略時: 設定されません（blackholeとの排他的設定）
  transit_gateway_attachment_id = aws_ec2_transit_gateway_vpc_attachment.example.id

  # 設定内容: プレフィックスリストに一致するトラフィックをドロップするか
  # 設定可能な値: true（トラフィックをドロップ）, false（転送先にルーティング）
  # 省略時: false
  blackhole = false

  #-----------------------------------------------------------------------
  # リージョン設定
  #-----------------------------------------------------------------------

  # 設定内容: リソースを管理するAWSリージョン
  # 設定可能な値: AWS リージョンコード (us-east-1, ap-northeast-1等)
  # 省略時: プロバイダー設定のリージョン
  region = "ap-northeast-1"
}

#-----------------------------------------------------------------------
# Attributes Reference（参照可能な属性）
#-----------------------------------------------------------------------
# このリソースの作成後に参照可能な属性：
#
# • id
#   - Transit Gatewayルートテーブル識別子とプレフィックスリスト識別子を
#     アンダースコア(_)で連結した値
#   - 形式: tgw-rtb-xxxxxxxxxxxxxxxxx_pl-xxxxxxxxxxxxxxxxx
#
# • prefix_list_owner_id
#   - プレフィックスリストのオーナーAWSアカウントID
#   - 形式: 12桁のAWSアカウントID
#
# アクセス方法:
#   aws_ec2_transit_gateway_prefix_list_reference.example.id
#   aws_ec2_transit_gateway_prefix_list_reference.example.prefix_list_owner_id
