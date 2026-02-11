# ==============================================================================
# Terraform AWS Resource Template: aws_ec2_transit_gateway_vpc_attachment
# ==============================================================================
# テンプレート生成日: 2026-01-23
# Provider Version: 6.28.0
#
# 注意事項:
# - このテンプレートは生成時点の AWS Provider 仕様に基づいています
# - 最新の仕様については公式ドキュメントを確認してください
# - 全てのオプショナル属性を網羅していますが、実際の利用では必要なもののみを設定してください
# ==============================================================================

# ------------------------------------------------------------------------------
# リソース概要
# ------------------------------------------------------------------------------
# EC2 Transit Gateway VPC Attachment を管理します。
# Transit Gateway に VPC をアタッチすることで、異なる VPC 間でトラフィックを流すことができます。
# 各 Availability Zone から 1 つのサブネットを指定する必要があり、これらがトランジットゲートウェイトラフィックの
# エントリーポイントおよびエグジットポイントとして機能します。
#
# 公式ドキュメント:
# - Resource: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_vpc_attachment
# - AWS Guide: https://docs.aws.amazon.com/vpc/latest/tgw/tgw-vpc-attachments.html
# - API Reference: https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_CreateTransitGatewayVpcAttachment.html
# ------------------------------------------------------------------------------

