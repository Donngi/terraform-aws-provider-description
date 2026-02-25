#---------------------------------------------------------------
# AWS Route 53 Recovery Readiness Cell
#---------------------------------------------------------------
#
# Amazon Route 53 Application Recovery Controller (ARC) のRecovery Readiness機能において、
# アプリケーションのフェイルオーバー準備状況を階層的に管理するためのセル (Cell) を
# プロビジョニングするリソースです。
#
# Cellは、アプリケーションの独立したレプリカを表す論理的な単位です。
# 通常、1つのCellは1つのAWSリージョンまたはアベイラビリティゾーンに対応します。
# Cellはネストが可能であり、より大きなCellの子Cellとして構成できます。
# Recovery GroupはCellを束ね、アプリケーション全体の準備状況を表します。
#
# AWS公式ドキュメント:
#   - Recovery Readiness概要: https://docs.aws.amazon.com/recovery-readiness/latest/api/what-is-recovery-readiness.html
#   - Cells概要: https://docs.aws.amazon.com/r53recovery/latest/dg/recovery-readiness.cells.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53recoveryreadiness_cell
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_route53recoveryreadiness_cell" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # cell_name (Required)
  # 設定内容: セルを識別するための一意の名前を指定します。
  # 設定可能な値: 文字列。アカウント内で一意である必要があります
  # 用途: アプリケーションの独立したレプリカ（リージョン/AZごとの複製）を
  #       識別する論理的な単位の名称として使用されます
  # 参考: https://docs.aws.amazon.com/recovery-readiness/latest/api/get-cell.html
  cell_name = "my-cell"

  # cells (Optional)
  # 設定内容: このセルの子セルとするセルのARNリストを指定します。
  # 設定可能な値: セルARNの文字列リスト。最大5件まで指定可能
  # 省略時: 子セルを持たない単独のCellとして作成されます
  # 関連機能: ネスト構造のCell
  #   大規模なアプリケーションでは、CellをAZレベルで作成し、
  #   それらをリージョンレベルのCellの子として組み込むことで
  #   階層的な準備状況管理を実現できます。
  #   - https://docs.aws.amazon.com/r53recovery/latest/dg/recovery-readiness.cells.html
  cells = [
    # "arn:aws:route53-recovery-readiness::123456789012:cell/child-cell-1",
    # "arn:aws:route53-recovery-readiness::123456789012:cell/child-cell-2",
  ]

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
    Name        = "my-cell"
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
# - arn: CellのAmazon Resource Name (ARN)
#        形式: arn:aws:route53-recovery-readiness::account-id:cell/cell-name
#
# - parent_readiness_scopes: このCellが属する親スコープ（Recovery GroupまたはCellのARN）のリスト
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
