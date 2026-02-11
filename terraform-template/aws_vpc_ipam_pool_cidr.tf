#---------------------------------------------------------------
# VPC IPAM Pool CIDR
#---------------------------------------------------------------
#
# IPAMアドレスプールからCIDRをプロビジョニングするリソースです。
# VPC IPAMプール内でCIDRブロックを割り当て、IPアドレス管理を効率化します。
#
# 【重要な注意事項】
# - Public IPv4/IPv6のプロビジョニングには、このリソースの範囲外の追加手順が必要です
#   （BYOIPの準備等）
# - publicly_advertisable = true のプールにプロビジョニングされるPublic IPv6 CIDR、
#   および全てのPublic IPv4 CIDRは、地域インターネットレジストリ(RIR)で
#   Route Origin Authorization (ROA)オブジェクトの作成が必要です
# - CIDRをデプロビジョニングするには、全ての割り当て(Allocation)を解放する必要があります
# - VPCによって作成された割り当ては解放に最大30分かかります
# - IPAMがVPCや他のリソースによって作成された割り当てレコードの削除を適切に管理するには、
#   単一アカウントまたは組織レベルで権限を付与する必要があります
#
# AWS公式ドキュメント:
#   - BYOIP準備手順: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-byoip.html#prepare-for-byoip
#   - IPAM権限設定: https://docs.aws.amazon.com/vpc/latest/ipam/choose-single-user-or-orgs-ipam.html
#   - リージョナルエンドポイント: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_ipam_pool_cidr
#
# Provider Version: 6.28.0
# Generated: 2026-02-05
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_vpc_ipam_pool_cidr" "example" {
  #---------------------------------------------------------------
  # IPAM設定
  #---------------------------------------------------------------

  # ipam_pool_id (Required)
  # 設定内容: CIDRを割り当てたいIPAMプールのIDを指定します。
  # 設定可能な値: 有効なIPAMプールID（例: ipam-pool-0123456789abcdef0）
  # 関連機能: VPC IPAM (IP Address Manager)
  #   VPC内のIPアドレス空間を計画、追跡、監視するための機能です。
  #   IPAMプールを作成し、そこにCIDRブロックを割り当てることで、
  #   組織全体のIPアドレス管理を一元化できます。
  #   - https://docs.aws.amazon.com/vpc/latest/ipam/what-it-is-ipam.html
  ipam_pool_id = "ipam-pool-0123456789abcdef0"

  #---------------------------------------------------------------
  # CIDR設定
  #---------------------------------------------------------------

  # cidr (Optional)
  # 設定内容: プールに割り当てたいCIDRブロックを指定します。
  # 設定可能な値: 有効なIPv4またはIPv6 CIDRブロック（例: "172.20.0.0/16", "2001:db8::/56"）
  # 注意: netmask_lengthと排他的（どちらか一方のみ指定可能）。
  #       具体的なCIDRブロックを割り当てたい場合に使用します。
  cidr = null

  # netmask_length (Optional)
  # 設定内容: 自動割り当てするCIDRのネットマスク長を指定します。
  # 設定可能な値: IPv4の場合は8-32、IPv6の場合は40-128の範囲の整数
  # 注意: cidrと排他的（どちらか一方のみ指定可能）。
  #       指定した場合、このネットマスク長で次に利用可能なCIDRが
  #       自動的にプロビジョニングされます。
  # 用途: 自動的に次の利用可能なCIDRブロックを取得したい場合に使用します。
  netmask_length = null

  #---------------------------------------------------------------
  # リージョン設定
  #---------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するAWSリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #---------------------------------------------------------------
  # リソース識別子
  #---------------------------------------------------------------

  # id (Optional)
  # 設定内容: TerraformリソースのID。
  # 注意: 通常はプロバイダーによって自動的に管理されます。
  #       明示的にインポート時などに使用する場合を除き、指定不要です。
  id = null

  #---------------------------------------------------------------
  # CIDR認証コンテキスト (BYOIPの場合に必要)
  #---------------------------------------------------------------

  # cidr_authorization_context (Optional)
  # 設定内容: BYOIP（Bring Your Own IP）を使用する際に必要な署名付きドキュメント情報。
  # 用途: 指定されたIPアドレス範囲をAmazonに持ち込む権限があることを証明します。
  # 注意: この情報はTerraform stateファイルには保存されません。
  #       Public IPv4またはPublic IPv6をプロビジョニングする場合に必要です。
  # 関連機能: BYOIP (Bring Your Own IP)
  #   自身が所有するIPアドレス範囲をAWSに持ち込む機能です。
  #   ROA（Route Origin Authorization）の作成と、
  #   署名付き認証メッセージの準備が必要です。
  #   - https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-byoip.html#prepare-for-byoip
  # cidr_authorization_context {
  #   # message (Optional)
  #   # 設定内容: プレフィックスとアカウントに対する平文の認証メッセージ。
  #   # 設定可能な値: BYOIPの準備手順で生成された認証メッセージ文字列
  #   message = null
  #
  #   # signature (Optional)
  #   # 設定内容: プレフィックスとアカウントに対する署名付き認証メッセージ。
  #   # 設定可能な値: BYOIPの準備手順で生成された署名文字列
  #   signature = null
  # }

  #---------------------------------------------------------------
  # タイムアウト設定
  #---------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト時間を指定します。
  # timeouts {
  #   # create (Optional)
  #   # 設定内容: CIDRプロビジョニング操作の最大待機時間。
  #   # 設定可能な値: 時間文字列（例: "10m", "1h"）
  #   # 省略時: デフォルトのタイムアウト時間が使用されます
  #   create = null
  #
  #   # delete (Optional)
  #   # 設定内容: CIDRデプロビジョニング操作の最大待機時間。
  #   # 設定可能な値: 時間文字列（例: "45m", "1h"）
  #   # 省略時: デフォルトのタイムアウト時間が使用されます
  #   # 注意: VPCによる割り当てが解放されるまで最大30分かかることがあるため、
  #   #       十分な時間を設定することを推奨します（例: 45m以上）。
  #   delete = null
  # }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: IPAMプールCIDR IDとIPAMプールIDを連結した文字列。
#       Terraformリソースの一意識別子として使用されます。
#
# - ipam_pool_cidr_id: AWSによって生成されたプールCIDRの一意ID。
#                      この属性はAPI呼び出しに後から追加されたため、
#                      Terraformリソースのidとしては使用されていませんが、
#                      AWS側での一意識別子として利用できます。
#---------------------------------------------------------------
