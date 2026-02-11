################################################################################
# AWS SES Domain DKIM Resource
################################################################################
#
# リソース概要:
#   Amazon SES (Simple Email Service) ドメインのDKIM (DomainKeys Identified Mail)
#   トークンを生成するリソースです。DKIMは電子メール認証の標準規格で、送信者が
#   メッセージに暗号鍵で署名し、受信側がそれを検証することでメールの真正性を
#   保証します。
#
# 主な用途:
#   - SESドメインのDKIM認証設定
#   - スパムやフィッシング詐欺の防止
#   - メール配信性能の向上
#   - DMARC準拠のための認証設定
#
# 前提条件:
#   - aws_ses_domain_identity でドメインの所有権確認が完了していること
#   - 生成されたDKIMトークンをDNSレコード(CNAME)として設定する必要があります
#
# 注意事項:
#   - DKIMの設定は、「From」アドレスで使用するドメインに対してのみ必要です
#   - 複数のAWSリージョンでSESを使用する場合、各リージョンで設定が必要です
#   - DKIMは親ドメインの全サブドメインに自動的に適用されます
#   - SES Easy DKIMは2048ビットRSA暗号化をデフォルトで使用します
#
# 参考ドキュメント:
#   - https://docs.aws.amazon.com/ses/latest/DeveloperGuide/send-email-authentication-dkim.html
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ses_domain_dkim
#
################################################################################

resource "aws_ses_domain_dkim" "example" {
  #-----------------------------------------------------------------------------
  # 必須パラメータ
  #-----------------------------------------------------------------------------

  # domain - ドメイン名 (必須)
  # 説明: DKIMトークンを生成する検証済みドメイン名を指定します
  # 型: string
  # 制約:
  #   - aws_ses_domain_identity で事前に検証済みである必要があります
  #   - ドメインの所有権確認が完了していることが前提条件です
  # 例: "example.com", "subdomain.example.com"
  #
  # ベストプラクティス:
  #   - メール送信に使用する「From」アドレスのドメインを指定
  #   - 通常は aws_ses_domain_identity.example.domain を参照
  domain = aws_ses_domain_identity.example.domain

  #-----------------------------------------------------------------------------
  # オプションパラメータ
  #-----------------------------------------------------------------------------

  # region - リージョン (オプション)
  # 説明: このリソースが管理されるAWSリージョンを指定します
  # 型: string
  # デフォルト: プロバイダー設定のリージョン
  # 制約:
  #   - SESが利用可能なリージョンである必要があります
  #   - 複数リージョンで使用する場合、各リージョンで個別に設定が必要
  # 例: "us-east-1", "us-west-2", "eu-west-1"
  #
  # 使用例:
  #   region = "us-east-1"  # 明示的にリージョンを指定する場合
  #
  # 注意:
  #   - 通常はプロバイダーのデフォルトリージョンを使用
  #   - マルチリージョン構成の場合のみ明示的に指定を検討
  # region = "us-east-1"

  #-----------------------------------------------------------------------------
  # 計算属性 (Computed Attributes)
  #-----------------------------------------------------------------------------
  #
  # これらの属性はTerraformによって自動的に計算され、他のリソースから参照可能です:
  #
  # - id (string)
  #   リソースの一意識別子（通常はドメイン名）
  #
  # - dkim_tokens (list of strings)
  #   SESによって生成された3つのDKIMトークンのリスト
  #   これらのトークンを使用してDNSにCNAMEレコードを作成する必要があります
  #
  #   DNSレコード設定例:
  #   - 名前: {token}._domainkey.example.com
  #   - タイプ: CNAME
  #   - 値: {token}.dkim.amazonses.com
  #
  #   各トークンに対して上記のCNAMEレコードを作成します（計3レコード）
  #   詳細: https://docs.aws.amazon.com/ses/latest/DeveloperGuide/easy-dkim-dns-records.html
  #
}

################################################################################
# 使用例 1: 基本的な設定（Route 53との統合）
################################################################################
#
# SESドメインIDとDKIM、Route 53 DNSレコードを組み合わせた完全な設定例
#
# resource "aws_ses_domain_identity" "example" {
#   domain = "example.com"
# }
#
# resource "aws_ses_domain_dkim" "example" {
#   domain = aws_ses_domain_identity.example.domain
# }
#
# # DKIMトークンをRoute 53のCNAMEレコードとして自動作成
# resource "aws_route53_record" "example_amazonses_dkim_record" {
#   count   = 3  # DKIMトークンは3つ生成されます
#   zone_id = "Z1234567890ABC"
#   name    = "${aws_ses_domain_dkim.example.dkim_tokens[count.index]}._domainkey"
#   type    = "CNAME"
#   ttl     = "600"
#   records = ["${aws_ses_domain_dkim.example.dkim_tokens[count.index]}.dkim.amazonses.com"]
# }
#
################################################################################

