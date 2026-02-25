#-----------------------------------------------------------------------
# AWS EC2 Transit Gateway VPC Attachment
#-----------------------------------------------------------------------
# Transit GatewayにVPCをアタッチメントとして接続します。
# VPC内の複数のサブネット(各AZに1つずつ推奨)を指定してTransit Gatewayと接続します。
# DNS解決、IPv6、アプライアンスモード、セキュリティグループ参照などの機能を設定可能です。
# 作成後はアタッチメントIDを使用してルートテーブルとの関連付けやルート伝播を設定します。
#
# Provider Version: 6.28.0
# Terraform Registry: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_vpc_attachment
# AWS Documentation: https://docs.aws.amazon.com/vpc/latest/tgw/tgw-vpc-attachments.html
#
# Generated: 2026-02-16
#
# NOTE:
# - 少なくとも1つのサブネットIDが必須ですが、冗長性のため各AZに1つずつ指定することを推奨
# - アタッチメント作成後、Transit Gatewayルートテーブルとの関連付けが別途必要
# - サブネットの追加・削除はアタッチメントの変更として実行可能(トラフィックは中断される場合あり)
# - Appliance Modeを有効にすると、同一フローのトラフィックが同じAZを通過するようになります
# - Security Group Referencing Supportを有効にすると、TGWにアタッチされたVPC間でセキュリティグループを参照可能
# - DNS Supportを有効にすると、VPC内のインスタンスがTransit Gateway経由でDNS解決を実行可能
#-----------------------------------------------------------------------

resource "aws_ec2_transit_gateway_vpc_attachment" "example" {
  #-----------------------------------------------------------------------
  # 必須設定
  #-----------------------------------------------------------------------
  # 設定内容: アタッチするTransit GatewayのID
  # 形式: tgw-xxxxxxxxxxxxxxxxx
  # 例: "tgw-0a1b2c3d4e5f6g7h8"
  transit_gateway_id = "tgw-0a1b2c3d4e5f6g7h8"

  # 設定内容: アタッチするVPCのID
  # 形式: vpc-xxxxxxxxxxxxxxxxx
  # 例: "vpc-0a1b2c3d4e5f6g7h8"
  vpc_id = "vpc-0a1b2c3d4e5f6g7h8"

  # 設定内容: Transit Gatewayに接続するサブネットのIDリスト
  # 形式: subnet-xxxxxxxxxxxxxxxxxの配列
  # 例: ["subnet-0a1b2c3d", "subnet-1a2b3c4d"]
  # 注意: 冗長性のため各Availability Zoneに1つずつサブネットを指定することを推奨
  # 注意: サブネット変更時は一時的にトラフィックが中断される可能性あり
  subnet_ids = [
    "subnet-0a1b2c3d4e5f6g7h",
    "subnet-1a2b3c4d5e6f7g8h",
  ]

  #-----------------------------------------------------------------------
  # 機能オプション設定
  #-----------------------------------------------------------------------
  # 設定内容: アプライアンスモードサポートの有効化
  # 設定可能な値: enable(有効) / disable(無効)
  # 省略時: disable
  # 説明: 有効にすると、同一フローのトラフィックが同じAvailability Zoneを通過するようになります
  # 用途: ステートフルなファイアウォールやIDSなどのネットワークアプライアンスを使用する場合に有効化
  appliance_mode_support = "disable"

  # 設定内容: DNS解決サポートの有効化
  # 設定可能な値: enable(有効) / disable(無効)
  # 省略時: enable
  # 説明: VPC内のリソースがTransit Gateway経由でDNS解決を実行可能にします
  dns_support = "enable"

  # 設定内容: IPv6サポートの有効化
  # 設定可能な値: enable(有効) / disable(無効)
  # 省略時: disable
  # 説明: IPv6トラフィックをTransit Gateway経由で送受信可能にします
  # 注意: VPC側もIPv6が有効化されている必要があります
  ipv6_support = "disable"

  # 設定内容: セキュリティグループ参照サポートの有効化
  # 設定可能な値: enable(有効) / disable(無効)
  # 省略時: enable(アタッチメントレベル) / Transit Gatewayレベルではdisable
  # 説明: Transit Gatewayにアタッチされた他のVPCのセキュリティグループを参照可能にします
  # 用途: 複数VPC間でセキュリティグループルールを簡素化する場合に使用
  security_group_referencing_support = "enable"

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
  # 注意: trueの場合、VPCのCIDRがデフォルトルートテーブルに自動的に伝播されます
  transit_gateway_default_route_table_propagation = true

  #-----------------------------------------------------------------------
  # リージョン設定
  #-----------------------------------------------------------------------
  # 設定内容: リソースを管理するAWSリージョン
  # 省略時: プロバイダー設定のリージョン
  # 例: "us-east-1", "ap-northeast-1"
  # 注意: Transit GatewayとVPCは同じリージョンである必要があります
  region = "ap-northeast-1"

  #-----------------------------------------------------------------------
  # タグ設定
  #-----------------------------------------------------------------------
  # 設定内容: リソースに付与するタグ
  # 形式: キーと値のマップ
  # 例: { Name = "my-tgw-vpc-attachment", Environment = "production" }
  tags = {
    Name        = "example-tgw-vpc-attachment"
    Environment = "production"
    ManagedBy   = "terraform"
  }
}

#-----------------------------------------------------------------------
# Attributes Reference (参照可能な属性)
#-----------------------------------------------------------------------
# このリソースの作成後に参照可能な属性:
#
# - id
#   Transit Gateway VPC AttachmentのID
#   形式: tgw-attach-xxxxxxxxxxxxxxxxx
#
# - arn
#   Transit Gateway VPC AttachmentのARN
#   形式: arn:aws:ec2:region:account-id:transit-gateway-attachment/tgw-attach-xxxxxxxxxxxxxxxxx
#
# - vpc_owner_id
#   VPCを所有するAWSアカウントのID
#   形式: 12桁の数字
#
# - tags_all
#   デフォルトタグを含む全てのタグのマップ
#-----------------------------------------------------------------------
