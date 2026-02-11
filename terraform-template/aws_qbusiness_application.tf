################################################################################
# AWS Q Business Application
################################################################################
# Amazon Q Businessアプリケーションは、生成AI機能を提供するエンタープライズ
# 向けアシスタントサービスです。IAM Identity Centerとの統合により、ユーザー
# 認証とアクセス管理を実現します。
#
# 主な用途:
# - エンタープライズデータを活用した生成AIアシスタント
# - ドキュメント検索とQ&A機能
# - カスタマーセルフサービス体験
# - 社内ナレッジベースの統合
#
# 料金モデル:
# - 認証ユーザー: ユーザー単位のサブスクリプション（Lite/Pro）
# - 匿名ユーザー: Chat/ChatSync API操作の従量課金
#
# 参考: https://docs.aws.amazon.com/amazonq/latest/qbusiness-ug/create-app.html
################################################################################

resource "aws_qbusiness_application" "this" {
  #---------------------------------------
  # 必須パラメータ
  #---------------------------------------

  # display_name - アプリケーションの表示名
  # - AWS Management Consoleやユーザーインターフェースに表示される名前
  # - 識別しやすい、わかりやすい名前を指定
  display_name = "example-app"

  # iam_service_role_arn - IAMサービスロールのARN
  # - Amazon Q BusinessがAWSサービスにアクセスするために必要
  # - 必要な権限:
  #   - CloudWatch Logs/Metricsへのアクセス
  #   - データソースへのアクセス（S3、RDS等）
  #   - KMS暗号化キーへのアクセス（暗号化使用時）
  # - 信頼関係でqbusiness.amazonaws.comをプリンシパルに設定
  iam_service_role_arn = "arn:aws:iam::123456789012:role/QBusinessServiceRole"

  # identity_center_instance_arn - IAM Identity CenterインスタンスのARN
  # - ユーザー認証とアクセス管理に使用
  # - 事前にIAM Identity Centerのセットアップが必要
  # - 取得方法: data.aws_ssoadmin_instances.example.arns
  # 注意: 匿名アクセスアプリケーションの場合は不要
  identity_center_instance_arn = "arn:aws:sso:::instance/ssoins-1234567890abcdef"

  # attachments_configuration - ファイルアップロード機能の設定
  # - エンドユーザーがファイルをアップロードできるかを制御
  # 注意: 匿名アクセスアプリケーションでは使用不可
  attachments_configuration {
    # attachments_control_mode - ファイルアップロード機能の有効/無効
    # - "ENABLED": ファイルアップロード機能を有効化
    # - "DISABLED": ファイルアップロード機能を無効化
    # セキュリティ考慮:
    # - ENABLEDにする場合、適切なファイルサイズ制限と検証を実装
    # - マルウェアスキャンの導入を推奨
    attachments_control_mode = "ENABLED"
  }

  #---------------------------------------
  # オプションパラメータ
  #---------------------------------------

  # description - アプリケーションの説明
  # - アプリケーションの目的や用途を記述
  # - 管理コンソールで表示される
  description = "Enterprise Q&A assistant for internal documentation"

  # region - リソースが管理されるリージョン
  # - 指定しない場合、プロバイダー設定のリージョンを使用
  # - マルチリージョン展開時に明示的に指定
  # 注意: Amazon Q Businessの利用可能リージョンは限定的
  # region = "us-east-1"

  # encryption_configuration - 暗号化設定
  # - データの暗号化にカスタムKMSキーを使用
  # - 指定しない場合、AWS管理キーを使用
  encryption_configuration {
    # kms_key_id - KMSキーの識別子
    # - キーID、キーARN、エイリアス名、エイリアスARNを指定可能
    # - 非対称キーは非サポート（対称キーのみ）
    # 必要な権限:
    # - kms:Decrypt
    # - kms:GenerateDataKey
    # - kms:CreateGrant（自動キーローテーション使用時）
    kms_key_id = "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"
  }

  # tags - リソースタグ
  # - リソースの分類、コスト配分、アクセス制御に使用
  tags = {
    Environment = "production"
    Department  = "IT"
    ManagedBy   = "Terraform"
  }

  #---------------------------------------
  # タイムアウト設定
  #---------------------------------------
  # Amazon Q Businessアプリケーションの作成には時間がかかる場合があるため、
  # 必要に応じてタイムアウト値を調整

  # timeouts {
  #   create = "30m"  # 作成タイムアウト（デフォルト: 30分）
  #   update = "30m"  # 更新タイムアウト（デフォルト: 30分）
  #   delete = "30m"  # 削除タイムアウト（デフォルト: 30分）
  # }
}

