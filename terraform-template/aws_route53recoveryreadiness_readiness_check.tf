#---------------------------------------------------------------
# AWS Route 53 Recovery Readiness Readiness Check
#---------------------------------------------------------------
#
# Amazon Route 53 Application Recovery Controller (ARC) のRecovery Readiness機能において、
# リソースセットの準備状況を監視するための準備状況チェック (Readiness Check) を
# プロビジョニングするリソースです。
#
# Readiness Checkは、アプリケーションのレプリカ（リージョンやAZごとの複製）が
# フェイルオーバートラフィックを処理する準備ができているかを継続的に監視します。
# ARCは1分ごとにReadiness Checkを実行し、プロビジョニング容量の一致確認や
# 可能な場合は自動的な修正アクションを実行します。
#
# AWS公式ドキュメント:
#   - Recovery Readiness概要: https://docs.aws.amazon.com/recovery-readiness/latest/api/what-is-recovery-readiness.html
#   - Recovery GroupsとReadiness Checks: https://docs.aws.amazon.com/r53recovery/latest/dg/recovery-readiness.recovery-groups-and-readiness-checks.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53recoveryreadiness_readiness_check
#
# Provider Version: 6.28.0
# Generated: 2026-02-04
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_route53recoveryreadiness_readiness_check" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # readiness_check_name (Required)
  # 設定内容: 準備状況チェックを識別するための一意の名前を指定します。
  # 設定可能な値: 文字列。アカウント内で一意である必要があります
  # 用途: Recovery Groupに関連付けられたリソースセットの準備状況を監視する
  #       チェックの識別子として使用されます
  # 参考: https://docs.aws.amazon.com/recovery-readiness/latest/api/get-readiness-check.html
  readiness_check_name = "my-readiness-check"

  # resource_set_name (Required)
  # 設定内容: 準備状況を監視するリソースセットの名前を指定します。
  # 設定可能な値: 既存のリソースセット名を指定
  # 関連機能: Resource Set
  #   各リソースタイプに対して作成され、特定のリソースグループの準備状況を
  #   定義します。Readiness Checkはこのリソースセットを監視し、リソースが
  #   フェイルオーバーに対応可能かどうかを確認します。
  #   - https://docs.aws.amazon.com/recovery-readiness/latest/api/get-resource-set.html
  resource_set_name = "my-resource-set"

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  #   - https://docs.aws.amazon.com/general/latest/gr/aws_tagging.html
  tags = {
    Name        = "my-readiness-check"
    Environment = "production"
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソースの削除操作のタイムアウト時間を指定します。
  # 関連機能: Terraform Operation Timeouts
  #   特定の操作の完了を待つ時間を設定します。設定がない場合、
  #   Terraformはデフォルトのタイムアウト値を使用します。
  timeouts {
    # delete (Optional)
    # 設定内容: リソースの削除操作のタイムアウト時間を指定します。
    # 設定可能な値: 時間の文字列（例: "5m", "1h"）
    # 省略時: Terraformのデフォルトタイムアウト値が使用されます
    delete = "5m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: Readiness CheckのAmazon Resource Name (ARN)
#        形式: arn:aws:route53-recovery-readiness::account-id:readiness-check/readiness-check-name
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
