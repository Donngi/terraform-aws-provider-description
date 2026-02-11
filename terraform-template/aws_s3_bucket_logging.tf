# =============================================================================
# AWS S3 Bucket Logging (Server Access Logging)
# =============================================================================
# S3バケットのサーバーアクセスログを管理するリソース
#
# 【重要な概念】
# - サーバーアクセスログは、S3バケットへのリクエストの詳細な記録を提供
# - セキュリティ監査、アクセス分析、課金理解に有用
# - デフォルトではログ収集は無効（明示的に有効化が必要）
#
# 【ログ配信の仕組み】
# - ログはソースバケットから宛先バケット（ターゲットバケット）に配信される
# - 宛先バケットはソースバケットと同じリージョン・同じAWSアカウント内に必要
# - ログ配信には数時間かかる場合がある
#
# 【CloudTrailとの比較】
# - CloudTrail: バケット・オブジェクトレベルのアクションに推奨、複数の宛先配信可能
# - サーバーアクセスログ: ライフサイクル移行、一括削除のキーログ記録など追加情報
# - 両方を組み合わせて使用することも可能
#
# 【コスト】
# - ログ有効化自体に追加料金なし
# - ログファイルのストレージには通常のS3料金が適用
# - ログファイル配信にデータ転送料金は不課金
#
# 【注意事項】
# - 宛先バケットでサーバーアクセスログを有効にしないこと（無限ループの原因）
# - ソースバケット自体をログ宛先にすることは可能だが非推奨
# - S3 Object Lockが有効なバケットは宛先バケットとして使用不可
# - 宛先バケットでRequester Paysを有効にしないこと
# - S3ディレクトリバケットでは使用不可
#
# 【セキュリティベストプラクティス】
# - AWS Security Hubコントロール: S3.9でサーバーアクセスログ設定を推奨
# - AWS Control Tower: CT.S3.PR.1でサーバーアクセスログ設定を要求
# - ログファイルは定期的に確認し、不要になったら削除
# - ログ宛先バケットには適切なアクセス制御を設定
#
# 参考:
# - https://docs.aws.amazon.com/AmazonS3/latest/userguide/ServerLogs.html
# - https://docs.aws.amazon.com/AmazonS3/latest/userguide/enable-server-access-logging.html
# - https://docs.aws.amazon.com/AmazonS3/latest/userguide/logging-with-S3.html
# - https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/s3_bucket_logging
#
# =============================================================================

# -----------------------------------------------------------------------------
# 基本設定パターン: バケットポリシーによる権限付与（推奨）
# -----------------------------------------------------------------------------
# 最新のベストプラクティスに従い、logging.s3.amazonaws.comサービスプリンシパルに
# バケットポリシーで権限を付与する方法
#
# 【推奨される理由】
# - Bucket owner enforcedのObject Ownership設定と互換性あり
# - ACLは新しいバケットではデフォルトで無効化されている
# - より明示的で管理しやすい権限設定
#
# 【設定の流れ】
# 1. ログ宛先バケットを作成
# 2. 宛先バケットにlogging.s3.amazonaws.comへのs3:PutObject権限を付与するポリシーを設定
# 3. ソースバケットでログ設定を有効化

# ログ宛先バケット
resource "aws_s3_bucket" "logging" {
  bucket = "example-access-logs-bucket"

  # タグ: ログバケットを識別しやすくする
  tags = {
    Name        = "Access Logs Bucket"
    Purpose     = "S3 Server Access Logs"
    Environment = "production"
  }
}

# ログ宛先バケットのポリシー（推奨方法）
# logging.s3.amazonaws.comサービスプリンシパルにログ書き込み権限を付与
data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "logging_bucket_policy" {
  statement {
    sid    = "S3ServerAccessLogsPolicy"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["logging.s3.amazonaws.com"]
    }

    actions = ["s3:PutObject"]

    # ログオブジェクトのリソースARN
    # target_prefixを指定する場合は、そのプレフィックスパスを含める
    resources = ["${aws_s3_bucket.logging.arn}/logs/*"]

    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"
      # ソースバケットのARNを指定（ログを収集したいバケット）
      values = ["arn:aws:s3:::example-source-bucket"]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      # ソースバケットを所有するAWSアカウントID
      values = [data.aws_caller_identity.current.account_id]
    }
  }
}

