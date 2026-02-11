#---------------------------------------------------------------
# AWS EC2 Transit Gateway VPC Attachment Accepter
#---------------------------------------------------------------
#
# EC2 Transit Gateway VPC AttachmentのAccepter側を管理するリソースです。
# クロスアカウント（リクエスター側のAWSアカウントとアクセプター側のAWSアカウントが
# 異なる場合）でEC2 Transit Gateway VPC Attachmentが作成されると、
# アクセプター側のアカウントに自動的にEC2 Transit Gateway VPC Attachmentリソースが作成されます。
# リクエスター側は aws_ec2_transit_gateway_vpc_attachment リソースを使用して
# 接続の管理を行い、アクセプター側は aws_ec2_transit_gateway_vpc_attachment_accepter
# リソースを使用して接続をTerraform管理下に「採用」できます。
#
# ユースケース:
#   - クロスアカウントのVPC接続を受け入れる
#   - 受け入れた接続のルートテーブル関連付けと伝播を制御する
#   - 接続にタグを適用して管理を容易にする
#
# AWS公式ドキュメント:
#   - Transit Gateway VPC Attachments: https://docs.aws.amazon.com/vpc/latest/tgw/tgw-vpc-attachments.html
#   - Accept a shared attachment: https://docs.aws.amazon.com/vpc/latest/tgw/acccept-tgw-attach.html
#   - AcceptTransitGatewayVpcAttachment API: https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_AcceptTransitGatewayVpcAttachment.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_vpc_attachment_accepter
#
# Provider Version: 6.28.0
# Generated: 2026-01-28
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_ec2_transit_gateway_vpc_attachment_accepter" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # transit_gateway_attachment_id (Required)
  # 設定内容: 管理するEC2 Transit Gateway AttachmentのIDを指定します。
  # 設定可能な値: 有効なTransit Gateway Attachment ID（例: tgw-attach-1234567890abcdef0）
  # 注意: クロスアカウントで作成されたアタッチメントのIDを指定します。
  #       アタッチメントは "pendingAcceptance" 状態である必要があります。
  # 関連リソース: aws_ec2_transit_gateway_vpc_attachment
  #   リクエスター側のアカウントで作成されたアタッチメントのIDを使用します。
  transit_gateway_attachment_id = "tgw-attach-1234567890abcdef0"

  #-------------------------------------------------------------
  # ルートテーブル設定
  #-------------------------------------------------------------

  # transit_gateway_default_route_table_association (Optional)
  # 設定内容: VPC AttachmentをEC2 Transit Gatewayのデフォルトルートテーブルに
  #          関連付けるかどうかを指定します。
  # 設定可能な値: true（関連付ける）、false（関連付けない）
  # デフォルト値: true
  # 関連機能: Transit Gateway Route Table Association
  #   ルートテーブル関連付けにより、アタッチメントからのトラフィックが
  #   どのルートテーブルを使用してルーティングされるかが決定されます。
  #   デフォルトルートテーブルを使用しない場合は、カスタムルートテーブルを
  #   別途関連付ける必要があります。
  #   - https://docs.aws.amazon.com/vpc/latest/tgw/tgw-route-tables.html
  transit_gateway_default_route_table_association = true

  # transit_gateway_default_route_table_propagation (Optional)
  # 設定内容: VPC AttachmentからEC2 Transit Gatewayのデフォルトルートテーブルへ
  #          ルートを伝播するかどうかを指定します。
  # 設定可能な値: true（伝播する）、false（伝播しない）
  # デフォルト値: true
  # 関連機能: Transit Gateway Route Propagation
  #   ルート伝播により、VPCのCIDRブロックが自動的にTransit Gatewayの
  #   ルートテーブルに追加されます。これにより、他のアタッチメントから
  #   このVPCへのトラフィックルーティングが可能になります。
  #   カスタムルーティング設定が必要な場合は、falseに設定して
  #   手動でルートを管理することができます。
  #   - https://docs.aws.amazon.com/vpc/latest/tgw/tgw-route-tables.html
  transit_gateway_default_route_table_propagation = true

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 注意: Transit Gateway AttachmentとTransit Gatewayは同じリージョンに
  #       存在する必要があります。クロスリージョンの接続には
  #       Transit Gateway Peeringを使用します。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: EC2 Transit Gateway VPC Attachmentに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  #   タグはコスト配分、リソース管理、アクセス制御に使用できます。
  #   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  tags = {
    Name        = "example-cross-account-attachment"
    Environment = "production"
    ManagedBy   = "Terraform"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: EC2 Transit Gateway Attachmentの識別子
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#
# - appliance_mode_support: Appliance Modeサポートが有効かどうか
#   設定可能な値: "disable", "enable"
#   Appliance Modeは、ステートフルなネットワークアプライアンス（ファイアウォールなど）
#   を使用する場合に、送信トラフィックと戻りトラフィックが同じアベイラビリティゾーンを
#   通過することを保証します。
#
# - dns_support: DNSサポートが有効かどうか
#   設定可能な値: "disable", "enable"
#   DNSサポートを有効にすると、Transit Gateway経由でVPC間のDNS解決が可能になります。
#
# - security_group_referencing_support: セキュリティグループ参照サポートが有効かどうか
#   設定可能な値: "disable", "enable"
#   セキュリティグループ参照を有効にすると、同じTransit Gatewayに接続された
#   VPC間でセキュリティグループIDを相互参照できるようになります。
#
#---------------------------------------------------------------
