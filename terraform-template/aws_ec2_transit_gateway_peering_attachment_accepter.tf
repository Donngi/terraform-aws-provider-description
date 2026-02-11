#---------------------------------------------------------------
# EC2 Transit Gateway Peering Attachment Accepter
#---------------------------------------------------------------
#
# Transit Gateway Peering Attachmentのアクセプター側を管理するリソースです。
# 他のAWSアカウントまたは同一アカウント内の別リージョンのTransit Gatewayからの
# Peering Attachment要求を承認する際に使用します。
#
# Transit Gateway Peeringは、同一リージョン内および異なるリージョン間の
# Transit Gatewayをピアリングし、IPv4とIPv6トラフィックをルーティングできます。
# Peering Attachmentを作成した後、ピアTransit Gatewayの所有者が承認する必要があります。
#
# リージョン間のトラフィックは、AES-256で暗号化されます。
#
# AWS公式ドキュメント:
#   - Transit Gateway Peering Attachments: https://docs.aws.amazon.com/vpc/latest/tgw/tgw-peering.html
#   - AcceptTransitGatewayPeeringAttachment API: https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_AcceptTransitGatewayPeeringAttachment.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_peering_attachment_accepter
#
# Provider Version: 6.28.0
# Generated: 2026-01-31
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_ec2_transit_gateway_peering_attachment_accepter" "example" {

  #---------------------------------------------------------------
  # 必須パラメータ
  #---------------------------------------------------------------

  # 承認するEC2 Transit Gateway Peering AttachmentのID
  # タイプ: string
  # 必須: true
  #
  # リクエスター側が作成したPeering AttachmentのIDを指定します。
  # このAttachmentは"pendingAcceptance"状態である必要があります。
  #
  # 例: "tgw-attach-1234567890abcdef0"
  transit_gateway_attachment_id = "tgw-attach-1234567890abcdef0"

  #---------------------------------------------------------------
  # オプションパラメータ
  #---------------------------------------------------------------

  # このリソースが管理されるリージョン
  # タイプ: string
  # デフォルト: プロバイダー設定のリージョン
  #
  # このリソースをデプロイするAWSリージョンを指定します。
  # 指定しない場合、プロバイダーの設定に基づくリージョンが使用されます。
  #
  # AWS公式ドキュメント:
  #   - Regional Endpoints: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  #
  # 例: "us-west-2", "ap-northeast-1"
  region = "us-west-2"

  # リソースタグ
  # タイプ: map(string)
  #
  # Transit Gateway Peering Attachmentに付与するキーバリュー形式のタグ。
  # プロバイダーのdefault_tags設定ブロックで定義されたタグと
  # キーが一致する場合、ここで指定したタグが優先されます。
  #
  # タグはリソースの識別、コスト管理、アクセス制御などに使用できます。
  #
  # 例:
  tags = {
    Name        = "cross-account-tgw-peering"
    Environment = "production"
    ManagedBy   = "terraform"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用)
#---------------------------------------------------------------
#
# このリソースは、以下の読み取り専用属性をエクスポートします:
#
# - id
#   EC2 Transit Gateway Attachmentの識別子
#   タイプ: string
#
# - transit_gateway_id
#   このアクセプター側のTransit Gatewayの識別子
#   タイプ: string
#
# - peer_transit_gateway_id
#   ピア側のTransit Gatewayの識別子
#   タイプ: string
#
# - peer_account_id
#   ピアTransit Gatewayを所有するAWSアカウントの識別子
#   タイプ: string
#
# - peer_region
#   ピアTransit GatewayがデプロイされているAWSリージョン
#   タイプ: string
#
# - tags_all
#   リソースに割り当てられたすべてのタグのマップ。
#   プロバイダーのdefault_tags設定ブロックから継承されたタグを含みます。
#   タイプ: map(string)
#
#---------------------------------------------------------------
