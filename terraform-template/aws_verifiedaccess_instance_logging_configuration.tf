#---------------------------------------------------------------
# AWS Verified Access Instance Logging Configuration
#---------------------------------------------------------------
#
# AWS Verified Access インスタンスのログ記録設定をプロビジョニングするリソースです。
# Verified Access は、すべてのアクセス試行を評価後にログに記録し、
# アプリケーションアクセスに対する集中的な可視性を提供します。
# ログはOpen Cybersecurity Schema Framework (OCSF) 形式に準拠しています。
#
# AWS公式ドキュメント:
#   - Verified Access logs: https://docs.aws.amazon.com/verified-access/latest/ug/access-logs.html
#   - Enable or disable Verified Access logs: https://docs.aws.amazon.com/verified-access/latest/ug/access-logs-enable.html
#   - VerifiedAccessLogOptions API: https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_VerifiedAccessLogOptions.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/verifiedaccess_instance_logging_configuration
#
# Provider Version: 6.28.0
# Generated: 2026-02-05
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_verifiedaccess_instance_logging_configuration" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # verifiedaccess_instance_id (Required, Forces new resource)
  # 設定内容: Verified Access インスタンスのIDを指定します。
  # 設定可能な値: 有効なVerified Access インスタンスID
  # 注意: この値を変更すると新しいリソースが作成されます（既存のリソースは削除されます）
  verifiedaccess_instance_id = "vai-0ce000c0b7643abea"

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # アクセスログ設定
  #-------------------------------------------------------------

  # access_logs (Required)
  # 設定内容: Verified Access インスタンスのログ記録設定オプションを指定します。
  # 注意: このブロックは必須です。少なくとも1つのログ配信先を設定する必要があります。
  access_logs {
    #-----------------------------------------------------------
    # ログバージョンと信頼コンテキスト
    #-----------------------------------------------------------

    # include_trust_context (Optional)
    # 設定内容: 信頼プロバイダーから送信された信頼データをログに含めるかを指定します。
    # 設定可能な値:
    #   - true: 信頼データをログに含める
    #   - false (デフォルト): 信頼データをログに含めない
    # 関連機能: Trust Context
    #   信頼プロバイダーからの信頼データにより、アクセス判断の根拠を詳細に記録可能。
    #   セキュリティ監査やコンプライアンス要件に有用。
    #   - https://docs.aws.amazon.com/verified-access/latest/ug/access-logs-enable.html
    include_trust_context = false

    # log_version (Optional)
    # 設定内容: 使用するログバージョンを指定します。
    # 設定可能な値:
    #   - "ocsf-0.1": 旧バージョンのOCSF形式
    #   - "ocsf-1.0.0-rc.2": 新バージョンのOCSF形式（推奨）
    # 省略時: デフォルトのログバージョンが使用されます
    # 関連機能: OCSF (Open Cybersecurity Schema Framework)
    #   標準化されたセキュリティログ形式。バージョンにより記録される情報が異なります。
    #   - https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_VerifiedAccessLogOptions.html
    log_version = "ocsf-1.0.0-rc.2"

    #-----------------------------------------------------------
    # CloudWatch Logs配信設定
    #-----------------------------------------------------------

    # cloudwatch_logs (Optional)
    # 設定内容: CloudWatch Logsへのログ配信設定を指定します。
    # 注意: 最大1つのcloudwatch_logsブロックを設定できます
    cloudwatch_logs {
      # enabled (Required)
      # 設定内容: CloudWatch Logsへのログ配信を有効にするかを指定します。
      # 設定可能な値:
      #   - true: ログ配信を有効化
      #   - false: ログ配信を無効化
      enabled = true

      # log_group (Optional)
      # 設定内容: CloudWatch Logsのロググループ名を指定します。
      # 設定可能な値: 有効なCloudWatch Logsロググループ名またはARN
      # 省略時: ログ配信は有効でもログは保存されません
      # 注意: ロググループは事前に作成されている必要があります
      # 参考: https://docs.aws.amazon.com/verified-access/latest/ug/access-logs-enable.html
      log_group = "my-log-group"
    }

    #-----------------------------------------------------------
    # Kinesis Data Firehose配信設定
    #-----------------------------------------------------------

    # kinesis_data_firehose (Optional)
    # 設定内容: Kinesis Data Firehoseへのログ配信設定を指定します。
    # 注意: 最大1つのkinesis_data_firehoseブロックを設定できます
    kinesis_data_firehose {
      # enabled (Required)
      # 設定内容: Kinesis Data Firehoseへのログ配信を有効にするかを指定します。
      # 設定可能な値:
      #   - true: ログ配信を有効化
      #   - false: ログ配信を無効化
      enabled = true

      # delivery_stream (Optional)
      # 設定内容: Kinesis Data Firehose配信ストリームの名前を指定します。
      # 設定可能な値: 有効なKinesis Data Firehose配信ストリーム名
      # 省略時: ログ配信は有効でもログは保存されません
      # 注意: 配信ストリームは事前に作成されている必要があります
      # 参考: https://docs.aws.amazon.com/verified-access/latest/ug/access-logs-enable.html
      delivery_stream = "my-delivery-stream"
    }

    #-----------------------------------------------------------
    # S3配信設定
    #-----------------------------------------------------------

    # s3 (Optional)
    # 設定内容: Amazon S3へのログ配信設定を指定します。
    # 注意: 最大1つのs3ブロックを設定できます
    s3 {
      # enabled (Required)
      # 設定内容: S3へのログ配信を有効にするかを指定します。
      # 設定可能な値:
      #   - true: ログ配信を有効化
      #   - false: ログ配信を無効化
      enabled = true

      # bucket_name (Optional)
      # 設定内容: S3バケットの名前を指定します。
      # 設定可能な値: 有効なS3バケット名
      # 省略時: ログ配信は有効でもログは保存されません
      # 注意: バケットは事前に作成されている必要があります
      # 参考: https://docs.aws.amazon.com/verified-access/latest/ug/access-logs-enable.html
      bucket_name = "my-verified-access-logs"

      # bucket_owner (Optional)
      # 設定内容: S3バケットを所有するAWSアカウントのIDを指定します。
      # 設定可能な値: 12桁のAWSアカウントID
      # 省略時: 現在のアカウントが所有者として使用されます
      # 用途: クロスアカウントのS3バケットにログを配信する場合に使用
      bucket_owner = null

      # prefix (Optional)
      # 設定内容: S3バケット内のログファイルのプレフィックス（パス）を指定します。
      # 設定可能な値: 有効なS3オブジェクトキープレフィックス
      # 省略時: ログはバケットのルートに保存されます
      # 用途: ログを整理したり、他のデータと分離するために使用
      prefix = "verified-access-logs/"
    }
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: リソースID（verifiedaccess_instance_idと同じ値）
#---------------------------------------------------------------
