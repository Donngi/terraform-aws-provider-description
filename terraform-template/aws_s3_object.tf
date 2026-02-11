# ================================================================
# Terraform AWS Provider Resource: aws_s3_object
# ================================================================
# Provider Version: 6.28.0
# Resource Type: aws_s3_object
# Description: Provides an S3 object resource for uploading files/content to S3 buckets
#
# このリソースは、Amazon S3バケットにオブジェクト（ファイルやコンテンツ）をアップロード
# するためのリソースです。ファイルのアップロード、暗号化、メタデータの設定、
# Object Lock、バージョニングなどの機能をサポートします。
#
# 主な用途:
# - ローカルファイルのS3へのアップロード
# - インラインコンテンツの作成
# - 暗号化されたオブジェクトの管理
# - Object Lockを使用したコンプライアンス対応
# - 静的ウェブサイトのコンテンツ配置
#
# 注意事項:
# - sourceとcontent、content_base64は同時に使用できません
# - etagはKMS暗号化やMultipart Uploadとは互換性がありません
# - Object Lockを使用する場合、バケットでバージョニングを有効化する必要があります
# - キーの先頭のスラッシュ(/)は無視され、複数のスラッシュは単一のスラッシュとして扱われます
# ================================================================

resource "aws_s3_object" "example" {
  # ================================================================
  # 必須パラメータ（Required）
  # ================================================================

  # bucket - (Required) バケット名またはS3アクセスポイントARN
  # Type: string
  # オブジェクトをアップロードするバケット名を指定します。
  # S3アクセスポイントのARNも指定可能です。
  # Example: "my-bucket-name" または "arn:aws:s3:us-west-2:123456789012:accesspoint/my-access-point"
  bucket = "your-bucket-name"

  # key - (Required) バケット内でのオブジェクト名（キー）
  # Type: string
  # バケット内でオブジェクトを識別するためのキー（パス）を指定します。
  # 先頭のスラッシュは無視され、複数の連続スラッシュは単一のスラッシュとして扱われます。
  # Example: "path/to/file.txt", "images/photo.jpg", "index.html"
  key = "new_object_key"

  # ================================================================
  # オプションパラメータ（Optional）- コンテンツソース
  # ================================================================

  # source - (Optional) アップロードするローカルファイルのパス
  # Type: string
  # Conflicts with: content, content_base64
  # ローカルファイルシステムからファイルを読み込んでアップロードします。
  # ファイルは生のバイトとしてアップロードされます。
  # Example: "path/to/local/file.txt", "/tmp/upload.zip"
  source = "path/to/file"

  # content - (Optional) UTF-8エンコードされたテキストコンテンツ
  # Type: string
  # Conflicts with: source, content_base64
  # リテラル文字列値をオブジェクトのコンテンツとして使用します。
  # UTF-8エンコードされたテキストとしてアップロードされます。
  # 小さなテキストファイルやJSON、HTMLなどに適しています。
  # Example: "Hello, World!", file("template.json")
  # content = "inline content here"

  # content_base64 - (Optional) Base64エンコードされたバイナリデータ
  # Type: string
  # Conflicts with: source, content
  # Base64エンコードされたデータをデコードしてアップロードします。
  # バイナリデータを安全にアップロードできますが、小さなコンテンツにのみ推奨されます。
  # 大きなオブジェクトには source を使用してください。
  # Example: base64encode("binary data"), gzipbase64("compressed content")
  # content_base64 = base64encode(file("binary-file"))

  # ================================================================
  # オプションパラメータ（Optional）- 整合性チェック
  # ================================================================

  # etag - (Optional) ファイル変更時の更新トリガー
  # Type: string
  # ファイルの内容が変更された際にリソースの更新をトリガーします。
  # filemd5()関数を使用してMD5ハッシュを計算します。
  # KMS暗号化、16MB以上のファイル、Multipart Uploadとは互換性がありません。
  # これらの場合は source_hash を使用してください。
  # Example: filemd5("path/to/file")
  etag = filemd5("path/to/file")

  # source_hash - (Optional) etag の暗号化対応代替
  # Type: string
  # etagと同様に更新をトリガーしますが、KMS暗号化やMultipart Uploadにも対応します。
  # 値はTerraformのステートにのみ保存され、AWSには送信されません。
  # Example: filemd5("path/to/source")
  # source_hash = filemd5("path/to/source")

  # checksum_algorithm - (Optional) チェックサムアルゴリズム
  # Type: string
  # Valid values: CRC32, CRC32C, CRC64NVME, SHA1, SHA256
  # オブジェクトのチェックサム計算に使用するアルゴリズムを指定します。
  # KMS暗号化されたオブジェクトの場合、kms:Decrypt権限が必要です。
  # Example: "SHA256"
  # checksum_algorithm = "SHA256"

  # ================================================================
  # オプションパラメータ（Optional）- アクセス制御
  # ================================================================

  # acl - (Optional) Canned ACL
  # Type: string
  # Valid values: private, public-read, public-read-write, aws-exec-read,
  #               authenticated-read, bucket-owner-read, bucket-owner-full-control
  # 定義済みACLを適用します。バケットレベルのACL設定が優先される場合があります。
  # 新しいアプリケーションでは、バケットポリシーやIAMポリシーの使用を推奨します。
  # Example: "private", "public-read"
  # acl = "private"

  # ================================================================
  # オプションパラメータ（Optional）- 暗号化
  # ================================================================

  # server_side_encryption - (Optional) サーバーサイド暗号化方式
  # Type: string
  # Valid values: AES256, aws:kms, aws:kms:dsse, aws:fsx
  # S3でのオブジェクト暗号化方式を指定します。
  # - AES256: AWS管理のS3暗号化キー（SSE-S3）
  # - aws:kms: KMSカスタマーマネージドキー（SSE-KMS）
  # - aws:kms:dsse: KMS Dual-layer Server-Side Encryption
  # - aws:fsx: FSx for Windows File Server用
  # Example: "AES256", "aws:kms"
  # server_side_encryption = "AES256"

  # kms_key_id - (Optional) KMSキーARN
  # Type: string
  # オブジェクト暗号化に使用するKMSキーのARNを指定します。
  # バケットでサーバーサイド暗号化が有効な場合、その値が自動的に使用されます。
  # aws_kms_keyリソースの場合は arn 属性、aws_kms_aliasの場合は target_key_arn 属性を使用します。
  # Terraformはドリフト検出のみ実行します（値が設定されている場合のみ）。
  # Example: "arn:aws:kms:us-west-2:123456789012:key/12345678-1234-1234-1234-123456789012"
  # kms_key_id = aws_kms_key.example.arn

  # bucket_key_enabled - (Optional) S3 Bucket Keysの使用
  # Type: bool
  # SSE-KMSでAmazon S3 Bucket Keysを使用するかどうかを指定します。
  # Bucket Keysを使用すると、KMS APIコールのコストを削減できます。
  # Example: true, false
  # bucket_key_enabled = true

  # ================================================================
  # オプションパラメータ（Optional）- HTTPヘッダー/メタデータ
  # ================================================================

  # content_type - (Optional) MIMEタイプ
  # Type: string
  # オブジェクトデータの形式を示す標準MIMEタイプを指定します。
  # 指定しない場合、S3はファイル拡張子から自動的に推測します。
  # Example: "text/html", "application/json", "image/jpeg", "application/octet-stream"
  # content_type = "text/html"

  # content_disposition - (Optional) Content-Disposition
  # Type: string
  # オブジェクトの表示方法に関する情報を指定します。
  # ブラウザでのダウンロード時のファイル名などを制御できます。
  # Example: "attachment; filename=\"download.txt\"", "inline"
  # content_disposition = "attachment; filename=\"download.txt\""

  # content_encoding - (Optional) Content-Encoding
  # Type: string
  # オブジェクトに適用されたコンテンツエンコーディングを指定します。
  # Content-Typeヘッダーで参照されるメディアタイプを取得するために必要なデコード機構を示します。
  # 注意: content_encodingを指定する場合、ボディを適切にエンコードする責任があります。
  # Example: "gzip", "compress", "deflate", "identity"
  # content_encoding = "gzip"

  # content_language - (Optional) コンテンツの言語
  # Type: string
  # コンテンツの対象言語を指定します。
  # Example: "en-US", "ja-JP", "en-GB"
  # content_language = "en-US"

  # cache_control - (Optional) Cache-Control
  # Type: string
  # リクエスト/レスポンスチェーンに沿ったキャッシング動作を指定します。
  # ブラウザやCDNのキャッシュ動作を制御します。
  # Example: "max-age=3600", "no-cache", "public, max-age=31536000"
  # cache_control = "max-age=3600"

  # website_redirect - (Optional) ウェブサイトリダイレクト先URL
  # Type: string
  # このオブジェクトへのリクエストを別のURLにリダイレクトします。
  # 静的ウェブサイトホスティングで使用されます。
  # Example: "https://example.com/redirect", "/another-page.html"
  # website_redirect = "https://example.com/"

  # metadata - (Optional) カスタムメタデータ
  # Type: map(string)
  # オブジェクトに関連付けるカスタムメタデータのキー/値ペアを指定します。
  # すべてのキーには自動的に "x-amz-meta-" プレフィックスが付加されます。
  # 注意: 現在AWS Go APIは小文字のラベルのみサポートしています。
  # Example: { "key1" = "value1", "key2" = "value2" }
  # metadata = {
  #   "environment" = "production"
  #   "version"     = "1.0.0"
  # }

  # ================================================================
  # オプションパラメータ（Optional）- Object Lock
  # ================================================================

  # object_lock_legal_hold_status - (Optional) 法的保持ステータス
  # Type: string
  # Valid values: ON, OFF
  # オブジェクトに適用する法的保持ステータスを指定します。
  # 法的保持が有効な場合、オブジェクトは削除や上書きから保護されます。
  # バケットでObject Lockが有効である必要があります。
  # Example: "ON", "OFF"
  # object_lock_legal_hold_status = "ON"

  # object_lock_mode - (Optional) Object Lock保持モード
  # Type: string
  # Valid values: GOVERNANCE, COMPLIANCE
  # オブジェクトに適用する保持モードを指定します。
  # - GOVERNANCE: 特別な権限を持つユーザーは保持設定を変更可能
  # - COMPLIANCE: 誰も保持期間中はオブジェクトを削除・変更できない
  # バケットでObject Lockが有効である必要があります。
  # Example: "GOVERNANCE", "COMPLIANCE"
  # object_lock_mode = "GOVERNANCE"

  # object_lock_retain_until_date - (Optional) Object Lock保持期限日
  # Type: string (RFC3339 format)
  # オブジェクトのObject Lock保持期限を指定します。
  # この日時までオブジェクトは保護されます。
  # RFC3339形式（例: 2021-12-31T23:59:60Z）で指定します。
  # Example: "2025-12-31T23:59:60Z"
  # object_lock_retain_until_date = "2025-12-31T23:59:60Z"

  # force_destroy - (Optional) 強制削除の許可
  # Type: bool
  # Default: false
  # オブジェクトに法的保持があっても削除を許可するかどうかを指定します。
  # Object Lockが有効なバケットでのみ true に設定してください。
  # Example: true, false
  # force_destroy = false

  # ================================================================
  # オプションパラメータ（Optional）- ストレージとタグ
  # ================================================================

  # storage_class - (Optional) ストレージクラス
  # Type: string
  # Default: STANDARD
  # Valid values: STANDARD, REDUCED_REDUNDANCY, STANDARD_IA, ONEZONE_IA,
  #               INTELLIGENT_TIERING, GLACIER, DEEP_ARCHIVE, GLACIER_IR
  # オブジェクトのストレージクラスを指定します。
  # アクセス頻度とコスト要件に基づいて適切なクラスを選択します。
  # Example: "STANDARD", "INTELLIGENT_TIERING", "GLACIER"
  # storage_class = "STANDARD"

  # tags - (Optional) タグ
  # Type: map(string)
  # オブジェクトに割り当てるタグを指定します。
  # プロバイダーのdefault_tags設定ブロックと統合されます。
  # Example: { "Environment" = "Production", "Project" = "MyApp" }
  # tags = {
  #   Name        = "MyObject"
  #   Environment = "Production"
  # }

  # ================================================================
  # オプションパラメータ（Optional）- リージョン設定
  # ================================================================

  # region - (Optional) リージョン
  # Type: string
  # このリソースが管理されるリージョンを指定します。
  # 指定しない場合、プロバイダー設定のリージョンが使用されます。
  # Example: "us-west-2", "ap-northeast-1"
  # region = "us-west-2"

  # ================================================================
  # オプションパラメータ（Optional）- プロバイダー設定オーバーライド
  # ================================================================

  # override_provider - (Optional) プロバイダーレベル設定のオーバーライド
  # プロバイダーレベルのdefault_tags設定をオーバーライドします。
  # 特定のオブジェクトでプロバイダーのデフォルトタグを無効化したい場合に使用します。
  # override_provider {
  #   default_tags {
  #     tags = {}
  #   }
  # }
}

