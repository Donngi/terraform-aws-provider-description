#-----------------------------------------------------------------------
# AWS EC2 Transit Gateway Connect
#-----------------------------------------------------------------------
# Transit Gateway Connectアタッチメントを作成します。
# SD-WAN等のサードパーティアプライアンスとTransit Gateway間の接続を確立します。
# GREトンネルプロトコルとBGPによる動的ルーティングをサポートします。
# 既存のVPCまたはDirect Connectアタッチメントを下位トランスポートとして利用します。
#
# Provider Version: 6.28.0
# Terraform Registry: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_connect
# AWS Documentation: https://docs.aws.amazon.com/vpc/latest/tgw/tgw-connect.html
#
# Generated: 2026-02-15
#
# NOTE:
# - Connect AttachmentはVPC AttachmentまたはDirect Connect Attachmentを下位トランスポートとして必要とします
# - GREトンネルプロトコルを使用し、BGPによる動的ルーティングを実装します
# - 1つのConnect Attachmentに最大4つのConnect Peerを作成可能です
# - Connect Peerの作成にはaws_ec2_transit_gateway_connect_peerリソースを使用します
# - GREトンネルあたり最大5Gbpsの帯域幅をサポートします
# - 静的ルートはサポートされず、BGPによる動的ルート更新が必須です
#-----------------------------------------------------------------------

resource "aws_ec2_transit_gateway_connect" "example" {
  #-----------------------------------------------------------------------
  # 必須設定
  #-----------------------------------------------------------------------
  # 設定内容: Transit GatewayのID
  # 形式: tgw-xxxxxxxxxxxxxxxxx
  # 例: "tgw-0a1b2c3d4e5f6g7h8"
  transit_gateway_id = "tgw-0a1b2c3d4e5f6g7h8"

  # 設定内容: トランスポートとなるTransit Gatewayアタッチメント(VPCまたはDirect Connect)のID
  # 形式: tgw-attach-xxxxxxxxxxxxxxxxx
  # 例: "tgw-attach-0a1b2c3d4e5f6g7h8"
  # 注意: Connect AttachmentはVPC AttachmentまたはDirect Connect Attachmentを下位トランスポートとして使用
  transport_attachment_id = "tgw-attach-0a1b2c3d4e5f6g7h8"

  #-----------------------------------------------------------------------
  # プロトコル設定
  #-----------------------------------------------------------------------
  # 設定内容: Connectアタッチメントで使用するトンネルプロトコル
  # 設定可能な値: gre(Generic Routing Encapsulation)
  # 省略時: gre
  # 注意: 現時点ではGREのみサポート
  protocol = "gre"

  #-----------------------------------------------------------------------
  # ルーティング設定
  #-----------------------------------------------------------------------
  # 設定内容: Transit Gatewayのデフォルトルートテーブルに自動的に関連付けるかどうか
  # 設定可能な値: true(関連付ける) / false(関連付けない)
  # 省略時: Transit Gatewayの設定に従う
  # 注意: falseの場合は手動でルートテーブルとの関連付けが必要
  transit_gateway_default_route_table_association = true

  # 設定内容: Transit Gatewayのデフォルトルートテーブルへルートを自動的に伝播するかどうか
  # 設定可能な値: true(伝播する) / false(伝播しない)
  # 省略時: Transit Gatewayの設定に従う
  # 注意: BGPで学習したルートがデフォルトルートテーブルに伝播される
  transit_gateway_default_route_table_propagation = true

  #-----------------------------------------------------------------------
  # リージョン設定
  #-----------------------------------------------------------------------
  # 設定内容: リソースを管理するAWSリージョン
  # 省略時: プロバイダー設定のリージョン
  # 例: "us-east-1", "ap-northeast-1"
  # 注意: Transit Gatewayと同じリージョンである必要がある
  region = "ap-northeast-1"

  #-----------------------------------------------------------------------
  # タグ設定
  #-----------------------------------------------------------------------
  # 設定内容: リソースに付与するタグ
  # 形式: キーと値のマップ
  # 例: { Name = "my-tgw-connect", Environment = "production" }
  tags = {
    Name        = "example-tgw-connect"
    Environment = "production"
    ManagedBy   = "terraform"
  }

  #-----------------------------------------------------------------------
  # タイムアウト設定
  #-----------------------------------------------------------------------
  timeouts {
    # 設定内容: Connect Attachment作成時のタイムアウト時間
    # 形式: "10m"(分単位)
    # 省略時: 10分
    # create = "10m"

    # 設定内容: Connect Attachment削除時のタイムアウト時間
    # 形式: "10m"(分単位)
    # 省略時: 10分
    # delete = "10m"

    # 設定内容: Connect Attachment更新時のタイムアウト時間
    # 形式: "10m"(分単位)
    # 省略時: 10分
    # update = "10m"
  }
}

#-----------------------------------------------------------------------
# Attributes Reference (参照可能な属性)
#-----------------------------------------------------------------------
# このリソースの作成後に参照可能な属性:
#
# - id
#   Transit Gateway Connect AttachmentのID
#   形式: tgw-attach-xxxxxxxxxxxxxxxxx
#
# - tags_all
#   デフォルトタグを含む全てのタグのマップ
#-----------------------------------------------------------------------
