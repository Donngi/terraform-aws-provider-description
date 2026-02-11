#---------------------------------------------------------------
# AWS WAF XSS Match Set
#---------------------------------------------------------------
#
# AWS WAF Classicのクロスサイトスクリプティング（XSS）マッチセットを
# プロビジョニングするリソースです。
# XSSマッチセットは、Webリクエスト内の悪意のあるスクリプトを検出するために
# 検査する部分（URI、クエリ文字列、ヘッダー、ボディ等）を定義します。
#
# AWS公式ドキュメント:
#   - Working with cross-site scripting match conditions: https://docs.aws.amazon.com/waf/latest/developerguide/classic-web-acl-xss-conditions.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/waf_xss_match_set
#
# Provider Version: 6.28.0
# Generated: 2026-02-05
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_waf_xss_match_set" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: XSSマッチセットの名前を指定します。
  # 設定可能な値: 任意の文字列
  # 注意: 作成後に変更するとリソースが再作成されます。
  name = "xss-match-set-example"

  #-------------------------------------------------------------
  # XSSマッチタプル設定
  #-------------------------------------------------------------

  # xss_match_tuples (Optional)
  # 設定内容: クロスサイトスクリプティング攻撃を検査するWebリクエストの部分を指定します。
  # 複数のxss_match_tuplesブロックを定義することで、複数の条件を設定できます。
  # 関連機能: AWS WAF Classic XSSマッチ条件
  #   Webリクエスト内の悪意のあるスクリプトを検出するためのフィルター設定。
  #   - https://docs.aws.amazon.com/waf/latest/developerguide/classic-web-acl-xss-conditions.html

  # 例1: URIを検査
  xss_match_tuples {
    # text_transformation (Required)
    # 設定内容: 検査前にリクエストに適用するテキスト変換を指定します。
    # 設定可能な値:
    #   - "NONE": 変換なし。そのままの値を検査
    #   - "CMD_LINE": コマンドライン用の変換。攻撃者がOSコマンドを難読化するために使用する
    #                 バックスラッシュ、ダブルクォート等の文字を削除/置換
    #   - "COMPRESS_WHITE_SPACE": 複数の連続する空白文字を単一のスペースに圧縮
    #   - "HTML_ENTITY_DECODE": HTMLエンコードされた文字（&quot; など）をデコード
    #   - "LOWERCASE": すべての文字を小文字に変換
    #   - "URL_DECODE": URLエンコードされた文字（%20 など）をデコード
    text_transformation = "NONE"

    # field_to_match (Required)
    # 設定内容: 検査対象のWebリクエストの部分を指定します。
    field_to_match {
      # type (Required)
      # 設定内容: 検査対象のリクエストの部分の種類を指定します。
      # 設定可能な値:
      #   - "BODY": リクエストボディ（POSTリクエストのデータ部分）
      #   - "HEADER": 特定のHTTPヘッダー（dataで名前を指定）
      #   - "METHOD": HTTPメソッド（GET、POST等）
      #   - "QUERY_STRING": URLのクエリ文字列部分（?以降）
      #   - "URI": URLのパス部分（クエリ文字列を除く）
      type = "URI"

      # data (Optional)
      # 設定内容: typeがHEADERの場合、検査するヘッダー名を指定します。
      # 設定可能な値: HTTPヘッダー名（例: "User-Agent", "Referer"）
      # 注意: typeがHEADER以外の場合は指定不要
      # data = null
    }
  }

  # 例2: クエリ文字列を検査
  xss_match_tuples {
    text_transformation = "NONE"

    field_to_match {
      type = "QUERY_STRING"
    }
  }

  # 例3: ヘッダーを検査（HTML_ENTITY_DECODEを適用）
  xss_match_tuples {
    text_transformation = "HTML_ENTITY_DECODE"

    field_to_match {
      type = "HEADER"
      data = "User-Agent"
    }
  }

  # 例4: ボディを検査（URL_DECODEを適用）
  xss_match_tuples {
    text_transformation = "URL_DECODE"

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
# - id: WAF XSSマッチセットのID
#
# - arn: XSSマッチセットのAmazon Resource Name (ARN)
#---------------------------------------------------------------
