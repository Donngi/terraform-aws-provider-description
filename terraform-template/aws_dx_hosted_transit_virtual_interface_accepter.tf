#---------------------------------------------------------------
# AWS Direct Connect Hosted Transit Virtual Interface Accepter
#---------------------------------------------------------------
#
# Direct Connect Hosted Transit Virtual Interface Accepterは、
# 他のAWSアカウントによって作成されたホステッド型トランジット仮想インターフェースの
# 受け入れ側を管理するためのリソースです。
#
# このリソースは、別のAWSアカウントによって作成されたトランジット仮想インターフェースの
# 所有権を受け入れることができます。トランジット仮想インターフェースは、
# Direct Connect GatewayとTransit Gatewayを接続し、
# 単一のインターフェースを通じて複数のVPCへの接続を可能にします。
#
# 重要な注意事項:
#   - AWSでは、Direct Connectホステッド型トランジット仮想インターフェースは、
#     割り当て側(allocator)または受け入れ側(accepter)のどちらからでも削除できますが、
#     Terraformでは割り当て側からのみ削除をサポートしています。
#   - このリソースを設定から削除すると、Terraformステートからは削除されますが、
#     実際のDirect Connect仮想インターフェースは削除されません。
#   - 仮想インターフェースは受け入れ前に'pending'状態である必要があります。
#   - 受け入れ前にDirect Connect Gatewayが存在している必要があります。
#
# ユースケース:
#   - Direct Connectが一元管理されているマルチアカウントアーキテクチャ
#   - ネットワーク接続がサービスとして提供される共有サービスモデル
#   - サードパーティによって接続がプロビジョニングされるパートナーまたは顧客シナリオ
#
# 関連リソース:
#   - aws_dx_gateway: 仮想インターフェースをアタッチするDirect Connect Gateway
#   - aws_dx_hosted_transit_virtual_interface: 仮想インターフェースの作成側
#   - aws_ec2_transit_gateway: VPC接続のためのTransit Gateway
#   - aws_dx_gateway_association: Direct Connect GatewayとTransit Gatewayの関連付け
#
# AWS公式ドキュメント:
#   - Accept a hosted virtual interface: https://docs.aws.amazon.com/directconnect/latest/UserGuide/accepthostedvirtualinterface.html
#   - ConfirmTransitVirtualInterface API: https://docs.aws.amazon.com/directconnect/latest/APIReference/API_ConfirmTransitVirtualInterface.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dx_hosted_transit_virtual_interface_accepter
#
# Provider Version: 6.28.0
# Generated: 2026-01-31
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_dx_hosted_transit_virtual_interface_accepter" "example" {
  #---------------------------------------------------------------
  # 必須パラメータ
  #---------------------------------------------------------------

  # virtual_interface_id - (必須) 受け入れるDirect Connect仮想インターフェースのID
  # これは割り当て側アカウントのaws_dx_hosted_transit_virtual_interfaceリソースから
  # 返されるIDです。仮想インターフェースは受け入れ前に'pending'状態である必要があります。
  #
  # 形式: dxvif-xxxxxxxx
  # 例: "dxvif-fgputw0j"
  #
  # 制約:
  #   - 有効な仮想インターフェースIDである必要があります
  #   - 仮想インターフェースが存在し、'pending'状態である必要があります
  #   - 作成後は変更できません(変更すると新しいリソースが作成されます)
  virtual_interface_id = "dxvif-example"

  # dx_gateway_id - (必須) 仮想インターフェースを接続するDirect Connect GatewayのID
  # Direct Connect Gatewayは、トランジット仮想インターフェースのグループ化構造として機能し、
  # Transit Gatewayのアタッチポイントを提供します。
  # 仮想インターフェースを受け入れる前に、同じアカウント内に存在している必要があります。
  #
  # 形式: xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
  # 例: "12345678-1234-1234-1234-123456789012"
  #
  # 制約:
  #   - 有効なDirect Connect Gateway IDである必要があります
  #   - Gatewayは受け入れ側のアカウントに存在している必要があります
  #   - GatewayのASNは仮想インターフェースのBGP ASNと異なる必要があります
  #   - 作成後は変更できません(変更すると新しいリソースが作成されます)
  #
  # ベストプラクティス:
  #   - 仮想インターフェースを受け入れる前にDirect Connect Gatewayを作成してください
  #   - Transit Gatewayまたは接続ドメインごとに専用のゲートウェイを使用してください
  #   - 競合を避けるためASNの計画を検討してください
  dx_gateway_id = aws_dx_gateway.example.id

  #---------------------------------------------------------------
  # オプションパラメータ
  #---------------------------------------------------------------

  # region - (オプション) このリソースが管理されるリージョン
  # 仮想インターフェースが受け入れられるAWSリージョンを指定します。
  # デフォルトはAWSプロバイダーで設定されたリージョンです。
  #
  # マルチリージョンデプロイメントや、プロバイダーリージョンが
  # 希望する仮想インターフェースリージョンと異なる場合に有用です。
  #
  # 例: "us-east-1"
  #
  # 制約:
  #   - 有効なAWSリージョン識別子である必要があります
  #   - Direct Connect Gatewayがこのリージョンからアクセス可能である必要があります
  #
  # デフォルト: プロバイダーリージョン
  #
  # 注意: Direct Connectはグローバルサービスですが、
  # 仮想インターフェースはリージョン固有のリソースです
  # region = "us-east-1"

  # tags - (オプション) リソースに割り当てるタグのマップ
  # タグはリソースの整理と管理のためのメタデータを提供します。
  # コスト配分、自動化、リソース分類に有用です。
  #
  # 例:
  # tags = {
  #   Name        = "prod-transit-vif-accepter"
  #   Environment = "production"
  #   ManagedBy   = "Terraform"
  #   Side        = "Accepter"
  #   CostCenter  = "networking"
  #   Owner       = "network-team@example.com"
  # }
  #
  # ベストプラクティス:
  #   - 識別タグを含めてください(Name、Environment)
  #   - 所有権と管理メタデータを追加してください
  #   - リソース全体で一貫したタグ戦略を使用してください
  #   - 作成側と区別するため"Side = Accepter"でタグ付けしてください
  #   - 請求追跡用のコスト配分タグを含めてください
  #
  # 注意: プロバイダーのdefault_tags設定ブロックが設定されている場合、
  # 一致するキーを持つタグはプロバイダーレベルのタグを上書きします
  tags = {
    Name        = "example-transit-vif-accepter"
    Environment = "development"
    ManagedBy   = "Terraform"
    Side        = "Accepter"
  }

  #---------------------------------------------------------------
  # Timeouts
  #---------------------------------------------------------------

  # timeouts - (オプション) リソース操作のタイムアウト設定ブロック
  # create操作とdelete操作のタイムアウト時間をカスタマイズできます。
  # これらのタイムアウトは、AWS Direct Connect APIとの通信と、
  # インターフェースが目的の状態に到達するまでの時間を考慮します。
  #
  # timeouts {
  #   # create - (オプション) 仮想インターフェースの受け入れのタイムアウト
  #   # デフォルト: 10分
  #   #
  #   # create操作には以下が含まれます:
  #   # - AWS Direct Connectへの確認の送信
  #   # - インターフェースが利用可能になるまでの待機
  #   # - Direct Connect Gatewayへのアタッチ
  #   #
  #   # 受け入れ時にタイムアウトの問題が発生する場合は増やしてください
  #   create = "10m"
  #
  #   # delete - (オプション) accepterリソースの削除のタイムアウト
  #   # デフォルト: 10分
  #   #
  #   # 注意: これはTerraformステートからリソースを削除するだけです。
  #   # 実際の仮想インターフェースの削除は、
  #   # aws_dx_hosted_transit_virtual_interfaceを使用して
  #   # 割り当て側から実行する必要があります
  #   #
  #   # このタイムアウトは通常、ステート削除に十分です
  #   delete = "10m"
  # }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id - 仮想インターフェースのID
