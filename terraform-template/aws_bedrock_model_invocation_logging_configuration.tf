#####################################################################################################
# Terraform Template: aws_bedrock_model_invocation_logging_configuration
#
# This template was generated on 2026-01-18
# AWS Provider Version: 6.28.0
#
# ⚠️ Note: This template reflects the resource schema at the time of generation.
#          Always refer to the official documentation for the latest specifications.
#####################################################################################################

#####################################################################################################
# Resource: aws_bedrock_model_invocation_logging_configuration
#
# Amazon Bedrockのモデル呼び出しログ設定を管理するリソース。
# リージョン単位でモデル呼び出しログを設定し、CloudWatch LogsまたはAmazon S3にログを配信できる。
#
# 重要な注意点:
# - モデル呼び出しログはAWSリージョンごとに設定される
# - 設定の上書きを避けるため、このリソースを複数の構成で定義しないこと
# - デフォルトではモデル呼び出しログは無効になっている
# - ログ設定を削除するまでログは保存され続ける
#
# 公式ドキュメント:
# - リソース: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/bedrock_model_invocation_logging_configuration
# - ユーザーガイド: https://docs.aws.amazon.com/bedrock/latest/userguide/model-invocation-logging.html
# - API: https://docs.aws.amazon.com/bedrock/latest/APIReference/API_PutModelInvocationLoggingConfiguration.html
#####################################################################################################

