#---------------------------------------------------------------
# AWS VPC DHCP オプションアソシエーション
#---------------------------------------------------------------
#
# VPCにDHCPオプションセットを関連付けるリソースです。
# VPCはデフォルトのDHCPオプションセットを持ちますが、このリソースを使用することで
# カスタムDHCPオプションセット（aws_vpc_dhcp_optionsリソース）をVPCに割り当てることができます。
# 各VPCに関連付けられるDHCPオプションセットは1つのみです。
# 新しいアソシエーションを作成すると、既存のアソシエーションは置き換えられます。
#
# AWS公式ドキュメント:
#   - VPCのDHCPオプション: https://docs.aws.amazon.com/vpc/latest/userguide/VPC_DHCP_Options.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_dhcp_options_association
#
# Provider Version: 6.28.0
# Generated: 2026-02-19
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
  # 設定内容: DHCPオプションセットを関連付けるVPCのIDを指定します。
  # 設定可能な値: 有効なVPC ID（例: vpc-xxxxxxxxxxxxxxxxx）
  vpc_id = aws_vpc.example.id

  # dhcp_options_id (Required)
  # 設定内容: VPCに関連付けるDHCPオプションセットのIDを指定します。
  # 設定可能な値: 有効なDHCPオプションセットID（例: dopt-xxxxxxxxxxxxxxxxx）
  # 注意: VPCをデフォルトのDHCPオプションに戻すには、デフォルトのDHCPオプションセットIDを指定します。
  #       デフォルトのDHCPオプションセットはaws_vpc_dhcp_optionsデータソースで取得できます。
  dhcp_options_id = aws_vpc_dhcp_options.example.id

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1, us-west-2）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # 注意: Provider v6以降では、provider aliasの代わりにこの属性でリージョンを指定できます。
  region = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: VPCとDHCPオプションセットのアソシエーションID
#---------------------------------------------------------------