################################################################################
# 出力値
################################################################################

# application_id - Amazon Q BusinessアプリケーションのID
# - 他のQ Businessリソース（Index、Data Source等）の作成に使用
output "qbusiness_application_id" {
  description = "ID of the Q Business application"
  value       = aws_qbusiness_application.this.id
}

# arn - Amazon Q BusinessアプリケーションのARN
# - IAMポリシーやリソースベースポリシーで使用
output "qbusiness_application_arn" {
  description = "ARN of the Q Business application"
  value       = aws_qbusiness_application.this.arn
}

# identity_center_application_arn - IAM Identity CenterアプリケーションのARN
# - Identity Center統合の検証に使用
output "qbusiness_identity_center_application_arn" {
  description = "ARN of the IAM Identity Center application"
  value       = aws_qbusiness_application.this.identity_center_application_arn
}

################################################################################
# 使用例: 完全な設定
################################################################################

# IAMサービスロールの作成例
# data "aws_iam_policy_document" "qbusiness_assume_role" {
#   statement {
#     actions = ["sts:AssumeRole"]
#     principals {
#       type        = "Service"
#       identifiers = ["qbusiness.amazonaws.com"]
#     }
#   }
# }
#
# resource "aws_iam_role" "qbusiness" {
#   name               = "QBusinessServiceRole"
#   assume_role_policy = data.aws_iam_policy_document.qbusiness_assume_role.json
#
#   tags = {
#     Name = "Q Business Service Role"
#   }
# }
#
# data "aws_iam_policy_document" "qbusiness_permissions" {
#   # CloudWatch Logs/Metrics権限
#   statement {
#     sid    = "CloudWatchLogsAccess"
#     effect = "Allow"
#     actions = [
#       "logs:CreateLogGroup",
#       "logs:CreateLogStream",
#       "logs:PutLogEvents",
#       "cloudwatch:PutMetricData"
#     ]
#     resources = ["*"]
#   }
#
#   # S3データソースアクセス権限（例）
#   statement {
#     sid    = "S3DataSourceAccess"
#     effect = "Allow"
#     actions = [
#       "s3:GetObject",
#       "s3:ListBucket"
#     ]
#     resources = [
#       "arn:aws:s3:::my-qbusiness-data-bucket",
#       "arn:aws:s3:::my-qbusiness-data-bucket/*"
#     ]
#   }
#
#   # KMS暗号化権限（暗号化使用時）
#   statement {
#     sid    = "KMSEncryptionAccess"
#     effect = "Allow"
#     actions = [
#       "kms:Decrypt",
#       "kms:GenerateDataKey",
#       "kms:CreateGrant"
#     ]
#     resources = ["arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"]
#   }
# }
#
# resource "aws_iam_role_policy" "qbusiness" {
#   name   = "QBusinessPermissions"
#   role   = aws_iam_role.qbusiness.id
#   policy = data.aws_iam_policy_document.qbusiness_permissions.json
# }

# Identity Centerインスタンスの取得例
# data "aws_ssoadmin_instances" "example" {}
#
# resource "aws_qbusiness_application" "full_example" {
#   display_name                 = "production-qbusiness-app"
#   description                  = "Production Q Business application with full configuration"
#   iam_service_role_arn         = aws_iam_role.qbusiness.arn
#   identity_center_instance_arn = tolist(data.aws_ssoadmin_instances.example.arns)[0]
#   region                       = "us-east-1"
#
#   attachments_configuration {
#     attachments_control_mode = "ENABLED"
#   }
#
#   encryption_configuration {
#     kms_key_id = aws_kms_key.qbusiness.arn
#   }
#
#   tags = {
#     Environment = "production"
#     Application = "QBusiness"
#     ManagedBy   = "Terraform"
#   }
#
#   timeouts {
#     create = "60m"
#     update = "60m"
#     delete = "30m"
#   }
# }

################################################################################
# 使用例: 匿名アクセスアプリケーション
################################################################################
# 公開ウェブサイトやドキュメントポータル向けの認証不要アプリケーション
#
# resource "aws_qbusiness_application" "anonymous" {
#   display_name         = "public-docs-assistant"
#   iam_service_role_arn = aws_iam_role.qbusiness_anonymous.arn
#   # identity_center_instance_arn は不要（匿名アクセスのため）
#
#   # 匿名アクセスの制限事項:
#   # - attachments_configurationは使用不可
#   # - チャット履歴なし
#   # - GetDocumentContent API使用不可
#   # - トピックルール、プラグイン、Amazon Q Apps使用不可
#   # - 公開データソース（ACLなし）のみサポート
#
#   description = "Public-facing Q&A assistant for documentation"
#
#   tags = {
#     AccessType = "anonymous"
#   }
# }
#
# # 匿名アクセス用のIAMロールには追加の制限ポリシーが必要
# data "aws_iam_policy_document" "qbusiness_anonymous_assume_role" {
#   statement {
#     actions = ["sts:AssumeRole"]
#     principals {
#       type        = "Service"
#       identifiers = ["qbusiness.amazonaws.com"]
#     }
#     condition {
#       test     = "StringEquals"
#       variable = "qbusiness:IdentityType"
#       values   = ["ANONYMOUS"]
#     }
#   }
# }