# ================================================================
# 出力属性（Computed Attributes）
# ================================================================
# このリソースは以下の属性を出力します:
#
# - arn: オブジェクトのARN
# - checksum_crc32: Base64エンコードされた32ビットCRC32チェックサム
# - checksum_crc32c: Base64エンコードされた32ビットCRC32Cチェックサム
# - checksum_crc64nvme: Base64エンコードされた64ビットCRC64NVMEチェックサム
# - checksum_sha1: Base64エンコードされた160ビットSHA-1ダイジェスト
# - checksum_sha256: Base64エンコードされた256ビットSHA-256ダイジェスト
# - etag: オブジェクトのETag（MD5サムまたはその他のハッシュ）
# - tags_all: リソースに割り当てられた全タグ（プロバイダーのdefault_tags含む）
# - version_id: オブジェクトのバージョンID（バケットでバージョニングが有効な場合）
#
# 出力例:
# output "object_arn" {
#   description = "S3オブジェクトのARN"
#   value       = aws_s3_object.example.arn
# }
#
# output "object_etag" {
#   description = "S3オブジェクトのETag"
#   value       = aws_s3_object.example.etag
# }
#
# output "object_version_id" {
#   description = "S3オブジェクトのバージョンID"
#   value       = aws_s3_object.example.version_id
# }

