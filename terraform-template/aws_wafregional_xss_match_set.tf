#---------------------------------------------------------------
# AWS WAF Regional XSS Match Set
#---------------------------------------------------------------
#
# AWS WAF Regional のクロスサイトスクリプティング（XSS）マッチセットを
# プロビジョニングするリソースです。
# XSSマッチセットは、Webリクエスト内の悪意のあるスクリプトを検出するために
# 検査する部分（URI、クエリ文字列、ヘッダー、ボディ等）を定義します。
# このリソースはAWS WAF Classicのリージョナル版で、Application Load Balancer (ALB)
# および API Gateway と連携して使用します。
#
# 注意: AWS WAF Classic は 2025年9月30日にサポート終了予定です。
#       新規構築には AWS WAFv2 の使用を推奨します。
#
# AWS公式ドキュメント:
#   - Working with cross-site scripting match conditions: https://docs.aws.amazon.com/waf/latest/developerguide/classic-web-acl-xss-conditions.html
#   - AWS WAF Classic: https://docs.aws.amazon.com/waf/latest/developerguide/classic-waf-chapter.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafregional_xss_match_set
#
# Provider Version: 6.28.0
# Generated: 2026-02-19
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_wafregional_xss_match_set" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: XSSマッチセットの名前を指定します。
  # 設定可能な値: 任意の文字列
  name = "xss-match-set-example"

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
  # XSSマッチタプル設定
  #-------------------------------------------------------------

  # xss_match_tuple (Optional)
  # 設定内容: クロスサイトスクリプティング攻撃を検査するWebリクエストの部分を指定します。
  # 注意: 複数のxss_match_tupleブロックを定義可能です。

  # 例1: URIを検査
  xss_match_tuple {
    # text_transformation (Required)
    # 設定内容: 攻撃者がAWS WAFをバイパスするために使用する異常なフォーマットを
    #           排除するためのテキスト変換を指定します。
    # 設定可能な値:
    #   - "NONE": テキスト変換を行わない
    #   - "COMPRESS_WHITE_SPACE": 複数の空白文字を単一のスペースに圧縮
    #   - "HTML_ENTITY_DECODE": HTMLエンコードされた文字をデコード
    #   - "LOWERCASE": 大文字を小文字に変換
    #   - "CMD_LINE": コマンドライン注入攻撃を検出するための変換
    #   - "URL_DECODE": URLエンコードされた値をデコード
    text_transformation = "NONE"

    # field_to_match (Required)
    # 設定内容: AWS WAFが検索するWebリクエストの部分を指定します。
    # 注意: 1つのxss_match_tupleにつき1つのfield_to_matchブロックが必須です。
    field_to_match {
      # type (Required)
      # 設定内容: 検査対象のリクエストの部分の種類を指定します。
      # 設定可能な値:
      #   - "HEADER": リクエストヘッダー。dataでヘッダー名を指定
      #   - "METHOD": HTTPメソッド（GET, POST, PUT, DELETE等）
      #   - "QUERY_STRING": URLの?以降のクエリ文字列
      #   - "URI": URIのパスコンポーネント（クエリ文字列やフラグメントは含まない）
      #   - "BODY": リクエストボディ（最初の8192バイトのみ検査）
      #   - "SINGLE_QUERY_ARG": 指定した単一のクエリパラメータ。dataでパラメータ名を指定
      #   - "ALL_QUERY_ARGS": すべてのクエリパラメータ
      # 参考: https://docs.aws.amazon.com/waf/latest/APIReference/API_waf_FieldToMatch.html
      type = "URI"

      # data (Optional)
      # 設定内容: typeがHEADERの場合は検索対象のヘッダー名、
      #           typeがSINGLE_QUERY_ARGの場合は検索対象のパラメータ名を指定します。
      # 設定可能な値: 1-128文字の文字列（大文字小文字を区別しない）
      # 省略時: typeがHEADERまたはSINGLE_QUERY_ARG以外の場合は省略
      # data = null
    }
  }

  # 例2: クエリ文字列をHTML_ENTITY_DECODEで検査
  xss_match_tuple {
    text_transformation = "HTML_ENTITY_DECODE"

    field_to_match {
      type = "QUERY_STRING"
    }
  }

  # 例3: ヘッダーをURL_DECODEで検査
  xss_match_tuple {
    text_transformation = "URL_DECODE"

    field_to_match {
      type   = "HEADER"
      data   = "User-Agent"
    }
  }

  # 例4: ボディをLOWERCASEで検査
  xss_match_tuple {
    text_transformation = "LOWERCASE"

    field_to_match {
      type = "BODY"
    }
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: WAF Regional XSSマッチセットのID
#
#---------------------------------------------------------------
