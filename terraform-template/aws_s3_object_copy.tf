#---------------------------------------------------------------
# Amazon S3 オブジェクトコピー
#---------------------------------------------------------------
#
# S3バケット内または別のS3バケットへオブジェクトをコピーするリソースです。
# コピー時にメタデータ・タグ・暗号化・ACL・オブジェクトロック設定を
# 上書きまたは引き継ぐことができます。
# アクセスポイント経由のオブジェクトコピーにも対応しています。
#
# AWS公式ドキュメント:
#   - S3 CopyObject API: https://docs.aws.amazon.com/AmazonS3/latest/API/API_CopyObject.html
#   - オブジェクトのコピー: https://docs.aws.amazon.com/AmazonS3/latest/userguide/copy-object.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_object_copy
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_s3_object_copy" "example" {
  #-------------------------------------------------------------
  # 基本設定（コピー先）
  #-------------------------------------------------------------

  # bucket (Required)
  # 設定内容: コピー先バケットの名前を指定します。
  # 設定可能な値: 有効なS3バケット名
  bucket = "destination-bucket"

  # key (Required)
  # 設定内容: コピー先バケット内のオブジェクトの名前（キー）を指定します。
  # 設定可能な値: 文字列。先頭の "/" は無視され、連続する "/" は単一の "/" として扱われます。
  key = "destination/path/object.txt"

  # source (Required)
  # 設定内容: コピー元オブジェクトを指定します。2つの形式があります。
  #   - アクセスポイント非経由: "source-bucket/source-key" 形式（例: testbucket/test1.json）
  #   - アクセスポイント経由: アクセスポイントのARN形式
  #     （例: arn:aws:s3:us-west-2:999999999999:accesspoint/my-access-point/object/testbucket/test1.json）
  # 設定可能な値: "バケット名/キー名" 形式の文字列またはアクセスポイントARN
  source = "source-bucket/source/path/object.txt"

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
  # コピー条件設定
  #-------------------------------------------------------------

  # copy_if_match (Optional)
  # 設定内容: コピー元オブジェクトのETagが指定したタグと一致する場合のみコピーします。
  # 設定可能な値: ETag文字列
  copy_if_match = null

  # copy_if_none_match (Optional)
  # 設定内容: コピー元オブジェクトのETagが指定したタグと異なる場合のみコピーします。
  # 設定可能な値: ETag文字列
  copy_if_none_match = null

  # copy_if_modified_since (Optional)
  # 設定内容: コピー元オブジェクトが指定した日時以降に変更された場合のみコピーします。
  # 設定可能な値: RFC3339形式の日時文字列（例: "2024-01-01T00:00:00Z"）
  copy_if_modified_since = null

  # copy_if_unmodified_since (Optional)
  # 設定内容: コピー元オブジェクトが指定した日時以降に変更されていない場合のみコピーします。
  # 設定可能な値: RFC3339形式の日時文字列（例: "2024-01-01T00:00:00Z"）
  copy_if_unmodified_since = null

  #-------------------------------------------------------------
  # コンテンツ設定
  #-------------------------------------------------------------

  # cache_control (Optional)
  # 設定内容: リクエスト/レスポンスチェーンに沿ったキャッシュ動作を指定します。
  # 設定可能な値: 有効なCache-Controlヘッダー値（例: "max-age=3600"）
  # 省略時: コピー元の設定を引き継ぐ（metadata_directive が "COPY" の場合）
  cache_control = null

  # content_disposition (Optional)
  # 設定内容: オブジェクトの表示方法に関するプレゼンテーション情報を指定します。
  # 設定可能な値: 有効なContent-Dispositionヘッダー値（例: "attachment; filename=file.txt"）
  # 省略時: コピー元の設定を引き継ぐ（metadata_directive が "COPY" の場合）
  content_disposition = null

  # content_encoding (Optional)
  # 設定内容: オブジェクトに適用されたコンテンツエンコーディングを指定します。
  # 設定可能な値: 有効なContent-Encodingヘッダー値（例: "gzip", "compress"）
  # 省略時: コピー元の設定を引き継ぐ（metadata_directive が "COPY" の場合）
  content_encoding = null

  # content_language (Optional)
  # 設定内容: コンテンツの言語を指定します。
  # 設定可能な値: 言語タグ文字列（例: "en-US", "ja-JP"）
  # 省略時: コピー元の設定を引き継ぐ（metadata_directive が "COPY" の場合）
  content_language = null

  # content_type (Optional)
  # 設定内容: オブジェクトデータの標準MIMEタイプを指定します。
  # 設定可能な値: 有効なMIMEタイプ文字列（例: "application/octet-stream", "text/plain"）
  # 省略時: コピー元の設定を引き継ぐ（metadata_directive が "COPY" の場合）
  content_type = null

  # expires (Optional)
  # 設定内容: オブジェクトがキャッシュ不可となる日時をRFC3339形式で指定します。
  # 設定可能な値: RFC3339形式の日時文字列（例: "2025-12-31T23:59:59Z"）
  expires = null

  # website_redirect (Optional)
  # 設定内容: ウェブサイトリダイレクトのターゲットURLを指定します。
  # 設定可能な値: リダイレクト先URLまたは同バケット内の別オブジェクトキー（例: "/newpage.html"）
  # 省略時: コピー元の設定を引き継ぐ（metadata_directive が "COPY" の場合）
  website_redirect = null

  #-------------------------------------------------------------
  # メタデータ設定
  #-------------------------------------------------------------

  # metadata_directive (Optional)
  # 設定内容: メタデータをコピー元から引き継ぐか新しい値で上書きするかを指定します。
  # 設定可能な値:
  #   - "COPY" (デフォルト): コピー元のメタデータを使用
  #   - "REPLACE": リクエストで指定した新しいメタデータを使用
  metadata_directive = null

  # metadata (Optional)
  # 設定内容: オブジェクトに付与するメタデータのキーと値のマップを指定します。
  #   キーは自動的に "x-amz-meta-" プレフィックスが付与されます（小文字のみサポート）。
  # 設定可能な値: キーと値のペアのマップ
  # 省略時: コピー元の設定を引き継ぐ（metadata_directive が "COPY" の場合）
  metadata = {}

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tagging_directive (Optional)
  # 設定内容: タグセットをコピー元から引き継ぐか新しい値で上書きするかを指定します。
  # 設定可能な値:
  #   - "COPY" (デフォルト): コピー元のタグセットを使用
  #   - "REPLACE": リクエストで指定した新しいタグセットを使用
  tagging_directive = null

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  tags = {
    Name        = "example-copied-object"
    Environment = "production"
  }

  #-------------------------------------------------------------
  # ACL設定
  #-------------------------------------------------------------

  # acl (Optional)
  # 設定内容: コピー先オブジェクトに適用する定型ACLを指定します。
  # 設定可能な値:
  #   - "private": バケットオーナーのみアクセス可能
  #   - "public-read": オーナーが FULL_CONTROL、全員が READ 権限
  #   - "public-read-write": オーナーが FULL_CONTROL、全員が READ/WRITE 権限
  #   - "authenticated-read": オーナーが FULL_CONTROL、認証済みユーザーが READ 権限
  #   - "aws-exec-read": オーナーが FULL_CONTROL、AWSが READ 権限
  #   - "bucket-owner-read": バケットオーナーが READ 権限
  #   - "bucket-owner-full-control": バケットオーナーが FULL_CONTROL 権限
  # 注意: grant と排他的（どちらか一方のみ指定可能）
  # 省略時: コピー先バケットのデフォルトACLを継承
  acl = null

  # grant (Optional)
  # 設定内容: ヘッダーグラントのACLポリシー設定ブロックです。複数指定可能。
  # 注意: acl と排他的（どちらか一方のみ指定可能）
  # grant {
  #   # permissions (Required)
  #   # 設定内容: グラント対象に付与するアクセス権限のセットを指定します。
  #   # 設定可能な値: "READ", "READ_ACP", "WRITE_ACP", "FULL_CONTROL"
  #   permissions = ["READ"]
  #
  #   # type (Required)
  #   # 設定内容: グラント対象のタイプを指定します。
  #   # 設定可能な値:
  #   #   - "CanonicalUser": 特定のAWSアカウント（id と併用）
  #   #   - "Group": 定義済みグループ（uri と併用）
  #   #   - "AmazonCustomerByEmail": メールアドレスで指定（email と併用）
  #   type = "CanonicalUser"
  #
  #   # email (Optional)
  #   # 設定内容: グラント対象のメールアドレスを指定します。
  #   # 設定可能な値: AWSアカウントに関連付けられたメールアドレス
  #   # 注意: type が "AmazonCustomerByEmail" の場合のみ使用
  #   email = null
  #
  #   # id (Optional)
  #   # 設定内容: グラント対象の正規ユーザーIDを指定します。
  #   # 設定可能な値: AWSアカウントの正規ユーザーID
  #   # 注意: type が "CanonicalUser" の場合のみ使用
  #   id = null
  #
  #   # uri (Optional)
  #   # 設定内容: グラント対象のグループURIを指定します。
  #   # 設定可能な値: 有効なグループURI（例: "http://acs.amazonaws.com/groups/global/AllUsers"）
  #   # 注意: type が "Group" の場合のみ使用
  #   uri = null
  # }

  #-------------------------------------------------------------
  # ストレージクラス設定
  #-------------------------------------------------------------

  # storage_class (Optional)
  # 設定内容: コピー先オブジェクトのストレージクラスを指定します。
  # 設定可能な値:
  #   - "STANDARD": 標準ストレージ（デフォルト）
  #   - "REDUCED_REDUNDANCY": 低冗長化ストレージ（非推奨）
  #   - "STANDARD_IA": 低頻度アクセス標準ストレージ
  #   - "ONEZONE_IA": 低頻度アクセス単一AZストレージ
  #   - "INTELLIGENT_TIERING": インテリジェント階層化ストレージ
  #   - "GLACIER": Glacierストレージ
  #   - "DEEP_ARCHIVE": Glacier Deep Archiveストレージ
  #   - "GLACIER_IR": Glacier Instant Retrievalストレージ
  #   - "EXPRESS_ONEZONE": S3 Express 単一AZストレージ
  # 省略時: "STANDARD"
  storage_class = null

  #-------------------------------------------------------------
  # 暗号化設定（コピー先）
  #-------------------------------------------------------------

  # server_side_encryption (Optional)
  # 設定内容: コピー先オブジェクトのサーバーサイド暗号化方式を指定します。
  # 設定可能な値:
  #   - "AES256": SSE-S3（Amazon S3管理キー）
  #   - "aws:kms": SSE-KMS（AWS KMS管理キー）
  # 省略時: コピー先バケットのデフォルト暗号化設定を使用
  server_side_encryption = null

  # kms_key_id (Optional, Sensitive)
  # 設定内容: SSE-KMS暗号化に使用するKMSキーのARNを指定します。
  # 設定可能な値: 完全修飾のKMSキーARN（例: aws_kms_key.foo.arn）
  # 注意: server_side_encryption が "aws:kms" の場合のみ有効
  # 省略時: AWSマネージドキー（aws/s3）を使用
  kms_key_id = null

  # kms_encryption_context (Optional, Sensitive)
  # 設定内容: SSE-KMS暗号化に使用する暗号化コンテキストを指定します。
  #   暗号化コンテキストのキーと値ペアをJSON形式でBase64エンコードした文字列を指定します。
  # 設定可能な値: Base64エンコードされたJSONのUTF-8文字列
  kms_encryption_context = null

  # bucket_key_enabled (Optional)
  # 設定内容: SSE-KMS用のAmazon S3バケットキーを使用するかを指定します。
  #   バケットキーを使用すると、KMSへのリクエスト数とコストを削減できます。
  # 設定可能な値:
  #   - true: バケットキーを有効化
  #   - false: バケットキーを無効化
  # 省略時: コピー先バケットの設定を継承
  # 参考: https://docs.aws.amazon.com/AmazonS3/latest/userguide/bucket-key.html
  bucket_key_enabled = null

  # customer_algorithm (Optional)
  # 設定内容: コピー先オブジェクトの顧客提供暗号化キー（SSE-C）で使用するアルゴリズムを指定します。
  # 設定可能な値: "AES256"
  # 省略時: コピー先バケットのデフォルト暗号化設定を引き継ぐ
  customer_algorithm = null

  # customer_key (Optional, Sensitive)
  # 設定内容: SSE-Cでの暗号化に使用する顧客提供暗号化キーを指定します。
  #   Amazon S3はオブジェクトの保存に使用した後、このキーを破棄します。
  # 設定可能な値: customer_algorithm で指定したアルゴリズムに適した暗号化キー文字列
  customer_key = null

  # customer_key_md5 (Optional)
  # 設定内容: RFC 1321に従った暗号化キーの128ビットMD5ダイジェストを指定します。
  #   Amazon S3がメッセージの整合性チェックに使用します。
  # 設定可能な値: 128ビットMD5ダイジェスト文字列
  customer_key_md5 = null

  #-------------------------------------------------------------
  # 暗号化設定（コピー元）
  #-------------------------------------------------------------

  # source_customer_algorithm (Optional)
  # 設定内容: コピー元オブジェクトの復号に使用するアルゴリズムを指定します（SSE-C）。
  # 設定可能な値: "AES256"
  source_customer_algorithm = null

  # source_customer_key (Optional, Sensitive)
  # 設定内容: コピー元オブジェクトの復号に使用する顧客提供暗号化キーを指定します。
  #   コピー元オブジェクト作成時に使用したキーと同じである必要があります。
  # 設定可能な値: コピー元オブジェクト作成時に使用した暗号化キー文字列
  source_customer_key = null

  # source_customer_key_md5 (Optional)
  # 設定内容: コピー元暗号化キーのRFC 1321に従った128ビットMD5ダイジェストを指定します。
  # 設定可能な値: 128ビットMD5ダイジェスト文字列
  source_customer_key_md5 = null

  #-------------------------------------------------------------
  # オブジェクトロック設定
  #-------------------------------------------------------------

  # object_lock_legal_hold_status (Optional)
  # 設定内容: コピー先オブジェクトに適用するリーガルホールドのステータスを指定します。
  # 設定可能な値:
  #   - "ON": リーガルホールドを有効化（オブジェクトの削除・上書きを無期限にブロック）
  #   - "OFF": リーガルホールドを無効化
  # 省略時: コピー先バケットのオブジェクトロック設定を引き継ぐ
  # 参考: https://docs.aws.amazon.com/AmazonS3/latest/userguide/object-lock-overview.html#object-lock-legal-holds
  object_lock_legal_hold_status = null

  # object_lock_mode (Optional)
  # 設定内容: コピー先オブジェクトに適用するオブジェクトロックの保持モードを指定します。
  # 設定可能な値:
  #   - "GOVERNANCE": ガバナンスモード（特権ユーザーはバイパス可能）
  #   - "COMPLIANCE": コンプライアンスモード（保持期間中は誰も削除・変更不可）
  # 参考: https://docs.aws.amazon.com/AmazonS3/latest/userguide/object-lock-overview.html#object-lock-retention-modes
  object_lock_mode = null

  # object_lock_retain_until_date (Optional)
  # 設定内容: コピー先オブジェクトのオブジェクトロックの有効期限日時をRFC3339形式で指定します。
  # 設定可能な値: RFC3339形式の日時文字列（例: "2026-12-31T23:59:59Z"）
  # 参考: https://docs.aws.amazon.com/AmazonS3/latest/userguide/object-lock-overview.html#object-lock-retention-periods
  object_lock_retain_until_date = null

  #-------------------------------------------------------------
  # チェックサム設定
  #-------------------------------------------------------------

  # checksum_algorithm (Optional)
  # 設定内容: オブジェクトのチェックサム生成に使用するアルゴリズムを指定します。
  #   KMS暗号化オブジェクトのチェックサム検証には kms:Decrypt 権限が必要です。
  # 設定可能な値: "CRC32", "CRC32C", "CRC64NVME", "SHA1", "SHA256"
  checksum_algorithm = null

  #-------------------------------------------------------------
  # リクエスト支払い設定
  #-------------------------------------------------------------

  # request_payer (Optional)
  # 設定内容: リクエスト者がリクエスト費用を負担することを確認します。
  #   リクエスト者支払いバケットからオブジェクトをダウンロードする場合に必要です。
  # 設定可能な値: "requester"
  # 参考: https://docs.aws.amazon.com/AmazonS3/latest/userguide/RequesterPaysBuckets.html
  request_payer = null

  #-------------------------------------------------------------
  # バケットオーナー検証設定
  #-------------------------------------------------------------

  # expected_bucket_owner (Optional)
  # 設定内容: コピー先バケットの期待されるオーナーのAWSアカウントIDを指定します。
  #   バケットが別アカウント所有の場合、一致しないと HTTP 403 エラーになります。
  # 設定可能な値: 12桁のAWSアカウントID
  expected_bucket_owner = null

  # expected_source_bucket_owner (Optional)
  # 設定内容: コピー元バケットの期待されるオーナーのAWSアカウントIDを指定します。
  #   バケットが別アカウント所有の場合、一致しないと HTTP 403 エラーになります。
  # 設定可能な値: 12桁のAWSアカウントID
  expected_source_bucket_owner = null

  #-------------------------------------------------------------
  # ライフサイクル設定
  #-------------------------------------------------------------

  # force_destroy (Optional)
  # 設定内容: オブジェクトバージョンのリーガルホールドを解除してオブジェクトの削除を許可するかを指定します。
  # 設定可能な値:
  #   - true: リーガルホールドを解除して削除を許可（バケットでS3オブジェクトロックが有効な場合に使用）
  #   - false (デフォルト): リーガルホールドがある場合は削除不可
  force_destroy = false

  #-------------------------------------------------------------
  # プロバイダーデフォルトタグ上書き設定
  #-------------------------------------------------------------

  # override_provider (Optional)
  # 設定内容: プロバイダーレベルの設定を上書きする設定ブロックです。
  #   プロバイダーの default_tags をこのリソースでのみ無効化したい場合に使用します。
  # override_provider {
  #   # default_tags (Optional)
  #   # 設定内容: プロバイダーの default_tags 設定ブロックを上書きします。
  #   # 参考: https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  #   default_tags {
  #     # tags (Optional)
  #     # 設定内容: このリソースに適用するタグのマップを指定します。
  #     #   空マップを指定するとプロバイダーのデフォルトタグを無効化できます。
  #     # 設定可能な値: キーと値のペアのマップ（空マップも可）
  #     tags = {}
  #   }
  # }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: バケット名とオブジェクトキーを結合した識別子
# - arn: コピーされたオブジェクトのARN
# - etag: オブジェクトのETag（MD5ダイジェスト）
# - expiration: オブジェクトの有効期限設定（設定されている場合）
# - last_modified: オブジェクトの最終更新日時（RFC3339形式）
# - request_charged: リクエスト者への課金が成功した場合にtrue
# - source_version_id: コピー元バケット内のコピー元オブジェクトのバージョンID
# - version_id: 新しく作成されたコピーのバージョンID
# - checksum_crc32: オブジェクトのBase64エンコードされた32ビットCRC32チェックサム
# - checksum_crc32c: オブジェクトのBase64エンコードされた32ビットCRC32Cチェックサム
# - checksum_crc64nvme: オブジェクトのBase64エンコードされた64ビットCRC64NVMEチェックサム
# - checksum_sha1: オブジェクトのBase64エンコードされた160ビットSHA-1ダイジェスト
# - checksum_sha256: オブジェクトのBase64エンコードされた256ビットSHA-256ダイジェスト
# - tags_all: プロバイダーの default_tags 設定から継承されたタグを含む全タグマップ
#---------------------------------------------------------------
