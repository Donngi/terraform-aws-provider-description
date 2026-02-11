################################################################################
# AWS S3 Bucket Server-Side Encryption Configuration
################################################################################

# リソース概要:
# S3バケットのサーバーサイド暗号化設定を管理するリソース
#
# 重要な注意点:
# - このリソースを削除すると、バケットはAmazon S3のデフォルト暗号化にリセットされます
# - 2023年1月5日以降、全ての新規オブジェクトアップロードは自動的にSSE-S3で暗号化されます
# - 2026年3月以降、新規バケットでは自動的にSSE-C（顧客提供キー）がブロックされます
# - 2026年4月以降、SSE-C暗号化されたデータがない既存バケットでもSSE-Cが無効化されます
#
# ベストプラクティス:
# 1. SSE-KMSを使用して暗号化キーの制御を強化
# 2. bucket_key_enabledをtrueに設定してKMSコストを削減
# 3. blocked_encryption_types = ["SSE-C"]を設定してセキュリティを強化
# 4. AWS Configのs3-bucket-server-side-encryption-enabledルールで検証
# 5. クロスアカウントアクセスにはカスタマー管理キーを使用
#
# 参照:
# - https://docs.aws.amazon.com/AmazonS3/latest/userguide/serv-side-encryption.html
# - https://docs.aws.amazon.com/AmazonS3/latest/userguide/bucket-encryption.html
# - https://docs.aws.amazon.com/prescriptive-guidance/latest/encryption-best-practices/s3.html

