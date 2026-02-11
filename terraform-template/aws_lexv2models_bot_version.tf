#---------------------------------------------------------------
# AWS Lex V2 Models Bot Version
#---------------------------------------------------------------
#
# Amazon Lex V2のボットバージョンをプロビジョニングするリソースです。
# バージョンはボットの番号付きスナップショットであり、開発、ベータ展開、
# プロダクションなど、ワークフローの異なる部分で使用できます。
# バージョンを作成すると、そのバージョンは変更されることなく保持され、
# Draftバージョンの更新を続けてもユーザー体験に影響を与えません。
#
# AWS公式ドキュメント:
#   - Versioning and aliases: https://docs.aws.amazon.com/lexv2/latest/dg/versions-aliases.html
#   - CreateBotVersion API: https://docs.aws.amazon.com/lexv2/latest/APIReference/API_CreateBotVersion.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lexv2models_bot_version
#
# Provider Version: 6.28.0
# Generated: 2026-02-04
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_lexv2models_bot_version" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # bot_id (Required)
  # 設定内容: バージョンを作成するボットの識別子を指定します。
  # 設定可能な値: 有効なAmazon Lex V2ボットID
  # 関連機能: Amazon Lex V2 Bot Versioning
  #   ボットの番号付きスナップショットを作成し、クライアントアプリケーションが
  #   使用する実装を制御できます。バージョンは一度作成されると変更されません。
  #   - https://docs.aws.amazon.com/lexv2/latest/dg/versions-aliases.html
  # 参考: https://docs.aws.amazon.com/lexv2/latest/APIReference/API_CreateBotVersion.html
  bot_id = "BOTID123456"

  # description (Optional)
  # 設定内容: バージョンの説明を指定します。
  # 設定可能な値: 文字列（最大200文字）
  # 省略時: 説明なしでバージョンが作成されます
  # 用途: リスト内でバージョンを識別するのに役立ちます
  description = "Production version v1.0 - Initial release"

  #-------------------------------------------------------------
  # ロケール設定
  #-------------------------------------------------------------

  # locale_specification (Required)
  # 設定内容: このバージョンに追加するロケールを指定します。
  # 設定可能な値: ロケール名をキー、ソースバージョン情報を値とするマップ
  #   各ロケールには以下を指定:
  #   - source_bot_version (Required): ロケールのコピー元となるボットバージョン
  #     有効な値: "DRAFT" または数値バージョン（例: "1", "2"）
  # 関連機能: Locale Version Selection
  #   各ロケールについて、Draftバージョンまたは以前に公開されたバージョンを
  #   選択できます。ソースバージョンを指定すると、ロケールデータがソースバージョン
  #   から新しいバージョンにコピーされます。全てのロケールを含める必要はなく、
  #   異なるロケールで異なるソースバージョンを選択することも可能です。
  #   - https://docs.aws.amazon.com/lexv2/latest/dg/versions-aliases.html
  # 注意: バージョン作成時に選択されたロケールのみが含まれます。
  #       後からロケールを追加するには新しいバージョンを作成する必要があります。
  # 参考: https://docs.aws.amazon.com/lexv2/latest/APIReference/API_BotVersionLocaleDetails.html
  locale_specification = {
    "en_US" = {
      source_bot_version = "DRAFT"
    }
    "ja_JP" = {
      source_bot_version = "DRAFT"
    }
  }

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
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト時間を指定します。
  # 設定可能な値:
  #   - create: 作成操作のタイムアウト（例: "30s", "5m"）
  #   - delete: 削除操作のタイムアウト（例: "30s", "5m"）
  # 省略時: Terraformのデフォルトタイムアウトが使用されます
  # 注意: 大規模なボットやロケールが多い場合は、タイムアウトを長めに設定することを推奨
  timeouts {
    create = "5m"
    delete = "5m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: bot_idとbot_versionをカンマ区切りで連結した文字列
#       形式: "{bot_id},{bot_version}"
#
# - bot_version: バージョンに割り当てられたバージョン番号。
#                Amazon Lex V2が自動的に採番します（例: "1", "2", "3"）。
#                このバージョン番号は、エイリアスの作成やクライアント
#                アプリケーションからの参照に使用できます。
#
# 使用例:
#   resource "aws_lexv2models_bot_alias" "prod" {
#     bot_id      = aws_lexv2models_bot_version.example.bot_id
#     bot_version = aws_lexv2models_bot_version.example.bot_version
#     # ...
#   }
#---------------------------------------------------------------
