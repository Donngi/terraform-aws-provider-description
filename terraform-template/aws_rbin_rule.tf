# ==============================================================================
# AWS Recycle Bin Retention Rule (aws_rbin_rule)
# ==============================================================================
# Recycle Bin（ごみ箱）の保持ルールを管理するリソース。
# 削除されたEBSスナップショットやEC2 AMIを一定期間保持し、誤削除時の復旧を可能にします。
#
# 主要な用途:
# - 削除されたEBSスナップショットの自動保護
# - 削除されたEBS-backed AMIの自動保護
# - タグベースの保持ルール設定
# - リージョン全体での保持ルール設定
# - 特定タグを持つリソースの除外設定
#
# 料金:
# - Recycle Bin自体の利用料金は無料
# - 保持期間中のスナップショットには通常のEBSスナップショット料金が適用
# - アーカイブされたスナップショットにはアーカイブストレージ料金が適用
#
# 公式ドキュメント:
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rbin_rule
# https://docs.aws.amazon.com/ebs/latest/userguide/recycle-bin.html
# ==============================================================================

# ------------------------------------------------------------------------------
# 基本的な使用例: タグレベルの保持ルール
# ------------------------------------------------------------------------------
# 特定のタグを持つEBSスナップショットを10日間保持するルールの例
resource "aws_rbin_rule" "example_tag_level" {
  # ------------------------------------------------------------------------------
  # 必須パラメータ
  # ------------------------------------------------------------------------------

  # resource_type: 保持するリソースタイプ (必須)
  # 有効な値: EBS_SNAPSHOT, EC2_IMAGE
  # - EBS_SNAPSHOT: EBSスナップショット（保持期間: 1〜365日）
  # - EC2_IMAGE: EBS-backed AMI（保持期間: 1〜365日）
  # 注意: EBSボリュームは1〜7日の保持期間
  resource_type = "EBS_SNAPSHOT"

  # retention_period: 保持期間の設定 (必須)
  # 削除されたリソースをRecycle Binに保持する期間を指定
  # この期間内であれば削除されたリソースを復元可能
  retention_period {
    # retention_period_value: 保持期間の値 (必須)
    # resource_typeに応じた範囲で設定
    # - EBS_SNAPSHOT, EC2_IMAGE: 1〜365
    retention_period_value = 10

    # retention_period_unit: 保持期間の単位 (必須)
    # 現在サポートされているのは "DAYS" のみ
    retention_period_unit = "DAYS"
  }

  # ------------------------------------------------------------------------------
  # オプションパラメータ
  # ------------------------------------------------------------------------------

  # description: 保持ルールの説明 (オプション)
  # ルールの目的や対象を明確にするための説明文
  # 注意: 機密情報を含めないこと
  description = "Example tag-level retention rule for production snapshots"

  # resource_tags: タグレベルの保持ルールで使用するタグ (オプション)
  # 指定したタグを持つリソースのみを保持対象とする
  # 最大50個のタグを指定可能
  # 注意: exclude_resource_tagsと併用不可
  resource_tags {
    # resource_tag_key: タグのキー (必須)
    resource_tag_key = "Environment"

    # resource_tag_value: タグの値 (オプション)
    # 省略した場合、キーのみで判定
    resource_tag_value = "Production"
  }

  # 複数のタグを指定する例
  resource_tags {
    resource_tag_key   = "Application"
    resource_tag_value = "CriticalApp"
  }

  # region: このリソースを管理するリージョン (オプション)
  # デフォルト: プロバイダー設定のリージョン
  # 注意: 保持ルールは作成したリージョンでのみ機能
  # 他のリージョンでも使用する場合は、各リージョンで個別に作成が必要
  region = "ap-northeast-1"

  # tags: リソースに付与するAWSタグ (オプション)
  # 保持ルール自体を管理するためのタグ
  # 注意: resource_tagsとは異なり、ルール自体に付与されるタグ
  tags = {
    Name        = "production-snapshot-retention"
    Environment = "production"
    ManagedBy   = "Terraform"
  }

  # tags_all: すべてのタグ（プロバイダーデフォルトタグを含む） (計算値)
  # Terraformが自動的に管理するため、通常は指定不要
}