resource "aws_s3_bucket_policy" "logging" {
  bucket = aws_s3_bucket.logging.bucket
  policy = data.aws_iam_policy_document.logging_bucket_policy.json
}

# ソースバケット（ログ収集対象）
resource "aws_s3_bucket" "example" {
  bucket = "example-source-bucket"

  tags = {
    Name        = "Example Source Bucket"
    Environment = "production"
  }
}

# サーバーアクセスログ設定（基本パターン）
resource "aws_s3_bucket_logging" "example" {
  # 必須: ログを収集したいソースバケット
  bucket = aws_s3_bucket.example.bucket

  # 必須: ログを保存する宛先バケット
  # ソースバケットと同じリージョン・同じAWSアカウント内である必要がある
  target_bucket = aws_s3_bucket.logging.bucket

  # 必須: ログオブジェクトキーのプレフィックス
  # プレフィックスの末尾にスラッシュ(/)を付けるとログファイルを見つけやすい
  # 例: "logs/" → logs/2013-11-01-21-32-16-E568B2907131C0C0
  # 例: "logs" → logs2013-11-01-21-32-16-E568B2907131C0C0
  target_prefix = "logs/"

  # 備考:
  # - ログ配信には数時間かかる場合がある
  # - このリソースが作成されても、すぐにはログファイルが表示されない可能性あり
  # - aws_s3_bucket_policyの設定が完了してから有効化される必要がある
}

# -----------------------------------------------------------------------------
# 高度なパターン1: パーティション化されたプレフィックス（推奨）
# -----------------------------------------------------------------------------
# ログオブジェクトを日付ベースでパーティション化することで、ログの検索と管理が容易になる
#
# 【パーティション化のメリット】
# - ログファイルが日付・アカウント・リージョン・バケットごとに整理される
# - 特定期間のログを素早く見つけられる
# - S3 Selectやクエリツールでの分析が効率的
# - ライフサイクルポリシーによる管理が容易
#
# 【フォーマット】
# [target_prefix][SourceAccountId]/[SourceRegion]/[SourceBucket]/[YYYY]/[MM]/[DD]/[YYYY]-[MM]-[DD]-[hh]-[mm]-[ss]-[UniqueString]
#
# 【partition_date_source】
# - EventTime: S3イベントが発生した時刻でパーティション化（推奨）
# - DeliveryTime: ログファイルが配信された時刻でパーティション化

resource "aws_s3_bucket_logging" "partitioned_prefix" {
  bucket = aws_s3_bucket.example.bucket

  target_bucket = aws_s3_bucket.logging.bucket
  target_prefix = "partitioned-logs/"

  # ログオブジェクトキーのフォーマット設定
  target_object_key_format {
    # パーティション化されたプレフィックス（日付ベース構造）
    partitioned_prefix {
      # partition_date_source: パーティション日付のソース
      # - EventTime: イベント発生時刻でパーティション化（推奨）
      #   リクエストが実際に発生した時刻に基づいてログを整理
      # - DeliveryTime: ログ配信時刻でパーティション化
      #   ログファイルがS3に書き込まれた時刻に基づいて整理
      partition_date_source = "EventTime"
    }

    # 注意: partitioned_prefixとsimple_prefixは相互排他的
    # どちらか一方のみ指定可能
  }

  # 結果のログオブジェクトキー例:
  # partitioned-logs/123456789012/us-east-1/example-source-bucket/2024/01/15/2024-01-15-10-30-45-ABCD1234EFGH5678
}

# -----------------------------------------------------------------------------
# 高度なパターン2: シンプルプレフィックス
# -----------------------------------------------------------------------------
# 従来のシンプルなキーフォーマット（日付情報のみ）
#
# 【フォーマット】
# [target_prefix][YYYY]-[MM]-[DD]-[hh]-[mm]-[ss]-[UniqueString]
#
# 【使用場面】
# - 既存のログ処理ワークフローとの互換性維持
# - シンプルな構造で十分な場合

