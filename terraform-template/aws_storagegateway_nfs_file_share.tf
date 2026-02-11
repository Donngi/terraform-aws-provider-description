#---------------------------------------------------------------
# AWS Storage Gateway NFS File Share
#---------------------------------------------------------------
#
# AWS Storage GatewayのNFSファイル共有をプロビジョニングするリソースです。
# NFSファイル共有は、Amazon S3バケットをバックエンドストレージとして使用し、
# NFSプロトコル経由でファイルシステムとしてマウントできるようにします。
#
# AWS公式ドキュメント:
#   - Storage Gateway NFS File Share概要: https://docs.aws.amazon.com/filegateway/latest/files3/create-nfs-file-share.html
#   - CreateNFSFileShare API: https://docs.aws.amazon.com/storagegateway/latest/APIReference/API_CreateNFSFileShare.html
#   - NFS File Share Defaults: https://docs.aws.amazon.com/storagegateway/latest/APIReference/API_NFSFileShareDefaults.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/storagegateway_nfs_file_share
#
# Provider Version: 6.28.0
# Generated: 2026-02-05
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_storagegateway_nfs_file_share" "example" {
  #-------------------------------------------------------------
  # 必須設定
  #-------------------------------------------------------------

  # client_list (Required)
  # 設定内容: ファイルゲートウェイへのアクセスを許可するクライアントのリストを指定します。
  # 設定可能な値: 有効なIPアドレスまたはCIDRブロックのリスト
  #   - "0.0.0.0/0": すべてのIPv4アドレスからのアクセスを許可（アクセス制限なし）
  #   - 個別のIPアドレス（例: "192.168.1.100"）
  #   - CIDRブロック（例: "10.0.0.0/16"）
  # 制約: 最小1項目、最大100項目
  # 注意: セキュリティのため、本番環境では"0.0.0.0/0"の使用は推奨されません。
  #       必要なクライアントIPアドレスのみを指定してください。
  # 参考: https://docs.aws.amazon.com/filegateway/latest/files3/edit-nfs-client.html
  client_list = ["0.0.0.0/0"]

  # gateway_arn (Required)
  # 設定内容: ファイルゲートウェイのAmazon Resource Name (ARN)を指定します。
  # 設定可能な値: 有効なStorage Gateway ARN
  # 注意: S3 File Gatewayが必要です。
  #       AWS STSがファイルゲートウェイのリージョンで有効化されている必要があります。
  # 参考: https://docs.aws.amazon.com/storagegateway/latest/APIReference/API_CreateNFSFileShare.html
  gateway_arn = "arn:aws:storagegateway:ap-northeast-1:123456789012:gateway/sgw-12345678"

  # location_arn (Required)
  # 設定内容: ファイルデータの保存に使用されるバックエンドストレージのARNを指定します。
  # 設定可能な値: Amazon S3バケットのARN
  # 形式: "arn:aws:s3:::bucket-name" または "arn:aws:s3:::bucket-name/prefix"
  # 注意: S3プレフィックス名を設定する場合、file_share_nameも設定する必要があります。
  # 参考: https://docs.aws.amazon.com/storagegateway/latest/APIReference/API_CreateNFSFileShare.html
  location_arn = "arn:aws:s3:::my-bucket"

  # role_arn (Required)
  # 設定内容: ファイルゲートウェイが基盤となるストレージにアクセスする際に引き受けるIAMロールのARNを指定します。
  # 設定可能な値: 有効なIAMロールARN
  # 必要な権限: S3バケットへの読み取り/書き込み権限
  # 参考: https://docs.aws.amazon.com/storagegateway/latest/APIReference/API_CreateNFSFileShare.html
  role_arn = "arn:aws:iam::123456789012:role/StorageGatewayRole"

  #-------------------------------------------------------------
  # ファイル共有設定
  #-------------------------------------------------------------

  # file_share_name (Optional)
  # 設定内容: ファイル共有の名前を指定します。
  # 設定可能な値: 文字列
  # 省略時: 自動的に生成されます
  # 注意: location_arnでS3プレフィックス名を設定する場合は、このパラメータを設定する必要があります。
  # 参考: https://docs.aws.amazon.com/storagegateway/latest/APIReference/API_CreateNFSFileShare.html
  file_share_name = "my-nfs-share"

  # default_storage_class (Optional)
  # 設定内容: ファイルゲートウェイがAmazon S3バケットに配置するオブジェクトのデフォルトストレージクラスを指定します。
  # 設定可能な値:
  #   - "S3_STANDARD" (デフォルト): 標準ストレージクラス
  #   - "S3_INTELLIGENT_TIERING": インテリジェント階層化ストレージクラス
  #   - "S3_STANDARD_IA": 標準低頻度アクセスストレージクラス
  #   - "S3_ONEZONE_IA": 1ゾーン低頻度アクセスストレージクラス
  #   - "S3_GLACIER_FLEXIBLE_RETRIEVAL": S3 Glacier Flexible Retrievalストレージクラス
  #   - "S3_GLACIER_DEEP_ARCHIVE": S3 Glacier Deep Archiveストレージクラス
  # 省略時: "S3_STANDARD"
  # 参考: https://docs.aws.amazon.com/storagegateway/latest/APIReference/API_CreateNFSFileShare.html#StorageGateway-CreateNFSFileShare-request-DefaultStorageClass
  default_storage_class = "S3_STANDARD"

  # read_only (Optional)
  # 設定内容: ファイル共有の書き込みステータスを指定します。
  # 設定可能な値:
  #   - true: ファイル共有は書き込みを受け付けません（読み取り専用）
  #   - false (デフォルト): ファイル共有は書き込みを受け付けます
  # 省略時: false
  # 参考: https://docs.aws.amazon.com/storagegateway/latest/APIReference/API_CreateNFSFileShare.html
  read_only = false

  # squash (Optional)
  # 設定内容: ユーザーを匿名ユーザーにマッピングする設定を指定します。
  # 設定可能な値:
  #   - "RootSquash" (デフォルト): rootユーザーのみが匿名ユーザーにマッピングされます
  #   - "NoSquash": 誰も匿名ユーザーにマッピングされません
  #   - "AllSquash": すべてのユーザーが匿名ユーザーにマッピングされます
  # 省略時: "RootSquash"
  # 参考: https://docs.aws.amazon.com/storagegateway/latest/APIReference/API_CreateNFSFileShare.html
  squash = "RootSquash"

  #-------------------------------------------------------------
  # S3設定
  #-------------------------------------------------------------

  # object_acl (Optional)
  # 設定内容: S3オブジェクトのアクセスコントロールリスト権限を指定します。
  # 設定可能な値:
  #   - "private" (デフォルト): オーナーのみがフルコントロール
  #   - "public-read": オーナーがフルコントロール、すべてのユーザーが読み取り可能
  #   - "public-read-write": オーナーがフルコントロール、すべてのユーザーが読み取り/書き込み可能
  #   - "authenticated-read": オーナーがフルコントロール、認証済みユーザーが読み取り可能
  #   - "bucket-owner-read": オブジェクトオーナーがフルコントロール、バケットオーナーが読み取り可能
  #   - "bucket-owner-full-control": オブジェクトオーナーとバケットオーナーの両方がフルコントロール
  #   - "aws-exec-read": オーナーがフルコントロール、EC2がS3からAMIバンドルを読み取り可能
  # 省略時: "private"
  # 参考: https://docs.aws.amazon.com/storagegateway/latest/APIReference/API_CreateNFSFileShare.html
  object_acl = "private"

  # guess_mime_type_enabled (Optional)
  # 設定内容: ファイル拡張子に基づいてアップロードされたオブジェクトのMIMEタイプを推測するかを指定します。
  # 設定可能な値:
  #   - true (デフォルト): MIMEタイプを推測する
  #   - false: MIMEタイプを推測しない
  # 省略時: true
  # 参考: https://docs.aws.amazon.com/storagegateway/latest/APIReference/API_CreateNFSFileShare.html
  guess_mime_type_enabled = true

  # requester_pays (Optional)
  # 設定内容: リクエストコストとAmazon S3バケットからのデータダウンロードコストを誰が支払うかを指定します。
  # 設定可能な値:
  #   - true: リクエスタ（ファイル共有を使用するユーザー）が支払う
  #   - false (デフォルト): バケットオーナーが支払う
  # 省略時: false
  # 参考: https://docs.aws.amazon.com/storagegateway/latest/APIReference/API_CreateNFSFileShare.html
  requester_pays = false

  #-------------------------------------------------------------
  # 暗号化設定
  #-------------------------------------------------------------

  # kms_encrypted (Optional)
  # 設定内容: 独自のAWS KMSキーを使用してAmazon S3サーバー側暗号化を使用するか、
  #          Amazon S3が管理するキーを使用するかを指定します。
  # 設定可能な値:
  #   - true: 独自のAWS KMSキーを使用
  #   - false (デフォルト): Amazon S3が管理するキーを使用
  # 省略時: false
  # 参考: https://docs.aws.amazon.com/storagegateway/latest/APIReference/API_CreateNFSFileShare.html
  kms_encrypted = false

  # kms_key_arn (Optional)
  # 設定内容: Amazon S3サーバー側暗号化に使用されるKMSキーのAmazon Resource Name (ARN)を指定します。
  # 設定可能な値: 有効なKMS Key ARN
  # 注意: この値は、kms_encryptedがtrueの場合のみ設定できます。
  # 参考: https://docs.aws.amazon.com/storagegateway/latest/APIReference/API_CreateNFSFileShare.html
  kms_key_arn = null

  #-------------------------------------------------------------
  # VPC設定
  #-------------------------------------------------------------

  # vpc_endpoint_dns_name (Optional)
  # 設定内容: S3 PrivateLink用のVPCエンドポイントのDNS名を指定します。
  # 設定可能な値: VPCエンドポイントのDNS名
  # 注意: この値を指定する場合、bucket_regionも設定する必要があります。
  # 関連機能: AWS PrivateLink for Amazon S3
  #   VPC内のリソースがインターネットゲートウェイやNATデバイスを経由せずに
  #   Amazon S3にアクセスできるようにします。
  #   - https://docs.aws.amazon.com/storagegateway/latest/APIReference/API_CreateNFSFileShare.html
  vpc_endpoint_dns_name = null

  # bucket_region (Optional)
  # 設定内容: ファイル共有で使用されるS3バケットのリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 注意: vpc_endpoint_dns_nameを指定する場合、このパラメータは必須です。
  # 参考: https://docs.aws.amazon.com/storagegateway/latest/APIReference/API_CreateNFSFileShare.html
  bucket_region = null

  #-------------------------------------------------------------
  # 監査設定
  #-------------------------------------------------------------

  # audit_destination_arn (Optional)
  # 設定内容: 監査ログの保存に使用されるストレージのAmazon Resource Name (ARN)を指定します。
  # 設定可能な値: CloudWatch Logs LogGroupのARNまたはS3バケットのARN
  # 省略時: 監査ログは保存されません
  # 参考: https://docs.aws.amazon.com/storagegateway/latest/APIReference/API_CreateNFSFileShare.html
  audit_destination_arn = null

  #-------------------------------------------------------------
  # 通知設定
  #-------------------------------------------------------------

  # notification_policy (Optional)
  # 設定内容: ファイル共有の通知ポリシーを指定します。
  # 設定可能な値: JSON形式の通知ポリシー文字列
  # 省略時: "{}" (通知なし)
  # 関連機能: File Upload Notification
  #   ファイルがS3バケットにアップロードされたときに通知を受け取ることができます。
  #   - https://docs.aws.amazon.com/storagegateway/latest/APIReference/API_CreateNFSFileShare.html#StorageGateway-CreateNFSFileShare-request-NotificationPolicy
  notification_policy = "{}"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  #   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  tags = {
    Name        = "my-nfs-file-share"
    Environment = "production"
  }

  #-------------------------------------------------------------
  # NFSファイル共有デフォルト設定
  #-------------------------------------------------------------

  # nfs_file_share_defaults (Optional)
  # 設定内容: ファイル共有のデフォルト値を含むネストされた引数を指定します。
  # 関連機能: NFS File Share Defaults
  #   S3バケット内のファイルとフォルダが検出されると、Storage Gatewayはデフォルトの
  #   Unix権限を割り当てます。これらのデフォルト値は変更可能です。
  #   - https://docs.aws.amazon.com/storagegateway/latest/APIReference/API_NFSFileShareDefaults.html
  nfs_file_share_defaults {
    # directory_mode (Optional)
    # 設定内容: ファイル共有内のすべてのディレクトリのデフォルトアクセスモードをUnix形式の文字列で指定します。
    # 設定可能な値: 4桁の8進数文字列（例: "0777", "0755"）
    # 省略時: "0777"
    # 参考: https://docs.aws.amazon.com/storagegateway/latest/APIReference/API_NFSFileShareDefaults.html
    directory_mode = "0777"

    # file_mode (Optional)
    # 設定内容: ファイル共有内のデフォルトファイルモードをUnix形式の文字列で指定します。
    # 設定可能な値: 4桁の8進数文字列（例: "0666", "0644"）
    # 省略時: "0666"
    # 参考: https://docs.aws.amazon.com/storagegateway/latest/APIReference/API_NFSFileShareDefaults.html
    file_mode = "0666"

    # group_id (Optional)
    # 設定内容: ファイル共有のデフォルトグループIDを指定します（ファイルに別のグループIDが指定されていない場合）。
    # 設定可能な値: 0～4294967294の整数
    # 省略時: 65534 (nfsnobody)
    # 参考: https://docs.aws.amazon.com/storagegateway/latest/APIReference/API_NFSFileShareDefaults.html
    group_id = "65534"

    # owner_id (Optional)
    # 設定内容: ファイル共有のデフォルトオーナーIDを指定します（ファイルに別のオーナーIDが指定されていない場合）。
    # 設定可能な値: 0～4294967294の整数
    # 省略時: 65534 (nfsnobody)
    # 参考: https://docs.aws.amazon.com/storagegateway/latest/APIReference/API_NFSFileShareDefaults.html
    owner_id = "65534"
  }

  #-------------------------------------------------------------
  # キャッシュ設定
  #-------------------------------------------------------------

  # cache_attributes (Optional)
  # 設定内容: キャッシュ情報のリフレッシュ設定を指定します。
  # 関連機能: Time To Live (TTL) Cache Refresh
  #   最後のリフレッシュからの経過時間を使用してファイル共有のキャッシュをリフレッシュします。
  #   TTLは、ディレクトリへのアクセスがファイルゲートウェイにそのディレクトリの内容を
  #   Amazon S3バケットから最初にリフレッシュさせる、最後のリフレッシュからの経過時間です。
  cache_attributes {
    # cache_stale_timeout_in_seconds (Optional)
    # 設定内容: Time To Live (TTL)を使用してファイル共有のキャッシュをリフレッシュする秒数を指定します。
    # 設定可能な値: 300～2592000秒（5分～30日）
    # 省略時: キャッシュの自動リフレッシュは無効
    # 参考: https://docs.aws.amazon.com/storagegateway/latest/APIReference/API_CacheAttributes.html
    cache_stale_timeout_in_seconds = 300
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト時間を指定します。
  timeouts {
    # create (Optional)
    # 設定内容: リソース作成時のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列（例: "10m", "1h"）
    # 省略時: デフォルトのタイムアウト時間
    create = "10m"

    # update (Optional)
    # 設定内容: リソース更新時のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列（例: "10m", "1h"）
    # 省略時: デフォルトのタイムアウト時間
    update = "10m"

    # delete (Optional)
    # 設定内容: リソース削除時のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列（例: "10m", "1h"）
    # 省略時: デフォルトのタイムアウト時間
    delete = "10m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: NFSファイル共有のAmazon Resource Name (ARN)
#
# - arn: NFSファイル共有のAmazon Resource Name (ARN)
#
# - fileshare_id: NFSファイル共有のID
#
# - path: NFSクライアントがマウントポイントを識別するために使用するファイル共有パス
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
