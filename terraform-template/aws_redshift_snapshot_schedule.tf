#---------------------------------------------------------------
# Amazon Redshift Snapshot Schedule
#---------------------------------------------------------------
#
# Amazon Redshiftクラスターの自動スナップショットスケジュールを管理するリソースです。
# スナップショットスケジュールを使用すると、Redshiftクラスターの自動バックアップを
# 定期的に取得するタイミングを柔軟に制御できます。
# スケジュールは、cronまたはrate式を使用して定義します。
#
# AWS公式ドキュメント:
#   - Redshift スナップショット: https://docs.aws.amazon.com/redshift/latest/mgmt/working-with-snapshots.html
#   - スナップショットスケジュール: https://docs.aws.amazon.com/redshift/latest/mgmt/managing-snapshots-console.html#snapshots-schedule
#   - Redshift API リファレンス: https://docs.aws.amazon.com/redshift/latest/APIReference/API_CreateSnapshotSchedule.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/redshift_snapshot_schedule
#
# Provider Version: 6.28.0
# Generated: 2026-02-03
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_redshift_snapshot_schedule" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # identifier (Optional, Forces new resource)
  # 設定内容: スナップショットスケジュールの一意な識別子を指定します。
  # 設定可能な値: 文字列
  # 省略時: Terraformがランダムな一意の識別子を自動的に割り当てます
  # 注意:
  #   - 変更すると新しいリソースが作成されます（Forces new resource）
  #   - identifier_prefixと同時に使用できません
  # 関連機能: スナップショットスケジュール識別子
  #   クラスターに関連付ける際に使用する一意の名前。
  #   - https://docs.aws.amazon.com/redshift/latest/APIReference/API_CreateSnapshotSchedule.html
  identifier = "tf-redshift-snapshot-schedule"

  # identifier_prefix (Optional, Forces new resource)
  # 設定内容: 指定したプレフィックスで始まる一意な識別子を自動生成します。
  # 設定可能な値: 文字列（プレフィックス）
  # 注意:
  #   - identifierと競合します（どちらか一方のみ指定可能）
  #   - 変更すると新しいリソースが作成されます（Forces new resource）
  # 用途: 複数のスケジュールを作成する際に命名規則を統一したい場合に使用
  identifier_prefix = null

  # description (Optional)
  # 設定内容: スナップショットスケジュールの説明を指定します。
  # 設定可能な値: 文字列
  # 用途: スケジュールの目的や対象を説明するために使用
  description = "Daily snapshots for production Redshift cluster"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # スケジュール定義
  #-------------------------------------------------------------

  # definitions (Optional)
  # 設定内容: スナップショットを取得するスケジュールを定義します。
  # 設定可能な値: スケジュール式の文字列のセット
  # スケジュール式の形式:
  #   1. cron式: cron(分 時 日 月 曜日)
  #      - 例: cron(30 12 *) - 毎日12:30 UTC
  #      - 例: cron(0 0 ? * MON) - 毎週月曜日00:00 UTC
  #   2. rate式: rate(数値 単位)
  #      - 例: rate(12 hours) - 12時間ごと
  #      - 例: rate(1 day) - 1日ごと
  # 注意:
  #   - 複数のスケジュールを定義可能
  #   - すべての時刻はUTCタイムゾーンで指定
  #   - cron式では日と曜日を同時に指定できません（どちらかは?を使用）
  # 関連機能: EventBridge（CloudWatch Events）スケジュール式
  #   Redshiftスナップショットスケジュールは、EventBridgeと同じスケジュール式構文を使用。
  #   - https://docs.aws.amazon.com/eventbridge/latest/userguide/eb-create-rule-schedule.html
  definitions = [
    "rate(12 hours)",
  ]

  # 複数スケジュールの例:
  # definitions = [
  #   "cron(0 0 ? * MON-FRI)",  # 平日の00:00 UTC
  #   "cron(0 12 ? * SAT,SUN)", # 週末の12:00 UTC
  # ]

  #-------------------------------------------------------------
  # 削除保護設定
  #-------------------------------------------------------------

  # force_destroy (Optional)
  # 設定内容: このスケジュールに関連付けられているすべてのクラスターを
  #          削除時に強制的に破棄するかどうかを指定します。
  # 設定可能な値:
  #   - true: スケジュール削除時に関連するすべてのクラスターも削除
  #   - false (デフォルト): 関連クラスターが存在する場合は削除を拒否
  # 注意:
  #   - 削除を試みる前に有効化して適用する必要があります
  #   - 本番環境では慎重に使用してください
  # 用途: テスト環境でリソースを一括削除する場合などに使用
  force_destroy = false

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  #   - https://docs.aws.amazon.com/redshift/latest/mgmt/amazon-redshift-tagging.html
  tags = {
    Name        = "production-snapshot-schedule"
    Environment = "production"
    ManagedBy   = "terraform"
  }

  # tags_all (Optional, Computed)
  # 設定内容: プロバイダーのdefault_tagsから継承されるタグを含む全タグのマップ
  # 注意: 通常は明示的に設定する必要はありません。Terraformが自動管理します
  tags_all = null

  # id (Optional, Computed)
  # 設定内容: リソースのID。通常はidentifierと同じ値
  # 注意: 通常は明示的に設定する必要はありません。Terraformが自動管理します
  id = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: スナップショットスケジュールのAmazon Resource Name (ARN)
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------

#---------------------------------------------------------------
#
# 例1: 毎日午前2時にスナップショットを取得
# resource "aws_redshift_snapshot_schedule" "daily_2am" {
#   identifier  = "daily-2am-snapshot"
#   description = "Daily snapshot at 2 AM UTC"
#   definitions = [
#     "cron(0 2 * * ? *)",
#   ]
#   tags = {
#     Schedule = "Daily"
#   }
# }
#
#---------------------------------------------------------------
