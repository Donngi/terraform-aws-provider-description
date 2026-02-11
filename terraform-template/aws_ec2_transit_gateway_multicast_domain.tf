#---------------------------------------------------------------
# AWS EC2 Transit Gateway Multicast Domain
#---------------------------------------------------------------
#
# EC2 Transit Gateway Multicast Domainを管理するリソースです。
# Transit Gatewayのマルチキャスト機能を有効化し、複数のVPC間で
# マルチキャストトラフィックを転送できるようにします。
#
# AWS公式ドキュメント:
#   - Transit Gateway Multicast: https://docs.aws.amazon.com/vpc/latest/tgw/tgw-multicast-overview.html
#   - Working with multicast: https://docs.aws.amazon.com/vpc/latest/tgw/working-with-multicast.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_multicast_domain
#
# Provider Version: 6.28.0
# Generated: 2026-01-31
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_ec2_transit_gateway_multicast_domain" "example" {
  #-------------------------------------------------------------
  # Transit Gateway設定 (Required)
  #-------------------------------------------------------------

  # transit_gateway_id (Required)
  # 設定内容: EC2 Transit Gatewayの識別子を指定します。
  # 設定可能な値: Transit Gateway ID (例: "tgw-0123456789abcdef0")
  # 注意事項: 指定するTransit Gatewayは`multicast_support`が有効化されている
  #           必要があります。
  # 参考: https://docs.aws.amazon.com/vpc/latest/tgw/tgw-multicast-overview.html
  transit_gateway_id = "tgw-0123456789abcdef0"

  #-------------------------------------------------------------
  # リージョン設定 (Optional)
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: AWSリージョンコード（例: "us-east-1", "ap-northeast-1"）
  # 省略時: プロバイダー設定で指定されたリージョンがデフォルトで使用されます。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # マルチキャストドメイン設定 (Optional)
  #-------------------------------------------------------------

  # auto_accept_shared_associations (Optional)
  # 設定内容: クロスアカウントのサブネット関連付けを自動的に承認するかどうかを指定します。
  # 設定可能な値:
  #   - "disable": 自動承認を無効化（手動承認が必要）
  #   - "enable": 自動承認を有効化
  # 省略時: "disable"がデフォルトで使用されます
  # 用途: AWS Organizations環境で複数アカウントのサブネットを
  #       マルチキャストドメインに関連付ける場合に使用します。
  auto_accept_shared_associations = null

  # igmpv2_support (Optional)
  # 設定内容: Internet Group Management Protocol (IGMP) version 2を
  #           有効化するかどうかを指定します。
  # 設定可能な値:
  #   - "disable": IGMPv2サポートを無効化
  #   - "enable": IGMPv2サポートを有効化
  # 省略時: "disable"がデフォルトで使用されます
  # 用途: マルチキャストグループメンバーシップを動的に管理する場合に使用します。
  # 参考: https://docs.aws.amazon.com/vpc/latest/tgw/working-with-multicast.html
  igmpv2_support = null

  # static_sources_support (Optional)
  # 設定内容: マルチキャストグループソースを静的に設定するサポートを
  #           有効化するかどうかを指定します。
  # 設定可能な値:
  #   - "disable": 静的ソース設定を無効化
  #   - "enable": 静的ソース設定を有効化
  # 省略時: "disable"がデフォルトで使用されます
  # 用途: マルチキャストソースを手動で設定する場合に使用します。
  #       IGMPv2と組み合わせて使用することも可能です。
  # 参考: https://docs.aws.amazon.com/vpc/latest/tgw/working-with-multicast.html
  static_sources_support = null

  #-------------------------------------------------------------
  # タグ設定 (Optional)
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: EC2 Transit Gateway Multicast Domainに付与するキー・バリュー形式のタグを指定します。
  # 設定可能な値: マップ型（map(string)）
  # 省略時: タグは付与されません
  # 注意事項: プロバイダーで`default_tags`設定ブロックが構成されている場合、
  #           キーが一致するタグはプロバイダーレベルで定義されたタグを上書きします。
  # 参考: https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  tags = {
    Name        = "example-multicast-domain"
    Environment = "production"
  }

  #-------------------------------------------------------------
  # タイムアウト設定 (Optional)
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: 特定の操作のタイムアウト時間を設定します。
  # 用途: デフォルトのタイムアウト時間を変更する必要がある場合に使用します。
  timeouts {
    # create (Optional)
    # 設定内容: リソース作成操作のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列（例: "10m", "1h"）
    # 省略時: デフォルトのタイムアウト時間が適用されます
    create = null

    # delete (Optional)
    # 設定内容: リソース削除操作のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列（例: "10m", "1h"）
    # 省略時: デフォルトのタイムアウト時間が適用されます
    delete = null
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: EC2 Transit Gateway Multicast Domainの識別子
# - arn: EC2 Transit Gateway Multicast DomainのAmazon Resource Name (ARN)
# - owner_id: EC2 Transit Gateway Multicast Domainを所有するAWSアカウントの識別子
# - tags_all: リソースに割り当てられたタグのマップ。
#             プロバイダーの`default_tags`設定ブロックから継承されたタグを含みます。
#---------------------------------------------------------------
