#---------------------------------------------------------------
# Amazon SES Domain Identity Verification
#---------------------------------------------------------------
#
# SESドメインアイデンティティの検証完了を表すリソースです。
# このリソースは、SESドメインアイデンティティの検証ワークフローの一部を実装します。
# 通常、aws_ses_domain_identity、aws_route53_record、aws_ses_domain_identity_verification
# を組み合わせて使用し、以下のワークフローを実現します:
#   1. SESドメインアイデンティティをリクエスト
#   2. 必要なDNS検証レコードをデプロイ
#   3. 検証の完了を待機
#
# 重要な注意事項:
#   - このリソースは実際のAWSエンティティを表すものではありません
#   - このリソース単体の変更や削除は、即座の影響を持ちません
#   - 検証プロセスは通常、DNSレコードの伝播により数分から72時間かかります
#   - 検証が完了するまで、ドメインからのメール送信はできません
#
# 主な用途:
#   - SESでのドメインベースのメール送信を有効化
#   - ドメイン所有権の証明
#   - DKIM、SPF、DMARCなどのメール認証機能の基盤
#
# AWS公式ドキュメント:
#   - SESアイデンティティの検証: https://docs.aws.amazon.com/ses/latest/dg/verify-addresses-and-domains.html
#   - ドメインアイデンティティの検証: https://docs.aws.amazon.com/ses/latest/dg/creating-identities.html
#   - VerifyDomainIdentity API: https://docs.aws.amazon.com/ses/latest/APIReference/API_VerifyDomainIdentity.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ses_domain_identity_verification
#
# Provider Version: 6.28.0
# Generated: 2026-02-05
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# 前提条件: SESドメインアイデンティティの作成
#---------------------------------------------------------------
# まず、検証したいドメインのSESアイデンティティを作成します

resource "aws_ses_domain_identity" "example" {
  # 検証したいドメイン名
  domain = "example.com"
}

#---------------------------------------------------------------
# 前提条件: Route 53でのDNS検証レコードの作成
#---------------------------------------------------------------
# SESから提供される検証トークンをTXTレコードとして追加します

resource "aws_route53_record" "example_amazonses_verification_record" {
  # Route 53ホストゾーンID
  zone_id = aws_route53_zone.example.zone_id

  # 検証レコード名 (_amazonses プレフィックス)
  name = "_amazonses.${aws_ses_domain_identity.example.domain}"

  # レコードタイプ
  type = "TXT"

  # TTL（秒）
  ttl = "600"

  # SESから提供される検証トークン
  records = [aws_ses_domain_identity.example.verification_token]
}

#---------------------------------------------------------------
# SESドメインアイデンティティ検証リソース
#---------------------------------------------------------------

resource "aws_ses_domain_identity_verification" "example" {
  #-------------------------------------------------------------
  # 必須パラメータ
  #-------------------------------------------------------------

  # domain (Required)
  # 設定内容: 検証するSESドメインアイデンティティのドメイン名を指定します。
  # 設定可能な値: aws_ses_domain_identity.domainと一致する有効なドメイン名
  # 注意:
  #   - このドメインは事前にaws_ses_domain_identityで登録されている必要があります
  #   - ドメインのDNS設定に検証用のTXTレコードが追加されている必要があります
  #   - 検証には通常数分かかりますが、DNS伝播により最大72時間かかる場合があります
  # 関連機能: SES Domain Identity
  #   ドメインアイデンティティを使用することで、@example.comのような
  #   ドメインレベルでのメール送信が可能になります。サブドメインごとに
  #   個別のアイデンティティを設定することもできます。
  #   - https://docs.aws.amazon.com/ses/latest/dg/verify-addresses-and-domains.html
  domain = aws_ses_domain_identity.example.domain

  #-------------------------------------------------------------
  # オプションパラメータ
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースが管理されるリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, us-west-2, eu-west-1）
  # 省略時: プロバイダー設定で指定されたリージョンがデフォルトとして使用されます。
  # 注意:
  #   - SESはリージョナルサービスのため、リージョンごとに検証が必要です
  #   - 複数のリージョンで同じドメインを使用する場合、各リージョンで検証が必要です
  # AWS参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # 依存関係の設定
  #-------------------------------------------------------------
  # DNS検証レコードが作成された後に検証を試行する必要があります
  depends_on = [aws_route53_record.example_amazonses_verification_record]
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: ドメインアイデンティティのドメイン名
#   用途: リソースの一意識別子として使用
#
# - arn: ドメインアイデンティティのARN
#   フォーマット: arn:aws:ses:region:account-id:identity/domain-name
#   用途: IAMポリシーでのリソース指定、他のAWSサービスとの統合など
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# Timeouts設定
#---------------------------------------------------------------
# このリソースは、検証完了を待機するためのタイムアウト設定をサポートしています
# デフォルトでは45分間待機します
#
# resource "aws_ses_domain_identity_verification" "example" {
#   domain = aws_ses_domain_identity.example.domain
#
#   timeouts {
#     # 検証完了を待機する最大時間
#---------------------------------------------------------------
