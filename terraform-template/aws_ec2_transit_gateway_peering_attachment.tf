################################################################################
# Terraform AWS Provider Resource Template
################################################################################
# Resource: aws_ec2_transit_gateway_peering_attachment
# Provider Version: 6.28.0
# Template Generated: 2026-01-22
#
# Description:
#   EC2 Transit Gateway Peering Attachmentを管理します。
#   Transit Gateway間のピアリング接続を確立し、同一リージョン内または
#   リージョン間、同一アカウント内または異なるアカウント間でのトラフィック
#   ルーティングを可能にします。
#
# 注意事項:
#   - このテンプレートは生成時点(2026-01-22)の情報に基づいています
#   - 最新の仕様や詳細は公式ドキュメントを必ず確認してください
#   - ピアリングリクエストは、ピア側のTransit Gatewayのオーナーが承認する必要があります
#   - リージョン間のピアリングトラフィックはAES-256で暗号化されます
#
# AWS公式ドキュメント:
#   - Transit Gateway Peering: https://docs.aws.amazon.com/vpc/latest/tgw/tgw-peering.html
#   - API Reference: https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_CreateTransitGatewayPeeringAttachment.html
#   - Terraform Provider Docs: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_peering_attachment
################################################################################

resource "aws_ec2_transit_gateway_peering_attachment" "example" {
  # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  # Required Arguments
  # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  # transit_gateway_id - (Required) リクエスト元のEC2 Transit GatewayのID
  # ピアリング接続を開始するTransit Gatewayを指定します。
  # Type: string
  transit_gateway_id = "tgw-0123456789abcdef0"

  # peer_transit_gateway_id - (Required) ピア先のEC2 Transit GatewayのID
  # ピアリング接続先のTransit Gatewayを指定します。
  # 同一アカウント内または異なるアカウント内のTransit Gatewayを指定可能です。
  # Type: string
  peer_transit_gateway_id = "tgw-abcdef0123456789a"

  # peer_region - (Required) ピア先のEC2 Transit Gatewayが存在するAWSリージョン
  # 同一リージョン内または異なるリージョンを指定可能です。
  # Example: "us-west-2", "ap-northeast-1"
  # Type: string
  peer_region = "us-west-2"

  # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  # Optional Arguments
  # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  # peer_account_id - (Optional) ピア先のEC2 Transit GatewayのAWSアカウントID
  # 指定しない場合、現在のAWSプロバイダーが接続しているアカウントIDが使用されます。
  # クロスアカウントでのピアリング接続を行う場合に指定します。
  # Type: string
  # Default: 現在のアカウントID
  peer_account_id = "123456789012"

  # region - (Optional) このリソースが管理されるリージョン
  # 指定しない場合、プロバイダー設定のリージョンがデフォルトで使用されます。
  # マルチリージョン構成でリソースを明示的に配置する場合に使用します。
  # 参照: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # Type: string
  # Default: プロバイダー設定のリージョン
  # region = "us-east-1"

  # id - (Optional) Transit Gateway Attachmentの識別子
  # 通常は自動生成されるため、明示的に指定する必要はありません。
  # Terraform管理外で作成されたリソースをインポートする場合などに使用できます。
  # Type: string
  # Computed: true
  # id = "tgw-attach-0123456789abcdef0"

  # tags - (Optional) EC2 Transit Gateway Peering Attachmentに付与するキー・バリューのタグ
  # リソースの管理、コスト配分、アクセス制御などに使用できます。
  # プロバイダーのdefault_tagsと組み合わせて使用可能です。
  # 同じキーを持つタグはこちらが優先されます。
  # Type: map(string)
  tags = {
    Name        = "TGW Peering Requestor"
    Environment = "production"
    Project     = "network-infrastructure"
    ManagedBy   = "terraform"
  }

  # tags_all - (Optional) リソースに割り当てられたすべてのタグ
  # プロバイダーのdefault_tags設定ブロックから継承されたタグを含みます。
  # 通常は明示的に設定する必要はなく、tagsとdefault_tagsが自動的にマージされます。
  # 参照: https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  # Type: map(string)
  # Computed: true
  # tags_all = {}

  # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  # Nested Block: options
  # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  # Transit Gateway Peeringリクエストの動的ルーティングの設定を行います。
  # 最大1つのoptionsブロックを指定可能です。
  # 参照: https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_TransitGatewayPeeringAttachmentOptions.html

  options {
    # dynamic_routing - (Optional) 動的ルーティングを有効化または無効化
    # BGPを使用した動的ルーティングの設定を制御します。
    # Valid values: "enable", "disable"
    # Type: string
    # Default: 動的ルーティングなし（静的ルートのみ）
    dynamic_routing = "enable"
  }
}

################################################################################
# Computed Attributes (参照用)
################################################################################
# 以下の属性はリソース作成後に参照可能です（テンプレートには含めません）
#
# - arn (string)
#   Transit Gateway Peering AttachmentのAmazon Resource Name (ARN)
#   例: "arn:aws:ec2:us-east-1:123456789012:transit-gateway-attachment/tgw-attach-0123456789abcdef0"
#
# - state (string)
#   Attachmentの現在の状態
#   可能な値: "initiatingRequest", "pendingAcceptance", "rollingBack", "pending",
#            "available", "modifying", "deleting", "deleted", "failed", "rejected",
#            "rejecting", "failing"
#
################################################################################
# Output Example
################################################################################
# output "transit_gateway_peering_attachment_id" {
#   description = "Transit Gateway Peering AttachmentのID"
#   value       = aws_ec2_transit_gateway_peering_attachment.example.id
# }
#
# output "transit_gateway_peering_attachment_arn" {
#   description = "Transit Gateway Peering AttachmentのARN"
#   value       = aws_ec2_transit_gateway_peering_attachment.example.arn
# }
#
# output "transit_gateway_peering_attachment_state" {
#   description = "Transit Gateway Peering Attachmentの状態"
#   value       = aws_ec2_transit_gateway_peering_attachment.example.state
# }
################################################################################
