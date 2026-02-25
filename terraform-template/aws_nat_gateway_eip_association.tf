#---------------------------------------------------------------
# AWS VPC NAT Gateway EIP Association
#---------------------------------------------------------------
#
# パブリックNAT GatewayにElastic IPアドレス（EIP）を関連付けるリソースです。
# セカンダリEIPをNAT Gatewayに追加する際に使用します。
# なお、aws_nat_gatewayリソースでsecondary_allocation_idsを設定している場合は
# 本リソースと併用すると競合が発生するため、どちらか一方のみを使用してください。
#
# AWS公式ドキュメント:
#   - NAT ゲートウェイ: https://docs.aws.amazon.com/vpc/latest/userguide/vpc-nat-gateway.html
#   - NAT ゲートウェイの操作: https://docs.aws.amazon.com/vpc/latest/userguide/nat-gateway-working-with.html
#   - AssociateNatGatewayAddress API: https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_AssociateNatGatewayAddress.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway_eip_association
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_nat_gateway_eip_association" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # allocation_id (Required)
  # 設定内容: NAT GatewayへのElastic IPアロケーションIDを指定します。
  # 設定可能な値: 有効なEIPアロケーションID（例: eipalloc-1234567890abcdef0）
  # 注意: EIPのネットワークボーダーグループとNAT Gatewayが配置されているAZの
  #       ネットワークボーダーグループが一致している必要があります。
  allocation_id = "eipalloc-1234567890abcdef0"

  # nat_gateway_id (Required)
  # 設定内容: EIPを関連付けるNAT GatewayのIDを指定します。
  # 設定可能な値: 有効なパブリックNAT GatewayのID（例: nat-1234567890abcdef0）
  # 注意: プライベートNAT GatewayはEIPの関連付けに対応していません。
  nat_gateway_id = "nat-1234567890abcdef0"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用します。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: 操作のタイムアウト時間を設定するブロックです。
  timeouts {

    # create (Optional)
    # 設定内容: リソースの作成完了を待機する最大時間を指定します。
    # 設定可能な値: "30s", "2h45m" のような時間単位付き文字列（s: 秒, m: 分, h: 時間）
    # 省略時: プロバイダーのデフォルトタイムアウトが適用されます。
    create = "10m"

    # delete (Optional)
    # 設定内容: リソースの削除完了を待機する最大時間を指定します。
    # 設定可能な値: "30s", "2h45m" のような時間単位付き文字列（s: 秒, m: 分, h: 時間）
    # 省略時: プロバイダーのデフォルトタイムアウトが適用されます。
    # 注意: 削除操作のタイムアウトはdestroyの前にstateに保存されている場合のみ有効です。
    delete = "10m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - association_id: NAT GatewayとEIPの関連付けに割り当てられたアソシエーションID
#---------------------------------------------------------------
