#---------------------------------------------------------------
# AWS WAF IPSet (Classic)
#---------------------------------------------------------------
#
# AWS WAF ClassicのIPSetリソースをプロビジョニングします。
# IPSetは、Webリクエストの送信元IPアドレスに基づいてリクエストを
# 許可またはブロックするための条件を定義します。
#
# 注意: このリソースはAWS WAF Classicリソースです。
#       新規作成の場合は、AWS WAFv2リソース(aws_wafv2_ip_set)の
#       使用が推奨されます。
#
# AWS公式ドキュメント:
#   - AWS WAF Classic開発者ガイド: https://docs.aws.amazon.com/waf/latest/developerguide/classic-waf-chapter.html
#   - IP一致条件の作成: https://docs.aws.amazon.com/waf/latest/developerguide/classic-web-acl-ip-conditions.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/waf_ipset
#
# Provider Version: 6.28.0
# Generated: 2026-02-05
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_waf_ipset" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: IPSetの名前または説明を指定します。
  # 設定可能な値: 任意の文字列
  # 注意: AWS WAFコンソールやAPIでIPSetを識別するために使用されます。
  name = "my-ipset"

  #-------------------------------------------------------------
  # IPアドレス設定
  #-------------------------------------------------------------

  # ip_set_descriptors (Optional)
  # 設定内容: Webリクエストの送信元IPアドレスとして許可またはブロックする
  #           IPアドレス範囲を指定します。
  # 注意: 複数のip_set_descriptorsブロックを指定して、複数のIPアドレス範囲を
  #       定義できます。

  # IPv4アドレス範囲の例
  ip_set_descriptors {
    # type (Required)
    # 設定内容: IPアドレスのタイプを指定します。
    # 設定可能な値:
    #   - "IPV4": IPv4アドレス
    #   - "IPV6": IPv6アドレス
    type = "IPV4"

    # value (Required)
    # 設定内容: CIDR形式でIPアドレス範囲を指定します。
    # 設定可能な値:
    #   - IPv4の場合: /8, /16, /24, /32 のサフィックスを持つCIDR表記
    #   - IPv6の場合: /24, /32, /48, /56, /64, /128 のサフィックスを持つCIDR表記
    # 例:
    #   - "192.0.2.0/24" - 192.0.2.0から192.0.2.255までの範囲
    #   - "203.0.113.5/32" - 単一のIPアドレス203.0.113.5
    value = "192.0.2.0/24"
  }

  # 追加のIPアドレス範囲の例
  ip_set_descriptors {
    type  = "IPV4"
    value = "198.51.100.0/24"
  }

  # IPv6アドレス範囲の例
  # ip_set_descriptors {
  #   type  = "IPV6"
  #   value = "2001:db8::/32"
  # }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: WAF IPSetのID。Web ACLルールでこのIPSetを参照する際に使用します。
#
# - arn: WAF IPSetのAmazon Resource Name (ARN)。
#        IAMポリシーでこのリソースへのアクセスを制御する際に使用します。
#---------------------------------------------------------------
