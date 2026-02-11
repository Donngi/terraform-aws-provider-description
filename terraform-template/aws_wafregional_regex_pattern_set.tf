#---------------------------------------------------------------
# AWS WAF Regional Regex Pattern Set
#---------------------------------------------------------------
#
# AWS WAF Regional用の正規表現パターンセットをプロビジョニングするリソースです。
# 正規表現パターンセットは、AWS WAFがウェブリクエスト内で検索する正規表現パターンの
# コレクションを定義します。これにより、特定のパターンにマッチするリクエストを
# 許可またはブロックできます。
#
# 注意: AWS WAF Classicは2025年9月30日にサポート終了予定です。
#       新規実装には AWS WAFV2 (aws_wafv2_regex_pattern_set) の使用を推奨します。
#
# AWS公式ドキュメント:
#   - WAF Classic RegexPatternSet: https://docs.aws.amazon.com/waf/latest/APIReference/API_wafRegional_RegexPatternSet.html
#   - AWS WAF Classic: https://docs.aws.amazon.com/waf/latest/developerguide/classic-waf-chapter.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafregional_regex_pattern_set
#
# Provider Version: 6.28.0
# Generated: 2026-02-05
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_wafregional_regex_pattern_set" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: 正規表現パターンセットの名前または説明を指定します。
  # 設定可能な値: 1-128文字の文字列
  # 注意: 作成後に名前を変更することはできません。
  name = "example-regex-pattern-set"

  #-------------------------------------------------------------
  # パターン設定
  #-------------------------------------------------------------

  # regex_pattern_strings (Optional)
  # 設定内容: AWS WAFが検索する正規表現パターンのリストを指定します。
  # 設定可能な値: 正規表現パターンの文字列セット
  #   - 各パターンは1-512文字
  #   - 最大10個のパターンを指定可能
  # 省略時: 空のパターンセットが作成されます。
  # 関連機能: WAF Regex Pattern Matching
  #   正規表現を使用して、悪意のあるボットやスパム送信者を検出するための
  #   パターンマッチングを行います。例: B[a@]dB[o0]t
  #   - https://docs.aws.amazon.com/waf/latest/developerguide/classic-waf-chapter.html
  # 注意: 正規表現はPCRE（Perl Compatible Regular Expressions）構文をサポートしますが、
  #       一部の機能は制限されています。
  regex_pattern_strings = [
    "B[a@]dB[o0]t",
    "malicious-pattern"
  ]

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用します。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # 注意: WAF Regionalリソースは、Application Load Balancer または API Gateway
  #       と同じリージョンに作成する必要があります。
  region = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: WAF Regional Regex Pattern SetのID。
#       RegexPatternSetの取得、更新、削除などの操作で使用されます。
#---------------------------------------------------------------
