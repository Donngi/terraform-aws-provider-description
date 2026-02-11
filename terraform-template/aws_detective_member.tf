#---------------------------------------------------------------
# AWS Detective Member
#---------------------------------------------------------------
#
# Amazon Detectiveのメンバーアカウントを管理するリソースです。
# DetectiveはAWSセキュリティサービスで、セキュリティ調査のために
# ログデータを分析し、セキュリティに関する問題の根本原因を特定するのに役立ちます。
# このリソースを使用して、管理者アカウントから他のAWSアカウントを
# Detectiveの動作グラフに招待し、メンバーとして追加できます。
#
# AWS公式ドキュメント:
#   - Amazon Detective概要: https://docs.aws.amazon.com/detective/latest/adminguide/what-is-detective.html
#   - メンバーアカウントの招待: https://docs.aws.amazon.com/detective/latest/adminguide/graph-admin-add-member-accounts.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/detective_member
#
# Provider Version: 6.28.0
# Generated: 2026-01-22
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_detective_member" "example" {
  #-------------------------------------------------------------
  # 基本設定（必須）
  #-------------------------------------------------------------

  # account_id (Required)
  # 設定内容: 招待するメンバーアカウントのAWSアカウントIDを指定します。
  # 設定可能な値: 12桁のAWSアカウントID
  # 注意: リソース作成後の変更はできません（Forces new resource）
  account_id = "123456789012"

  # email_address (Required)
  # 設定内容: メンバーアカウントに関連付けられたメールアドレスを指定します。
  # 設定可能な値: 有効なメールアドレス
  # 注意: 招待通知の送信先として使用されます。
  #       リソース作成後の変更はできません（Forces new resource）
  email_address = "member@example.com"

  # graph_arn (Required)
  # 設定内容: メンバーアカウントを招待する動作グラフのARNを指定します。
  # 設定可能な値: 有効なDetective動作グラフのARN
  # 注意: 動作グラフは aws_detective_graph リソースで作成できます。
  #       リソース作成後の変更はできません（Forces new resource）
  # 参考: https://docs.aws.amazon.com/detective/latest/adminguide/detective-source-data-about.html
  graph_arn = aws_detective_graph.example.graph_arn

  #-------------------------------------------------------------
  # オプション設定
  #-------------------------------------------------------------

  # message (Optional)
  # 設定内容: 招待に含めるカスタムメッセージを指定します。
  # 設定可能な値: 任意の文字列
  # 省略時: なし（標準の招待コンテンツのみ送信）
  # 注意: Amazon Detectiveは、このメッセージを招待メールの標準コンテンツに追加します。
  message = "Please accept this invitation to join our Detective behavior graph for security analysis."

  # disable_email_notification (Optional)
  # 設定内容: 招待メール通知を無効にするかどうかを指定します。
  # 設定可能な値:
  #   - true: 招待メールを送信しない（AWS Personal Health Dashboardのアラートのみ）
  #   - false (デフォルト): 招待メールを送信する
  # 省略時: false
  # 注意: trueに設定しても、招待されたアカウントのルートユーザーには
  #       AWS Personal Health Dashboardでアラートが表示されます。
  disable_email_notification = false

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null
}

#---------------------------------------------------------------
# 関連リソース例: Detective Graph
#---------------------------------------------------------------
# aws_detective_member リソースを使用するには、まず動作グラフが必要です。
# 以下は参考用の aws_detective_graph リソース例です。
#
# resource "aws_detective_graph" "example" {
#   tags = {
#     Name = "example-detective-graph"
#   }
# }

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: Detectiveのユニーク識別子（ID）
#
# - administrator_id: 管理者アカウントのAWSアカウントID
#
# - status: メンバーアカウントの現在のメンバーシップステータス
#   - INVITED: 招待済みだが未承諾
#   - VERIFICATION_IN_PROGRESS: 検証中
#   - ENABLED: 有効化済み
#   - DISABLED: 無効化済み
#
# - disabled_reason: メンバーアカウントが無効化されている場合の理由
#
# - volume_usage_in_bytes: メンバーアカウントの1日あたりのデータ使用量（バイト単位）
#
# - invited_time: 招待が最後に送信された日時（UTC、RFC 3339形式）
#
# - updated_time: メンバーアカウントのステータスが最後に変更された日時（UTC、RFC 3339形式）
#---------------------------------------------------------------
