#---------------------------------------------------------------
# AWS WAFv2 Web ACL ルール（個別管理）
#---------------------------------------------------------------
#
# AWS WAFv2 Web ACL内の個別ルールを独立したリソースとして管理します。
# aws_wafv2_web_aclリソースのインラインruleブロックの代替手段として使用でき、
# IPセットなど参照先リソースの安全な削除（WAFAssociatedItemException回避）や、
# ルール単位のライフサイクル管理を実現します。
#
# 注意: このリソースを使用する場合、対応するaws_wafv2_web_aclリソースに
#       lifecycle { ignore_changes = [rule] } を追加してください。
#
# AWS公式ドキュメント:
#   - AWS WAFルールの概要: https://docs.aws.amazon.com/waf/latest/developerguide/waf-rules.html
#   - ルールステートメント: https://docs.aws.amazon.com/waf/latest/developerguide/waf-rule-statements.html
#   - マネージドルールグループ一覧: https://docs.aws.amazon.com/waf/latest/developerguide/aws-managed-rule-groups-list.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_web_acl_rule
#
# Provider Version: 6.38.0
# Generated: 2026-03-26
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_wafv2_web_acl_rule" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: ルール名を指定します。Web ACL内で一意である必要があります。
  # 設定可能な値: 文字列
  name = "block-countries"

  # priority (Required)
  # 設定内容: ルールの評価優先度を指定します。数値が小さいほど先に評価されます。
  # 設定可能な値: 整数（Web ACL内で一意の値）
  priority = 1

  # web_acl_arn (Required)
  # 設定内容: ルールを追加する対象のWeb ACLのARNを指定します。
  # 設定可能な値: Web ACLのARN文字列
  web_acl_arn = aws_wafv2_web_acl.example.arn

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = null

  #-------------------------------------------------------------
  # アクション設定
  #-------------------------------------------------------------

  # action (Optional)
  # 設定内容: ルールにマッチした場合に実行するアクションを定義します。
  #   allow / block / count / captcha / challenge のいずれか1つを指定します。
  #   override_actionと排他的です（マネージドルールグループ/ルールグループ参照時は
  #   override_actionを使用）。
  action {
    # block (Optional)
    # 設定内容: リクエストをブロックします。
    block {
      # custom_response (Optional)
      # 設定内容: カスタムレスポンスを返す場合に設定します。
      # custom_response {
      #   # response_code (Required)
      #   # 設定内容: クライアントに返すHTTPステータスコード（200〜599）。
      #   response_code = 403
      #   # custom_response_body_key (Optional)
      #   # 設定内容: Web ACLで定義したカスタムレスポンスボディを参照するキー。
      #   # custom_response_body_key = "block_response"
      #   # response_header (Optional)
      #   # 設定内容: レスポンスに追加するHTTPヘッダーを定義します。
      #   # response_header {
      #   #   # name (Required)
      #   #   # 設定内容: ヘッダー名。
      #   #   name = "x-custom-header"
      #   #   # value (Required)
      #   #   # 設定内容: ヘッダー値。
      #   #   value = "blocked"
      #   # }
      # }
    }

    # allow (Optional)
    # 設定内容: リクエストを許可します。blockと排他的です。
    # allow {
    #   # custom_request_handling (Optional)
    #   # 設定内容: リクエストにカスタムヘッダーを挿入する処理を定義します。
    #   # custom_request_handling {
    #   #   # insert_header (Required)
    #   #   # 設定内容: 挿入するカスタムHTTPヘッダー。"x-amzn-waf-" プレフィックスが自動付与されます。
    #   #   insert_header {
    #   #     name  = "custom-header"
    #   #     value = "custom-value"
    #   #   }
    #   # }
    # }

    # count (Optional)
    # 設定内容: リクエストをカウントのみ行い、ブロックしません。
    # count {
    #   # custom_request_handling (Optional)
    #   # 設定内容: allowと同様のカスタムリクエスト処理を定義できます。
    #   # custom_request_handling { ... }
    # }

    # captcha (Optional)
    # 設定内容: クライアントにCAPTCHAチャレンジを提示します。
    # captcha {
    #   # custom_request_handling (Optional)
    #   # 設定内容: allowと同様のカスタムリクエスト処理を定義できます。
    #   # custom_request_handling { ... }
    # }

    # challenge (Optional)
    # 設定内容: クライアントにサイレントチャレンジを提示します。
    # challenge {
    #   # custom_request_handling (Optional)
    #   # 設定内容: allowと同様のカスタムリクエスト処理を定義できます。
    #   # custom_request_handling { ... }
    # }
  }

  # override_action (Optional)
  # 設定内容: マネージドルールグループまたはルールグループ参照ステートメントを使用する
  #   ルールのアクションをオーバーライドします。actionと排他的です。
  # override_action {
  #   # count (Optional)
  #   # 設定内容: ルールグループ内の全ルールアクションをカウントにオーバーライドします。
  #   # count {}
  #   # none (Optional)
  #   # 設定内容: ルールグループのアクションをそのまま使用します（オーバーライドしない）。
  #   # none {}
  # }

  #-------------------------------------------------------------
  # ステートメント設定
  #-------------------------------------------------------------

  # statement (Required)
  # 設定内容: ウェブリクエストを評価するためのルールステートメントを定義します。
  #   以下のステートメントタイプから1つを指定します。
  #   論理ステートメント（and/or/not）は最大3レベルまでネスト可能です。
  statement {
    # --- 地理的マッチステートメント ---
    geo_match_statement {
      # country_codes (Required)
      # 設定内容: マッチ対象の2文字国コード（ISO 3166-1 alpha-2）のリスト。
      # 設定可能な値: ["JP", "US", "CN", "RU"] など
      country_codes = ["CN", "RU"]

      # forwarded_ip_config (Optional)
      # 設定内容: オリジンIPの代わりにHTTPヘッダー内のIPアドレスを検査する設定です。
      # forwarded_ip_config {
      #   # fallback_behavior (Required)
      #   # 設定内容: ヘッダー内のIPアドレスが無効な場合の動作。
      #   # 設定可能な値: "MATCH", "NO_MATCH"
      #   fallback_behavior = "MATCH"
      #   # header_name (Required)
      #   # 設定内容: 転送されたIPアドレスを含むヘッダー名。
      #   header_name = "X-Forwarded-For"
      # }
    }

    # --- IPセット参照ステートメント ---
    # ip_set_reference_statement {
    #   # arn (Required)
    #   # 設定内容: 参照するIPセットのARN。
    #   arn = aws_wafv2_ip_set.example.arn
    #   # ip_set_forwarded_ip_config (Optional)
    #   # 設定内容: 転送されたIPヘッダーの検査設定。
    #   # ip_set_forwarded_ip_config {
    #   #   # fallback_behavior (Required)
    #   #   # 設定内容: ヘッダー内のIPアドレスが無効な場合の動作。
    #   #   # 設定可能な値: "MATCH", "NO_MATCH"
    #   #   fallback_behavior = "MATCH"
    #   #   # header_name (Required)
    #   #   # 設定内容: 転送されたIPアドレスを含むヘッダー名。
    #   #   header_name = "X-Forwarded-For"
    #   #   # position (Required)
    #   #   # 設定内容: ヘッダー内で使用するIPの位置。
    #   #   # 設定可能な値: "FIRST", "LAST", "ANY"
    #   #   position = "FIRST"
    #   # }
    # }

    # --- ASNマッチステートメント ---
    # asn_match_statement {
    #   # asn_list (Required)
    #   # 設定内容: マッチ対象のASN（自律システム番号）のリスト（0〜4294967295）。
    #   asn_list = [64496, 64497]
    #   # forwarded_ip_config (Optional)
    #   # 設定内容: geo_match_statementのforwarded_ip_configと同様。
    #   # forwarded_ip_config { ... }
    # }

    # --- バイトマッチステートメント ---
    # byte_match_statement {
    #   # search_string (Required)
    #   # 設定内容: リクエスト内で検索する文字列値（1〜200文字）。
    #   search_string = "admin"
    #   # positional_constraint (Required)
    #   # 設定内容: 検索する位置の制約。
    #   # 設定可能な値: "EXACTLY", "STARTS_WITH", "ENDS_WITH", "CONTAINS", "CONTAINS_WORD"
    #   positional_constraint = "CONTAINS"
    #   # field_to_match (Required)
    #   # 設定内容: 検査するウェブリクエストの部分。詳細は「field_to_match設定」を参照。
    #   field_to_match {
    #     uri_path {}
    #   }
    #   # text_transformation (Required)
    #   # 設定内容: 検査前にリクエストに適用するテキスト変換。詳細は「text_transformation設定」を参照。
    #   text_transformation {
    #     priority = 0
    #     type     = "LOWERCASE"
    #   }
    # }

    # --- サイズ制約ステートメント ---
    # size_constraint_statement {
    #   # comparison_operator (Required)
    #   # 設定内容: 比較演算子。
    #   # 設定可能な値: "EQ", "NE", "LE", "LT", "GE", "GT"
    #   comparison_operator = "GT"
    #   # size (Required)
    #   # 設定内容: 比較対象のサイズ（バイト単位）。
    #   size = 8192
    #   # field_to_match (Required)
    #   # 設定内容: 検査するウェブリクエストの部分。
    #   field_to_match {
    #     body {
    #       oversize_handling = "MATCH"
    #     }
    #   }
    #   # text_transformation (Required)
    #   # 設定内容: 検査前にリクエストに適用するテキスト変換。
    #   text_transformation {
    #     priority = 0
    #     type     = "NONE"
    #   }
    # }

    # --- SQLインジェクションマッチステートメント ---
    # sqli_match_statement {
    #   # sensitivity_level (Optional)
    #   # 設定内容: SQLインジェクション攻撃の検知感度。
    #   # 設定可能な値: "LOW", "HIGH"
    #   # 省略時: "LOW"
    #   # sensitivity_level = "HIGH"
    #   field_to_match {
    #     body {
    #       oversize_handling = "MATCH"
    #     }
    #   }
    #   text_transformation {
    #     priority = 0
    #     type     = "URL_DECODE"
    #   }
    # }

    # --- XSSマッチステートメント ---
    # xss_match_statement {
    #   field_to_match {
    #     body {
    #       oversize_handling = "MATCH"
    #     }
    #   }
    #   text_transformation {
    #     priority = 0
    #     type     = "URL_DECODE"
    #   }
    # }

    # --- 正規表現マッチステートメント ---
    # regex_match_statement {
    #   # regex_string (Required)
    #   # 設定内容: マッチする正規表現パターン文字列。
    #   regex_string = "^/api/v[0-9]+/admin"
    #   field_to_match {
    #     uri_path {}
    #   }
    #   text_transformation {
    #     priority = 0
    #     type     = "LOWERCASE"
    #   }
    # }

    # --- 正規表現パターンセット参照ステートメント ---
    # regex_pattern_set_reference_statement {
    #   # arn (Required)
    #   # 設定内容: 参照する正規表現パターンセットのARN。
    #   arn = aws_wafv2_regex_pattern_set.example.arn
    #   field_to_match {
    #     uri_path {}
    #   }
    #   text_transformation {
    #     priority = 0
    #     type     = "LOWERCASE"
    #   }
    # }

    # --- ラベルマッチステートメント ---
    # label_match_statement {
    #   # key (Required)
    #   # 設定内容: マッチ対象のラベル文字列（1〜1024文字）。
    #   #   コロン区切りの名前空間形式（例: "awswaf:managed:aws:bot-control:bot:verified"）。
    #   key = "awswaf:managed:aws:bot-control:bot:verified"
    #   # scope (Required)
    #   # 設定内容: ラベル名全体と一致させるか、名前空間のみと一致させるかを指定。
    #   # 設定可能な値: "LABEL", "NAMESPACE"
    #   scope = "LABEL"
    # }

    # --- レートベースステートメント ---
    # rate_based_statement {
    #   # limit (Required)
    #   # 設定内容: 評価ウィンドウ期間あたりのリクエスト数の閾値（10〜2,000,000,000）。
    #   limit = 2000
    #   # aggregate_key_type (Required)
    #   # 設定内容: リクエスト数の集約方法。
    #   # 設定可能な値: "IP", "FORWARDED_IP", "CUSTOM_KEYS", "CONSTANT"
    #   aggregate_key_type = "IP"
    #   # evaluation_window_sec (Optional)
    #   # 設定内容: レート制限の評価ウィンドウ（秒）。
    #   # 設定可能な値: 60, 120, 300, 600
    #   # 省略時: 300（5分）
    #   # evaluation_window_sec = 300
    #   # forwarded_ip_config (Optional)
    #   # 設定内容: aggregate_key_typeが"FORWARDED_IP"の場合に使用。
    #   # forwarded_ip_config { ... }
    #   # custom_keys (Optional)
    #   # 設定内容: aggregate_key_typeが"CUSTOM_KEYS"の場合に使用。
    #   #   1つ以上のウェブリクエストコンポーネントを集約キーとして指定します。
    #   # custom_keys {
    #   #   # 以下から1つ以上を指定:
    #   #   # ip {}
    #   #   # forwarded_ip {}
    #   #   # http_method {}
    #   #   # header {
    #   #   #   name = "user-agent"
    #   #   #   text_transformation { priority = 0; type = "LOWERCASE" }
    #   #   # }
    #   #   # cookie {
    #   #   #   name = "session-id"
    #   #   #   text_transformation { priority = 0; type = "NONE" }
    #   #   # }
    #   #   # query_argument {
    #   #   #   name = "api_key"
    #   #   #   text_transformation { priority = 0; type = "NONE" }
    #   #   # }
    #   #   # query_string {
    #   #   #   text_transformation { priority = 0; type = "NONE" }
    #   #   # }
    #   #   # uri_path {
    #   #   #   text_transformation { priority = 0; type = "NONE" }
    #   #   # }
    #   #   # label_namespace {
    #   #   #   namespace = "awswaf:managed:aws:bot-control:bot:"
    #   #   # }
    #   #   # asn {}
    #   #   # ja3_fingerprint { fallback_behavior = "MATCH" }
    #   #   # ja4_fingerprint { fallback_behavior = "MATCH" }
    #   # }
    #   # scope_down_statement (Optional)
    #   # 設定内容: レートベースルールが評価するリクエストの範囲を絞り込む追加ステートメント。
    #   #   上記の各ステートメントタイプを使用可能（論理ステートメントを除く）。
    #   # scope_down_statement { ... }
    # }

    # --- マネージドルールグループステートメント ---
    # managed_rule_group_statement {
    #   # name (Required)
    #   # 設定内容: マネージドルールグループ名。
    #   # 参考: https://docs.aws.amazon.com/waf/latest/developerguide/aws-managed-rule-groups-list.html
    #   name = "AWSManagedRulesCommonRuleSet"
    #   # vendor_name (Required)
    #   # 設定内容: マネージドルールグループのベンダー名。
    #   # 設定可能な値: "AWS"（AWSマネージドルール）またはサードパーティベンダー名
    #   vendor_name = "AWS"
    #   # version (Optional)
    #   # 設定内容: マネージドルールグループのバージョン。
    #   # 省略時: デフォルトバージョンを使用
    #   # version = "Version_1.0"
    #   # rule_action_override (Optional)
    #   # 設定内容: ルールグループ内の個別ルールのアクションをオーバーライドします。
    #   # rule_action_override {
    #   #   # name (Required)
    #   #   # 設定内容: オーバーライド対象のルール名。
    #   #   name = "SizeRestrictions_QUERYSTRING"
    #   #   # action_to_use (Required)
    #   #   # 設定内容: オーバーライドするアクション（action設定と同じ構造）。
    #   #   action_to_use {
    #   #     count {}
    #   #   }
    #   # }
    #   # managed_rule_group_configs (Optional)
    #   # 設定内容: マネージドルールグループ固有の追加設定。
    #   #   ATP、ACFP、Bot Control、Anti-DDoS等の高度なルールグループで使用します。
    #   # managed_rule_group_configs {
    #   #   # --- AWSManagedRulesATPRuleSet用 ---
    #   #   # aws_managed_rules_atp_rule_set {
    #   #   #   login_path = "/login"
    #   #   #   enable_regex_in_path = false
    #   #   #   request_inspection {
    #   #   #     payload_type = "JSON"
    #   #   #     username_field { identifier = "/username" }
    #   #   #     password_field { identifier = "/password" }
    #   #   #   }
    #   #   # }
    #   #   # --- AWSManagedRulesACFPRuleSet用 ---
    #   #   # aws_managed_rules_acfp_rule_set {
    #   #   #   creation_path = "/signup"
    #   #   #   registration_page_path = "/register"
    #   #   #   request_inspection {
    #   #   #     payload_type = "JSON"
    #   #   #     username_field { identifier = "/username" }
    #   #   #     password_field { identifier = "/password" }
    #   #   #     email_field { identifier = "/email" }
    #   #   #   }
    #   #   # }
    #   #   # --- AWSManagedRulesBotControlRuleSet用 ---
    #   #   # aws_managed_rules_bot_control_rule_set {
    #   #   #   inspection_level = "COMMON"
    #   #   #   enable_machine_learning = true
    #   #   # }
    #   #   # --- AWSManagedRulesAntiDDoSRuleSet用 ---
    #   #   # aws_managed_rules_anti_ddos_rule_set {
    #   #   #   sensitivity_to_block = "LOW"
    #   #   #   client_side_action_config {
    #   #   #     challenge {
    #   #   #       usage_of_action = "ENABLED"
    #   #   #       sensitivity = "LOW"
    #   #   #     }
    #   #   #   }
    #   #   # }
    #   # }
    #   # scope_down_statement (Optional)
    #   # 設定内容: マネージドルールグループが評価するリクエストの範囲を絞り込みます。
    #   # scope_down_statement { ... }
    # }

    # --- ルールグループ参照ステートメント ---
    # rule_group_reference_statement {
    #   # arn (Required)
    #   # 設定内容: 参照するカスタムルールグループのARN。
    #   arn = aws_wafv2_rule_group.example.arn
    #   # excluded_rule (Optional)
    #   # 設定内容: ルールグループから除外するルール。
    #   # excluded_rule {
    #   #   # name (Required)
    #   #   # 設定内容: 除外するルール名（1〜128文字）。
    #   #   name = "SizeRestrictions_QUERYSTRING"
    #   # }
    #   # rule_action_override (Optional)
    #   # 設定内容: managed_rule_group_statementのrule_action_overrideと同様。
    #   # rule_action_override { ... }
    # }

    # --- 論理ANDステートメント ---
    # and_statement {
    #   # statement (Required)
    #   # 設定内容: 組み合わせるステートメントのリスト（2つ以上指定）。
    #   #   各ネストされたステートメントは上記と同じステートメントタイプを使用可能。
    #   #   最大3レベルまでネスト可能。
    #   statement {
    #     geo_match_statement {
    #       country_codes = ["CN"]
    #     }
    #   }
    #   statement {
    #     byte_match_statement {
    #       search_string         = "admin"
    #       positional_constraint = "CONTAINS"
    #       field_to_match {
    #         uri_path {}
    #       }
    #       text_transformation {
    #         priority = 0
    #         type     = "LOWERCASE"
    #       }
    #     }
    #   }
    # }

    # --- 論理ORステートメント ---
    # or_statement {
    #   # statement (Required)
    #   # 設定内容: 組み合わせるステートメントのリスト（2つ以上指定）。
    #   statement { ... }
    #   statement { ... }
    # }

    # --- 論理NOTステートメント ---
    # not_statement {
    #   # statement (Required)
    #   # 設定内容: 否定する単一のステートメント。
    #   statement {
    #     geo_match_statement {
    #       country_codes = ["JP"]
    #     }
    #   }
    # }
  }

  #-------------------------------------------------------------
  # ルールラベル設定
  #-------------------------------------------------------------

  # rule_label (Optional)
  # 設定内容: マッチしたウェブリクエストに適用するラベルを指定します。
  #   他のルールのlabel_match_statementで参照可能です。
  # rule_label {
  #   # name (Required)
  #   # 設定内容: ラベル文字列（1〜1024文字）。
  #   #   英数字、アンダースコア、ハイフン、コロンのみ使用可能。
  #   name = "my-app:blocked-country"
  # }

  #-------------------------------------------------------------
  # CAPTCHA / Challenge設定
  #-------------------------------------------------------------

  # captcha_config (Optional)
  # 設定内容: Web ACLレベルのCAPTCHA設定をオーバーライドします。
  # captcha_config {
  #   immunity_time_property {
  #     # immunity_time (Optional)
  #     # 設定内容: CAPTCHAチャレンジ成功後の免疫時間（秒）。
  #     # 設定可能な値: 60〜259200（3日間）
  #     immunity_time = 300
  #   }
  # }

  # challenge_config (Optional)
  # 設定内容: Web ACLレベルのChallenge設定をオーバーライドします。
  # challenge_config {
  #   immunity_time_property {
  #     # immunity_time (Optional)
  #     # 設定内容: チャレンジ成功後の免疫時間（秒）。
  #     # 設定可能な値: 60〜259200（3日間）
  #     immunity_time = 300
  #   }
  # }

  #-------------------------------------------------------------
  # 可視性設定
  #-------------------------------------------------------------

  # visibility_config (Required)
  # 設定内容: CloudWatchメトリクスおよびサンプルリクエストの設定を定義します。
  visibility_config {
    # cloudwatch_metrics_enabled (Required)
    # 設定内容: CloudWatchメトリクスの収集を有効にするかを指定します。
    cloudwatch_metrics_enabled = true

    # metric_name (Required)
    # 設定内容: CloudWatchメトリクス名を指定します。
    # 設定可能な値: 英数字・ハイフン・アンダースコアのみ、1〜128文字
    metric_name = "block-countries"

    # sampled_requests_enabled (Required)
    # 設定内容: マッチしたウェブリクエストのサンプリングを有効にするかを指定します。
    sampled_requests_enabled = true
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト時間を設定します。
  # timeouts {
  #   # create (Optional)
  #   # 設定内容: 作成操作のタイムアウト。
  #   # 省略時: プロバイダーのデフォルト値
  #   create = "30m"
  #   # update (Optional)
  #   # 設定内容: 更新操作のタイムアウト。
  #   update = "30m"
  #   # delete (Optional)
  #   # 設定内容: 削除操作のタイムアウト。
  #   delete = "30m"
  # }
}

