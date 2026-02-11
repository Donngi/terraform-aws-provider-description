#---------------------------------------------------------------
# AWS DataSync Task
#---------------------------------------------------------------
#
# AWS DataSync タスクを管理するリソースです。
# DataSync タスクは、ソースとデスティネーション間のデータ同期設定を表します。
# このリソースはタスクの設定を管理しますが、実際の同期実行（タスク実行）は
# 別途トリガーする必要があります。
#
# AWS公式ドキュメント:
#   - DataSync タスク作成: https://docs.aws.amazon.com/datasync/latest/userguide/create-task-how-to.html
#   - タスクオプション: https://docs.aws.amazon.com/datasync/latest/userguide/API_Options.html
#   - メタデータ設定: https://docs.aws.amazon.com/datasync/latest/userguide/configure-metadata.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/datasync_task
#
# Provider Version: 6.28.0
# Generated: 2026-01-22
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_datasync_task" "example" {
  #-------------------------------------------------------------
  # 必須設定
  #-------------------------------------------------------------

  # destination_location_arn (Required)
  # 設定内容: デスティネーション DataSync ロケーションの ARN を指定します。
  # 設定可能な値: 有効な DataSync ロケーション ARN
  # 関連機能: データ転送先
  #   S3、EFS、FSx、NFS、SMB などのロケーションを指定できます。
  destination_location_arn = aws_datasync_location_s3.destination.arn

  # source_location_arn (Required)
  # 設定内容: ソース DataSync ロケーションの ARN を指定します。
  # 設定可能な値: 有効な DataSync ロケーション ARN
  # 関連機能: データ転送元
  #   S3、EFS、FSx、NFS、SMB などのロケーションを指定できます。
  source_location_arn = aws_datasync_location_nfs.source.arn

  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Optional)
  # 設定内容: DataSync タスクの名前を指定します。
  # 設定可能な値: 任意の文字列
  # 省略時: AWS が自動生成します。
  name = "example-datasync-task"

  # cloudwatch_log_group_arn (Optional)
  # 設定内容: 同期タスクの監視とログ記録に使用する CloudWatch ロググループの ARN を指定します。
  # 設定可能な値: 有効な CloudWatch ロググループ ARN
  # 関連機能: DataSync ログ記録
  #   タスク実行の詳細なログを CloudWatch Logs に出力します。
  cloudwatch_log_group_arn = aws_cloudwatch_log_group.datasync.arn

  # task_mode (Optional)
  # 設定内容: データ転送のタスクモードを指定します。
  # 設定可能な値:
  #   - "BASIC" (デフォルト): AWS ストレージとオンプレミス、エッジ、
  #     または他のクラウドストレージ間でファイルやオブジェクトを転送します。
  #   - "ENHANCED": 拡張メトリクス、詳細ログ、Basic モードより高いパフォーマンスで
  #     仮想的に無制限のオブジェクトを転送します。
  #     現在は Amazon S3 ロケーション間の転送で利用可能です。
  task_mode = "BASIC"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効な AWS リージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: DataSync タスクに割り当てるタグを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWS リソースタグ付け
  #   プロバイダーレベルの default_tags 設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "example-datasync-task"
    Environment = "production"
  }

  # tags_all (Optional, Computed)
  # 設定内容: プロバイダーの default_tags から継承されたタグを含む全タグのマップです。
  # 注意: 通常は明示的に設定せず、Terraform が自動計算します。
  # tags_all = {}

  #-------------------------------------------------------------
  # excludes ブロック (Optional)
  # タスクから除外するファイルを決定するフィルタールールを指定します。
  #-------------------------------------------------------------

  excludes {
    # filter_type (Optional)
    # 設定内容: 適用するフィルタールールのタイプを指定します。
    # 設定可能な値:
    #   - "SIMPLE_PATTERN": シンプルパターンでフィルタリング
    filter_type = "SIMPLE_PATTERN"

    # value (Optional)
    # 設定内容: 除外するパターンの文字列を指定します。
    # 設定可能な値: パイプ（|）で区切られたパターン文字列
    # 例: "/folder1|/folder2" - folder1 と folder2 を除外
    value = "/temp|/cache"
  }

  #-------------------------------------------------------------
  # includes ブロック (Optional)
  # タスクに含めるファイルを決定するフィルタールールを指定します。
  #-------------------------------------------------------------

  includes {
    # filter_type (Optional)
    # 設定内容: 適用するフィルタールールのタイプを指定します。
    # 設定可能な値:
    #   - "SIMPLE_PATTERN": シンプルパターンでフィルタリング
    filter_type = "SIMPLE_PATTERN"

    # value (Optional)
    # 設定内容: 含めるパターンの文字列を指定します。
    # 設定可能な値: パイプ（|）で区切られたパターン文字列
    # 例: "/data|/logs" - data と logs のみを含める
    value = "/important-data"
  }

  #-------------------------------------------------------------
  # options ブロック (Optional)
  # DataSync タスク実行時のデフォルト動作を制御するオプションを指定します。
  # 個々のタスク実行時に上書きすることも可能です。
  # 参考: https://docs.aws.amazon.com/datasync/latest/userguide/API_Options.html
  #-------------------------------------------------------------

  options {
    # atime (Optional)
    # 設定内容: ファイルのアクセス時刻（atime）の取り扱いを指定します。
    # 設定可能な値:
    #   - "BEST_EFFORT" (デフォルト): 元の atime を可能な限り保持
    #   - "NONE": atime を保持しない
    atime = "BEST_EFFORT"

    # bytes_per_second (Optional)
    # 設定内容: 帯域幅の制限値（バイト/秒）を指定します。
    # 設定可能な値:
    #   - -1 (デフォルト): 無制限
    #   - 1 以上の整数: 指定したバイト/秒に制限
    # 例: 1048576 を設定すると 1 MB/秒に制限
    # 参考: https://docs.aws.amazon.com/datasync/latest/userguide/configure-bandwidth.html
    bytes_per_second = -1

    # gid (Optional)
    # 設定内容: ファイル所有者のグループ ID の取り扱いを指定します。
    # 設定可能な値:
    #   - "BOTH": 名前と数値の両方を保持
    #   - "INT_VALUE" (デフォルト): ID の数値を保持
    #   - "NAME": グループ名を保持
    #   - "NONE": グループ情報を保持しない
    gid = "INT_VALUE"

    # log_level (Optional)
    # 設定内容: CloudWatch ロググループに公開するログのタイプを指定します。
    # 設定可能な値:
    #   - "OFF" (デフォルト): ログを出力しない
    #   - "BASIC": 基本的なログを出力（エラーとサマリー）
    #   - "TRANSFER": 転送されたファイルの詳細ログを出力
    log_level = "BASIC"

    # mtime (Optional)
    # 設定内容: ファイルの最終変更時刻（mtime）の取り扱いを指定します。
    # 設定可能な値:
    #   - "NONE": mtime を保持しない
    #   - "PRESERVE" (デフォルト): 元の mtime を保持
    mtime = "PRESERVE"

    # object_tags (Optional)
    # 設定内容: オブジェクトストレージ間転送時のオブジェクトタグの取り扱いを指定します。
    # 設定可能な値:
    #   - "PRESERVE" (デフォルト): オブジェクトタグを保持
    #   - "NONE": オブジェクトタグを無視
    object_tags = "PRESERVE"

    # overwrite_mode (Optional)
    # 設定内容: デスティネーションのファイルを上書きするかを指定します。
    # 設定可能な値:
    #   - "ALWAYS" (デフォルト): 常に上書き
    #   - "NEVER": 上書きしない（既存ファイルを保持）
    overwrite_mode = "ALWAYS"

    # posix_permissions (Optional)
    # 設定内容: POSIX パーミッションの取り扱いを指定します。
    # 設定可能な値:
    #   - "NONE": パーミッションを保持しない
    #   - "PRESERVE" (デフォルト): パーミッションを保持
    posix_permissions = "PRESERVE"

    # preserve_deleted_files (Optional)
    # 設定内容: ソースで削除されたファイルをデスティネーションで保持するかを指定します。
    # 設定可能な値:
    #   - "PRESERVE" (デフォルト): デスティネーションのファイルを保持
    #   - "REMOVE": デスティネーションからも削除
    preserve_deleted_files = "PRESERVE"

    # preserve_devices (Optional)
    # 設定内容: ブロックデバイス・キャラクターデバイスのメタデータを保持するかを指定します。
    # 設定可能な値:
    #   - "NONE" (デフォルト): 特殊デバイスを無視
    #   - "PRESERVE": デバイス名とメタデータを保持して再作成
    # 注意: デバイスの実際の内容は同期されません（EOF マーカーを返さないため）
    preserve_devices = "NONE"

    # security_descriptor_copy_flags (Optional)
    # 設定内容: SMB セキュリティ記述子のコピー対象を指定します。
    # 設定可能な値:
    #   - "NONE": セキュリティ記述子をコピーしない
    #   - "OWNER_DACL" (デフォルト): 所有者と DACL をコピー
    #   - "OWNER_DACL_SACL": 所有者、DACL、SACL をコピー
    # 対象: SMB と Amazon FSx for Windows File Server 間の転送、
    #       または 2 つの FSx for Windows File Server 間の転送のみ有効
    security_descriptor_copy_flags = "OWNER_DACL"

    # task_queueing (Optional)
    # 設定内容: タスク実行前にキューイングするかを指定します。
    # 設定可能な値:
    #   - "ENABLED" (デフォルト): タスクをキューに入れる
    #   - "DISABLED": キューイングを無効化
    task_queueing = "ENABLED"

    # transfer_mode (Optional)
    # 設定内容: データ転送モードを指定します。
    # 設定可能な値:
    #   - "CHANGED" (デフォルト): 変更されたデータとメタデータのみ転送
    #   - "ALL": すべてのコンテンツを転送（比較なし）
    transfer_mode = "CHANGED"

    # uid (Optional)
    # 設定内容: ファイル所有者のユーザー ID の取り扱いを指定します。
    # 設定可能な値:
    #   - "BOTH": 名前と数値の両方を保持
    #   - "INT_VALUE" (デフォルト): ID の数値を保持
    #   - "NAME": ユーザー名を保持
    #   - "NONE": ユーザー情報を保持しない
    uid = "INT_VALUE"

    # verify_mode (Optional)
    # 設定内容: タスク実行終了時のデータ整合性検証方法を指定します。
    # 設定可能な値:
    #   - "NONE": 検証しない
    #   - "POINT_IN_TIME_CONSISTENT" (デフォルト): ポイントインタイム整合性検証
    #   - "ONLY_FILES_TRANSFERRED": 転送されたファイルのみ検証
    verify_mode = "POINT_IN_TIME_CONSISTENT"
  }

  #-------------------------------------------------------------
  # schedule ブロック (Optional)
  # ソースからデスティネーションへの定期的なファイル転送スケジュールを指定します。
  #-------------------------------------------------------------

  schedule {
    # schedule_expression (Required)
    # 設定内容: タスク実行のスケジュール式を指定します。
    # 設定可能な値: CloudWatch Events のスケジュール式
    # 例:
    #   - "rate(1 hour)": 1時間ごとに実行
    #   - "cron(0 12 * * ? *)": 毎日 12:00 UTC に実行
    # 参考: https://docs.aws.amazon.com/AmazonCloudWatch/latest/events/ScheduledEvents.html
    schedule_expression = "rate(1 hour)"
  }

  #-------------------------------------------------------------
  # task_report_config ブロック (Optional)
  # DataSync タスクレポートの設定を指定します。
  # タスク実行後に転送結果のレポートを S3 に出力できます。
  #-------------------------------------------------------------

  task_report_config {
    # output_type (Optional)
    # 設定内容: タスクレポートのタイプを指定します。
    # 設定可能な値:
    #   - "SUMMARY_ONLY": サマリーのみ
    #   - "STANDARD": 標準レポート（詳細情報を含む）
    output_type = "STANDARD"

    # report_level (Optional)
    # 設定内容: レポートに含める内容のレベルを指定します。
    # 設定可能な値:
    #   - "ERRORS_ONLY": エラーのみをレポート
    #   - "SUCCESSES_AND_ERRORS": 成功と失敗の両方をレポート
    report_level = "SUCCESSES_AND_ERRORS"

    # s3_object_versioning (Optional)
    # 設定内容: S3 バケットのバージョニング有効時に新しいバージョンを含めるかを指定します。
    # 設定可能な値:
    #   - "INCLUDE": 新しいバージョンをレポートに含める
    #   - "NONE": バージョン情報を含めない
    # 注意: INCLUDE を設定するとタスク実行時間が長くなる可能性があります。
    s3_object_versioning = "NONE"

    # s3_destination ブロック (Required)
    # DataSync がタスクレポートをアップロードする S3 バケットの設定を指定します。
    s3_destination {
      # bucket_access_role_arn (Required)
      # 設定内容: DataSync が S3 バケットにレポートをアップロードするための IAM ポリシーの ARN を指定します。
      # 設定可能な値: 有効な IAM ロール ARN
      bucket_access_role_arn = aws_iam_role.datasync_report.arn

      # s3_bucket_arn (Required)
      # 設定内容: DataSync がレポートをアップロードする S3 バケットの ARN を指定します。
      # 設定可能な値: 有効な S3 バケット ARN
      s3_bucket_arn = aws_s3_bucket.datasync_reports.arn

      # subdirectory (Optional)
      # 設定内容: レポートのバケットプレフィックスを指定します。
      # 設定可能な値: 任意の文字列（パスプレフィックス）
      # 省略時: バケットのルートに保存
      subdirectory = "reports/"
    }

    # report_overrides ブロック (Optional)
    # タスクレポートの各アスペクトのレポートレベルを個別に上書きします。
    # 注意: report_level と同じ値を設定すると、毎回変更として検出されます。
    #       report_level とは異なる値を設定する場合にのみ使用してください。
    report_overrides {
      # deleted_override (Optional)
      # 設定内容: デスティネーションで削除を試みたファイル/オブジェクト/ディレクトリのレポートレベルを指定します。
      # 設定可能な値:
      #   - "ERRORS_ONLY": エラーのみ
      #   - "SUCCESSES_AND_ERRORS": 成功と失敗の両方
      # 対象: デスティネーションにないソースのデータを削除するよう設定したタスクにのみ適用
      deleted_override = "ERRORS_ONLY"

      # skipped_override (Optional)
      # 設定内容: スキップを試みたファイル/オブジェクト/ディレクトリのレポートレベルを指定します。
      # 設定可能な値:
      #   - "ERRORS_ONLY": エラーのみ
      #   - "SUCCESSES_AND_ERRORS": 成功と失敗の両方
      skipped_override = "ERRORS_ONLY"

      # transferred_override (Optional)
      # 設定内容: 転送を試みたファイル/オブジェクト/ディレクトリのレポートレベルを指定します。
      # 設定可能な値:
      #   - "ERRORS_ONLY": エラーのみ
      #   - "SUCCESSES_AND_ERRORS": 成功と失敗の両方
      transferred_override = "ERRORS_ONLY"

      # verified_override (Optional)
      # 設定内容: 転送終了時に検証を試みたファイル/オブジェクト/ディレクトリのレポートレベルを指定します。
      # 設定可能な値:
      #   - "ERRORS_ONLY": エラーのみ
      #   - "SUCCESSES_AND_ERRORS": 成功と失敗の両方
      verified_override = "ERRORS_ONLY"
    }
  }

  #-------------------------------------------------------------
  # timeouts ブロック (Optional)
  # リソース操作のタイムアウト値を指定します。
  #-------------------------------------------------------------

  timeouts {
    # create (Optional)
    # 設定内容: 作成操作のタイムアウトを指定します。
    # 設定可能な値: "10m" などの duration 文字列
    create = "10m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: DataSync タスクの Amazon Resource Name (ARN)
#
# - arn: DataSync タスクの Amazon Resource Name (ARN)
#
# - tags_all: プロバイダーの default_tags 設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