resource "aws_s3_bucket_logging" "simple_prefix" {
  bucket = aws_s3_bucket.example.bucket

  target_bucket = aws_s3_bucket.logging.bucket
  target_prefix = "simple-logs/"

  target_object_key_format {
    # シンプルプレフィックス（従来形式）
    # ブロックは空だが、明示的に指定する必要がある
    simple_prefix {}

    # 注意: partitioned_prefixとsimple_prefixは相互排他的
  }

  # 結果のログオブジェクトキー例:
  # simple-logs/2024-01-15-10-30-45-ABCD1234EFGH5678
}

# -----------------------------------------------------------------------------
# 高度なパターン3: ターゲットグラント（ACLベースの権限付与）
# -----------------------------------------------------------------------------
# ログファイルへのアクセス権限を特定のユーザーやグループに付与
#
# 【重要な制約】
# - Bucket owner enforcedのObject Ownership設定では使用不可
# - 新しいバケットではACLがデフォルトで無効化されているため非推奨
# - レガシーシステムとの互換性が必要な場合のみ使用
#
# 【設定要件】
# - 宛先バケットのObject OwnershipがBucket owner preferredまたはObject writer
# - 宛先バケットでACLが有効化されている必要がある
#
# 【代替推奨方法】
# - 宛先バケットのバケットポリシーでアクセス制御を管理する
# - IAMロールとポリシーでアクセス権限を管理する

# ACLベースの設定例（非推奨だが参考として記載）
resource "aws_s3_bucket" "log_bucket_with_acl" {
  bucket = "example-logs-with-acl"
}

resource "aws_s3_bucket_acl" "log_bucket_acl" {
  bucket = aws_s3_bucket.log_bucket_with_acl.id
  # log-delivery-write: S3ログ配信グループにWRITEとREAD_ACP権限を付与
  acl = "log-delivery-write"
}

resource "aws_s3_bucket_logging" "with_target_grant" {
  bucket = aws_s3_bucket.example.bucket

  target_bucket = aws_s3_bucket.log_bucket_with_acl.bucket
  target_prefix = "logs-with-grant/"

  # ターゲットグラント: ログオブジェクトへのアクセス権限を付与
  # 複数のグラントを指定可能
  target_grant {
    # 権限受領者（grantee）の設定
    grantee {
      # type: 権限受領者のタイプ
      # - CanonicalUser: 正規ユーザーID
      # - AmazonCustomerByEmail: メールアドレス（一部リージョンのみ）
      # - Group: 定義済みグループ
      type = "Group"

      # uri: グループURI（typeがGroupの場合）
      # 例: http://acs.amazonaws.com/groups/s3/LogDelivery
      uri = "http://acs.amazonaws.com/groups/s3/LogDelivery"

      # id: 正規ユーザーID（typeがCanonicalUserの場合）
      # id = "canonical-user-id"

      # email_address: メールアドレス（typeがAmazonCustomerByEmailの場合）
      # 注意: 一部のリージョンでのみサポート
      # email_address = "user@example.com"
    }

    # permission: 付与する権限
    # - FULL_CONTROL: フルコントロール
    # - READ: 読み取り
    # - WRITE: 書き込み
    permission = "FULL_CONTROL"
  }

  # 複数のグラントを追加可能
  target_grant {
    grantee {
      type = "CanonicalUser"
      id   = "canonical-user-id-example"
    }
    permission = "READ"
  }

  # 注意事項:
  # - Bucket owner enforced設定では使用不可
  # - 新規実装では宛先バケットのバケットポリシーでアクセス制御を推奨
  # - このパターンはレガシーシステムとの互換性目的でのみ使用すること
}

# -----------------------------------------------------------------------------
# オプション設定: 期待されるバケット所有者
# -----------------------------------------------------------------------------
# expected_bucket_owner: セキュリティ強化のためのアカウントID検証
#
# 【目的】
# - バケット所有者の誤操作防止
# - マルチアカウント環境での誤設定防止
# - 指定したAWSアカウントIDと実際の所有者が異なる場合、操作が失敗する
#
# 【使用場面】
# - マルチアカウント環境で厳格な制御が必要な場合
# - コンプライアンス要件で所有者検証が必要な場合

