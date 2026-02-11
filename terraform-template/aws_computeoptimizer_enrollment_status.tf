################################################################################
# AWS Compute Optimizer Enrollment Status
################################################################################
# Generated: 2026-01-19
# Provider Version: 6.28.0
#
# 注意: このテンプレートは生成時点(2026-01-19)の情報に基づいています。
#       最新の仕様については公式ドキュメントをご確認ください。
#
# 参考:
# - Terraform Registry: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/computeoptimizer_enrollment_status
# - AWS API Reference: https://docs.aws.amazon.com/compute-optimizer/latest/APIReference/API_UpdateEnrollmentStatus.html
################################################################################

resource "aws_computeoptimizer_enrollment_status" "example" {
  # ====================================
  # 必須パラメータ
  # ====================================

  # (Required) The enrollment status of the account.
  # アカウントのAWS Compute Optimizerへの登録状態を指定します。
  #
  # 有効な値:
  # - "Active"   : アカウントをCompute Optimizerに登録し、リソース使用状況の分析と最適化推奨を受け取ります
  # - "Inactive" : アカウントのCompute Optimizer登録を解除します
  #
  # 注意:
  # - Activeに設定すると、Compute Optimizerはアカウント内のサービスリンクロールを自動的に作成します
  # - Inactiveに設定すると、最適化推奨の取得が停止されます
  #
  # 参考: https://docs.aws.amazon.com/compute-optimizer/latest/APIReference/API_UpdateEnrollmentStatus.html
  status = "Active"

  # ====================================
  # オプションパラメータ
  # ====================================

  # (Optional) Whether to enroll member accounts of the organization if the account
  # is the management account of an organization.
  # アカウントが組織の管理アカウントである場合、メンバーアカウントも同時に登録するかを指定します。
  #
  # デフォルト値: false
  #
  # 注意:
  # - この設定は組織の管理アカウントでのみ有効です
  # - trueに設定すると、組織内の全メンバーアカウントがCompute Optimizerに登録されます
  # - メンバーアカウントの登録状態はnumber_of_member_accounts_opted_in属性で確認できます
  #
  # 参考: https://docs.aws.amazon.com/compute-optimizer/latest/APIReference/API_UpdateEnrollmentStatus.html
  include_member_accounts = false

  # (Optional) Region where this resource will be managed.
  # このリソースが管理されるAWSリージョンを指定します。
  #
  # デフォルト値: プロバイダー設定で指定されたリージョン
  #
  # 注意:
  # - 明示的に指定しない場合は、プロバイダー設定のリージョンが使用されます
  # - Compute Optimizerは特定のリージョンで管理する必要があるため、この設定で制御できます
  #
  # 例: "us-east-1", "ap-northeast-1"
  #
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  # ====================================
  # Timeouts
  # ====================================

  # (Optional) タイムアウト設定
  # リソース操作のタイムアウト時間を指定します。
  timeouts {
    # (Optional) リソース作成時のタイムアウト
    # デフォルト: プロバイダーのデフォルト値
    # 形式: "30s", "5m", "1h" など（秒: s, 分: m, 時間: h）
    create = null

    # (Optional) リソース更新時のタイムアウト
    # デフォルト: プロバイダーのデフォルト値
    # 形式: "30s", "5m", "1h" など（秒: s, 分: m, 時間: h）
    update = null
  }
}

################################################################################
# Computed Attributes (参照のみ)
################################################################################
# このリソースは以下の属性を出力します（設定はできません）:
#
# - id (string)
#     リソースの一意識別子
#
# - number_of_member_accounts_opted_in (number)
#     組織のメンバーアカウントのうち、Compute Optimizerに登録されているアカウント数
#     注意: 管理アカウントの場合のみ有効な値が返されます
#
# 使用例:
# output "enrollment_id" {
#   value = aws_computeoptimizer_enrollment_status.example.id
# }
#
# output "member_accounts_opted_in" {
#   value = aws_computeoptimizer_enrollment_status.example.number_of_member_accounts_opted_in
# }
################################################################################
