#---------------------------------------------------------------
# AWS Network Manager Transit Gateway Route Table Attachment
#---------------------------------------------------------------
#
# AWS Cloud WANコアネットワークに対して、Transit Gatewayルートテーブルを
# アタッチメントとして接続するリソースです。
# Transit Gatewayピアリングを通じて、コアネットワークのセグメントと
# Transit Gatewayルートテーブルを関連付けます。
#
# AWS公式ドキュメント:
#   - Transit Gatewayルートテーブルアタッチメント概要: https://docs.aws.amazon.com/network-manager/latest/cloudwan/cloudwan-tgw-attachment.html
#   - アタッチメントの作成: https://docs.aws.amazon.com/network-manager/latest/cloudwan/cloudwan-tgw-attachment-add.html
#   - CreateTransitGatewayRouteTableAttachment API: https://docs.aws.amazon.com/networkmanager/latest/APIReference/API_CreateTransitGatewayRouteTableAttachment.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/networkmanager_transit_gateway_route_table_attachment
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_networkmanager_transit_gateway_route_table_attachment" "example" {
  #-------------------------------------------------------------
  # ピアリング設定
  #-------------------------------------------------------------

  # peering_id (Required)
  # 設定内容: このアタッチメントに使用するTransit Gatewayピアリングのリソースを指定します。
  # 設定可能な値: 有効なNetwork Manager Transit Gatewayピアリングリソースのリソースid
  # 参考: https://docs.aws.amazon.com/network-manager/latest/cloudwan/cloudwan-tgw-attachment-add.html
  peering_id = aws_networkmanager_transit_gateway_peering.example.id

  #-------------------------------------------------------------
  # ルートテーブル設定
  #-------------------------------------------------------------

  # transit_gateway_route_table_arn (Required)
  # 設定内容: アタッチメントに使用するTransit GatewayルートテーブルのARNを指定します。
  # 設定可能な値: 有効なTransit GatewayルートテーブルのARN
  # 参考: https://docs.aws.amazon.com/network-manager/latest/cloudwan/cloudwan-tgw-attachment-add.html
  transit_gateway_route_table_arn = aws_ec2_transit_gateway_route_table.example.arn

  #-------------------------------------------------------------
  # ルーティングポリシー設定
  #-------------------------------------------------------------

  # routing_policy_label (Optional, Forces new resource)
  # 設定内容: トラフィックルーティング判断のためにTransit Gatewayルートテーブルアタッチメントに
  #           適用するルーティングポリシーラベルを指定します。
  # 設定可能な値: 最大256文字の文字列
  # 省略時: ルーティングポリシーラベルは適用されません。
  # 注意: この値を変更するとリソースが再作成されます。
  # 参考: https://docs.aws.amazon.com/network-manager/latest/cloudwan/cloudwan-attachments-viewing-editing-rtb.html
  routing_policy_label = null

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 省略時: タグなし
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "example-tgw-route-table-attachment"
    Environment = "production"
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト時間を指定する設定ブロックです。
  timeouts {

    # create (Optional)
    # 設定内容: リソース作成操作のタイムアウト時間を指定します。
    # 設定可能な値: "60m"、"2h" などのGoのtime.Duration形式の文字列
    # 省略時: デフォルトのタイムアウト値が使用されます。
    create = "30m"

    # delete (Optional)
    # 設定内容: リソース削除操作のタイムアウト時間を指定します。
    # 設定可能な値: "60m"、"2h" などのGoのtime.Duration形式の文字列
    # 省略時: デフォルトのタイムアウト値が使用されます。
    delete = "30m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: アタッチメントのARN
# - attachment_policy_rule_number: アタッチメントに関連付けられたポリシールール番号
# - attachment_type: アタッチメントのタイプ
# - core_network_arn: コアネットワークのARN
# - core_network_id: コアネットワークのID
# - edge_location: ピアのエッジロケーション
# - id: アタッチメントのID
# - owner_account_id: アタッチメントアカウントオーナーのID
# - resource_arn: アタッチメントリソースのARN
# - segment_name: アタッチメントのセグメント名
# - state: アタッチメントの状態
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
