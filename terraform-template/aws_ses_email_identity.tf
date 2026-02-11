################################################################################
# AWS SES Email Identity
# https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/ses_email_identity
################################################################################

# aws_ses_email_identity は、Amazon SES (Simple Email Service) でメールアドレスを
# 送信元として使用するためのメールアイデンティティを作成します。
# メールアドレスを検証し、そのアドレスからメールを送信できるようにします。
#
# 主な用途:
# - メール送信元アドレスの検証と登録
# - SESでのメール送信権限の設定
# - トランザクションメールやマーケティングメールの送信元設定
#
# 重要な考慮事項:
# - メールアドレスの検証が必要（検証メールが送信されます）
# - SESサンドボックス環境では検証済みアドレスにのみ送信可能
# - 本番環境移行には送信制限解除申請が必要な場合があります
# - リージョンごとに個別に設定が必要です

resource "aws_ses_email_identity" "example" {
  #=============================================================================
  # 必須パラメータ
  #=============================================================================

  # email - (必須) SESに登録するメールアドレス
  #
  # SESで送信元として使用するメールアドレスを指定します。
  # このアドレスに検証メールが送信され、リンクをクリックして検証を完了する必要があります。
  #
  # 制約事項:
  # - 有効なメールアドレス形式である必要があります
  # - 受信可能なメールアドレスを指定してください（検証が必要）
  # - 同じリージョン内で重複登録はできません
  #
  # 例:
  # - 個人アドレス: "sender@example.com"
  # - 組織アドレス: "noreply@company.com"
  # - サポートアドレス: "support@service.com"
  email = "email@example.com"

  #=============================================================================
  # オプショナルパラメータ
  #=============================================================================

  # region - (オプション) リソースを管理するAWSリージョン
  #
  # このリソースが管理されるAWSリージョンを指定します。
  # 指定しない場合は、プロバイダー設定のリージョンがデフォルトで使用されます。
  #
  # 使用場面:
  # - マルチリージョン構成でリージョンを明示的に指定する場合
  # - プロバイダーのデフォルトリージョンと異なるリージョンで管理する場合
  #
  # 注意事項:
  # - SESの送信制限やサンドボックス設定はリージョンごとに管理されます
  # - 複数リージョンで同じメールアドレスを使用する場合、各リージョンで個別に登録が必要です
  #
  # 例:
  # region = "us-east-1"  # バージニア北部
  # region = "us-west-2"  # オレゴン
  # region = "eu-west-1"  # アイルランド

  #=============================================================================
  # タグ設定
  #=============================================================================

  # このリソースはタグをサポートしていません
  # タグが必要な場合は、SES v2 API（aws_sesv2_email_identity）の使用を検討してください
}

################################################################################
# 出力値（Attributes Reference）
################################################################################

# arn - メールアイデンティティのARN
#
# 作成されたSESメールアイデンティティのAmazon Resource Name (ARN)を返します。
# このARNは、IAMポリシーやSES関連リソースの参照に使用できます。
#
# 形式: arn:aws:ses:region:account-id:identity/email-address
#
# 使用例:
output "ses_email_identity_arn" {
  description = "SESメールアイデンティティのARN"
  value       = aws_ses_email_identity.example.arn
}

################################################################################
# 使用例
################################################################################

# 例1: 基本的な単一メールアドレスの登録
# resource "aws_ses_email_identity" "noreply" {
#   email = "noreply@example.com"
# }

# 例2: 複数メールアドレスの登録
# resource "aws_ses_email_identity" "support" {
#   email = "support@example.com"
# }
#
# resource "aws_ses_email_identity" "notifications" {
#   email = "notifications@example.com"
# }

# 例3: 特定リージョンでの登録
# resource "aws_ses_email_identity" "us_east" {
#   email  = "sender@example.com"
#   region = "us-east-1"
# }

# 例4: 変数を使用した動的な登録
# variable "sender_emails" {
#   description = "登録するメールアドレスのリスト"
#   type        = list(string)
#   default     = ["info@example.com", "sales@example.com"]
# }
#
# resource "aws_ses_email_identity" "emails" {
#   for_each = toset(var.sender_emails)
#   email    = each.value
# }

