#---------------------------------------------------------------
# AWS Route 53 Recovery Control Config Control Panel
#---------------------------------------------------------------
#
# AWS Route 53 Application Recovery Controller の制御パネルをプロビジョニングするリソースです。
# 制御パネルは、クラスタ内でルーティングコントロールを論理的にグループ化して整理するための仕組みです。
#
# 制御パネルの主な特徴:
#   - クラスタ作成時にデフォルトの制御パネルが自動的に作成され、すぐに利用可能
#   - 複数の制御パネルを作成して、ルーティングコントロールを組織化できる
#   - 制御パネルは1つのクラスタにのみ存在可能 (別クラスタに移動する場合は削除して再作成が必要)
#   - 制御パネル内でルーティングコントロールを管理し、フェイルオーバー操作を実行
#
# ユースケース:
#   - 災害復旧 (DR) シナリオのフェイルオーバー制御
#   - マルチリージョンアプリケーションのトラフィック管理
#   - 複数のセルやアベイラビリティーゾーンのルーティング制御
#   - セーフティールールによるフェイルオーバーの保護
#
# AWS公式ドキュメント:
#   - Recovery Control 概要: https://docs.aws.amazon.com/recovery-cluster/latest/api/Welcome.html
#   - 制御パネルの作成: https://docs.aws.amazon.com/recovery-cluster/latest/api/create-control-panel.html
#   - 制御パネルの説明: https://docs.aws.amazon.com/recovery-cluster/latest/api/describe-control-panel.html
#   - Recovery Controlのセットアップ: https://docs.aws.amazon.com/r53recovery/latest/dg/getting-started-cli-routing-config.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53recoverycontrolconfig_control_panel
#
# Provider Version: 6.28.0
# Generated: 2026-02-04
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_route53recoverycontrolconfig_control_panel" "example" {
  #-------------------------------------------------------------
  # 必須パラメータ
  #-------------------------------------------------------------

  # cluster_arn (Required)
  # 設定内容: この制御パネルを配置するクラスタのARNを指定します。
  # 設定可能な値: 有効なRoute 53 Recovery Control クラスタのARN
  # 形式例: arn:aws:route53-recovery-control::123456789012:cluster/8d47920e-d789-437d-803a-2dcc4b204393
  # 注意: 制御パネルは1つのクラスタにのみ存在可能。別クラスタに移動する場合は削除して再作成が必要
  # 関連機能: Route 53 Recovery Control クラスタ
  #   クラスタは5つの異なるAWSリージョンに配置されたエンドポイントのセットで、
  #   フェイルオーバー操作の高可用性とシーケンシャル一貫性を保証します。
  #   - https://docs.aws.amazon.com/r53recovery/latest/dg/getting-started-cli-routing-config.html
  cluster_arn = "arn:aws:route53-recovery-control::123456789012:cluster/8d47920e-d789-437d-803a-2dcc4b204393"

  # name (Required)
  # 設定内容: 制御パネルを説明する名前を指定します。
  # 設定可能な値: 1〜64文字の英数字、ハイフン、アンダースコア
  # 制約: クラスタ内で一意である必要があります
  # 用途: 制御パネルの識別と管理のための分かりやすい名前
  # オプションパラメータ
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ (最大50タグ)
  # 用途: リソースの識別、分類、コスト配分、アクセス制御に使用
  # プロバイダーのdefault_tags設定ブロックで定義されたタグと
  # 一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  # 関連機能: AWSリソースタグ付け
  #   タグを使用してリソースを分類し、コスト配分やアクセス制御を実現できます。
  #   - https://docs.aws.amazon.com/general/latest/gr/aws_tagging.html
  tags = {
    Name        = "example-control-panel"
    Environment = "production"
    Application = "disaster-recovery"
    ManagedBy   = "terraform"
  }

  # tags_all (Optional, Computed)
  # 設定内容: プロバイダーのdefault_tagsから継承されるタグを含む全タグのマップ
  # 注意: 通常は明示的に設定する必要はありません。Terraformが自動管理します
  tags_all = null

  # id (Optional, Computed)
  # 設定内容: リソースのID。通常はARNと同じ値
  # 注意: 通常は明示的に設定する必要はありません。Terraformが自動管理します
  id = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: 制御パネルのAmazon Resource Name (ARN)
#   形式: arn:aws:route53-recovery-control::123456789012:controlpanel/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
#   用途: 他のリソース (ルーティングコントロール、セーフティールール) で制御パネルを参照する際に使用
#
# - default_control_panel: 制御パネルがデフォルトであるかどうか (boolean)
#   true: クラスタ作成時に自動生成されたデフォルト制御パネル
#   false: ユーザーが作成したカスタム制御パネル
#   注意: デフォルト制御パネルはクラスタごとに1つのみ存在し、すぐに利用可能
#
# - routing_control_count: 制御パネル内のルーティングコントロールの数 (integer)
#   この値はルーティングコントロールの作成・削除に応じて動的に変化します
#   用途: 制御パネル内のルーティングコントロールの管理状況を把握するため
#
# - status: 制御パネルのステータス (string)
#   - PENDING: 作成中または更新中
#   - PENDING_DELETION: 削除処理中
#   - DEPLOYED: デプロイ完了、利用可能
#   注意: DEPLOYEDステータスになるまでルーティングコントロールを作成できません
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#---------------------------------------------------------------
