#---------------------------------------------------------------
# AWS S3 Object
#---------------------------------------------------------------
#
# Amazon S3バケット内のオブジェクト（ファイル）をプロビジョニングするリソースです。
# ファイルのアップロード、コンテンツの設定、暗号化、アクセス制御、
# オブジェクトロック等を管理します。
#
# AWS公式ドキュメント:
#   - Amazon S3オブジェクト概要: https://docs.aws.amazon.com/AmazonS3/latest/userguide/Welcome.html
#   - S3ストレージクラス: https://docs.aws.amazon.com/AmazonS3/latest/userguide/storage-class-intro.html
#   - S3サーバーサイド暗号化: https://docs.aws.amazon.com/AmazonS3/latest/userguide/serv-side-encryption.html
#   - S3 Object Lock: https://docs.aws.amazon.com/AmazonS3/latest/userguide/object-lock.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_object
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_s3_object" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # bucket (Required)
  # 設定内容: オブジェクトを配置するバケットの名前またはS3アクセスポイントARNを指定します。
  # 設定可能な値: バケット名の文字列、またはS3アクセスポイントARN
  # 参考: https://docs.aws.amazon.com/AmazonS3/latest/dev/using-access-points.html
  bucket = "your-bucket-name"

  # key (Required)
  # 設定内容: バケット内でのオブジェクト名（パス）を指定します。
  # 設定可能な値: 文字列。先頭の「/」は無視され、連続する「/」は単一の「/」として扱われます。
  # 注意: Terraformはキーの先頭スラッシュを全て無視します。例: "/index.html" と "index.html" は同一オブジェクト
  key = "path/to/object.txt"

  #-------------------------------------------------------------
  # コンテンツ設定
  #-------------------------------------------------------------

  # source (Optional)
  # 設定内容: アップロードするローカルファイルのパスを指定します。
  # 設定可能な値: ローカルファイルシステム上のファイルパス
  # 省略時: content または content_base64 で内容を指定するか、空オブジェクトになります
  # 注意: content および content_base64 と排他的（いずれか一方のみ指定可能）
  source = "path/to/local/file.txt"

  # content (Optional)
  # 設定内容: オブジェクトのコンテンツをUTF-8エンコードされたテキスト文字列で指定します。
  # 設定可能な値: UTF-8テキスト文字列
  # 省略時: null
  # 注意: source および content_base64 と排他的（いずれか一方のみ指定可能）
  content = null

  # content_base64 (Optional)
  # 設定内容: Base64エンコードされたバイナリデータをオブジェクトコンテンツとして指定します。
  # 設定可能な値: Base64エンコード済みの文字列
  # 省略時: null
  # 注意: source および content と排他的（いずれか一方のみ指定可能）。
  #       大きなオブジェクトにはsourceの使用を推奨します。
  content_base64 = null

  # source_hash (Optional)
  # 設定内容: sourceファイルのMD5ハッシュ値を指定します。ファイル変更時の差分検知に使用します。
  # 設定可能な値: filemd5("path/to/source") 関数の結果（Terraform 0.11.12以降）
  # 省略時: null
  # 注意: etag がKMS暗号化やマルチパートアップロードで使用できない場合の代替として有用です。
  #       値はTerraformのstateにのみ保存され、AWSには保存されません。
  source_hash = null

  #-------------------------------------------------------------
  # HTTPコンテンツメタデータ設定
  #-------------------------------------------------------------

  # content_type (Optional)
  # 設定内容: オブジェクトデータのフォーマットを表す標準MIMEタイプを指定します。
  # 設定可能な値: 標準MIMEタイプ文字列（例: "text/html", "application/json", "image/png"）
  # 省略時: AWSがデフォルト値を設定します
  content_type = "text/plain"

  # cache_control (Optional)
  # 設定内容: リクエスト/レスポンスチェーンに沿ったキャッシュ動作を指定します。
  # 設定可能な値: HTTPキャッシュ制御ディレクティブ（例: "max-age=3600", "no-cache"）
  # 省略時: null
  cache_control = null

  # content_disposition (Optional)
  # 設定内容: オブジェクトのプレゼンテーション情報（ファイル名等）を指定します。
  # 設定可能な値: Content-Dispositionヘッダー値（例: "attachment; filename=\"file.txt\""）
  # 省略時: null
  content_disposition = null

  # content_encoding (Optional)
  # 設定内容: オブジェクトに適用されたエンコード方式を指定します。
  # 設定可能な値: エンコーディング識別子（例: "gzip", "deflate"）
  # 省略時: null
  # 注意: content_encoding を指定する場合、ボディのエンコード/圧縮はユーザーの責任です。
  content_encoding = null

  # content_language (Optional)
  # 設定内容: コンテンツの言語を指定します。
  # 設定可能な値: 言語タグ（例: "ja-JP", "en-US", "en-GB"）
  # 省略時: null
  content_language = null

  # website_redirect (Optional)
  # 設定内容: ウェブサイトホスティング時のリダイレクト先URLを指定します。
  # 設定可能な値: リダイレクト先のURL文字列
  # 省略時: null
  # 参考: https://docs.aws.amazon.com/AmazonS3/latest/dev/how-to-page-redirect.html
  website_redirect = null

  #-------------------------------------------------------------
  # データ整合性設定
  #-------------------------------------------------------------

  # etag (Optional)
  # 設定内容: オブジェクトのETagを指定します。ファイル変更時の差分検知に使用します。
  # 設定可能な値: filemd5("path/to/file") 関数の結果（Terraform 0.11.12以降）
  # 省略時: null
  # 注意: KMS暗号化（kms_key_id または server_side_encryption = "aws:kms"）とは互換性がありません。
  #       16MBを超えるオブジェクトはマルチパートアップロードになり、ETagがMD5ダイジェストにならないため
  #       source_hash の使用を推奨します。
  etag = null

  # checksum_algorithm (Optional)
  # 設定内容: オブジェクトのチェックサム計算に使用するアルゴリズムを指定します。
  # 設定可能な値:
  #   - "CRC32": 32ビットCRC32チェックサム
  #   - "CRC32C": 32ビットCRC32Cチェックサム
  #   - "CRC64NVME": 64ビットCRC64NVMEチェックサム
  #   - "SHA1": 160ビットSHA-1ダイジェスト
  #   - "SHA256": 256ビットSHA-256ダイジェスト
  # 省略時: null
  # 注意: KMS暗号化されたオブジェクトのチェックサム検証にはkms:Decrypt権限が必要です。
  checksum_algorithm = null

  #-------------------------------------------------------------
  # アクセス制御設定
  #-------------------------------------------------------------

  # acl (Optional)
  # 設定内容: オブジェクトに適用する定型ACLを指定します。
  # 設定可能な値:
  #   - "private": オーナーのみフルコントロール
  #   - "public-read": オーナーはフルコントロール、全員が読み取り可能
  #   - "public-read-write": オーナーはフルコントロール、全員が読み書き可能
  #   - "aws-exec-read": オーナーはフルコントロール、EC2がREADアクセス可能
  #   - "authenticated-read": オーナーはフルコントロール、認証済みAWSユーザーが読み取り可能
  #   - "bucket-owner-read": オーナーはフルコントロール、バケットオーナーがREADアクセス可能
  #   - "bucket-owner-full-control": オーナーとバケットオーナーが共にフルコントロール
  # 省略時: バケットのデフォルトACL設定が適用されます
  # 参考: https://docs.aws.amazon.com/AmazonS3/latest/dev/acl-overview.html#canned-acl
  acl = "private"

  #-------------------------------------------------------------
  # ストレージクラス設定
  #-------------------------------------------------------------

  # storage_class (Optional)
  # 設定内容: オブジェクトのストレージクラスを指定します。
  # 設定可能な値:
  #   - "STANDARD" (デフォルト): 頻繁にアクセスされるデータ向け
  #   - "REDUCED_REDUNDANCY": 重要度の低い再現可能データ向け（非推奨）
  #   - "ONEZONE_IA": 単一AZの低頻度アクセス向け
  #   - "INTELLIGENT_TIERING": アクセスパターンが不明または変化するデータ向け
  #   - "GLACIER": 長期アーカイブ向け（取得に数分〜数時間）
  #   - "DEEP_ARCHIVE": 最長期アーカイブ向け（最低コスト）
  #   - "GLACIER_IR": アーカイブデータへの即時アクセスが必要な場合
  #   - "STANDARD_IA": 低頻度アクセス向け（最低30日間の保存）
  #   - "EXPRESS_ONEZONE": 高パフォーマンス単一ゾーン向け
  # 省略時: "STANDARD"
  # 参考: https://docs.aws.amazon.com/AmazonS3/latest/userguide/storage-class-intro.html
  storage_class = "STANDARD"

  #-------------------------------------------------------------
  # 暗号化設定
  #-------------------------------------------------------------

  # server_side_encryption (Optional)
  # 設定内容: S3でのオブジェクトのサーバーサイド暗号化方式を指定します。
  # 設定可能な値:
  #   - "AES256": S3管理キーによるSSE-S3（256ビットAES）
  #   - "aws:kms": KMSキーによるSSE-KMS
  #   - "aws:kms:dsse": KMSキーによるデュアルレイヤーSSE-KMS（2層のAES-256暗号化）
  #   - "aws:fsx": Amazon FSxアクセスポイント使用時のSSE-FSX
  # 省略時: バケットのデフォルト暗号化設定が適用されます
  # 参考: https://docs.aws.amazon.com/AmazonS3/latest/userguide/serv-side-encryption.html
  server_side_encryption = "aws:kms"

  # kms_key_id (Optional)
  # 設定内容: オブジェクト暗号化に使用するKMSキーのARNを指定します。
  # 設定可能な値: 有効なKMSキーARN
  # 省略時: バケットにSSE-KMSが設定されている場合はそのキーが使用されます
  # 注意: aws_kms_key リソースを参照する場合はarn属性を使用。
  #       aws_kms_alias リソース/データソースを参照する場合はtarget_key_arn属性を使用。
  #       Terraformはこの値が設定されている場合のみドリフト検知を実行します。
  kms_key_id = "arn:aws:kms:ap-northeast-1:123456789012:key/12345678-1234-1234-1234-123456789012"

  # bucket_key_enabled (Optional)
  # 設定内容: SSE-KMS使用時にAmazon S3バケットキーを使用するかを指定します。
  # 設定可能な値:
  #   - true: バケットキーを使用してKMSへのリクエスト数を削減（コスト削減）
  #   - false: 各オブジェクトに個別のデータキーを使用
  # 省略時: バケットの設定に従います
  # 関連機能: Amazon S3バケットキー
  #   KMSリクエスト数を最大99%削減することでSSE-KMSのコストを大幅に削減できます。
  #   - https://docs.aws.amazon.com/AmazonS3/latest/dev/bucket-key.html
  bucket_key_enabled = true

  #-------------------------------------------------------------
  # メタデータ設定
  #-------------------------------------------------------------

  # metadata (Optional)
  # 設定内容: オブジェクトに付加するメタデータのキーと値のマップを指定します。
  # 設定可能な値: キーと値の文字列マップ
  # 省略時: null
  # 注意: AWSは自動的に "x-amz-meta-" プレフィックスを付加します。
  #       現在のAWS Go APIでは小文字ラベルのみサポートされています。
  metadata = {
    "content-owner" = "team-infra"
    "environment"   = "production"
  }

  #-------------------------------------------------------------
  # オブジェクトロック設定
  #-------------------------------------------------------------

  # object_lock_legal_hold_status (Optional)
  # 設定内容: オブジェクトに適用するリーガルホールドステータスを指定します。
  # 設定可能な値:
  #   - "ON": リーガルホールドを有効化（明示的に解除するまでオブジェクトの上書き・削除を防止）
  #   - "OFF": リーガルホールドを無効化
  # 省略時: null
  # 注意: バケットのオブジェクトロックが有効になっている必要があります。
  # 参考: https://docs.aws.amazon.com/AmazonS3/latest/dev/object-lock-overview.html#object-lock-legal-holds
  object_lock_legal_hold_status = null

  # object_lock_mode (Optional)
  # 設定内容: オブジェクトに適用するオブジェクトロックの保持モードを指定します。
  # 設定可能な値:
  #   - "GOVERNANCE": 特別な権限（s3:BypassGovernanceRetention）を持つユーザーは上書き・削除が可能
  #   - "COMPLIANCE": 保持期間中はrootユーザーを含む全ユーザーによる上書き・削除が不可
  # 省略時: null
  # 注意: object_lock_retain_until_date と併用する必要があります。
  #       バケットのバージョニングとオブジェクトロックが有効になっている必要があります。
  # 参考: https://docs.aws.amazon.com/AmazonS3/latest/dev/object-lock-overview.html#object-lock-retention-modes
  object_lock_mode = null

  # object_lock_retain_until_date (Optional)
  # 設定内容: オブジェクトロックの保持期間終了日時をRFC3339形式で指定します。
  # 設定可能な値: RFC3339形式の日時文字列（例: "2026-12-31T23:59:59Z"）
  # 省略時: null
  # 注意: object_lock_mode と併用する必要があります。
  # 参考: https://docs.aws.amazon.com/AmazonS3/latest/dev/object-lock-overview.html#object-lock-retention-periods
  object_lock_retain_until_date = null

  #-------------------------------------------------------------
  # ライフサイクル設定
  #-------------------------------------------------------------

  # force_destroy (Optional)
  # 設定内容: オブジェクトにリーガルホールドがある場合でも削除を許可するかを指定します。
  # 設定可能な値:
  #   - true: リーガルホールドを解除してオブジェクトを削除
  #   - false (デフォルト): リーガルホールドがある場合は削除しない
  # 省略時: false
  # 注意: バケットでS3オブジェクトロックが有効な場合にのみ関連します。
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
  # 設定内容: オブジェクトに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 省略時: null
  # 注意: プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #       一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "example-object"
    Environment = "production"
    ManagedBy   = "terraform"
  }

  #-------------------------------------------------------------
  # プロバイダーデフォルトタグ上書き設定
  #-------------------------------------------------------------

  # override_provider (Optional)
  # 設定内容: プロバイダーレベルの設定オプションを上書きします。
  # 省略時: プロバイダーのデフォルト設定が適用されます
  override_provider {

    # default_tags (Optional)
    # 設定内容: プロバイダーのdefault_tags設定ブロックを上書きします。
    #           特定のオブジェクトでプロバイダーレベルのタグを無効化したい場合に使用します。
    default_tags {

      # tags (Optional)
      # 設定内容: このオブジェクトに適用するタグのマップを指定します。
      # 設定可能な値: キーと値の文字列マップ。空マップ {} を指定するとプロバイダータグを無効化
      tags = {}
    }
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: オブジェクトのARN
# - etag: オブジェクトのETag（コンテンツのMD5ハッシュ。KMS暗号化やマルチパートでは異なる）
# - version_id: バケットバージョニングが有効な場合のオブジェクトの一意バージョンID
# - checksum_crc32: Base64エンコードされた32ビットCRC32チェックサム
# - checksum_crc32c: Base64エンコードされた32ビットCRC32Cチェックサム
# - checksum_crc64nvme: Base64エンコードされた64ビットCRC64NVMEチェックサム
# - checksum_sha1: Base64エンコードされた160ビットSHA-1ダイジェスト
# - checksum_sha256: Base64エンコードされた256ビットSHA-256ダイジェスト
# - tags_all: プロバイダーのdefault_tags設定から継承されたタグを含む全タグのマップ
#---------------------------------------------------------------
