#---------------------------------------------------------------
# AWS CloudWatch Log Data Protection Policy
#---------------------------------------------------------------
#
# CloudWatch Logsロググループに対するデータ保護ポリシーをプロビジョニングする
# リソースです。データ保護ポリシーを使用することで、ログに含まれる機密データ
# （メールアドレス、クレジットカード番号、社会保障番号など）を自動的に検出し、
# マスキング（匿名化）することができます。
#
# AWS公式ドキュメント:
#   - 機密ログデータのマスキングによる保護: https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/mask-sensitive-log-data.html
#   - データ保護ポリシーの理解: https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/cloudwatch-logs-data-protection-policies.html
#   - 単一ロググループのデータ保護ポリシー作成: https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/mask-sensitive-log-data-start.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_data_protection_policy
#
# Provider Version: 6.28.0
# Generated: 2026-01-19
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_cloudwatch_log_data_protection_policy" "example" {
  #-------------------------------------------------------------
  # ロググループ設定
  #-------------------------------------------------------------

  # log_group_name (Required)
  # 設定内容: データ保護ポリシーを適用するロググループの名前を指定します。
  # 設定可能な値: 既存のCloudWatch Logsロググループの名前
  # 注意: ロググループは事前に作成されている必要があります。
  log_group_name = aws_cloudwatch_log_group.example.name

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
  # データ保護ポリシードキュメント
  #-------------------------------------------------------------

  # policy_document (Required)
  # 設定内容: データ保護ポリシーをJSON形式で指定します。
  # 設定可能な値: JSON形式のポリシードキュメント（jsonencode関数の使用を推奨）
  #
  # ポリシー構造:
  #   - Name: ポリシーの名前（オプション）
  #   - Version: ポリシーバージョン。"2021-06-01"を指定
  #   - Statement: ポリシーステートメントの配列
  #
  # Statementの構成:
  #   - Sid: ステートメント識別子
  #   - DataIdentifier: 検出対象のデータ識別子ARNの配列
  #   - Operation: 実行する操作（AuditまたはDeidentify）
  #
  # 主なマネージドデータ識別子:
  #   - arn:aws:dataprotection::aws:data-identifier/EmailAddress（メールアドレス）
  #   - arn:aws:dataprotection::aws:data-identifier/CreditCardNumber（クレジットカード番号）
  #   - arn:aws:dataprotection::aws:data-identifier/SsnUs（米国社会保障番号）
  #   - arn:aws:dataprotection::aws:data-identifier/IpAddress（IPアドレス）
  #   - arn:aws:dataprotection::aws:data-identifier/Address（住所）
  #
  # 監査先（FindingsDestination）の設定可能なサービス:
  #   - CloudWatchLogs: CloudWatch Logsロググループ
  #   - Firehose: Amazon Data Firehose配信ストリーム
  #   - S3: Amazon S3バケット
  #
  # 関連機能: CloudWatch Logs データ保護
  #   機械学習とパターンマッチングを使用して機密データを検出し、
  #   ログイベントに含まれる機密情報を自動的にマスキングします。
  #   各ロググループには1つのデータ保護ポリシーのみ設定可能です。
  #   - https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/mask-sensitive-log-data-start.html#mask-sensitive-log-data-policysyntax
  #
  # 注意事項:
  #   - データ保護ポリシーはStandardログクラスのロググループにのみ適用可能
  #   - ポリシーには監査用とマスキング用の2つのブロックを含める必要があります
  #   - 監査ステートメントは1つのみ設定可能
  #   - カスタムデータ識別子は最大10個まで設定可能
  policy_document = jsonencode({
    Name    = "ExampleDataProtectionPolicy"
    Version = "2021-06-01"

    Statement = [
      # 監査ステートメント: 検出した機密データの監査ログを出力
      {
        Sid            = "Audit"
        DataIdentifier = [
          "arn:aws:dataprotection::aws:data-identifier/EmailAddress",
          "arn:aws:dataprotection::aws:data-identifier/CreditCardNumber"
        ]
        Operation = {
          Audit = {
            FindingsDestination = {
              # S3への監査ログ出力例
              S3 = {
                Bucket = aws_s3_bucket.audit_logs.bucket
              }
              # CloudWatch Logsへの監査ログ出力例（オプション）
              # CloudWatchLogs = {
              #   LogGroup = aws_cloudwatch_log_group.audit.name
              # }
              # Firehoseへの監査ログ出力例（オプション）
              # Firehose = {
              #   DeliveryStream = aws_kinesis_firehose_delivery_stream.audit.name
              # }
            }
          }
        }
      },
      # マスキングステートメント: 検出した機密データをアスタリスクでマスキング
      {
        Sid            = "Redact"
        DataIdentifier = [
          "arn:aws:dataprotection::aws:data-identifier/EmailAddress",
          "arn:aws:dataprotection::aws:data-identifier/CreditCardNumber"
        ]
        Operation = {
          Deidentify = {
            MaskConfig = {}
          }
        }
      }
    ]
  })
}

#---------------------------------------------------------------
# 依存リソースの例
#---------------------------------------------------------------

# データ保護ポリシーを適用するロググループ
resource "aws_cloudwatch_log_group" "example" {
  name = "/aws/my-application/logs"
}

# 監査ログの出力先S3バケット
resource "aws_s3_bucket" "audit_logs" {
  bucket = "my-data-protection-audit-logs"
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: ロググループ名（log_group_nameと同じ値）
#
#---------------------------------------------------------------
