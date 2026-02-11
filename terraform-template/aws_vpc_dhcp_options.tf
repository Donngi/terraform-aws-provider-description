#---------------------------------------------------------------
# VPC DHCP Options
#---------------------------------------------------------------
#
# VPCで使用するDHCPオプションセットをプロビジョニングするリソースです。
# DHCPオプションセットは、VPC内のインスタンスがDHCPを通じて受け取る
# ネットワーク設定（DNSサーバー、ドメイン名、NTPサーバーなど）を定義します。
#
# AWS公式ドキュメント:
#   - DHCP Options Sets: https://docs.aws.amazon.com/vpc/latest/userguide/VPC_DHCP_Options.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_dhcp_options
#
# Provider Version: 6.28.0
# Generated: 2026-02-05
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_vpc_dhcp_options" "example" {
  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # DNS設定
  #-------------------------------------------------------------

  # domain_name (Optional)
  # 設定内容: FQDN（完全修飾ドメイン名）ではないドメイン名を解決する際に
  #           デフォルトで使用するサフィックスドメイン名を指定します。
  # 設定可能な値: 文字列（ドメイン名形式）
  # 省略時: 指定なし
  # 関連機能: /etc/resolv.confのsearch値として使用されます。
  # 参考: https://docs.aws.amazon.com/vpc/latest/userguide/VPC_DHCP_Options.html
  domain_name = "example.local"

  # domain_name_servers (Optional)
  # 設定内容: /etc/resolv.confに設定するネームサーバーのリストを指定します。
  # 設定可能な値:
  #   - IPアドレスのリスト（最大4つまで）
  #   - "AmazonProvidedDNS": AWSのデフォルトネームサーバーを使用する場合
  # 省略時: 指定なし
  # 関連機能: DNSリゾルバー設定
  #   VPC内のインスタンスが使用するDNSサーバーを定義します。
  #   - https://docs.aws.amazon.com/vpc/latest/userguide/VPC_DHCP_Options.html
  domain_name_servers = ["AmazonProvidedDNS"]

  #-------------------------------------------------------------
  # IPv6設定
  #-------------------------------------------------------------

  # ipv6_address_preferred_lease_time (Optional)
  # 設定内容: IPv6が割り当てられた実行中のインスタンスが、DHCPv6リース更新を
  #           実行する頻度を秒単位で指定します。
  # 設定可能な値: 140～2147483647（約68年）の整数値（文字列形式）
  # 省略時: 140秒（デフォルトのリース時間）
  # 関連機能: DHCPv6リース管理
  #   EC2インスタンスで長期アドレス指定を使用する場合、リース時間を増やすことで
  #   頻繁なリース更新リクエストを回避できます。リース更新は通常、リース時間の
  #   半分が経過した時点で発生します。
  #   - https://docs.aws.amazon.com/vpc/latest/userguide/VPC_DHCP_Options.html
  ipv6_address_preferred_lease_time = "1440"

  #-------------------------------------------------------------
  # NTP設定
  #-------------------------------------------------------------

  # ntp_servers (Optional)
  # 設定内容: 設定するNTPサーバーのリストを指定します。
  # 設定可能な値: NTPサーバーのIPアドレスのリスト（最大4つまで）
  # 省略時: 指定なし
  # 関連機能: 時刻同期
  #   VPC内のインスタンスが時刻同期に使用するNTPサーバーを定義します。
  #   - https://docs.aws.amazon.com/vpc/latest/userguide/VPC_DHCP_Options.html
  ntp_servers = ["169.254.169.123"]

  #-------------------------------------------------------------
  # NetBIOS設定
  #-------------------------------------------------------------

  # netbios_name_servers (Optional)
  # 設定内容: NetBIOSネームサーバーのリストを指定します。
  # 設定可能な値: NetBIOSネームサーバーのIPアドレスのリスト（最大4つまで）
  # 省略時: 指定なし
  # 関連機能: Windows NetBIOS名前解決
  #   Windows環境でNetBIOS名前解決に使用するサーバーを定義します。
  #   - https://docs.aws.amazon.com/vpc/latest/userguide/VPC_DHCP_Options.html
  netbios_name_servers = ["10.0.0.1"]

  # netbios_node_type (Optional)
  # 設定内容: NetBIOSノードタイプを指定します。
  # 設定可能な値:
  #   - "1": B-node（ブロードキャスト）
  #   - "2": P-node（ポイントツーポイント）- AWSが推奨
  #   - "4": M-node（ミックス）
  #   - "8": H-node（ハイブリッド）
  # 省略時: 指定なし
  # 注意: AWSはブロードキャストとマルチキャストをサポートしていないため、
  #       2（P-node）の指定を推奨しています。
  # 参考: RFC 2132 - http://www.ietf.org/rfc/rfc2132.txt
  netbios_node_type = "2"

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  #   - https://docs.aws.amazon.com/vpc/latest/userguide/VPC_DHCP_Options.html
  tags = {
    Name        = "example-dhcp-options"
    Environment = "production"
  }
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
# - owner_id: DHCPオプションセットを所有するAWSアカウントのID
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
