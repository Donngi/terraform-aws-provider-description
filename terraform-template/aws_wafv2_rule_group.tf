#---------------------------------------------------------------
# AWS WAFv2 Rule Group
#---------------------------------------------------------------
#
# AWS WAFv2のルールグループをプロビジョニングするリソースです。
# ルールグループは、Web ACLで再利用可能なルールのコレクションを定義します。
# 独自のルールをまとめて管理し、複数のWeb ACLに共有・適用できます。
#
# AWS公式ドキュメント:
#   - ルールグループの管理: https://docs.aws.amazon.com/waf/latest/developerguide/waf-rule-group-managing.html
#   - AWS WAF 開発者ガイド: https://docs.aws.amazon.com/waf/latest/developerguide/
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_rule_group
#
# Provider Version: 6.28.0
# Generated: 2026-02-19
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
  # 設定内容: ルールグループのフレンドリーな名前を指定します。
  # 設定可能な値: 文字列
  # 省略時: Terraformがランダムな一意の名前を生成します。
  # 注意: name_prefixと排他的（どちらか一方のみ指定可能）
  name = "example-rule-group"

  # name_prefix (Optional)
  # 設定内容: ルールグループ名のプレフィックスを指定します。
  # 設定可能な値: 文字列。Terraformが後ろにランダムなサフィックスを追加します。
  # 省略時: nameが使用されます。
  # 注意: nameと排他的（どちらか一方のみ指定可能）
  name_prefix = null

  # description (Optional)
  # 設定内容: ルールグループのフレンドリーな説明を指定します。
  # 設定可能な値: 文字列
  # 省略時: 説明なし
  description = "Example WAFv2 rule group"

  # capacity (Required)
  # 設定内容: ルールグループの処理能力単位（WCU: Web ACL Capacity Units）を指定します。
  # 設定可能な値: 正の整数
  # 注意: 設定したルールのWCU合計がここで指定した値を超えてはいけません。
  #       容量はルールグループ作成後に変更できません（再作成が必要）。
  capacity = 100

  #-------------------------------------------------------------
  # スコープ設定
  #-------------------------------------------------------------

  # scope (Required, Forces new resource)
  # 設定内容: このルールグループがCloudFront用かリージョナルアプリケーション用かを指定します。
  # 設定可能な値:
  #   - "CLOUDFRONT": Amazon CloudFrontディストリビューションで使用
  #   - "REGIONAL": リージョナルリソース（ALB、API Gateway等）で使用
  # 注意: CLOUDFRONTを指定する場合、リージョンをUS East (N. Virginia)に設定が必要です。
  scope = "REGIONAL"

  #-------------------------------------------------------------
  # カスタムレスポンスボディ設定
  #-------------------------------------------------------------

  # custom_response_body (Optional)
  # 設定内容: ルールでブロックアクション時に返すカスタムレスポンスボディを定義します。
  # 複数のカスタムレスポンスボディを定義し、ルールアクションで参照できます。
  custom_response_body {
    # key (Required)
    # 設定内容: カスタムレスポンスボディを識別するキーを指定します。
    # 設定可能な値: 文字列（英数字、ハイフン、アンダースコア）
    # 用途: ルールのblock.custom_response.custom_response_body_keyで参照する際に使用します。
    key = "custom_error_body"

    # content_type (Required)
    # 設定内容: レスポンスボディのコンテントタイプを指定します。
    # 設定可能な値:
    #   - "TEXT_PLAIN": テキスト形式
    #   - "TEXT_HTML": HTML形式
    #   - "APPLICATION_JSON": JSON形式
    content_type = "APPLICATION_JSON"

    # content (Required)
    # 設定内容: レスポンスボディの内容を指定します。
    # 設定可能な値: 文字列（content_typeに対応した形式）
    content = "{\"error\": \"Access denied by WAF rule group\"}"
  }

  #-------------------------------------------------------------
  # ルール設定
  #-------------------------------------------------------------

  # rule (Optional)
  # 設定内容: ルールグループに含めるルールを定義します。
  # 複数のruleブロックを指定できます。
  # 注意: rules_json（JSON文字列でルールを指定する代替手段）と排他的です。
  rule {
    # name (Required)
    # 設定内容: ルールの一意な名前を指定します。
    # 設定可能な値: 文字列（英数字、ハイフン）
    name = "block-bad-ips"

    # priority (Required)
    # 設定内容: ルールの評価優先度を指定します。
    # 設定可能な値: 0以上の整数（数値が小さいほど先に評価されます）
    # 注意: ルールグループ内で一意である必要があります。
    priority = 1

    #-----------------------------------------------------------
    # アクション設定
    #-----------------------------------------------------------

    # action (Required)
    # 設定内容: ルールにマッチしたリクエストに対するアクションを定義します。
    # allow / block / captcha / challenge / count のいずれか一つを指定します。
    action {
      # block (Optional)
      # 設定内容: マッチしたリクエストをブロックします。
      block {
        # custom_response (Optional)
        # 設定内容: ブロック時のカスタムレスポンスを定義します。
        # 省略時: デフォルトの403レスポンスが返されます。
        custom_response {
          # response_code (Required)
          # 設定内容: カスタムレスポンスのHTTPステータスコードを指定します。
          # 設定可能な値: 200〜600の整数
          response_code = 403

          # custom_response_body_key (Optional)
          # 設定内容: custom_response_bodyブロックで定義したカスタムボディのキーを参照します。
          # 設定可能な値: custom_response_bodyブロックのkeyと一致する文字列
          # 省略時: デフォルトのレスポンスボディが使用されます。
          custom_response_body_key = "custom_error_body"

          # response_header (Optional)
          # 設定内容: レスポンスに追加するカスタムヘッダーを定義します。
          response_header {
            # name (Required)
            # 設定内容: ヘッダー名を指定します。
            name = "x-blocked-by"

            # value (Required)
            # 設定内容: ヘッダー値を指定します。
            value = "waf-rule-group"
          }
        }
      }

      # allow (Optional)
      # 設定内容: マッチしたリクエストを許可します。
      # allow {
      #   custom_request_handling {
      #     insert_header {
      #       name  = "x-waf-allow"
      #       value = "true"
      #     }
      #   }
      # }

      # captcha (Optional)
      # 設定内容: マッチしたリクエストにCAPTCHAチャレンジを要求します。
      # captcha {
      #   custom_request_handling {
      #     insert_header {
      #       name  = "x-waf-captcha"
      #       value = "required"
      #     }
      #   }
      # }

      # challenge (Optional)
      # 設定内容: マッチしたリクエストにJavaScriptチャレンジを要求します。
      # challenge {
      #   custom_request_handling {
      #     insert_header {
      #       name  = "x-waf-challenge"
      #       value = "required"
      #     }
      #   }
      # }

      # count (Optional)
      # 設定内容: マッチしたリクエストをカウントし通過させます（テスト用途）。
      # count {
      #   custom_request_handling {
      #     insert_header {
      #       name  = "x-waf-count"
      #       value = "true"
      #     }
      #   }
      # }
    }

    #-----------------------------------------------------------
    # ステートメント設定
    #-----------------------------------------------------------

    # statement (Required)
    # 設定内容: ルールの評価条件（マッチング条件）を定義します。
    statement {
      # ip_set_reference_statement (Optional)
      # 設定内容: IPセットに含まれるIPアドレスからのリクエストにマッチします。
      ip_set_reference_statement {
        # arn (Required)
        # 設定内容: 参照するIPセットのARNを指定します。
        arn = aws_wafv2_ip_set.example.arn

        # ip_set_forwarded_ip_config (Optional)
        # 設定内容: 転送されたIPアドレスを使用してIPセットと照合する設定です。
        # 省略時: リクエストの送信元IPアドレスを使用します。
        # ip_set_forwarded_ip_config {
        #   # fallback_behavior (Required)
        #   # 設定可能な値: "MATCH" または "NO_MATCH"
        #   fallback_behavior = "NO_MATCH"
        #
        #   # header_name (Required)
        #   # 設定内容: 転送元IPを含むHTTPヘッダー名を指定します。
        #   header_name = "X-Forwarded-For"
        #
        #   # position (Required)
        #   # 設定可能な値: "FIRST", "LAST", "ANY"
        #   position = "FIRST"
        # }
      }
    }

    #-----------------------------------------------------------
    # ルールラベル設定
    #-----------------------------------------------------------

    # rule_label (Optional)
    # 設定内容: ルールがマッチしたときに追加するラベルを指定します。
    # 複数のrule_labelブロックを指定できます。
    # 省略時: ラベルなし
    rule_label {
      # name (Required)
      # 設定内容: ラベル名を指定します。
      # 設定可能な値: ラベル名前空間形式（例: "prefix:label"）
      name = "waf:blocked-ip"
    }

    #-----------------------------------------------------------
    # CAPTCHAコンフィグ設定
    #-----------------------------------------------------------

    # captcha_config (Optional)
    # 設定内容: CAPTCHAアクションの免除時間を上書きします。
    # 省略時: Web ACLレベルのCAPTCHA設定が使用されます。
    # captcha_config {
    #   immunity_time_property {
    #     # immunity_time (Optional)
    #     # 設定内容: CAPTCHA解決後の免除時間（秒）を指定します。
    #     # 設定可能な値: 60〜259200（1分〜3日）
    #     # 省略時: 300秒（5分）
    #     immunity_time = 300
    #   }
    # }

    #-----------------------------------------------------------
    # 可視性設定
    #-----------------------------------------------------------

    # visibility_config (Required)
    # 設定内容: このルールのCloudWatchメトリクスとサンプリングの設定を行います。
    visibility_config {
      # cloudwatch_metrics_enabled (Required)
      # 設定内容: CloudWatchメトリクスを有効にするかどうかを指定します。
      # 設定可能な値: true または false
      cloudwatch_metrics_enabled = true

      # metric_name (Required)
      # 設定内容: CloudWatchメトリクスの名前を指定します。
      # 設定可能な値: 英数字、ハイフン、アンダースコアを含む文字列（最大128文字）
      metric_name = "block-bad-ips-metric"

      # sampled_requests_enabled (Required)
      # 設定内容: サンプリングされたリクエストを有効にするかどうかを指定します。
      # 設定可能な値: true または false
      sampled_requests_enabled = true
    }
  }

  rule {
    name     = "block-sqli"
    priority = 2

    action {
      block {}
    }

    statement {
      # sqli_match_statement (Optional)
      # 設定内容: SQLインジェクション攻撃パターンにマッチするリクエストを検出します。
      sqli_match_statement {
        # sensitivity_level (Optional)
        # 設定内容: SQLインジェクション検出の感度レベルを指定します。
        # 設定可能な値:
        #   - "LOW": 誤検知を減らした低感度モード
        #   - "HIGH": より多くの攻撃を検出する高感度モード
        # 省略時: "LOW"
        sensitivity_level = "HIGH"

        # field_to_match (Optional)
        # 設定内容: 検査対象のリクエストフィールドを指定します。
        # 省略時: リクエスト全体を検査します。
        field_to_match {
          # body (Optional)
          # 設定内容: リクエストボディを検査対象にします。
          body {
            # oversize_handling (Optional)
            # 設定内容: ボディサイズが上限を超えた場合の処理を指定します。
            # 設定可能な値: "CONTINUE", "MATCH", "NO_MATCH"
            # 省略時: "CONTINUE"
            oversize_handling = "CONTINUE"
          }

          # 他のfield_to_match オプション（排他的、一つのみ指定可）:
          # all_query_arguments {} - 全クエリ引数
          # cookies {
          #   match_pattern { all {} }
          #   match_scope      = "ALL"
          #   oversize_handling = "CONTINUE"
          # }
          # header_order { oversize_handling = "CONTINUE" }
          # headers {
          #   match_pattern { all {} }
          #   match_scope      = "ALL"
          #   oversize_handling = "CONTINUE"
          # }
          # ja3_fingerprint { fallback_behavior = "NO_MATCH" }
          # ja4_fingerprint { fallback_behavior = "NO_MATCH" }
          # json_body {
          #   match_pattern { all {} }
          #   match_scope              = "ALL"
          #   invalid_fallback_behavior = "EVALUATE_AS_STRING"
          #   oversize_handling        = "CONTINUE"
          # }
          # method {}
          # query_string {}
          # single_header { name = "authorization" }
          # single_query_argument { name = "param" }
          # uri_fragment { fallback_behavior = "MATCH" }
          # uri_path {}
        }

        # text_transformation (Required)
        # 設定内容: マッチング前にフィールドに適用するテキスト変換を指定します。
        # 複数のtext_transformationブロックを指定できます。
        text_transformation {
          # priority (Required)
          # 設定内容: 変換の優先度（実行順序）を指定します。
          # 設定可能な値: 0以上の整数（小さいほど先に実行）
          priority = 1

          # type (Required)
          # 設定内容: 適用するテキスト変換の種類を指定します。
          # 設定可能な値: "NONE", "COMPRESS_WHITE_SPACE", "HTML_ENTITY_DECODE",
          #               "LOWERCASE", "CMD_LINE", "URL_DECODE", "BASE64_DECODE",
          #               "HEX_DECODE", "MD5", "REPLACE_COMMENTS", "ESCAPE_SEQ_DECODE",
          #               "SQL_HEX_DECODE", "CSS_DECODE", "JS_DECODE", "NORMALIZE_PATH",
          #               "NORMALIZE_PATH_WIN", "REMOVE_NULLS", "REPLACE_NULLS",
          #               "BASE64_DECODE_EXT", "URL_DECODE_UNI", "UTF8_TO_UNICODE" 等
          type = "URL_DECODE"
        }
        text_transformation {
          priority = 2
          type     = "HTML_ENTITY_DECODE"
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "block-sqli-metric"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "geo-block"
    priority = 3

    action {
      block {}
    }

    statement {
      # geo_match_statement (Optional)
      # 設定内容: 指定した国コードに対応する地理的位置からのリクエストにマッチします。
      geo_match_statement {
        # country_codes (Required)
        # 設定内容: ブロック対象の国コード一覧を指定します。
        # 設定可能な値: ISO 3166-1 alpha-2形式の国コードのリスト（例: "JP", "US", "CN"）
        country_codes = ["RU", "CN", "KP"]

        # forwarded_ip_config (Optional)
        # 設定内容: 転送されたIPに基づいた地理的マッチングの設定です。
        # 省略時: リクエストの送信元IPを使用します。
        # forwarded_ip_config {
        #   # fallback_behavior (Required)
        #   # 設定可能な値: "MATCH" または "NO_MATCH"
        #   fallback_behavior = "NO_MATCH"
        #
        #   # header_name (Required)
        #   header_name = "X-Forwarded-For"
        # }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "geo-block-metric"
      sampled_requests_enabled   = false
    }
  }

  rule {
    name     = "rate-limit"
    priority = 4

    action {
      block {}
    }

    statement {
      # rate_based_statement (Optional)
      # 設定内容: 一定時間内のリクエスト数が上限を超えた場合にマッチします。
      rate_based_statement {
        # limit (Required)
        # 設定内容: 評価ウィンドウ内で許可するリクエスト数の上限を指定します。
        # 設定可能な値: 100〜2000000000の整数
        limit = 2000

        # aggregate_key_type (Optional)
        # 設定内容: レート制限の集計キーの種類を指定します。
        # 設定可能な値:
        #   - "CONSTANT": 全リクエストをまとめて集計
        #   - "CUSTOM_KEYS": custom_keyブロックで指定した属性で集計
        #   - "FORWARDED_IP": X-Forwarded-Forヘッダーのクライアントを個別集計
        #   - "IP": 送信元IPアドレスで集計
        # 省略時: "IP"
        aggregate_key_type = "IP"

        # evaluation_window_sec (Optional)
        # 設定内容: レート評価のウィンドウ時間（秒）を指定します。
        # 設定可能な値: 60, 120, 300, 600
        # 省略時: 300
        evaluation_window_sec = 300

        # forwarded_ip_config (Optional)
        # 設定内容: aggregate_key_typeがFORWARDED_IPの場合に必須です。
        # 省略時: aggregate_key_typeがFORWARDED_IP以外の場合は設定不要。
        # forwarded_ip_config {
        #   fallback_behavior = "NO_MATCH"
        #   header_name       = "X-Forwarded-For"
        # }

        # scope_down_statement (Optional)
        # 設定内容: レート集計の対象を絞り込む条件を指定します。
        # 省略時: 全リクエストを集計対象にします。
        # scope_down_statement {
        #   geo_match_statement {
        #     country_codes = ["US"]
        #   }
        # }

        # custom_key (Optional)
        # 設定内容: aggregate_key_typeがCUSTOM_KEYSの場合にキーの組み合わせを指定します。
        # 複数のcustom_keyブロックを指定できます（最大5つ）。
        # 省略時: aggregate_key_typeがCUSTOM_KEYS以外の場合は設定不要。
        # custom_key {
        #   # 以下から一つのブロックを指定:
        #   # asn {}
        #   # cookie {
        #   #   name = "session"
        #   #   text_transformation { priority = 0; type = "NONE" }
        #   # }
        #   # forwarded_ip {}
        #   # header {
        #   #   name = "x-api-key"
        #   #   text_transformation { priority = 0; type = "NONE" }
        #   # }
        #   # http_method {}
        #   # ip {}
        #   # ja3_fingerprint { fallback_behavior = "NO_MATCH" }
        #   # ja4_fingerprint { fallback_behavior = "NO_MATCH" }
        #   # label_namespace { namespace = "custom:" }
        #   # query_argument {
        #   #   name = "user_id"
        #   #   text_transformation { priority = 0; type = "NONE" }
        #   # }
        #   # query_string {
        #   #   text_transformation { priority = 0; type = "NONE" }
        #   # }
        #   # uri_path {
        #   #   text_transformation { priority = 0; type = "NONE" }
        #   # }
        # }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "rate-limit-metric"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "byte-match-example"
    priority = 5

    action {
      count {}
    }

    statement {
      # byte_match_statement (Optional)
      # 設定内容: 指定したバイト文字列を含むリクエストにマッチします。
      byte_match_statement {
        # search_string (Required)
        # 設定内容: 検索対象のバイト文字列を指定します。
        # 設定可能な値: 文字列
        search_string = "badbot"

        # positional_constraint (Required)
        # 設定内容: フィールド内での文字列の位置条件を指定します。
        # 設定可能な値:
        #   - "EXACTLY": 完全一致
        #   - "STARTS_WITH": 指定文字列で始まる
        #   - "ENDS_WITH": 指定文字列で終わる
        #   - "CONTAINS": 指定文字列を含む
        #   - "CONTAINS_WORD": 指定文字列を単語として含む
        positional_constraint = "CONTAINS"

        field_to_match {
          # single_header (Optional)
          # 設定内容: 指定した名前の単一HTTPヘッダーを検査します。
          single_header {
            # name (Required)
            # 設定内容: 検査するHTTPヘッダーの名前を指定します（小文字で指定）。
            name = "user-agent"
          }
        }

        text_transformation {
          priority = 1
          type     = "LOWERCASE"
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "byte-match-metric"
      sampled_requests_enabled   = false
    }
  }

  rule {
    name     = "label-match-example"
    priority = 6

    action {
      block {}
    }

    statement {
      # label_match_statement (Optional)
      # 設定内容: 前のルールが付与したラベルにマッチするリクエストを検出します。
      label_match_statement {
        # scope (Required)
        # 設定内容: ラベルのスコープを指定します。
        # 設定可能な値:
        #   - "LABEL": 現在のWeb ACLのルールが付与したラベル
        #   - "NAMESPACE": ラベルの名前空間プレフィックスでマッチ
        scope = "LABEL"

        # key (Required)
        # 設定内容: マッチ対象のラベル名または名前空間を指定します。
        # 設定可能な値: ラベル名（例: "waf:blocked-ip"）または名前空間（例: "waf:"）
        key = "waf:blocked-ip"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "label-match-metric"
      sampled_requests_enabled   = false
    }
  }

  # rules_json (Optional)
  # 設定内容: JSON文字列形式でルールを指定する代替手段です。
  # 設定可能な値: JSON文字列
  # 省略時: ruleブロックが使用されます。
  # 注意: ruleブロックと排他的（どちらか一方のみ指定可能）
  rules_json = null

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
  # 可視性設定（ルールグループレベル）
  #-------------------------------------------------------------

  # visibility_config (Required)
  # 設定内容: ルールグループ全体のCloudWatchメトリクスとサンプリングの設定を行います。
  visibility_config {
    # cloudwatch_metrics_enabled (Required)
    # 設定内容: CloudWatchメトリクスを有効にするかどうかを指定します。
    # 設定可能な値: true または false
    cloudwatch_metrics_enabled = true

    # metric_name (Required)
    # 設定内容: CloudWatchメトリクスの名前を指定します。
    # 設定可能な値: 英数字、ハイフン、アンダースコアを含む文字列（最大128文字）
    metric_name = "example-rule-group-metric"

    # sampled_requests_enabled (Required)
    # 設定内容: サンプリングされたリクエストを有効にするかどうかを指定します。
    # 設定可能な値: true または false
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

  # tags_all (Optional)
  # 設定内容: プロバイダーのdefault_tagsを含む全タグのマップ。
  # 注意: この属性は通常、明示的に設定しません。
  #       プロバイダーのdefault_tagsとtagsの組み合わせから自動計算されます。
  # tags_all = {}
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: ルールグループの一意識別子
#
# - arn: ルールグループのAmazon Resource Name (ARN)
#        Web ACLでルールグループを参照する際に使用します。
#
# - lock_token: ルールグループを更新する際に使用するロックトークン。
#               楽観的ロックに使用され、同時更新の競合を防ぎます。
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