resource "aws_s3_bucket_logging" "with_expected_owner" {
  bucket = aws_s3_bucket.example.bucket

  # expected_bucket_owner: ソースバケットの期待される所有者のAWSアカウントID
  # 実際の所有者と異なる場合、リソース作成が失敗する（Forces new resource）
  expected_bucket_owner = data.aws_caller_identity.current.account_id

  target_bucket = aws_s3_bucket.logging.bucket
  target_prefix = "logs/"
}

# -----------------------------------------------------------------------------
# オプション設定: リージョン指定
# -----------------------------------------------------------------------------
# region: リソースが管理されるリージョンを明示的に指定
#
# 【デフォルト動作】
# - 指定しない場合、プロバイダー設定のリージョンが使用される
#
# 【使用場面】
# - プロバイダーのデフォルトリージョンと異なるリージョンで管理したい場合
# - マルチリージョン構成で明示的にリージョンを指定したい場合
#
# 【制約】
# - ソースバケットと宛先バケットは同じリージョンである必要がある

resource "aws_s3_bucket_logging" "with_region" {
  bucket = aws_s3_bucket.example.bucket

  # region: リソースを管理するリージョン
  # 通常はプロバイダー設定に従うため、指定不要
  region = "us-east-1"

  target_bucket = aws_s3_bucket.logging.bucket
  target_prefix = "logs/"
}

# -----------------------------------------------------------------------------
# 統合パターン: 包括的なログ設定（本番環境推奨）
# -----------------------------------------------------------------------------
# 本番環境で推奨される、セキュリティとガバナンスを考慮した設定例

# ログ宛先バケット（本番環境用）
resource "aws_s3_bucket" "production_logs" {
  bucket = "production-s3-access-logs"

  tags = {
    Name        = "Production S3 Access Logs"
    Purpose     = "Centralized S3 Server Access Logs"
    Environment = "production"
    Compliance  = "required"
  }
}

# ログバケットの暗号化
resource "aws_s3_bucket_server_side_encryption_configuration" "production_logs" {
  bucket = aws_s3_bucket.production_logs.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# ログバケットのバージョニング（監査証跡の保護）
resource "aws_s3_bucket_versioning" "production_logs" {
  bucket = aws_s3_bucket.production_logs.bucket

  versioning_configuration {
    status = "Enabled"
  }
}

# ログバケットのライフサイクル管理
resource "aws_s3_bucket_lifecycle_configuration" "production_logs" {
  bucket = aws_s3_bucket.production_logs.bucket

  rule {
    id     = "transition-old-logs"
    status = "Enabled"

    # 90日後にInfrequent Accessに移行
    transition {
      days          = 90
      storage_class = "STANDARD_IA"
    }

    # 180日後にGlacierに移行
    transition {
      days          = 180
      storage_class = "GLACIER"
    }

    # 365日後に削除
    expiration {
      days = 365
    }
  }
}

# ログバケットのパブリックアクセスブロック（セキュリティ強化）
resource "aws_s3_bucket_public_access_block" "production_logs" {
  bucket = aws_s3_bucket.production_logs.bucket

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# ログバケットのバケットポリシー（本番環境用）
data "aws_iam_policy_document" "production_logging_policy" {
  # ログ配信サービスプリンシパルへの権限付与
  statement {
    sid    = "S3ServerAccessLogsPolicy"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["logging.s3.amazonaws.com"]
    }

    actions   = ["s3:PutObject"]
    resources = ["${aws_s3_bucket.production_logs.arn}/*"]

    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"
      # 複数のソースバケットを指定可能
      values = [
        "arn:aws:s3:::production-app-bucket-*",
        "arn:aws:s3:::production-data-bucket-*"
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = [data.aws_caller_identity.current.account_id]
    }
  }

  # SSLを強制（セキュリティベストプラクティス）
  statement {
    sid    = "DenyInsecureTransport"
    effect = "Deny"

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions   = ["s3:*"]
    resources = [
      aws_s3_bucket.production_logs.arn,
      "${aws_s3_bucket.production_logs.arn}/*"
    ]

    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }
  }
}

