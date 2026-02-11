#---------------------------------------------------------------
# Amazon SES Domain Identity
#---------------------------------------------------------------
#
# Amazon Simple Email Service (SES) のドメインアイデンティティを作成・管理するリソースです。
# SESからメールを送信するには、送信元のドメインまたはメールアドレスの所有権を検証する必要があります。
# このリソースを使用することで、ドメイン全体をSESで使用可能にし、そのドメインから
# 任意のメールアドレスでメールを送信できるようになります。
#
# 主な機能:
#   - ドメイン所有権の検証トークンを生成
#   - 特定のリージョンでドメインアイデンティティを管理
#   - Route53等のDNSサービスと連携してドメイン検証を自動化
#
# AWS公式ドキュメント:
#   - SES ドメインアイデンティティの検証: https://docs.aws.amazon.com/ses/latest/DeveloperGuide/verify-domains.html
#   - SES アイデンティティ管理: https://docs.aws.amazon.com/ses/latest/DeveloperGuide/verify-addresses-and-domains.html
#   - SES API リファレンス: https://docs.aws.amazon.com/ses/latest/APIReference/API_VerifyDomainIdentity.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ses_domain_identity
#
# Provider Version: 6.28.0
# Generated: 2026-02-05
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_ses_domain_identity" "example" {
  #-------------------------------------------------------------
  # 必須パラメータ
  #-------------------------------------------------------------

  # domain (Required)
  # 設定内容: SESに割り当てるドメイン名を指定します。
  # 設定可能な値: 完全修飾ドメイン名 (FQDN)。例: example.com, mail.example.com
  # 用途: SESでメールを送信するために検証するドメインを指定
  # 注意事項:
  #   - このドメインのDNSレコードにアクセスできる必要があります
  #   - ドメイン検証には、このリソースが生成するverification_tokenを
  #     DNSのTXTレコードとして追加する必要があります
  # 関連機能: SES ドメインアイデンティティ検証
  #   ドメイン所有権を証明することで、そのドメインからメールを送信可能になります。
  #   - https://docs.aws.amazon.com/ses/latest/DeveloperGuide/verify-domain-procedure.html
  domain = "example.com"

  #-------------------------------------------------------------
  # オプションパラメータ
  #-------------------------------------------------------------

  # region (Optional, Computed)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード (例: us-east-1, ap-northeast-1, eu-west-1)
  # 省略時: プロバイダー設定で指定されたリージョンを使用
  # 用途: 複数リージョンでSESを使用する場合に明示的にリージョンを指定
  # 注意事項:
  #   - SESのリージョンは送信元リージョンを決定します
  #   - 各リージョンで個別にドメイン検証が必要です
  # 関連機能: SES リージョン管理
  #   SESは各リージョンで独立して動作するため、複数リージョンで送信する場合は
  #   各リージョンでドメインアイデンティティを設定する必要があります。
  #   - https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # 計算属性 (Terraform管理)
  #-------------------------------------------------------------

  # id (Optional, Computed)
  # 設定内容: リソースのID。通常はドメイン名と同じ値
  # 注意: 通常は明示的に設定する必要はありません。Terraformが自動管理します
  id = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: ドメインアイデンティティのAmazon Resource Name (ARN)
#   例: arn:aws:ses:us-east-1:123456789012:identity/example.com
#
# - verification_token: ドメイン所有権を検証するためのコード
#   このトークンをドメインのDNS TXTレコードとして追加することで、
#   SESに対してドメインの所有者であることを証明できます。
#   ドメインアイデンティティは、このトークンがDNSに追加されるまで
#   "verification pending" 状態のままとなります。
#
#   詳細: https://docs.aws.amazon.com/ses/latest/DeveloperGuide/verify-domains.html
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# Route53を使用してドメインを管理している場合、
# 以下のようにTXTレコードを自動的に作成できます:
#
# resource "aws_route53_record" "example_ses_verification" {
#   zone_id = "ABCDEFGHIJ123"
#   name    = "_amazonses.example.com"
#---------------------------------------------------------------
