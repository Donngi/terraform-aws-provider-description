# ============================================================
# AWS QuickSight Refresh Schedule
# ============================================================
# リソース: aws_quicksight_refresh_schedule
# プロバイダーバージョン: 6.28.0
#
# 用途:
#   Amazon QuickSightデータセットのリフレッシュスケジュールを管理します。
#   データセットの自動更新を定期的に実行するためのスケジュールを設定できます。
#
# 主な機能:
#   - データセットの完全更新(FULL_REFRESH)または増分更新(INCREMENTAL_REFRESH)の設定
#   - 15分、30分、1時間、日次、週次、月次の更新間隔をサポート
#   - タイムゾーンと更新時刻の細かい制御
#   - 週次・月次スケジュールでの特定曜日・日付の指定
#
# ユースケース:
#   - ビジネスインテリジェンスダッシュボードのデータ鮮度維持
#   - データウェアハウスからの定期的なデータ同期
#   - リアルタイムに近いデータ分析（15分間隔更新）
#   - 営業時間前の日次データ更新（例: 毎朝1時）
#
# 注意事項:
#   - data_set_id、schedule_id、aws_account_idの変更は新しいリソースを作成します（Forces new resource）
#   - MINUTE15間隔は1つのデータセットにつき1つのスケジュールのみ設定可能
#   - 時間指定更新（hourly以外）にはtime_of_the_dayの指定が必要
#   - タイムゾーンはjava.util.time.getAvailableIDs()と一致する必要があります
#
# 参考資料:
#   - https://docs.aws.amazon.com/quicksight/latest/APIReference/API_RefreshSchedule.html
#   - https://docs.aws.amazon.com/quicksight/latest/APIReference/API_RefreshFrequency.html
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/quicksight_refresh_schedule
# ============================================================

# ------------------------------------------------------------
# 基本的な使用例: 1時間ごとの完全更新
# ------------------------------------------------------------
# 説明:
#   最もシンプルな設定例です。データセット全体を1時間ごとに更新します。
#   時刻指定なしで継続的に更新されます。
#
# ユースケース:
#   - リアルタイムに近いダッシュボード更新が必要な場合
#   - データソースが頻繁に更新される場合
resource "aws_quicksight_refresh_schedule" "hourly_full_refresh" {
  # (必須) データセットID
  # Forces new resource: この値を変更すると新しいリソースが作成されます
  # 既存のQuickSightデータセットのIDを指定します
  data_set_id = "example-dataset-id"

  # (必須) スケジュールID
  # Forces new resource: この値を変更すると新しいリソースが作成されます
  # このリフレッシュスケジュールを識別する一意のIDです
  schedule_id = "hourly-refresh-schedule"

  # (オプション) AWSアカウントID
  # Forces new resource: この値を変更すると新しいリソースが作成されます
  # デフォルト: TerraformプロバイダーのアカウントIDを自動的に使用
  # 明示的に指定する場合のみ記述してください
  # aws_account_id = "123456789012"

  # (必須) リフレッシュスケジュール設定
  schedule {
    # (必須) リフレッシュタイプ
    # 有効な値:
    #   - INCREMENTAL_REFRESH: 変更されたデータのみを更新（高速、リソース効率的）
    #   - FULL_REFRESH: データセット全体を完全に更新（完全性保証）
    #
    # 選択基準:
    #   - データソースが追加のみ（削除・更新なし）→ INCREMENTAL_REFRESH推奨
    #   - データの整合性が最優先 → FULL_REFRESH推奨
    #   - 大規模データセットで更新時間を短縮したい → INCREMENTAL_REFRESH推奨
    refresh_type = "FULL_REFRESH"

    # (オプション) スケジュール頻度設定
    schedule_frequency {
      # (必須) 更新間隔
      # 有効な値:
      #   - MINUTE15: 15分ごと（1データセットにつき1スケジュールのみ）
      #   - MINUTE30: 30分ごと
      #   - HOURLY: 1時間ごと
      #   - DAILY: 1日1回
      #   - WEEKLY: 週1回
      #   - MONTHLY: 月1回
      #
      # 注意:
      #   - HOURLYの場合、time_of_the_dayは不要です
      #   - DAILY/WEEKLY/MONTHLYの場合、time_of_the_dayを指定してください
      interval = "HOURLY"

      # (オプション) 更新時刻（HH:MM形式）
      # hourly更新の場合は不要です
      # 例: "01:00", "14:30", "23:45"
      # time_of_the_day = "01:00"

      # (オプション) タイムゾーン
      # java.util.time.getAvailableIDs()と一致する必要があります
      # 例: "America/New_York", "Europe/London", "Asia/Tokyo"
      # timezone = "UTC"
    }
  }
}

