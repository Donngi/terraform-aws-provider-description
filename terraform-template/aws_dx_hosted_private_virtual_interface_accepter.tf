#---------------------------------------------------------------
# Direct Connect ホスト型プライベート仮想インターフェース受け入れ
#---------------------------------------------------------------
#
# 他のAWSアカウントが作成したDirect Connectホスト型プライベート仮想
# インターフェース(VIF)の所有権を受け入れ、VPN GatewayまたはDirect
# Connect Gatewayに接続します。
#
# クロスアカウントでのDirect Connect接続を確立する際に使用されます。
# 作成側のアカウントでホスト型VIFを作成し、受け入れ側のアカウントで
# このリソースを使用して受け入れと接続を行います。
#
# AWS公式ドキュメント:
#   - ホスト型仮想インターフェースの受け入れ: https://docs.aws.amazon.com/directconnect/latest/UserGuide/accepthostedvirtualinterface.html
#   - Direct Connect仮想インターフェース: https://docs.aws.amazon.com/directconnect/latest/UserGuide/create-vif.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dx_hosted_private_virtual_interface_accepter
#
# Provider Version: 6.28.0
# Generated: 2026-01-31
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_dx_hosted_private_virtual_interface_accepter" "example" {
  #---------------------------------------------------------------
  # 必須パラメータ
  #---------------------------------------------------------------

  # 受け入れる仮想インターフェースのID
  # - 作成側のアカウントで aws_dx_hosted_private_virtual_interface リソースにより
  #   作成されたVIFのIDを指定します
  # - 形式: dxvif-xxxxxxxx
  # - VIFは受け入れ可能な状態（pending状態）である必要があります
  # - 変更時は新しいリソースが作成されます
  virtual_interface_id = "dxvif-12345678"

  #---------------------------------------------------------------
  # オプションパラメータ
  #---------------------------------------------------------------

  # 接続先のDirect Connect Gateway ID
  # - VIFを接続するDirect Connect GatewayのIDを指定します
  # - 形式: xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
  # - vpn_gateway_idとは排他的です（どちらか一方のみ指定可能）
  # - Direct Connect Gatewayを使用すると、複数のVPCや
  #   Transit Gatewayへの接続が可能になります
  # - 変更時は新しいリソースが作成されます
  dx_gateway_id = null

  # 接続先のVPN Gateway ID
  # - VIFを接続する仮想プライベートゲートウェイのIDを指定します
  # - 形式: vgw-xxxxxxxx
  # - dx_gateway_idとは排他的です（どちらか一方のみ指定可能）
  # - VPN Gatewayを使用すると、単一のVPCへの接続が可能になります
  # - VPN GatewayはVPCにアタッチされている必要があります
  # - 変更時は新しいリソースが作成されます
  vpn_gateway_id = null

  # リソースID
  # - 通常は指定不要です（自動的に割り当てられます）
  # - インポート時など特定のケースでのみ使用します
  # - 未指定の場合はvirtual_interface_idと同じ値が設定されます
  id = null

  # リソースに付与するタグ
  # - キーと値のペアで任意のメタデータを付与できます
  # - プロバイダーのdefault_tagsと統合されます
  # - 同じキーの場合、リソースレベルのタグがプロバイダーレベルを上書きします
  # - クロスアカウント管理の場合、作成側アカウントや受け入れ側アカウントの
  #   識別情報をタグに含めることを推奨します
  tags = {
    Name        = "example-vif-accepter"
    Environment = "production"
    ManagedBy   = "Terraform"
  }

  # 全てのタグ（プロバイダーのdefault_tagsを含む）
  # - 通常は指定不要です（自動的に計算されます）
  # - リソースのtagsとプロバイダーのdefault_tagsがマージされた結果が設定されます
  # - 特定のユースケースでのみ明示的に指定します
  tags_all = null

  # リソースを管理するAWSリージョン
  # - 明示的にリージョンを指定する場合に使用します
  # - 未指定の場合はプロバイダー設定のリージョンが使用されます
  # - 受け入れ側のゲートウェイ（VPN GatewayまたはDirect Connect Gateway）が
  #   存在するリージョンと一致させる必要があります
  region = null

  #---------------------------------------------------------------
  # タイムアウト設定
  #---------------------------------------------------------------

  timeouts {
    # VIFの受け入れとアタッチメント処理のタイムアウト時間
    # - デフォルト: 10m
    # - VIFの受け入れとゲートウェイへのアタッチメントが完了するまでの待機時間
    # - ネットワーク条件や環境により時間がかかる場合は延長を検討してください
    create = "10m"

    # VIFのデタッチと削除処理のタイムアウト時間
    # - デフォルト: 10m
    # - VIFのゲートウェイからのデタッチと削除が完了するまでの待機時間
    # - ネットワーク条件や環境により時間がかかる場合は延長を検討してください
    delete = "10m"
  }
}

