#---------------------------------------------------------------
# AWS Route 53 Recovery Readiness Recovery Group
#---------------------------------------------------------------
#
# Amazon Route 53 Application Recovery Controller (ARC) のRecovery Readiness機能において、
# アプリケーションの高可用性を確保するためのリカバリーグループを管理するリソースです。
#
# リカバリーグループは、複数のセル（フォールトドメイン）をまとめた論理的なグループであり、
# 各セルは独立したリージョンやアベイラビリティーゾーンを表します。
# リカバリーグループにReadiness Checkを関連付けることで、アプリケーション全体の
# 回復準備状態を一元的に監視できます。
#
# AWS公式ドキュメント:
#   - Recovery Groups概要: https://docs.aws.amazon.com/r53recovery/latest/dg/recovery-readiness.recovery-groups-and-readiness-checks.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53recoveryreadiness_recovery_group
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_route53recoveryreadiness_recovery_group" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # recovery_group_name (Required)
  # 設定内容: リカバリーグループを一意に識別する名前を指定します。
  # 設定可能な値: 任意の文字列（AWSアカウント内で一意である必要がある）
  recovery_group_name = "my-high-availability-app"

  #-------------------------------------------------------------
  # フォールトドメイン（ネストされたセル）設定
  #-------------------------------------------------------------

  # cells (Optional)
  # 設定内容: このリカバリーグループにネストされたフォールトドメインとして追加するセルのARNリスト
  # 設定可能な値: aws_route53recoveryreadiness_cell リソースのARNのリスト
  # 省略時: セルなしのリカバリーグループが作成される
  cells = [
    # "arn:aws:route53-recovery-readiness::123456789012:cell/example-cell-1",
    # "arn:aws:route53-recovery-readiness::123456789012:cell/example-cell-2",
  ]

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに付与するキーと値のペア
  # 省略時: タグなし
  tags = {
    Name        = "my-high-availability-app"
    Environment = "production"
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  timeouts {
    # delete (Optional)
    # 設定内容: リソース削除操作のタイムアウト時間
    # 設定可能な値: "60s", "5m", "1h" などの時間文字列
    # 省略時: プロバイダーのデフォルト値が使用される
    delete = "5m"
  }
}

#---------------------------------------------------------------
# Attributes Reference
#---------------------------------------------------------------
# id         - リカバリーグループの名前（recovery_group_name と同一）
# arn        - リカバリーグループの ARN
# tags_all   - プロバイダーの default_tags を含む全タグのマップ
