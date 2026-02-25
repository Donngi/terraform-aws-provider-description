#---------------------------------------------------------------
# Amazon Route 53 VPC関連付け認可
#---------------------------------------------------------------
#
# 別のAWSアカウントが所有するVPCをRoute 53プライベートホストゾーンに
# 関連付けることを認可するリソースです。
# クロスアカウントのプライベートホストゾーンとVPCの関連付けを行う際、
# ホストゾーン所有者側で認可を作成し、VPC所有者側で関連付けを実施します。
#
# AWS公式ドキュメント:
#   - クロスアカウントVPCとプライベートホストゾーンの関連付け:
#     https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/hosted-zone-private-associate-vpcs-different-accounts.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_vpc_association_authorization
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_route53_vpc_association_authorization" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # zone_id (Required)
  # 設定内容: VPCの関連付けを認可するRoute 53プライベートホストゾーンのIDを指定します。
  # 設定可能な値: 有効なRoute 53プライベートホストゾーンID
  # 関連機能: Route 53 プライベートホストゾーン
  #   クロスアカウントのVPC関連付けでは、ホストゾーン所有者がこのリソースで
  #   認可を作成した後、VPC所有者がaws_route53_zone_associationリソースで
  #   関連付けを完了させます。
  #   - https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/hosted-zone-private-associate-vpcs-different-accounts.html
  zone_id = "Z1234567890ABCDEF"

  # vpc_id (Required)
  # 設定内容: 関連付けを認可するVPCのIDを指定します。
  # 設定可能な値: 有効なVPC ID（例: vpc-12345678）
  # 関連機能: Amazon VPC
  #   指定するVPCは別のAWSアカウントが所有するVPCを指定します。
  #   VPCではDNSホスト名とDNSサポートが有効になっている必要があります。
  #   - https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/hosted-zone-private-considerations.html
  vpc_id = "vpc-12345678"

  #-------------------------------------------------------------
  # VPCリージョン設定
  #-------------------------------------------------------------

  # vpc_region (Optional)
  # 設定内容: 関連付けを認可するVPCが配置されているAWSリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: AWSプロバイダーのリージョン設定が使用されます。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  vpc_region = null

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト時間を指定します。
  # 用途: デフォルトのタイムアウト時間では不十分な場合に調整します。
  timeouts {
    # create (Optional)
    # 設定内容: 認可作成操作のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列（例: "30m", "1h"）
    # 省略時: デフォルトのタイムアウト時間が使用されます。
    create = null

    # read (Optional)
    # 設定内容: 認可読み取り操作のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列（例: "30m", "1h"）
    # 省略時: デフォルトのタイムアウト時間が使用されます。
    read = null

    # delete (Optional)
    # 設定内容: 認可削除操作のタイムアウト時間を指定します。
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
# - id: ゾーンIDとVPC IDを組み合わせた識別子（zone_id:vpc_id 形式）
#
#---------------------------------------------------------------
