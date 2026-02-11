################################################################################
# AWS Route 53 Key Signing Key (KSK) - DNSSEC Configuration
################################################################################
# Route 53 Key Signing Keyは、DNSSECによるDNSレコードの署名とセキュリティ保護を
# 実現するために使用されます。KSKは公開鍵/秘密鍵ペアで構成され、秘密鍵は
# Zone Signing Key (ZSK)の署名に使用されます。
#
# 主要な用途:
# - ホストゾーンのDNSSEC署名の有効化
# - DNSスプーフィング攻撃からの保護
# - DNS応答の真正性と完全性の検証
#
# セキュリティ考慮事項:
# - KMS鍵は必ずus-east-1リージョンに配置する必要があります
# - ECC_NIST_P256キー仕様の非対称カスタマー管理キーが必須
# - Route 53サービスにDescribeKey、GetPublicKey、Sign権限を付与
# - 各ホストゾーンには最大2つまでのKSKを設定可能
#
# ベストプラクティス:
# - DNSSECを有効化する前にCloudWatchアラームを設定
# - ゾーンの最大TTLとSOA最小フィールドを1週間以下に設定
# - KSKのステータスを定期的に監視(ACTION_NEEDEDに注意)
# - 親DNSゾーンがDSレコードをサポートしていることを確認
#
# 参考資料:
# - DNSSEC設定ガイド: https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/dns-configuring-dnssec.html
# - KMS鍵要件: https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/dns-configuring-dnssec-cmk-requirements.html
# - KSK管理: https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/dns-configuring-dnssec-ksk.html
#
# Provider Version: 6.28.0
################################################################################

resource "aws_route53_key_signing_key" "example" {
  #--------------------------------------------------------------------------
  # 必須パラメータ
  #--------------------------------------------------------------------------

  # ホストゾーンID
  # - KSKを設定するRoute 53ホストゾーンの識別子
  # - aws_route53_zone.example.idの形式で参照
  # - 各KSKは単一のホストゾーンに紐づき、独立して存在できません
  hosted_zone_id = "Z1234567890ABC" # aws_route53_zone.example.id

  # KMS鍵のARN
  # - AWS Key Management Service (KMS)の顧客管理キーのARN
  # - 必須要件:
  #   * us-east-1リージョンに配置
  #   * 非対称カスタマー管理キー
  #   * キー仕様: ECC_NIST_P256
  #   * キー使用法: SIGN_VERIFY
  #   * Route 53サービスプリンシパルへの適切な権限付与
  # - 各ホストゾーン内でKSKごとに一意である必要があります
  # - 参考: https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/dns-configuring-dnssec-cmk-requirements.html
  key_management_service_arn = "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012" # aws_kms_key.example.arn

  # KSK名
  # - Key Signing Key (KSK)の名前
  # - 同じホストゾーン内の各KSKに対して一意である必要があります
  # - DNSKEYレコードとDSレコードの識別に使用されます
  name = "example-ksk"

  #--------------------------------------------------------------------------
  # オプションパラメータ
  #--------------------------------------------------------------------------

  # KSKのステータス
  # - DNSSEC署名に使用するKSKの状態を制御します
  # - 有効な値:
  #   * ACTIVE: KSKが有効で、DNSSEC署名に使用されます(デフォルト)
  #   * INACTIVE: KSKが無効で、DNSSEC署名に使用されません
  # - KSKを削除する前に、ステータスをINACTIVEに設定する必要があります
  # - KSKのステータスがACTION_NEEDEDの場合、KMS鍵へのアクセスが
  #   失われている可能性があります
  status = "ACTIVE"

  #--------------------------------------------------------------------------
  # タイムアウト設定
  #--------------------------------------------------------------------------
  # DNSSEC設定は伝播に時間がかかる場合があります
  # 運用環境では適切なタイムアウト値を設定してください

  timeouts {
    # 作成タイムアウト
    # - KSKの作成処理の最大待機時間
    # - デフォルトは適用されません
    create = "20m"

    # 削除タイムアウト
    # - KSKの削除処理の最大待機時間
    # - デフォルトは適用されません
    delete = "20m"

    # 更新タイムアウト
    # - KSK設定の更新処理の最大待機時間(ステータス変更など)
    # - デフォルトは適用されません
    update = "20m"
  }

  #--------------------------------------------------------------------------
  # 依存関係管理
  #--------------------------------------------------------------------------
  # DNSSECの有効化とKSKの作成順序は重要です
  # aws_route53_hosted_zone_dnssecリソースとの依存関係を適切に設定してください
  # 通常、KSKを先に作成し、その後DNSSECを有効化します
}