################################################################################
# 使用例 2: マルチリージョン設定
################################################################################
#
# 複数のリージョンでSESを使用する場合の設定例
#
# # US East (バージニア北部) リージョン
# resource "aws_ses_domain_identity" "us_east" {
#   domain = "example.com"
# }
#
# resource "aws_ses_domain_dkim" "us_east" {
#   domain = aws_ses_domain_identity.us_east.domain
#   region = "us-east-1"
# }
#
# # EU West (アイルランド) リージョン
# resource "aws_ses_domain_identity" "eu_west" {
#   provider = aws.eu_west
#   domain   = "example.com"
# }
#
# resource "aws_ses_domain_dkim" "eu_west" {
#   provider = aws.eu_west
#   domain   = aws_ses_domain_identity.eu_west.domain
#   region   = "eu-west-1"
# }
#
# # 各リージョンのDKIMトークンに対応するDNSレコードを作成
# resource "aws_route53_record" "dkim_us_east" {
#   count   = 3
#   zone_id = "Z1234567890ABC"
#   name    = "${aws_ses_domain_dkim.us_east.dkim_tokens[count.index]}._domainkey"
#   type    = "CNAME"
#   ttl     = "600"
#   records = ["${aws_ses_domain_dkim.us_east.dkim_tokens[count.index]}.dkim.amazonses.com"]
# }
#
# resource "aws_route53_record" "dkim_eu_west" {
#   count   = 3
#   zone_id = "Z1234567890ABC"
#   name    = "${aws_ses_domain_dkim.eu_west.dkim_tokens[count.index]}._domainkey"
#   type    = "CNAME"
#   ttl     = "600"
#   records = ["${aws_ses_domain_dkim.eu_west.dkim_tokens[count.index]}.dkim.amazonses.com"]
# }
#
################################################################################

################################################################################
# 使用例 3: サブドメインでのDKIM設定
################################################################################
#
# サブドメインを使用してメールを送信する場合の設定例
# サブドメインは親ドメインのDKIM設定を継承しますが、
# 個別に設定することで上書き可能です
#
# resource "aws_ses_domain_identity" "subdomain" {
#   domain = "mail.example.com"
# }
#
# resource "aws_ses_domain_dkim" "subdomain" {
#   domain = aws_ses_domain_identity.subdomain.domain
# }
#
# resource "aws_route53_record" "subdomain_dkim" {
#   count   = 3
#   zone_id = "Z1234567890ABC"
#   name    = "${aws_ses_domain_dkim.subdomain.dkim_tokens[count.index]}._domainkey.mail"
#   type    = "CNAME"
#   ttl     = "600"
#   records = ["${aws_ses_domain_dkim.subdomain.dkim_tokens[count.index]}.dkim.amazonses.com"]
# }
#
################################################################################

################################################################################
# トラブルシューティング
################################################################################
#
# 1. DKIM検証が完了しない場合
#    - DNSレコードの伝播に最大72時間かかる場合があります
#    - CNAMEレコードの名前と値が正確か確認してください
#    - dig や nslookup コマンドでDNSレコードを確認
#      例: dig {token}._domainkey.example.com CNAME
#
# 2. "Domain not verified" エラー
#    - aws_ses_domain_identity でドメイン検証が完了しているか確認
#    - depends_on を使用して依存関係を明示的に設定
#
# 3. マルチリージョン設定で問題が発生する場合
#    - 各リージョンで個別にDKIM設定が必要です
#    - provider エイリアスを正しく設定しているか確認
#
# 4. DMARC準拠の確認
#    - SPFとDKIMの両方の設定を推奨
#    - DMARCポリシーレコード (_dmarc.example.com) の設定も検討
#    - DKIM署名のドメインとFromアドレスのドメインが一致する必要があります
#
################################################################################

################################################################################
# セキュリティとコンプライアンスの考慮事項
################################################################################
#
# 1. DKIM認証の重要性
#    - スパムフィルターのバイパス率向上
#    - フィッシング詐欺からの保護
#    - ドメインなりすまし防止
#    - 送信者レピュテーションの維持
#
# 2. DMARC準拠
#    - DKIMとSPFの両方を設定することを推奨
#    - DMARCポリシーで認証失敗時の処理を定義
#    - 緩和 (relaxed) または厳格 (strict) のアライメントポリシーを選択
#
# 3. 鍵の管理
#    - SES Easy DKIMは2048ビットRSA鍵をデフォルトで使用
#    - 鍵の長さ変更は制限されています（転送中のメール保護のため）
#    - DKIM署名の有効化を維持することを推奨
#
# 4. モニタリングと保守
#    - CloudWatch メトリクスでDKIM署名付きメールを監視
#    - 定期的にDNSレコードの有効性を確認
#    - DKIM検証ステータスをモニタリング
#
################################################################################

################################################################################
# 関連リソース
################################################################################
#
# よく一緒に使用されるリソース:
#
# - aws_ses_domain_identity
#   ドメインの所有権検証（DKIM設定の前提条件）
#
# - aws_ses_domain_mail_from
#   カスタムMAIL FROMドメインの設定（SPF/DMARC準拠に推奨）
#
# - aws_route53_record
#   DKIMトークン用のCNAMEレコード作成（DNS設定）
#
# - aws_ses_configuration_set
#   送信イベント追跡やIP プール管理
#
# - aws_ses_email_identity
#   個別メールアドレスの検証（ドメインレベルのDKIM設定を上書き可能）
#
################################################################################
