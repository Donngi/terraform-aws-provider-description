#---------------------------------------------------------------
# AWS Route53 Domains Delegation Signer Record
#---------------------------------------------------------------
#
# Route53に登録されたドメインの親DNS ZoneにDelegation Signer（DS）レコードを
# プロビジョニングするリソースです。DSレコードはDNSSECの信頼チェーンを確立するために
# 使用され、上位TLDレジストリに公開鍵情報を登録します。
#
# AWS公式ドキュメント:
#   - DNSSECの有効化と信頼チェーンの確立: https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/dns-configuring-dnssec-enable-signing.html
#   - ドメインのDNSSEC設定: https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/domain-configure-dnssec.html
#   - AssociateDelegationSignerToDomain APIリファレンス: https://docs.aws.amazon.com/Route53/latest/APIReference/API_domains_AssociateDelegationSignerToDomain.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53domains_delegation_signer_record
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_route53domains_delegation_signer_record" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # domain_name (Required)
  # 設定内容: 親DNS ZoneにDSレコードを追加するドメイン名を指定します。
  # 設定可能な値: Route53に登録済みの有効なドメイン名（例: example.com）
  # 注意: DSレコードの追加はDNSSEC検証に影響を与えるため、正しい順序と
  #       タイミングで実施しないとドメインがインターネットで利用不能になる場合があります。
  domain_name = "example.com"

  #-------------------------------------------------------------
  # DNSSEC署名属性設定
  #-------------------------------------------------------------

  # signing_attributes (Required)
  # 設定内容: DSレコードに登録するDNSSECキーの署名属性を指定するブロックです。
  # 注意: `aws_route53_key_signing_key` リソースの属性値を参照して設定することを推奨します。
  # 参考: https://docs.aws.amazon.com/Route53/latest/APIReference/API_domains_DnssecSigningAttributes.html
  signing_attributes {

    # algorithm (Required)
    # 設定内容: 公開鍵からダイジェストを生成するために使用されたアルゴリズムの番号を指定します。
    # 設定可能な値: IANAが割り当てたアルゴリズム番号（整数）
    #   - 13: ECDSAP256SHA256（Route53がDNSサービスの場合に推奨）
    #   - 14: ECDSAP384SHA384
    #   - 8: RSASHA256 等
    # 参考: https://docs.aws.amazon.com/Route53/latest/APIReference/API_domains_DnssecSigningAttributes.html
    algorithm = 13

    # flags (Required)
    # 設定内容: キーのタイプを定義するフラグ値を指定します。
    # 設定可能な値:
    #   - 257: KSK（Key-Signing-Key）。レジストリへの登録にはKSKを推奨
    #   - 256: ZSK（Zone-Signing-Key）
    # 参考: https://docs.aws.amazon.com/Route53/latest/APIReference/API_domains_DnssecKey.html
    flags = 257

    # public_key (Required)
    # 設定内容: レジストリに渡すキーペアのBase64エンコードされた公開鍵部分を指定します。
    # 設定可能な値: Base64エンコードされた文字列（最大32768文字）
    # 参考: https://docs.aws.amazon.com/Route53/latest/APIReference/API_domains_DnssecSigningAttributes.html
    public_key = "BASE64_ENCODED_PUBLIC_KEY"
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト時間を設定するブロックです。
  timeouts {

    # create (Optional)
    # 設定内容: リソース作成操作のタイムアウト時間を指定します。
    # 設定可能な値: 時間を表す文字列（例: "30s", "5m", "2h"）
    #   使用可能な単位: "s"（秒）, "m"（分）, "h"（時間）
    # 省略時: プロバイダーのデフォルトタイムアウトを使用
    create = "30m"

    # delete (Optional)
    # 設定内容: リソース削除操作のタイムアウト時間を指定します。
    # 設定可能な値: 時間を表す文字列（例: "30s", "5m", "2h"）
    #   使用可能な単位: "s"（秒）, "m"（分）, "h"（時間）
    # 省略時: プロバイダーのデフォルトタイムアウトを使用
    delete = "30m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - dnssec_key_id: AssociateDelegationSignerToDomainによって作成された
#                  DSレコードに割り当てられたID。
#
# - id: リソースの識別子。
#---------------------------------------------------------------