# ------------------------------------------------------------
# 週次更新の例: 毎週月曜日の深夜1時に増分更新
# ------------------------------------------------------------
# 説明:
#   週に1回、特定の曜日の特定時刻にデータセットを増分更新します。
#   増分更新により、変更されたデータのみを効率的に更新します。
#
# ユースケース:
#   - 週次レポートのための定期更新
#   - サーバー負荷の低い時間帯での更新実行
#   - 週単位で集計されるビジネスメトリクス
resource "aws_quicksight_refresh_schedule" "weekly_incremental" {
  data_set_id = "example-dataset-id"
  schedule_id = "weekly-refresh-schedule"

  schedule {
    # 増分更新: 変更されたデータのみを更新
    # データソースが追加・更新・削除をサポートする必要があります
    refresh_type = "INCREMENTAL_REFRESH"

    schedule_frequency {
      # 週次更新
      interval = "WEEKLY"

      # 深夜1時に更新（24時間表記）
      # データベースやシステムの負荷が低い時間帯を選択することを推奨
      time_of_the_day = "01:00"

      # ロンドンタイムゾーン
      # ビジネスの主要拠点や対象ユーザーのタイムゾーンに合わせてください
      # 夏時間(DST)の自動調整も考慮されます
      timezone = "Europe/London"

      # (オプション) 更新日の指定
      # WEEKLY/MONTHLY間隔で必要です
      refresh_on_day {
        # (オプション) 更新する曜日
        # 有効な値: SUNDAY, MONDAY, TUESDAY, WEDNESDAY, THURSDAY, FRIDAY, SATURDAY
        #
        # 選択基準:
        #   - 週次レポート提出日の前日 → その前日を選択
        #   - 週初めのデータ確認 → MONDAY推奨
        #   - 週末のデータ処理 → SUNDAY推奨
        day_of_week = "MONDAY"

        # 注意: day_of_weekとday_of_monthは排他的です
        # WEEKLYの場合はday_of_week、MONTHLYの場合はday_of_monthを使用
      }
    }
  }
}

# ------------------------------------------------------------
# 月次更新の例: 毎月1日の深夜1時に増分更新
# ------------------------------------------------------------
# 説明:
#   月に1回、特定の日の特定時刻にデータセットを更新します。
#   月次レポートや月末処理後のデータ更新に適しています。
#
# ユースケース:
#   - 月次経営レポート用のデータ更新
#   - 月末締め後のデータ同期
#   - 月次KPIダッシュボードの更新
resource "aws_quicksight_refresh_schedule" "monthly_refresh" {
  data_set_id = "example-dataset-id"
  schedule_id = "monthly-refresh-schedule"

  schedule {
    refresh_type = "INCREMENTAL_REFRESH"

    schedule_frequency {
      # 月次更新
      interval = "MONTHLY"

      # 深夜1時に更新
      time_of_the_day = "01:00"

      # タイムゾーン指定
      timezone = "Europe/London"

      refresh_on_day {
        # (オプション) 更新する日（月内の日付）
        # 有効な値: "1" ～ "31"の文字列
        #
        # 注意事項:
        #   - 31日が存在しない月（2月、4月、6月、9月、11月）では
        #     その月の最終日に実行されます
        #   - 月初め（1日）や月末（28-31日）の指定が一般的です
        #
        # 選択基準:
        #   - 月次レポート作成日程に合わせる
        #   - 会計締め日の翌日を選択
        #   - 給与計算など定期バッチ処理の後に設定
        day_of_month = "1"

        # 注意: day_of_monthとday_of_weekは排他的です
      }
    }
  }
}

# ------------------------------------------------------------
# 日次更新の例: 毎日午前2時に完全更新
# ------------------------------------------------------------
# 説明:
#   毎日決まった時刻にデータセット全体を完全更新します。
#   データの整合性が重要な場合に適しています。
#
# ユースケース:
#   - 日次ダッシュボードの営業開始前更新
#   - ETLパイプライン完了後のデータ同期
#   - 日次集計データの反映
resource "aws_quicksight_refresh_schedule" "daily_full_refresh" {
  data_set_id = "example-dataset-id"
  schedule_id = "daily-refresh-schedule"

  schedule {
    # 完全更新: データセット全体を毎回更新
    # データの整合性が保証されます
    refresh_type = "FULL_REFRESH"

    schedule_frequency {
      # 日次更新
      interval = "DAILY"

      # 午前2時に更新
      # 一般的にデータベース負荷が低く、ETL処理が完了している時間帯
      time_of_the_day = "02:00"

      # 東京タイムゾーン
      # 日本のビジネス時間に合わせた設定例
      timezone = "Asia/Tokyo"

      # 注意: DAILY更新ではrefresh_on_dayは不要です
      # refresh_on_dayはWEEKLY/MONTHLYのみで使用します
    }
  }
}