# ------------------------------------------------------------------------------
# リージョンレベルの保持ルール
# ------------------------------------------------------------------------------
# リージョン内のすべてのEC2 AMIを保持し、特定タグを持つものを除外する例
resource "aws_rbin_rule" "example_region_level" {
  description   = "Example region-level retention rule with exclusion tags"
  resource_type = "EC2_IMAGE"

  # exclude_resource_tags: リージョンレベルルールで除外するタグ (オプション)
  # 指定したタグを持つリソースは保持対象から除外
  # 最大5個の除外タグを指定可能
  # 注意:
  # - resource_tagsと併用不可
  # - Rule Lock（lock_configuration）との併用不可
  exclude_resource_tags {
    resource_tag_key   = "Temporary"
    resource_tag_value = "true"
  }

  exclude_resource_tags {
    resource_tag_key   = "Environment"
    resource_tag_value = "Development"
  }

  retention_period {
    retention_period_value = 30
    retention_period_unit  = "DAYS"
  }

  tags = {
    Name = "region-level-ami-retention"
  }
}

# ------------------------------------------------------------------------------
# ロック付き保持ルール
# ------------------------------------------------------------------------------
# ルールの変更・削除を防ぐためのロック機能を持つ例
resource "aws_rbin_rule" "example_locked" {
  description   = "Locked retention rule for compliance"
  resource_type = "EBS_SNAPSHOT"

  resource_tags {
    resource_tag_key   = "Compliance"
    resource_tag_value = "Required"
  }

  retention_period {
    retention_period_value = 365
    retention_period_unit  = "DAYS"
  }

  # lock_configuration: ルールのロック設定 (オプション)
  # ロックされたルールは、アンロック遅延期間が経過するまで変更・削除不可
  # コンプライアンス要件を満たすために使用
  # 注意: exclude_resource_tagsとの併用不可
  lock_configuration {
    # unlock_delay: アンロック遅延設定 (必須)
    unlock_delay {
      # unlock_delay_value: アンロック遅延期間の値 (必須)
      # ルールをアンロック後、実際に変更可能になるまでの待機期間
      unlock_delay_value = 7

      # unlock_delay_unit: アンロック遅延期間の単位 (必須)
      # 現在サポートされているのは "DAYS" のみ
      unlock_delay_unit = "DAYS"
    }
  }

  tags = {
    Name       = "compliance-snapshot-retention"
    Compliance = "SOC2"
  }
}

# ------------------------------------------------------------------------------
# タイムアウト設定
# ------------------------------------------------------------------------------
resource "aws_rbin_rule" "example_with_timeouts" {
  description   = "Retention rule with custom timeouts"
  resource_type = "EBS_SNAPSHOT"

  resource_tags {
    resource_tag_key = "Backup"
  }

  retention_period {
    retention_period_value = 14
    retention_period_unit  = "DAYS"
  }

  # timeouts: リソース操作のタイムアウト設定 (オプション)
  timeouts {
    # create: 作成操作のタイムアウト (オプション)
    # デフォルト値が適切な場合が多いため、通常は指定不要
    create = "10m"

    # update: 更新操作のタイムアウト (オプション)
    update = "10m"

    # delete: 削除操作のタイムアウト (オプション)
    delete = "10m"
  }

  tags = {
    Name = "backup-snapshot-retention"
  }
}

# ==============================================================================
# 出力値（Computed Attributes）
# ==============================================================================

# 以下の属性は Terraform によって自動的に計算されます

