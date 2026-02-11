#---------------------------------------------------------------
# VPC DHCP Options Association
#---------------------------------------------------------------
#
# VPCにDHCPオプションセットを関連付けるリソースです。
# DHCPオプションセットには、DNSサーバー、ドメイン名、NTPサーバー、
# NetBIOS設定などのネットワーク設定が含まれます。
#
# 各VPCには1つのDHCPオプションセットのみを関連付けることができますが、
# 1つのDHCPオプションセットを複数のVPCに関連付けることは可能です。
#
# AWS公式ドキュメント:
#   - DHCP Option Set Concepts: https://docs.aws.amazon.com/vpc/latest/userguide/DHCPOptionSetConcepts.html
#   - Work with DHCP Option Sets: https://docs.aws.amazon.com/vpc/latest/userguide/DHCPOptionSet.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_dhcp_options_association
#
# Provider Version: 6.28.0
# Generated: 2026-02-05
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_vpc_dhcp_options_association" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # vpc_id (Required)
  # 設定内容: DHCPオプションセットを関連付ける対象のVPC IDを指定します。
  # 設定可能な値: 有効なVPC ID（例: vpc-12345678）
  # 関連機能: VPC DHCP Options Association
  #   各VPCには1つのDHCPオプションセットのみを関連付けることができます。
  #   VPCのインスタンスは、関連付けられたDHCPオプションセットのネットワーク設定を使用します。
  #   - https://docs.aws.amazon.com/vpc/latest/userguide/DHCPOptionSet.html
  vpc_id = "vpc-12345678"

  # dhcp_options_id (Required)
  # 設定内容: VPCに関連付けるDHCPオプションセットのIDを指定します。
  # 設定可能な値: 有効なDHCPオプションセットID（例: dopt-12345678）
  # 関連機能: DHCP Options Set
  #   DHCPオプションセットには、DNSサーバー、ドメイン名、NTPサーバー、
  #   NetBIOS名サーバー、NetBIOSノードタイプなどのネットワーク設定が含まれます。
  #   1つのDHCPオプションセットを複数のVPCに関連付けることが可能です。
  #   - https://docs.aws.amazon.com/vpc/latest/userguide/DHCPOptionSetConcepts.html
  dhcp_options_id = "dopt-12345678"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "ap-northeast-1"

  #-------------------------------------------------------------
  # リソースID設定
  #-------------------------------------------------------------

  # id (Optional)
  # 設定内容: リソースの一意の識別子を指定します。
  # 設定可能な値: 文字列形式のリソースID
  # 省略時: Terraformが自動的に生成します
  # 注意: 通常は指定する必要はありません。リソースのインポート時など、
  #       特定のケースでのみ使用します。
  # id = "dopt-12345678-vpc-12345678"
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: DHCPオプションセット関連付けのID
#---------------------------------------------------------------
