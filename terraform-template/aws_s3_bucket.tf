#---------------------------------------------------------------
# Amazon S3 バケット (General Purpose)
#---------------------------------------------------------------
#
# Amazon S3の汎用バケットをプロビジョニングするリソースです。
# オブジェクトストレージとして任意のデータを保存・取得できます。
# S3 Expressディレクトリバケットは aws_s3_directory_bucket リソースを使用してください。
# S3 on Outpostsには aws_s3control_bucket リソースを使用してください。
#
# AWS公式ドキュメント:
#   - Amazon S3 汎用バケット概要: https://docs.aws.amazon.com/AmazonS3/latest/userguide/UsingBucket.html
#   - バケット作成・設定: https://docs.aws.amazon.com/AmazonS3/latest/userguide/creating-buckets-s3.html
#   - バケット命名規則: https://docs.aws.amazon.com/AmazonS3/latest/userguide/bucketnamingrules.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_s3_bucket" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # bucket (Optional, Forces new resource)
  # 設定内容: バケットの名前を指定します。
  # 設定可能な値: 小文字英数字・ハイフン・ドットを含む3〜63文字の文字列。
  #   AWSアカウントおよびリージョンをまたいでグローバルに一意である必要があります。
  #   "[bucket_name]--[azid]--x-s3" 形式の名前は使用不可。
  # 省略時: Terraformがランダムな一意の名前を生成します。
  # 注意: bucket_prefix と排他的（どちらか一方のみ指定可能）
  # 参考: https://docs.aws.amazon.com/AmazonS3/latest/userguide/bucketnamingrules.html
  bucket = "my-tf-example-bucket"

  # bucket_prefix (Optional, Forces new resource)
  # 設定内容: バケット名の先頭に付与するプレフィックスを指定します。
  #   Terraformがプレフィックスの後にランダムなサフィックスを付加して一意の名前を生成します。
  # 設定可能な値: 小文字英数字・ハイフン・ドットを含む37文字以内の文字列
  # 注意: bucket と排他的（どちらか一方のみ指定可能）
  # 参考: https://docs.aws.amazon.com/AmazonS3/latest/userguide/bucketnamingrules.html
  bucket_prefix = null

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
  # ライフサイクル設定
  #-------------------------------------------------------------

  # force_destroy (Optional)
  # 設定内容: バケット削除時に全オブジェクト（ロックされたオブジェクトを含む）を
  #   強制的に削除するかを指定します。削除されたオブジェクトは復元不可能です。
  #   この設定はバケット destroy 時のみに機能し、true に設定するだけでは削除されません。
  # 設定可能な値:
  #   - true: destroy 時に全オブジェクトを削除してからバケットを削除
  #   - false (デフォルト): オブジェクトが残っている場合は destroy が失敗
  # 注意: true に設定後、次の terraform apply が成功してから destroy を実行する必要があります。
  force_destroy = false

  #-------------------------------------------------------------
  # オブジェクトロック設定
  #-------------------------------------------------------------

  # object_lock_enabled (Optional, Forces new resource)
  # 設定内容: バケットのオブジェクトロック設定を有効にするかを指定します。
  #   オブジェクトロックはバケット作成時にのみ有効化できます。
  #   有効化後は無効化できません。
  # 設定可能な値:
  #   - true: オブジェクトロックを有効化（WORM モデルでオブジェクトを保護）
  #   - false (デフォルト): オブジェクトロックを無効化
  # 注意: 一部のリージョンおよびパーティションではサポートされていません。
  # 参考: https://docs.aws.amazon.com/AmazonS3/latest/userguide/object-lock.html
  object_lock_enabled = false

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 注意: ABAC（属性ベースアクセス制御）を利用する場合は、呼び出し元に
  #   s3:TagResource, s3:UntagResource, s3:ListTagsForResource の IAM 権限が必要です。
  # 参考: https://docs.aws.amazon.com/AmazonS3/latest/userguide/buckets-tagging-enable-abac.html
  tags = {
    Name        = "my-example-bucket"
    Environment = "production"
  }

  #-------------------------------------------------------------
  # 非推奨: アクセスコントロールリスト (ACL) 設定
  #   代替: aws_s3_bucket_acl リソースを使用してください。
  #-------------------------------------------------------------

  # acl (Optional, Deprecated)
  # 設定内容: バケットに適用する定型ACLを指定します。
  # 設定可能な値:
  #   - "private" (デフォルト): バケットオーナーのみアクセス可能
  #   - "public-read": オーナーが FULL_CONTROL、全員が READ 権限
  #   - "public-read-write": オーナーが FULL_CONTROL、全員が READ/WRITE 権限
  #   - "aws-exec-read": オーナーが FULL_CONTROL、AWSがREAD権限
  #   - "authenticated-read": オーナーが FULL_CONTROL、認証済みユーザーが READ 権限
  #   - "log-delivery-write": LogDelivery グループが WRITE/READ_ACP 権限
  # 注意: grant と排他的（どちらか一方のみ指定可能）
  # 非推奨: aws_s3_bucket_acl リソースを使用してください。
  acl = null

  # grant (Optional, Deprecated)
  # 設定内容: ACLポリシーグラントの設定ブロックです。
  # 注意: acl と排他的（どちらか一方のみ指定可能）
  # 非推奨: aws_s3_bucket_acl リソースを使用してください。
  # grant {
  #   # id (Optional)
  #   # 設定内容: グラント対象の正規ユーザーIDを指定します。
  #   # 設定可能な値: AWSアカウントの正規ユーザーID
  #   # 注意: type が "CanonicalUser" の場合のみ使用
  #   id = null
  #
  #   # type (Required)
  #   # 設定内容: グラント対象のタイプを指定します。
  #   # 設定可能な値:
  #   #   - "CanonicalUser": 特定のAWSアカウント
  #   #   - "Group": 定義済みグループ
  #   type = "CanonicalUser"
  #
  #   # permissions (Required)
  #   # 設定内容: グラント対象に付与するアクセス権限のリストを指定します。
  #   # 設定可能な値: "READ", "WRITE", "READ_ACP", "WRITE_ACP", "FULL_CONTROL"
  #   permissions = ["READ"]
  #
  #   # uri (Optional)
  #   # 設定内容: グラント対象のURIを指定します。
  #   # 設定可能な値: 有効なグループURI
  #   # 注意: type が "Group" の場合のみ使用
  #   uri = null
  # }

  #-------------------------------------------------------------
  # 非推奨: 転送加速設定
  #   代替: aws_s3_bucket_accelerate_configuration リソースを使用してください。
  #-------------------------------------------------------------

  # acceleration_status (Optional, Deprecated)
  # 設定内容: バケットの転送加速設定を指定します。
  # 設定可能な値:
  #   - "Enabled": 転送加速を有効化
  #   - "Suspended": 転送加速を一時停止
  # 注意: cn-north-1 および us-gov-west-1 リージョンでは使用不可。
  # 非推奨: aws_s3_bucket_accelerate_configuration リソースを使用してください。
  acceleration_status = null

  #-------------------------------------------------------------
  # 非推奨: バケットポリシー設定
  #   代替: aws_s3_bucket_policy リソースを使用してください。
  #-------------------------------------------------------------

  # policy (Optional, Deprecated)
  # 設定内容: バケットポリシーのJSON文書を指定します。
  # 設定可能な値: 有効なIAMポリシーJSON文字列
  # 非推奨: aws_s3_bucket_policy リソースを使用してください。
  policy = null

  #-------------------------------------------------------------
  # 非推奨: リクエスト支払者設定
  #   代替: aws_s3_bucket_request_payment_configuration リソースを使用してください。
  #-------------------------------------------------------------

  # request_payer (Optional, Deprecated)
  # 設定内容: Amazon S3 データ転送コストを負担する主体を指定します。
  # 設定可能な値:
  #   - "BucketOwner" (デフォルト): バケットオーナーがデータ転送コストを負担
  #   - "Requester": リクエスト者がデータ転送コストを負担
  # 非推奨: aws_s3_bucket_request_payment_configuration リソースを使用してください。
  # 参考: https://docs.aws.amazon.com/AmazonS3/latest/userguide/RequesterPaysBuckets.html
  request_payer = null

  #-------------------------------------------------------------
  # 非推奨: CORS設定
  #   代替: aws_s3_bucket_cors_configuration リソースを使用してください。
  #-------------------------------------------------------------

  # cors_rule (Optional, Deprecated)
  # 設定内容: クロスオリジンリソース共有 (CORS) ルールの設定ブロックです。
  # 非推奨: aws_s3_bucket_cors_configuration リソースを使用してください。
  # 参考: https://docs.aws.amazon.com/AmazonS3/latest/userguide/cors.html
  # cors_rule {
  #   # allowed_headers (Optional)
  #   # 設定内容: 許可するリクエストヘッダーのリストを指定します。
  #   # 設定可能な値: ヘッダー名の文字列リスト
  #   allowed_headers = ["*"]
  #
  #   # allowed_methods (Required)
  #   # 設定内容: オリジンが実行できるHTTPメソッドのリストを指定します。
  #   # 設定可能な値: "GET", "PUT", "POST", "DELETE", "HEAD"
  #   allowed_methods = ["GET"]
  #
  #   # allowed_origins (Required)
  #   # 設定内容: バケットへのアクセスを許可するオリジンのリストを指定します。
  #   # 設定可能な値: オリジンURLの文字列リスト。ワイルドカード "*" も使用可能
  #   allowed_origins = ["https://example.com"]
  #
  #   # expose_headers (Optional)
  #   # 設定内容: レスポンスでアプリケーションからアクセス可能なヘッダーのリストを指定します。
  #   # 設定可能な値: ヘッダー名の文字列リスト
  #   expose_headers = []
  #
  #   # max_age_seconds (Optional)
  #   # 設定内容: プリフライトリクエストのレスポンスをブラウザがキャッシュできる秒数を指定します。
  #   # 設定可能な値: 秒数（整数）
  #   max_age_seconds = 3000
  # }

  #-------------------------------------------------------------
  # 非推奨: ライフサイクルルール設定
  #   代替: aws_s3_bucket_lifecycle_configuration リソースを使用してください。
  #-------------------------------------------------------------

  # lifecycle_rule (Optional, Deprecated)
  # 設定内容: オブジェクトライフサイクル管理の設定ブロックです。複数指定可能。
  # 非推奨: aws_s3_bucket_lifecycle_configuration リソースを使用してください。
  # lifecycle_rule {
  #   # id (Optional)
  #   # 設定内容: ルールの一意な識別子を指定します。
  #   # 設定可能な値: 255文字以内の文字列
  #   # 省略時: Terraformが自動生成
  #   id = null
  #
  #   # prefix (Optional)
  #   # 設定内容: ルールを適用するオブジェクトキーのプレフィックスを指定します。
  #   # 設定可能な値: 文字列
  #   prefix = null
  #
  #   # tags (Optional)
  #   # 設定内容: ルールを適用するオブジェクトタグのマップを指定します。
  #   # 設定可能な値: キーと値のペアのマップ
  #   tags = {}
  #
  #   # enabled (Required)
  #   # 設定内容: ライフサイクルルールのステータスを指定します。
  #   # 設定可能な値:
  #   #   - true: ルールを有効化
  #   #   - false: ルールを無効化
  #   enabled = true
  #
  #   # abort_incomplete_multipart_upload_days (Optional)
  #   # 設定内容: マルチパートアップロードの開始後、不完全なアップロードを中止するまでの日数を指定します。
  #   # 設定可能な値: 正の整数
  #   abort_incomplete_multipart_upload_days = null
  #
  #   # expiration (Optional)
  #   # 設定内容: オブジェクトの有効期限設定ブロックです。
  #   expiration {
  #     # date (Optional)
  #     # 設定内容: オブジェクトを期限切れにする日付を指定します。
  #     # 設定可能な値: ISO 8601 形式の日付文字列（例: "2024-12-31"）
  #     date = null
  #
  #     # days (Optional)
  #     # 設定内容: オブジェクト作成後に期限切れになるまでの日数を指定します。
  #     # 設定可能な値: 正の整数
  #     days = null
  #
  #     # expired_object_delete_marker (Optional)
  #     # 設定内容: バージョニングが有効なバケットで、期限切れオブジェクトの削除マーカーを
  #     #   自動削除するかを指定します。
  #     # 設定可能な値: true / false
  #     # 注意: date または days と同時に指定不可
  #     expired_object_delete_marker = null
  #   }
  #
  #   # transition (Optional)
  #   # 設定内容: オブジェクトのストレージクラス移行設定ブロックです。複数指定可能。
  #   transition {
  #     # date (Optional)
  #     # 設定内容: 移行を実行する日付を指定します。
  #     # 設定可能な値: ISO 8601 形式の日付文字列
  #     date = null
  #
  #     # days (Optional)
  #     # 設定内容: オブジェクト作成後に移行するまでの日数を指定します。
  #     # 設定可能な値: 正の整数
  #     days = null
  #
  #     # storage_class (Required)
  #     # 設定内容: 移行先のS3ストレージクラスを指定します。
  #     # 設定可能な値: "STANDARD_IA", "ONEZONE_IA", "INTELLIGENT_TIERING",
  #     #   "GLACIER", "DEEP_ARCHIVE", "GLACIER_IR"
  #     storage_class = "STANDARD_IA"
  #   }
  #
  #   # noncurrent_version_expiration (Optional)
  #   # 設定内容: 非現行バージョンオブジェクトの有効期限設定ブロックです。
  #   noncurrent_version_expiration {
  #     # days (Optional)
  #     # 設定内容: 非現行バージョンが期限切れになるまでの日数を指定します。
  #     # 設定可能な値: 正の整数
  #     days = 90
  #   }
  #
  #   # noncurrent_version_transition (Optional)
  #   # 設定内容: 非現行バージョンオブジェクトのストレージクラス移行設定ブロックです。複数指定可能。
  #   noncurrent_version_transition {
  #     # days (Optional)
  #     # 設定内容: 非現行バージョンが移行されるまでの日数を指定します。
  #     # 設定可能な値: 正の整数
  #     days = 30
  #
  #     # storage_class (Required)
  #     # 設定内容: 移行先のS3ストレージクラスを指定します。
  #     # 設定可能な値: "STANDARD_IA", "ONEZONE_IA", "INTELLIGENT_TIERING",
  #     #   "GLACIER", "DEEP_ARCHIVE", "GLACIER_IR"
  #     storage_class = "GLACIER"
  #   }
  # }

  #-------------------------------------------------------------
  # 非推奨: アクセスログ設定
  #   代替: aws_s3_bucket_logging リソースを使用してください。
  #-------------------------------------------------------------

  # logging (Optional, Deprecated)
  # 設定内容: S3バケットアクセスログの設定ブロックです。
  # 非推奨: aws_s3_bucket_logging リソースを使用してください。
  # 参考: https://docs.aws.amazon.com/AmazonS3/latest/userguide/ServerLogs.html
  # logging {
  #   # target_bucket (Required)
  #   # 設定内容: ログオブジェクトを受信するバケットの名前を指定します。
  #   # 設定可能な値: 有効なS3バケット名
  #   target_bucket = "my-log-bucket"
  #
  #   # target_prefix (Optional)
  #   # 設定内容: ログオブジェクトのキープレフィックスを指定します。
  #   # 設定可能な値: 文字列
  #   # 省略時: プレフィックスなし
  #   target_prefix = "s3-access-logs/"
  # }

  #-------------------------------------------------------------
  # 非推奨: オブジェクトロック詳細設定
  #   代替: object_lock_enabled 属性および aws_s3_bucket_object_lock_configuration リソースを使用してください。
  #-------------------------------------------------------------

  # object_lock_configuration (Optional, Deprecated)
  # 設定内容: オブジェクトロックの詳細設定ブロックです。
  # 非推奨: object_lock_enabled 属性および aws_s3_bucket_object_lock_configuration
  #   リソースを使用してください。
  # 参考: https://docs.aws.amazon.com/AmazonS3/latest/userguide/object-lock.html
  # object_lock_configuration {
  #   # object_lock_enabled (Optional, Deprecated)
  #   # 設定内容: オブジェクトロックが有効かを示す文字列です。
  #   # 設定可能な値: "Enabled"
  #   # 非推奨: トップレベルの object_lock_enabled 属性を使用してください。
  #   object_lock_enabled = "Enabled"
  #
  #   # rule (Optional, Deprecated)
  #   # 設定内容: オブジェクトロックのルール設定ブロックです。
  #   rule {
  #     # default_retention (Required)
  #     # 設定内容: 新規オブジェクトに適用するデフォルト保持期間の設定ブロックです。
  #     default_retention {
  #       # mode (Required)
  #       # 設定内容: デフォルトのオブジェクトロック保持モードを指定します。
  #       # 設定可能な値:
  #       #   - "GOVERNANCE": ガバナンスモード。特権ユーザーは保護をバイパス可能
  #       #   - "COMPLIANCE": コンプライアンスモード。誰も保持期間中は削除・変更不可
  #       mode = "GOVERNANCE"
  #
  #       # days (Optional)
  #       # 設定内容: デフォルト保持期間を日数で指定します。
  #       # 設定可能な値: 正の整数
  #       # 注意: years と排他的（どちらか一方のみ指定可能）
  #       days = null
  #
  #       # years (Optional)
  #       # 設定内容: デフォルト保持期間を年数で指定します。
  #       # 設定可能な値: 正の整数
  #       # 注意: days と排他的（どちらか一方のみ指定可能）
  #       years = null
  #     }
  #   }
  # }

  #-------------------------------------------------------------
  # 非推奨: レプリケーション設定
  #   代替: aws_s3_bucket_replication_configuration リソースを使用してください。
  #-------------------------------------------------------------

  # replication_configuration (Optional, Deprecated)
  # 設定内容: クロスリージョンレプリケーション (CRR) またはセームリージョンレプリケーション (SRR)
  #   の設定ブロックです。
  # 非推奨: aws_s3_bucket_replication_configuration リソースを使用してください。
  # 参考: https://docs.aws.amazon.com/AmazonS3/latest/userguide/replication.html
  # replication_configuration {
  #   # role (Required)
  #   # 設定内容: Amazon S3 がオブジェクトのレプリケーション時に引き受ける IAM ロールの ARN を指定します。
  #   # 設定可能な値: 有効な IAM ロール ARN
  #   role = "arn:aws:iam::123456789012:role/replication-role"
  #
  #   # rules (Required)
  #   # 設定内容: レプリケーションを管理するルールの設定ブロックです。1つ以上必要。
  #   rules {
  #     # id (Optional)
  #     # 設定内容: ルールの一意な識別子を指定します。
  #     # 設定可能な値: 255文字以内の文字列
  #     id = null
  #
  #     # prefix (Optional)
  #     # 設定内容: レプリケーション対象オブジェクトのキープレフィックスを指定します。
  #     # 設定可能な値: 1024文字以内の文字列
  #     # 注意: filter と排他的（どちらか一方のみ指定可能）
  #     prefix = null
  #
  #     # priority (Optional)
  #     # 設定内容: ルールの優先度を指定します。filter が設定されている場合のみ指定します。
  #     # 設定可能な値: 整数。複数ルール間で一意である必要があります。
  #     # 省略時: 0
  #     priority = null
  #
  #     # status (Required)
  #     # 設定内容: ルールのステータスを指定します。
  #     # 設定可能な値:
  #     #   - "Enabled": ルールを有効化
  #     #   - "Disabled": ルールを無効化
  #     status = "Enabled"
  #
  #     # delete_marker_replication_status (Optional)
  #     # 設定内容: 削除マーカーをレプリケートするかを指定します。
  #     # 設定可能な値: "Enabled"
  #     # 注意: filter を使用した V2 レプリケーション設定でのみ有効。無効にする場合は省略。
  #     delete_marker_replication_status = null
  #
  #     # destination (Required)
  #     # 設定内容: レプリケーション先の設定ブロックです。
  #     destination {
  #       # bucket (Required)
  #       # 設定内容: レプリカを保存するバケットの ARN を指定します。
  #       # 設定可能な値: 有効な S3 バケット ARN
  #       bucket = "arn:aws:s3:::destination-bucket"
  #
  #       # storage_class (Optional)
  #       # 設定内容: レプリカのストレージクラスを指定します。
  #       # 設定可能な値: "STANDARD", "REDUCED_REDUNDANCY", "STANDARD_IA",
  #       #   "ONEZONE_IA", "INTELLIGENT_TIERING", "GLACIER", "DEEP_ARCHIVE", "GLACIER_IR"
  #       # 省略時: ソースオブジェクトのストレージクラスを使用
  #       storage_class = null
  #
  #       # replica_kms_key_id (Optional)
  #       # 設定内容: SSE-KMS レプリケーション用の宛先 KMS キー ARN を指定します。
  #       # 設定可能な値: 有効な KMS キー ARN
  #       # 注意: source_selection_criteria の sse_kms_encrypted_objects と併用が必要
  #       replica_kms_key_id = null
  #
  #       # account_id (Optional)
  #       # 設定内容: レプリカオーナーを上書きするアカウント ID を指定します。
  #       # 設定可能な値: AWS アカウント ID
  #       # 注意: access_control_translation と併用が必要
  #       account_id = null
  #
  #       # access_control_translation (Optional)
  #       # 設定内容: レプリケーション時のオブジェクトオーナー上書き設定ブロックです。
  #       # 注意: account_id と併用が必要
  #       access_control_translation {
  #         # owner (Required)
  #         # 設定内容: レプリカのオーナーを指定します。
  #         # 設定可能な値: "Destination"
  #         owner = "Destination"
  #       }
  #
  #       # metrics (Optional)
  #       # 設定内容: レプリケーションメトリクスの設定ブロックです（S3 RTC に必要）。
  #       metrics {
  #         # status (Optional)
  #         # 設定内容: レプリケーションメトリクスのステータスを指定します。
  #         # 設定可能な値: "Enabled", "Disabled"
  #         status = "Enabled"
  #
  #         # minutes (Optional)
  #         # 設定内容: レプリケーションのしきい値時間（分）を指定します。
  #         # 設定可能な値: 15
  #         minutes = 15
  #       }
  #
  #       # replication_time (Optional)
  #       # 設定内容: S3 レプリケーション時間制御 (S3 RTC) の設定ブロックです。
  #       replication_time {
  #         # status (Optional)
  #         # 設定内容: S3 RTC のステータスを指定します。
  #         # 設定可能な値: "Enabled", "Disabled"
  #         status = "Enabled"
  #
  #         # minutes (Optional)
  #         # 設定内容: レプリケーション完了のしきい値時間（分）を指定します。
  #         # 設定可能な値: 15
  #         minutes = 15
  #       }
  #     }
  #
  #     # filter (Optional)
  #     # 設定内容: レプリケーション対象のオブジェクトを絞り込むフィルター設定ブロックです。
  #     # 注意: prefix と排他的（どちらか一方のみ指定可能）
  #     filter {
  #       # prefix (Optional)
  #       # 設定内容: フィルタリング対象オブジェクトのキープレフィックスを指定します。
  #       # 設定可能な値: 1024文字以内の文字列
  #       prefix = null
  #
  #       # tags (Optional)
  #       # 設定内容: フィルタリング対象オブジェクトのタグのマップを指定します。
  #       # 設定可能な値: キーと値のペアのマップ
  #       tags = {}
  #     }
  #
  #     # source_selection_criteria (Optional)
  #     # 設定内容: レプリケーション対象オブジェクトの選択条件設定ブロックです。
  #     source_selection_criteria {
  #       # sse_kms_encrypted_objects (Optional)
  #       # 設定内容: SSE-KMS で暗号化されたオブジェクトのレプリケーション設定ブロックです。
  #       # 注意: destination の replica_kms_key_id と併用が必要
  #       sse_kms_encrypted_objects {
  #         # enabled (Required)
  #         # 設定内容: SSE-KMS オブジェクトのレプリケーションを有効にするかを指定します。
  #         # 設定可能な値: true / false
  #         enabled = true
  #       }
  #     }
  #   }
  # }

  #-------------------------------------------------------------
  # 非推奨: サーバーサイド暗号化設定
  #   代替: aws_s3_bucket_server_side_encryption_configuration リソースを使用してください。
  #-------------------------------------------------------------

  # server_side_encryption_configuration (Optional, Deprecated)
  # 設定内容: サーバーサイド暗号化のデフォルト設定ブロックです。
  # 非推奨: aws_s3_bucket_server_side_encryption_configuration リソースを使用してください。
  # 参考: https://docs.aws.amazon.com/AmazonS3/latest/userguide/bucket-encryption.html
  # server_side_encryption_configuration {
  #   # rule (Required)
  #   # 設定内容: サーバーサイド暗号化のルール設定ブロックです。
  #   rule {
  #     # bucket_key_enabled (Optional)
  #     # 設定内容: SSE-KMS 用の Amazon S3 バケットキーを使用するかを指定します。
  #     #   バケットキーを使用すると KMS リクエスト数とコストを削減できます。
  #     # 設定可能な値: true / false
  #     # 参考: https://docs.aws.amazon.com/AmazonS3/latest/userguide/bucket-key.html
  #     bucket_key_enabled = false
  #
  #     # apply_server_side_encryption_by_default (Required)
  #     # 設定内容: デフォルトのサーバーサイド暗号化設定ブロックです。
  #     apply_server_side_encryption_by_default {
  #       # sse_algorithm (Required)
  #       # 設定内容: サーバーサイド暗号化アルゴリズムを指定します。
  #       # 設定可能な値:
  #       #   - "AES256": SSE-S3（Amazon S3 管理キー）
  #       #   - "aws:kms": SSE-KMS（AWS KMS 管理キー）
  #       sse_algorithm = "aws:kms"
  #
  #       # kms_master_key_id (Optional)
  #       # 設定内容: SSE-KMS 暗号化に使用する AWS KMS マスターキー ID を指定します。
  #       # 設定可能な値: 有効な KMS キー ARN またはキーエイリアス
  #       # 省略時: sse_algorithm が "aws:kms" の場合は デフォルトの aws/s3 KMS キーを使用
  #       # 注意: sse_algorithm が "aws:kms" の場合のみ有効
  #       kms_master_key_id = null
  #     }
  #   }
  # }

  #-------------------------------------------------------------
  # 非推奨: バージョニング設定
  #   代替: aws_s3_bucket_versioning リソースを使用してください。
  #-------------------------------------------------------------

  # versioning (Optional, Deprecated)
  # 設定内容: バケットのバージョニング状態の設定ブロックです。
  # 非推奨: aws_s3_bucket_versioning リソースを使用してください。
  # 参考: https://docs.aws.amazon.com/AmazonS3/latest/userguide/Versioning.html
  # versioning {
  #   # enabled (Optional)
  #   # 設定内容: バージョニングを有効にするかを指定します。
  #   # 設定可能な値: true / false
  #   # 注意: 一度バージョニングを有効化したバケットは無効化できません（一時停止のみ可能）。
  #   enabled = true
  #
  #   # mfa_delete (Optional)
  #   # 設定内容: MFA Delete を有効にするかを指定します。
  #   #   バージョニング状態の変更またはオブジェクトバージョンの永久削除に MFA が必要になります。
  #   # 設定可能な値: true / false
  #   # 省略時: false
  #   # 注意: この設定の切り替えには使用できませんが、管理対象バケットの状態をAWSに反映するために使用可能。
  #   mfa_delete = false
  # }

  #-------------------------------------------------------------
  # 非推奨: ウェブサイトホスティング設定
  #   代替: aws_s3_bucket_website_configuration リソースを使用してください。
  #-------------------------------------------------------------

  # website (Optional, Deprecated)
  # 設定内容: S3 静的ウェブサイトホスティングの設定ブロックです。
  # 非推奨: aws_s3_bucket_website_configuration リソースを使用してください。
  # 参考: https://docs.aws.amazon.com/AmazonS3/latest/userguide/WebsiteHosting.html
  # website {
  #   # index_document (Optional)
  #   # 設定内容: ルートドメインまたはサブフォルダへのリクエスト時に返すインデックスドキュメントを指定します。
  #   # 設定可能な値: ファイル名文字列（例: "index.html"）
  #   # 注意: redirect_all_requests_to を使用しない場合に指定
  #   index_document = "index.html"
  #
  #   # error_document (Optional)
  #   # 設定内容: 4XX エラー発生時に返すエラードキュメントの絶対パスを指定します。
  #   # 設定可能な値: ファイルパス文字列（例: "error.html"）
  #   error_document = "error.html"
  #
  #   # redirect_all_requests_to (Optional)
  #   # 設定内容: このバケットへの全ウェブサイトリクエストをリダイレクトするホスト名を指定します。
  #   # 設定可能な値: ホスト名文字列（オプションで http:// または https:// プロトコルプレフィックスを含む）
  #   # 省略時: 元のリクエストと同じプロトコルを使用
  #   redirect_all_requests_to = null
  #
  #   # routing_rules (Optional)
  #   # 設定内容: リダイレクト動作とリダイレクト適用条件を記述するルーティングルールの
  #   #   JSON 配列文字列を指定します。
  #   # 設定可能な値: JSON 配列文字列
  #   routing_rules = null
  # }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト時間を設定するブロックです。
  timeouts {
    # create (Optional)
    # 設定内容: バケット作成操作のタイムアウト時間を指定します。
    # 設定可能な値: "60s", "10m", "2h" 等の時間文字列
    create = null

    # read (Optional)
    # 設定内容: バケット読み取り操作のタイムアウト時間を指定します。
    # 設定可能な値: "60s", "10m", "2h" 等の時間文字列
    read = null

    # update (Optional)
    # 設定内容: バケット更新操作のタイムアウト時間を指定します。
    # 設定可能な値: "60s", "10m", "2h" 等の時間文字列
    update = null

    # delete (Optional)
    # 設定内容: バケット削除操作のタイムアウト時間を指定します。
    # 設定可能な値: "60s", "10m", "2h" 等の時間文字列
    delete = null
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: バケットの名前
# - arn: バケットの ARN（例: arn:aws:s3:::bucketname）
# - bucket_domain_name: バケットのドメイン名（例: bucketname.s3.amazonaws.com）
# - bucket_regional_domain_name: バケットのリージョン固有ドメイン名
# - bucket_region: バケットが存在する AWS リージョン
# - hosted_zone_id: バケットのリージョンの Route 53 ホストゾーン ID
# - tags_all: プロバイダーの default_tags 設定から継承されたタグを含む全タグマップ
# - website_endpoint: (非推奨) ウェブサイトエンドポイント
# - website_domain: (非推奨) ウェブサイトエンドポイントのドメイン
#---------------------------------------------------------------
