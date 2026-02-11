#======================================
# AWS Redshift Scheduled Action
#======================================
# Amazon Redshift のスケジュールアクションを定義します。
# クラスターの一時停止、再開、リサイズなどの操作を定期的に実行できます。
# cron式またはat式でスケジュールを指定します。
#
# ユースケース:
# - 夜間にクラスターを一時停止してコスト削減
# - 業務時間前にクラスターを再開
# - トラフィックパターンに応じたリサイズ
#
# 公式ドキュメント:
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/redshift_scheduled_action
#======================================

resource "aws_redshift_scheduled_action" "example" {
  #======================================
  # 基本設定
  #======================================

  # name - スケジュールアクション名（必須）
  # 説明: スケジュールアクションを識別する一意の名前
  # 制約: AWS アカウント内で一意である必要があります
  # 例: "pause-cluster-nightly", "resize-cluster-weekend"
  name = "tf-redshift-scheduled-action"

  # description - スケジュールアクションの説明（オプション）
  # 説明: アクションの目的や動作を説明するテキスト
  # 例: "Pause cluster every night at 11 PM UTC to reduce costs"
  description = "Scheduled action to pause cluster nightly"

  # enable - スケジュールアクションの有効化（オプション）
  # 説明: アクションを有効にするかどうか
  # デフォルト: true
  # 注意: false に設定するとスケジュールは実行されません
  enable = true

  #======================================
  # スケジュール設定
  #======================================

  # schedule - アクションのスケジュール（必須）
  # 説明: cron式またはat式でスケジュールを定義
  # cron式の形式: cron(分 時 日 月 曜日 年)
  # - 分: 0-59
  # - 時: 0-23（UTC）
  # - 日: 1-31 または ?（任意の日）
  # - 月: 1-12 または JAN-DEC
  # - 曜日: 1-7 または SUN-SAT または ?（任意の曜日）
  # - 年: 1970-2199（オプション）
  #
  # at式の形式: at(YYYY-MM-DDTHH:MM:SS)
  # - 一度だけ実行する場合に使用
  #
  # 例:
  # - "cron(00 23 * * ? *)" - 毎日23:00 UTC
  # - "cron(0 10 ? * MON *)" - 毎週月曜日10:00 UTC
  # - "cron(0 0/2 * * ? *)" - 2時間ごと
  # - "at(2026-12-31T23:59:00)" - 2026年12月31日23:59 UTC
  #
  # 参考: https://docs.aws.amazon.com/redshift/latest/APIReference/API_ScheduledAction.html
  schedule = "cron(00 23 * * ? *)"

  # start_time - スケジュール開始時刻（オプション）
  # 説明: スケジュールが有効になる開始時刻（UTC、RFC3339形式）
  # 形式: YYYY-MM-DDTHH:MM:SSZ
  # 例: "2026-01-01T00:00:00Z"
  # 注意: 指定しない場合は即座に開始されます
  # start_time = "2026-01-01T00:00:00Z"

  # end_time - スケジュール終了時刻（オプション）
  # 説明: スケジュールが無効になる終了時刻（UTC、RFC3339形式）
  # 形式: YYYY-MM-DDTHH:MM:SSZ
  # 例: "2026-12-31T23:59:59Z"
  # 注意: 指定しない場合はスケジュールは永続的に実行されます
  # end_time = "2026-12-31T23:59:59Z"

  #======================================
  # IAM設定
  #======================================

  # iam_role - IAMロールARN（必須）
  # 説明: スケジュールアクションを実行するために使用するIAMロール
  # 要件:
  # - scheduler.redshift.amazonaws.com サービスからの AssumeRole を許可
  # - 必要なRedshift操作権限（PauseCluster、ResumeCluster、ResizeCluster等）
  # 形式: arn:aws:iam::123456789012:role/role-name
  # 例: aws_iam_role.redshift_scheduler.arn
  iam_role = aws_iam_role.example.arn

  #======================================
  # ターゲットアクション設定
  #======================================
  # 以下のいずれか1つを指定する必要があります:
  # - pause_cluster: クラスターを一時停止
  # - resume_cluster: クラスターを再開
  # - resize_cluster: クラスターをリサイズ

  target_action {
    #----------------------------------
    # オプション1: クラスター一時停止
    #----------------------------------
    # コスト削減のためにクラスターを一時停止します
    # 注意:
    # - 一時停止中はクエリを実行できません
    # - 最大30日間一時停止できます
    # - 一時停止中もスナップショットストレージは課金されます
    pause_cluster {
      # cluster_identifier - クラスター識別子（必須）
      # 説明: 一時停止するクラスターの識別子
      # 例: "my-redshift-cluster", aws_redshift_cluster.main.id
      cluster_identifier = "tf-redshift001"
    }

    #----------------------------------
    # オプション2: クラスター再開
    #----------------------------------
    # 一時停止中のクラスターを再開します
    # 注意: 再開には数分かかることがあります
    # resume_cluster {
    #   # cluster_identifier - クラスター識別子（必須）
    #   # 説明: 再開するクラスターの識別子
    #   # 例: "my-redshift-cluster", aws_redshift_cluster.main.id
    #   cluster_identifier = "tf-redshift001"
    # }

    #----------------------------------
    # オプション3: クラスターリサイズ
    #----------------------------------
    # クラスターのノードタイプやノード数を変更します
    # ユースケース:
    # - 業務時間に合わせてスケールアップ/ダウン
    # - トラフィックパターンに応じた最適化
    # resize_cluster {
    #   # cluster_identifier - クラスター識別子（必須）
    #   # 説明: リサイズするクラスターの識別子
    #   # 例: "my-redshift-cluster", aws_redshift_cluster.main.id
    #   cluster_identifier = "tf-redshift001"
    #
    #   # classic - クラシックリサイズの使用（オプション）
    #   # 説明: 従来のリサイズプロセスを使用するかどうか
    #   # デフォルト: false（エラスティックリサイズを使用）
    #   # 注意:
    #   # - エラスティックリサイズ: 数分で完了、一時的なダウンタイム
    #   # - クラシックリサイズ: 数時間かかる、クラスターは読み取り専用モード
    #   # classic = false
    #
    #   # cluster_type - クラスタータイプ（オプション）
    #   # 説明: 新しいクラスタータイプ
    #   # 値:
    #   # - "single-node": 単一ノードクラスター
    #   # - "multi-node": マルチノードクラスター
    #   # 注意: single-nodeからmulti-nodeへの変更、またはその逆が可能
    #   cluster_type = "multi-node"
    #
    #   # node_type - ノードタイプ（オプション）
    #   # 説明: 新しいノードタイプ
    #   # 例:
    #   # - dc2.large: 高密度コンピューティング、160GB SSD
    #   # - dc2.8xlarge: 高密度コンピューティング、2.56TB SSD
    #   # - ra3.xlplus: マネージドストレージ、32TB
    #   # - ra3.4xlarge: マネージドストレージ、128TB
    #   # - ra3.16xlarge: マネージドストレージ、128TB
    #   # 参考: https://aws.amazon.com/redshift/pricing/
    #   node_type = "dc2.large"
    #
    #   # number_of_nodes - ノード数（オプション）
    #   # 説明: 新しいノード数
    #   # 制約:
    #   # - single-node: 1のみ
    #   # - multi-node: 2以上（最大値はノードタイプによる）
    #   # 注意: ノード数を増やすとストレージ容量とコンピューティング能力が増加
    #   number_of_nodes = 2
    # }
  }

  #======================================
  # リージョン設定
  #======================================

  # region - AWSリージョン（オプション）
  # 説明: このリソースが管理されるリージョン
  # デフォルト: プロバイダー設定のリージョン
  # 例: "us-east-1", "ap-northeast-1"
  # 注意: クラスターと同じリージョンである必要があります
  # region = "us-east-1"
}

