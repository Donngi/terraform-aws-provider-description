#-------
# EBS スナップショットのブロックパブリックアクセス設定
#-------
# Provider Version: 6.28.0
# Generated: 2026-02-14
# Terraform Registry: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ebs_snapshot_block_public_access
#
# アカウントとリージョン単位で、EBSスナップショットのパブリック共有を制限する設定を管理
# スナップショットが一般公開されることを防ぎ、データ漏洩のリスクを低減します
#
# 主な機能:
# - block-all-sharing: すべてのパブリック共有をブロック（既存の公開スナップショットも非公開化）
# - block-new-sharing: 新規のパブリック共有のみをブロック（既存の公開スナップショットは影響なし）
# - unblocked: パブリック共有を許可
#
# NOTE:
# - アカウント単位とリージョン単位で設定が可能
# - block-all-sharingモードでは、既存の公開スナップショットが見えなくなりますが、
#   stateは「publicly shared」のまま残ります
# - 設定を無効化またはblock-new-sharingに変更すると、既存スナップショットが再び公開されます
# - Declarative Policyで管理されている場合、直接変更できません
# - Terraformのライフサイクル外で作成されたリソースには影響しません
# - 既存の公開スナップショットの状態を変更するには、個別のスナップショット設定が必要です
#-------

#-------
# 基本設定
#-------
resource "aws_ebs_snapshot_block_public_access" "example" {
  #-------
  # ブロックパブリックアクセスの状態
  #-------
  # 設定内容: EBSスナップショットのパブリック共有を制限するモード
  # 設定可能な値:
  #   - block-all-sharing   : すべてのパブリック共有をブロック（既存も含む）
  #   - block-new-sharing   : 新規のパブリック共有のみブロック
  #   - unblocked           : パブリック共有を許可
  # 注意事項:
  #   - block-all-sharingでは既存の公開スナップショットが非表示になりますが、
  #     内部的には「publicly shared」のステータスが維持されます
  #   - 後で設定を変更すると、非表示にされたスナップショットが再び公開される可能性があります
  state = "block-all-sharing"

  #-------
  # リージョン指定
  #-------
  # 設定内容: この設定を適用するAWSリージョン
  # 省略時: プロバイダー設定のリージョンが使用されます
  # 注意事項:
  #   - リージョンごとに個別の設定が必要です
  #   - マルチリージョン環境では、各リージョンでリソースを作成してください
  region = "us-east-1"
}

#-------
# Attributes Reference (参照可能な属性)
#-------
# このリソースでは、以下の属性を参照できます。
#
# - id        : リソースの識別子（通常はリージョン名）
# - region    : 設定が適用されているリージョン
# - state     : 現在のブロックパブリックアクセスの状態
#-------
