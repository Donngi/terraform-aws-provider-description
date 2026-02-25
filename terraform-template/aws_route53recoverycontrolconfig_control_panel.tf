#---------------------------------------------------------------
# AWS Route 53 Application Recovery Controller Control Panel
#---------------------------------------------------------------
#
# Amazon Route 53 Application Recovery Controller (ARC) の
# コントロールパネルをプロビジョニングするリソースです。
# コントロールパネルはルーティングコントロールと安全ルールをグループ化する
# 論理的なコンテナです。各クラスターにはデフォルトのコントロールパネルが
# 含まれており、追加のコントロールパネルを作成することで、
# アプリケーションのフェイルオーバーをきめ細かく管理できます。
#
# AWS公式ドキュメント:
#   - コントロールパネルの作成: https://docs.aws.amazon.com/r53recovery/latest/dg/routing-control.create.html
#   - ARCルーティングコントロールコンポーネント: https://docs.aws.amazon.com/r53recovery/latest/dg/introduction-components-routing.html
#   - Application Recovery Controller概要: https://docs.aws.amazon.com/r53recovery/latest/dg/index.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/route53recoverycontrolconfig_control_panel
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_route53recoverycontrolconfig_control_panel" "example" {

  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: コントロールパネルを識別する名前を指定します。
  # 設定可能な値: 文字列（1-64文字）
  # 注意: クラスター内で一意である必要があります
  name = "example-control-panel"

  # cluster_arn (Required)
  # 設定内容: このコントロールパネルが所属するクラスターのARNを指定します。
  # 設定可能な値: 有効なRoute 53 ARCクラスターのARN
  # 関連機能: Cluster
  #   クラスターは複数のコントロールパネルを持つことができます。
  #   各クラスターにはデフォルトのコントロールパネルが自動的に作成されます。
  #   - https://docs.aws.amazon.com/r53recovery/latest/dg/introduction-components-routing.html
  cluster_arn = "arn:aws:route53-recovery-control::123456789012:cluster/8d47920e-d789-437d-803a-2dcc4b204393"

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "example-control-panel"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: コントロールパネルのAmazon Resource Name (ARN)
#
# - default_control_panel: コントロールパネルがデフォルトかどうかを示すブール値
#
# - routing_control_count: コントロールパネル内のルーティングコントロール数
#
# - status: コントロールパネルのステータス
#        作成/更新中: "PENDING"
#        削除中: "PENDING_DELETION"
#        それ以外: "DEPLOYED"
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
