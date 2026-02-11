################################################################################
# Terraform AWS Provider Resource: aws_glacier_vault_lock
# Provider Version: 6.28.0
#
# AWS Glacier Vault Lock リソース
#
# Amazon Glacier Vault Lock は、個々のボルトにコンプライアンスコントロールを適用する
# ための機能です。WORM (Write Once Read Many) コントロールを含むポリシーを設定し、
# ロックすることで将来の変更を防ぐことができます。
#
# AWS公式ドキュメント:
# https://docs.aws.amazon.com/amazonglacier/latest/dev/vault-lock.html
#
# 注意事項:
# - Vault Lock は一度完了すると不変であり、削除や変更はできません
# - complete_lock を true に設定すると永続的にポリシーが適用されます
# - complete_lock を false に設定するとテストモードとなり、24時間後に自動削除されます
# - Amazon Glacier は新規顧客を受け付けていません。新しいアーカイブストレージには
#   Amazon S3 Glacier ストレージクラスの使用が推奨されています
################################################################################

################################################################################
# 基本的な使用例（テストモード）
################################################################################
resource "aws_glacier_vault_lock" "test_example" {
  # -----------------------------------------------------------------------------
  # 必須パラメータ
  # -----------------------------------------------------------------------------

  # vault_name - Glacier Vault の名前（必須）
  #
  # Vault Lock ポリシーを適用する Glacier Vault の名前を指定します。
  # 事前に aws_glacier_vault リソースで作成されたボルトを指定する必要があります。
  #
  # 型: string
  # 必須: Yes
  # 更新: 再作成が必要
  vault_name = aws_glacier_vault.example.name

  # complete_lock - ポリシーの永続適用フラグ（必須）
  #
  # Glacier Lock Policy を永続的に適用するかどうかを指定します。
  #
  # - false: テストモードで、24時間後に自動的にポリシーが削除されます
  #          この期間中にポリシーの動作を検証できます
  # - true:  永続的にポリシーを適用します。一度適用すると取り消し不可能です
  #
  # false から true への変更はリソースの再作成として表示されます（想定される動作）。
  # true から false への変更は、同時に Glacier Vault を再作成しない限り不可能です。
  #
  # 型: bool
  # 必須: Yes
  # デフォルト値: なし
  # 更新: 再作成が必要
  complete_lock = false

  # policy - IAM ポリシー（JSON形式）（必須）
  #
  # Glacier Vault Lock ポリシーとして適用する IAM ポリシーを JSON 文字列で指定します。
  #
  # 一般的なポリシー例:
  # - アーカイブの保持期間を強制（例: 365日未満のアーカイブの削除を拒否）
  # - 法的保持（タグに基づくアーカイブの削除を拒否）
  #
  # ベストプラクティス:
  # - jsonencode() 関数または aws_iam_policy_document データソースの使用を推奨
  # - これにより JSON フォーマットの不整合や空白の問題を回避できます
  # - ポリシーサイズは最大 20 KB です
  #
  # 型: string (JSON)
  # 必須: Yes
  # 更新: 再作成が必要
  policy = data.aws_iam_policy_document.example.json

  # -----------------------------------------------------------------------------
  # オプションパラメータ
  # -----------------------------------------------------------------------------

  # ignore_deletion_error - 削除エラーの無視（オプション）
  #
  # Glacier Lock Policy の削除を試みた際に返されるエラーを Terraform に無視させます。
  #
  # 使用ケース:
  # - Vault Lock ポリシーが許可する場合、Terraform 経由で Glacier Vault を
  #   削除または再作成するために使用できます
  # - complete_lock が true に設定されている場合にのみ使用すべきです
  #
  # 注意:
  # - ロックされた Vault Lock ポリシーは削除できないため、Terraform での
  #   リソース削除時にエラーが発生します
  # - このオプションを使用する前に、`terraform state rm` でリソースを
  #   Terraform 管理から除外することも検討してください
  #
  # 型: bool
  # 必須: No
  # デフォルト値: false
  # 更新: 可能
  # ignore_deletion_error = true

  # region - リージョン（オプション）
  #
  # このリソースが管理されるリージョンを指定します。
  # 指定しない場合、プロバイダー設定のリージョンがデフォルトで使用されます。
  #
  # 型: string
  # 必須: No
  # デフォルト値: プロバイダーのリージョン設定
  # 更新: 再作成が必要
  # region = "us-east-1"
}

################################################################################
# 永続適用の使用例（本番環境）
################################################################################
resource "aws_glacier_vault_lock" "production_example" {
  vault_name    = aws_glacier_vault.production.name
  complete_lock = true
  policy        = data.aws_iam_policy_document.production_policy.json

  # 永続適用の場合は削除エラーを無視する設定を推奨
  ignore_deletion_error = true
}

################################################################################
# データソース例: IAM ポリシードキュメント
################################################################################

# 例1: 365日未満のアーカイブの削除を拒否するポリシー
data "aws_iam_policy_document" "retention_policy" {
  statement {
    # glacier:DeleteArchive アクションを拒否
    actions   = ["glacier:DeleteArchive"]
    effect    = "Deny"
    resources = [aws_glacier_vault.example.arn]

    # アーカイブの年齢が 365 日以下の場合に適用
    condition {
      test     = "NumericLessThanEquals"
      variable = "glacier:ArchiveAgeInDays"
      values   = ["365"]
    }
  }
}

