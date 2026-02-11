#---------------------------------------------------------------
# AWS WAF Rule Group
#---------------------------------------------------------------
#
# AWS WAF（Web Application Firewall）のルールグループをプロビジョニングするリソースです。
# ルールグループは、Web ACLに追加できる再利用可能なルールの集合を定義します。
# 複数のWeb ACLで同じルールセットを使用する場合に便利です。
#
# 注意: このリソースはAWS WAF Classic用です。新規構築にはAWS WAFv2
#       (aws_wafv2_rule_group)の使用を推奨します。
#
# AWS公式ドキュメント:
#   - AWS WAF Rule Groups: https://docs.aws.amazon.com/waf/latest/developerguide/waf-rule-groups.html
#   - AWS WAF Classic Developer Guide: https://docs.aws.amazon.com/waf/latest/developerguide/classic-waf-chapter.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/waf_rule_group
#
# Provider Version: 6.28.0
# Generated: 2026-02-05
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_waf_rule_group" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: ルールグループの名前を指定します。
  # 設定可能な値: 1-128文字の英数字およびハイフン
  # 注意: AWS WAF全体で一意である必要があります。
  name = "example-rule-group"

  # metric_name (Required)
  # 設定内容: CloudWatchメトリクスに使用されるフレンドリー名を指定します。
  # 設定可能な値: 英数字のみ、128文字以内
  # 関連機能: CloudWatch メトリクス
  #   ルールグループに関連付けられたメトリクスを識別するために使用されます。
  #   メトリクス名は英数字のみで構成され、スペースやハイフンは使用できません。
  metric_name = "exampleRuleGroup"

  #-------------------------------------------------------------
  # ルール設定
  #-------------------------------------------------------------

  # activated_rule (Optional)
  # 設定内容: ルールグループ内でアクティブ化するルールのリストを指定します。
  # 関連機能: AWS WAF ルール
  #   ルールグループには複数のルールを含めることができ、各ルールに対して
  #   優先度とアクションを設定します。ルールは優先度の低い順に評価されます。
  activated_rule {
    # priority (Required)
    # 設定内容: ルールの優先度を指定します。
    # 設定可能な値: 正の整数
    # 注意: 値が小さいほど優先度が高くなります。同じルールグループ内で一意である必要があります。
    priority = 50

    # rule_id (Required)
    # 設定内容: アクティブ化するルールのIDを指定します。
    # 設定可能な値: 有効なAWS WAFルールID
    # 注意: aws_waf_ruleリソースで作成したルールのIDを参照します。
    rule_id = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"

    # type (Optional)
    # 設定内容: ルールのタイプを指定します。
    # 設定可能な値:
    #   - "REGULAR": 通常のルール（デフォルト）
    #   - "RATE_BASED": レートベースのルール
    #   - "GROUP": ルールグループ
    # 省略時: "REGULAR"
    type = "REGULAR"

    # action (Required)
    # 設定内容: ルールに一致したリクエストに対するアクションを指定します。
    action {
      # type (Required)
      # 設定内容: 実行するアクションのタイプを指定します。
      # 設定可能な値:
      #   - "ALLOW": リクエストを許可
      #   - "BLOCK": リクエストをブロック
      #   - "COUNT": リクエストをカウントのみ（ブロックも許可もしない）
      # 関連機能: AWS WAF アクション
      #   COUNTはテスト目的で使用され、ルールの影響を確認できます。
      #   本番環境ではALLOWまたはBLOCKを使用します。
      type = "COUNT"
    }
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
    Name        = "example-rule-group"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: WAFルールグループのID
#
# - arn: WAFルールグループのAmazon Resource Name (ARN)
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