################################################################################
# 関連リソース
################################################################################

# aws_ses_domain_identity - ドメイン全体をSESで認証する場合
# resource "aws_ses_domain_identity" "example" {
#   domain = "example.com"
# }

# aws_ses_identity_notification_topic - 通知設定（バウンス、苦情など）
# resource "aws_ses_identity_notification_topic" "example" {
#   topic_arn         = aws_sns_topic.example.arn
#   notification_type = "Bounce"
#   identity          = aws_ses_email_identity.example.email
# }

# aws_ses_configuration_set - 送信設定セット
# resource "aws_ses_configuration_set" "example" {
#   name = "example-config-set"
# }

# aws_ses_event_destination - イベント送信先の設定
# resource "aws_ses_event_destination" "cloudwatch" {
#   name                   = "cloudwatch-destination"
#   configuration_set_name = aws_ses_configuration_set.example.name
#   enabled                = true
#   matching_types         = ["send", "reject", "bounce", "complaint"]
#
#   cloudwatch_destination {
#     default_value  = "default"
#     dimension_name = "dimension"
#     value_source   = "emailHeader"
#   }
# }

# aws_ses_identity_policy - SESアイデンティティポリシー
# resource "aws_ses_identity_policy" "example" {
#   identity = aws_ses_email_identity.example.email
#   name     = "example-policy"
#   policy   = data.aws_iam_policy_document.ses_policy.json
# }

################################################################################
# ベストプラクティス
################################################################################

# 1. メールアドレスの検証
#    - リソース作成後、指定したメールアドレスに検証メールが送信されます
#    - 検証リンクをクリックして、24時間以内に検証を完了してください
#    - 検証が完了するまでメール送信はできません

# 2. サンドボックスモードの理解
#    - 新規アカウントはサンドボックスモードで開始されます
#    - サンドボックスでは検証済みアドレスにのみ送信可能です
#    - 本番利用には送信制限解除申請が必要です

# 3. 送信制限の確認
#    - リージョンごとに1日の送信制限があります
#    - 送信レート（秒あたりの送信数）にも制限があります
#    - 必要に応じてAWSサポートに制限緩和を申請してください

# 4. バウンスと苦情の監視
#    - aws_ses_identity_notification_topicでSNS通知を設定
#    - バウンス率と苦情率を監視してください
#    - 高いバウンス率はアカウント停止につながる可能性があります

# 5. セキュリティ考慮事項
#    - IAMポリシーで送信権限を適切に制限してください
#    - 必要最小限のIAMロールのみにses:SendEmailを許可
#    - SPF、DKIM、DMARCの設定を推奨（ドメインアイデンティティ使用時）

# 6. コスト最適化
#    - 未使用のメールアイデンティティは削除してください
#    - 使用頻度の低いアドレスは統合を検討してください
#    - SESの料金は送信数に基づくため、不要な送信を削減してください

# 7. 代替オプション
#    - 新規実装ではSES v2 API（aws_sesv2_email_identity）の使用を推奨
#    - ドメイン全体を認証する場合はaws_ses_domain_identityを検討
#    - タグ付けが必要な場合はSES v2リソースを使用してください

################################################################################
# トラブルシューティング
################################################################################

# 問題: メールアドレスの検証メールが届かない
# 解決策:
# - スパムフォルダを確認してください
# - メールアドレスが正しく入力されているか確認
# - 24時間以内に検証を完了してください（期限切れの場合は再作成）

# 問題: メールが送信できない（サンドボックス）
# 解決策:
# - 送信先メールアドレスも検証済みか確認してください
# - サンドボックス解除申請を提出してください
# - AWS SESコンソールで送信統計を確認してください

# 問題: リソース作成時のエラー
# 解決策:
# - 同じメールアドレスが既に登録されていないか確認
# - リージョンが正しく設定されているか確認
# - IAM権限（ses:VerifyEmailIdentity）があるか確認

# 問題: 送信制限に達した
# 解決策:
# - AWSサポートに制限緩和申請を提出してください
# - 送信レートを調整して制限内に収めてください
# - CloudWatchメトリクスで送信統計を監視してください