################################################################################
# Computed Attributes (読み取り専用)
################################################################################
# 以下の属性はTerraformによって自動的に計算され、出力として使用できます:
#
# - id
#   Route 53ホストゾーン識別子とKMS鍵識別子をカンマで結合した値
#   例: "Z1234567890ABC,12345678-1234-1234-1234-123456789012"
#
# - digest_algorithm_mnemonic (string)
#   Delegation Signer (DS)ダイジェストアルゴリズムを表す文字列
#   RFC-8624 Section 3.3に準拠
#
# - digest_algorithm_type (number)
#   DSダイジェストアルゴリズムを表す整数値
#   RFC-8624 Section 3.3に準拠
#
# - digest_value (string)
#   DNSKEYリソースレコードの暗号学的ダイジェスト
#   DNSSEC署名の検証に使用されます
#
# - dnskey_record (string)
#   DNSKEYレコードを表す文字列
#   公開鍵情報が含まれます
#
# - ds_record (string)
#   Delegation Signer (DS)レコードを表す文字列
#   親ゾーンに登録してトラストチェーンを確立するために使用します
#
# - flag (number)
#   鍵の使用方法を指定する整数値
#   KSKの場合は常に257
#
# - key_tag (number)
#   ドメイン名のDNSSECレコードを識別するために使用される整数値
#   RFC-4034 Appendix Bに記載された計算プロセスに基づきます
#
# - public_key (string)
#   Base64エンコーディングで表現された公開鍵
#   RFC-4034 Page 5に準拠
#
# - signing_algorithm_mnemonic (string)
#   署名アルゴリズムを表す文字列
#   RFC-8624 Section 3.1に準拠
#
# - signing_algorithm_type (number)
#   署名アルゴリズムを表す整数値
#   RFC-8624 Section 3.1に準拠
################################################################################

################################################################################
# 出力例
################################################################################
# output "ksk_id" {
#   description = "Key Signing Keyのリソース識別子"
#   value       = aws_route53_key_signing_key.example.id
# }
#
# output "ksk_ds_record" {
#   description = "親ゾーンに登録するためのDSレコード"
#   value       = aws_route53_key_signing_key.example.ds_record
# }
#
# output "ksk_dnskey_record" {
#   description = "DNSKEYレコード情報"
#   value       = aws_route53_key_signing_key.example.dnskey_record
# }
#
# output "ksk_key_tag" {
#   description = "KSKのキータグ識別子"
#   value       = aws_route53_key_signing_key.example.key_tag
# }
#
# output "ksk_public_key" {
#   description = "KSKの公開鍵(Base64エンコード)"
#   value       = aws_route53_key_signing_key.example.public_key
#   sensitive   = true
# }
################################################################################

################################################################################
# 完全な実装例: KMS鍵とホストゾーンを含む
################################################################################
# 以下は、DNSSEC対応のホストゾーンをセットアップするための
# 完全な実装例です。KMS鍵、ホストゾーン、KSK、DNSSEC有効化の
# すべてのステップを含みます。
################################################################################

