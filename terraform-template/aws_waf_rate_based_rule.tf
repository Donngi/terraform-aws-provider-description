#---------------------------------------------------------------
# AWS WAF Rate Based Rule
#---------------------------------------------------------------
#
# AWS WAF（Web Application Firewall）のレートベースルールをプロビジョニングするリソースです。
# レートベースルールは、一定期間内に特定の条件を満たすリクエスト数が閾値を超えた
# IPアドレスからのリクエストを自動的にブロックまたはカウントする機能を提供します。
# DDoS攻撃やブルートフォース攻撃などの大量リクエストによる攻撃対策に使用されます。
#
# 注意: このリソースはAWS WAF Classic用です。新規構築にはAWS WAFv2
#       (aws_wafv2_rate_based_statement)の使用を推奨します。
#
# AWS公式ドキュメント:
#   - AWS WAF Rate Based Rules: https://docs.aws.amazon.com/waf/latest/developerguide/classic-web-acl-rules-creating.html
#   - AWS WAF Classic Developer Guide: https://docs.aws.amazon.com/waf/latest/developerguide/classic-waf-chapter.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/waf_rate_based_rule
#
# Provider Version: 6.28.0
# Generated: 2026-02-19
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_waf_rate_based_rule" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: ルールの名前または説明を指定します。
  # 設定可能な値: 1-128文字の英数字およびハイフン
  # 注意: AWS WAF全体で一意である必要があります。
  name = "example-rate-based-rule"

  # metric_name (Required)
  # 設定内容: このルールに対するAmazon CloudWatchメトリクスの名前または説明を指定します。
  # 設定可能な値: 英数字のみ、128文字以内
  # 注意: スペースやハイフンは使用できません。
  metric_name = "exampleRateBasedRule"

  #-------------------------------------------------------------
  # レート制限設定
  #-------------------------------------------------------------

  # rate_key (Required)
  # 設定内容: レートを追跡するフィールドを指定します。
  # 設定可能な値:
  #   - "IP": リクエストのIPアドレスを基準にレートを計測する（現時点で唯一有効な値）
  rate_key = "IP"

  # rate_limit (Required)
  # 設定内容: rate_keyで指定したフィールドが同一値を持つリクエストの5分間に許可する最大数を指定します。
  # 設定可能な値: 100以上の整数
  # 注意: 最小値は100です。この閾値を超えたIPからのリクエストは自動的にブロック対象になります。
  rate_limit = 2000

  #-------------------------------------------------------------
  # 条件設定
  #-------------------------------------------------------------

  # predicates (Optional)
  # 設定内容: ルールに含めるオブジェクト（条件）を指定します。
  # 関連機能: AWS WAF 条件
  #   predicatesを指定すると、rate_limitと組み合わせた条件でリクエストを評価します。
  #   指定しない場合はすべてのIPアドレスのリクエストレートを計測します。
  predicates {
    # data_id (Required)
    # 設定内容: 条件として使用するAWS WAFオブジェクトのIDを指定します。
    # 設定可能な値: aws_waf_ipset, aws_waf_byte_match_set等のリソースID
    data_id = aws_waf_ipset.example.id

    # negated (Required)
    # 設定内容: 条件を反転させるかどうかを指定します。
    # 設定可能な値:
    #   - false: 条件に一致するリクエストを対象にする
    #   - true: 条件に一致しないリクエストを対象にする
    negated = false

    # type (Required)
    # 設定内容: 条件のタイプを指定します。
    # 設定可能な値:
    #   - "IPMatch": IPアドレス条件（aws_waf_ipset）
    #   - "ByteMatch": バイト一致条件（aws_waf_byte_match_set）
    #   - "SqlInjectionMatch": SQLインジェクション条件（aws_waf_sql_injection_match_set）
    #   - "GeoMatch": 地理的位置条件（aws_waf_geo_match_set）
    #   - "SizeConstraint": サイズ制約条件（aws_waf_size_constraint_set）
    #   - "XssMatch": XSS一致条件（aws_waf_xss_match_set）
    #   - "RegexMatch": 正規表現一致条件（aws_waf_regex_match_set）
    type = "IPMatch"
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
    Name        = "example-rate-based-rule"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: WAFレートベースルールのID
#
# - arn: WAFレートベースルールのAmazon Resource Name (ARN)
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
