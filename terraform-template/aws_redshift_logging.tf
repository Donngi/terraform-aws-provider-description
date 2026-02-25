#---------------------------------------------------------------
# Amazon Redshift Logging
#---------------------------------------------------------------
#
# Amazon RedshiftクラスターのAuditロギング設定をプロビジョニングするリソースです。
# 接続ログ・ユーザーログ・ユーザーアクティビティログをAmazon S3または
# Amazon CloudWatch Logsへエクスポートする設定を管理します。
#
# AWS公式ドキュメント:
#   - データベース監査ログ: https://docs.aws.amazon.com/redshift/latest/mgmt/db-auditing.html
#   - 監査ログの有効化: https://docs.aws.amazon.com/redshift/latest/mgmt/db-auditing-console.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/redshift_logging
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_redshift_logging" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # cluster_identifier (Required)
  # 設定内容: ログ設定の対象となるRedshiftクラスターの識別子を指定します。
  # 設定可能な値: 既存のRedshiftクラスターの識別子文字列
  cluster_identifier = "my-redshift-cluster"

  #-------------------------------------------------------------
  # ログ出力先設定
  #-------------------------------------------------------------

  # log_destination_type (Optional)
  # 設定内容: ログの出力先タイプを指定します。
  # 設定可能な値:
  #   - "s3": Amazon S3バケットにログを出力。bucket_nameが必須
  #   - "cloudwatch": Amazon CloudWatch Logsにログを出力。log_exportsが必須
  # 省略時: 既存クラスター設定に依存
  # 参考: https://docs.aws.amazon.com/redshift/latest/APIReference/API_EnableLogging.html
  log_destination_type = "cloudwatch"

  # log_exports (Optional)
  # 設定内容: エクスポートするログの種類のコレクションを指定します。
  #           log_destination_typeが"cloudwatch"の場合は必須です。
  # 設定可能な値:
  #   - "connectionlog": 認証試行・接続・切断のログ
  #   - "useractivitylog": 実行前のクエリを記録するログ（パラメータグループで
  #                        enable_user_activity_loggingを有効化する必要あり）
  #   - "userlog": データベースユーザーの変更ログ
  # 省略時: null（エクスポートなし）
  # 参考: https://docs.aws.amazon.com/redshift/latest/mgmt/db-auditing.html
  log_exports = ["connectionlog", "userlog"]

  #-------------------------------------------------------------
  # S3出力設定
  #-------------------------------------------------------------

  # bucket_name (Optional)
  # 設定内容: ログファイルの保存先となる既存S3バケットの名前を指定します。
  #           log_destination_typeが"s3"の場合は必須です。
  # 設定可能な値: 既存S3バケット名。クラスターと同一リージョンである必要があります。
  # 省略時: null
  # 注意: クラスターにはS3バケットへの読み取りおよびオブジェクト書き込み権限が必要です。
  #       S3バケットはSSE-S3暗号化を使用し、S3 Object Lock機能はオフである必要があります。
  # 参考: https://docs.aws.amazon.com/redshift/latest/mgmt/db-auditing.html
  bucket_name = null

  # s3_key_prefix (Optional)
  # 設定内容: S3に保存するログファイル名に付加するプレフィックスを指定します。
  # 設定可能な値: 任意の文字列（例: "redshift-logs/", "audit/"）
  # 省略時: プレフィックスなし
  # 参考: https://docs.aws.amazon.com/redshift/latest/APIReference/API_EnableLogging.html
  s3_key_prefix = null

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: (非推奨) ソースクラスターの識別子。cluster_identifierを使用してください。
#---------------------------------------------------------------