output "rbin_rule_outputs" {
  description = "AWS Recycle Bin Rule の計算値例"
  value = {
    # id: ルールのID (計算値)
    # 保持ルールの一意識別子
    id = aws_rbin_rule.example_tag_level.id

    # arn: ルールのARN (計算値)
    # Amazon Resource Name
    arn = aws_rbin_rule.example_tag_level.arn

    # status: ルールのステータス (計算値)
    # - pending: ルール作成中
    # - available: ルールが有効でリソースを保持可能
    # availableステータスのルールのみがリソースを保持
    status = aws_rbin_rule.example_tag_level.status

    # lock_state: ルールのロック状態 (計算値)
    # - locked: ロック中
    # - pending_unlock: アンロック処理中
    # - unlocked: アンロック済み
    # lock_configurationが設定されている場合のみ有効
    lock_state = try(aws_rbin_rule.example_locked.lock_state, null)

    # lock_end_time: アンロック遅延期間の終了日時 (計算値)
    # アンロックされたルールでアンロック遅延期間内の場合のみ返される
    # この期間が経過するまでルールの変更・削除は不可
    lock_end_time = try(aws_rbin_rule.example_locked.lock_end_time, null)
  }
}

# ==============================================================================
# ベストプラクティスと注意事項
# ==============================================================================

# 1. 保持期間の設定
#    - スナップショット/AMI: 1〜365日の範囲で設定可能
#    - コンプライアンス要件に応じて適切な期間を設定
#    - 長期保存が必要な場合はAWS Backupとの併用を検討

# 2. タグ戦略
#    - タグレベルルール: 特定の重要なリソースのみを保護
#    - リージョンレベルルール: すべてのリソースを保護し、不要なものを除外
#    - 複数のルールが適用される場合、最も長い保持期間が優先

# 3. リソースタイプごとの考慮事項
#    - EBS_SNAPSHOT:
#      * 高速スナップショット復元(FSR)は自動的に無効化
#      * 共有スナップショットは削除時に共有解除
#      * 他のAWSサービスが作成したスナップショットは復元後も管理されない
#    - EC2_IMAGE:
#      * EBS-backed AMIのみサポート（Instance Store-backed AMIは非対応）
#      * AMIと関連スナップショットの保持期間は同じか長く設定することを推奨
#      * AMI復元前にすべての関連スナップショットを復元する必要あり

# 4. ロック機能の使用
#    - コンプライアンス要件がある場合に使用
#    - ロック後の変更には十分な計画期間が必要
#    - exclude_resource_tagsとは併用不可

# 5. リージョンごとの設定
#    - 保持ルールは作成したリージョンでのみ機能
#    - マルチリージョン運用の場合、各リージョンで個別に作成が必要
#    - region パラメータで明示的にリージョンを指定可能

# 6. コスト管理
#    - Recycle Bin自体は無料だが、保持期間中のストレージ料金は発生
#    - 不要な保持期間の延長は避ける
#    - アーカイブスナップショットには別途アーカイブストレージ料金

# 7. 運用上の注意
#    - ルールは最終的整合性モデルに従う（即座に反映されない場合あり）
#    - Recycle Bin内のリソースは手動削除不可（保持期間終了後に自動削除）
#    - Data Lifecycle Managerとの併用時は削除タイミングに注意

# 8. セキュリティ
#    - description に機密情報を含めない
#    - 適切なIAMポリシーで保持ルールの変更を制限
#    - ロック機能を活用してルールの不正変更を防止

# ==============================================================================
# 関連リソース
# ==============================================================================

# - aws_ebs_snapshot: EBSスナップショットの作成・管理
# - aws_ami: AMIの作成・管理
# - aws_dlm_lifecycle_policy: Data Lifecycle Managerポリシー
# - aws_backup_plan: AWS Backupプラン

# ==============================================================================
# 変更履歴
# ==============================================================================
# このテンプレートはプロバイダーバージョン 6.28.0 のスキーマに基づいています
