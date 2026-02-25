#---------------------------------------------------------------
# AWS VPC IPv4 CIDR Block Association
#---------------------------------------------------------------
#
# VPCに追加のIPv4 CIDRブロックを関連付けるリソースです。
# VPC作成時にプライマリIPv4 CIDRブロックが必須ですが、このリソースを使用することで
# さらに追加のIPv4 CIDRブロックをVPCに関連付けることができます。
# CIDRは明示的に指定するか、IPAM（IP Address Manager）プールから自動割り当てできます。
#
# AWS公式ドキュメント:
#   - VPC CIDRブロック: https://docs.aws.amazon.com/vpc/latest/userguide/vpc-cidr-blocks.html
#   - VPCへのCIDRブロックの追加・削除: https://docs.aws.amazon.com/vpc/latest/userguide/add-ipv4-cidr.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_ipv4_cidr_block_association
#
# Provider Version: 6.28.0
# Generated: 2026-02-19
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_vpc_ipv4_cidr_block_association" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # vpc_id (Required)
  # 設定内容: CIDRブロックを関連付けるVPCのIDを指定します。
  # 設定可能な値: 有効なVPC ID（例: vpc-0123456789abcdef0）
  vpc_id = "vpc-0123456789abcdef0"

  #-------------------------------------------------------------
  # CIDRブロック設定
  #-------------------------------------------------------------

  # cidr_block (Optional)
  # 設定内容: VPCに関連付けるIPv4 CIDRブロックを指定します。
  # 設定可能な値: RFC 1918プライベートアドレス範囲のCIDR表記（例: 172.20.0.0/16）
  #   - /16 〜 /28 のネットマスク長が使用可能
  # 省略時: ipv4_ipam_pool_idとipv4_netmask_lengthを使用してIPAMから割り当てられます
  # 注意: cidr_blockとipv4_netmask_lengthはどちらか一方を指定（ipv4_ipam_pool_id指定時はipv4_netmask_lengthを使用）
  # 参考: https://docs.aws.amazon.com/vpc/latest/userguide/vpc-cidr-blocks.html
  cidr_block = "172.20.0.0/16"

  # ipv4_ipam_pool_id (Optional)
  # 設定内容: このVPCのCIDR割り当てに使用するIPv4 IPAMプールのIDを指定します。
  # 設定可能な値: 有効なIPAMプールID（例: ipam-pool-0123456789abcdef0）
  # 省略時: IPAMを使用せず、cidr_blockを直接指定します
  # 関連機能: AWS IPAM（IP Address Manager）
  #   AWSリージョンおよびアカウント全体でIPアドレス管理ワークフローを自動化する機能。
  #   IPアドレスの割り当て・追跡・トラブルシューティング・監査が可能。
  #   - https://docs.aws.amazon.com/vpc/latest/ipam/what-it-is-ipam.html
  ipv4_ipam_pool_id = null

  # ipv4_netmask_length (Optional)
  # 設定内容: このVPCに割り当てるIPv4 CIDRのネットマスク長を指定します。
  # 設定可能な値: 整数値（例: 16, 20, 24 等）
  # 省略時: cidr_blockを直接指定する場合は不要
  # 注意: ipv4_ipam_pool_idの指定が必須です
  ipv4_netmask_length = null

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用します
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト時間を設定するブロックです。
  timeouts {

    # create (Optional)
    # 設定内容: リソース作成時のタイムアウト時間を指定します。
    # 設定可能な値: Go duration形式の文字列（例: "10m", "1h30m"）
    # 省略時: プロバイダーのデフォルトタイムアウトを使用します
    create = "10m"

    # delete (Optional)
    # 設定内容: リソース削除時のタイムアウト時間を指定します。
    # 設定可能な値: Go duration形式の文字列（例: "10m", "1h30m"）
    # 省略時: プロバイダーのデフォルトタイムアウトを使用します
    delete = "10m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: VPC CIDRブロック関連付けのID
#---------------------------------------------------------------