# ------------------------------------------------------------
# 高頻度更新の例: 15分ごとの増分更新
# ------------------------------------------------------------
# 説明:
#   最も高頻度な15分間隔でデータセットを増分更新します。
#   リアルタイムに近いデータ分析を実現します。
#
# 重要な制限:
#   - MINUTE15間隔は1つのデータセットにつき1つのスケジュールのみ設定可能
#   - 他の頻度のスケジュールと併用できません
#
# ユースケース:
#   - リアルタイムダッシュボード（IoTデータ、株価、トラフィック等）
#   - 緊急性の高いビジネスメトリクスの監視
#   - オペレーションセンターのモニタリング画面
resource "aws_quicksight_refresh_schedule" "high_frequency_refresh" {
  data_set_id = "example-dataset-id"
  schedule_id = "15min-refresh-schedule"

  schedule {
    # 増分更新推奨: 15分ごとの完全更新は負荷が高すぎる可能性があります
    refresh_type = "INCREMENTAL_REFRESH"

    schedule_frequency {
      # 15分間隔更新
      # 制限: このデータセットに対して他のスケジュールを設定できません
      #
      # 注意事項:
      #   - データソースとネットワークの帯域幅に十分な余裕があることを確認
      #   - QuickSightの同時更新制限を考慮
      #   - コスト影響を事前に評価（API呼び出し回数増加）
      interval = "MINUTE15"

      # MINUTE15とMINUTE30、HOURLYの場合、time_of_the_dayは不要
      # これらの間隔では継続的に更新が実行されます
    }
  }
}

# ------------------------------------------------------------
# 30分ごとの更新例: ビジネスアワー内の準リアルタイム更新
# ------------------------------------------------------------
# 説明:
#   30分間隔でデータセットを更新します。
#   15分間隔より負荷が低く、1時間間隔より頻繁な更新が可能です。
#
# ユースケース:
#   - 営業時間内のセールスダッシュボード
#   - カスタマーサポートメトリクスの監視
#   - 在庫状況のリアルタイム追跡
resource "aws_quicksight_refresh_schedule" "half_hourly_refresh" {
  data_set_id = "example-dataset-id"
  schedule_id = "30min-refresh-schedule"

  schedule {
    refresh_type = "INCREMENTAL_REFRESH"

    schedule_frequency {
      # 30分間隔更新
      # 15分より負荷が低く、hourlyより頻繁な更新のバランスが良い選択
      interval = "MINUTE30"

      # 30分間隔でもtime_of_the_dayは不要です
      # 継続的に30分ごとに更新が実行されます
    }
  }
}

# ------------------------------------------------------------
# 開始日時指定の例: 将来の特定日時から開始するスケジュール
# ------------------------------------------------------------
# 説明:
#   スケジュールの開始日時を指定して、将来の特定時刻から
#   定期更新を開始します。
#
# ユースケース:
#   - 新サービス開始日に合わせた更新開始
#   - データマイグレーション完了後の自動更新
#   - 季節性ビジネスの開始時期に合わせた更新
resource "aws_quicksight_refresh_schedule" "scheduled_start" {
  data_set_id = "example-dataset-id"
  schedule_id = "future-start-schedule"

  schedule {
    refresh_type = "FULL_REFRESH"

    # (オプション) スケジュール開始日時
    # RFC3339形式で指定します
    # この日時以降に最初の更新が実行されます
    #
    # 使用例:
    #   - プロジェクト開始日に合わせる
    #   - データソース準備完了日時を指定
    #   - メンテナンスウィンドウ後に開始
    start_after_date_time = "2024-01-01T00:00:00Z"

    schedule_frequency {
      interval        = "DAILY"
      time_of_the_day = "03:00"
      timezone        = "UTC"
    }
  }
}

# ============================================================
# 出力値（Outputs）
# ============================================================
# リソースから取得可能な属性値の例

# ARN（Amazon Resource Name）
# リフレッシュスケジュールを一意に識別するARN
# 他のAWSサービスやIAMポリシーで参照する際に使用
output "refresh_schedule_arn" {
  description = "The ARN of the QuickSight refresh schedule"
  value       = aws_quicksight_refresh_schedule.hourly_full_refresh.arn
}

