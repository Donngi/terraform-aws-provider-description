#---------------------------------------------------------------
# AWS WAF Regional レートベースルール
#---------------------------------------------------------------
#
# AWS WAF Regional レートベースルールをプロビジョニングするリソースです。
# レートベースルールは、指定したレート制限を超えたIPアドレスからの
# リクエストを自動的にブロックするルールです。
# 一定期間（5分間）内に指定した閾値を超えたリクエストを送信した
# IPアドレスを検出し、自動的にブロックリストに追加します。
# リージョナルルールは、Application Load Balancer (ALB) や
# API Gatewayなどのリージョナルリソースを保護するために使用されます。
#
# 注意: このリソースはAWS WAF Classicを使用しています。
#       AWS WAF Classicは2025年9月30日にサポート終了が予定されています。
#       新規の実装にはAWS WAFv2 (aws_wafv2_rule_group) の使用を推奨します。
#
# AWS公式ドキュメント:
#   - AWS WAF Classic概要: https://docs.aws.amazon.com/waf/latest/developerguide/classic-waf-chapter.html
#   - Rate-based Rules: https://docs.aws.amazon.com/waf/latest/developerguide/classic-waf-rate-based-rule.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafregional_rate_based_rule
#
# Provider Version: 6.28.0
# Generated: 2026-02-19
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_wafregional_rate_based_rule" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: レートベースルールの名前または説明を指定します。
  # 設定可能な値: 文字列
  # 注意: ルールを識別するための名前です。
  name = "example-waf-rate-rule"

  # metric_name (Required)
  # 設定内容: レートベースルールのAmazon CloudWatchメトリクス用の名前を指定します。
  # 設定可能な値: 英数字のみの文字列（特殊文字不可）
  # 注意: CloudWatchメトリクスで使用される名前です。
  #       スペースやハイフンなどの特殊文字は使用できません。
  metric_name = "exampleWafRateRule"

  #-------------------------------------------------------------
  # レート制限設定
  #-------------------------------------------------------------

  # rate_key (Required)
  # 設定内容: レート制限の基準となるキーを指定します。
  # 設定可能な値:
  #   - "IP": 送信元IPアドレスに基づいてリクエスト数を追跡する
  # 注意: 現在はIPのみサポートされています。
  #       5分間のローリングウィンドウ内でrate_limitを超えたIPからの
  #       リクエストは自動的にブロックされます。
  rate_key = "IP"

  # rate_limit (Required)
  # 設定内容: 5分間のローリングウィンドウ内で許可するリクエストの最大数を指定します。
  # 設定可能な値: 100以上2000000000以下の数値
  # 注意: この閾値を超えたIPアドレスからのリクエストは自動的にブロックされます。
  #       最小値は100です。
  rate_limit = 2000

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # 条件（Predicate）設定
  #-------------------------------------------------------------

  # predicate (Optional)
  # 設定内容: レートベースルールに含める条件オブジェクトのセットを指定します。
  # 注意: 複数のpredicateブロックを指定可能です。
  #       すべての条件がAND条件で評価されます。
  #       predicateを省略した場合、rate_keyで指定したキー（IP）の
  #       全リクエストに対してレート制限が適用されます。
  # 関連機能: AWS WAF Classic Predicate
  #   ByteMatchSet、IPSet、SqlInjectionMatchSet、XssMatchSet、
  #   RegexMatchSet、GeoMatchSet、SizeConstraintSetなどの
  #   条件オブジェクトを追加し、レート制限の対象を絞り込みます。
  predicate {
    # data_id (Required)
    # 設定内容: ルール内のPredicateの一意の識別子を指定します。
    # 設定可能な値: 対応するConditionリソースのID
    #   例: aws_wafregional_ipset.id、aws_wafregional_byte_match_set.id など
    # 注意: 対応するCreate/Listコマンドで返されるIDを指定します。
    data_id = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"

    # negated (Required)
    # 設定内容: 条件の設定を否定するかどうかを指定します。
    # 設定可能な値:
    #   - false: 条件に一致するリクエストを対象とする
    #   - true: 条件に一致しないリクエストを対象とする（否定条件）
    # 注意: trueの場合、指定された条件の逆の条件でマッチングします。
    #       例: IPSetに192.0.2.44が含まれる場合、trueにすると
    #       192.0.2.44以外のIPからのリクエストが対象になります。
    negated = false

    # type (Required)
    # 設定内容: ルール内のPredicateのタイプを指定します。
    # 設定可能な値:
    #   - "IPMatch": IPアドレスによるマッチング (aws_wafregional_ipset)
    #   - "ByteMatch": バイトマッチング (aws_wafregional_byte_match_set)
    #   - "SqlInjectionMatch": SQLインジェクション検出 (aws_wafregional_sql_injection_match_set)
    #   - "GeoMatch": 地理的位置によるマッチング (aws_wafregional_geo_match_set)
    #   - "SizeConstraint": リクエストサイズ制約 (aws_wafregional_size_constraint_set)
    #   - "XssMatch": クロスサイトスクリプティング検出 (aws_wafregional_xss_match_set)
    #   - "RegexMatch": 正規表現によるマッチング (aws_wafregional_regex_match_set)
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
    Name        = "example-waf-rate-rule"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: WAF Regional レートベースルールのID
#
# - arn: WAF Regional レートベースルールのAmazon Resource Name (ARN)
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