#======================================
# 出力
#======================================

# スケジュールアクションの名前を出力
output "redshift_scheduled_action_id" {
  description = "The Redshift Scheduled Action name"
  value       = aws_redshift_scheduled_action.example.id
}

#======================================
# 補足情報
#======================================

# IAMロールの例
# スケジュールアクションを実行するために必要なIAMロールとポリシーの例:
#
# data "aws_iam_policy_document" "assume_role" {
#   statement {
#     effect = "Allow"
#
#     principals {
#       type        = "Service"
#       identifiers = ["scheduler.redshift.amazonaws.com"]
#     }
#
#     actions = ["sts:AssumeRole"]
#   }
# }
#
# resource "aws_iam_role" "redshift_scheduler" {
#   name               = "redshift-scheduled-action-role"
#   assume_role_policy = data.aws_iam_policy_document.assume_role.json
# }
#
# data "aws_iam_policy_document" "redshift_scheduler" {
#   statement {
#     effect = "Allow"
#
#     actions = [
#       "redshift:PauseCluster",
#       "redshift:ResumeCluster",
#       "redshift:ResizeCluster",
#     ]
#
#     resources = ["*"]
#   }
# }
#
# resource "aws_iam_policy" "redshift_scheduler" {
#   name   = "redshift-scheduled-action-policy"
#   policy = data.aws_iam_policy_document.redshift_scheduler.json
# }
#
# resource "aws_iam_role_policy_attachment" "redshift_scheduler" {
#   policy_arn = aws_iam_policy.redshift_scheduler.arn
#   role       = aws_iam_role.redshift_scheduler.name
# }

