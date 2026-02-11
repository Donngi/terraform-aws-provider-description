################################################################################
# Route 53 Domains Delegation Signer Record
################################################################################
# 概要:
#   Route53で登録されたドメインに対して、親DNSゾーンに委任署名者レコード(DS record)を
#   管理するリソース。DNSSEC有効化の一環として使用される。
#
# 主な用途:
#   - Route53でDNSSECを有効化する際の親ゾーンへのDS登録
#   - ドメインレジストラへの鍵署名キー(KSK)情報の提供
#   - DNSセキュリティ拡張の実装
#
# 前提条件:
#   - Route53でホストゾーンが管理されていること
#   - KMS鍵と鍵署名キー(KSK)が作成されていること
#   - ホストゾーンでDNSSECが有効化されていること
#
# 制限事項:
#   - Route53で登録されたドメインのみ対応
#   - us-east-1リージョンでの作成が必要
#   - ドメイン登録のステータスによっては更新に時間がかかる場合がある
#
# 注意事項:
#   - DS recordの誤った設定はDNS解決の失敗につながる可能性がある
#   - KSKのローテーション時は適切なタイミングでDS recordも更新すること
#   - 削除前にDNSSECの無効化を検討すること
#
# 参考URL:
#   https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53domains_delegation_signer_record
################################################################################

resource "aws_route53domains_delegation_signer_record" "example" {
  ##############################################################################
  # 必須パラメータ
  ##############################################################################

  # domain_name - (Required)
  # 説明: 親DNSゾーンに委任署名者レコードが登録されるドメイン名
  # タイプ: string
  # デフォルト: なし
  # 制約:
  #   - Route53で登録されたドメインである必要がある
  #   - 完全修飾ドメイン名(FQDN)を指定
  # 更新時の動作: 変更時にリソースが再作成される
  domain_name = "example.com"

  ##############################################################################
  # signing_attributes - (Required)
  # 説明: 鍵に関する情報（アルゴリズム、公開鍵値、フラグ）
  # タイプ: list (max_items: 1)
  # ネスト構造: block
  ##############################################################################
  signing_attributes {
    # algorithm - (Required)
    # 説明: 公開鍵からダイジェストを生成するために使用されたアルゴリズム
    # タイプ: number
    # デフォルト: なし
    # 一般的な値:
    #   - 13: ECDSAP256SHA256 (楕円曲線 P-256)
    #   - 8:  RSA/SHA-256
    # 制約: Route53 KSKの署名アルゴリズムと一致する必要がある
    # 参照例: aws_route53_key_signing_key.example.signing_algorithm_type
    algorithm = 13

    # flags - (Required)
    # 説明: 鍵のタイプを定義するフラグ値
    # タイプ: number
    # デフォルト: なし
    # 有効な値:
    #   - 257: KSK (key-signing-key) - 鍵署名キー
    #   - 256: ZSK (zone-signing-key) - ゾーン署名キー
    # 制約:
    #   - 通常はKSKの257を使用
    #   - Route53 KSKのフラグ値と一致する必要がある
    # 参照例: aws_route53_key_signing_key.example.flag
    flags = 257

    # public_key - (Required)
    # 説明: レジストラに渡される鍵ペアの公開鍵部分（Base64エンコード）
    # タイプ: string
    # デフォルト: なし
    # 形式: Base64エンコードされた公開鍵
    # 制約:
    #   - KSKから取得した公開鍵を使用
    #   - 正しいエンコード形式である必要がある
    # 参照例: aws_route53_key_signing_key.example.public_key
    # セキュリティ: 公開鍵のため機密情報ではない
    public_key = "AwEAAa..."
  }

  ##############################################################################
  # タイムアウト設定 (オプション)
  ##############################################################################
  # timeouts {
  #   # create - (Optional)
  #   # 説明: リソース作成のタイムアウト時間
  #   # タイプ: string (duration format)
  #   # デフォルト: 30m
  #   # 形式: "30s", "10m", "2h" などの時間単位
  #   # 用途: ドメインレジストラとの通信が遅い場合に延長
  #   create = "30m"
  #
  #   # delete - (Optional)
  #   # 説明: リソース削除のタイムアウト時間
  #   # タイプ: string (duration format)
  #   # デフォルト: 30m
  #   # 形式: "30s", "10m", "2h" などの時間単位
  #   # 用途: 削除処理に時間がかかる場合に延長
  #   delete = "30m"
  # }
}

################################################################################
# 出力される属性 (Computed Attributes)
################################################################################
# 以下の属性は自動的に計算され、他のリソースから参照可能です:

# id (string, computed)
# 説明: リソースの一意識別子
# 形式: 通常はドメイン名と同じ
# 用途: Terraformの内部管理用
# 参照例: aws_route53domains_delegation_signer_record.example.id

# dnssec_key_id (string, computed)
# 説明: 作成されたDSレコードに割り当てられたID
# 用途: Route53 APIでのDS record識別子
# 参照例: aws_route53domains_delegation_signer_record.example.dnssec_key_id

