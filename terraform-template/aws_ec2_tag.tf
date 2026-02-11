#---------------------------------------------------------------
# AWS EC2 Tag
#---------------------------------------------------------------
#
# 個別のEC2リソースタグを管理するリソースです。
#
# このリソースは以下のようなケースでのみ使用すべきです:
#   - Terraform外で作成されたEC2リソース（例: AMI）にタグを付与する場合
#   - Resource Access Manager (RAM) 経由で共有されているリソースにタグを付与する場合
#   - 暗黙的に作成されたリソース（例: Transit Gateway VPN Attachments）にタグを付与する場合
#
# 注意事項:
#   - 親リソースのTerraformリソースと組み合わせて使用しないでください。
#     例えば、aws_vpc と aws_ec2_tag を使用して同じVPCのタグを管理すると、
#     aws_vpc リソースが aws_ec2_tag で追加されたタグを削除しようとし、
#     永続的な差分が発生します。
#   - このリソースはプロバイダーの `ignore_tags` 設定を使用しません。
#
# AWS公式ドキュメント:
#   - EC2 タグ付け: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/Using_Tags.html
#   - タグ付けのベストプラクティス: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/tag-resources.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_tag
#
# Provider Version: 6.28.0
# Generated: 2026-01-23
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_ec2_tag" "example" {
  #-------------------------------------------------------------
  # 必須設定
  #-------------------------------------------------------------

  # resource_id (Required)
  # 設定内容: タグを管理するEC2リソースのIDを指定します。
  # 設定可能な値: 有効なEC2リソースID
  # 用途: タグを付与する対象のEC2リソースを特定
  # 例:
  #   - VPC ID: vpc-xxxxxxxxxxxxxxxxx
  #   - Subnet ID: subnet-xxxxxxxxxxxxxxxxx
  #   - Instance ID: i-xxxxxxxxxxxxxxxxx
  #   - Transit Gateway Attachment ID: tgw-attach-xxxxxxxxxxxxxxxxx
  #   - AMI ID: ami-xxxxxxxxxxxxxxxxx
  # 関連機能: EC2 リソースのタグ付け
  #   EC2リソースにはメタデータとしてタグを付与でき、リソースの識別・管理・コスト配分に活用できます。
  #   - https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/Using_Tags.html
  resource_id = "tgw-attach-xxxxxxxxxxxxxxxxx"

  # key (Required)
  # 設定内容: タグ名（キー）を指定します。
  # 設定可能な値: 最大128文字のUnicode文字列。大文字と小文字は区別されます。
  # 制約:
  #   - "aws:" プレフィックスは予約されており、使用できません
  #   - 空文字列は使用できません
  # 関連機能: EC2 タグの命名規則
  #   タグキーは組織のタグ付け戦略に従って命名することが推奨されます。
  #   - https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/Using_Tags.html#tag-restrictions
  key = "Name"

  # value (Required)
  # 設定内容: タグの値を指定します。
  # 設定可能な値: 最大256文字のUnicode文字列。空文字列も許可されます。
  # 用途: リソースの識別情報、環境名、所有者情報など任意のメタデータを格納
  # 関連機能: EC2 タグ値
  #   タグ値はリソースの分類、フィルタリング、コスト配分レポートに使用できます。
  #   - https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/Using_Tags.html
  value = "Example Tag Value"

  #-------------------------------------------------------------
  # オプション設定
  #-------------------------------------------------------------

  # region (Optional, Computed)
  # 設定内容: このリソースを管理するAWSリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード (例: us-east-1, ap-northeast-1)
  # 省略時: プロバイダー設定のリージョンを使用
  # 用途: 別リージョンのEC2リソースにタグを付与する場合に使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null
}

#---------------------------------------------------------------
# Transit Gateway VPN Attachment は aws_vpn_connection リソースによって
# 暗黙的に作成されるため、aws_ec2_tag を使用してタグを付与します。
#
# resource "aws_ec2_transit_gateway" "example" {}
#
# resource "aws_customer_gateway" "example" {
#   bgp_asn    = 65000
#   ip_address = "172.0.0.1"
#   type       = "ipsec.1"
# }
#
# resource "aws_vpn_connection" "example" {
#   customer_gateway_id = aws_customer_gateway.example.id
#   transit_gateway_id  = aws_ec2_transit_gateway.example.id
#   type                = aws_customer_gateway.example.type
# }
#
# resource "aws_ec2_tag" "example" {
#   resource_id = aws_vpn_connection.example.transit_gateway_attachment_id
#   key         = "Name"
#   value       = "Hello World"
# }
#---------------------------------------------------------------

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: EC2リソース識別子とキーをカンマ（,）で区切った文字列
#   例: "tgw-attach-xxxxxxxxxxxxxxxxx,Name"
#
#---------------------------------------------------------------