# ID（リソース識別子）
# フォーマット: "AWSアカウントID,データセットID,スケジュールID"
# カンマ区切りの複合キー
output "refresh_schedule_id" {
  description = "The ID of the QuickSight refresh schedule (format: account_id,dataset_id,schedule_id)"
  value       = aws_quicksight_refresh_schedule.hourly_full_refresh.id
}

# ============================================================
# 補足情報
# ============================================================
#
# リフレッシュタイプの選択ガイド:
#
# FULL_REFRESH（完全更新）を選択すべき場合:
#   - データの完全性と整合性が最優先
#   - データセットが比較的小さい（数GB以下）
#   - 削除されたレコードを確実に反映する必要がある
#   - データソースで増分更新がサポートされていない
#   - 月次・週次など低頻度の更新
#
# INCREMENTAL_REFRESH（増分更新）を選択すべき場合:
#   - 大規模データセット（数十GB以上）
#   - 高頻度更新（hourly以上）
#   - データソースが追加・更新のタイムスタンプをサポート
#   - コスト削減とパフォーマンス向上を優先
#   - データは主に追加のみで削除が少ない
#
# 更新間隔の選択ガイド:
#
# MINUTE15/MINUTE30:
#   - リアルタイムに近いデータが必要
#   - 高いコストと負荷を許容できる
#   - データソースとネットワークに十分な容量がある
#
# HOURLY:
#   - 準リアルタイムデータが必要
#   - コストとパフォーマンスのバランスが良い
#   - 営業時間内の定期更新
#
# DAILY:
#   - 日次レポート用途
#   - 営業開始前のデータ更新
#   - 標準的なビジネスダッシュボード
#
# WEEKLY:
#   - 週次レポート用途
#   - データ変更頻度が低い
#   - 長期トレンド分析
#
# MONTHLY:
#   - 月次レポート用途
#   - 経営ダッシュボード
#   - データ変更頻度が非常に低い
#
# タイムゾーンの考慮事項:
#   - ビジネスの主要拠点のタイムゾーンを使用
#   - 夏時間(DST)の自動調整を考慮
#   - グローバルチームの場合はUTCの使用を検討
#   - ユーザーの営業時間前に更新が完了するよう設定
#
# ベストプラクティス:
#   1. 本番環境適用前にテスト環境で動作確認
#   2. データソースの負荷パターンを考慮した時刻設定
#   3. QuickSightの同時更新制限を確認
#   4. 更新失敗時のアラート設定（CloudWatch等）
#   5. コスト監視の設定（AWS Cost Explorer）
#   6. データセットサイズに応じた適切なrefresh_typeの選択
#   7. 定期的なスケジュール見直しと最適化
#
# リソース削除時の注意:
#   - スケジュールを削除してもデータセット自体は削除されません
#   - 削除後は自動更新が停止します
#   - 手動での更新は引き続き可能です
#
# トラブルシューティング:
#   - 更新失敗 → CloudWatch Logsで詳細確認
#   - タイムアウト → データセットサイズの削減またはINCREMENTAL_REFRESHへ変更
#   - アクセス拒否 → IAMロールの権限確認
#   - 無効なパラメータ → タイムゾーン文字列の確認
#
# コスト最適化:
#   - 不要な高頻度更新を避ける
#   - ピーク時間外の更新スケジュール設定
#   - INCREMENTAL_REFRESHの活用
#   - 複数データセットの更新時刻を分散
#
# セキュリティ考慮事項:
#   - データセットへのアクセス権限を最小限に制限
#   - IAMロールを使用した適切な権限設定
#   - VPC内のデータソース接続時は適切なネットワーク設定
#   - 監査ログの有効化（CloudTrail）
#
# 制限事項:
#   - MINUTE15間隔は1データセットにつき1スケジュールのみ
#   - 同時に実行できる更新数には制限があります
#   - データセットサイズによって更新時間が変動します
#   - タイムゾーンはJavaのタイムゾーンIDと一致する必要があります
#
# 関連リソース:
#   - aws_quicksight_data_set: データセットの定義
#   - aws_quicksight_data_source: データソースの設定
#   - aws_iam_role: QuickSightサービスロール
#   - aws_cloudwatch_event_rule: カスタムトリガー設定（補完的）
#
# 参考ドキュメント:
#   - Terraform AWS Provider: aws_quicksight_refresh_schedule
#   - AWS QuickSight API: RefreshSchedule
#   - AWS QuickSight API: RefreshFrequency
#   - AWS QuickSight User Guide: Refreshing Data
#   - AWS QuickSight API: CreateRefreshSchedule
#   - AWS QuickSight API: UpdateRefreshSchedule
#
# ============================================================