resource "aws_s3_bucket_server_side_encryption_configuration" "example" {
  #-----------------------------------------------------------------------------
  # 必須パラメータ
  #-----------------------------------------------------------------------------

  # bucket - (必須, 強制的に新規リソース作成)
  # バケットのID（名前）
  #
  # 値の形式: バケット名文字列
  # 例: "my-encrypted-bucket", aws_s3_bucket.example.id
  #
  # 注意事項:
  # - 既存のaws_s3_bucketリソースのIDを参照することを推奨
  # - バケット名を直接指定することも可能
  # - 変更すると強制的に新規リソースが作成されます
  bucket = aws_s3_bucket.example.id

  #-----------------------------------------------------------------------------
  # オプションパラメータ
  #-----------------------------------------------------------------------------

  # expected_bucket_owner - (オプション, 強制的に新規リソース作成)
  # 想定されるバケット所有者のアカウントID
  #
  # 値の形式: 12桁のAWSアカウントID
  # 例: "123456789012"
  #
  # 用途:
  # - バケット所有者の検証によるセキュリティ強化
  # - 意図しないバケットへの設定適用を防止
  # - クロスアカウントシナリオでの安全性確保
  # expected_bucket_owner = "123456789012"

  # region - (オプション, 計算値あり)
  # このリソースが管理されるリージョン
  #
  # デフォルト: プロバイダー設定のリージョン
  #
  # 用途:
  # - マルチリージョン構成で明示的にリージョンを指定
  # - プロバイダーのデフォルトリージョンを上書き
  #
  # 参照:
  # - https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-east-1"

  #-----------------------------------------------------------------------------
  # ブロック: rule (必須, 最小1個)
  #-----------------------------------------------------------------------------
  # サーバーサイド暗号化設定ルールのセット
  # 現在は単一のルールのみサポート

  rule {
    #---------------------------------------------------------------------------
    # rule - オプション属性
    #---------------------------------------------------------------------------

    # blocked_encryption_types - (オプション)
    # オブジェクトアップロード時にブロックする暗号化タイプのリスト
    #
    # 有効な値:
    # - "SSE-C": 顧客提供キーによるサーバーサイド暗号化をブロック
    # - "NONE": すべての暗号化タイプのブロックを解除
    #
    # セキュリティ考慮事項:
    # - SSE-Cはキー管理の複雑さとリスクが高い
    # - 2026年3月以降、新規バケットでは自動的にSSE-Cがブロックされます
    # - ベストプラクティスとして["SSE-C"]を設定することを推奨
    #
    # 参照:
    # - https://docs.aws.amazon.com/AmazonS3/latest/userguide/default-s3-c-encryption-setting-faq.html
    blocked_encryption_types = ["SSE-C"]

    # bucket_key_enabled - (オプション)
    # SSE-KMS用のAmazon S3 Bucket Keysを使用するかどうか
    #
    # 値: true または false
    # デフォルト: false
    #
    # メリット:
    # - S3からKMSへのトランザクション数を大幅に削減（最大99%削減）
    # - SSE-KMSの暗号化コストを削減
    # - 大量のオブジェクトがあるバケットで特に効果的
    #
    # 動作:
    # - S3がバケットレベルのキーを生成
    # - 個別のオブジェクトキーの生成にこのバケットキーを使用
    # - KMSへの呼び出し頻度を削減
    #
    # 注意事項:
    # - sse_algorithm = "aws:kms" または "aws:kms:dsse" の場合のみ有効
    # - CloudTrailログでオブジェクトレベルのKMS操作が表示されなくなる
    #
    # ベストプラクティス: コスト削減のため true を推奨
    #
    # 参照:
    # - https://docs.aws.amazon.com/AmazonS3/latest/dev/bucket-key.html
    bucket_key_enabled = true

    #---------------------------------------------------------------------------
    # ネストブロック: apply_server_side_encryption_by_default (オプション, 最大1個)
    #---------------------------------------------------------------------------
    # デフォルトでサーバーサイド暗号化を適用する設定

    apply_server_side_encryption_by_default {
      # sse_algorithm - (必須)
      # 使用するサーバーサイド暗号化アルゴリズム
      #
      # 有効な値:
      # - "AES256": SSE-S3 (Amazon S3管理キー)
      #   - 最もシンプルで追加コストなし
      #   - 256ビットAES-GCM暗号化
      #   - 2023年1月5日以降のデフォルト
      #
      # - "aws:kms": SSE-KMS (AWS KMS管理キー)
      #   - キーポリシーによる詳細なアクセス制御
      #   - CloudTrailでのキー使用監査
      #   - キーのローテーション管理
      #   - カスタマー管理キーまたはAWS管理キー(aws/s3)を使用
      #
      # - "aws:kms:dsse": DSSE-KMS (デュアルレイヤー暗号化)
      #   - 2層のAES-256暗号化を適用
      #   - 規制要件が厳しい環境向け
      #   - パフォーマンスへの影響あり
      #
      # 選択ガイドライン:
      # - 標準的なセキュリティ要件: "AES256"
      # - キー管理制御が必要: "aws:kms"
      # - クロスアカウントアクセス: "aws:kms" (カスタマー管理キー必須)
      # - 高度なセキュリティ要件: "aws:kms:dsse"
      #
      # コスト考慮事項:
      # - AES256: 追加コストなし
      # - aws:kms: KMS API呼び出しに課金 (bucket_key_enabled推奨)
      # - aws:kms:dsse: KMS API呼び出しに課金 (より高いオーバーヘッド)
      sse_algorithm = "aws:kms"

      # kms_master_key_id - (オプション)
      # SSE-KMS暗号化に使用するAWS KMSマスターキーID
      #
      # 値の形式:
      # - キーID: "1234abcd-12ab-34cd-56ef-1234567890ab"
      # - キーARN: "arn:aws:kms:us-east-1:123456789012:key/1234abcd-12ab-34cd-56ef-1234567890ab"
      # - エイリアス名: "alias/my-key"
      # - エイリアスARN: "arn:aws:kms:us-east-1:123456789012:alias/my-key"
      #
      # 使用条件:
      # - sse_algorithm = "aws:kms" または "aws:kms:dsse" の場合のみ有効
      # - 指定しない場合、デフォルトのAWS管理キー (aws/s3) が使用されます
      #
      # カスタマー管理キーを使用する理由:
      # - キーポリシーによる詳細なアクセス制御
      # - キーのローテーションスケジュールの制御
      # - クロスアカウントアクセスの有効化
      # - キーの無効化/削除の制御
      # - コンプライアンス要件への対応
      #
      # クロスアカウントアクセス:
      # - カスタマー管理キーのキーポリシーで他のアカウントに権限付与
      # - リクエスト元に対して「kms:Encrypt」権限を付与
      # - バケットポリシーと組み合わせて使用
      #
      # セキュリティベストプラクティス:
      # - 本番環境ではカスタマー管理キーを推奨
      # - キーポリシーで最小権限の原則を適用
      # - 自動キーローテーションを有効化
      #
      # 参照例: aws_kms_key.example.arn
      kms_master_key_id = aws_kms_key.example.arn
    }
  }

  #-----------------------------------------------------------------------------
  # 依存関係の考慮事項
  #-----------------------------------------------------------------------------
  # 1. aws_s3_bucket リソースが先に作成される必要があります
  # 2. aws:kms を使用する場合、aws_kms_key が先に作成される必要があります
  # 3. クロスアカウントの場合、KMSキーポリシーが適切に設定されている必要があります
  #
  # 暗黙的な依存関係:
  # - bucket = aws_s3_bucket.example.id
  # - kms_master_key_id = aws_kms_key.example.arn
}

