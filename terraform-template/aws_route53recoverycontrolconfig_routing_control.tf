#---------------------------------------------------------------
# AWS Route 53 Application Recovery Controller Routing Control
#---------------------------------------------------------------
#
# Amazon Route 53 Application Recovery Controller (ARC) の
# ルーティングコントロールをプロビジョニングするリソースです。
# ルーティングコントロールは、トラフィックルーティングを手動または自動で
# 切り替えるための単純なオン/オフスイッチとして機能します。
# フェイルオーバー、フェイルバック、メンテナンスウィンドウなど、
# 回復フローの制御に使用されます。
#
# AWS公式ドキュメント:
#   - ルーティングコントロール: https://docs.aws.amazon.com/r53recovery/latest/dg/routing-control.html
#   - ルーティングコントロールの作成: https://docs.aws.amazon.com/r53recovery/latest/dg/routing-control.create.html
#   - Application Recovery Controller概要: https://docs.aws.amazon.com/r53recovery/latest/dg/index.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/route53recoverycontrolconfig_routing_control
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_route53recoverycontrolconfig_routing_control" "example" {

  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: ルーティングコントロールを説明する名前を指定します。
  # 設定可能な値: 文字列（1-64文字）
  # 注意: コントロールパネル内で一意である必要があります
  name = "my-routing-control"

  # cluster_arn (Required)
  # 設定内容: このルーティングコントロールが存在するクラスターのARNを指定します。
  # 設定可能な値: 有効なRoute 53 ARCクラスターのARN
  # 用途: ルーティングコントロールが所属するクラスターを指定します。
  #       クラスターはRoute 53 ARCの基本インフラストラクチャとして機能します。
  cluster_arn = "arn:aws:route53-recovery-control::123456789012:cluster/8d47920e-d789-437d-803a-2dcc4b204393"

  #-------------------------------------------------------------
  # コントロールパネル設定
  #-------------------------------------------------------------

  # control_panel_arn (Optional)
  # 設定内容: このルーティングコントロールが存在するコントロールパネルのARNを指定します。
  # 設定可能な値: 有効なコントロールパネルのARN
  # 省略時: クラスターのデフォルトコントロールパネルに配置されます
  # 用途: ルーティングコントロールを特定のコントロールパネルにグループ化します。
  #       複数のコントロールパネルを使用して、異なる回復フローを整理できます。
  #   - https://docs.aws.amazon.com/r53recovery/latest/dg/introduction-components-routing.html
  control_panel_arn = "arn:aws:route53-recovery-control::123456789012:controlpanel/abd5fbfc052d4844a082dbf400f61da8"
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: ルーティングコントロールのAmazon Resource Name (ARN)
#
# - status: ルーティングコントロールのステータス
#           作成/更新中: "PENDING"
#           削除中: "PENDING_DELETION"
#           それ以外: "DEPLOYED"
#
# - id: ルーティングコントロールのARN（arnと同値）
#---------------------------------------------------------------
