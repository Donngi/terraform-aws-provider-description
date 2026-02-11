#---------------------------------------------------------------
# VPC IPv4 CIDR Block Association
#---------------------------------------------------------------
#
# VPCに追加のIPv4 CIDRブロックを関連付けるリソースです。
# VPC作成時にはプライマリIPv4 CIDRブロックが必要ですが、
# このリソースを使用することで、VPCにさらにIPv4 CIDRブロックを追加できます。
# IPAM（IP Address Management）を使用した自動IP割り当ても可能です。
#
# AWS公式ドキュメント:
#   - Amazon VPC User Guide - VPC and Subnet Sizing: https://docs.aws.amazon.com/vpc/latest/userguide/configure-your-vpc.html
#   - What is Amazon VPC IP Address Manager?: https://docs.aws.amazon.com/vpc/latest/ipam/what-it-is-ipam.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_ipv4_cidr_block_association
#
# Provider Version: 6.28.0
# Generated: 2026-02-05
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_vpc_ipv4_cidr_block_association" "example" {
  #---------------------------------------------------------------
  # VPC設定
  #---------------------------------------------------------------

  # vpc_id (Required)
  # 設定内容: IPv4 CIDRブロックを関連付ける対象のVPCのIDを指定します。
  # 設定可能な値: 有効なVPC ID（例: vpc-12345678）
  # 用途: 既存のVPCに追加のCIDRブロックを割り当てる際に使用します。
  # 参考: https://docs.aws.amazon.com/vpc/latest/userguide/configure-your-vpc.html
  vpc_id = "vpc-12345678"

  #---------------------------------------------------------------
  # CIDR設定
  #---------------------------------------------------------------

  # cidr_block (Optional)
  # 設定内容: VPCに関連付けるIPv4 CIDRブロックを指定します。
  # 設定可能な値: 有効なIPv4 CIDRブロック（例: 172.20.0.0/16）
  # 省略時: ipv4_ipam_pool_idとipv4_netmask_lengthを使用してIPAMから導出されます。
  # 注意: cidr_blockを明示的に指定するか、ipv4_ipam_pool_id + ipv4_netmask_lengthを
  #      使用してIPAMから導出するか、いずれかの方法を選択します。
  # 参考: https://docs.aws.amazon.com/vpc/latest/userguide/configure-your-vpc.html
  cidr_block = null

  #---------------------------------------------------------------
  # IPAM設定
  #---------------------------------------------------------------

  # ipv4_ipam_pool_id (Optional)
  # 設定内容: このVPCのCIDRを割り当てるために使用するIPv4 IPAMプールのIDを指定します。
  # 設定可能な値: 有効なIPAM プールID
  # 関連機能: AWS VPC IP Address Manager (IPAM)
  #   IPAMは、AWSリージョンとアカウント全体でIPアドレス管理ワークフローを
  #   自動化できるVPC機能です。IPアドレスの割り当て、追跡、トラブルシューティング、
  #   監査を行うことができます。
  #   - https://docs.aws.amazon.com/vpc/latest/ipam/what-it-is-ipam.html
  # 注意: ipv4_netmask_lengthと組み合わせて使用します。
  ipv4_ipam_pool_id = null

  # ipv4_netmask_length (Optional)
  # 設定内容: このVPCに割り当てるIPv4 CIDRのネットマスク長を指定します。
  # 設定可能な値: 整数値（例: 16は/16のCIDRブロックを表します）
  # 注意: ipv4_ipam_pool_idの指定が必要です。
  # 参考: https://docs.aws.amazon.com/vpc/latest/ipam/what-it-is-ipam.html
  ipv4_netmask_length = null

  #---------------------------------------------------------------
  # リージョン設定
  #---------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定で設定されたリージョンがデフォルトとなります。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #---------------------------------------------------------------
  # タイムアウト設定
  #---------------------------------------------------------------

  # タイムアウト設定
  # 設定内容: リソースの作成・削除操作のタイムアウト時間を設定します。
  timeouts {
    # create (Optional)
    # 設定内容: 作成時のタイムアウト時間を指定します。
    # 設定可能な値: 時間の文字列表現（例: "10m", "15m"）
    # 省略時: 10分
    create = null

    # delete (Optional)
    # 設定内容: 削除時のタイムアウト時間を指定します。
    # 設定可能な値: 時間の文字列表現（例: "10m", "15m"）
    # 省略時: 10分
    delete = null
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: VPC CIDR関連付けのID
#
#---------------------------------------------------------------