################################################################################
# 関連リソース
################################################################################
# Amazon Q Businessアプリケーションと組み合わせて使用する主なリソース:
#
# 1. aws_qbusiness_index
#    - データのインデックス作成
#
# 2. aws_qbusiness_data_source
#    - データソース接続（S3、SharePoint、Salesforce等）
#
# 3. aws_qbusiness_web_experience
#    - Webインターフェース作成
#
# 4. aws_ssoadmin_*
#    - IAM Identity Center設定
#
# 5. aws_iam_role / aws_iam_role_policy
#    - サービスロール作成
#
# 6. aws_kms_key
#    - カスタム暗号化キー

################################################################################
# ベストプラクティス
################################################################################
# 1. セキュリティ
#    - カスタムKMSキーで暗号化を有効化
#    - 最小権限の原則でIAMロールを設定
#    - Identity Centerで適切なアクセス制御を実装
#    - ファイルアップロード機能を有効にする場合、検証とスキャンを実装
#
# 2. コスト最適化
#    - Lite/Proサブスクリプションを適切に選択
#    - 匿名アクセスの場合、API使用量を監視
#    - 不要なデータソースの同期を削減
#
# 3. 運用
#    - CloudWatch Logsで監査ログを有効化
#    - データソースの同期スケジュールを最適化
#    - 定期的にユーザーフィードバックを確認
#    - アプリケーションのメトリクスを監視
#
# 4. 可用性
#    - プロダクション環境では適切なタイムアウト値を設定
#    - データソースの冗長性を考慮
#    - バックアップとディザスタリカバリ戦略を計画
#
# 5. コンプライアンス
#    - データソースに含まれる機密情報の分類
#    - アクセスログの保存期間を法令に準拠
#    - データレジデンシー要件を確認
#    - GDPRなどの規制に対応

################################################################################
# トラブルシューティング
################################################################################
# 1. アプリケーション作成失敗
#    問題: アプリケーションの作成がタイムアウトまたは失敗する
#    解決策:
#    - IAMロールの信頼関係を確認（qbusiness.amazonaws.comが信頼されているか）
#    - Identity CenterインスタンスのARNが正しいか確認
#    - リージョンでQ Businessが利用可能か確認
#    - 作成タイムアウトを60分に増やす
#
# 2. ユーザーアクセス不可
#    問題: ユーザーがアプリケーションにアクセスできない
#    解決策:
#    - Identity Centerでユーザー/グループが追加されているか確認
#    - サブスクリプションが有効か確認
#    - ユーザーに適切なIAMポリシーが割り当てられているか確認
#
# 3. 暗号化エラー
#    問題: KMS暗号化関連のエラーが発生する
#    解決策:
#    - KMSキーポリシーでqbusiness.amazonaws.comを許可
#    - キーが有効化されているか確認
#    - 対称キーを使用しているか確認（非対称キーは非サポート）
#    - IAMロールにKMS権限があるか確認
#
# 4. データソース接続失敗
#    問題: データソースへの接続が失敗する
#    解決策:
#    - IAMロールに必要なデータソース権限があるか確認
#    - データソースへのネットワーク接続を確認
#    - データソースのアクセスコントロール設定を確認
#
# 5. パフォーマンス問題
#    問題: 応答が遅い、またはタイムアウトする
#    解決策:
#    - データソースのインデックスサイズを確認
#    - 同期スケジュールを最適化
#    - データソースのフィルタリングを検討
#    - CloudWatch Metricsでボトルネックを特定

################################################################################
# 参考リンク
################################################################################
# - 公式ドキュメント: https://docs.aws.amazon.com/amazonq/latest/qbusiness-ug/create-app.html
# - Terraformリソース: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/qbusiness_application
# - IAM Identity Center: https://docs.aws.amazon.com/singlesignon/latest/userguide/
# - 料金情報: https://aws.amazon.com/q/business/pricing/
# - 匿名アクセス: https://docs.aws.amazon.com/amazonq/latest/qbusiness-ug/create-anonymous-application.html
