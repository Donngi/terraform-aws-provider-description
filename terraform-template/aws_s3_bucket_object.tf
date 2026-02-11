#---------------------------------------------------------------
# AWS S3 Bucket Object (DEPRECATED)
#---------------------------------------------------------------
#
# Amazon S3バケットにオブジェクト（ファイル）をアップロードするリソースです。
#
# ⚠️ 重要な非推奨通知:
# このリソースは非推奨（DEPRECATED）であり、将来のバージョンで削除されます。
# 代わりに aws_s3_object リソースを使用してください。新機能や修正は
# aws_s3_object リソースに追加されます。
#
# aws_s3_bucket_object を aws_s3_object に置き換える場合の注意点:
# - 次回のapply時にTerraformはオブジェクトを再作成します
# - オブジェクトを再作成したくない場合は、aws_s3_object を使用してインポートしてください
#
# 主な機能:
# - ローカルファイルまたはリテラル文字列コンテンツのアップロード
# - Base64エンコードデータのアップロード
# - サーバーサイド暗号化（SSE-S3、SSE-KMS）
# - オブジェクトロック機能のサポート
# - メタデータとタグの設定
# - キャッシュ制御とコンテンツタイプの指定
#
# AWS公式ドキュメント:
#   - Amazon S3 オブジェクト: https://docs.aws.amazon.com/AmazonS3/latest/userguide/UsingObjects.html
#   - オブジェクトのアップロード: https://docs.aws.amazon.com/AmazonS3/latest/userguide/upload-objects.html
#   - オブジェクトロック: https://docs.aws.amazon.com/AmazonS3/latest/userguide/object-lock.html
#   - サーバーサイド暗号化: https://docs.aws.amazon.com/AmazonS3/latest/userguide/serv-side-encryption.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/s3_bucket_object
#
# Provider Version: 6.28.0
# Generated: 2026-02-05
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_s3_bucket_object" "example" {
  #-------------------------------------------------------------
  # 必須パラメータ
  #-------------------------------------------------------------

  # bucket (Required)
  # 設定内容: ファイルを配置するバケットの名前を指定します。
  # 設定可能な値:
  #   - S3バケット名（例: my-bucket-name）
  #   - S3アクセスポイントのARN
  #     （例: arn:aws:s3:us-west-2:123456789012:accesspoint/my-access-point）
  # 注意: バケットは事前に作成されている必要があります
  # 参考: https://docs.aws.amazon.com/AmazonS3/latest/dev/using-access-points.html
  bucket = "my-tf-test-bucket"

  # key (Required)
  # 設定内容: バケット内でのオブジェクトのキー（名前）を指定します。
  # 設定可能な値: 文字列（オブジェクトのパスを含む）
  # 注意:
  #   - Terraformは先頭のスラッシュ（/）を全て無視します
  #   - キー内の複数のスラッシュ（//）は単一のスラッシュ（/）として扱われます
  #   - 例: /index.html と index.html は同じオブジェクト
  #   - 例: first//second///third// と first/second/third/ は同じオブジェクト
  # 参考: https://docs.aws.amazon.com/AmazonS3/latest/userguide/object-keys.html
  key = "new_object_key"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # コンテンツソース（排他的設定）
  #-------------------------------------------------------------
  # source、content、content_base64 は排他的です。
  # いずれか1つのみ指定可能です。
  # 全て省略した場合、オブジェクトは空になります。

  # source (Optional, conflicts with content and content_base64)
  # 設定内容: アップロードするファイルへのパスを指定します。
  # 設定可能な値: ローカルファイルシステム上の有効なファイルパス
  # 注意:
  #   - ファイルの内容は生のバイトとして読み込まれ、アップロードされます
  #   - content_encodingを指定する場合、事前にファイルをエンコード/圧縮する必要があります
  # 例: source = "path/to/file"
  source = "path/to/file"

  # content (Optional, conflicts with source and content_base64)
  # 設定内容: オブジェクトのコンテンツとして使用するリテラル文字列を指定します。
  # 設定可能な値: 文字列（UTF-8エンコードされてアップロードされます）
  # 用途: 小さなテキストコンテンツに適しています
  # 注意: content_encodingを指定する場合、事前に文字列をエンコードする必要があります
  # 例: content = "Hello, World!"
  # content = null

  # content_base64 (Optional, conflicts with source and content)
  # 設定内容: Base64エンコードされたデータを指定します。
  # 設定可能な値: Base64エンコードされた文字列
  # 用途:
  #   - 非UTF8バイナリデータを安全にアップロードする場合
  #   - gzipbase64関数の結果など、小さなコンテンツに推奨
  # 注意: デコードされて生のバイトとしてアップロードされます
  # 例: content_base64 = gzipbase64(file("path/to/file"))
  # content_base64 = null

  #-------------------------------------------------------------
  # 変更検出設定
  #-------------------------------------------------------------

  # etag (Optional)
  # 設定内容: 値が変更されたときに更新をトリガーします。
  # 設定可能な値:
  #   - filemd5("path/to/file") (Terraform 0.11.12以降)
  #   - md5(file("path/to/file")) (Terraform 0.11.11以前)
  # 注意:
  #   - KMS暗号化（kms_key_id または server_side_encryption = "aws:kms"）とは互換性がありません
  #   - KMS暗号化を使用する場合は source_hash を使用してください
  # 例: etag = filemd5("path/to/file")
  etag = filemd5("path/to/file")

  # source_hash (Optional)
  # 設定内容: etagと同様に更新をトリガーしますが、etagの暗号化制限に対処します。
  # 設定可能な値: filemd5("path/to/source") (Terraform 0.11.12以降)
  # 注意:
  #   - この値はステートにのみ保存され、AWSには保存されません
  #   - KMS暗号化を使用する場合はこちらを使用してください
  # 例: source_hash = filemd5("path/to/source")
  # source_hash = null

  #-------------------------------------------------------------
  # コンテンツメタデータ設定
  #-------------------------------------------------------------

  # content_type (Optional)
  # 設定内容: オブジェクトデータのフォーマットを記述する標準MIMEタイプを指定します。
  # 設定可能な値: 有効なMIMEタイプ文字列
  # 省略時: application/octet-stream が使用されます
  # 例:
  #   - text/html
  #   - application/json
  #   - image/png
  # 参考: https://developer.mozilla.org/en-US/docs/Web/HTTP/Basics_of_HTTP/MIME_types
  content_type = null

  # cache_control (Optional)
  # 設定内容: リクエスト/レスポンスチェーン沿いのキャッシュ動作を指定します。
  # 設定可能な値: Cache-Controlヘッダーの有効な値
  # 例:
  #   - max-age=3600
  #   - no-cache
  #   - public, max-age=86400
  # 参考: http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.9
  cache_control = null

  # content_disposition (Optional)
  # 設定内容: オブジェクトの表示情報を指定します。
  # 設定可能な値: Content-Dispositionヘッダーの有効な値
  # 例:
  #   - inline
  #   - attachment; filename="filename.jpg"
  # 参考: http://www.w3.org/Protocols/rfc2616/rfc2616-sec19.html#sec19.5.1
  content_disposition = null

  # content_encoding (Optional)
  # 設定内容: オブジェクトに適用されたコンテンツエンコーディングを指定します。
  # 設定可能な値: Content-Encodingヘッダーの有効な値
  # 注意:
  #   - この値を指定する場合、事前にコンテンツをエンコード/圧縮する必要があります
  #   - source、content、content_base64は全て既にエンコード/圧縮済みのバイトを期待します
  # 例:
  #   - gzip
  #   - compress
  # 参考: http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.11
  content_encoding = null

  # content_language (Optional)
  # 設定内容: コンテンツの言語を指定します。
  # 設定可能な値: 言語コード（例: en-US, ja-JP, en-GB）
  # 参考: https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Language
  content_language = null

  # website_redirect (Optional)
  # 設定内容: ウェブサイトリダイレクトのターゲットURLを指定します。
  # 設定可能な値: 有効なURL文字列
  # 用途: S3ウェブサイトホスティングでリダイレクトを設定する場合
  # 参考: http://docs.aws.amazon.com/AmazonS3/latest/dev/how-to-page-redirect.html
  website_redirect = null

  #-------------------------------------------------------------
  # メタデータ設定
  #-------------------------------------------------------------

  # metadata (Optional)
  # 設定内容: オブジェクトにプロビジョニングするメタデータのキー/値マップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 注意:
  #   - 自動的に x-amz-meta- プレフィックスが追加されます
  #   - 現在、AWS Go APIでは小文字のラベルのみサポートされています
  # 例:
  #   metadata = {
  #     author      = "John Doe"
  #     department  = "Engineering"
  #     description = "Sample file"
  #   }
  metadata = null

  #-------------------------------------------------------------
  # ACL設定
  #-------------------------------------------------------------

  # acl (Optional)
  # 設定内容: 適用する定義済みACL（Canned ACL）を指定します。
  # 設定可能な値:
  #   - private (デフォルト): オーナーのみがフルコントロール権限を持つ
  #   - public-read: 全ユーザーが読み取り可能
  #   - public-read-write: 全ユーザーが読み取り・書き込み可能
  #   - aws-exec-read: EC2が読み取り可能
  #   - authenticated-read: 認証されたAWSユーザーが読み取り可能
  #   - bucket-owner-read: バケット所有者が読み取り可能
  #   - bucket-owner-full-control: バケット所有者がフルコントロール権限を持つ
  # 省略時: private
  # 参考: https://docs.aws.amazon.com/AmazonS3/latest/dev/acl-overview.html#canned-acl
  acl = "private"

  #-------------------------------------------------------------
  # ストレージクラス設定
  #-------------------------------------------------------------

  # storage_class (Optional)
  # 設定内容: オブジェクトのストレージクラスを指定します。
  # 設定可能な値:
  #   - STANDARD (デフォルト): 標準ストレージ
  #   - REDUCED_REDUNDANCY: 低冗長化ストレージ
  #   - STANDARD_IA: 標準 - 低頻度アクセス
  #   - ONEZONE_IA: 1ゾーン - 低頻度アクセス
  #   - INTELLIGENT_TIERING: インテリジェント階層化
  #   - GLACIER: Glacier
  #   - GLACIER_IR: Glacier Instant Retrieval
  #   - DEEP_ARCHIVE: Glacier Deep Archive
  # 省略時: STANDARD
  # 参考: https://docs.aws.amazon.com/AmazonS3/latest/API/API_PutObject.html#AmazonS3-PutObject-request-header-StorageClass
  storage_class = "STANDARD"

  #-------------------------------------------------------------
  # 暗号化設定
  #-------------------------------------------------------------

  # server_side_encryption (Optional)
  # 設定内容: S3でのオブジェクトのサーバーサイド暗号化方式を指定します。
  # 設定可能な値:
  #   - AES256: AWS管理キーによるAES256暗号化（SSE-S3）
  #   - aws:kms: AWS KMSキーによる暗号化（SSE-KMS）
  # 注意: S3バケットでサーバーサイド暗号化が有効な場合、その値が自動的に使用されます
  # 参考: https://docs.aws.amazon.com/AmazonS3/latest/userguide/serv-side-encryption.html
  server_side_encryption = null

  # kms_key_id (Optional)
  # 設定内容: オブジェクト暗号化に使用するKMSキーのARNを指定します。
  # 設定可能な値: KMSキーのARN
  # 省略時: S3バケットでサーバーサイド暗号化が有効な場合、その値が自動的に使用されます
  # 注意:
  #   - aws_kms_key リソースを参照する場合は arn 属性を使用
  #   - aws_kms_alias データソース/リソースを参照する場合は target_key_arn 属性を使用
  #   - Terraformは設定値が提供されている場合のみドリフト検出を実行します
  # 例: kms_key_id = aws_kms_key.examplekms.arn
  kms_key_id = null

  # bucket_key_enabled (Optional)
  # 設定内容: SSE-KMSでAmazon S3 Bucket Keysを使用するかを指定します。
  # 設定可能な値:
  #   - true: Bucket Keysを使用（KMSリクエストコストを削減）
  #   - false: Bucket Keysを使用しない
  # 関連機能: S3 Bucket Keys
  #   KMS暗号化のリクエスト数を削減し、コストを最大99%削減できます。
  #   - https://docs.aws.amazon.com/AmazonS3/latest/dev/bucket-key.html
  bucket_key_enabled = null

  #-------------------------------------------------------------
  # オブジェクトロック設定
  #-------------------------------------------------------------

  # object_lock_legal_hold_status (Optional)
  # 設定内容: 指定したオブジェクトに適用するリーガルホールドステータスを指定します。
  # 設定可能な値:
  #   - ON: リーガルホールドを有効化（削除不可）
  #   - OFF: リーガルホールドを無効化
  # 注意: バケットでS3 Object Lockが有効になっている必要があります
  # 参考: https://docs.aws.amazon.com/AmazonS3/latest/dev/object-lock-overview.html#object-lock-legal-holds
  object_lock_legal_hold_status = null

  # object_lock_mode (Optional)
  # 設定内容: このオブジェクトに適用するオブジェクトロック保持モードを指定します。
  # 設定可能な値:
  #   - GOVERNANCE: ガバナンスモード（特定の権限で上書き可能）
  #   - COMPLIANCE: コンプライアンスモード（誰も上書き不可）
  # 注意: object_lock_retain_until_date と併せて使用します
  # 参考: https://docs.aws.amazon.com/AmazonS3/latest/dev/object-lock-overview.html#object-lock-retention-modes
  object_lock_mode = null

  # object_lock_retain_until_date (Optional)
  # 設定内容: このオブジェクトのオブジェクトロックが期限切れになる日時を指定します。
  # 設定可能な値: RFC3339形式の日時文字列
  # 例: "2021-12-31T23:59:60Z"
  # 注意: object_lock_mode と併せて使用します
  # 参考: https://tools.ietf.org/html/rfc3339#section-5.8
  object_lock_retain_until_date = null

  #-------------------------------------------------------------
  # 削除設定
  #-------------------------------------------------------------

  # force_destroy (Optional)
  # 設定内容: 任意のオブジェクトバージョンのリーガルホールドを削除することで
  #           オブジェクトの削除を許可するかを指定します。
  # 設定可能な値:
  #   - true: リーガルホールドがあっても削除を許可
  #   - false (デフォルト): リーガルホールドがある場合は削除に失敗
  # 注意: バケットでS3 Object Lockが有効な場合のみ、この値をtrueに設定してください
  force_destroy = false

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: オブジェクトに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  #   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  tags = {
    Name        = "MyObject"
    Environment = "Dev"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: オブジェクトのAmazon Resource Name (ARN)
