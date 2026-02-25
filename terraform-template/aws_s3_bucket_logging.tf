#---------------------------------------------------------------
# AWS S3 Bucket Logging
#---------------------------------------------------------------
#
# Amazon S3バケットのサーバーアクセスログ設定をプロビジョニングするリソースです。
# サーバーアクセスログは、バケットに対するリクエストの詳細なレコードを提供し、
# セキュリティ監査、アクセス解析、コスト把握に活用できます。
#
# 注意: このリソースはS3ディレクトリバケットには使用できません。
#
# AWS公式ドキュメント:
#   - サーバーアクセスログの概要: https://docs.aws.amazon.com/AmazonS3/latest/userguide/ServerLogs.html
#   - サーバーアクセスログの有効化: https://docs.aws.amazon.com/AmazonS3/latest/userguide/enable-server-access-logging.html
#   - S3のロギングオプション: https://docs.aws.amazon.com/AmazonS3/latest/userguide/logging-with-S3.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/s3_bucket_logging
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_s3_bucket_logging" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # bucket (Required, Forces new resource)
  # 設定内容: サーバーアクセスログを有効にするバケットの名前を指定します。
  # 設定可能な値: 有効なS3バケット名
  bucket = "example-source-bucket"

  # target_bucket (Required)
  # 設定内容: Amazon S3がサーバーアクセスログを保存するバケットの名前を指定します。
  # 設定可能な値: 有効なS3バケット名
  # 注意: ターゲットバケットはソースバケットと同じAWSリージョンおよびアカウントに属している必要があります。
  #       バケットオーナー強制型オブジェクト所有権設定のバケットをターゲットとする場合、
  #       target_grantブロックは使用できません。
  target_bucket = "example-logging-bucket"

  # target_prefix (Required)
  # 設定内容: すべてのログオブジェクトキーに付与するプレフィックスを指定します。
  # 設定可能な値: 任意の文字列（例: "log/", "access-logs/"）
  # 省略時: 空文字列（プレフィックスなし）は不可。必ず指定が必要です。
  target_prefix = "log/"

  #-------------------------------------------------------------
  # アカウント設定
  #-------------------------------------------------------------

  # expected_bucket_owner (Optional, Forces new resource, Deprecated)
  # 設定内容: バケットの所有者として期待されるAWSアカウントIDを指定します。
  # 設定可能な値: 有効な12桁のAWSアカウントID
  # 省略時: 検証は行われません。
  # 注意: この引数は非推奨（Deprecated）です。
  expected_bucket_owner = null

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用します。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # ログアクセス許可設定
  #-------------------------------------------------------------

  # target_grant (Optional)
  # 設定内容: ログへのアクセス権限を付与するための設定ブロックです。複数指定可能です。
  # 注意: ターゲットバケットがバケットオーナー強制型オブジェクト所有権設定を使用している場合、
  #       このブロックは使用できません。代わりにバケットポリシーで権限を付与してください。
  target_grant {
    #-------------------------------------------------------------
    # 付与権限設定
    #-------------------------------------------------------------

    # permission (Required)
    # 設定内容: バケットのロギングに割り当てる権限を指定します。
    # 設定可能な値:
    #   - "FULL_CONTROL": ログオブジェクトへの完全な制御権限
    #   - "READ": ログオブジェクトの読み取り権限
    #   - "WRITE": ログオブジェクトの書き込み権限
    permission = "FULL_CONTROL"

    # grantee (Required)
    # 設定内容: 権限を付与する対象者の設定ブロックです。
    grantee {
      #-------------------------------------------------------------
      # 付与対象者設定
      #-------------------------------------------------------------

      # type (Required)
      # 設定内容: 権限付与対象者の種別を指定します。
      # 設定可能な値:
      #   - "CanonicalUser": 正規ユーザーID（個人のAWSアカウント）
      #   - "AmazonCustomerByEmail": メールアドレスによるAWSカスタマー
      #   - "Group": AmazonS3定義のグループ（URIで指定）
      type = "CanonicalUser"

      # id (Optional)
      # 設定内容: 付与対象者の正規ユーザーIDを指定します。
      # 設定可能な値: 有効な正規ユーザーID（64文字の16進数文字列）
      # 省略時: typeが"CanonicalUser"の場合に使用します。
      id = "canonical-user-id-here"

      # email_address (Optional)
      # 設定内容: 付与対象者のメールアドレスを指定します。
      # 設定可能な値: 有効なメールアドレス
      # 省略時: typeが"AmazonCustomerByEmail"の場合に使用します。
      # 注意: メールアドレスによるACLはAWSにて2025年10月1日をもってサポートが廃止されました。
      #       対応しているAWSリージョンに制限があります。
      email_address = null

      # uri (Optional)
      # 設定内容: 付与対象グループのURIを指定します。
      # 設定可能な値:
      #   - "http://acs.amazonaws.com/groups/global/AuthenticatedUsers": 認証済みAWSユーザー全員
      #   - "http://acs.amazonaws.com/groups/global/AllUsers": すべてのユーザー（匿名含む）
      #   - "http://acs.amazonaws.com/groups/s3/LogDelivery": S3ログ配信グループ
      # 省略時: typeが"Group"の場合に使用します。
      uri = null
    }
  }

  #-------------------------------------------------------------
  # ログオブジェクトキーフォーマット設定
  #-------------------------------------------------------------

  # target_object_key_format (Optional)
  # 設定内容: ログオブジェクトのS3キーフォーマットを設定するブロックです。
  # 省略時: simple_prefixフォーマット（デフォルト）が使用されます。
  # 関連機能: S3サーバーアクセスログのキーフォーマット
  #   ログオブジェクトのキー形式をパーティション分割形式またはシンプル形式から選択できます。
  #   パーティション分割形式はログの検索・分析に適しています。
  #   - https://docs.aws.amazon.com/AmazonS3/latest/userguide/ServerLogs.html
  target_object_key_format {
    #-------------------------------------------------------------
    # パーティション分割プレフィックス設定
    #-------------------------------------------------------------

    # partitioned_prefix (Optional)
    # 設定内容: ログオブジェクトのS3キーをパーティション形式にするための設定ブロックです。
    # 設定内容: キー形式は [target_prefix][SourceAccountId]/[SourceRegion]/[SourceBucket]/[YYYY]/[MM]/[DD]/[YYYY]-[MM]-[DD]-[hh]-[mm]-[ss]-[UniqueString]
    # 注意: simple_prefixと同時に指定することはできません。
    partitioned_prefix {
      # partition_date_source (Required)
      # 設定内容: パーティション分割プレフィックスの日付ソースを指定します。
      # 設定可能な値:
      #   - "EventTime": リクエストが発生した時刻を基準にパーティションを作成
      #   - "DeliveryTime": ログが配信された時刻を基準にパーティションを作成
      partition_date_source = "EventTime"
    }

    #-------------------------------------------------------------
    # シンプルプレフィックス設定
    #-------------------------------------------------------------

    # simple_prefix (Optional)
    # 設定内容: ログオブジェクトのS3キーをシンプル形式にするための設定ブロックです。
    # 設定内容: キー形式は [target_prefix][YYYY]-[MM]-[DD]-[hh]-[mm]-[ss]-[UniqueString]
    # 省略時: target_object_key_formatブロックを省略した場合のデフォルト動作と同等です。
    # 注意: partitioned_prefixと同時に指定することはできません。使用する場合は simple_prefix {} と空ブロックで記述します。
    # simple_prefix {}
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: バケット名。expected_bucket_ownerが指定されている場合は
#        bucket,expected_bucket_owner をカンマ区切りで結合した値。
#---------------------------------------------------------------
