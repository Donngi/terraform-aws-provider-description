#---------------------------------------------------------------
# AWS Default VPC DHCP Options
#---------------------------------------------------------------
#
# 現在のリージョンにおけるデフォルトのAWS DHCPオプションセットを管理するリソースです。
# 各AWSリージョンにはデフォルトのDHCPオプションセットが用意されています。
#
# **これは高度なリソースです**。使用する際には特別な注意事項があります。
# このドキュメントを最後まで読んでから使用してください。
#
# aws_default_vpc_dhcp_optionsは通常のリソースとは異なる動作をします。
# Terraformはこのリソースを「作成」するのではなく、既存のデフォルト
# DHCPオプションセットを管理対象として「採用」します。
#
# AWS公式ドキュメント:
#   - VPC DHCPオプションセット: https://docs.aws.amazon.com/vpc/latest/userguide/VPC_DHCP_Options.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/default_vpc_dhcp_options
#
# Provider Version: 6.28.0
# Generated: 2026-01-22
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_default_vpc_dhcp_options" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # id (Optional, Computed)
  # 設定内容: DHCPオプションセットのIDを指定します。
  # 設定可能な値: 既存のDHCPオプションセットID
  # 省略時: Terraformが自動的にデフォルトDHCPオプションセットを検出します
  # 注意: このリソースはデフォルトDHCPオプションセットを「作成」するのではなく、
  #       既存のものを管理対象として「採用」します
  # id = null

  # owner_id (Optional, Computed)
  # 設定内容: DHCPオプションセットを所有するAWSアカウントIDを指定します。
  # 設定可能な値: 12桁のAWSアカウントID
  # 省略時: 現在のアカウントIDが使用されます
  # owner_id = null

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional, Computed)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = null

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  #   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  tags = {
    Name = "Default DHCP Option Set"
  }

  # tags_all (Optional, Computed)
  # 設定内容: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
  #           リソースに割り当てられたすべてのタグのマップです。
  # 注意: 通常はこの属性を直接設定する必要はありません。
  #       tagsとdefault_tagsから自動的に計算されます。
  # tags_all = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: DHCPオプションセットのID
#
# - arn: DHCPオプションセットのAmazon Resource Name (ARN)
#
# - domain_name: DHCPで設定されるドメイン名
#   リージョンに応じて自動的に設定されます。
#   - us-east-1: "ec2.internal"
#   - その他のリージョン: "{region}.compute.internal"
#
# - domain_name_servers: DNSサーバーのアドレス
#   デフォルトでは "AmazonProvidedDNS" が設定されています。
#
# - ipv6_address_preferred_lease_time: IPv6アドレスの優先リース時間
#
# - netbios_name_servers: NetBIOS名前サーバーのリスト
#
# - netbios_node_type: NetBIOSノードタイプ
#   AWS推奨値は2です（ブロードキャストとマルチキャストはAWSネットワークで
#   サポートされていないため）。
#   詳細: http://www.ietf.org/rfc/rfc2132.txt
#
# - ntp_servers: NTPサーバーのリスト
#
# - owner_id: DHCPオプションセットを所有するAWSアカウントID
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