#---------------------------------------------------------------
# Attributes Reference（参照専用属性）
#---------------------------------------------------------------
# このリソースでは以下の属性が参照可能です（computed属性）:
#
# - id (string)
#   仮想インターフェースのID
#   virtual_interface_idと同じ値が設定されます
#
# - arn (string)
#   仮想インターフェースのARN
#   形式: arn:aws:directconnect:<region>:<account-id>:dxvif/<vif-id>
#   IAMポリシーやリソースベースポリシーで使用できます
#
# - tags_all (map of strings)
#   リソースに割り当てられた全てのタグ
#   リソースのtagsとプロバイダーのdefault_tagsをマージした結果が含まれます
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# 使用例
#---------------------------------------------------------------
#
# # クロスアカウント構成の例
#
# # 作成側アカウントのプロバイダー設定
# provider "aws" {
#   region = "us-east-1"
#   # 作成側のクレデンシャル
# }
#
# # 受け入れ側アカウントのプロバイダー設定
# provider "aws" {
#   alias  = "accepter"
#   region = "us-east-1"
#   # 受け入れ側のクレデンシャル
# }
#
# # 受け入れ側のアカウントID取得
# data "aws_caller_identity" "accepter" {
#   provider = aws.accepter
# }
#
# # 受け入れ側のVPN Gateway作成
# resource "aws_vpn_gateway" "accepter" {
#   provider = aws.accepter
#   vpc_id   = aws_vpc.accepter.id
#
#   tags = {
#     Name = "accepter-vgw"
#   }
# }
#
# # 作成側でホスト型プライベートVIFを作成
# resource "aws_dx_hosted_private_virtual_interface" "creator" {
#   connection_id    = "dxcon-zzzzzzzz"
#   owner_account_id = data.aws_caller_identity.accepter.account_id
#
#   name           = "example-vif"
#   vlan           = 4094
#   address_family = "ipv4"
#   bgp_asn        = 65000
#
#   # VPN Gatewayより先に削除される必要があります
#   depends_on = [aws_vpn_gateway.accepter]
# }
#
# # 受け入れ側でVIFを受け入れ
# resource "aws_dx_hosted_private_virtual_interface_accepter" "accepter" {
#   provider             = aws.accepter
#   virtual_interface_id = aws_dx_hosted_private_virtual_interface.creator.id
#   vpn_gateway_id       = aws_vpn_gateway.accepter.id
#
#   tags = {
#     Name = "accepted-vif"
#     Side = "Accepter"
#   }
# }
#
# # Direct Connect Gatewayを使用する例
# resource "aws_dx_gateway" "accepter" {
#   provider        = aws.accepter
#   name            = "example-dx-gateway"
#   amazon_side_asn = "64512"
# }
#
# resource "aws_dx_hosted_private_virtual_interface_accepter" "with_dx_gw" {
#   provider             = aws.accepter
#   virtual_interface_id = aws_dx_hosted_private_virtual_interface.creator.id
#   dx_gateway_id        = aws_dx_gateway.accepter.id
#
#   tags = {
#     Name = "dx-gateway-vif"
#   }
# }
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# インポート
#---------------------------------------------------------------
# 既存のホスト型プライベート仮想インターフェース受け入れリソースは
# 仮想インターフェースIDを使用してインポートできます:
#
# terraform import aws_dx_hosted_private_virtual_interface_accepter.example dxvif-33cc44dd
#
# 注意事項:
# - VIFが既に受け入れられている（available状態）必要があります
# - インポート後、terraform planで差分がないことを確認してください
# - タグやtimeouts設定はインポートされないため手動で設定が必要です
#---------------------------------------------------------------
