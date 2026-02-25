#---------------------------------------------------------------
# AWS WAF Rule (Classic)
#---------------------------------------------------------------
#
# AWS WAF Classic のルールをプロビジョニングするリソースです。
# ルールには条件（predicates）を追加し、WebACLと組み合わせることで
# ウェブリクエストの許可・拒否・カウントを制御できます。
# ルールは複数の条件を持つことができ、すべての条件を満たしたリクエストに対して
# WebACLで定義されたアクションが適用されます。
#
# 注意: このリソースはAWS WAF Classic（レガシー版）に対応します。
#       新規構築の場合はAWS WAFv2（aws_wafv2_web_acl等）の使用を推奨します。
#
# AWS公式ドキュメント:
#   - AWS WAF Classic 概要: https://docs.aws.amazon.com/waf/latest/developerguide/classic-how-aws-waf-works.html
#   - ルールの作成と条件の追加: https://docs.aws.amazon.com/waf/latest/developerguide/classic-web-acl-rules-creating.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/waf_rule
#
# Provider Version: 6.28.0
# Generated: 2026-02-19
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_waf_rule" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: ルールの名前または説明を指定します。
  # 設定可能な値: 任意の文字列
  name = "example-waf-rule"

  # metric_name (Required)
  # 設定内容: このルールに対応するAmazon CloudWatchメトリクスの名前を指定します。
  # 設定可能な値: 英数字（A-Z、a-z、0-9）のみ使用可能。空白文字は使用不可
  metric_name = "exampleWAFRule"

  #-------------------------------------------------------------
  # 条件設定（Predicates）
  #-------------------------------------------------------------

  # predicates (Optional)
  # 設定内容: ルールに含める条件の設定ブロックです。複数指定可能です。
  # 設定内容: リクエストが条件に一致する場合にルールのアクションが適用されます。
  # 関連機能: AWS WAF Classic 条件（Conditions）
  #   IP一致、バイト一致、SQLインジェクション一致、XSS一致、サイズ制約、地理一致等の
  #   条件を組み合わせてルールを定義します。
  #   - https://docs.aws.amazon.com/waf/latest/developerguide/classic-web-acl-rules-creating.html
  predicates {

    # data_id (Required)
    # 設定内容: 条件（IPSet、ByteMatchSet等）の一意識別子を指定します。
    # 設定可能な値: 対応するWAF条件リソースのIDを指定
    data_id = aws_waf_ipset.example.id

    # negated (Required)
    # 設定内容: 条件の一致を反転させるかどうかを指定します。
    # 設定可能な値:
    #   - false: data_idで指定した条件に一致するリクエストにルールを適用
    #   - true: data_idで指定した条件に一致しないリクエストにルールを適用
    negated = false

    # type (Required)
    # 設定内容: 条件の種別を指定します。
    # 設定可能な値:
    #   - "IPMatch": IPアドレス一致条件（aws_waf_ipset）
    #   - "ByteMatch": バイト文字列一致条件（aws_waf_byte_match_set）
    #   - "SqlInjectionMatch": SQLインジェクション一致条件（aws_waf_sql_injection_match_set）
    #   - "XssMatch": クロスサイトスクリプティング一致条件（aws_waf_xss_match_set）
    #   - "SizeConstraint": サイズ制約条件（aws_waf_size_constraint_set）
    #   - "GeoMatch": 地理的一致条件（aws_waf_geo_match_set）
    #   - "RegexMatch": 正規表現一致条件（aws_waf_regex_match_set）
    type = "IPMatch"
  }

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 省略時: タグなし
  # 参考: プロバイダーレベルの default_tags 設定ブロックで定義されたタグと
  #       一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "example-waf-rule"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: WAFルールのID
# - arn: WAFルールのARN
# - tags_all: プロバイダーの default_tags 設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
