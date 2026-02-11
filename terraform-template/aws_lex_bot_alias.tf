#---------------------------------------------------------------
# Amazon Lex Bot Alias
#---------------------------------------------------------------
#
# Amazon Lex Bot Aliasをプロビジョニングします。
# エイリアスは特定のボットバージョンへのポインタで、クライアントアプリケーションが
# 特定のバージョンを使用できるようにします。エイリアスを更新することで、
# クライアントアプリケーションを変更せずにボットのバージョンを切り替えられます。
#
# AWS公式ドキュメント:
#   - Versioning and Aliases: https://docs.aws.amazon.com/lex/latest/dg/versioning-aliases.html
#   - Conversation Logs: https://docs.aws.amazon.com/lex/latest/dg/conversation-logs.html
#   - PutBotAlias API: https://docs.aws.amazon.com/lex/latest/dg/API_PutBotAlias.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lex_bot_alias
#
# Provider Version: 6.28.0
# Generated: 2026-01-28
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_lex_bot_alias" "example" {
  #---------------------------------------------------------------
  # Required Parameters
  #---------------------------------------------------------------

  # (Required) ボットの名前
  # エイリアスを作成する対象のボット名を指定します。
  bot_name = "OrderFlowers"

  # (Required) ボットのバージョン
  # エイリアスが参照するボットのバージョンを指定します。
  # - 番号付きバージョン（例: "1", "2"）を指定
  # - $LATESTバージョンはエイリアスに使用できません
  # - 本番環境では番号付きバージョンの使用を推奨
  bot_version = "1"

  # (Required) エイリアスの名前
  # エイリアスの一意な名前を指定します。
  # - 最大100文字
  # - 大文字小文字を区別しない
  # - 英数字とハイフン、アンダースコアが使用可能
  name = "OrderFlowersProd"

  #---------------------------------------------------------------
  # Optional Parameters
  #---------------------------------------------------------------

  # (Optional) エイリアスの説明
  # エイリアスの目的や用途を説明するテキストです。
  # - 最大200文字
  # - 開発ステージ（dev、staging、production等）の識別に有用
  description = "Production Version of the OrderFlowers Bot."

  # (Optional) AWSリージョン
  # このリソースを管理するリージョンを指定します。
  # - 指定しない場合、プロバイダー設定のリージョンが使用されます
  # - リージョン間でのリソース移動はサポートされていません
  # region = "us-east-1"

  # (Optional) リソースID
  # Terraformが管理するリソースIDです。
  # - 通常は指定不要（自動計算されます）
  # - インポート時やID管理が必要な特殊ケースでのみ使用
  # id = "OrderFlowers:OrderFlowersProd"

  #---------------------------------------------------------------
  # Nested Blocks
  #---------------------------------------------------------------

  # (Optional) 会話ログの設定
  # ボットとユーザー間のインタラクションをログに記録するための設定です。
  # - パフォーマンスレビューやトラブルシューティングに使用
  # - エイリアスごとに設定が必要
  # - COPPAの対象となるボットでは使用不可
  # - $LATESTエイリアスやテストボットでは有効化できません
  conversation_logs {
    # (Required) IAMロールARN
    # CloudWatch LogsまたはS3バケットへのログ書き込みに使用するIAMロールのARNです。
    # - 20〜2048文字
    # - CloudWatch Logsへの書き込み権限が必要（テキストログの場合）
    # - S3への書き込み権限が必要（オーディオログの場合）
    iam_role_arn = "arn:aws:iam::123456789012:role/LexConversationLogsRole"

    # (Optional) ログ設定
    # テキストログ、オーディオログ、またはその両方の設定を指定します。
    # - 複数のlog_settingsブロックを指定可能
    # - テキストログとオーディオログを同時に有効化できます
    log_settings {
      # (Required) ログの出力先
      # ログを配信する宛先を指定します。
      # - CLOUDWATCH_LOGS: CloudWatch Logsにログを保存（テキストログ用）
      # - S3: S3バケットにログを保存（オーディオログ用）
      destination = "CLOUDWATCH_LOGS"

      # (Required) ログタイプ
      # 記録するログの種類を指定します。
      # - TEXT: テキスト形式の会話ログ（CloudWatch Logs推奨）
      # - AUDIO: 音声形式の会話ログ（S3推奨）
      log_type = "TEXT"

      # (Required) リソースARN
      # ログの配信先となるCloudWatch LogsロググループまたはS3バケットのARNです。
      # - 最大2048文字
      # - CloudWatch Logsの場合: ロググループARN
      # - S3の場合: バケットARN
      # - ボットと同じリージョンのリソースを指定する必要があります
      resource_arn = "arn:aws:logs:us-east-1:123456789012:log-group:/aws/lex/OrderFlowers"

      # (Optional) KMSキーARN
      # S3バケット内のオーディオログを暗号化するためのKMSキーのARNです。
      # - 20〜2048文字
      # - destinationがS3の場合のみ指定可能
      # - 指定しない場合、S3のデフォルト暗号化が使用されます
      # kms_key_arn = "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"
    }

    # オーディオログの設定例
    # log_settings {
    #   destination  = "S3"
    #   log_type     = "AUDIO"
    #   resource_arn = "arn:aws:s3:::my-lex-audio-logs-bucket"
    #   kms_key_arn  = "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"
    # }
  }

  # (Optional) タイムアウト設定
  # リソースの作成、更新、削除時のタイムアウトを設定します。
  # timeouts {
  #   # (Optional) 作成時のタイムアウト
  #   # - デフォルト: 1分
  #   create = "1m"
  #
  #   # (Optional) 更新時のタイムアウト
  #   # - デフォルト: 1分
  #   update = "1m"
  #
  #   # (Optional) 削除時のタイムアウト
  #   # - デフォルト: 5分
  #   delete = "5m"
  # }
}

