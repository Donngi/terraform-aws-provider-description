#---------------------------------------------------------------
# AWS WAFv2 Regex Pattern Set
#---------------------------------------------------------------
#
# AWS WAFv2の正規表現パターンセットをプロビジョニングするリソースです。
# 正規表現パターンセットは、Web ACLやルールグループで使用する
# 正規表現パターンのコレクションを定義します。
# リクエストのURIパス、クエリ文字列、ヘッダー、ボディなどを
# 正規表現でマッチングしてフィルタリングするために使用します。
#
# AWS公式ドキュメント:
#   - 正規表現パターンセットの作成と管理: https://docs.aws.amazon.com/waf/latest/developerguide/waf-regex-pattern-set-creating.html
#   - AWS WAF 開発者ガイド: https://docs.aws.amazon.com/waf/latest/developerguide/
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_regex_pattern_set
#
# Provider Version: 6.28.0
# Generated: 2026-02-19
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_wafv2_regex_pattern_set" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Optional, Forces new resource)
  # 設定内容: 正規表現パターンセットのフレンドリーな名前を指定します。
  # 設定可能な値: 文字列
  # 省略時: Terraformがランダムな一意の名前を生成します。
  # 注意: name_prefixと排他的（どちらか一方のみ指定可能）
  #       パターンセット作成後に名前を変更することはできません。
  name = "example-regex-pattern-set"

  # name_prefix (Optional)
  # 設定内容: パターンセット名のプレフィックスを指定します。
  # 設定可能な値: 文字列。Terraformが後ろにランダムなサフィックスを追加します。
  # 省略時: nameが使用されます。
  # 注意: nameと排他的（どちらか一方のみ指定可能）
  name_prefix = null

  # description (Optional)
  # 設定内容: 正規表現パターンセットのフレンドリーな説明を指定します。
  # 設定可能な値: 文字列
  # 省略時: 説明なし
  description = "Example regex pattern set"

  #-------------------------------------------------------------
  # スコープ設定
  #-------------------------------------------------------------

  # scope (Required)
  # 設定内容: このパターンセットがCloudFrontディストリビューション用か、
  #           リージョナルアプリケーション用かを指定します。
  # 設定可能な値:
  #   - "CLOUDFRONT": Amazon CloudFrontディストリビューションで使用
  #   - "REGIONAL": リージョナルリソース（ALB、API Gateway等）で使用
  # 注意: CLOUDFRONTを指定する場合、リージョンをUS East (N. Virginia)に
  #       設定する必要があります。
  scope = "REGIONAL"

  #-------------------------------------------------------------
  # 正規表現パターン設定
  #-------------------------------------------------------------

  # regular_expression (Optional)
  # 設定内容: AWS WAFが検索する正規表現パターンのブロックを指定します。
  # 設定可能な値: 以下のブロックを1つ以上指定
  #   - regex_string (Required): 正規表現を表す文字列
  #     AWS WAFがサポートする正規表現の詳細は公式ドキュメントを参照してください。
  #     参考: https://docs.aws.amazon.com/waf/latest/developerguide/waf-regex-pattern-set-creating.html
  # 省略時: パターンなし（空のパターンセット）
  regular_expression {
    regex_string = "one"
  }

  regular_expression {
    regex_string = "two"
  }

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # 注意: scopeがCLOUDFRONTの場合、us-east-1を指定する必要があります。
  region = null

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
    Name        = "example-regex-pattern-set"
    Environment = "production"
  }

  # tags_all (Optional)
  # 設定内容: プロバイダーのdefault_tagsを含む全タグのマップ。
  # 注意: この属性は通常、明示的に設定しません。
  #       プロバイダーのdefault_tagsとtagsの組み合わせから自動計算されます。
  # 用途: 明示的に設定する場合は、default_tagsを上書きする場合のみ。
  # tags_all = {}
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: 正規表現パターンセットの一意識別子
#
# - arn: 正規表現パターンセットのAmazon Resource Name (ARN)
#        Web ACLやルールグループで参照する際に使用します。
#
# - lock_token: パターンセットを更新する際に使用するロックトークン。
#               楽観的ロックに使用され、同時更新の競合を防ぎます。
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