#---------------------------------------------------------------
# field_to_match設定（参考）
#---------------------------------------------------------------
# byte_match_statement, size_constraint_statement, sqli_match_statement,
# xss_match_statement, regex_match_statement, regex_pattern_set_reference_statement
# で使用する検査対象の設定です。以下のいずれか1つを指定します。
#
# - all_query_arguments {}: 全クエリ引数を検査
# - body { oversize_handling = "CONTINUE" }: リクエストボディを検査
#     oversize_handling: "CONTINUE", "MATCH", "NO_MATCH"（省略時: "CONTINUE"）
# - cookies { match_pattern { all {} }; match_scope = "ALL"; oversize_handling = "CONTINUE" }
#     match_pattern: all {} / included_cookies / excluded_cookies
#     match_scope: "ALL", "KEY", "VALUE"
# - header_order { oversize_handling = "CONTINUE" }: ヘッダー順序を検査
# - headers { match_pattern { all {} }; match_scope = "ALL"; oversize_handling = "CONTINUE" }
#     match_pattern: all {} / included_headers / excluded_headers
# - ja3_fingerprint { fallback_behavior = "MATCH" }: JA3フィンガープリントを検査
# - ja4_fingerprint { fallback_behavior = "MATCH" }: JA4フィンガープリントを検査
# - json_body { match_pattern { all {} }; match_scope = "ALL" }
#     invalid_fallback_behavior: "EVALUATE_AS_STRING", "MATCH", "NO_MATCH"
#     match_pattern: all {} / included_paths
# - method {}: HTTPメソッドを検査
# - query_string {}: クエリ文字列を検査
# - single_header { name = "user-agent" }: 特定ヘッダーを検査
# - single_query_argument { name = "api_key" }: 特定クエリ引数を検査
# - uri_fragment { fallback_behavior = "MATCH" }: URIフラグメントを検査
# - uri_path {}: URIパスを検査
#---------------------------------------------------------------

#---------------------------------------------------------------
# text_transformation設定（参考）
#---------------------------------------------------------------
# 検査前にリクエストコンポーネントに適用するテキスト変換です。
# 複数指定可能で、priorityの昇順に適用されます。
#
# - priority (Required): 変換の適用順序（0始まり）
# - type (Required): 変換タイプ
#     "NONE", "COMPRESS_WHITE_SPACE", "HTML_ENTITY_DECODE", "LOWERCASE",
#     "CMD_LINE", "URL_DECODE", "BASE64_DECODE", "HEX_DECODE", "MD5",
#     "REPLACE_COMMENTS", "ESCAPE_SEQ_DECODE", "SQL_HEX_DECODE",
#     "CSS_DECODE", "JS_DECODE", "NORMALIZE_PATH", "NORMALIZE_PATH_WIN",
#     "REMOVE_NULLS", "REPLACE_NULLS", "BASE64_DECODE_EXT",
#     "URL_DECODE_UNI", "UTF8_TO_UNICODE"
#---------------------------------------------------------------

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは引数に加え、以下の属性をエクスポートします:
#
# - id: ルールのID（name,web_acl_arnの組み合わせ）。
# - region: リソースが管理されているリージョン。
#---------------------------------------------------------------
