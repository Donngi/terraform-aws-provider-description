#---------------------------------------------------------------
# AWS WAF Classic Regex Pattern Set
#---------------------------------------------------------------
#
# AWS WAF ClassicのRegex Pattern Setリソースをプロビジョニングします。
# Regex Pattern Setは、Webリクエストの検査に使用する正規表現パターンの
# コレクションを定義します。このパターンセットをRegex Match Conditionで
# 参照することで、特定のパターンに一致するリクエストをフィルタリングできます。
#
# 重要: このリソースはAWS WAF Classic用です。AWS WAF Classicは2025年9月30日に
# サポートが終了します。新規実装ではAWS WAFv2（aws_wafv2_regex_pattern_set）を
# 使用してください。
#
# AWS公式ドキュメント:
#   - AWS WAF Classic Regex Match Conditions: https://docs.aws.amazon.com/waf/latest/developerguide/classic-web-acl-regex-conditions.html
#   - RegexPatternSet API Reference: https://docs.aws.amazon.com/waf/latest/APIReference/API_waf_RegexPatternSet.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/waf_regex_pattern_set
#
# Provider Version: 6.28.0
# Generated: 2026-02-05
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_waf_regex_pattern_set" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: Regex Pattern Setの名前または説明を指定します。
  # 設定可能な値: 文字列（1〜128文字）
  # 用途: AWS WAFコンソールやAPIでこのパターンセットを識別するために使用されます。
  name = "example-regex-pattern-set"

  #-------------------------------------------------------------
  # 正規表現パターン設定
  #-------------------------------------------------------------

  # regex_pattern_strings (Optional)
  # 設定内容: AWS WAFが検索する正規表現パターンのリストを指定します。
  # 設定可能な値: 正規表現パターンの文字列リスト
  #   - 各パターンは最大512文字
  #   - 最大10個のパターンを指定可能
  #   - Perl Compatible Regular Expressions (PCRE) ライブラリの構文をサポート
  # 省略時: 空のパターンセットが作成されます。
  # 関連機能: AWS WAF正規表現パターンマッチング
  #   正規表現パターンを使用してWebリクエストの特定の部分（URI、クエリ文字列、
  #   ヘッダー、HTTPメソッド、ボディなど）を検査できます。
  #   パターンセットを更新すると、そのセットを参照するすべてのルールが自動的に更新されます。
  #   - https://docs.aws.amazon.com/waf/latest/developerguide/classic-web-acl-regex-conditions.html
  # 注意:
  #   - パターンは大文字小文字を区別します
  #   - 一部のPCRE機能（後方参照、キャプチャグループなど）はサポートされていません
  #   - パターンの複雑さによってはパフォーマンスに影響する可能性があります
  regex_pattern_strings = [
    "BadBot",
    "B[a@]dB[o0]t",
    "malicious-pattern-\\d+"
  ]
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: Regex Pattern SetのID。GetRegexPatternSet、UpdateRegexPatternSet、
#       DeleteRegexPatternSetなどのAPIオペレーションで使用されます。
#
# - arn: Regex Pattern SetのAmazon Resource Name (ARN)。
#        IAMポリシーでのリソース指定や、他のAWSサービスとの連携に使用できます。
#---------------------------------------------------------------
