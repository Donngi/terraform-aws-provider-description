#---------------------------------------------------------------
# AWS CloudWatch Log Anomaly Detector
#---------------------------------------------------------------
#
# Amazon CloudWatch Logsの異常検出器をプロビジョニングするリソースです。
# 異常検出器は、機械学習アルゴリズムを使用してロググループを定期的にスキャンし、
# ログイベントのパターンを特定し、通常とは異なる異常なイベントを検出します。
#
# AWS公式ドキュメント:
#   - Log anomaly detection: https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/LogsAnomalyDetection.html
#   - CreateLogAnomalyDetector API: https://docs.aws.amazon.com/AmazonCloudWatchLogs/latest/APIReference/API_CreateLogAnomalyDetector.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_anomaly_detector
#
# Provider Version: 6.28.0
# Generated: 2026-01-19
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_cloudwatch_log_anomaly_detector" "example" {
  #-------------------------------------------------------------
  # 必須設定
  #-------------------------------------------------------------

  # enabled (Required)
  # 設定内容: 異常検出器の有効/無効を指定します。
  # 設定可能な値:
  #   - true: 異常検出器を有効化し、ログイベントの監視を開始します
  #   - false: 異常検出器を無効化します
  # 注意: 作成後は約15分間のトレーニング期間が必要です。その後、異常の検出が開始されます。
  enabled = true

  # log_group_arn_list (Required)
  # 設定内容: 異常検出器が監視するロググループのARNのリストを指定します。
  # 設定可能な値: ロググループARNの配列
  # 注意: 現在、1つのロググループARNのみ指定可能です。
  # 形式: arn:aws:logs:<region>:<account-id>:log-group:<log-group-name>
  log_group_arn_list = [
    "arn:aws:logs:ap-northeast-1:123456789012:log-group:/aws/my-application/logs"
  ]

  #-------------------------------------------------------------
  # 名前設定
  #-------------------------------------------------------------

  # detector_name (Optional)
  # 設定内容: 異常検出器の名前を指定します。
  # 設定可能な値: 1文字以上の文字列
  # 用途: 異常検出器を識別するための名前。管理やフィルタリングに使用します。
  detector_name = "my-application-anomaly-detector"

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
  # 異常検出設定
  #-------------------------------------------------------------

  # anomaly_visibility_time (Optional)
  # 設定内容: 異常の可視性を維持する日数を指定します。
  # 設定可能な値: 7 から 90 の整数値
  # 省略時: デフォルト値が適用されます
  # 関連機能: 異常のベースライン化
  #   指定した期間が経過すると、異常は自動的にベースライン化され、
  #   同様のイベントは今後「正常」として扱われます。
  #   原因を修正しない場合、その異常は将来検出されなくなります。
  #   - https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/LogsAnomalyDetection.html
  anomaly_visibility_time = 7

  # evaluation_frequency (Optional)
  # 設定内容: 異常検出器の実行頻度を指定します。
  # 設定可能な値:
  #   - "ONE_MIN": 1分ごと
  #   - "FIVE_MIN": 5分ごと
  #   - "TEN_MIN": 10分ごと
  #   - "FIFTEEN_MIN": 15分ごと
  #   - "THIRTY_MIN": 30分ごと
  #   - "ONE_HOUR": 1時間ごと
  # 推奨: ロググループが新しいログを受信する頻度に合わせて設定します。
  #       例: 10分ごとに新しいログが来る場合は"FIFTEEN_MIN"が適切です。
  evaluation_frequency = "TEN_MIN"

  # filter_pattern (Optional)
  # 設定内容: 異常検出の対象となるログイベントをフィルタリングするパターンを指定します。
  # 設定可能な値: CloudWatch Logsフィルターパターン構文に準拠した文字列（最大1024文字）
  # 用途: 特定のパターンに一致するログイベントのみを異常検出の対象にします。
  # 関連機能: Filter and Pattern Syntax
  #   CloudWatch Logsのフィルターパターン構文を使用してログをフィルタリングします。
  #   - https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/FilterAndPatternSyntax.html
  filter_pattern = null

  #-------------------------------------------------------------
  # 暗号化設定
  #-------------------------------------------------------------

  # kms_key_id (Optional)
  # 設定内容: 異常検出器とその検出結果を暗号化するAWS KMSキーのARNを指定します。
  # 設定可能な値: 有効なKMSキーARN（最大256文字）
  # 形式: arn:aws:kms:<region>:<account-id>:key/<key-id>
  # 関連機能: KMSによる暗号化
  #   キーが割り当てられた場合、検出された異常と検出器が使用するモデルは
  #   KMSキーで暗号化されます。異常情報を取得するには、キーと検出器の
  #   両方に対する権限が必要です。
  #   - https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/LogsAnomalyDetection-KMS.html
  kms_key_id = null

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ（最大50エントリ）
  #   - キー: 1-128文字
  #   - 値: 最大256文字
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  #   - https://docs.aws.amazon.com/general/latest/gr/aws_tagging.html
  tags = {
    Name        = "my-application-anomaly-detector"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: 作成されたログ異常検出器のAmazon Resource Name (ARN)
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
