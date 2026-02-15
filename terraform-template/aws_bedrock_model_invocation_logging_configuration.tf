#---------------------------------------
# AWS Bedrock モデル呼び出しログ設定
#---------------------------------------
# Amazon Bedrockのモデル呼び出しログ設定を管理します。
# モデル呼び出しログはAWSリージョン単位で設定されます。
# 設定の上書きを避けるため、このリソースは複数の構成で定義しないでください。
#
# ユースケース:
# - モデル呼び出しの監視とトラブルシューティング
# - モデル入力/出力データの長期保存
# - コンプライアンスおよび監査要件への対応
# - モデル使用パターンの分析
#
# 関連リソース:
# - aws_s3_bucket: ログデータの保存先バケット
# - aws_cloudwatch_log_group: CloudWatch Logsへのログ配信
# - aws_iam_role: CloudWatch Logs配信用のIAMロール
#
# Provider Version: 6.28.0
# Generated: 2026-02-11
# Terraform Registry: https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/bedrock_model_invocation_logging_configuration
# NOTE: モデル呼び出しログはリージョン単位で設定されるため、複数の構成で定義しないでください
#
# 参考: https://docs.aws.amazon.com/bedrock/latest/userguide/model-invocation-logging.html

resource "aws_bedrock_model_invocation_logging_configuration" "example" {

  #---------------------------------------
  # リージョン設定
  #---------------------------------------

  region = "us-east-1"
  # 設定内容: このリソースを管理するAWSリージョン
  # 省略時: プロバイダー設定で指定されたリージョンが使用されます

  #---------------------------------------
  # ログ設定
  #---------------------------------------

  logging_config {
    #---------------------------------------
    # データ配信設定
    #---------------------------------------

    embedding_data_delivery_enabled = true
    # 設定内容: 埋め込みデータをログ配信に含めるかどうか
    # 設定可能な値: true / false
    # 省略時: true

    image_data_delivery_enabled = true
    # 設定内容: 画像データをログ配信に含めるかどうか
    # 設定可能な値: true / false
    # 省略時: true

    text_data_delivery_enabled = true
    # 設定内容: テキストデータをログ配信に含めるかどうか
    # 設定可能な値: true / false
    # 省略時: true

    video_data_delivery_enabled = true
    # 設定内容: ビデオデータをログ配信に含めるかどうか
    # 設定可能な値: true / false
    # 省略時: true

    #---------------------------------------
    # S3設定
    #---------------------------------------

    s3_config {
      bucket_name = "example-bedrock-logs"
      # 設定内容: ログを保存するS3バケット名
      # 注意: バケットはログ設定と同じリージョンに存在する必要があります
      # 注意: Amazon Bedrockがオブジェクトを配置できるようバケットポリシーが必要です

      key_prefix = "bedrock"
      # 設定内容: S3バケット内のキープレフィックス
      # 省略時: プレフィックスなしでログが保存されます
    }

    #---------------------------------------
    # CloudWatch Logs設定
    #---------------------------------------

    # cloudwatch_config {
    #   log_group_name = "/aws/bedrock/modelinvocations"
    #   # 設定内容: CloudWatch Logsのロググループ名
    #
    #   role_arn = "arn:aws:iam::123456789012:role/BedrockLoggingRole"
    #   # 設定内容: CloudWatch Logsへの書き込み権限を持つIAMロールのARN
    #   # 必要な権限:
    #   # - logs:CreateLogStream
    #   # - logs:PutLogEvents
    #
    #   #---------------------------------------
    #   # 大容量データのS3配信設定
    #   #---------------------------------------
    #
    #   # large_data_delivery_s3_config {
    #   #   bucket_name = "example-bedrock-large-logs"
    #   #   # 設定内容: 大容量データを保存するS3バケット名
    #   #
    #   #   key_prefix = "large-data"
    #   #   # 設定内容: S3バケット内のキープレフィックス
    #   #   # 省略時: プレフィックスなしでデータが保存されます
    #   # }
    # }
  }
}

#---------------------------------------
# Attributes Reference
#---------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id
#   ログが設定されているAWSリージョン
