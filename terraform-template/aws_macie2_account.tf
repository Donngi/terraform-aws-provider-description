#---------------------------------------------------------------
# AWS Macie2 Account
#---------------------------------------------------------------
#
# Amazon Macie アカウントのセッションをプロビジョニングするリソースです。
# Macie を有効化してアカウントのすべての Macie アクティビティを開始します。
# また、ポリシー検出結果の発行頻度やアカウントのステータスを管理します。
#
# AWS公式ドキュメント:
#   - Amazon Macie アカウント管理 API: https://docs.aws.amazon.com/macie/latest/APIReference/macie.html
#   - Macie 検出結果の発行設定: https://docs.aws.amazon.com/macie/latest/user/findings-publish-frequency.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/macie2_account
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_macie2_account" "example" {
  #-------------------------------------------------------------
  # アカウントステータス設定
  #-------------------------------------------------------------

  # status (Optional)
  # 設定内容: Amazon Macie アカウントのステータスを指定します。
  # 設定可能な値:
  #   - "ENABLED": Macie を有効化し、アカウントのすべての Macie アクティビティを開始します
  #   - "PAUSED": Macie を一時停止します（Macie は設定を保持しますが、データの監視を停止します）
  # 省略時: "ENABLED" が設定されます
  # 参考: https://docs.aws.amazon.com/macie/latest/APIReference/macie.html
  status = "ENABLED"

  #-------------------------------------------------------------
  # 検出結果発行設定
  #-------------------------------------------------------------

  # finding_publishing_frequency (Optional)
  # 設定内容: アカウントのポリシー検出結果の更新を AWS Security Hub および
  #           Amazon EventBridge に発行する頻度を指定します。
  # 設定可能な値:
  #   - "FIFTEEN_MINUTES": 15分ごとに発行
  #   - "ONE_HOUR": 1時間ごとに発行
  #   - "SIX_HOURS": 6時間ごとに発行（デフォルト）
  # 省略時: "SIX_HOURS" が設定されます
  # 参考: https://docs.aws.amazon.com/macie/latest/user/findings-publish-frequency.html
  finding_publishing_frequency = "SIX_HOURS"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効な AWS リージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用します
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: Macie アカウントの一意の識別子（ID）
# - service_role: Macie が AWS リソースのデータを監視・分析できるようにする
#                 サービスリンクロールの Amazon Resource Name (ARN)
# - created_at: Amazon Macie アカウントが作成された日時
#               （UTC、RFC 3339 拡張形式）
# - updated_at: Macie アカウントのステータスが最後に変更された日時
#               （UTC、RFC 3339 拡張形式）
#---------------------------------------------------------------
