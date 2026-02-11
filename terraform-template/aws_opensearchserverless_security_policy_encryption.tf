# ================================================================================
# AWS OpenSearch Serverless Security Policy - Encryption Type
# ================================================================================
#
# このリソースは、OpenSearch Serverlessコレクションの暗号化ポリシーを管理します。
# 暗号化ポリシーは、コレクションがAWS所有キーまたはカスタマー管理キー(CMK)の
# どちらで暗号化されるかを定義します。暗号化は必須であり、コレクション作成前に
# 暗号化ポリシーを作成する必要があります。
#
# ユースケース:
# - コレクションの暗号化設定を一元管理
# - 複数のコレクションに対して一貫した暗号化ポリシーを適用
# - カスタマー管理キーによる暗号化制御の実装
# - コンプライアンス要件に基づいた暗号化の強制
#
# 前提条件:
# - カスタマー管理キーを使用する場合、事前にKMSキーを作成
# - IAM権限: aoss:CreateSecurityPolicy, aoss:UpdateSecurityPolicy
#
# 関連リソース:
# - aws_opensearchserverless_collection
# - aws_kms_key (カスタマー管理キーを使用する場合)
#
# 公式ドキュメント:
# - https://docs.aws.amazon.com/opensearch-service/latest/developerguide/serverless-encryption.html
# - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/opensearchserverless_security_policy
#
# ================================================================================

# --------------------------------------------------------------------------------
# 基本設定 - AWS所有キーによる暗号化 (推奨開始点)
# --------------------------------------------------------------------------------
resource "aws_opensearchserverless_security_policy" "encryption_basic" {
  # ポリシー名 (必須)
  # - 3〜32文字の長さ
  # - 小文字、数字、ハイフンのみ使用可能
  # - 小文字で開始する必要がある
  # - アカウント内で一意である必要がある
  name = "example-encryption-policy"

  # セキュリティポリシーのタイプ (必須)
  # - 有効な値: "encryption" または "network"
  # - このテンプレートでは暗号化ポリシーを定義
  type = "encryption"

  # ポリシーの説明 (オプション)
  # - ポリシーで定義された権限に関する情報を保存
  # - 管理目的で使用される
  description = "Encryption policy for example collection using AWS-owned key"

  # JSON形式のポリシードキュメント (必須)
  # - Rules: 暗号化ルールのリスト
  # - Resource: 適用するコレクションのパターン (ワイルドカード使用可)
  # - ResourceType: "collection" (現在はコレクションのみサポート)
  # - AWSOwnedKey: AWS所有キーを使用する場合はtrue
  policy = jsonencode({
    Rules = [
      {
        Resource = [
          "collection/example-collection"
        ],
        ResourceType = "collection"
      }
    ],
    AWSOwnedKey = true
  })

  # リージョンの指定 (オプション)
  # - 指定しない場合、プロバイダー設定のリージョンを使用
  # region = "us-east-1"
}

# --------------------------------------------------------------------------------
# ワイルドカードパターン - 複数コレクションへの適用
# --------------------------------------------------------------------------------
resource "aws_opensearchserverless_security_policy" "encryption_wildcard" {
  name        = "example-wildcard-encryption"
  type        = "encryption"
  description = "Encryption policy for collections starting with 'example-'"

  # ワイルドカード(*)を使用して複数のコレクションに適用
  # - "example-*" は "example-" で始まる全てのコレクションにマッチ
  # - スケーラブルな暗号化管理に有効
  policy = jsonencode({
    Rules = [
      {
        Resource = [
          "collection/example-*"
        ],
        ResourceType = "collection"
      }
    ],
    AWSOwnedKey = true
  })
}

# --------------------------------------------------------------------------------
# カスタマー管理キー(CMK) - 高度な暗号化制御
# --------------------------------------------------------------------------------
resource "aws_opensearchserverless_security_policy" "encryption_cmk" {
  name        = "example-cmk-encryption"
  type        = "encryption"
  description = "Encryption policy using customer-managed KMS key"

  # カスタマー管理キーを使用した暗号化設定
  # - AWSOwnedKey: false (カスタマー管理キーを使用)
  # - KmsARN: 使用するKMSキーのARN
  #
  # 利点:
  # - キーのローテーション制御
  # - キーへのアクセス監査
  # - キーポリシーによる細かいアクセス制御
  #
  # 注意:
  # - KMSキーは事前に作成されている必要がある
  # - 追加のKMS料金が発生する
  # - キーポリシーでOpenSearch Serverlessサービスに使用権限を付与する必要がある
  policy = jsonencode({
    Rules = [
      {
        Resource = [
          "collection/secure-collection"
        ],
        ResourceType = "collection"
      }
    ],
    AWSOwnedKey = false
    KmsARN      = "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"
  })
}

# --------------------------------------------------------------------------------
# 複数リソースパターン - 複雑な暗号化要件
# --------------------------------------------------------------------------------
resource "aws_opensearchserverless_security_policy" "encryption_multiple" {
  name        = "example-multiple-encryption"
  type        = "encryption"
  description = "Encryption policy for multiple collection patterns"

  # 複数のリソースパターンを定義
  # - 異なるコレクションパターンに対して同じ暗号化設定を適用
  # - 組織の命名規則に基づいた柔軟な管理
  policy = jsonencode({
    Rules = [
      {
        Resource = [
          "collection/prod-*",
          "collection/staging-*",
          "collection/dev-*"
        ],
        ResourceType = "collection"
      }
    ],
    AWSOwnedKey = true
  })
}

# --------------------------------------------------------------------------------
# Outputs - 他のリソースで参照可能な値
# --------------------------------------------------------------------------------

# ポリシー名 (コレクション作成時に必要)
output "encryption_policy_name" {
  description = "Name of the encryption security policy"
  value       = aws_opensearchserverless_security_policy.encryption_basic.name
}

# ポリシーバージョン (監査・追跡用)
output "encryption_policy_version" {
  description = "Version of the encryption security policy"
  value       = aws_opensearchserverless_security_policy.encryption_basic.policy_version
}

# ポリシーID (一意識別子)
output "encryption_policy_id" {
  description = "ID of the encryption security policy"
  value       = aws_opensearchserverless_security_policy.encryption_basic.id
}

# ================================================================================
# 重要な注意事項
# ================================================================================
#
# 1. 暗号化ポリシーの作成タイミング
#    - コレクション作成前に暗号化ポリシーを作成する必要がある
#    - ポリシーが存在しないとコレクション作成は失敗する
#
# 2. ポリシーの変更と影響
#    - 既存のコレクションに適用されているポリシーの変更は注意が必要
#    - 暗号化キーの変更は既存データの再暗号化を必要とする場合がある
#
# 3. カスタマー管理キー使用時の考慮事項
#    - KMSキーポリシーでOpenSearch Serverlessサービスプリンシパルに権限を付与
#    - キーの削除や無効化はコレクションへのアクセスに影響
#    - 追加のKMS料金が発生する
#
# 4. リソースパターンのベストプラクティス
#    - 明示的な命名規則を使用してワイルドカードパターンを効果的に活用
#    - 過度に広範なパターンは避け、適切にスコープを限定
#    - 環境やチーム別にポリシーを分離
#
# 5. コンプライアンスとセキュリティ
#    - 規制要件に応じてカスタマー管理キーの使用を検討
#    - ポリシーの変更履歴を監査ログで追跡
#    - 定期的にポリシーの有効性をレビュー
#
# 6. コスト最適化
#    - AWS所有キーは追加料金なし (推奨開始点)
#    - カスタマー管理キーは必要な場合のみ使用
#
# ================================================================================