#
# - etag: オブジェクトに対して生成されたETag（オブジェクトコンテンツのMD5サム）
#        注意: AWS管理キーで暗号化されたプレーンテキストオブジェクトまたは
#        オブジェクトの場合、ハッシュはオブジェクトデータのMD5ダイジェストです。
#        KMSキーで暗号化されたオブジェクト、またはマルチパートアップロードまたは
#        パートコピー操作によって作成されたオブジェクトの場合、暗号化方法に
#        関係なく、ハッシュはMD5ダイジェストではありません。
#        参考: https://docs.aws.amazon.com/AmazonS3/latest/API/RESTCommonResponseHeaders.html
#
# - version_id: オブジェクトの一意のバージョンID値（バケットのバージョニングが有効な場合）
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられた全てのタグのマップ
#---------------------------------------------------------------

#---------------------------------------------------------------
# 使用例
#---------------------------------------------------------------

# 例1: ファイルをバケットにアップロード
# resource "aws_s3_bucket_object" "object" {
#   bucket = "your_bucket_name"
#   key    = "new_object_key"
#   source = "path/to/file"
#   etag   = filemd5("path/to/file")
# }

# 例2: KMSキーで暗号化
# resource "aws_kms_key" "examplekms" {
#   description             = "KMS key 1"
#   deletion_window_in_days = 7
# }
#
# resource "aws_s3_bucket" "examplebucket" {
#   bucket = "examplebuckettftest"
# }
#
# resource "aws_s3_bucket_acl" "example" {
#   bucket = aws_s3_bucket.examplebucket.id
#   acl    = "private"
# }
#
# resource "aws_s3_bucket_object" "example" {
#   key        = "someobject"
#   bucket     = aws_s3_bucket.examplebucket.id
#   source     = "index.html"
#   kms_key_id = aws_kms_key.examplekms.arn
# }

