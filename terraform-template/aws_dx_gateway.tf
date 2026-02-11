#---------------------------------------------------------------
# AWS Direct Connect Gateway
#---------------------------------------------------------------
#
# Direct Connect GatewayはAWS Direct Connectサービスの中間オブジェクトで、
# 仮想インターフェースと仮想プライベートゲートウェイのセットを接続可能にします。
# Direct Connect Gatewayはグローバルで、作成後は任意のAWSリージョンから参照可能です。
# 異なるAWSリージョン間でトラフィックをルーティングすることができます。
#
# AWS公式ドキュメント:
#   - Create a Direct Connect gateway: https://docs.aws.amazon.com/directconnect/latest/UserGuide/create-direct-connect-gateway.html
#   - CreateDirectConnectGateway API: https://docs.aws.amazon.com/directconnect/latest/APIReference/API_CreateDirectConnectGateway.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dx_gateway
#
# Provider Version: 6.28.0
# Generated: 2026-01-28
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_dx_gateway" "example" {
  #---------------------------------------------------------------
  # Required Parameters
  #---------------------------------------------------------------

  # name - (Required) Direct Connect Gatewayの名前
  # Direct Connect Gatewayを識別するための名前を指定します。
  # この名前はコンソール上での表示や識別に使用されます。
  #
  # 例: "tf-dxg-example", "production-dxg", "my-dx-gateway"
  name = "tf-dxg-example"

  # amazon_side_asn - (Required) Amazon側のBGP接続用ASN番号
  # Border Gateway Protocol (BGP)セッションでAmazon側に設定される
  # 自律システム番号(ASN)を指定します。
  #
  # 有効な範囲:
  #   - 64,512 ～ 65,534 (プライベートASN範囲)
  #   - 4,200,000,000 ～ 4,294,967,294 (拡張プライベートASN範囲)
  #
  # デフォルト値: 64512
  #
  # 注意事項:
  #   - AWS Cloud WAN core networkと併用する場合、
  #     core networkのASNと同じ範囲を使用しないでください
  #
  # 例: "64512", "65534", "4200000000"
  amazon_side_asn = "64512"

  #---------------------------------------------------------------
  # Optional Parameters
  #---------------------------------------------------------------

  # tags - (Optional) リソースに付与するタグのKey-Valueマップ
  # Direct Connect Gatewayに付与するタグを指定します。
  #
  # プロバイダーレベルで `default_tags` 設定ブロックが存在する場合、
  # 同じキーを持つタグはプロバイダーレベルで定義されたものを上書きします。
  #
  # 例:
  # tags = {
  #   Environment = "production"
  #   Project     = "network-infrastructure"
  #   ManagedBy   = "terraform"
  # }
  tags = {
    Environment = "production"
    Name        = "tf-dxg-example"
  }
}

#---------------------------------------------------------------
# Attributes Reference
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします（computed only）:
#
# - arn - Direct Connect GatewayのAmazon Resource Name (ARN)
#
# - id - Direct Connect GatewayのID
#   このIDは他のリソースとの関連付けに使用されます
#
# - owner_account_id - Direct Connect Gatewayを所有するAWSアカウントID
#   クロスアカウントでの利用時に参照可能です
#
# - tags_all - リソースに割り当てられたすべてのタグのマップ
#   プロバイダーの `default_tags` 設定ブロックから継承されたタグを含みます
#
#---------------------------------------------------------------
