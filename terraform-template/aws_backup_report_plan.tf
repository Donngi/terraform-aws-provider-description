#---------------------------------------------------------------
# AWS Backup Report Plan
#---------------------------------------------------------------
#
# AWS Backup Audit Managerのレポートプランをプロビジョニングするリソースです。
# レポートプランは、バックアップジョブ、リストアジョブ、コピージョブ、
# およびコンプライアンスに関するレポートを自動生成し、指定したS3バケットに
# 配信する設定を定義します。
#
# AWS公式ドキュメント:
#   - AWS Backup Audit Manager: https://docs.aws.amazon.com/aws-backup/latest/devguide/working-with-audit-reports.html
#   - レポートテンプレートの選択: https://docs.aws.amazon.com/aws-backup/latest/devguide/choosing-report-template.html
#   - CreateReportPlan API: https://docs.aws.amazon.com/aws-backup/latest/devguide/API_CreateReportPlan.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/backup_report_plan
#
# Provider Version: 6.28.0
# Generated: 2026-01-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_backup_report_plan" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: レポートプランの一意な名前を指定します。
  # 設定可能な値: 1-256文字の文字列。先頭は英字で始まり、英字・数字・アンダースコアのみ使用可能。
  # 注意: 同一アカウント内で一意である必要があります。
  name = "example-report-plan"

  # description (Optional)
  # 設定内容: レポートプランの説明を指定します。
  # 設定可能な値: 最大1,024文字の文字列
  # 省略時: 説明なし
  description = "Daily backup job report for production resources"

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
  # レポート配信チャネル設定
  #-------------------------------------------------------------

  # report_delivery_channel (Required)
  # 設定内容: レポートの配信先と形式を指定します。
  # 関連機能: AWS Backup Audit Manager レポート配信
  #   生成されたレポートは指定したS3バケットに配信されます。
  #   バケットにはAWS Backupからの書き込みを許可するバケットポリシーが必要です。
  #   - https://docs.aws.amazon.com/aws-backup/latest/devguide/create-report-plan-console.html
  report_delivery_channel {
    # s3_bucket_name (Required)
    # 設定内容: レポートを受け取るS3バケットの名前を指定します。
    # 設定可能な値: 有効なS3バケット名
    # 注意: バケットはAWS Backupからのレポート配信を許可するポリシーを持つ必要があります。
    #       カスタマー管理のKMSキーで暗号化されている場合、追加の権限設定が必要です。
    s3_bucket_name = "example-backup-reports-bucket"

    # s3_key_prefix (Optional)
    # 設定内容: レポートの配信先S3キープレフィックスを指定します。
    # 設定可能な値: 有効なS3キープレフィックス
    # 省略時: プレフィックスなし
    # 配信パス例: s3://your-bucket-name/prefix/Backup/us-west-2/year/month/day/report-name
    s3_key_prefix = "backup-reports"

    # formats (Optional)
    # 設定内容: レポートの出力形式を指定します。
    # 設定可能な値:
    #   - "CSV": CSV形式で出力
    #   - "JSON": JSON形式で出力
    # 省略時: CSV形式がデフォルト
    # 注意: 複数指定可能（両方の形式でレポートを生成）
    formats = [
      "CSV",
      "JSON"
    ]
  }

  #-------------------------------------------------------------
  # レポート設定
  #-------------------------------------------------------------

  # report_setting (Required)
  # 設定内容: レポートのテンプレートと対象範囲を指定します。
  # 関連機能: AWS Backup Audit Manager レポートテンプレート
  #   ジョブレポート（バックアップ/リストア/コピー）とコンプライアンスレポートがあります。
  #   レポートは毎日UTC 1:00-5:00の間に自動生成されます。
  #   - https://docs.aws.amazon.com/aws-backup/latest/devguide/choosing-report-template.html
  report_setting {
    # report_template (Required)
    # 設定内容: 使用するレポートテンプレートを指定します。
    # 設定可能な値:
    #   - "BACKUP_JOB_REPORT": バックアップジョブレポート。過去24時間の完了済みバックアップジョブと
    #                         アクティブなジョブの情報を提供。
    #   - "COPY_JOB_REPORT": コピージョブレポート。過去24時間の完了済みコピージョブと
    #                       アクティブなジョブの情報を提供。
    #   - "RESTORE_JOB_REPORT": リストアジョブレポート。過去24時間の完了済みリストアジョブと
    #                          アクティブなジョブの情報を提供。
    #   - "RESOURCE_COMPLIANCE_REPORT": リソースコンプライアンスレポート。
    #                                   各リソースのバックアップ状況とコンプライアンス状態を提供。
    #   - "CONTROL_COMPLIANCE_REPORT": コントロールコンプライアンスレポート。
    #                                  各コントロールのコンプライアンス状態を提供。
    # 注意: RESOURCE_COMPLIANCE_REPORTとCONTROL_COMPLIANCE_REPORTを使用する場合、
    #       framework_arnsの指定が必要になる場合があります。
    report_template = "BACKUP_JOB_REPORT"

    # accounts (Optional)
    # 設定内容: レポートの対象とするAWSアカウントIDのリストを指定します。
    # 設定可能な値: AWSアカウントIDの配列
    # 省略時: 現在のアカウントのみが対象
    # 用途: Organizations環境でクロスアカウントレポートを生成する場合に使用
    accounts = null

    # organization_units (Optional)
    # 設定内容: レポートの対象とするOrganization Unit（OU）のリストを指定します。
    # 設定可能な値: OU IDの配列（例: ou-xxxx-xxxxxxxx）
    # 省略時: OUによるフィルタリングなし
    # 用途: Organizations環境で特定のOUに属するアカウントのレポートを生成する場合に使用
    organization_units = null

    # regions (Optional)
    # 設定内容: レポートの対象とするAWSリージョンのリストを指定します。
    # 設定可能な値: AWSリージョンコードの配列（例: ["ap-northeast-1", "us-east-1"]）
    # 省略時: 現在のリージョンのみが対象
    # 用途: クロスリージョンレポートを生成する場合に使用
    # 注意: ワイルドカード "*" を指定すると全リージョンが対象
    regions = null

    # framework_arns (Optional)
    # 設定内容: レポートの対象とするAWS Backupフレームワークの ARN リストを指定します。
    # 設定可能な値: AWS Backupフレームワーク ARN の配列
    # 省略時: フレームワークによるフィルタリングなし
    # 用途: RESOURCE_COMPLIANCE_REPORTまたはCONTROL_COMPLIANCE_REPORTテンプレートで、
    #       特定のフレームワークに対するコンプライアンス状態をレポートする場合に使用
    framework_arns = null

    # number_of_frameworks (Optional)
    # 設定内容: レポートがカバーするフレームワークの数を指定します。
    # 設定可能な値: 正の整数
    # 省略時: 自動計算される
    # 用途: コンプライアンスレポートで対象とするフレームワーク数を明示的に指定する場合
    number_of_frameworks = null
  }

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "example-report-plan"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: レポートプランのAmazon Resource Name (ARN)
#
# - creation_time: レポートプランが作成された日時
#                  Unix形式およびUTC（協定世界時）で表現されます。
#
# - deployment_status: レポートプランのデプロイメントステータス
#                      設定可能な値:
#                        - CREATE_IN_PROGRESS: 作成中
#                        - UPDATE_IN_PROGRESS: 更新中
#                        - DELETE_IN_PROGRESS: 削除中
#                        - COMPLETED: 完了
#
# - id: レポートプランのID
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