# ================================================================
# 使用例
# ================================================================

# 例1: ローカルファイルのアップロード
# resource "aws_s3_object" "upload_file" {
#   bucket = "my-bucket"
#   key    = "uploads/document.pdf"
#   source = "local-files/document.pdf"
#   etag   = filemd5("local-files/document.pdf")
#
#   content_type = "application/pdf"
#
#   tags = {
#     Type = "Document"
#   }
# }

# 例2: KMS暗号化
# resource "aws_s3_object" "encrypted_file" {
#   bucket = aws_s3_bucket.example.id
#   key    = "sensitive/data.txt"
#   source = "data.txt"
#
#   server_side_encryption = "aws:kms"
#   kms_key_id            = aws_kms_key.example.arn
#   bucket_key_enabled    = true
# }

# 例3: インラインコンテンツ
# resource "aws_s3_object" "config_file" {
#   bucket       = "my-bucket"
#   key          = "config/settings.json"
#   content      = jsonencode({
#     environment = "production"
#     version     = "1.0.0"
#   })
#   content_type = "application/json"
# }

# 例4: Object Lock with GOVERNANCE モード
# resource "aws_s3_object" "protected_file" {
#   depends_on = [aws_s3_bucket_versioning.example]
#
#   bucket = aws_s3_bucket.example.id
#   key    = "protected/important.txt"
#   source = "important.txt"
#
#   object_lock_legal_hold_status = "ON"
#   object_lock_mode              = "GOVERNANCE"
#   object_lock_retain_until_date = "2025-12-31T23:59:60Z"
#
#   force_destroy = true
# }

# 例5: 静的ウェブサイトホスティング
# resource "aws_s3_object" "index_html" {
#   bucket       = aws_s3_bucket.website.id
#   key          = "index.html"
#   source       = "website/index.html"
#   content_type = "text/html"
#   etag         = filemd5("website/index.html")
#
#   cache_control = "max-age=3600"
# }

# ================================================================
# 参考リンク
# ================================================================
# - Terraform Registry: https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/s3_object
# - AWS S3 PutObject API: https://docs.aws.amazon.com/AmazonS3/latest/API/API_PutObject.html
# - S3 Object Lock: https://docs.aws.amazon.com/AmazonS3/latest/dev/object-lock.html
# - S3 Encryption: https://docs.aws.amazon.com/AmazonS3/latest/dev/UsingEncryption.html
# - S3 Access Points: https://docs.aws.amazon.com/AmazonS3/latest/dev/using-access-points.html
# ================================================================
