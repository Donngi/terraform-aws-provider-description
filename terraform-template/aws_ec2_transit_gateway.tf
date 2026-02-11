# ==============================================================================
# AWS EC2 Transit Gateway - Annotated Template
# ==============================================================================
# Generated: 2026-01-22
# Provider Version: 6.28.0
#
# このテンプレートは生成時点(2026-01-22)の AWS Provider 6.28.0 の仕様に基づいています。
# 最新の仕様については公式ドキュメントを確認してください:
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway
#
# AWS Transit Gateway 公式ドキュメント:
# https://docs.aws.amazon.com/vpc/latest/tgw/what-is-transit-gateway.html
# ==============================================================================

resource "aws_ec2_transit_gateway" "example" {
  # --------------------------------------------------------------------------
  # Amazon Side ASN (Optional)
  # --------------------------------------------------------------------------
  # BGPセッションのAmazon側のプライベート自律システム番号(ASN)
  # - 16ビットASN: 64512 から 65534
  # - 32ビットASN: 4200000000 から 4294967294
  # - デフォルト値: 64512
  #
  # 注意: アクティブなBGPセッションを持つTransit Gatewayのamazon_side_asnを変更することはできません。
  # amazon_side_asnを変更する前に、BGPが設定されたすべてのTransit Gateway Attachmentを削除する必要があります。
  #
  # 参考: https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_ModifyTransitGatewayOptions.html
  amazon_side_asn = 64512

  # --------------------------------------------------------------------------
  # Auto Accept Shared Attachments (Optional)
  # --------------------------------------------------------------------------
  # リソースアタッチメントリクエストが自動的に承認されるかどうか
  # - 有効な値: "disable", "enable"
  # - デフォルト値: "disable"
  #
  # 組織間や異なるAWSアカウント間でTransit Gatewayを共有する場合に使用
  auto_accept_shared_attachments = "disable"

  # --------------------------------------------------------------------------
  # Default Route Table Association (Optional)
  # --------------------------------------------------------------------------
  # リソースアタッチメントがデフォルトの関連付けルートテーブルに自動的に関連付けられるかどうか
  # - 有効な値: "disable", "enable"
  # - デフォルト値: "enable"
  #
  # disableに設定すると、各アタッチメントを手動でルートテーブルに関連付ける必要があります
  default_route_table_association = "enable"

  # --------------------------------------------------------------------------
  # Default Route Table Propagation (Optional)
  # --------------------------------------------------------------------------
  # リソースアタッチメントがデフォルトの伝播ルートテーブルにルートを自動的に伝播するかどうか
  # - 有効な値: "disable", "enable"
  # - デフォルト値: "enable"
  #
  # disableに設定すると、ルート伝播を手動で設定する必要があります
  default_route_table_propagation = "enable"

  # --------------------------------------------------------------------------
  # Description (Optional)
  # --------------------------------------------------------------------------
  # Transit Gatewayの説明文
  # 用途や環境を識別するための任意の説明を設定できます
  description = "My Transit Gateway"

  # --------------------------------------------------------------------------
  # DNS Support (Optional)
  # --------------------------------------------------------------------------
  # DNS解決サポートが有効かどうか
  # - 有効な値: "disable", "enable"
  # - デフォルト値: "enable"
  #
  # enableにすると、Transit Gateway経由で接続されたVPC間でDNS解決が可能になります
  dns_support = "enable"

  # --------------------------------------------------------------------------
  # Encryption Support (Optional)
  # --------------------------------------------------------------------------
  # VPC暗号化制御のための暗号化サポートが有効かどうか
  # - 有効な値: "disable", "enable"
  # - デフォルト値: "disable"
  #
  # 注意: 一度設定すると、disableに切り替えるには引数を削除するのではなく、
  # 明示的に "disable" を指定する必要があります
  encryption_support = "disable"

  # --------------------------------------------------------------------------
  # Multicast Support (Optional)
  # --------------------------------------------------------------------------
  # マルチキャストサポートが有効かどうか
  # - 有効な値: "disable", "enable"
  # - デフォルト値: "disable"
  #
  # ec2_transit_gateway_multicast_domain を使用する場合は必須
  # 参考: https://docs.aws.amazon.com/vpc/latest/tgw/tgw-multicast-overview.html
  multicast_support = "disable"

  # --------------------------------------------------------------------------
  # Region (Optional)
  # --------------------------------------------------------------------------
  # このリソースが管理されるAWSリージョン
  # 指定しない場合、プロバイダー設定で設定されたリージョンがデフォルトとして使用されます
  #
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-east-1"

  # --------------------------------------------------------------------------
  # Security Group Referencing Support (Optional)
  # --------------------------------------------------------------------------
  # セキュリティグループ参照サポートが有効かどうか
  # - 有効な値: "disable", "enable"
  # - デフォルト値: "disable"
  #
  # enableにすると、異なるVPC間でセキュリティグループを相互参照できるようになります
  security_group_referencing_support = "disable"

  # --------------------------------------------------------------------------
  # Tags (Optional)
  # --------------------------------------------------------------------------
  # Transit Gatewayに付与するキーバリュー形式のタグ
  #
  # プロバイダーにdefault_tags設定ブロックが存在する場合、
  # 一致するキーを持つタグはプロバイダーレベルで定義されたものを上書きします
  #
  # 参考: https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  tags = {
    Name        = "my-transit-gateway"
    Environment = "production"
  }

  # --------------------------------------------------------------------------
  # Transit Gateway CIDR Blocks (Optional)
  # --------------------------------------------------------------------------
  # Transit Gateway用の1つ以上のIPv4またはIPv6 CIDRブロック
  # - IPv4の場合: /24以上のサイズのCIDRブロック
  # - IPv6の場合: /64以上のサイズのCIDRブロック
  #
  # Transit Gateway Connect attachmentやピアリング接続で使用されます
  transit_gateway_cidr_blocks = []

  # --------------------------------------------------------------------------
  # VPN ECMP Support (Optional)
  # --------------------------------------------------------------------------
  # VPN Equal Cost Multipath Protocolサポートが有効かどうか
  # - 有効な値: "disable", "enable"
  # - デフォルト値: "enable"
  #
  # 複数のVPN接続で負荷分散を行う場合に使用
  vpn_ecmp_support = "enable"

  # --------------------------------------------------------------------------
  # Timeouts (Optional)
  # --------------------------------------------------------------------------
  # リソース操作のタイムアウト設定
  timeouts {
    # 作成時のタイムアウト (デフォルト: 10m)
    create = "10m"

    # 更新時のタイムアウト (デフォルト: 10m)
    update = "10m"

    # 削除時のタイムアウト (デフォルト: 10m)
    delete = "10m"
  }
}

# ==============================================================================
# Computed Attributes (読み取り専用)
# ==============================================================================
# 以下の属性はTerraform実行後に参照可能ですが、入力時には指定できません:
#
# - arn: Transit GatewayのAmazon Resource Name (ARN)
# - association_default_route_table_id: デフォルトの関連付けルートテーブルの識別子
# - id: Transit Gatewayの識別子
# - owner_id: Transit Gatewayを所有するAWSアカウントの識別子
# - propagation_default_route_table_id: デフォルトの伝播ルートテーブルの識別子
#
# 使用例:
# output "transit_gateway_id" {
#   value = aws_ec2_transit_gateway.example.id
# }
#
# output "transit_gateway_arn" {
#   value = aws_ec2_transit_gateway.example.arn
# }
# ==============================================================================
