#---------------------------------------------------------------
# AWS Backup Restore Testing Plan
#---------------------------------------------------------------
#
# AWS Backupのリストアテスト計画をプロビジョニングするリソースです。
# リストアテスト計画は、バックアップからのリストアが正常に動作するかを
# 定期的かつ自動的に検証するための機能を提供します。
# 災害復旧（DR）戦略の重要なコンポーネントとして、バックアップの整合性検証、
# コンプライアンスレポートの自動化に活用できます。
#
# AWS公式ドキュメント:
#   - AWS Backup リストアテスト: https://docs.aws.amazon.com/aws-backup/latest/devguide/restore-testing.html
#   - CreateRestoreTestingPlan API: https://docs.aws.amazon.com/aws-backup/latest/devguide/API_CreateRestoreTestingPlan.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/backup_restore_testing_plan
#
# Provider Version: 6.28.0
# Generated: 2026-01-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_backup_restore_testing_plan" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required, Forces new resource)
  # 設定内容: リストアテスト計画の名前を指定します。
  # 設定可能な値: 英数字とアンダースコアのみで構成される文字列（最大50文字）
  # 注意: 作成後に変更することはできません。
  name = "example_restore_testing_plan"

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
  # スケジュール設定
  #-------------------------------------------------------------

  # schedule_expression (Required)
  # 設定内容: リストアテスト計画を実行するスケジュールをCRON式で指定します。
  # 設定可能な値: AWS標準のCRON式
  #   フォーマット: cron(分 時 日 月 曜日 年)
  #   - 分: 0-59
  #   - 時: 0-23
  #   - 日: 1-31
  #   - 月: 1-12 または JAN-DEC
  #   - 曜日: 1-7 または SUN-SAT
  #   - 年: 1970-2199 または * (任意)
  # 例:
  #   - cron(0 12 ? * * *): 毎日12:00 UTC
  #   - cron(0 5 ? * 1 *): 毎週日曜日05:00 UTC
  # 省略時のデフォルト: cron(0 5 ? * * *)（毎日05:00 UTC）
  schedule_expression = "cron(0 12 ? * * *)"

  # schedule_expression_timezone (Optional)
  # 設定内容: スケジュール式で使用するタイムゾーンを指定します。
  # 設定可能な値: IANAタイムゾーン名
  #   - "Etc/UTC" (デフォルト)
  #   - "Asia/Tokyo"
  #   - "America/New_York"
  #   - "Europe/London"
  # 省略時: Etc/UTC
  # 関連機能: タイムゾーン対応スケジューリング
  #   ローカルタイムゾーンでスケジュールを設定可能。
  #   夏時間の切り替えにも対応します。
  schedule_expression_timezone = "Asia/Tokyo"

  # start_window_hours (Optional)
  # 設定内容: リストアテストジョブの開始ウィンドウを時間単位で指定します。
  # 設定可能な値: 1-168（1時間から1週間）
  # 省略時: 24（24時間）
  # 関連機能: 開始ウィンドウ
  #   スケジュールされた時刻から指定時間内にジョブが開始しない場合、
  #   そのジョブはキャンセルされます。AWS Backupはこの期間内で
  #   開始時刻をランダム化してベストエフォートで実行します。
  #   復旧ポイントの数やリストアにかかる時間を考慮して設定してください。
  start_window_hours = 24

  #-------------------------------------------------------------
  # 復旧ポイント選択設定
  #-------------------------------------------------------------

  # recovery_point_selection (Required)
  # 設定内容: テスト対象の復旧ポイントを選択するための条件を指定します。
  recovery_point_selection {
    # algorithm (Required)
    # 設定内容: 復旧ポイントの選択アルゴリズムを指定します。
    # 設定可能な値:
    #   - "LATEST_WITHIN_WINDOW": 指定期間内の最新の復旧ポイントを選択
    #   - "RANDOM_WITHIN_WINDOW": 指定期間内からランダムに復旧ポイントを選択
    # 使い分け:
    #   - LATEST_WITHIN_WINDOW: 最新のバックアップの整合性を確認したい場合
    #   - RANDOM_WITHIN_WINDOW: 過去のバックアップの一般的な健全性を確認したい場合
    algorithm = "LATEST_WITHIN_WINDOW"

    # include_vaults (Required)
    # 設定内容: テスト対象に含めるバックアップボールトを指定します。
    # 設定可能な値:
    #   - ["*"]: すべてのボールトを含める
    #   - ボールトARNまたは名前のリスト: 特定のボールトのみを含める
    # 例:
    #   - ["*"]
    #   - ["arn:aws:backup:ap-northeast-1:123456789012:backup-vault:Default"]
    #   - ["my-backup-vault-1", "my-backup-vault-2"]
    include_vaults = ["*"]

    # exclude_vaults (Optional)
    # 設定内容: テスト対象から除外するバックアップボールトを指定します。
    # 設定可能な値: ボールトARNまたは名前のセット
    # 省略時: 空（除外なし）
    # 注意: include_vaultsで["*"]を指定した場合に、特定のボールトを
    #       除外するために使用します。
    exclude_vaults = []

    # recovery_point_types (Required)
    # 設定内容: テスト対象の復旧ポイントタイプを指定します。
    # 設定可能な値:
    #   - "CONTINUOUS": 継続的バックアップ（ポイントインタイムリカバリ/PITR対応）
    #   - "SNAPSHOT": スナップショットバックアップ
    # 注意: 対象リソースタイプによってサポートされるタイプが異なります。
    #       Aurora、DynamoDB、S3などはCONTINUOUS（PITR）をサポート。
    #       - https://docs.aws.amazon.com/aws-backup/latest/devguide/backup-feature-availability.html#features-by-resource
    recovery_point_types = ["CONTINUOUS", "SNAPSHOT"]

    # selection_window_days (Optional)
    # 設定内容: 復旧ポイントを選択する期間を日数で指定します。
    # 設定可能な値: 1-365（日）
    # 省略時: 30（30日間）
    # 関連機能: 復旧ポイント選択期間
    #   この日数以内に作成された復旧ポイントが選択対象となります。
    #   algorithmの設定に基づき、この期間内から最新またはランダムに選択されます。
    selection_window_days = 30
  }

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ（最大50個）
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "example-restore-testing-plan"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: リストアテスト計画のAmazon Resource Name (ARN)
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
