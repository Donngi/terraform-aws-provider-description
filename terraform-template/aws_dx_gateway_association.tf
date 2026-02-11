#---------------------------------------------------------------
# AWS Direct Connect Gateway Association
#---------------------------------------------------------------
#
# Direct Connect GatewayをVirtual Private Gateway (VGW) または
# Transit Gatewayに関連付けるリソースです。
#
# このリソースは以下の2つのユースケースで使用できます:
#   1. 単一アカウント関連付け: 同一アカウント内のVGW/Transit Gatewayを関連付け
#   2. クロスアカウント関連付け: 別アカウントのVGW/Transit Gatewayを関連付け
#      (proposal_idとassociated_gateway_owner_account_idを使用)
#
# AWS公式ドキュメント:
#   - Direct Connect Gateway 概要: https://docs.aws.amazon.com/directconnect/latest/UserGuide/direct-connect-gateways.html
#   - Direct Connect Gateway 関連付け: https://docs.aws.amazon.com/directconnect/latest/UserGuide/direct-connect-gateways-intro.html
#   - Direct Connect API リファレンス: https://docs.aws.amazon.com/directconnect/latest/APIReference/Welcome.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dx_gateway_association
#
# Provider Version: 6.28.0
# Generated: 2026-01-22
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_dx_gateway_association" "example" {
  #-------------------------------------------------------------
  # 必須設定
  #-------------------------------------------------------------

  # dx_gateway_id (Required)
  # 設定内容: 関連付けを行うDirect Connect GatewayのIDを指定します。
  # 設定可能な値: 有効なDirect Connect Gateway ID
  # 用途: 関連付けの対象となるDirect Connect Gatewayを識別
  # 関連機能: Direct Connect Gateway
  #   オンプレミスネットワークから複数のVPCへの接続を可能にするグローバルリソース。
  #   - https://docs.aws.amazon.com/directconnect/latest/UserGuide/direct-connect-gateways.html
  dx_gateway_id = aws_dx_gateway.example.id

  #-------------------------------------------------------------
  # 単一アカウント関連付けの設定
  #-------------------------------------------------------------

  # associated_gateway_id (Optional, Computed)
  # 設定内容: 関連付けるVGWまたはTransit GatewayのIDを指定します。
  # 設定可能な値: VGW ID (vgw-xxxxxxxx) または Transit Gateway ID (tgw-xxxxxxxx)
  # 用途: 単一アカウント内でDirect Connect Gatewayを関連付ける場合に使用
  # 注意: dx_gateway_idと組み合わせて、単一アカウント関連付けの場合に必須
  # 注意: associated_gateway_idが別リージョンにある場合、そのリージョン用の
  #       プロバイダーエイリアスを指定する必要があります
  # 関連機能: VPN Gateway / Transit Gateway
  #   VGW: VPCへのプライベート接続を提供
  #   Transit Gateway: 複数のVPCとオンプレミスネットワークを接続するハブ
  #   - https://docs.aws.amazon.com/directconnect/latest/UserGuide/virtualgateways.html
  associated_gateway_id = aws_vpn_gateway.example.id

  #-------------------------------------------------------------
  # クロスアカウント関連付けの設定
  #-------------------------------------------------------------

  # associated_gateway_owner_account_id (Optional, Computed)
  # 設定内容: VGWまたはTransit Gatewayを所有するAWSアカウントのIDを指定します。
  # 設定可能な値: 12桁のAWSアカウントID
  # 用途: クロスアカウントDirect Connect Gateway関連付けの場合に使用
  # 注意: クロスアカウント関連付けの場合、proposal_idと組み合わせて必須
  # 関連機能: クロスアカウント関連付け
  #   異なるAWSアカウント間でDirect Connect Gatewayを共有して使用可能。
  #   - https://docs.aws.amazon.com/directconnect/latest/UserGuide/multi-account-associate-vgw.html
  associated_gateway_owner_account_id = null

  # proposal_id (Optional)
  # 設定内容: Direct Connect Gateway関連付け提案のIDを指定します。
  # 設定可能な値: 有効な関連付け提案ID
  # 用途: クロスアカウントDirect Connect Gateway関連付けを承認する場合に使用
  # 注意: aws_dx_gateway_association_proposalリソースで作成された提案のIDを指定
  # 関連機能: 関連付け提案
  #   VGW/Transit Gateway所有アカウントが提案を作成し、
  #   Direct Connect Gateway所有アカウントが承認するワークフロー。
  #   - https://docs.aws.amazon.com/directconnect/latest/UserGuide/multi-account-associate-vgw.html
  proposal_id = null

  #-------------------------------------------------------------
  # ルーティング設定
  #-------------------------------------------------------------

  # allowed_prefixes (Optional, Computed)
  # 設定内容: Direct Connect Gatewayにアドバタイズするプレフィックス (CIDRブロック) を指定します。
  # 設定可能な値: CIDRブロックのセット (例: ["10.0.0.0/8", "172.16.0.0/12"])
  # 省略時: VGWの場合、関連付けられたVPCのCIDRブロックがデフォルトで使用されます
  # 用途: オンプレミスネットワークへアドバタイズするルートを制御
  # 注意: ドリフト検出を有効にするには、明示的に設定する必要があります
  # 関連機能: BGPルーティング
  #   Direct Connect経由でアドバタイズするプレフィックスを制御。
  #   - https://docs.aws.amazon.com/directconnect/latest/UserGuide/allowed-to-prefixes.html
  allowed_prefixes = [
    "10.255.255.0/30",
    "10.255.255.8/30",
  ]

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional, Computed)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード (例: us-east-1, ap-northeast-1)
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  # id (Optional, Computed)
  # 設定内容: リソースのID
  # 注意: 通常は明示的に設定する必要はありません。Terraformが自動管理します
  # id = null

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト値を設定します。
  # 用途: 関連付けの作成・更新・削除が完了するまでの待機時間を制御
  # 関連機能: Direct Connect Gateway関連付けの操作には時間がかかることがあります
  timeouts {
    # create (Optional)
    # 設定内容: リソース作成のタイムアウト値を指定します。
    # 設定可能な値: 時間文字列 (例: "30m", "1h")
    # 省略時: デフォルトのタイムアウト値を使用
    # 注意: Direct Connect Gateway関連付けの作成には数分から数十分かかることがあります
    create = "30m"

    # update (Optional)
    # 設定内容: リソース更新のタイムアウト値を指定します。
    # 設定可能な値: 時間文字列 (例: "30m", "1h")
    # 省略時: デフォルトのタイムアウト値を使用
    update = "30m"

    # delete (Optional)
    # 設定内容: リソース削除のタイムアウト値を指定します。
    # 設定可能な値: 時間文字列 (例: "30m", "1h")
    # 省略時: デフォルトのタイムアウト値を使用
    delete = "30m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - associated_gateway_type: 関連付けられたゲートウェイのタイプ
#   設定可能な値: "transitGateway" または "virtualPrivateGateway"
#
# - dx_gateway_association_id: Direct Connect Gateway関連付けのID
#
# - dx_gateway_owner_account_id: Direct Connect Gatewayを所有するAWSアカウントのID
#
# - transit_gateway_attachment_id: Transit Gateway接続の場合の
#   Transit Gateway AttachmentのID。ゲートウェイタイプが"transitGateway"の場合のみ設定
#
#---------------------------------------------------------------

#---------------------------------------------------------------
#
# resource "aws_dx_gateway" "example" {
#   name            = "example"
#   amazon_side_asn = "64512"
# }
#
# resource "aws_vpc" "example" {
#---------------------------------------------------------------
