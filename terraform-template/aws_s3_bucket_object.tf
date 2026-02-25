#---------------------------------------------------------------
# Amazon S3 バケットオブジェクト (非推奨)
#---------------------------------------------------------------
#
# S3バケットにオブジェクト（ファイル）をアップロード・管理するリソースです。
# このリソースは非推奨となっており、代わりに aws_s3_object リソースを使用することを推奨します。
# テキストコンテンツはインラインで指定でき、ファイルはローカルパスで参照できます。
#
# 非推奨の理由:
# - プロバイダーの更新に伴い aws_s3_object リソースが後継として提供されています。
# - aws_s3_object は本リソースと同等の機能を提供します。
#
# AWS公式ドキュメント:
#   - S3オブジェクト概要: https://docs.aws.amazon.com/AmazonS3/latest/userguide/UsingObjects.html
#   - オブジェクトのアップロード: https://docs.aws.amazon.com/AmazonS3/latest/userguide/upload-objects.html
#   - オブジェクトの暗号化: https://docs.aws.amazon.com/AmazonS3/latest/userguide/UsingEncryption.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_object
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_s3_bucket_object" "example" {
  #-------------------------------------------------------------
  # 基本設定 (非推奨リソース: 代わりに aws_s3_object を使用してください)
  #-------------------------------------------------------------

  # bucket (Required, Deprecated, Forces new resource)
  # 設定内容: オブジェクトをアップロードするS3バケットの名前またはARNを指定します。
  # 設定可能な値: 既存のS3バケット名またはARN文字列
  # 注意: このリソース全体が非推奨です。aws_s3_object リソースを使用してください。
  bucket = "my-s3-bucket"

  # key (Required, Deprecated, Forces new resource)
  # 設定内容: バケット内のオブジェクトのキー（パス）を指定します。
  # 設定可能な値: スラッシュ区切りのパス文字列（例: "path/to/object.txt"）
  # 注意: このリソース全体が非推奨です。aws_s3_object リソースを使用してください。
  key = "path/to/object.txt"

  #-------------------------------------------------------------
  # コンテンツ設定 (source / content / content_base64 のいずれか一つを指定)
  #-------------------------------------------------------------

  # source (Optional)
  # 設定内容: アップロードするローカルファイルのパスを指定します。
  # 設定可能な値: ローカルファイルシステムのパス文字列
  # 注意: content、content_base64 と排他的。いずれか一方のみ指定可能
  source = null

  # content (Optional)
  # 設定内容: オブジェクトのコンテンツをリテラル文字列として指定します。
  # 設定可能な値: UTF-8文字列
  # 注意: source、content_base64 と排他的。いずれか一方のみ指定可能
  content = null

  # content_base64 (Optional)
  # 設定内容: バイナリデータをBase64エンコードした文字列としてオブジェクトのコンテンツを指定します。
  # 設定可能な値: Base64エンコードされたバイナリデータ文字列
  # 注意: source、content と排他的。いずれか一方のみ指定可能
  content_base64 = null

  # source_hash (Optional)
  # 設定内容: sourceファイルのコンテンツのハッシュ値を指定します。
  #   Terraformがファイルの変更を検出するために使用します。
  # 設定可能な値: MD5またはSHA256等のハッシュ文字列（例: filemd5("path/to/file") の結果）
  # 省略時: etagのみで変更を検出
  source_hash = null

  #-------------------------------------------------------------
  # コンテンツメタデータ設定
  #-------------------------------------------------------------

  # content_type (Optional)
  # 設定内容: オブジェクトのMIMEタイプを指定します。
  # 設定可能な値: 有効なMIMEタイプ文字列（例: "text/plain", "application/json", "image/png"）
  # 省略時: "binary/octet-stream"（AWSのデフォルト）
  content_type = null

  # cache_control (Optional)
  # 設定内容: オブジェクトのキャッシュ動作を指定するCache-Controlヘッダーを設定します。
  # 設定可能な値: RFC 7234準拠のCache-Control指示文字列（例: "max-age=3600", "no-cache"）
  # 省略時: Cache-Controlヘッダーなし
  cache_control = null

  # content_disposition (Optional)
  # 設定内容: オブジェクトのプレゼンテーション情報を指定するContent-Dispositionヘッダーを設定します。
  # 設定可能な値: "inline"、"attachment"、"attachment; filename=\"filename.jpg\"" 等
  # 省略時: Content-Dispositionヘッダーなし
  content_disposition = null

  # content_encoding (Optional)
  # 設定内容: オブジェクトに適用されているコンテンツエンコーディングを指定します。
  # 設定可能な値: "gzip"、"deflate"、"identity" 等のエンコーディング文字列
  # 省略時: Content-Encodingヘッダーなし
  content_encoding = null

  # content_language (Optional)
  # 設定内容: オブジェクトのコンテンツが使用している言語を指定します。
  # 設定可能な値: BCP 47言語タグ（例: "en", "ja", "en-US"）
  # 省略時: Content-Languageヘッダーなし
  content_language = null

  # website_redirect (Optional)
  # 設定内容: このオブジェクトへのリクエストを別のオブジェクトまたはURLにリダイレクトするパスを指定します。
  # 設定可能な値: バケット内の別オブジェクトへのパス（例: "/other/key"）または外部URL
  # 省略時: リダイレクトなし
  website_redirect = null

  #-------------------------------------------------------------
  # メタデータ設定
  #-------------------------------------------------------------

  # metadata (Optional)
  # 設定内容: オブジェクトに付与するユーザー定義メタデータのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ（キーは自動的に小文字化されます）
  # 省略時: メタデータなし
  metadata = {}

  #-------------------------------------------------------------
  # ストレージクラス設定
  #-------------------------------------------------------------

  # storage_class (Optional)
  # 設定内容: オブジェクトのストレージクラスを指定します。
  # 設定可能な値:
  #   - "STANDARD": 標準ストレージ（デフォルト）。頻繁にアクセスされるデータ向け
  #   - "REDUCED_REDUNDANCY": 低冗長化ストレージ。重要でない再現可能なデータ向け
  #   - "STANDARD_IA": 標準低頻度アクセスストレージ。アクセス頻度が低いが迅速なアクセスが必要なデータ向け
  #   - "ONEZONE_IA": 1ゾーン低頻度アクセスストレージ。再現可能なデータの低コスト保存向け
  #   - "INTELLIGENT_TIERING": アクセスパターンに基づいて自動的にストレージ階層を移動
  #   - "GLACIER": Glacierアーカイブストレージ。長期アーカイブ向け
  #   - "GLACIER_IR": Glacier Instant Retrieval。即時取得が必要なアーカイブデータ向け
  #   - "DEEP_ARCHIVE": Glacier Deep Archiveストレージ。最低コストの長期保管向け
  # 省略時: "STANDARD"
  storage_class = null

  #-------------------------------------------------------------
  # 暗号化設定
  #-------------------------------------------------------------

  # server_side_encryption (Optional)
  # 設定内容: サーバーサイド暗号化のアルゴリズムを指定します。
  # 設定可能な値:
  #   - "AES256": SSE-S3（Amazon S3管理キーによる暗号化）
  #   - "aws:kms": SSE-KMS（AWS KMS管理キーによる暗号化）
  #   - "aws:kms:dsse": SSE-DSSE（デュアルレイヤーSSE-KMS）
  # 省略時: バケットのデフォルト暗号化設定に従う
  server_side_encryption = null

  # kms_key_id (Optional)
  # 設定内容: SSE-KMS暗号化に使用するAWS KMSキーのARNを指定します。
  # 設定可能な値: 有効なKMSキーARN
  # 省略時: server_side_encryptionが"aws:kms"の場合はAWSマネージドキー（aws/s3）を使用
  # 注意: server_side_encryptionが"aws:kms"または"aws:kms:dsse"の場合のみ有効
  kms_key_id = null

  # bucket_key_enabled (Optional)
  # 設定内容: SSE-KMS暗号化のコスト削減のためにS3バケットキーを使用するかを指定します。
  # 設定可能な値:
  #   - true: S3バケットキーを使用（KMSリクエスト数とコストを削減）
  #   - false: バケットキーを使用しない
  # 省略時: バケットのデフォルト設定に従う
  # 注意: server_side_encryptionが"aws:kms"の場合のみ有効
  bucket_key_enabled = null

  # etag (Optional)
  # 設定内容: オブジェクトのETagを指定します。オブジェクトの変更検出に使用されます。
  # 設定可能な値: MD5ハッシュ文字列（例: filemd5("path/to/file")）
  # 省略時: AWSがアップロード時に自動計算
  # 注意: 暗号化されたオブジェクトのETagはMD5ハッシュと異なる場合があります
  etag = null

  #-------------------------------------------------------------
  # アクセス制御設定
  #-------------------------------------------------------------

  # acl (Optional)
  # 設定内容: オブジェクトに適用する定型ACLを指定します。
  # 設定可能な値:
  #   - "private" (デフォルト): オブジェクトオーナーのみアクセス可能
  #   - "public-read": オーナーがFULL_CONTROL、全員がREAD権限
  #   - "public-read-write": オーナーがFULL_CONTROL、全員がREAD/WRITE権限
  #   - "aws-exec-read": オーナーがFULL_CONTROL、AWSがREAD権限
  #   - "authenticated-read": オーナーがFULL_CONTROL、認証済みユーザーがREAD権限
  #   - "bucket-owner-read": オブジェクトオーナーがFULL_CONTROL、バケットオーナーがREAD権限
  #   - "bucket-owner-full-control": オブジェクトオーナーとバケットオーナーの両方がFULL_CONTROL
  # 省略時: "private"
  acl = null

  #-------------------------------------------------------------
  # オブジェクトロック設定
  #-------------------------------------------------------------

  # object_lock_mode (Optional)
  # 設定内容: オブジェクトロックの保持モードを指定します。
  # 設定可能な値:
  #   - "GOVERNANCE": ガバナンスモード。特権ユーザーはロックをバイパス可能
  #   - "COMPLIANCE": コンプライアンスモード。保持期間中は誰も削除・変更不可
  # 省略時: オブジェクトロックなし
  # 注意: バケットのオブジェクトロックが有効化されている必要があります
  # 参考: https://docs.aws.amazon.com/AmazonS3/latest/userguide/object-lock.html
  object_lock_mode = null

  # object_lock_retain_until_date (Optional)
  # 設定内容: オブジェクトロックの保持期限を指定します。
  # 設定可能な値: RFC3339形式の日時文字列（例: "2026-12-31T00:00:00Z"）
  # 省略時: 保持期限なし
  # 注意: object_lock_modeが設定されている場合に必須
  object_lock_retain_until_date = null

  # object_lock_legal_hold_status (Optional)
  # 設定内容: オブジェクトへのリーガルホールドの状態を指定します。
  # 設定可能な値:
  #   - "ON": リーガルホールドを有効化（保持期限に関わらず削除不可）
  #   - "OFF": リーガルホールドを無効化
  # 省略時: リーガルホールドなし
  # 注意: バケットのオブジェクトロックが有効化されている必要があります
  object_lock_legal_hold_status = null

  #-------------------------------------------------------------
  # ライフサイクル設定
  #-------------------------------------------------------------

  # force_destroy (Optional)
  # 設定内容: オブジェクトロックが有効なオブジェクトを強制的に削除するかを指定します。
  # 設定可能な値:
  #   - true: ロックされたオブジェクトも強制削除
  #   - false: ロックされたオブジェクトは削除不可（エラーが発生）
  # 省略時: false
  force_destroy = false

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
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  tags = {
    Name        = "my-s3-object"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: オブジェクトのキー（key属性と同一）
# - arn: オブジェクトのARN（例: arn:aws:s3:::bucketname/key）
# - etag: オブジェクトのETag（MD5ハッシュ）
# - version_id: バージョニングが有効な場合のオブジェクトバージョンID
# - tags_all: プロバイダーの default_tags 設定から継承されたタグを含む全タグマップ
#---------------------------------------------------------------
