#---------------------------------------------------------------
# AWS Backup Plan
#---------------------------------------------------------------
#
# AWS Backupのバックアッププランをプロビジョニングするリソースです。
# バックアッププランは、AWSリソースをいつ・どのようにバックアップするかを
# 定義するポリシーです。バックアップルール、ライフサイクル設定、
# コピーアクションなどを含みます。
#
# AWS公式ドキュメント:
#   - AWS Backup概要: https://docs.aws.amazon.com/aws-backup/latest/devguide/whatisbackup.html
#   - バックアッププランの作成: https://docs.aws.amazon.com/aws-backup/latest/devguide/creating-a-backup-plan.html
#   - BackupRule API: https://docs.aws.amazon.com/aws-backup/latest/devguide/API_BackupRule.html
#   - Lifecycle API: https://docs.aws.amazon.com/aws-backup/latest/devguide/API_Lifecycle.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/backup_plan
#
# Provider Version: 6.28.0
# Generated: 2026-01-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_backup_plan" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: バックアッププランの表示名を指定します。
  # 設定可能な値: 任意の文字列
  # 注意: プラン作成後に名前を変更することはできません。
  #       同一名のプランを作成しようとするとAlreadyExistsExceptionエラーが発生します。
  name = "example-backup-plan"

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
  # バックアップルール設定 (Required, 最低1つ必要)
  #-------------------------------------------------------------

  # rule (Required)
  # 設定内容: バックアップジョブのスケジュールとライフサイクルを定義するルールオブジェクト。
  # 複数のルールを定義することで、異なるスケジュールや保持ポリシーを設定できます。
  rule {
    # rule_name (Required)
    # 設定内容: バックアップルールの表示名を指定します。
    # 設定可能な値: 1〜50文字の英数字または特殊文字
    rule_name = "daily-backup-rule"

    # target_vault_name (Required)
    # 設定内容: バックアップを保存する論理コンテナ（バックアップボールト）の名前を指定します。
    # 設定可能な値: 既存のバックアップボールト名
    # 注意: ボールトはアカウントおよびAWSリージョンで一意である必要があります。
    target_vault_name = "example-backup-vault"

    # schedule (Optional)
    # 設定内容: AWS BackupがバックアップジョブをいつUTC開始するかを指定するCRON式。
    # 設定可能な値: CRON式（例: "cron(0 12 * * ? *)" は毎日12:00 UTC）
    # 省略時: スケジュールなし（オンデマンドバックアップのみ）
    # 参考: https://docs.aws.amazon.com/eventbridge/latest/userguide/eb-scheduled-rule-pattern.html
    # 注意: 曜日は1〜7で指定（1=日曜日）
    schedule = "cron(0 5 ? * * *)"

    # schedule_expression_timezone (Optional)
    # 設定内容: スケジュール式のタイムゾーンを指定します。
    # 設定可能な値: IANAタイムゾーン名（例: "Asia/Tokyo", "America/Los_Angeles"）
    # 省略時: "Etc/UTC"
    # 参考: https://docs.aws.amazon.com/location/latest/APIReference/API_TimeZone.html
    schedule_expression_timezone = "Asia/Tokyo"

    # start_window (Optional)
    # 設定内容: スケジュールされた時刻からバックアップ開始までの最大待機時間（分）を指定します。
    # 設定可能な値: 正の整数（分単位）
    # 省略時: デフォルト値が適用（通常8時間 = 480分）
    # 用途: バックアップ開始のタイミングに柔軟性を持たせる場合に使用
    start_window = 60

    # completion_window (Optional)
    # 設定内容: バックアップジョブ開始後、完了までの最大時間（分）を指定します。
    # 設定可能な値: 正の整数（分単位）
    # 省略時: デフォルト値が適用（通常7日間）
    # 注意: この時間を超えるとジョブはキャンセルされエラーが返されます。
    completion_window = 120

    # enable_continuous_backup (Optional)
    # 設定内容: 継続的バックアップ（ポイントインタイムリカバリ/PITR）を有効にするかを指定します。
    # 設定可能な値:
    #   - true: 継続的バックアップを有効化（PITRをサポートするリソースタイプで利用可能）
    #   - false: スナップショットバックアップのみ
    # 省略時: false
    # 関連機能: Point-in-Time Recovery (PITR)
    #   対応リソース: Amazon RDS, Amazon Aurora, Amazon S3, Amazon DynamoDB等
    #   - https://docs.aws.amazon.com/aws-backup/latest/devguide/point-in-time-recovery.html
    enable_continuous_backup = false

    # recovery_point_tags (Optional)
    # 設定内容: 作成されるリカバリポイント（バックアップ）に割り当てるタグを指定します。
    # 設定可能な値: キーと値のペアのマップ
    # 用途: バックアップの識別、コスト配分、アクセス制御に使用
    recovery_point_tags = {
      Environment = "production"
      BackupType  = "daily"
    }

    # target_logically_air_gapped_backup_vault_arn (Optional)
    # 設定内容: 論理的にエアギャップされたボールトのARNを指定します。
    # 設定可能な値: 同一アカウント・リージョン内の論理エアギャップボールトARN
    # 用途: サポートされるフルマネージドリソースは直接論理エアギャップボールトに
    #       バックアップし、他のリソースは一時スナップショットを経由してコピーします。
    # 注意: 一時スナップショットは課金対象となります。
    #       サポートされていないリソースは指定されたバックアップボールトにのみバックアップされます。
    target_logically_air_gapped_backup_vault_arn = null

    #-----------------------------------------------------------
    # ライフサイクル設定
    #-----------------------------------------------------------

    # lifecycle (Optional)
    # 設定内容: リカバリポイントのコールドストレージへの移行と有効期限を定義します。
    # 関連機能: AWS Backup ライフサイクル管理
    #   コールドストレージへの移行によりストレージコストを削減できます。
    #   - https://docs.aws.amazon.com/aws-backup/latest/devguide/API_Lifecycle.html
    lifecycle {
      # cold_storage_after (Optional)
      # 設定内容: リカバリポイント作成後、コールドストレージに移行するまでの日数を指定します。
      # 設定可能な値: 正の整数（日単位）
      # 注意: コールドストレージを使用する場合、合計保持期間は90日以上必要です。
      #       delete_afterはcold_storage_afterより90日以上大きい値にする必要があります。
      # 関連機能: Amazon EBS Snapshots Archive
      #   EBSスナップショットのコールドストレージはEBS Snapshots Archiveを使用します。
      #   - https://docs.aws.amazon.com/ebs/latest/userguide/snapshot-archive.html
      cold_storage_after = 30

      # delete_after (Optional)
      # 設定内容: リカバリポイント作成後、削除するまでの日数を指定します。
      # 設定可能な値: 正の整数（日単位）
      # 注意: cold_storage_afterを指定した場合、その値より90日以上大きい値にする必要があります。
      delete_after = 365

      # opt_in_to_archive_for_supported_resources (Optional)
      # 設定内容: サポートされるリソースに対してアーカイブ（コールドストレージ）への
      #          移行をライフサイクル設定に従って行うかを指定します。
      # 設定可能な値:
      #   - true: アーカイブへの移行を有効化
      #   - false: アーカイブへの移行を無効化
      # 省略時: Terraformが自動設定
      opt_in_to_archive_for_supported_resources = true
    }

    #-----------------------------------------------------------
    # コピーアクション設定
    #-----------------------------------------------------------

    # copy_action (Optional)
    # 設定内容: バックアップのクロスリージョンまたはクロスアカウントコピー設定を定義します。
    # 用途: 災害復旧（DR）のために別リージョンにバックアップのコピーを保持する場合に使用
    copy_action {
      # destination_vault_arn (Required)
      # 設定内容: コピー先のバックアップボールトのARNを指定します。
      # 設定可能な値: 有効なバックアップボールトARN
      # 注意: クロスリージョンコピーの場合は別リージョンのボールトARNを指定
      destination_vault_arn = "arn:aws:backup:us-west-2:123456789012:backup-vault:example-vault-dr"

      # lifecycle (Optional)
      # 設定内容: コピー先でのリカバリポイントのライフサイクルを定義します。
      # 注意: ソースとは異なる保持ポリシーを設定可能
      lifecycle {
        # cold_storage_after (Optional)
        # 設定内容: コピー先でコールドストレージに移行するまでの日数を指定します。
        cold_storage_after = 30

        # delete_after (Optional)
        # 設定内容: コピー先で削除するまでの日数を指定します。
        delete_after = 365

        # opt_in_to_archive_for_supported_resources (Optional)
        # 設定内容: コピー先でアーカイブへの移行を有効にするかを指定します。
        opt_in_to_archive_for_supported_resources = true
      }
    }

    #-----------------------------------------------------------
    # スキャンアクション設定
    #-----------------------------------------------------------

    # scan_action (Optional)
    # 設定内容: バックアップルールに対するマルウェアスキャン設定を定義します。
    # 用途: 作成されたバックアップに対して自動的にマルウェアスキャンを実行
    # 関連機能: AWS Backup マルウェア保護
    #   GuardDutyを使用してバックアップをスキャンし、マルウェアを検出します。
    #   - https://docs.aws.amazon.com/aws-backup/latest/devguide/malware-protection.html
    scan_action {
      # malware_scanner (Required)
      # 設定内容: スキャンに使用するマルウェアスキャナーを指定します。
      # 設定可能な値: "GUARDDUTY"（現在サポートされている唯一の値）
      malware_scanner = "GUARDDUTY"

      # scan_mode (Required)
      # 設定内容: スキャンモードを指定します。
      # 設定可能な値:
      #   - "FULL_SCAN": フルスキャン（バックアップ全体をスキャン）
      #   - "INCREMENTAL_SCAN": 増分スキャン（前回からの変更分のみスキャン）
      scan_mode = "FULL_SCAN"
    }
  }

  #-------------------------------------------------------------
  # 高度なバックアップ設定
  #-------------------------------------------------------------

  # advanced_backup_setting (Optional)
  # 設定内容: リソースタイプごとのバックアップオプションを指定します。
  # 用途: 現在、Windows VSS（Volume Shadow Copy Service）バックアップの有効化に使用
  # 関連機能: Windows VSS バックアップ
  #   アプリケーション整合性のあるバックアップを作成するためのWindows固有機能。
  #   VSS対応アプリケーション（SQL Server, Exchange等）のデータ整合性を保証します。
  advanced_backup_setting {
    # backup_options (Required)
    # 設定内容: バックアップオプションをマップ形式で指定します。
    # 設定可能な値: Windows VSSバックアップの場合 { WindowsVSS = "enabled" }
    # 用途: VSSを有効にしてアプリケーション整合性のあるバックアップを作成
    backup_options = {
      WindowsVSS = "enabled"
    }

    # resource_type (Required)
    # 設定内容: バックアップ対象のAWSリソースタイプを指定します。
    # 設定可能な値: "EC2"（VSSバックアップでサポートされる唯一のリソースタイプ）
    resource_type = "EC2"
  }

  #-------------------------------------------------------------
  # スキャン設定
  #-------------------------------------------------------------

  # scan_setting (Optional)
  # 設定内容: プラン全体に対するマルウェアスキャン設定を定義します。
  # 用途: 特定のリソースタイプに対してマルウェアスキャンを有効化
  # 関連機能: AWS Backup マルウェア保護
  #   - https://docs.aws.amazon.com/aws-backup/latest/devguide/malware-protection.html
  # 注意: スキャンを有効にする前に、バックアップロールとスキャナーロールに
  #       必要な権限があることを確認してください。
  #   - https://docs.aws.amazon.com/guardduty/latest/ug/malware-protection-backup-iam-permissions.html
  scan_setting {
    # malware_scanner (Required)
    # 設定内容: スキャンに使用するマルウェアスキャナーを指定します。
    # 設定可能な値: "GUARDDUTY"（現在サポートされている唯一の値）
    malware_scanner = "GUARDDUTY"

    # resource_types (Required)
    # 設定内容: スキャン対象のリソースタイプリストを指定します。
    # 設定可能な値:
    #   - "EBS": Amazon EBSボリューム
    #   - "EC2": Amazon EC2インスタンス
    #   - "S3": Amazon S3バケット
    #   - "ALL": サポートされる全てのリソースタイプ
    resource_types = ["EC2", "EBS"]

    # scanner_role_arn (Required)
    # 設定内容: AWS Backupがリソースをスキャンするために使用するIAMロールのARNを指定します。
    # 設定可能な値: 有効なIAMロールARN
    # 注意: ロールには必要な権限が付与されている必要があります。
    #   - https://docs.aws.amazon.com/guardduty/latest/ug/malware-protection-backup-iam-permissions.html
    scanner_role_arn = "arn:aws:iam::123456789012:role/AWSBackupScannerRole"
  }

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: バックアッププランに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "example-backup-plan"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: バックアッププランのAmazon Resource Name (ARN)
#
# - version: バックアッププランのバージョンIDとして機能する、
#            ランダム生成されたUnicode UTF-8エンコード文字列。
#            プランの内容が変更されると新しいバージョンが生成されます。
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