# 例2: タグに基づく法的保持ポリシー
data "aws_iam_policy_document" "legal_hold_policy" {
  statement {
    actions   = ["glacier:DeleteArchive"]
    effect    = "Deny"
    resources = [aws_glacier_vault.example.arn]

    # 特定のタグを持つアーカイブの削除を拒否
    condition {
      test     = "StringEquals"
      variable = "glacier:ResourceTag/LegalHold"
      values   = ["true"]
    }
  }
}

# 例3: 複数の条件を持つポリシー
data "aws_iam_policy_document" "comprehensive_policy" {
  # 保持期間による制限
  statement {
    sid       = "DenyDeleteBeforeRetention"
    actions   = ["glacier:DeleteArchive"]
    effect    = "Deny"
    resources = [aws_glacier_vault.example.arn]

    condition {
      test     = "NumericLessThanEquals"
      variable = "glacier:ArchiveAgeInDays"
      values   = ["2555"] # 約7年間の保持
    }
  }

  # 特定のプリンシパル以外の削除を拒否
  statement {
    sid       = "DenyDeleteExceptAdmin"
    actions   = ["glacier:DeleteArchive"]
    effect    = "Deny"
    resources = [aws_glacier_vault.example.arn]

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    condition {
      test     = "StringNotEquals"
      variable = "aws:PrincipalArn"
      values   = ["arn:aws:iam::123456789012:role/GlacierAdmin"]
    }
  }
}

################################################################################
# 依存リソース例: Glacier Vault
################################################################################
resource "aws_glacier_vault" "example" {
  name = "example-vault"

  # Vault の通知設定（オプション）
  notification {
    sns_topic = aws_sns_topic.glacier.arn
    events    = ["ArchiveRetrievalCompleted", "InventoryRetrievalCompleted"]
  }

  # アクセスポリシー（オプション）
  access_policy = data.aws_iam_policy_document.vault_access_policy.json

  tags = {
    Name        = "Example Glacier Vault"
    Environment = "Production"
  }
}

# Vault アクセスポリシー（Vault Lock ポリシーとは別）
data "aws_iam_policy_document" "vault_access_policy" {
  statement {
    actions = [
      "glacier:InitiateJob",
      "glacier:GetJobOutput",
    ]
    effect    = "Allow"
    resources = ["arn:aws:glacier:us-west-2:123456789012:vaults/example-vault"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::123456789012:role/GlacierAccessRole"]
    }
  }
}

################################################################################
# 出力例
################################################################################
output "vault_lock_id" {
  description = "Glacier Vault Lock のリソース ID（Vault 名と同じ）"
  value       = aws_glacier_vault_lock.test_example.id
}

output "vault_lock_vault_name" {
  description = "Vault Lock が適用されている Glacier Vault の名前"
  value       = aws_glacier_vault_lock.test_example.vault_name
}

################################################################################
# 補足説明
################################################################################

# 1. Vault Lock のライフサイクル:
#    a. テストフェーズ (complete_lock = false):
#       - ポリシーを適用し、24時間以内に動作を検証
#       - 24時間後に自動的に削除され、Terraform はリソースの再作成が必要と表示
#
#    b. 本番フェーズ (complete_lock = true):
#       - ポリシーを永続的に適用
#       - この操作は不可逆であり、取り消し不可能
#       - false から true への変更は、リソースの再作成として表示される

# 2. 削除の制限:
#    - ロックされた Vault Lock ポリシーは削除できません
#    - Terraform でリソースを削除しようとするとエラーが発生します
#    - 対処方法:
#      a. ignore_deletion_error = true を設定してから削除を実行
#      b. `terraform state rm aws_glacier_vault_lock.example` で
#         Terraform 管理から除外

# 3. ポリシー設計のベストプラクティス:
#    - 保持期間は組織のコンプライアンス要件に基づいて設定
#    - テストモードで十分にポリシーを検証してから complete_lock を true に設定
#    - ポリシーは 20 KB 以下に制限されています
#    - jsonencode() または aws_iam_policy_document を使用して JSON の整形問題を回避

# 4. Vault Lock vs Vault Access Policy:
#    - Vault Lock Policy: コンプライアンスコントロールの強制（不変）
#    - Vault Access Policy: アクセス権限の管理（変更可能）
#    - 各 Vault には、1つの Vault Lock Policy と 1つの Vault Access Policy を
#      持つことができます

# 5. コスト考慮事項:
#    - Vault を所有するアカウントが、すべての Vault 関連コストを負担します
#    - クロスアカウントアクセスを許可した場合でも、所有者がコストを負担

# 6. リージョン対応:
#    - Glacier は複数のリージョンで利用可能ですが、リソースはリージョン固有です
#    - マルチリージョン構成の場合は、各リージョンに個別の Vault を作成

# 7. モニタリングとロギング:
#    - AWS CloudTrail を使用して、Vault Lock 関連の API 呼び出しを監査
#    - SNS 通知を設定して、ジョブの完了を追跡

# 8. セキュリティのベストプラクティス:
#    - 最小権限の原則に従い、必要最小限のアクションのみを許可
#    - MFA を要求する条件を追加して、削除操作を保護
#    - 定期的にポリシーの有効性をレビュー

# 9. Amazon Glacier の現状:
#    - Amazon Glacier スタンドアロンサービスは新規顧客を受け付けていません
#    - 新しいアーカイブストレージには、Amazon S3 Glacier ストレージクラスの
#      使用が推奨されています
#    - 既存の Glacier データは引き続き安全にアクセス可能です

################################################################################
# 属性リファレンス
################################################################################

# 利用可能な属性:
# - id: Glacier Vault 名（vault_name と同じ値）
