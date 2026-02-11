#---------------------------------------------------------------
# AWS IoT Logging Options
#---------------------------------------------------------------
#
# AWS IoT Coreのデフォルトロギングオプションを管理するリソースです。
# AWS IoT CoreがCloudWatch Logsにログを書き込むための設定を行います。
# アカウントレベルでのデフォルトログレベルを設定し、全てのIoTリソースに
# 適用されます（リソース固有のオーバーライドがない場合）。
#
# AWS公式ドキュメント:
#   - AWS IoT ロギングの設定: https://docs.aws.amazon.com/iot/latest/developerguide/configure-logging.html
#   - SetV2LoggingOptions API: https://docs.aws.amazon.com/iot/latest/apireference/API_SetV2LoggingOptions.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iot_logging_options
#
# Provider Version: 6.28.0
# Generated: 2026-01-27
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_iot_logging_options" "example" {
  #-------------------------------------------------------------
  # デフォルトログレベル設定
  #-------------------------------------------------------------

  # default_log_level (Required)
  # 設定内容: AWS IoT Coreのデフォルトログレベルを指定します。
  # 設定可能な値:
  #   - "DEBUG": デバッグレベル - 最も詳細なログ出力
  #   - "INFO": 情報レベル - 一般的な情報メッセージ
  #   - "ERROR": エラーレベル - エラーメッセージのみ
  #   - "WARN": 警告レベル - 警告メッセージとエラー
  #   - "DISABLED": ロギング無効 - ログを出力しません
  # 関連機能: AWS IoT V2ロギング
  #   アカウントレベルのロギングは全てのAWS IoTリソースに適用されます。
  #   イベントレベルやリソース固有のロギング設定で上書きすることができます。
  #   - https://docs.aws.amazon.com/iot/latest/developerguide/configure-logging.html
  # 注意: ログレベルを上げると（DEBUG等）、CloudWatch Logsのコストが増加する可能性があります
  default_log_level = "WARN"

  #-------------------------------------------------------------
  # IAMロール設定
  #-------------------------------------------------------------

  # role_arn (Required)
  # 設定内容: IoTがCloudWatch Logsに書き込むために使用するIAMロールのARNを指定します。
  # 設定可能な値: 有効なIAMロールARN
  # 関連機能: CloudWatch Logsへのアクセス権限
  #   指定されたIAMロールには、logs:CreateLogGroup、logs:CreateLogStream、
  #   logs:PutLogEvents等のCloudWatch Logsへの書き込み権限が必要です。
  #   - https://docs.aws.amazon.com/iot/latest/developerguide/configure-logging.html
  # 注意: ロールに適切な信頼ポリシー（iot.amazonaws.com）とログ書き込み権限が必要です
  role_arn = "arn:aws:iam::123456789012:role/IoTLoggingRole"

  #-------------------------------------------------------------
  # 全ログ無効化設定
  #-------------------------------------------------------------

  # disable_all_logs (Optional)
  # 設定内容: 全てのログを無効化するかを指定します。
  # 設定可能な値:
  #   - true: 全てのログを無効化します
  #   - false (デフォルト): default_log_levelに基づいてログを出力します
  # 省略時: false（ログ出力が有効）
  # 関連機能: ロギングの一時的な無効化
  #   トラブルシューティングやコスト削減のため、一時的に全てのログを無効化できます。
  #   - https://docs.aws.amazon.com/iot/latest/developerguide/configure-logging.html
  # 注意: この設定をtrueにすると、default_log_levelに関係なく全てのログが無効化されます
  disable_all_logs = false

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # 注意: AWS IoTのロギング設定はリージョン単位で管理されます
  region = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: リソースの一意識別子
#
#---------------------------------------------------------------