resource "aws_s3_bucket_policy" "production_logs" {
  bucket = aws_s3_bucket.production_logs.bucket
  policy = data.aws_iam_policy_document.production_logging_policy.json
}

# 本番環境のソースバケット
resource "aws_s3_bucket" "production_app" {
  bucket = "production-app-bucket"

  tags = {
    Name        = "Production Application Bucket"
    Environment = "production"
    Logging     = "enabled"
  }
}

# 本番環境のログ設定
resource "aws_s3_bucket_logging" "production" {
  bucket = aws_s3_bucket.production_app.bucket

  expected_bucket_owner = data.aws_caller_identity.current.account_id

  target_bucket = aws_s3_bucket.production_logs.bucket
  target_prefix = "app-logs/"

  # パーティション化されたプレフィックスで整理（推奨）
  target_object_key_format {
    partitioned_prefix {
      partition_date_source = "EventTime"
    }
  }

  # 依存関係の明示
  # バケットポリシーが設定されてからログ設定を有効化
  depends_on = [
    aws_s3_bucket_policy.production_logs,
    aws_s3_bucket_public_access_block.production_logs
  ]
}

# -----------------------------------------------------------------------------
# Output例
# -----------------------------------------------------------------------------
# 作成したリソースの情報を出力

output "logging_bucket_name" {
  description = "ログ宛先バケット名"
  value       = aws_s3_bucket.logging.bucket
}

output "logging_bucket_arn" {
  description = "ログ宛先バケットARN"
  value       = aws_s3_bucket.logging.arn
}

output "source_bucket_name" {
  description = "ログソースバケット名"
  value       = aws_s3_bucket.example.bucket
}

output "logging_configuration_id" {
  description = "ログ設定のID"
  value       = aws_s3_bucket_logging.example.id
}

# =============================================================================
# ベストプラクティスチェックリスト
# =============================================================================
#
# □ ログ宛先バケットでサーバーアクセスログを有効にしていない
# □ ログ宛先バケットのバケットポリシーでlogging.s3.amazonaws.comに権限付与
# □ ソースバケットと宛先バケットが同じリージョン・同じアカウント
# □ target_prefixの末尾にスラッシュ(/)を付けている
# □ パーティション化されたプレフィックスを使用（EventTime推奨）
# □ ログバケットに暗号化を設定
# □ ログバケットにライフサイクルポリシーを設定（コスト最適化）
# □ ログバケットにパブリックアクセスブロックを設定
# □ ログバケットのバケットポリシーでSSLを強制
# □ 必要に応じてログバケットのバージョニングを有効化
# □ ログ配信の依存関係（depends_on）を明示
# □ 適切なタグ付けで管理とコスト配分を実施
#
# =============================================================================
# トラブルシューティング
# =============================================================================
#
# 【ログが配信されない場合】
# 1. ログ宛先バケットのバケットポリシーが正しく設定されているか確認
#    - logging.s3.amazonaws.comへのs3:PutObject権限
#    - aws:SourceArnとaws:SourceAccountの条件
# 2. ソースバケットと宛先バケットが同じリージョンか確認
# 3. ログ配信には数時間かかる場合があることを考慮
# 4. 宛先バケットでサーバーアクセスログが有効になっていないか確認
# 5. 宛先バケットでS3 Object Lockが有効になっていないか確認
# 6. 宛先バケットでRequester Paysが有効になっていないか確認
#
# 【ACL関連のエラー】
# - "AccessControlListNotSupported"エラーが発生する場合
#   → 宛先バケットがBucket owner enforced設定
#   → target_grantを削除し、バケットポリシーで権限管理に移行
#
# 【権限エラー】
# - "AccessDenied"エラーが発生する場合
#   → バケットポリシーのConditionブロックでaws:SourceArnとaws:SourceAccountを確認
#   → Denyステートメントがログ配信を妨げていないか確認
#
# 【リソース作成エラー】
# - expected_bucket_ownerの値が実際の所有者と異なる場合、リソース作成が失敗
#   → 正しいAWSアカウントIDを指定
#
# =============================================================================
