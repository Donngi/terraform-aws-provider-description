#---------------------------------------------------------------
# AWS WAFv2 Rule Group
#---------------------------------------------------------------
#
# AWS WAFv2のルールグループをプロビジョニングするリソースです。
# ルールグループは、Webリクエストの検査・制御に使用するルールの集合体で、
# Web ACLに追加して再利用可能なルールセットとして機能します。
# ルールグループには固定のWCU（Web ACL Capacity Units）キャパシティが割り当てられ、
# 作成後に変更することはできません。
#
# AWS公式ドキュメント:
#   - AWS WAFルールグループ: https://docs.aws.amazon.com/waf/latest/developerguide/waf-rule-group-creating.html
#   - AWS WAF APIリファレンス（RuleGroup）: https://docs.aws.amazon.com/waf/latest/APIReference/API_RuleGroup.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_rule_group
#
# Provider Version: 6.28.0
# Generated: 2026-02-06
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_wafv2_rule_group" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Optional, Forces new resource)
  # 設定内容: ルールグループのフレンドリー名を指定します。
  # 設定可能な値: 英数字、ハイフン、アンダースコアを含む文字列
  # 省略時: Terraformがランダムな一意の名前を生成します。
  # 注意: name_prefixと排他的（どちらか一方のみ指定可能）。作成後に変更不可。
  name = "example-rule-group"

  # name_prefix (Optional, Forces new resource)
  # 設定内容: ルールグループ名のプレフィックスを指定します。
  # 設定可能な値: 文字列。Terraformが後ろにランダムなサフィックスを追加します。
  # 注意: nameと排他的（どちらか一方のみ指定可能）
  name_prefix = null

  # description (Optional)
  # 設定内容: ルールグループのフレンドリーな説明を指定します。
  # 設定可能な値: 任意の文字列
  description = "Example WAFv2 rule group"

  # scope (Required, Forces new resource)
  # 設定内容: ルールグループのスコープを指定します。
  # 設定可能な値:
  #   - "REGIONAL": リージョナルアプリケーション（ALB、API Gateway、AppSync等）向け
  #   - "CLOUDFRONT": Amazon CloudFrontディストリビューション向け
  # 注意: CLOUDFRONTを指定する場合、AWSプロバイダーのリージョンをus-east-1に設定する必要があります。
  scope = "REGIONAL"

  # capacity (Required, Forces new resource)
  # 設定内容: ルールグループが使用するWeb ACLキャパシティユニット（WCU）を指定します。
  # 設定可能な値: 正の整数値
  # 関連機能: WAF WCU（Web ACL Capacity Units）
  #   各ルールのWCU消費量はステートメントの種類によって異なります。
  #   作成後にキャパシティを変更することはできません。
  #   - https://docs.aws.amazon.com/waf/latest/developerguide/waf-rule-statements-list.html
  capacity = 100

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
  # ルール設定（HCLブロック形式）
  #-------------------------------------------------------------
  # rule (Optional)
  # 設定内容: Webリクエストの検査・制御に使用するルールブロックを定義します。
  # 注意: rules_jsonと排他的（どちらか一方のみ指定可能）。
  #       HCLブロック形式ではネストは最大3階層まで。それ以上の場合はrules_jsonを使用。

  rule {
    # name (Required, Forces new resource)
    # 設定内容: ルールのフレンドリー名を指定します。
    name = "rule-1"

    # priority (Required)
    # 設定内容: ルールの評価優先度を指定します。
    # 設定可能な値: 正の整数値（小さい値ほど先に評価）
    # 関連機能: WAFルール優先度
    #   Web ACL内で複数のルールが定義されている場合、priorityの値が小さいルールから順に評価されます。
    priority = 1

    #-----------------------------------------------------------
    # ルールアクション設定
    #-----------------------------------------------------------
    # action (Required)
    # 設定内容: ルールのステートメントに一致したWebリクエストに対するアクションを定義します。
    # 注意: Web ACLレベルの設定でルールアクションをオーバーライドできます。

    action {
      # 以下のいずれか1つを指定:
      #   - allow: リクエストを許可
      #   - block: リクエストをブロック
      #   - count: リクエストをカウント（許可しつつ記録）
      #   - captcha: CAPTCHAチャレンジを実行
      #   - challenge: チャレンジを実行（正当なブラウザか検証）

      # --- allow ---
      # allow (Optional)
      # 設定内容: Webリクエストを許可します。
      allow {
        # custom_request_handling (Optional)
        # 設定内容: リクエストに対するカスタムヘッダの挿入等のカスタム処理を定義します。
        # custom_request_handling {
        #   # insert_header (Required, 1つ以上)
        #   # 設定内容: リクエストに挿入するHTTPヘッダを指定します。
        #   # 注意: ヘッダ名にはAWS WAFが自動的に "x-amzn-waf-" プレフィックスを付与します。
        #   insert_header {
        #     name  = "x-custom-header"
        #     value = "custom-value"
        #   }
        # }
      }

      # --- block ---
      # block (Optional)
      # 設定内容: Webリクエストをブロックします。
      # block {
      #   # custom_response (Optional)
      #   # 設定内容: ブロック時に返すカスタムレスポンスを定義します。
      #   # custom_response {
      #   #   # response_code (Required)
      #   #   # 設定内容: 返却するHTTPステータスコードを指定します。
      #   #   response_code = 403
      #   #
      #   #   # custom_response_body_key (Optional)
      #   #   # 設定内容: custom_response_bodyブロックで定義したキーを参照します。
      #   #   custom_response_body_key = "custom_403"
      #   #
      #   #   # response_header (Optional)
      #   #   # 設定内容: レスポンスに追加するHTTPヘッダを指定します。
      #   #   response_header {
      #   #     name  = "x-custom-response-header"
      #   #     value = "blocked"
      #   #   }
      #   # }
      # }

      # --- count ---
      # count (Optional)
      # 設定内容: Webリクエストをカウントし、許可します。
      # count {
      #   # custom_request_handling (Optional)
      #   # 設定内容: allowと同様のカスタムリクエスト処理を定義できます。
      # }

      # --- captcha ---
      # captcha (Optional)
      # 設定内容: CAPTCHAチャレンジを実行します。
      # captcha {
      #   # custom_request_handling (Optional)
      #   # 設定内容: allowと同様のカスタムリクエスト処理を定義できます。
      # }

      # --- challenge ---
      # challenge (Optional)
      # 設定内容: 正当なブラウザセッションからのリクエストかを検証するチャレンジを実行します。
      # challenge {
      #   # custom_request_handling (Optional)
      #   # 設定内容: allowと同様のカスタムリクエスト処理を定義できます。
      # }
    }

    #-----------------------------------------------------------
    # ステートメント設定
    #-----------------------------------------------------------
    # statement (Required)
    # 設定内容: Webリクエストの検査条件を定義します。
    # 注意: 以下のステートメントタイプから1つを選択して指定します。
    #   論理ステートメント: and_statement, or_statement, not_statement
    #   マッチステートメント: byte_match_statement, geo_match_statement,
    #     ip_set_reference_statement, label_match_statement, regex_match_statement,
    #     regex_pattern_set_reference_statement, size_constraint_statement,
    #     sqli_match_statement, xss_match_statement, asn_match_statement
    #   レート制限: rate_based_statement

    statement {

      # =====================================================
      # byte_match_statement (Optional)
      # 設定内容: Webリクエストの指定部分に対する文字列マッチ検索を定義します。
      # =====================================================
      byte_match_statement {
        # search_string (Required)
        # 設定内容: 検索する文字列を指定します。
        # 設定可能な値: 最大50バイトの文字列
        search_string = "bad-bot"

        # positional_constraint (Required)
        # 設定内容: 検索対象内で文字列をどのように検索するかを指定します。
        # 設定可能な値:
        #   - "EXACTLY": 完全一致
        #   - "STARTS_WITH": 前方一致
        #   - "ENDS_WITH": 後方一致
        #   - "CONTAINS": 部分一致
        #   - "CONTAINS_WORD": 単語一致
        # 参考: https://docs.aws.amazon.com/waf/latest/APIReference/API_ByteMatchStatement.html
        positional_constraint = "CONTAINS"

        # field_to_match (Required)
        # 設定内容: 検査対象のWebリクエストコンポーネントを指定します。
        # 注意: 以下のいずれか1つを指定します。
        field_to_match {
          # --- uri_path ---
          # uri_path (Optional)
          # 設定内容: リクエストURIパスを検査します（例: /images/daily-ad.jpg）。
          uri_path {}

          # --- all_query_arguments ---
          # all_query_arguments (Optional)
          # 設定内容: すべてのクエリ引数を検査します。
          # all_query_arguments {}

          # --- body ---
          # body (Optional)
          # 設定内容: リクエストボディを検査します。
          # body {
          #   # oversize_handling (Optional)
          #   # 設定内容: リクエストボディが検査上限を超えた場合の処理を指定します。
          #   # 設定可能な値: "CONTINUE", "MATCH", "NO_MATCH"
          #   # 参考: https://docs.aws.amazon.com/waf/latest/developerguide/waf-rule-statement-oversize-handling.html
          #   oversize_handling = "CONTINUE"
          # }

          # --- cookies ---
          # cookies (Optional)
          # 設定内容: リクエストのCookieを検査します。
          # cookies {
          #   # match_scope (Required)
          #   # 設定内容: 検査対象のCookieの範囲を指定します。
          #   # 設定可能な値: "ALL", "KEY", "VALUE"
          #   match_scope = "ALL"
          #
          #   # oversize_handling (Required)
          #   # 設定内容: Cookieが検査上限（8KB/200個）を超えた場合の処理を指定します。
          #   # 設定可能な値: "CONTINUE", "MATCH", "NO_MATCH"
          #   oversize_handling = "CONTINUE"
          #
          #   # match_pattern (Required)
          #   # 設定内容: 検査対象のCookieを絞り込むフィルタを指定します。
          #   # 注意: all, included_cookies, excluded_cookiesのいずれか1つを指定
          #   match_pattern {
          #     all {}
          #     # included_cookies = ["session-id"]
          #     # excluded_cookies = ["tracking"]
          #   }
          # }

          # --- headers ---
          # headers (Optional)
          # 設定内容: リクエストヘッダを検査します。
          # headers {
          #   # match_scope (Required)
          #   # 設定内容: 検査対象のヘッダの範囲を指定します。
          #   # 設定可能な値: "ALL", "Key", "Value"
          #   match_scope = "ALL"
          #
          #   # oversize_handling (Required)
          #   # 設定内容: ヘッダが検査上限を超えた場合の処理を指定します。
          #   # 設定可能な値: "CONTINUE", "MATCH", "NO_MATCH"
          #   oversize_handling = "CONTINUE"
          #
          #   # match_pattern (Required)
          #   # 設定内容: 検査対象のヘッダを絞り込むフィルタを指定します。
          #   # 注意: all, included_headers, excluded_headersのいずれか1つを指定
          #   match_pattern {
          #     all {}
          #     # included_headers = ["referer"]
          #     # excluded_headers = ["host"]
          #   }
          # }

          # --- header_order ---
          # header_order (Optional)
          # 設定内容: リクエストヘッダの順序を検査します。
          # header_order {
          #   # oversize_handling (Required)
          #   # 設定可能な値: "CONTINUE", "MATCH", "NO_MATCH"
          #   oversize_handling = "CONTINUE"
          # }

          # --- single_header ---
          # single_header (Optional)
          # 設定内容: 単一のリクエストヘッダを検査します。
          # single_header {
          #   # name (Required)
          #   # 設定内容: 検査するヘッダ名（小文字で指定）
          #   name = "user-agent"
          # }

          # --- single_query_argument ---
          # single_query_argument (Optional)
          # 設定内容: 単一のクエリ引数を検査します。
          # single_query_argument {
          #   # name (Required)
          #   # 設定内容: 検査するクエリ引数名（小文字で指定）
          #   name = "username"
          # }

          # --- query_string ---
          # query_string (Optional)
          # 設定内容: クエリ文字列全体（URLの ? 以降の部分）を検査します。
          # query_string {}

          # --- method ---
          # method (Optional)
          # 設定内容: HTTPメソッド（GET, POST等）を検査します。
          # method {}

          # --- json_body ---
          # json_body (Optional)
          # 設定内容: リクエストボディをJSONとして検査します。
          # json_body {
          #   # match_scope (Required)
          #   # 設定内容: JSON内の検査対象を指定します。
          #   # 設定可能な値: "ALL", "KEY", "VALUE"
          #   match_scope = "ALL"
          #
          #   # invalid_fallback_behavior (Optional)
          #   # 設定内容: JSONパースに失敗した場合の処理を指定します。
          #   # 設定可能な値: "EVALUATE_AS_STRING", "MATCH", "NO_MATCH"
          #   # 省略時: 最初のパース失敗箇所まで評価
          #   invalid_fallback_behavior = "EVALUATE_AS_STRING"
          #
          #   # oversize_handling (Optional)
          #   # 設定内容: ボディが検査上限を超えた場合の処理を指定します。
          #   # 設定可能な値: "CONTINUE" (デフォルト), "MATCH", "NO_MATCH"
          #   oversize_handling = "CONTINUE"
          #
          #   # match_pattern (Required)
          #   # 設定内容: JSON内の検査対象パターンを指定します。
          #   # 注意: allまたはincluded_pathsのいずれか1つを指定
          #   # 参考: https://docs.aws.amazon.com/waf/latest/APIReference/API_JsonMatchPattern.html
          #   match_pattern {
          #     all {}
          #     # included_paths = ["/login", "/admin"]
          #   }
          # }

          # --- ja3_fingerprint ---
          # ja3_fingerprint (Optional)
          # 設定内容: JA3フィンガープリントを検査します。
          # ja3_fingerprint {
          #   # fallback_behavior (Required)
          #   # 設定内容: JA3フィンガープリントが取得できない場合のマッチステータスを指定します。
          #   # 設定可能な値: "MATCH", "NO_MATCH"
          #   fallback_behavior = "NO_MATCH"
          # }

          # --- ja4_fingerprint ---
          # ja4_fingerprint (Optional)
          # 設定内容: JA4フィンガープリントを検査します。
          # ja4_fingerprint {
          #   # fallback_behavior (Required)
          #   # 設定内容: JA4フィンガープリントが取得できない場合のマッチステータスを指定します。
          #   # 設定可能な値: "MATCH", "NO_MATCH"
          #   fallback_behavior = "NO_MATCH"
          # }

          # --- uri_fragment ---
          # uri_fragment (Optional)
          # 設定内容: URIフラグメント（URLの # 以降の部分）を検査します。
          # uri_fragment {
          #   # fallback_behavior (Optional)
          #   # 設定内容: URIフラグメントの処理失敗時のマッチステータスを指定します。
          #   # 設定可能な値: "MATCH" (デフォルト), "NO_MATCH"
          #   fallback_behavior = "MATCH"
          # }
        }

        # text_transformation (Required, 1つ以上)
        # 設定内容: 検査前にリクエストコンポーネントに適用するテキスト変換を指定します。
        # 関連機能: テキスト変換
        #   攻撃者が検出を回避するために使用する異常なフォーマットを排除します。
        #   複数指定時はpriorityの値が小さい順に適用されます。
        #   - https://docs.aws.amazon.com/waf/latest/APIReference/API_TextTransformation.html
        text_transformation {
          # priority (Required)
          # 設定内容: テキスト変換の適用順序を指定します（小さい値が先に適用）。
          priority = 0

          # type (Required)
          # 設定内容: 適用するテキスト変換のタイプを指定します。
          # 設定可能な値:
          #   - "NONE": 変換なし
          #   - "LOWERCASE": 小文字変換
          #   - "HTML_ENTITY_DECODE": HTMLエンティティのデコード
          #   - "URL_DECODE": URLデコード
          #   - "CMD_LINE": コマンドライン正規化
          #   - "COMPRESS_WHITE_SPACE": 空白圧縮
          #   - "BASE64_DECODE": Base64デコード
          #   - "HEX_DECODE": 16進数デコード
          #   - "BASE64_DECODE_EXT": 拡張Base64デコード
          #   - "UTF8_TO_UNICODE": UTF-8からUnicodeへの変換
          #   - "CSS_DECODE": CSSデコード
          #   - "JS_DECODE": JavaScriptデコード
          #   - "NORMALIZE_PATH": パス正規化
          #   - "NORMALIZE_PATH_WIN": Windowsパス正規化
          #   - "REMOVE_NULLS": null文字の削除
          #   - "REPLACE_NULLS": null文字の置換
          #   - "REPLACE_COMMENTS": コメントの置換
          #   - "SQL_HEX_DECODE": SQL 16進数デコード
          #   - "URL_DECODE_UNI": Unicode URLデコード
          type = "NONE"
        }
      }

      # =====================================================
      # geo_match_statement (Optional)
      # 設定内容: リクエスト元の国に基づいてWebリクエストを識別します。
      # =====================================================
      # geo_match_statement {
      #   # country_codes (Required)
      #   # 設定内容: ISO 3166 alpha-2の国コードリストを指定します。
      #   # 設定可能な値: "US", "JP", "CN", "NL"等のISO 3166-1 alpha-2コード
      #   # 参考: https://docs.aws.amazon.com/waf/latest/APIReference/API_GeoMatchStatement.html
      #   country_codes = ["US", "JP"]
      #
      #   # forwarded_ip_config (Optional)
      #   # 設定内容: リクエスト元IPの代わりにHTTPヘッダからIPアドレスを取得する設定です。
      #   # forwarded_ip_config {
      #   #   # fallback_behavior (Required)
      #   #   # 設定内容: 指定ヘッダに有効なIPが含まれない場合のマッチステータスを指定します。
      #   #   # 設定可能な値: "MATCH", "NO_MATCH"
      #   #   fallback_behavior = "NO_MATCH"
      #   #
      #   #   # header_name (Required)
      #   #   # 設定内容: IPアドレスを含むHTTPヘッダ名を指定します。
      #   #   header_name = "X-Forwarded-For"
      #   # }
      # }

      # =====================================================
      # ip_set_reference_statement (Optional)
      # 設定内容: IPセットを参照してWebリクエストを検査します。
      # =====================================================
      # ip_set_reference_statement {
      #   # arn (Required)
      #   # 設定内容: 参照するIPセットのARNを指定します。
      #   arn = "arn:aws:wafv2:ap-northeast-1:123456789012:regional/ipset/example/12345678-1234-1234-1234-123456789012"
      #
      #   # ip_set_forwarded_ip_config (Optional)
      #   # 設定内容: HTTPヘッダからIPアドレスを取得する設定です。
      #   # ip_set_forwarded_ip_config {
      #   #   # fallback_behavior (Required)
      #   #   # 設定可能な値: "MATCH", "NO_MATCH"
      #   #   fallback_behavior = "NO_MATCH"
      #   #
      #   #   # header_name (Required)
      #   #   # 設定内容: IPアドレスを含むHTTPヘッダ名を指定します。
      #   #   header_name = "X-Forwarded-For"
      #   #
      #   #   # position (Required)
      #   #   # 設定内容: ヘッダ内のIPアドレスの位置を指定します。
      #   #   # 設定可能な値:
      #   #   #   - "FIRST": 最初のIPアドレス
      #   #   #   - "LAST": 最後のIPアドレス
      #   #   #   - "ANY": いずれかのIPアドレス（10個を超える場合は最後の10個を検査）
      #   #   position = "FIRST"
      #   # }
      # }

      # =====================================================
      # asn_match_statement (Optional)
      # 設定内容: リクエストのIPアドレスに関連付けられたASN（自律システム番号）に基づいて検査します。
      # =====================================================
      # asn_match_statement {
      #   # asn_list (Required)
      #   # 設定内容: ASN番号のリストを指定します。
      #   asn_list = [15169, 16509]
      #
      #   # forwarded_ip_config (Optional)
      #   # 設定内容: geo_match_statementと同様のフォワードIP設定です。
      #   # forwarded_ip_config {
      #   #   fallback_behavior = "NO_MATCH"
      #   #   header_name       = "X-Forwarded-For"
      #   # }
      # }

      # =====================================================
      # label_match_statement (Optional)
      # 設定内容: Web ACL内で先行するルールが付与したラベルに基づいてマッチングします。
      # =====================================================
      # label_match_statement {
      #   # scope (Required)
      #   # 設定内容: ラベル名全体でマッチするか、名前空間のみでマッチするかを指定します。
      #   # 設定可能な値:
      #   #   - "LABEL": ラベル名全体でマッチ
      #   #   - "NAMESPACE": 名前空間のみでマッチ
      #   scope = "LABEL"
      #
      #   # key (Required)
      #   # 設定内容: マッチング対象のラベル文字列を指定します。
      #   key = "awswaf:managed:aws:bot-control:bot:verified"
      # }

      # =====================================================
      # regex_match_statement (Optional)
      # 設定内容: 単一の正規表現パターンでWebリクエストコンポーネントを検査します。
      # =====================================================
      # regex_match_statement {
      #   # regex_string (Required)
      #   # 設定内容: 正規表現パターンを指定します。
      #   # 設定可能な値: 最大200文字の正規表現文字列
      #   # 参考: https://docs.aws.amazon.com/waf/latest/developerguide/limits.html
      #   regex_string = "[a-z]([a-z0-9_-]*[a-z0-9])?"
      #
      #   # field_to_match (Required)
      #   # 設定内容: 検査対象のWebリクエストコンポーネント（byte_match_statementと同様）
      #   field_to_match {
      #     uri_path {}
      #   }
      #
      #   # text_transformation (Required, 1つ以上)
      #   # 設定内容: byte_match_statementと同様のテキスト変換
      #   text_transformation {
      #     priority = 0
      #     type     = "NONE"
      #   }
      # }

      # =====================================================
      # regex_pattern_set_reference_statement (Optional)
      # 設定内容: 正規表現パターンセットを参照してWebリクエストを検査します。
      # =====================================================
      # regex_pattern_set_reference_statement {
      #   # arn (Required)
      #   # 設定内容: 参照する正規表現パターンセットのARNを指定します。
      #   arn = "arn:aws:wafv2:ap-northeast-1:123456789012:regional/regexpatternset/example/12345678-1234-1234-1234-123456789012"
      #
      #   # field_to_match (Required)
      #   # 設定内容: 検査対象のWebリクエストコンポーネント（byte_match_statementと同様）
      #   field_to_match {
      #     uri_path {}
      #   }
      #
      #   # text_transformation (Required, 1つ以上)
      #   text_transformation {
      #     priority = 0
      #     type     = "NONE"
      #   }
      # }

      # =====================================================
      # size_constraint_statement (Optional)
      # 設定内容: リクエストコンポーネントのサイズと指定値を比較します。
      # =====================================================
      # size_constraint_statement {
      #   # comparison_operator (Required)
      #   # 設定内容: 比較演算子を指定します。
      #   # 設定可能な値: "EQ", "NE", "LE", "LT", "GE", "GT"
      #   comparison_operator = "GT"
      #
      #   # size (Required)
      #   # 設定内容: 比較対象のサイズ（バイト）を指定します。
      #   # 設定可能な値: 0 ~ 21474836480
      #   size = 8192
      #
      #   # field_to_match (Optional)
      #   # 設定内容: 検査対象のWebリクエストコンポーネント（byte_match_statementと同様）
      #   field_to_match {
      #     body {}
      #   }
      #
      #   # text_transformation (Required, 1つ以上)
      #   text_transformation {
      #     priority = 0
      #     type     = "NONE"
      #   }
      # }

      # =====================================================
      # sqli_match_statement (Optional)
      # 設定内容: SQLインジェクション攻撃を検出するためWebリクエストを検査します。
      # =====================================================
      # sqli_match_statement {
      #   # sensitivity_level (Optional)
      #   # 設定内容: SQLインジェクション検出の感度レベルを指定します。
      #   # 設定可能な値:
      #   #   - "LOW": 低感度（誤検知が少ない）
      #   #   - "HIGH": 高感度（より多くの攻撃を検出するが誤検知の可能性あり）
      #   sensitivity_level = "HIGH"
      #
      #   # field_to_match (Required)
      #   # 設定内容: 検査対象のWebリクエストコンポーネント（byte_match_statementと同様）
      #   field_to_match {
      #     body {}
      #   }
      #
      #   # text_transformation (Required, 1つ以上)
      #   text_transformation {
      #     priority = 0
      #     type     = "URL_DECODE"
      #   }
      # }

      # =====================================================
      # xss_match_statement (Optional)
      # 設定内容: クロスサイトスクリプティング（XSS）攻撃を検出するためWebリクエストを検査します。
      # =====================================================
      # xss_match_statement {
      #   # field_to_match (Required)
      #   # 設定内容: 検査対象のWebリクエストコンポーネント（byte_match_statementと同様）
      #   field_to_match {
      #     body {}
      #   }
      #
      #   # text_transformation (Required, 1つ以上)
      #   text_transformation {
      #     priority = 0
      #     type     = "NONE"
      #   }
      # }

      # =====================================================
      # rate_based_statement (Optional)
      # 設定内容: 送信元IPアドレス等のキーごとにリクエストレートを追跡し、
      #   制限を超えた場合にルールアクションを実行します。
      # 注意: このステートメントはネストできません（トップレベルのstatementにのみ記述可能）。
      # =====================================================
      # rate_based_statement {
      #   # limit (Required)
      #   # 設定内容: 評価ウィンドウ内の最大リクエスト数を指定します。
      #   # 設定可能な値: 100以上の整数値
      #   limit = 1000
      #
      #   # aggregate_key_type (Optional)
      #   # 設定内容: リクエスト集計のキータイプを指定します。
      #   # 設定可能な値:
      #   #   - "IP" (デフォルト): 送信元IPアドレスで集計
      #   #   - "FORWARDED_IP": フォワードIPヘッダのIPアドレスで集計
      #   #   - "CUSTOM_KEYS": カスタムキーで集計
      #   #   - "CONSTANT": すべてのリクエストを集計（scope_down_statementが必要）
      #   aggregate_key_type = "IP"
      #
      #   # evaluation_window_sec (Optional)
      #   # 設定内容: リクエスト数のカウント対象期間（秒）を指定します。
      #   # 設定可能な値: 60, 120, 300, 600
      #   # 省略時: 300（5分）
      #   # 注意: チェック頻度ではなく、遡って確認する期間を定義します（チェックは約10秒ごと）。
      #   evaluation_window_sec = 300
      #
      #   # forwarded_ip_config (Optional)
      #   # 設定内容: aggregate_key_typeがFORWARDED_IPの場合に必須。
      #   #   HTTPヘッダからIPアドレスを取得する設定です。
      #   # forwarded_ip_config {
      #   #   fallback_behavior = "NO_MATCH"
      #   #   header_name       = "X-Forwarded-For"
      #   # }
      #
      #   # custom_key (Optional, 最大5個)
      #   # 設定内容: aggregate_key_typeがCUSTOM_KEYSの場合に使用。
      #   #   集計に使用するカスタムキーを定義します。
      #   # custom_key {
      #   #   # 以下のいずれかを指定（複数のcustom_keyブロックで異なるキーを組み合わせ可能）:
      #   #
      #   #   # --- asn ---
      #   #   # ASN番号をキーとして使用
      #   #   # asn {}
      #   #
      #   #   # --- cookie ---
      #   #   # 指定Cookieの値をキーとして使用
      #   #   # cookie {
      #   #   #   name = "session-id"
      #   #   #   text_transformation {
      #   #   #     priority = 0
      #   #   #     type     = "NONE"
      #   #   #   }
      #   #   # }
      #   #
      #   #   # --- forwarded_ip ---
      #   #   # フォワードIPをキーとして使用
      #   #   # forwarded_ip {}
      #   #
      #   #   # --- header ---
      #   #   # 指定ヘッダの値をキーとして使用
      #   #   # header {
      #   #   #   name = "x-api-key"
      #   #   #   text_transformation {
      #   #   #     priority = 0
      #   #   #     type     = "NONE"
      #   #   #   }
      #   #   # }
      #   #
      #   #   # --- http_method ---
      #   #   # HTTPメソッドをキーとして使用
      #   #   # http_method {}
      #   #
      #   #   # --- ip ---
      #   #   # 送信元IPアドレスをキーとして使用
      #   #   # ip {}
      #   #
      #   #   # --- ja3_fingerprint ---
      #   #   # JA3フィンガープリントをキーとして使用
      #   #   # ja3_fingerprint {
      #   #   #   fallback_behavior = "NO_MATCH"
      #   #   # }
      #   #
      #   #   # --- ja4_fingerprint ---
      #   #   # JA4フィンガープリントをキーとして使用
      #   #   # ja4_fingerprint {
      #   #   #   fallback_behavior = "NO_MATCH"
      #   #   # }
      #   #
      #   #   # --- label_namespace ---
      #   #   # ラベル名前空間をキーとして使用
      #   #   # label_namespace {
      #   #   #   namespace = "awswaf:managed:aws:bot-control:"
      #   #   # }
      #   #
      #   #   # --- query_argument ---
      #   #   # 指定クエリ引数の値をキーとして使用
      #   #   # query_argument {
      #   #   #   name = "user_id"
      #   #   #   text_transformation {
      #   #   #     priority = 0
      #   #   #     type     = "NONE"
      #   #   #   }
      #   #   # }
      #   #
      #   #   # --- query_string ---
      #   #   # クエリ文字列全体をキーとして使用
      #   #   # query_string {
      #   #   #   text_transformation {
      #   #   #     priority = 0
      #   #   #     type     = "NONE"
      #   #   #   }
      #   #   # }
      #   #
      #   #   # --- uri_path ---
      #   #   # URIパスをキーとして使用
      #   #   # uri_path {
      #   #   #   text_transformation {
      #   #   #     priority = 0
      #   #   #     type     = "NONE"
      #   #   #   }
      #   #   # }
      #   # }
      #
      #   # scope_down_statement (Optional)
      #   # 設定内容: レートベースステートメントの対象を絞り込むネストステートメントです。
      #   #   aggregate_key_typeがCONSTANTの場合は必須。
      #   #   ネスト可能なステートメント（rate_based_statement以外）を指定できます。
      #   # scope_down_statement {
      #   #   geo_match_statement {
      #   #     country_codes = ["US"]
      #   #   }
      #   # }
      # }

      # =====================================================
      # 論理ステートメント
      # =====================================================

      # --- and_statement ---
      # and_statement (Optional)
      # 設定内容: 複数のステートメントをAND条件で組み合わせます。
      # and_statement {
      #   # statement (Required, 複数指定)
      #   # 設定内容: AND条件で結合するステートメントを指定します。
      #   # 注意: ネスト可能なステートメントを指定できます。
      #   #       HCL形式では最大3階層までのネストが可能です。
      #   statement {
      #     geo_match_statement {
      #       country_codes = ["US"]
      #     }
      #   }
      #   statement {
      #     byte_match_statement {
      #       search_string         = "badbot"
      #       positional_constraint = "CONTAINS"
      #       field_to_match {
      #         uri_path {}
      #       }
      #       text_transformation {
      #         priority = 0
      #         type     = "NONE"
      #       }
      #     }
      #   }
      # }

      # --- or_statement ---
      # or_statement (Optional)
      # 設定内容: 複数のステートメントをOR条件で組み合わせます。
      # or_statement {
      #   statement {
      #     # ネスト可能な任意のステートメントを指定
      #   }
      #   statement {
      #     # ネスト可能な任意のステートメントを指定
      #   }
      # }

      # --- not_statement ---
      # not_statement (Optional)
      # 設定内容: ステートメントの結果を否定（反転）します。
      # not_statement {
      #   # statement (Required, 1つのみ)
      #   statement {
      #     # ネスト可能な任意のステートメントを指定
      #   }
      # }
    }

    #-----------------------------------------------------------
    # ルールラベル設定
    #-----------------------------------------------------------
    # rule_label (Optional)
    # 設定内容: ルールに一致したWebリクエストに付与するラベルを定義します。
    # 関連機能: WAFラベル
    #   ラベルはWeb ACL内の後続ルールでlabel_match_statementを使用して参照できます。
    # rule_label {
    #   # name (Required)
    #   # 設定内容: ラベル文字列を指定します。
    #   name = "my-label"
    # }

    #-----------------------------------------------------------
    # CAPTCHAコンフィグ設定
    #-----------------------------------------------------------
    # captcha_config (Optional)
    # 設定内容: CAPTCHA評価のカスタム設定を定義します。

    # captcha_config {
    #   # immunity_time_property (Optional)
    #   # 設定内容: CAPTCHAの免除時間を定義します。
    #   # immunity_time_property {
    #   #   # immunity_time (Optional)
    #   #   # 設定内容: CAPTCHAタイムスタンプの有効期間（秒）を指定します。
    #   #   # 省略時: 300秒
    #   #   immunity_time = 300
    #   # }
    # }

    #-----------------------------------------------------------
    # ルールのVisibility Config設定
    #-----------------------------------------------------------
    # visibility_config (Required)
    # 設定内容: ルールごとのCloudWatchメトリクスとサンプルリクエスト収集を定義します。

    visibility_config {
      # cloudwatch_metrics_enabled (Required)
      # 設定内容: CloudWatchメトリクスの送信を有効にするかを指定します。
      # 設定可能な値: true, false
      # 参考: https://docs.aws.amazon.com/waf/latest/developerguide/monitoring-cloudwatch.html#waf-metrics
      cloudwatch_metrics_enabled = true

      # metric_name (Required, Forces new resource)
      # 設定内容: CloudWatchメトリクスのフレンドリー名を指定します。
      # 設定可能な値: 英数字、ハイフン、アンダースコア（1-128文字）
      # 注意: 空白やAWS WAF予約名（All, Default_Action等）は使用不可
      metric_name = "rule-1-metric"

      # sampled_requests_enabled (Required)
      # 設定内容: サンプルリクエストの収集を有効にするかを指定します。
      # 設定可能な値: true, false
      sampled_requests_enabled = true
    }
  }

  #-------------------------------------------------------------
  # JSON形式ルール設定
  #-------------------------------------------------------------

  # rules_json (Optional)
  # 設定内容: JSON文字列形式でルールを定義します。
  # 用途: HCLブロック形式の3階層ネスト制限を超えるルール定義が必要な場合に使用します。
  # 注意:
  #   - ruleブロックと排他的（どちらか一方のみ指定可能）
  #   - ドリフト検出は行われません
  #   - 既存リソースのインポート時、初回のみインプレース更新が発生します
  # 参考: https://docs.aws.amazon.com/waf/latest/APIReference/API_CreateRuleGroup.html
  #
  # rules_json = jsonencode([{
  #   Name     = "rule-1"
  #   Priority = 1
  #   Action = {
  #     Count = {}
  #   }
  #   Statement = {
  #     ByteMatchStatement = {
  #       SearchString         = "badbot"
  #       PositionalConstraint = "CONTAINS"
  #       FieldToMatch = {
  #         UriPath = {}
  #       }
  #       TextTransformations = [{
  #         Priority = 1
  #         Type     = "NONE"
  #       }]
  #     }
  #   }
  #   VisibilityConfig = {
  #     CloudwatchMetricsEnabled = false
  #     MetricName               = "rule-1-metric"
  #     SampledRequestsEnabled   = false
  #   }
  # }])

  #-------------------------------------------------------------
  # カスタムレスポンスボディ設定
  #-------------------------------------------------------------
  # custom_response_body (Optional)
  # 設定内容: ルールのblockアクションで参照できるカスタムレスポンスボディを定義します。
  # 注意: custom_responseのcustom_response_body_keyで参照します。

  # custom_response_body {
  #   # key (Required)
  #   # 設定内容: カスタムレスポンスボディの一意キーを指定します。
  #   # 注意: ルールのcustom_response_body_keyから参照される値
  #   key = "custom_403"
  #
  #   # content_type (Required)
  #   # 設定内容: レスポンスボディのコンテンツタイプを指定します。
  #   # 設定可能な値:
  #   #   - "TEXT_PLAIN": プレーンテキスト
  #   #   - "TEXT_HTML": HTML
  #   #   - "APPLICATION_JSON": JSON
  #   content_type = "APPLICATION_JSON"
  #
  #   # content (Required)
  #   # 設定内容: レスポンスボディのペイロードを指定します。
  #   content = "{\"error\": \"Forbidden\"}"
  # }

  #-------------------------------------------------------------
  # Visibility Config設定（ルールグループ全体）
  #-------------------------------------------------------------
  # visibility_config (Required)
  # 設定内容: ルールグループ全体のCloudWatchメトリクスとサンプルリクエスト収集を定義します。

  visibility_config {
    # cloudwatch_metrics_enabled (Required)
    # 設定内容: CloudWatchメトリクスの送信を有効にするかを指定します。
    # 設定可能な値: true, false
    # 参考: https://docs.aws.amazon.com/waf/latest/developerguide/monitoring-cloudwatch.html#waf-metrics
    cloudwatch_metrics_enabled = true

    # metric_name (Required, Forces new resource)
    # 設定内容: CloudWatchメトリクスのフレンドリー名を指定します。
    # 設定可能な値: 英数字、ハイフン、アンダースコア（1-128文字）
    # 注意: 空白やAWS WAF予約名（All, Default_Action等）は使用不可
    metric_name = "example-rule-group-metric"

    # sampled_requests_enabled (Required)
    # 設定内容: サンプルリクエストの収集を有効にするかを指定します。
    # 設定可能な値: true, false
    sampled_requests_enabled = true
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
# - arn: WAFv2ルールグループのAmazon Resource Name (ARN)
#
# - id: WAFv2ルールグループのID
#
# - lock_token: ルールグループのロックトークン。
#               ルールグループの更新時に楽観的ロックとして使用されます。
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
