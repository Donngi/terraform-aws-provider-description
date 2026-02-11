#---------------------------------------------------------------
# AWS WAFv2 IP Set
#---------------------------------------------------------------
#
# AWS WAFv2のIPセットをプロビジョニングするリソースです。
# IPセットは、Web ACLやルールグループで使用するIPアドレスおよび
# IPアドレス範囲のコレクションを定義します。
#
# AWS公式ドキュメント:
#   - IP Setの作成と管理: https://docs.aws.amazon.com/waf/latest/developerguide/waf-ip-set-managing.html
#   - AWS WAF 開発者ガイド: https://docs.aws.amazon.com/waf/latest/developerguide/
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_ip_set
#
# Provider Version: 6.28.0
# Generated: 2026-02-06
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_wafv2_ip_set" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Optional, Forces new resource)
  # 設定内容: IPセットのフレンドリーな名前を指定します。
  # 設定可能な値: 文字列
  # 省略時: Terraformがランダムな一意の名前を生成します。
  # 注意: name_prefixと排他的（どちらか一方のみ指定可能）
  #       IPセット作成後に名前を変更することはできません。
  name = "example-ip-set"

  # name_prefix (Optional)
  # 設定内容: IPセット名のプレフィックスを指定します。
  # 設定可能な値: 文字列。Terraformが後ろにランダムなサフィックスを追加します。
  # 注意: nameと排他的（どちらか一方のみ指定可能）
  name_prefix = null

  # description (Optional)
  # 設定内容: IPセットのフレンドリーな説明を指定します。
  # 設定可能な値: 文字列
  # 用途: IPセットを識別・管理するための説明文
  description = "Example IP set for allowing specific IP addresses"

  #-------------------------------------------------------------
  # スコープ設定
  #-------------------------------------------------------------

  # scope (Required, Forces new resource)
  # 設定内容: このIPセットがCloudFrontディストリビューション用か、
  #           リージョナルアプリケーション用かを指定します。
  # 設定可能な値:
  #   - "CLOUDFRONT": Amazon CloudFrontディストリビューションで使用
  #   - "REGIONAL": リージョナルリソース（ALB、API Gateway等）で使用
  # 注意: CLOUDFRONTを指定する場合、リージョンをUS East (N. Virginia)に
  #       設定する必要があります。
  # 参考: https://docs.aws.amazon.com/waf/latest/developerguide/waf-ip-set-managing.html
  scope = "REGIONAL"

  #-------------------------------------------------------------
  # IPアドレス設定
  #-------------------------------------------------------------

  # ip_address_version (Required, Forces new resource)
  # 設定内容: IPアドレスのバージョンを指定します。
  # 設定可能な値:
  #   - "IPV4": IPv4アドレスを使用
  #   - "IPV6": IPv6アドレスを使用
  # 注意: IPセット内のすべてのアドレスは同じバージョンである必要があります。
  ip_address_version = "IPV4"

  # addresses (Optional)
  # 設定内容: IPアドレスまたはIPアドレス範囲の配列を指定します。
  # 設定可能な値: CIDR表記のIPアドレス/範囲の配列
  #   - IPv4例: "192.0.2.44/32" (単一IP), "192.0.2.0/24" (範囲)
  #   - IPv6例: "2620:0:2d0:200:0:0:0:0/128" (単一IP), "2620:0:2d0:200::/64" (範囲)
  # 省略時: 空の配列（IPアドレスなし）
  # 関連機能: AWS WAF IPセット
  #   すべてのアドレスはCIDR表記で指定する必要があります。
  #   AWS WAFはすべてのIPv4およびIPv6 CIDR範囲をサポートしますが、
  #   /0は除きます。
  #   - https://docs.aws.amazon.com/waf/latest/developerguide/waf-ip-set-managing.html
  addresses = ["1.2.3.4/32", "5.6.7.8/32"]

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # 注意: scopeがCLOUDFRONTの場合、us-east-1を指定する必要があります。
  region = null

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "example-ip-set"
    Environment = "production"
  }

  # tags_all (Optional)
  # 設定内容: プロバイダーのdefault_tagsを含む全タグのマップ。
  # 注意: この属性は通常、明示的に設定しません。
  #       プロバイダーのdefault_tagsとtagsの組み合わせから自動計算されます。
  # 用途: 明示的に設定する場合は、default_tagsを上書きする場合のみ。
  # tags_all = {}
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: IPセットの一意識別子
#
# - arn: IPセットのAmazon Resource Name (ARN)
#        Web ACLやルールグループでIPセットを参照する際に使用します。
#
# - lock_token: IPセットを更新する際に使用するロックトークン。
#               楽観的ロックに使用され、同時更新の競合を防ぎます。
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