################################################################################
# 補足: バケットポリシーとの統合例
################################################################################

# 暗号化されていないオブジェクトのアップロードを拒否するバケットポリシー
# resource "aws_s3_bucket_policy" "require_encryption" {
#   bucket = aws_s3_bucket.example.id
#
#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Sid    = "DenyUnencryptedObjectUploads"
#         Effect = "Deny"
#         Principal = "*"
#         Action = "s3:PutObject"
#         Resource = "${aws_s3_bucket.example.arn}/*"
#         Condition = {
#           StringNotEquals = {
#             "s3:x-amz-server-side-encryption" = "aws:kms"
#           }
#         }
#       },
#       {
#         Sid    = "DenyInsecureTransport"
#         Effect = "Deny"
#         Principal = "*"
#         Action = "s3:*"
#         Resource = [
#           aws_s3_bucket.example.arn,
#           "${aws_s3_bucket.example.arn}/*"
#         ]
#         Condition = {
#           Bool = {
#             "aws:SecureTransport" = "false"
#           }
#         }
#       }
#     ]
#   })
# }

################################################################################
# 出力値 (Attributes Reference)
################################################################################

# output "encryption_configuration_id" {
#   description = "バケット名、またはexpected_bucket_ownerが指定されている場合は「バケット名,アカウントID」"
#   value       = aws_s3_bucket_server_side_encryption_configuration.example.id
# }

################################################################################
# 使用例: 異なる暗号化アルゴリズム
################################################################################

# 例1: SSE-S3 (Amazon S3管理キー) - シンプルで追加コストなし
# resource "aws_s3_bucket_server_side_encryption_configuration" "sse_s3" {
#   bucket = aws_s3_bucket.example.id
#
#   rule {
#     apply_server_side_encryption_by_default {
#       sse_algorithm = "AES256"
#     }
#   }
# }

# 例2: SSE-KMS (デフォルトのAWS管理キー aws/s3)
# resource "aws_s3_bucket_server_side_encryption_configuration" "sse_kms_default" {
#   bucket = aws_s3_bucket.example.id
#
#   rule {
#     apply_server_side_encryption_by_default {
#       sse_algorithm = "aws:kms"
#       # kms_master_key_id を省略すると aws/s3 が使用されます
#     }
#     bucket_key_enabled = true
#   }
# }

# 例3: DSSE-KMS (デュアルレイヤー暗号化) - 高度なセキュリティ要件
# resource "aws_s3_bucket_server_side_encryption_configuration" "dsse_kms" {
#   bucket = aws_s3_bucket.example.id
#
#   rule {
#     apply_server_side_encryption_by_default {
#       sse_algorithm     = "aws:kms:dsse"
#       kms_master_key_id = aws_kms_key.example.arn
#     }
#     bucket_key_enabled = true
#   }
# }

################################################################################
# インポート
################################################################################

# このリソースは以下の形式でインポート可能:
#
# バケット名のみの場合:
# terraform import aws_s3_bucket_server_side_encryption_configuration.example bucket-name
#
# expected_bucket_ownerを含む場合:
# terraform import aws_s3_bucket_server_side_encryption_configuration.example bucket-name,123456789012

################################################################################
# 関連リソース
################################################################################

# 関連するTerraformリソース:
# - aws_s3_bucket: バケット本体の作成
# - aws_s3_bucket_policy: バケットポリシーの設定
# - aws_s3_bucket_public_access_block: パブリックアクセスブロック設定
# - aws_kms_key: カスタマー管理KMSキーの作成
# - aws_kms_alias: KMSキーエイリアスの作成
#
# AWS Config管理ルール:
# - s3-bucket-server-side-encryption-enabled: 暗号化設定の検証
# - s3-bucket-ssl-requests-only: HTTPS接続の強制検証
#
# IAMポリシーの例 (KMSキーアクセス):
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Effect": "Allow",
#       "Action": [
#         "kms:Decrypt",
#         "kms:GenerateDataKey"
#       ],
#       "Resource": "arn:aws:kms:us-east-1:123456789012:key/1234abcd-12ab-34cd-56ef-1234567890ab"
#     }
#   ]
# }