#======================================
# 使用例
#======================================

# 例1: 夜間にクラスターを一時停止
# resource "aws_redshift_scheduled_action" "pause_nightly" {
#   name        = "pause-cluster-nightly"
#   description = "Pause cluster every night at 11 PM UTC"
#   schedule    = "cron(00 23 * * ? *)"
#   iam_role    = aws_iam_role.redshift_scheduler.arn
#
#   target_action {
#     pause_cluster {
#       cluster_identifier = aws_redshift_cluster.main.id
#     }
#   }
# }

# 例2: 朝にクラスターを再開
# resource "aws_redshift_scheduled_action" "resume_morning" {
#   name        = "resume-cluster-morning"
#   description = "Resume cluster every morning at 6 AM UTC"
#   schedule    = "cron(00 06 * * ? *)"
#   iam_role    = aws_iam_role.redshift_scheduler.arn
#
#   target_action {
#     resume_cluster {
#       cluster_identifier = aws_redshift_cluster.main.id
#     }
#   }
# }

# 例3: 週末にクラスターをスケールダウン
# resource "aws_redshift_scheduled_action" "scale_down_weekend" {
#   name        = "scale-down-weekend"
#   description = "Scale down cluster on Friday evening"
#   schedule    = "cron(00 18 ? * FRI *)"
#   iam_role    = aws_iam_role.redshift_scheduler.arn
#
#   target_action {
#     resize_cluster {
#       cluster_identifier = aws_redshift_cluster.main.id
#       cluster_type       = "multi-node"
#       node_type          = "dc2.large"
#       number_of_nodes    = 2
#     }
#   }
# }

# 例4: 月曜朝にクラスターをスケールアップ
# resource "aws_redshift_scheduled_action" "scale_up_monday" {
#   name        = "scale-up-monday"
#   description = "Scale up cluster on Monday morning"
#   schedule    = "cron(00 06 ? * MON *)"
#   iam_role    = aws_iam_role.redshift_scheduler.arn
#
#   target_action {
#     resize_cluster {
#       cluster_identifier = aws_redshift_cluster.main.id
#       cluster_type       = "multi-node"
#       node_type          = "dc2.8xlarge"
#       number_of_nodes    = 4
#     }
#   }
# }