#   形式: dxvif-xxxxxxxx
#   virtual_interface_id入力と同じ
#   リソース識別とクロスリファレンスに使用されます
#
# - arn - 仮想インターフェースのARN
#   形式: arn:aws:directconnect:region:account-id:dxvif/dxvif-xxxxxxxx
#   IAMポリシーとクロスアカウント参照に使用されます
#   リージョンとアカウント情報を含みます
#
# - tags_all - リソースに割り当てられたすべてのタグのマップ
#   明示的に設定されたタグと継承されたdefault_tagsの両方を含みます
#   リソースのすべての有効なタグを追跡するのに有用です
#
# 使用例:
# output "vif_id" {
#   value = aws_dx_hosted_transit_virtual_interface_accepter.example.id
# }
#
# output "vif_arn" {
#   value = aws_dx_hosted_transit_virtual_interface_accepter.example.arn
# }
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# 使用例
#---------------------------------------------------------------
#
# 例1: マルチアカウント トランジット仮想インターフェース
# ---------------------------------------------------
# シナリオ: 中央ネットワークアカウントからトランジット仮想インターフェースを受け入れ、
# 受け入れ側アカウントのDirect Connect Gatewayに接続する
#
# # 受け入れ側アカウントのプロバイダー設定
# provider "aws" {
#   alias  = "accepter"
#   region = "us-east-1"
#   # 受け入れ側アカウントの認証情報を設定
# }
#
# # 受け入れ側アカウントのDirect Connect Gateway
# resource "aws_dx_gateway" "accepter" {
#   provider = aws.accepter
#
#   name            = "accepter-dxgw"
#   amazon_side_asn = 64512
#
#   # Amazon側ASNは仮想インターフェースで設定された
#   # BGP ASNと異なる必要があります
# }
#
# # トランジット仮想インターフェースを受け入れる
# resource "aws_dx_hosted_transit_virtual_interface_accepter" "multi_account" {
#   provider = aws.accepter
#
#   virtual_interface_id = "dxvif-from-allocator"
#   dx_gateway_id        = aws_dx_gateway.accepter.id
#
#   tags = {
#     Name        = "shared-services-transit-vif"
#     Environment = "production"
#     Account     = "accepter"
#     Side        = "Accepter"
#   }
# }
#
# 例2: Transit Gateway統合
# ---------------------------------------
# シナリオ: 受け入れた仮想インターフェースをTransit Gatewayに接続して
# VPC接続を実現する
#
# resource "aws_dx_gateway" "transit" {
#   name            = "transit-dxgw"
#   amazon_side_asn = 64512
# }
#
# resource "aws_ec2_transit_gateway" "main" {
#   description                     = "Main transit gateway"
#   default_route_table_association = "enable"
#   default_route_table_propagation = "enable"
#   amazon_side_asn                 = 64513
#
#   tags = {
#     Name = "main-tgw"
#   }
# }
#
# # Direct Connect GatewayとTransit Gatewayを関連付ける
# resource "aws_dx_gateway_association" "transit" {
#   dx_gateway_id         = aws_dx_gateway.transit.id
#   associated_gateway_id = aws_ec2_transit_gateway.main.id
#
#   # オプション: 関連付けに許可されたプレフィックスを指定
#   allowed_prefixes = [
#     "10.0.0.0/8",
#     "172.16.0.0/12",
#   ]
# }
#
# resource "aws_dx_hosted_transit_virtual_interface_accepter" "transit_integration" {
#   virtual_interface_id = "dxvif-transit-example"
#   dx_gateway_id        = aws_dx_gateway.transit.id
#
#   tags = {
#     Name             = "tgw-transit-vif"
#     TransitGateway   = aws_ec2_transit_gateway.main.id
#     ConnectivityType = "hybrid-cloud"
#   }
#
#   depends_on = [aws_dx_gateway_association.transit]
# }
#
# 例3: クロスリージョン受け入れ
# -----------------------------------
# シナリオ: プロバイダーのデフォルトとは異なるリージョンで仮想インターフェースを受け入れる
#
# resource "aws_dx_gateway" "cross_region" {
#   name            = "cross-region-dxgw"
#   amazon_side_asn = 64514
# }
#
# resource "aws_dx_hosted_transit_virtual_interface_accepter" "cross_region" {
#   virtual_interface_id = "dxvif-cross-region"
#   dx_gateway_id        = aws_dx_gateway.cross_region.id
#   region               = "eu-west-1" # リージョンを明示的に指定
#
#   tags = {
#     Name   = "eu-west-1-transit-vif"
#     Region = "eu-west-1"
#   }
# }
#
# 例4: カスタムタイムアウトの設定
# --------------------------------
# シナリオ: 低速ネットワークまたはAPIスロットリングのある環境で
# 拡張タイムアウトで仮想インターフェースを受け入れる
#
# resource "aws_dx_gateway" "custom_timeout" {
#   name            = "custom-timeout-dxgw"
#   amazon_side_asn = 64515
# }
#
# resource "aws_dx_hosted_transit_virtual_interface_accepter" "custom_timeout" {
#   virtual_interface_id = "dxvif-slow-network"
#   dx_gateway_id        = aws_dx_gateway.custom_timeout.id
#
#   timeouts {
#     create = "20m" # 低速の受け入れ用の拡張タイムアウト
#     delete = "15m"
#   }
#
#   tags = {
#     Name = "slow-network-transit-vif"
#   }
# }
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# ベストプラクティス
#---------------------------------------------------------------
#
# 1. ライフサイクル管理:
#    - 仮想インターフェースを受け入れる前にDirect Connect Gatewayを作成する
#    - depends_onを使用して適切なリソースの順序を確保する
#    - 削除は割り当て側から実行する必要があることを忘れない
#    - 変更を行う際は割り当て側アカウントと調整する
#
# 2. ASN計画:
#    - Direct Connect GatewayのASNが仮想インターフェースのBGP ASNと異なることを確認する
#    - 内部使用にはプライベートASN範囲(64512-65534)を使用する
#    - 競合を避けるためASN割り当てを文書化する
#    - アカウントとリージョン間でASN割り当てを調整する
#
# 3. タグ戦略:
#    - 作成側と区別するため"Side = Accepter"でタグ付けする
#    - タグにアカウントとリージョン情報を含める
#    - 一貫した命名規則を使用する
#    - コスト配分と所有権追跡用にタグ付けする
#
# 4. セキュリティ考慮事項:
#    - 受け入れる前に仮想インターフェースIDを検証する
#    - IAMポリシーを使用してインターフェースの受け入れを制御する
#    - CloudTrailで受け入れイベントを監視する
#    - Direct Connect操作に最小権限アクセスを実装する
#
# 5. 高可用性:
#    - 複数のリージョンで仮想インターフェースを受け入れる
#    - 冗長性のために複数のDirect Connect接続を使用する
#    - フェイルオーバーシナリオを定期的にテストする
#    - インターフェースのステータスとヘルスメトリクスを監視する
#
# 6. 監視とアラート:
#    - 仮想インターフェースの状態変更を監視する
#    - 接続問題のCloudWatchアラームを設定する
#    - BGPセッションのステータスを追跡する
#    - 予期しないインターフェース削除時にアラートする
#
# 7. ドキュメント:
#    - 割り当て側アカウントとの関係を文書化する
#    - 受け入れた仮想インターフェースのインベントリを維持する
#    - BGPとルーティング設定を記録する
#    - 割り当て側アカウントの連絡先情報を保持する
#
# 8. 変更管理:
#    - 割り当て側アカウントと変更を調整する
#    - 本番環境の前に非本番環境で変更をテストする
#    - ロールバック手順を維持する
#    - 変更承認プロセスを文書化する
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# 一般的な問題とトラブルシューティング
#---------------------------------------------------------------
#
# 問題1: "Virtual interface not found"
# - 仮想インターフェースIDが正しいことを確認する
# - インターフェースが存在し、'pending'状態であることを確認する
# - インターフェースが削除されていないか、他の場所で受け入れられていないかを確認する
# - 正しいアカウントとリージョンにいることを確認する
#
# 問題2: "Direct Connect gateway not found"
# - Direct Connect Gatewayが受け入れ側アカウントに存在することを確認する
# - Gateway IDが正しいことを確認する
# - Gatewayが同じパーティション(商用/GovCloud)にあることを確認する
#
# 問題3: "ASN conflict"
# - Direct Connect GatewayのASNが仮想インターフェースのBGP ASNと異なることを確認する
# - ASNが有効な範囲(プライベートの場合は64512-65534)にあることを確認する
# - ネットワークで既に使用されているASNの使用を避ける
#
# 問題4: "Timeout during acceptance"
# - timeoutsブロックでタイムアウト値を増やす
# - AWSサービスヘルスダッシュボードを確認する
# - APIレート制限を超えていないことを確認する
# - AWS APIエンドポイントへのネットワーク接続を確認する
#
# 問題5: "Cannot delete virtual interface"
# - Terraformは実際のインターフェースを削除できないことを覚えておく
# - 削除は割り当て側から実行する必要がある
# - terraform state rmを使用してステートからのみ削除する
# - 割り当て側と調整してインターフェースを削除する
#
# 問題6: "Tags not applying"
# - プロバイダーのdefault_tags設定を確認する
# - タグ付けのためのIAM権限を確認する
# - タグのキーと値が有効であることを確認する
# - タグの伝播設定を確認する
#
#---------------------------------------------------------------