# 例3: S3デフォルトマスターキーでのサーバーサイド暗号化
# resource "aws_s3_bucket_object" "example" {
#   key                    = "someobject"
#   bucket                 = aws_s3_bucket.examplebucket.id
#   source                 = "index.html"
#   server_side_encryption = "aws:kms"
# }

# 例4: AWS管理キーでのサーバーサイド暗号化
# resource "aws_s3_bucket_object" "example" {
#   key                    = "someobject"
#   bucket                 = aws_s3_bucket.examplebucket.id
#   source                 = "index.html"
#   server_side_encryption = "AES256"
# }

# 例5: S3 Object Lock
# resource "aws_s3_bucket" "examplebucket" {
#   bucket              = "examplebuckettftest"
#   object_lock_enabled = true
# }
#
# resource "aws_s3_bucket_versioning" "example" {
#   bucket = aws_s3_bucket.examplebucket.id
#   versioning_configuration {
#     status = "Enabled"
#   }
# }
#
# resource "aws_s3_bucket_object" "example" {
#   depends_on = [aws_s3_bucket_versioning.example]
#
#   key    = "someobject"
#   bucket = aws_s3_bucket.examplebucket.id
#   source = "important.txt"
#
#   object_lock_legal_hold_status = "ON"
#   object_lock_mode              = "GOVERNANCE"
#   object_lock_retain_until_date = "2021-12-31T23:59:60Z"
#
#   force_destroy = true
# }
#---------------------------------------------------------------