# 例5: 期間限定のスケジュールアクション
# resource "aws_redshift_scheduled_action" "temporary_action" {
#   name        = "temporary-pause"
#   description = "Temporary scheduled action with start and end times"
#   schedule    = "cron(00 20 * * ? *)"
#   start_time  = "2026-01-01T00:00:00Z"
#   end_time    = "2026-03-31T23:59:59Z"
#   iam_role    = aws_iam_role.redshift_scheduler.arn
#
#   target_action {
#     pause_cluster {
#       cluster_identifier = aws_redshift_cluster.main.id
#     }
#   }
# }

#======================================
# ベストプラクティス
#======================================

# 1. IAM権限の最小化
#    - 必要な操作のみを許可するIAMポリシーを作成
#    - 特定のクラスターのARNを指定して権限を制限
#
# 2. スケジュールの最適化
#    - 業務時間外にクラスターを一時停止してコスト削減
#    - トラフィックパターンに基づいてリサイズを計画
#    - タイムゾーンに注意（スケジュールはUTC）
#
# 3. 監視とアラート
#    - CloudWatch Eventsでスケジュールアクションの実行を監視
#    - 失敗時のアラート設定を検討
#
# 4. テストとバリデーション
#    - 本番環境に適用する前にテスト環境で検証
#    - enable = false で作成してからテスト
#
# 5. ドキュメント化
#    - description フィールドにアクションの目的を明確に記載
#    - 命名規則を統一（例: {action}-{target}-{schedule}）
#
# 6. リサイズの考慮事項
#    - エラスティックリサイズを優先（高速、ダウンタイム最小）
#    - クラシックリサイズは大幅な変更時のみ使用
#    - リサイズ中のクエリパフォーマンスへの影響を考慮
#
# 7. コスト最適化
#    - 開発環境では夜間・週末の一時停止を検討
#    - 本番環境では予約インスタンスとの組み合わせを検討
#    - 一時停止は最大30日まで（それ以降は自動再開）

#======================================
# 注意事項
#======================================

# 1. スケジュールの制約
#    - スケジュールはUTCタイムゾーンで指定
#    - cron式の曜日フィールドは1（日曜）から7（土曜）
#    - 日と曜日の両方を指定する場合、一方は ? にする
#
# 2. クラスター状態の要件
#    - pause_cluster: クラスターが available 状態である必要があります
#    - resume_cluster: クラスターが paused 状態である必要があります
#    - resize_cluster: クラスターが available 状態である必要があります
#
# 3. 一時停止の制限
#    - 最大30日間一時停止可能（それ以降は自動的に再開）
#    - 一時停止中もスナップショットストレージは課金されます
#    - 一時停止中はクエリを実行できません
#
# 4. リサイズの制限
#    - すべてのノードタイプ間でリサイズできるわけではありません
#    - エラスティックリサイズには制約があります（互換性のあるノードタイプのみ）
#    - クラシックリサイズは数時間かかることがあります
#
# 5. IAMロールの要件
#    - scheduler.redshift.amazonaws.com からの AssumeRole を許可
#    - 必要なRedshift API操作権限を付与
#    - クラスターと同じリージョンにロールが存在する必要があります
#
# 6. インポート
#    - 既存のスケジュールアクションはインポート可能
#    - インポートコマンド: terraform import aws_redshift_scheduled_action.example action-name
#
# 7. 削除時の動作
#    - スケジュールアクションを削除してもクラスターには影響しません
#    - 実行中のアクションは完了まで継続されます

#======================================
# 関連リソース
#======================================

# - aws_redshift_cluster: Redshiftクラスター
# - aws_iam_role: IAMロール
# - aws_iam_policy: IAMポリシー
# - aws_cloudwatch_event_rule: CloudWatch Eventsルール（監視用）