resource "aws_ec2_transit_gateway_vpc_attachment" "example" {
  # ----------------------------------------------------------------------------
  # 必須パラメータ
  # ----------------------------------------------------------------------------

  # subnet_ids - (必須) EC2 サブネットの識別子のセット
  # Transit Gateway アタッチメントに使用するサブネット ID のリストを指定します。
  # 各 Availability Zone から 1 つのサブネットを指定する必要があります。
  # これらのサブネットが Transit Gateway トラフィックのエントリー/エグジットポイントとなります。
  # トラフィックは、Transit Gateway アタッチメントサブネットに適切なルートが設定されている場合のみ、
  # 同じ Availability Zone 内の他のサブネット内のリソースに到達できます。
  # 型: set(string)
  subnet_ids = ["subnet-12345678", "subnet-87654321"]

  # transit_gateway_id - (必須) EC2 Transit Gateway の識別子
  # VPC をアタッチする Transit Gateway の ID を指定します。
  # 型: string
  transit_gateway_id = "tgw-12345678"

  # vpc_id - (必須) EC2 VPC の識別子
  # Transit Gateway にアタッチする VPC の ID を指定します。
  # 型: string
  vpc_id = "vpc-12345678"

  # ----------------------------------------------------------------------------
  # オプションパラメータ
  # ----------------------------------------------------------------------------

  # appliance_mode_support - (オプション) Appliance Mode サポートの有効/無効
  # 有効にすると、送信元と送信先間のトラフィックフローは、そのフローの存続期間中、
  # VPC アタッチメントに対して同じ Availability Zone を使用します。
  # これは、ネットワークアプライアンス（ファイアウォール、IDS/IPS など）を使用する場合に有用です。
  # 有効な値: "disable", "enable"
  # デフォルト値: "disable"
  # 型: string
  # 参考: https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_CreateTransitGatewayVpcAttachmentRequestOptions.html
  appliance_mode_support = "disable"

  # dns_support - (オプション) DNS サポートの有効/無効
  # 有効にすると、VPC 内のインスタンスは Transit Gateway の DNS サーバーを使用して名前解決を行うことができます。
  # 有効な値: "disable", "enable"
  # デフォルト値: "enable"
  # 型: string
  # 参考: https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_CreateTransitGatewayVpcAttachmentRequestOptions.html
  dns_support = "enable"

  # ipv6_support - (オプション) IPv6 サポートの有効/無効
  # 有効にすると、VPC 内のインスタンスは IPv6 アドレスを使用できます。
  # 有効な値: "disable", "enable"
  # デフォルト値: "disable"
  # 型: string
  # 参考: https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_CreateTransitGatewayVpcAttachmentRequestOptions.html
  ipv6_support = "disable"

  # region - (オプション) このリソースが管理されるリージョン
  # このリソースを管理する AWS リージョンを指定します。
  # デフォルトでは、プロバイダー設定で指定されたリージョンが使用されます。
  # 型: string (computed)
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # 参考: https://registry.terraform.io/providers/hashicorp/aws/latest/docs#aws-configuration-reference
  # region = "us-east-1"

  # security_group_referencing_support - (オプション) セキュリティグループ参照サポートの有効/無効
  # 有効にすると、Transit Gateway にアタッチされた VPC 間でセキュリティグループを参照できるようになり、
  # セキュリティグループの管理が簡素化されます。
  # 有効な値: "disable", "enable"
  # 型: string (computed)
  # 参考: https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_CreateTransitGatewayVpcAttachmentRequestOptions.html
  security_group_referencing_support = "enable"

  # tags - (オプション) EC2 Transit Gateway VPC Attachment のキー・バリュータグ
  # リソースに割り当てるタグを指定します。
  # プロバイダーの default_tags 設定ブロックが存在する場合、一致するキーを持つタグは
  # プロバイダーレベルで定義されたタグを上書きします。
  # 型: map(string)
  # 参考: https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  tags = {
    Name        = "example-tgw-vpc-attachment"
    Environment = "production"
    ManagedBy   = "Terraform"
  }

  # tags_all - (オプション) リソースに割り当てられた全タグのマップ
  # プロバイダーの default_tags 設定ブロックから継承されたタグを含む、
  # リソースに割り当てられた全タグのマップです。
  # 型: map(string) (computed)
  # 注: 通常は Terraform が自動的に管理するため、明示的な設定は不要です
  # tags_all = {}

  # transit_gateway_default_route_table_association - (オプション) デフォルトルートテーブル関連付けの有効/無効
  # VPC アタッチメントを EC2 Transit Gateway の関連付けデフォルトルートテーブルに関連付けるかどうかを指定します。
  # Resource Access Manager で共有された EC2 Transit Gateway では、この設定やドリフト検出を行うことはできません。
  # 型: bool (computed)
  # デフォルト値: true
  transit_gateway_default_route_table_association = true

  # transit_gateway_default_route_table_propagation - (オプション) デフォルトルートテーブル伝播の有効/無効
  # VPC アタッチメントが EC2 Transit Gateway の伝播デフォルトルートテーブルにルートを伝播するかどうかを指定します。
  # Resource Access Manager で共有された EC2 Transit Gateway では、この設定やドリフト検出を行うことはできません。
  # 型: bool (computed)
  # デフォルト値: true
  transit_gateway_default_route_table_propagation = true

  # id - (オプション) EC2 Transit Gateway Attachment 識別子
  # Terraform によって自動的に設定される属性です。
  # 通常は明示的に指定する必要はありませんが、既存のリソースをインポートする際に使用できます。
  # 型: string (computed)
  # id = "tgw-attach-12345678"
}

# ==============================================================================
# Computed-only 属性（出力のみで設定不可）
# ==============================================================================
# 以下の属性は Terraform によって自動的に計算され、outputs で参照できますが、
# リソース定義内では設定できません:
#
# - arn: アタッチメントの ARN
#   型: string
#   例: arn:aws:ec2:us-east-1:123456789012:transit-gateway-attachment/tgw-attach-12345678
#
# - vpc_owner_id: EC2 VPC を所有する AWS アカウントの識別子
#   型: string
#   例: 123456789012
# ==============================================================================

# ==============================================================================
# 出力例
# ==============================================================================
# output "transit_gateway_vpc_attachment_id" {
#   description = "Transit Gateway VPC Attachment の ID"
#   value       = aws_ec2_transit_gateway_vpc_attachment.example.id
# }
#
# output "transit_gateway_vpc_attachment_arn" {
#   description = "Transit Gateway VPC Attachment の ARN"
#   value       = aws_ec2_transit_gateway_vpc_attachment.example.arn
# }
#
# output "vpc_owner_id" {
#   description = "VPC を所有する AWS アカウント ID"
#   value       = aws_ec2_transit_gateway_vpc_attachment.example.vpc_owner_id
# }
# ==============================================================================
