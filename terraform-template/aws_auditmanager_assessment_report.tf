#---------------------------------------------------------------
# AWS Audit Manager Assessment Report
#---------------------------------------------------------------
#
# AWS Audit Managerの評価レポートをプロビジョニングするリソースです。
# 評価レポートは、評価で収集されたエビデンスの要約を含むドキュメントで、
# 各エビデンスの詳細を含むPDFファイルへのリンクが含まれます。
#
# AWS公式ドキュメント:
#   - Assessment Reports: https://docs.aws.amazon.com/audit-manager/latest/userguide/assessment-reports.html
#   - AssessmentReport API: https://docs.aws.amazon.com/audit-manager/latest/APIReference/API_AssessmentReport.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/auditmanager_assessment_report
#
# Provider Version: 6.28.0
# Generated: 2026-01-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_auditmanager_assessment_report" "example" {
  #-------------------------------------------------------------
  # 必須設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: 評価レポートの名前を指定します。
  # 設定可能な値: 文字列
  # 注意: レポート生成後、カバーページにこの名前が表示されます。
  name = "my-assessment-report"

  # assessment_id (Required)
  # 設定内容: レポートを生成する評価の一意識別子を指定します。
  # 設定可能な値: 36文字のUUID形式の文字列
  # 関連機能: AWS Audit Manager Assessment
  #   評価は、フレームワーク内のコントロールに対してエビデンスを収集する
  #   プロセスです。評価からレポートを生成することで、監査人が確認できる
  #   形式でエビデンスをまとめることができます。
  #   - https://docs.aws.amazon.com/audit-manager/latest/userguide/assessments.html
  assessment_id = "12345678-1234-1234-1234-123456789012"

  #-------------------------------------------------------------
  # オプション設定
  #-------------------------------------------------------------

  # description (Optional)
  # 設定内容: 評価レポートの説明を指定します。
  # 設定可能な値: 文字列
  # 用途: レポートの目的や対象期間などを記述するのに使用します。
  description = "Monthly compliance assessment report for Q1 2026"

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
# - id: 評価レポートの一意識別子（UUID形式、36文字）
#
# - author: 評価レポートを作成したユーザーの名前（最大128文字）
#
# - status: 評価レポートの現在のステータス
#           有効な値: "COMPLETE", "IN_PROGRESS", "FAILED"
#---------------------------------------------------------------
