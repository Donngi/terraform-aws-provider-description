#---------------------------------------------------------------
# Amazon Route 53 Hosted Zone VPC Association
#---------------------------------------------------------------
#
# Route 53のプライベートホストゾーンとVPCの関連付けを管理するリソースです。
# VPCの関連付けはプライベートホストゾーンにのみ作成できます。
# クロスアカウントの関連付けを行う場合は、aws_route53_vpc_association_authorization
# リソースを合わせて使用してください。
#
# 注意: 明示的な関連付け順序が必要な場合（例: クロスアカウントの関連付け承認）を除き、
#       このリソースの使用は推奨されません。代わりに aws_route53_zone リソース内の
#       vpc 設定ブロックを使用してください。
#
# AWS公式ドキュメント:
#   - プライベートホストゾーンの使用: https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/hosted-zones-private.html
#   - 別アカウントのVPCとの関連付け: https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/hosted-zone-private-associate-vpcs-different-accounts.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_zone_association
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_route53_zone_association" "example" {
  #-------------------------------------------------------------
  # ホストゾーンとVPCの関連付け設定
  #-------------------------------------------------------------

  # zone_id (Required)
  # 設定内容: 関連付けるプライベートホストゾーンのIDを指定します。
  # 設定可能な値: 有効なRoute 53プライベートホストゾーンID
  # 注意: パブリックホストゾーンへの関連付けはサポートされていません。
  #       プライベートホストゾーンにのみ使用できます。
  zone_id = "Z1D633PJN98FT9"

  # vpc_id (Required)
  # 設定内容: プライベートホストゾーンに関連付けるVPCのIDを指定します。
  # 設定可能な値: 有効なVPC ID
  # 注意: VPCではDNSホスト名とDNSサポートを有効にする必要があります。
  #       aws_route53_zone リソースの vpc ブロックで指定したVPCと同じVPCを
  #       このリソースでも指定すると、永続的な差分が発生する場合があります。
  #   - https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/hosted-zone-private-considerations.html
  vpc_id = "vpc-12345678"

  # vpc_region (Optional)
  # 設定内容: 関連付けるVPCが存在するAWSリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: AWSプロバイダーに設定されているリージョンが使用されます。
  # 用途: AWSプロバイダーとは異なるリージョンのVPCを関連付ける場合に指定します。
  vpc_region = null

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト時間を指定します。
  # 用途: デフォルトのタイムアウト時間では不十分な場合に調整します。
  timeouts {
    # create (Optional)
    # 設定内容: VPC関連付け作成操作のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列（例: "30m", "1h"）
    # 省略時: デフォルトのタイムアウト時間が使用されます。
    create = null

    # delete (Optional)
    # 設定内容: VPC関連付け削除操作のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列（例: "30m", "1h"）
    # 省略時: デフォルトのタイムアウト時間が使用されます。
    delete = null
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: 関連付けのユニーク識別子（ゾーンID、VPC ID、VPCリージョンから算出）
#
# - owning_account: ホストゾーンを作成したアカウントのAWSアカウントID
#---------------------------------------------------------------