################################################################################
# 依存関係の例
################################################################################
# 典型的な使用パターンでは以下のリソースと連携します:
#
# 1. KMS鍵 (aws_kms_key)
#    - DNSSEC署名用のカスタマーマネージドキー
#    - ECC_NIST_P256など適切な鍵仕様が必要
#
# 2. 鍵署名キー (aws_route53_key_signing_key)
#    - ホストゾーンのDNSSEC署名に使用
#    - algorithm, flags, public_keyを参照
#
# 3. ホストゾーンDNSSEC (aws_route53_hosted_zone_dnssec)
#    - ホストゾーンでDNSSECを有効化
#    - DS recordの前提条件
#
# depends_onで明示的な依存関係を設定することを推奨:
#   depends_on = [
#     aws_route53_hosted_zone_dnssec.example
#   ]

################################################################################
# 使用例
################################################################################
# # 完全な例（KMS鍵、KSK、DNSSEC有効化を含む）
# provider "aws" {
#   region = "us-east-1"
# }
#
# data "aws_caller_identity" "current" {}
#
# # DNSSEC用のKMS鍵
# resource "aws_kms_key" "dnssec" {
#   customer_master_key_spec = "ECC_NIST_P256"
#   deletion_window_in_days  = 7
#   key_usage                = "SIGN_VERIFY"
#
#   policy = jsonencode({
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
#     Version = "2012-10-17"
#   })
# }
#
# # Route53ホストゾーン
# resource "aws_route53_zone" "example" {
#   name = "example.com"
# }
#
# # 鍵署名キー
# resource "aws_route53_key_signing_key" "example" {
#   hosted_zone_id             = aws_route53_zone.example.id
#   key_management_service_arn = aws_kms_key.dnssec.arn
#   name                       = "example-ksk"
# }
#
# # ホストゾーンでDNSSECを有効化
# resource "aws_route53_hosted_zone_dnssec" "example" {
#   hosted_zone_id = aws_route53_key_signing_key.example.hosted_zone_id
#
#   depends_on = [
#     aws_route53_key_signing_key.example
#   ]
# }
#
# # 委任署名者レコード
# resource "aws_route53domains_delegation_signer_record" "example" {
#   domain_name = "example.com"
#
#   signing_attributes {
#     algorithm  = aws_route53_key_signing_key.example.signing_algorithm_type
#     flags      = aws_route53_key_signing_key.example.flag
#     public_key = aws_route53_key_signing_key.example.public_key
#   }
#
#   depends_on = [
#     aws_route53_hosted_zone_dnssec.example
#   ]
# }

################################################################################
# トラブルシューティング
################################################################################
# よくある問題と解決策:
#
# 1. "Domain is not registered with Route53"
#    → ドメインがRoute53で登録されていることを確認
#    → 外部レジストラで登録されたドメインは非対応
#
# 2. "DNSSEC is not enabled for the hosted zone"
#    → aws_route53_hosted_zone_dnssecリソースが作成済みか確認
#    → depends_onで依存関係を明示
#
# 3. "Invalid algorithm or flags"
#    → KSKの値と一致しているか確認
#    → algorithm: 13 (ECDSAP256SHA256) または 8 (RSA/SHA-256)
#    → flags: 257 (KSK)
#
# 4. タイムアウトエラー
#    → timeoutsブロックでcreate/deleteを延長
#    → ドメインレジストラAPIの応答待ちに時間がかかる場合がある
#
# 5. "Public key format is invalid"
#    → Base64エンコードされた公開鍵が正しいか確認
#    → KSKのpublic_key属性を直接参照することを推奨

################################################################################
# ベストプラクティス
################################################################################
# 1. KSKからの自動参照:
#    - algorithm, flags, public_keyは手動設定ではなくKSKから参照
#    - 値の不一致を防ぎメンテナンス性向上
#
# 2. 依存関係の明示:
#    - depends_onでaws_route53_hosted_zone_dnssecへの依存を明示
#    - 正しい順序でリソースが作成される
#
# 3. リージョン設定:
#    - Route53 Domainsはus-east-1でのみ利用可能
#    - providerでregion = "us-east-1"を明示
#
# 4. KMS鍵のポリシー:
#    - Route53 DNSSECサービスに適切な権限を付与
#    - ソースアカウントとARNの条件を設定してセキュリティ強化
#
# 5. 変更管理:
#    - DS recordの変更はDNS解決に影響するため慎重に実施
#    - KSKローテーション時は新旧両方のDSを一時的に登録することを検討
#    - 変更後はDNSSEC検証ツールで確認
#
# 6. モニタリング:
#    - CloudWatch EventsでDNSSEC関連のエラーを監視
#    - Route53クエリログでDNSSEC検証の状況を確認
#
# 7. ドキュメント化:
#    - どのドメインでDNSSECが有効か明記
#    - KSKのローテーション手順をドキュメント化
