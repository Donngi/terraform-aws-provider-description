#---------------------------------------------------------------
# Amazon Lex Bot Alias
#---------------------------------------------------------------
#
# Amazon Lex V1 のボットエイリアス（Bot Alias）をプロビジョニングするリソースです。
# ボットエイリアスはボットの特定バージョンを指すポインターとして機能し、
# 本番環境やテスト環境など複数の環境を同一ボットの異なるバージョンで管理できます。
# ボットのバージョンを更新する際はエイリアスを切り替えることで
# クライアントアプリケーションを変更せずにデプロイが可能です。
#
# 注意: このリソースは Amazon Lex V1 向けです。
#       新規開発には Amazon Lex V2 の aws_lexv2models_* リソース群の使用を推奨します。
#
# AWS公式ドキュメント:
#   - Amazon Lex V1 とは: https://docs.aws.amazon.com/lex/latest/dg/what-is.html
#   - ボットエイリアス: https://docs.aws.amazon.com/lex/latest/dg/aliases.html
#   - 会話ログ設定: https://docs.aws.amazon.com/lex/latest/dg/conversation-logs.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lex_bot_alias
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_lex_bot_alias" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: エイリアスの名前を指定します。
  # 設定可能な値: 英数字、アンダースコア、ハイフンを含む文字列（最大100文字）
  # 省略時: 設定必須
  name = "example-alias"

  # bot_name (Required)
  # 設定内容: エイリアスが指すボットの名前を指定します。
  # 設定可能な値: 既存の Amazon Lex V1 ボット名（最大50文字）
  # 省略時: 設定必須
  bot_name = "example-bot"

  # bot_version (Required)
  # 設定内容: エイリアスが指すボットのバージョンを指定します。
  # 設定可能な値:
  #   - "$LATEST": 最新の開発バージョン（本番環境での使用は非推奨）
  #   - "1", "2", ...: 公開済みの特定バージョン番号
  # 省略時: 設定必須
  bot_version = "$LATEST"

  # description (Optional)
  # 設定内容: エイリアスの説明を指定します。
  # 設定可能な値: 任意の文字列（最大200文字）
  # 省略時: 説明なし
  description = "example-alias の説明"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効な AWS リージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # 会話ログ設定
  #-------------------------------------------------------------

  # conversation_logs (Optional)
  # 設定内容: ボットエイリアスの会話ログ設定を行うブロックです。
  #           テキストログおよび音声ログの送信先を設定します。
  # 参考: https://docs.aws.amazon.com/lex/latest/dg/conversation-logs.html
  conversation_logs {

    # iam_role_arn (Required)
    # 設定内容: ログを CloudWatch Logs または S3 に書き込む IAM ロールの ARN を指定します。
    # 設定可能な値: CloudWatch Logs / S3 への書き込み権限を持つ IAM ロールの ARN
    # 省略時: 設定必須
    # 注意: 指定ロールには Amazon Lex が AssumeRole できる信頼ポリシーが必要です。
    iam_role_arn = "arn:aws:iam::123456789012:role/example-lex-conversation-logs-role"

    #-------------------------------------------------------------
    # ログ送信先設定
    #-------------------------------------------------------------

    # log_settings (Optional)
    # 設定内容: ログの種類と送信先を設定するブロックです（複数指定可）。
    #           テキストログと音声ログをそれぞれ異なる送信先に設定できます。
    log_settings {

      # log_type (Required)
      # 設定内容: 記録するログの種類を指定します。
      # 設定可能な値:
      #   - "TEXT": テキスト（会話トランスクリプト）ログ
      #   - "AUDIO": 音声ログ
      # 省略時: 設定必須
      log_type = "TEXT"

      # destination (Required)
      # 設定内容: ログの送信先サービスを指定します。
      # 設定可能な値:
      #   - "CLOUDWATCH_LOGS": Amazon CloudWatch Logs（TEXT ログのみ対応）
      #   - "S3": Amazon S3（TEXT および AUDIO ログに対応）
      # 省略時: 設定必須
      destination = "CLOUDWATCH_LOGS"

      # resource_arn (Required)
      # 設定内容: ログの送信先リソースの ARN を指定します。
      # 設定可能な値:
      #   - destination が "CLOUDWATCH_LOGS" の場合: CloudWatch Logs ロググループの ARN
      #   - destination が "S3" の場合: S3 バケットの ARN
      # 省略時: 設定必須
      resource_arn = "arn:aws:logs:ap-northeast-1:123456789012:log-group:/aws/lex/example-bot:*"

      # kms_key_arn (Optional)
      # 設定内容: ログの暗号化に使用する AWS KMS キーの ARN を指定します。
      # 設定可能な値:
      #   - AWS KMS キーの ARN（destination が "S3" の場合のみ使用可能）
      # 省略時: 暗号化なし（または S3 のデフォルト暗号化を使用）
      # 注意: CloudWatch Logs destination の場合、このパラメータは無視されます。
      kms_key_arn = null
    }
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト時間を設定するブロックです。
  timeouts {

    # create (Optional)
    # 設定内容: リソース作成時のタイムアウト時間を指定します。
    # 設定可能な値: "30s", "5m", "1h" など Go の time.Duration 形式
    # 省略時: プロバイダーのデフォルト値を使用
    create = "5m"

    # update (Optional)
    # 設定内容: リソース更新時のタイムアウト時間を指定します。
    # 設定可能な値: "30s", "5m", "1h" など Go の time.Duration 形式
    # 省略時: プロバイダーのデフォルト値を使用
    update = "5m"

    # delete (Optional)
    # 設定内容: リソース削除時のタイムアウト時間を指定します。
    # 設定可能な値: "30s", "5m", "1h" など Go の time.Duration 形式
    # 省略時: プロバイダーのデフォルト値を使用
    delete = "5m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: ボットエイリアスの Amazon Resource Name (ARN)
# - checksum: リソースの変更検出に使用される ETag 相当のチェックサム値
# - created_date: エイリアスが作成された日時（ISO 8601 形式）
# - id: ボット名とエイリアス名を結合した識別子（例: bot_name:alias_name）
# - last_updated_date: エイリアスが最後に更新された日時（ISO 8601 形式）
# - conversation_logs[*].log_settings[*].resource_prefix: CloudWatch Logs または S3 への書き込みプレフィックス
#---------------------------------------------------------------
