#---------------------------------------------------------------
# AWS Route 53 Application Recovery Controller Safety Rule
#---------------------------------------------------------------
#
# Amazon Route 53 Application Recovery Controller (ARC) の安全ルールをプロビジョニングするリソースです。
# 安全ルールは、ルーティングコントロールの状態変更時に意図しない結果を防ぐための
# セーフガードを提供します。フェイルオープンシナリオの回避や、ルーティングコントロールの
# セットに対する全体的なオン/オフスイッチの実装などに使用されます。
#
# AWS公式ドキュメント:
#   - 安全ルールの作成: https://docs.aws.amazon.com/r53recovery/latest/dg/routing-control.safety-rules.html
#   - ルーティングコントロールコンポーネント: https://docs.aws.amazon.com/r53recovery/latest/dg/introduction-components-routing.html
#   - Application Recovery Controller概要: https://docs.aws.amazon.com/r53recovery/latest/dg/index.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/route53recoverycontrolconfig_safety_rule
#
# Provider Version: 6.28.0
# Generated: 2026-02-04
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

# -----------------------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: 安全ルールを説明する名前を指定します。
  # 設定可能な値: 文字列（1-64文字）
  # 注意: コントロールパネル内で一意である必要があります
  name = "ensure-at-least-one-zone-active"

  # control_panel_arn (Required)
  # 設定内容: この安全ルールが存在するコントロールパネルのARNを指定します。
  # 設定可能な値: 有効なコントロールパネルARN
  # 関連機能: Control Panel
  #   関連するルーティングコントロールをグループ化し、安全ルールを作成できます。
  #   複数の安全ルールを1つのコントロールパネルに関連付けることが可能です。
  #   - https://docs.aws.amazon.com/r53recovery/latest/dg/introduction-components-routing.html
  control_panel_arn = "arn:aws:route53-recovery-control::123456789012:controlpanel/abd5fbfc052d4844a082dbf400f61da8"

  # wait_period_ms (Required)
  # 設定内容: ターゲットルーティングコントロールに対するリクエストが失敗する評価期間をミリ秒単位で指定します。
  # 設定可能な値: 整数（ミリ秒単位、最小値は通常5000ms）
  # 動作: この期間中、ルールに違反する変更リクエストは拒否されます。
  #       例えば、5000msに設定すると、5秒間の待機期間が設定されます。
  wait_period_ms = 5000

  #-------------------------------------------------------------
  # アサーションルール設定
  #-------------------------------------------------------------

  # asserted_controls (Optional)
  # 設定内容: 評価対象となるトランザクションに含まれるルーティングコントロールのARNリストを指定します。
  # 設定可能な値: ルーティングコントロールARNのリスト
  # 用途: ルーティングコントロールの状態変更リクエストが許可されるかを判定します。
  # 関連機能: Assertion Rule
  #   指定された条件（rule_config）に基づいて、asserted_controlsの状態変更を許可または拒否します。
  #   例: 少なくとも1つのコントロールがOnであることを確認し、フェイルオープンを防止します。
  #   - https://docs.aws.amazon.com/r53recovery/latest/dg/routing-control.safety-rules.html
  # 注意: gating_controlsおよびtarget_controlsとは排他的です（アサーションルールで使用）
  asserted_controls = [
    "arn:aws:route53-recovery-control::123456789012:controlpanel/abd5fbfc052d4844a082dbf400f61da8/routingcontrol/12345678-1234-1234-1234-123456789012",
    "arn:aws:route53-recovery-control::123456789012:controlpanel/abd5fbfc052d4844a082dbf400f61da8/routingcontrol/87654321-4321-4321-4321-210987654321"
  ]

  #-------------------------------------------------------------
  # ルール設定
  #-------------------------------------------------------------

  # rule_config (Required)
  # 設定内容: 安全ルールの条件を定義する設定ブロックです。
  rule_config {
    # type (Required)
    # 設定内容: ルールのタイプを指定します。
    # 設定可能な値:
    #   - "ATLEAST": 指定された数以上のコントロールがOnである必要がある
    #   - "AND": すべてのコントロールがOnである必要がある
    #   - "OR": 少なくとも1つのコントロールがOnである必要がある
    # 用途: トラフィックの可用性を維持するための条件を定義します
    type = "ATLEAST"

    # threshold (Required)
    # 設定内容: ATLEASTタイプのルールを指定する場合に設定する必要があるコントロール数を指定します。
    # 設定可能な値: 整数（1以上、asserted_controls/gating_controlsの数以下）
    # 動作: ATLEASTルールの場合、この数以上のコントロールがOnである必要があります。
    #       ANDやORタイプの場合でも指定は必要ですが、実際の評価には影響しません。
    threshold = 1

    # inverted (Required)
    # 設定内容: ルールの論理否定を行うかを指定します。
    # 設定可能な値:
    #   - false: 通常の評価（例: 少なくとも1つのコントロールがOn）
    #   - true: 逆の評価（例: 少なくとも1つのコントロールがOff）
    # 用途: ルールの条件を逆転させたい場合に使用します
    inverted = false
  }

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
    Name        = "multi-az-assertion-rule"
    Environment = "production"
    Purpose     = "prevent-fail-open"
  }
}