#---------------------------------------------------------------
# Attributes Reference
#---------------------------------------------------------------
# このリソースが公開する読み取り専用属性（computed）:
#
# - arn: ボットエイリアスのARN
#   例: "arn:aws:lex:us-east-1:123456789012:bot-alias/OrderFlowers:OrderFlowersProd"
#
# - checksum: ボットエイリアスのチェックサム
#   リソースの整合性検証に使用されます
#
# - created_date: ボットエイリアスが作成された日時
#   ISO 8601形式のタイムスタンプ
#
# - last_updated_date: ボットエイリアスが最後に更新された日時
#   リソース作成時は created_date と同じ値になります
#   ISO 8601形式のタイムスタンプ
#
# - conversation_logs.log_settings.resource_prefix: ログのリソースプレフィックス
#   - TEXTログの場合: CloudWatch Logsのログストリーム名
#   - AUDIOログの場合: S3オブジェクトキーのプレフィックス
#   自動的に計算されます（computed）
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# Usage Examples
#---------------------------------------------------------------

# 基本的な使用例: 本番環境用エイリアス
# resource "aws_lex_bot_alias" "production" {
#   bot_name    = aws_lex_bot.order_flowers.name
#   bot_version = aws_lex_bot.order_flowers.version
#   name        = "Production"
#   description = "Production environment alias"
# }

# 会話ログを有効化した例
# resource "aws_lex_bot_alias" "production_with_logs" {
#   bot_name    = aws_lex_bot.order_flowers.name
#   bot_version = "1"
#   name        = "Production"
#   description = "Production environment with conversation logging"
#
#   conversation_logs {
#     iam_role_arn = aws_iam_role.lex_logs.arn
#
#     log_settings {
#       destination  = "CLOUDWATCH_LOGS"
#       log_type     = "TEXT"
#       resource_arn = aws_cloudwatch_log_group.lex_logs.arn
#     }
#
#     log_settings {
#       destination  = "S3"
#       log_type     = "AUDIO"
#       resource_arn = aws_s3_bucket.lex_audio_logs.arn
#       kms_key_arn  = aws_kms_key.lex_logs.arn
#     }
#   }
# }

# ステージング環境用エイリアス
# resource "aws_lex_bot_alias" "staging" {
#   bot_name    = aws_lex_bot.order_flowers.name
#   bot_version = "2"
#   name        = "Staging"
#   description = "Staging environment for testing"
# }