# # AWS現在のアカウント情報を取得
# data "aws_caller_identity" "current" {}
#
# # DNSSEC用のKMS鍵を作成
# resource "aws_kms_key" "dnssec" {
#   # us-east-1リージョンで作成する必要があります(プロバイダー設定で指定)
#   customer_master_key_spec = "ECC_NIST_P256"
#   deletion_window_in_days  = 7
#   key_usage                = "SIGN_VERIFY"
#
#   # Route 53 DNSSECサービスに必要な権限を付与
#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Sid    = "Allow Route 53 DNSSEC Service"
#         Effect = "Allow"
#         Principal = {
#           Service = "dnssec-route53.amazonaws.com"
#         }
#         Action = [
#           "kms:DescribeKey",
#           "kms:GetPublicKey",
#           "kms:Sign",
#         ]
#         Resource = "*"
#         Condition = {
#           StringEquals = {
#             "aws:SourceAccount" = data.aws_caller_identity.current.account_id
#           }
#           ArnLike = {
#             "aws:SourceArn" = "arn:aws:route53:::hostedzone/*"
#           }
#         }
#       },
#       {
#         Sid    = "Allow Route 53 DNSSEC Service to CreateGrant"
#         Effect = "Allow"
#         Principal = {
#           Service = "dnssec-route53.amazonaws.com"
#         }
#         Action   = "kms:CreateGrant"
#         Resource = "*"
#         Condition = {
#           Bool = {
#             "kms:GrantIsForAWSResource" = "true"
#           }
#         }
#       },
#       {
#         Sid    = "Enable IAM User Permissions"
#         Effect = "Allow"
#         Principal = {
#           AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
#         }
#         Action   = "kms:*"
#         Resource = "*"
#       },
#     ]
#   })
#
#   tags = {
#     Name        = "route53-dnssec-key"
#     Environment = "production"
#     Purpose     = "DNSSEC signing for Route53"
#   }
# }
#
# # Route 53ホストゾーンの作成
# resource "aws_route53_zone" "main" {
#   name = "example.com"
#
#   tags = {
#     Name        = "example.com"
#     Environment = "production"
#   }
# }
#
# # Key Signing Key (KSK)の作成
# resource "aws_route53_key_signing_key" "main" {
#   hosted_zone_id             = aws_route53_zone.main.id
#   key_management_service_arn = aws_kms_key.dnssec.arn
#   name                       = "example-ksk"
#   status                     = "ACTIVE"
#
#   timeouts {
#     create = "20m"
#     delete = "20m"
#     update = "20m"
#   }
# }
#
# # ホストゾーンのDNSSECを有効化
# resource "aws_route53_hosted_zone_dnssec" "main" {
#   depends_on = [
#     aws_route53_key_signing_key.main
#   ]
#   hosted_zone_id = aws_route53_key_signing_key.main.hosted_zone_id
# }
#
# # 出力: 親ゾーンに登録するDSレコード情報
# output "dnssec_ds_record" {
#   description = "親DNSゾーンに登録するDSレコード(トラストチェーン確立用)"
#   value       = aws_route53_key_signing_key.main.ds_record
# }
#
# output "dnssec_status" {
#   description = "DNSSECの有効化ステータス"
#   value       = aws_route53_hosted_zone_dnssec.main.id
# }
################################################################################

################################################################################
# マルチKSK構成例(キーローテーション用)
################################################################################
# ホストゾーンごとに最大2つのKSKを設定できます。
# これにより、ダウンタイムなしでKSKのローテーションが可能になります。
################################################################################

# # プライマリKSK
# resource "aws_route53_key_signing_key" "primary" {
#   hosted_zone_id             = aws_route53_zone.main.id
#   key_management_service_arn = aws_kms_key.dnssec_primary.arn
#   name                       = "primary-ksk"
#   status                     = "ACTIVE"
# }
#
# # セカンダリKSK(ローテーション用)
# resource "aws_route53_key_signing_key" "secondary" {
#   hosted_zone_id             = aws_route53_zone.main.id
#   key_management_service_arn = aws_kms_key.dnssec_secondary.arn
#   name                       = "secondary-ksk"
#   status                     = "INACTIVE" # 最初は非アクティブ、ローテーション時にアクティブ化
# }
################################################################################

################################################################################
# トラブルシューティングガイド
################################################################################
# KSKのステータスがACTION_NEEDEDになった場合:
# 1. KMS鍵が有効であることを確認
# 2. KMS鍵のポリシーが正しく設定されていることを確認
# 3. KSKを再度アクティブ化する
#
# DNSSECを無効化する場合:
# 1. 親ゾーンからDSレコードを削除
# 2. aws_route53_hosted_zone_dnssecリソースを削除
# 3. aws_route53_key_signing_keyリソースを削除(ステータスをINACTIVEに設定後)
#
# 参考資料:
# - トラブルシューティング: https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/dns-configuring-dnssec-troubleshoot.html
################################################################################