# -----------------------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  name               = "manual-override-switch"
  control_panel_arn  = "arn:aws:route53-recovery-control::123456789012:controlpanel/abd5fbfc052d4844a082dbf400f61da8"
  wait_period_ms     = 5000

  #-------------------------------------------------------------
  # ゲーティングルール設定
  #-------------------------------------------------------------

  # gating_controls (Optional)
  # 設定内容: 指定したルール設定によって評価されるゲーティングコントロールのARNリストを指定します。
  # 設定可能な値: ルーティングコントロールARNのリスト
  # 用途: 全体的なスイッチとして機能するルーティングコントロールを定義します。
  # 関連機能: Gating Rule
  #   ゲーティングコントロールの状態に基づいて、ターゲットコントロールの変更を制御します。
  #   最もシンプルな例は、単一のゲーティングコントロールがOnまたはOffに設定されているかです。
  #   - https://docs.aws.amazon.com/r53recovery/latest/dg/routing-control.safety-rules.html
  # 注意: asserted_controlsとは排他的です（ゲーティングルールで使用）
  gating_controls = [
    "arn:aws:route53-recovery-control::123456789012:controlpanel/abd5fbfc052d4844a082dbf400f61da8/routingcontrol/gating-11111111-1111-1111-1111-111111111111"
  ]

  # target_controls (Optional)
  # 設定内容: 指定したrule_configがgating_controlsに対してtrueと評価される場合にのみ、
  #          設定または解除できるルーティングコントロールのARNリストを指定します。
  # 設定可能な値: ルーティングコントロールARNのリスト
  # 動作: ゲーティングルールの条件が満たされない限り、これらのコントロールは変更できません。
  # 用途: 保護が必要なルーティングコントロールのセットを定義します。
  # 注意: gating_controlsと組み合わせて使用します
  target_controls = [
    "arn:aws:route53-recovery-control::123456789012:controlpanel/abd5fbfc052d4844a082dbf400f61da8/routingcontrol/target-22222222-2222-2222-2222-222222222222",
    "arn:aws:route53-recovery-control::123456789012:controlpanel/abd5fbfc052d4844a082dbf400f61da8/routingcontrol/target-33333333-3333-3333-3333-333333333333"
  ]

  #-------------------------------------------------------------
  # ルール設定
  #-------------------------------------------------------------

  rule_config {
    # ゲーティングルールの例: ゲーティングコントロールが1つ以上Onの場合に
    # ターゲットコントロールの変更を許可
    type      = "ATLEAST"
    threshold = 1
    inverted  = false
  }

  tags = {
    Name        = "gating-rule-manual-override"
    Environment = "production"
    Purpose     = "manual-control-switch"
  }
}

# -----------------------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: 安全ルールのAmazon Resource Name (ARN)
#
# - status: 安全ルールのステータス
#        作成/更新中: "PENDING"
#        削除中: "PENDING_DELETION"
#        それ以外: "DEPLOYED"
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------

#---------------------------------------------------------------
# 使用上の注意事項
#---------------------------------------------------------------
# 1. アサーションルールとゲーティングルールは排他的です
#    - asserted_controls を使用する場合、gating_controls と target_controls は使用できません
#    - gating_controls と target_controls を使用する場合、asserted_controls は使用できません
#
# 2. 安全ルール名はコントロールパネル内で一意である必要があります
#
#---------------------------------------------------------------
