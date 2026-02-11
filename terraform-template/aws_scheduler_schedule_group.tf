#---------------------------------------------------------------
# AWS EventBridge Scheduler Schedule Group
#---------------------------------------------------------------
#
# EventBridge Schedulerのスケジュールグループを管理するリソースです。
# スケジュールグループを使用すると、関連するスケジュールを論理的に整理し、
# グループ単位でスケジュールを管理できます。
#
# EventBridge Schedulerは、AWS CloudWatch Eventsの後継サービスで、
# より高度なスケジューリング機能を提供します。スケジュールグループを使用することで、
# 大量のスケジュールを効率的に整理・管理できます。
#
# AWS公式ドキュメント:
#   - EventBridge Scheduler概要: https://docs.aws.amazon.com/scheduler/latest/UserGuide/what-is-scheduler.html
#   - スケジュールグループ: https://docs.aws.amazon.com/scheduler/latest/UserGuide/managing-schedule-groups.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/scheduler_schedule_group
#
# Provider Version: 6.28.0
# Generated: 2025-02-04
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_scheduler_schedule_group" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Optional, Forces new resource)
  # 設定内容: スケジュールグループの名前を指定します。
  # 設定可能な値: 文字列（1〜64文字）
  # 注意:
  #   - 省略した場合、Terraformがランダムでユニークな名前を自動生成します。
  #   - name_prefixと排他的（どちらか一方のみ指定）
  #   - 変更すると新しいリソースが作成されます（Forces new resource）
  # 命名規則:
  #   - 英数字、ハイフン(-)、アンダースコア(_)のみ使用可能
  #   - 先頭は英字または数字である必要があります
  name = "my-schedule-group"

  # name_prefix (Optional, Forces new resource)
  # 設定内容: スケジュールグループ名のプレフィックスを指定します。
  # 設定可能な値: 文字列プレフィックス
  # 注意:
  #   - 指定したプレフィックスで始まるユニークな名前が自動生成されます。
  #   - nameと排他的（どちらか一方のみ指定）
  #   - 変更すると新しいリソースが作成されます（Forces new resource）
  # name_prefix = "schedule-group-"

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
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 注意: プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #       一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  # 用途:
  #   - リソースの整理とフィルタリング
  #   - コスト配分タグとしての利用
  #   - アクセス制御ポリシーでの参照
  tags = {
    Name        = "my-schedule-group"
    Environment = "production"
    ManagedBy   = "terraform"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: スケジュールグループの名前
#
# - arn: スケジュールグループのAmazon Resource Name (ARN)
#
# - creation_date: スケジュールグループが作成された日時
#   形式: RFC3339タイムスタンプ
#
# - last_modification_date: スケジュールグループが最後に変更された日時
#   形式: RFC3339タイムスタンプ
#
# - state: スケジュールグループの現在の状態
#   可能な値:
#     - ACTIVE: アクティブ（正常に動作中）
#     - DELETING: 削除中
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#
#---------------------------------------------------------------
# 使用例: スケジュールグループを参照する
#---------------------------------------------------------------
# スケジュールグループを作成した後、aws_scheduler_scheduleリソースで
# このグループを参照してスケジュールを作成できます。
#
# resource "aws_scheduler_schedule" "example" {
#   name       = "my-schedule"
#   group_name = aws_scheduler_schedule_group.example.name
#
#   flexible_time_window {
#     mode = "OFF"
#   }
#
#   schedule_expression = "rate(1 hour)"
#
#   target {
#     arn      = aws_lambda_function.example.arn
#     role_arn = aws_iam_role.scheduler.arn
#   }
# }
#
#---------------------------------------------------------------
# ベストプラクティス
#---------------------------------------------------------------
# 1. 命名規則の統一
#    - 環境や用途に応じた一貫した命名規則を使用
#    - 例: "{service}-{environment}-{purpose}"
#
# 2. タグの活用
#    - Environment, Owner, CostCenter等の標準タグを設定
#    - default_tagsを使用して組織全体で一貫したタグ付け
#
# 3. グループの整理
#    - 関連するスケジュールを同じグループにまとめる
#    - 環境（dev/staging/prod）やサービス単位でグループを分ける
#
# 4. IAM権限の管理
#    - スケジュールグループへのアクセスをIAMポリシーで制御
#    - 最小権限の原則に従ってアクセスを制限
#
#---------------------------------------------------------------