resource "aws_bedrock_model_invocation_logging_configuration" "example" {
  #####################################################################################################
  # region: (オプション) このリソースが管理されるAWSリージョン
  #
  # - 指定しない場合、プロバイダー設定のリージョンがデフォルトで使用される
  # - リージョンごとに独立したログ設定が必要
  # - 同じアカウント・リージョン内のログ配信先のみサポート
  #
  # 型: string
  # デフォルト: プロバイダー設定のリージョン
  # 公式ドキュメント: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  #####################################################################################################
  region = "us-east-1"

  #####################################################################################################
  # logging_config ブロック: モデル呼び出しログの設定
  #
  # モデル呼び出しのログ記録に関する設定を定義する。
  # 以下の操作のログを記録できる:
  # - Converse
  # - ConverseStream
  # - InvokeModel
  # - InvokeModelWithResponseStream
  #
  # ログ配信先としてCloudWatch Logs、Amazon S3、または両方を指定可能。
  # モダリティ（テキスト、画像、埋め込み、動画）ごとにログ配信を制御できる。
  #####################################################################################################
  logging_config {
    #####################################################################################################
    # embedding_data_delivery_enabled: (オプション) 埋め込みデータのログ配信を有効化
    #
    # - trueに設定すると、埋め込みモデルの入出力データがログに含まれる
    # - 埋め込みモダリティをサポートする全モデルのログが記録される
    # - デフォルトはtrue
    #
    # 型: bool
    # デフォルト: true
    #####################################################################################################
    embedding_data_delivery_enabled = true

    #####################################################################################################
    # image_data_delivery_enabled: (オプション) 画像データのログ配信を有効化
    #
    # - trueに設定すると、画像入力または画像出力を含むモデル呼び出しのログが記録される
    # - Converse APIで渡される画像やドキュメントデータは、Amazon S3配信とこの設定が有効な場合にログ記録される
    # - バイナリ画像出力はAmazon S3のみサポート
    # - デフォルトはtrue
    #
    # 型: bool
    # デフォルト: true
    #####################################################################################################
    image_data_delivery_enabled = true

    #####################################################################################################
    # text_data_delivery_enabled: (オプション) テキストデータのログ配信を有効化
    #
    # - trueに設定すると、テキスト入出力を含むモデル呼び出しのログが記録される
    # - テキストモダリティをサポートする全モデルのログが記録される
    # - デフォルトはtrue
    #
    # 型: bool
    # デフォルト: true
    #####################################################################################################
    text_data_delivery_enabled = true

    #####################################################################################################
    # video_data_delivery_enabled: (オプション) 動画データのログ配信を有効化
    #
    # - trueに設定すると、動画入力または動画出力を含むモデル呼び出しのログが記録される
    # - 動画モダリティをサポートする全モデルのログが記録される
    # - デフォルトはtrue
    #
    # 型: bool
    # デフォルト: true
    #####################################################################################################
    video_data_delivery_enabled = true

    #####################################################################################################
    # cloudwatch_config ブロック: (オプション) CloudWatch Logsログ配信設定
    #
    # CloudWatch Logsにログを配信する場合の設定。
    # JSONフォーマットの呼び出しログイベントがCloudWatch Logsに配信される。
    # ログイベントには以下が含まれる:
    # - 呼び出しメタデータ
    # - 最大100KBまでの入出力JSONボディ
    # - 100KBを超えるデータやバイナリデータは、large_data_delivery_s3_configで指定したS3に配信
    #
    # CloudWatch Logs Insightsでクエリ可能で、リアルタイムで他サービスにストリーミング可能。
    #####################################################################################################
    cloudwatch_config {
      #####################################################################################################
      # log_group_name: (必須) ログが配信されるCloudWatch Logsロググループ名
      #
      # - ログが配信されるCloudWatch Logsのロググループを指定
      # - 事前にロググループを作成しておく必要がある
      # - 同じリージョンのロググループのみ指定可能
      #
      # 型: string
      #####################################################################################################
      log_group_name = "/aws/bedrock/modelinvocations"

      #####################################################################################################
      # role_arn: (必須) CloudWatch Logsにログを書き込むために使用するIAMロールのARN
      #
      # IAMロールには以下の権限が必要:
      # 信頼ポリシー:
      # - Principal: bedrock.amazonaws.com
      # - Action: sts:AssumeRole
      # - Condition: aws:SourceAccount と aws:SourceArn で制限
      #
      # ロールポリシー:
      # - logs:CreateLogStream
      # - logs:PutLogEvents
      # - Resource: 対象ログストリームのARN
      #
      # 型: string
      # 公式ドキュメント: https://docs.aws.amazon.com/bedrock/latest/userguide/model-invocation-logging.html#setup-cloudwatch-logs-destination
      #####################################################################################################
      role_arn = "arn:aws:iam::123456789012:role/BedrockLoggingRole"

      #####################################################################################################
      # large_data_delivery_s3_config ブロック: (オプション) 大容量データ配信用のS3設定
      #
      # CloudWatch Logsログ配信時に、100KBを超えるJSONボディやバイナリデータを
      # Amazon S3に配信するための設定。
      # この設定を行わない場合、100KBを超えるデータは切り捨てられる。
      #####################################################################################################
      large_data_delivery_s3_config {
        #####################################################################################################
        # bucket_name: (必須) 大容量データが配信されるS3バケット名
        #
        # - 同じリージョンのS3バケットを指定する必要がある
        # - バケットにはBedrock用のバケットポリシーが必要
        # - バケットACLは無効化する必要がある
        #
        # バケットポリシー例:
        # {
        #   "Effect": "Allow",
        #   "Principal": {"Service": "bedrock.amazonaws.com"},
        #   "Action": ["s3:PutObject"],
        #   "Resource": ["arn:aws:s3:::bucket-name/prefix/AWSLogs/*/BedrockModelInvocationLogs/*"],
        #   "Condition": {
        #     "StringEquals": {"aws:SourceAccount": "account-id"},
        #     "ArnLike": {"aws:SourceArn": "arn:aws:bedrock:region:account-id:*"}
        #   }
        # }
        #
        # 型: string
        # 公式ドキュメント: https://docs.aws.amazon.com/bedrock/latest/userguide/model-invocation-logging.html#setup-s3-destination
        #####################################################################################################
        bucket_name = "my-bedrock-large-data-logs"

        #####################################################################################################
        # key_prefix: (オプション) S3オブジェクトキーのプレフィックス
        #
        # - S3バケット内でログを整理するためのプレフィックスを指定
        # - 指定しない場合、バケットのルートに配信される
        # - 実際のログは {prefix}/AWSLogs/{account-id}/BedrockModelInvocationLogs/ 配下に配信される
        #
        # 型: string
        #####################################################################################################
        key_prefix = "large-data"
      }
    }

    #####################################################################################################
    # s3_config ブロック: (オプション) Amazon S3ログ配信設定
    #
    # Amazon S3にログを配信する場合の設定。
    # Gzip圧縮されたJSONファイルとして、呼び出しログのバッチがS3バケットに配信される。
    # 各レコードには以下が含まれる:
    # - 呼び出しメタデータ
    # - 最大100KBまでの入出力JSONボディ
    # - 100KBを超えるバイナリデータやJSONボディは個別のS3オブジェクトとして配信
    #
    # S3 SelectやAmazon Athenaでクエリ可能。
    # AWS Glueでカタログ化してETL処理が可能。
    # EventBridgeターゲットで処理することも可能。
    #####################################################################################################
    s3_config {
      #####################################################################################################
      # bucket_name: (必須) ログが配信されるS3バケット名
      #
      # - 同じリージョンのS3バケットを指定する必要がある
      # - バケットにはBedrock用のバケットポリシーが必要
      # - バケットACLは無効化する必要がある
      #
      # バケットポリシー例:
      # {
      #   "Sid": "AmazonBedrockLogsWrite",
      #   "Effect": "Allow",
      #   "Principal": {"Service": "bedrock.amazonaws.com"},
      #   "Action": ["s3:PutObject"],
      #   "Resource": ["arn:aws:s3:::bucket-name/prefix/AWSLogs/*/BedrockModelInvocationLogs/*"],
      #   "Condition": {
      #     "StringEquals": {"aws:SourceAccount": "account-id"},
      #     "ArnLike": {"aws:SourceArn": "arn:aws:bedrock:region:account-id:*"}
      #   }
      # }
      #
      # SSE-KMS暗号化を使用する場合は、KMSキーポリシーも必要。
      #
      # 型: string
      # 公式ドキュメント: https://docs.aws.amazon.com/bedrock/latest/userguide/model-invocation-logging.html#setup-s3-destination
      #####################################################################################################
      bucket_name = "my-bedrock-model-logs"

      #####################################################################################################
      # key_prefix: (オプション) S3オブジェクトキーのプレフィックス
      #
      # - S3バケット内でログを整理するためのプレフィックスを指定
      # - 指定しない場合、バケットのルートに配信される
      # - 実際のログは {prefix}/AWSLogs/{account-id}/BedrockModelInvocationLogs/ 配下に配信される
      #
      # 型: string
      #####################################################################################################
      key_prefix = "bedrock"
    }
  }
}

