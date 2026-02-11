#---------------------------------------------------------------
# AWS Storage Gateway SMB File Share
#---------------------------------------------------------------
#
# AWS Storage Gateway上にSMB (Server Message Block) ファイル共有を
# プロビジョニングするリソースです。SMBファイル共有は、Amazon S3バケットを
# バックエンドストレージとして使用し、SMBプロトコル経由でファイルアクセスを
# 提供します。Active Directory認証またはゲストアクセス認証をサポートします。
#
# AWS公式ドキュメント:
#   - SMBファイル共有の作成: https://docs.aws.amazon.com/filegateway/latest/files3/CreatingAnSMBFileShare.html
#   - SMBファイル共有の設定編集: https://docs.aws.amazon.com/filegateway/latest/files3/edit-smbfileshare-settings.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/storagegateway_smb_file_share
#
# Provider Version: 6.28.0
# Generated: 2026-02-09
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_storagegateway_smb_file_share" "example" {
  #-------------------------------------------------------------
  # 基本設定（必須）
  #-------------------------------------------------------------

  # gateway_arn (Required)
  # 設定内容: ファイルゲートウェイのAmazon Resource Name (ARN) を指定します。
  # 設定可能な値: 有効なStorage Gateway ARN
  gateway_arn = "arn:aws:storagegateway:ap-northeast-1:123456789012:gateway/sgw-12345678"

  # location_arn (Required)
  # 設定内容: ファイルデータの保存に使用するバックエンドストレージ（S3バケット）のARNを指定します。
  # 設定可能な値: 有効なS3バケットARNまたはS3アクセスポイントARN
  location_arn = "arn:aws:s3:::my-file-share-bucket"

  # role_arn (Required)
  # 設定内容: ファイルゲートウェイがバックエンドストレージにアクセスする際に使用するIAMロールのARNを指定します。
  # 設定可能な値: 有効なIAMロールARN
  role_arn = "arn:aws:iam::123456789012:role/StorageGatewayRole"

  #-------------------------------------------------------------
  # 認証設定
  #-------------------------------------------------------------

  # authentication (Optional)
  # 設定内容: ユーザーがファイル共有にアクセスする際の認証方法を指定します。
  # 設定可能な値:
  #   - "ActiveDirectory" (デフォルト): Active Directoryによる認証
  #   - "GuestAccess": ゲストアクセスによる認証
  authentication = "ActiveDirectory"

  # admin_user_list (Optional)
  # 設定内容: ファイル共有に管理者アクセス権を持つActive Directoryユーザーのリストを指定します。
  # 設定可能な値: Active Directoryユーザー名の文字列セット
  # 注意: authenticationが"ActiveDirectory"の場合のみ有効
  admin_user_list = []

  # valid_user_list (Optional)
  # 設定内容: ファイル共有へのアクセスを許可するActive Directoryユーザーのリストを指定します。
  # 設定可能な値: Active Directoryユーザー名の文字列セット
  # 注意: authenticationが"ActiveDirectory"の場合のみ有効。
  #        グループを指定する場合はグループ名の前に"@"を付加します（AWSコンソールのAllowed groupに設定されます）。
  valid_user_list = []

  # invalid_user_list (Optional)
  # 設定内容: ファイル共有へのアクセスを拒否するActive Directoryユーザーのリストを指定します。
  # 設定可能な値: Active Directoryユーザー名の文字列セット
  # 注意: authenticationが"ActiveDirectory"の場合のみ有効
  invalid_user_list = []

  # smb_acl_enabled (Optional)
  # 設定内容: SMBファイル共有でACL（アクセス制御リスト）を有効にするかを指定します。
  # 設定可能な値:
  #   - true: ACLを有効化
  #   - false: ファイルおよびディレクトリのパーミッションをPOSIXパーミッションにマッピング
  # 注意: ActiveDirectory認証タイプにのみ適用されます
  smb_acl_enabled = null

  #-------------------------------------------------------------
  # ファイル共有設定
  #-------------------------------------------------------------

  # file_share_name (Optional)
  # 設定内容: ファイル共有の名前を指定します。
  # 設定可能な値: 文字列
  # 省略時: 自動生成されます
  # 注意: location_arnにS3プレフィックス名が設定されている場合は必須です
  file_share_name = null

  # access_based_enumeration (Optional)
  # 設定内容: 読み取りアクセス権を持つユーザーにのみファイルとフォルダーを表示するかを指定します。
  # 設定可能な値:
  #   - true: 読み取りアクセス権を持つユーザーにのみ表示
  #   - false (デフォルト): すべてのユーザーに表示
  access_based_enumeration = false

  # read_only (Optional)
  # 設定内容: ファイル共有を読み取り専用にするかを指定します。
  # 設定可能な値:
  #   - true: ファイル共有は書き込みを受け付けません
  #   - false (デフォルト): 書き込みを許可
  read_only = false

  # requester_pays (Optional)
  # 設定内容: S3バケットからのリクエストおよびデータダウンロードのコストをリクエスター負担にするかを指定します。
  # 設定可能な値:
  #   - true: リクエスターがコストを負担
  #   - false (デフォルト): バケットオーナーがコストを負担
  requester_pays = false

  # guess_mime_type_enabled (Optional)
  # 設定内容: ファイル拡張子に基づいてアップロードされたオブジェクトのMIMEタイプを推測するかを指定します。
  # 設定可能な値:
  #   - true (デフォルト): MIMEタイプ推測を有効化
  #   - false: MIMEタイプ推測を無効化
  guess_mime_type_enabled = true

  # oplocks_enabled (Optional)
  # 設定内容: Opportunistic lock (oplock) を有効にするかを指定します。
  # 設定可能な値:
  #   - true (デフォルト): oplockを有効化
  #   - false: oplockを無効化
  # 関連機能: Opportunistic Locking
  #   SMBクライアントがローカルにファイルをキャッシュし、パフォーマンスを向上させる機能。
  oplocks_enabled = true

  # case_sensitivity (Optional)
  # 設定内容: S3バケット内のオブジェクト名の大文字小文字の扱いを指定します。
  # 設定可能な値:
  #   - "ClientSpecified" (デフォルト): クライアントが大文字小文字の区別を決定
  #   - "CaseSensitive": ゲートウェイが大文字小文字の区別を決定
  case_sensitivity = "ClientSpecified"

  # notification_policy (Optional)
  # 設定内容: ファイル共有の通知ポリシーを指定します。
  # 設定可能な値: JSON形式の文字列
  # 省略時: "{}" (通知なし)
  # 参考: https://docs.aws.amazon.com/storagegateway/latest/APIReference/API_CreateNFSFileShare.html#StorageGateway-CreateNFSFileShare-request-NotificationPolicy
  notification_policy = null

  #-------------------------------------------------------------
  # ストレージ設定
  #-------------------------------------------------------------

  # default_storage_class (Optional)
  # 設定内容: ファイルゲートウェイによってS3バケットに格納されるオブジェクトのデフォルトストレージクラスを指定します。
  # 設定可能な値:
  #   - "S3_STANDARD" (デフォルト): 標準ストレージ
  #   - "S3_STANDARD_IA": 低頻度アクセスストレージ
  #   - "S3_ONEZONE_IA": 単一AZ低頻度アクセスストレージ
  #   - "S3_INTELLIGENT_TIERING": インテリジェント階層化ストレージ
  # 参考: https://docs.aws.amazon.com/storagegateway/latest/APIReference/API_CreateNFSFileShare.html#StorageGateway-CreateNFSFileShare-request-DefaultStorageClass
  default_storage_class = "S3_STANDARD"

  # object_acl (Optional)
  # 設定内容: S3オブジェクトのアクセス制御リスト（ACL）パーミッションを指定します。
  # 設定可能な値: S3の既定ACL値（例: "private", "public-read", "aws-exec-read", "bucket-owner-read", "bucket-owner-full-control"）
  # 省略時: "private"
  object_acl = "private"

  #-------------------------------------------------------------
  # ネットワーク設定
  #-------------------------------------------------------------

  # vpc_endpoint_dns_name (Optional)
  # 設定内容: S3プライベートリンク用のVPCエンドポイントのDNS名を指定します。
  # 設定可能な値: 有効なVPCエンドポイントDNS名
  vpc_endpoint_dns_name = null

  # bucket_region (Optional)
  # 設定内容: ファイル共有で使用するS3バケットのリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 注意: vpc_endpoint_dns_nameを指定する場合は必須です
  bucket_region = null

  #-------------------------------------------------------------
  # 暗号化設定
  #-------------------------------------------------------------

  # kms_encrypted (Optional)
  # 設定内容: Amazon S3サーバーサイド暗号化に独自のAWS KMSキーを使用するかを指定します。
  # 設定可能な値:
  #   - true: 独自のKMSキーで暗号化
  #   - false (デフォルト): Amazon S3マネージドキーで暗号化
  kms_encrypted = false

  # kms_key_arn (Optional)
  # 設定内容: S3サーバーサイド暗号化に使用するKMSキーのARNを指定します。
  # 設定可能な値: 有効なKMSキーARN
  # 注意: kms_encryptedがtrueの場合のみ設定可能です
  kms_key_arn = null

  #-------------------------------------------------------------
  # 監査設定
  #-------------------------------------------------------------

  # audit_destination_arn (Optional)
  # 設定内容: 監査ログの送信先となるCloudWatch Log GroupのARNを指定します。
  # 設定可能な値: 有効なCloudWatch Log Group ARN
  audit_destination_arn = null

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
  # キャッシュ設定
  #-------------------------------------------------------------

  # cache_attributes (Optional)
  # 設定内容: キャッシュの更新設定を指定します。
  # 注意: 一度設定した後に削除しても、以前の値がリセットされずに残ります。
  #        変更するには明示的に新しい値を設定する必要があります。
  cache_attributes {
    # cache_stale_timeout_in_seconds (Optional)
    # 設定内容: TTL (Time To Live) を使用してファイル共有のキャッシュを更新する間隔を秒単位で指定します。
    #           最後の更新からこの時間が経過すると、ディレクトリへのアクセス時にS3バケットから内容を再取得します。
    # 設定可能な値: 300 ～ 2,592,000（5分 ～ 30日）
    cache_stale_timeout_in_seconds = null
  }

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "my-smb-file-share"
    Environment = "production"
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  timeouts {
    # create (Optional)
    # 設定内容: リソース作成時のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列（例: "10m", "1h"）
    create = null

    # update (Optional)
    # 設定内容: リソース更新時のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列（例: "10m", "1h"）
    update = null

    # delete (Optional)
    # 設定内容: リソース削除時のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列（例: "10m", "1h"）
    delete = null
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: SMBファイル共有のAmazon Resource Name (ARN)
#
# - fileshare_id: SMBファイル共有のID
#
# - path: NFSクライアントがマウントポイントを識別するために使用する
#          ファイル共有パス
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
