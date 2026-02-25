#---------------------------------------------------------------
# AWS Route 53 Key Signing Key (KSK)
#---------------------------------------------------------------
#
# Route 53 ホストゾーンのDNSSEC（Domain Name System Security Extensions）で
# 使用するKey Signing Key（KSK）を管理するリソースです。KSKはDNSSEC署名の
# 基盤となる暗号鍵で、AWS KMSによって管理される非対称キーを使用します。
#
# KSKはZone Signing Key（ZSK）に署名するために使用され、DNSKEY DNSレコードと
# DSレコードの生成に必要です。DNSSECを有効化するには、まずKSKを作成し、
# その後 aws_route53_hosted_zone_dnssec リソースでDNSSEC署名を有効化します。
#
# 注意: Route 53 DNSSECで使用するAWS KMSキーは必ずus-east-1リージョンに
# 作成する必要があります。また、KMSキーのkey_usageは"SIGN_VERIFY"、
# customer_master_key_specは"ECC_NIST_P256"を指定してください。
#
# AWS公式ドキュメント:
#   - Route 53 DNSSEC設定: https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/dns-configuring-dnssec.html
#   - KSKの管理: https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/dns-configuring-dnssec-ksk.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_key_signing_key
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_route53_key_signing_key" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: Key Signing Keyの名前を指定します。
  # 設定可能な値: 3〜128文字の英数字、ハイフン（-）またはアンダースコア（_）
  # 注意: 同一ホストゾーン内でKSK名は一意である必要があります。
  name = "example"

  # hosted_zone_id (Required)
  # 設定内容: KSKを関連付けるRoute 53ホストゾーンのIDを指定します。
  # 設定可能な値: 有効なRoute 53ホストゾーンID文字列
  # 関連リソース: aws_route53_zone
  hosted_zone_id = aws_route53_zone.example.id

  # key_management_service_arn (Required)
  # 設定内容: KSKの署名に使用するAWS KMSキーのARNを指定します。
  # 設定可能な値: AWS KMSキーのARN（us-east-1リージョンに配置されたキーのみ有効）
  # 注意: KMSキーは以下の条件を満たす必要があります:
  #   - リージョン: us-east-1（Route 53 DNSSECはus-east-1のKMSキーのみサポート）
  #   - key_usage: "SIGN_VERIFY"
  #   - customer_master_key_spec: "ECC_NIST_P256"
  #   - KMSキーポリシーでRoute 53サービスへのアクセスを許可すること
  # 関連リソース: aws_kms_key
  key_management_service_arn = aws_kms_key.example.arn

  #-------------------------------------------------------------
  # ステータス設定
  #-------------------------------------------------------------

  # status (Optional)
  # 設定内容: Key Signing Keyのステータスを指定します。
  # 設定可能な値:
  #   - "ACTIVE": KSKを有効にしてDNSSEC署名に使用する（デフォルト）
  #   - "INACTIVE": KSKを無効にしてDNSSEC署名には使用しない
  # 省略時: "ACTIVE"
  # 注意: ホストゾーンで有効なKSKが少なくとも1つ必要です。
  #       最後のアクティブなKSKを無効化しようとするとエラーになります。
  status = "ACTIVE"

  #-------------------------------------------------------------
  # タイムアウト設定 (Optional)
  #-------------------------------------------------------------
  # timeouts {
  #   # create (Optional)
  #   # 設定内容: リソース作成操作のタイムアウト時間を指定します。
  #   # 設定可能な値: 時間文字列（例: "30m", "1h"）
  #   # 省略時: デフォルトのタイムアウトが適用されます
  #   create = "30m"
  #
  #   # update (Optional)
  #   # 設定内容: リソース更新操作のタイムアウト時間を指定します。
  #   # 設定可能な値: 時間文字列（例: "30m", "1h"）
  #   # 省略時: デフォルトのタイムアウトが適用されます
  #   update = "30m"
  #
  #   # delete (Optional)
  #   # 設定内容: リソース削除操作のタイムアウト時間を指定します。
  #   # 設定可能な値: 時間文字列（例: "30m", "1h"）
  #   # 省略時: デフォルトのタイムアウトが適用されます
  #   delete = "30m"
  # }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: ホストゾーンIDとKSK名を組み合わせた識別子
# - digest_algorithm_mnemonic: ダイジェストアルゴリズムのニーモニック（例: "SHA-256"）
# - digest_algorithm_type: ダイジェストアルゴリズムの番号
# - digest_value: DSレコードのダイジェスト値（16進数文字列）
# - dnskey_record: DNSKEYレコードの文字列表現
# - ds_record: DSレコードの文字列表現
# - flag: DNSKEYレコードのフラグフィールドの値
# - key_tag: DNSKEYレコードのキータグ値
# - public_key: KSKの公開鍵（Base64エンコード）
# - signing_algorithm_mnemonic: 署名アルゴリズムのニーモニック（例: "ECDSAP256SHA256"）
# - signing_algorithm_type: 署名アルゴリズムの番号
#
#---------------------------------------------------------------