#####################################################################################################
# 使用例: S3のみにログを配信
#####################################################################################################
# resource "aws_bedrock_model_invocation_logging_configuration" "s3_only" {
#   logging_config {
#     text_data_delivery_enabled      = true
#     image_data_delivery_enabled     = true
#     embedding_data_delivery_enabled = true
#     video_data_delivery_enabled     = true
#
#     s3_config {
#       bucket_name = aws_s3_bucket.bedrock_logs.id
#       key_prefix  = "model-invocations"
#     }
#   }
# }

#####################################################################################################
# 使用例: CloudWatch Logsのみにログを配信
#####################################################################################################
# resource "aws_bedrock_model_invocation_logging_configuration" "cloudwatch_only" {
#   logging_config {
#     text_data_delivery_enabled = true
#
#     cloudwatch_config {
#       log_group_name = aws_cloudwatch_log_group.bedrock.name
#       role_arn       = aws_iam_role.bedrock_logging.arn
#     }
#   }
# }

#####################################################################################################
# 使用例: 両方の配信先を使用（CloudWatchとS3）
#####################################################################################################
# resource "aws_bedrock_model_invocation_logging_configuration" "both" {
#   logging_config {
#     text_data_delivery_enabled      = true
#     image_data_delivery_enabled     = true
#     embedding_data_delivery_enabled = true
#     video_data_delivery_enabled     = true
#
#     cloudwatch_config {
#       log_group_name = aws_cloudwatch_log_group.bedrock.name
#       role_arn       = aws_iam_role.bedrock_logging.arn
#
#       # 大容量データはS3に配信
#       large_data_delivery_s3_config {
#         bucket_name = aws_s3_bucket.bedrock_large_data.id
#         key_prefix  = "large-data"
#       }
#     }
#
#     s3_config {
#       bucket_name = aws_s3_bucket.bedrock_logs.id
#       key_prefix  = "all-logs"
#     }
#   }
# }

#####################################################################################################
# Computed Attributes (読み取り専用):
#
# - id: ログが設定されているAWSリージョン
#   注: この属性は非推奨（deprecated）となっている
#####################################################################################################
