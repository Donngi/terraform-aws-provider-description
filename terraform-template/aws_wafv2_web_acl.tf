#---------------------------------------------------------------
# AWS WAFv2 Web ACL
#---------------------------------------------------------------
#
# AWS WAFv2 (Web Application Firewall v2) のウェブACL (Access Control List) を
# プロビジョニングするリソースです。ウェブACLはウェブリクエストに対して
# 許可・ブロック・カウント・CAPTCHAチャレンジ等のアクション定義ルールを持ちます。
# CloudFrontディストリビューションまたはリージョナルリソース（API Gateway、
# ALB、App Runnerなど）に関連付けることができます。
#
# AWS公式ドキュメント:
#   - AWS WAFの概要: https://docs.aws.amazon.com/waf/latest/developerguide/what-is-aws-waf.html
#   - ウェブACLの操作: https://docs.aws.amazon.com/waf/latest/developerguide/web-acl.html
#   - マネージドルールグループ一覧: https://docs.aws.amazon.com/waf/latest/developerguide/aws-managed-rule-groups-list.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_web_acl
#
# Provider Version: 6.28.0
# Generated: 2026-02-19
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_wafv2_web_acl" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # scope (Required, Forces new resource)
  # 設定内容: ウェブACLの適用スコープを指定します。
  # 設定可能な値:
  #   - "REGIONAL": リージョナルアプリケーション（ALB、API Gateway、App Runner、
  #                 Cognito ユーザープール、Verified Accessなど）に適用
  #   - "CLOUDFRONT": Amazon CloudFrontディストリビューションに適用。
  #                   CloudFrontに使用する場合は、AWSプロバイダーのリージョンを
  #                   us-east-1（バージニア北部）に指定する必要があります。
  scope = "REGIONAL"

  # name (Optional, Forces new resource)
  # 設定内容: ウェブACLのフレンドリー名を指定します。
  # 設定可能な値: 文字列
  # 省略時: Terraformがランダムな一意の名前を生成します。
  # 注意: name_prefixと排他的（どちらか一方のみ指定可能）
  name = "example-web-acl"

  # name_prefix (Optional)
  # 設定内容: ウェブACL名のプレフィックスを指定します。Terraformが後ろにランダムなサフィックスを追加します。
  # 設定可能な値: 文字列
  # 注意: nameと排他的（どちらか一方のみ指定可能）
  # name_prefix = "example-"

  # description (Optional)
  # 設定内容: ウェブACLのフレンドリーな説明テキストを指定します。
  # 設定可能な値: 文字列
  description = "Example Web ACL"

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = null

  # rule_json (Optional)
  # 設定内容: ルールをJSON文字列として指定します。ruleブロックの代替手段として使用できます。
  # 設定可能な値: AWS WAFv2ルールのJSON文字列
  # 省略時: ruleブロックを使用してルールを定義
  # rule_json = null

  # token_domains (Optional)
  # 設定内容: AWS WAFがウェブリクエストトークンで受け入れるドメインのリストを指定します。
  #   複数の保護されたウェブサイトにまたがってトークンを使用する場合に設定します。
  #   この値を指定しない場合、AWS WAFは保護されたリソースのドメインのトークンのみ受け入れます。
  # 設定可能な値: ドメイン文字列のセット（例: ["mywebsite.com", "myotherwebsite.com"]）
  # token_domains = ["mywebsite.com", "myotherwebsite.com"]

  #-------------------------------------------------------------
  # デフォルトアクション設定
  #-------------------------------------------------------------

  # default_action (Required)
  # 設定内容: ウェブACLのルールがいずれもマッチしなかった場合に実行するアクションを指定します。
  #   allowブロックまたはblockブロックのいずれか1つのみ指定可能です。
  default_action {
    # allow (Optional)
    # 設定内容: デフォルトアクションとしてリクエストを許可します。
    #   カスタムリクエスト処理を追加する場合はcustom_request_handlingブロックを使用します。
    allow {
      # custom_request_handling (Optional)
      # 設定内容: ウェブリクエストに対してカスタムヘッダーを挿入するカスタム処理を定義します。
      # custom_request_handling {
      #   insert_header {
      #     # name (Required)
      #     # 設定内容: 挿入するカスタムHTTPヘッダー名。
      #     #   AWS WAFはヘッダー名の前に "x-amzn-waf-" を付加します。
      #     name = "custom-header"
      #     # value (Required)
      #     # 設定内容: 挿入するカスタムHTTPヘッダーの値。
      #     value = "custom-value"
      #   }
      # }
    }

    # block (Optional)
    # 設定内容: デフォルトアクションとしてリクエストをブロックします。
    #   allowブロックと排他的です。
    # block {
    #   custom_response {
    #     # response_code (Required)
    #     # 設定内容: クライアントに返すHTTPステータスコード。
    #     response_code = 403
    #     # custom_response_body_key (Optional)
    #     # 設定内容: custom_response_bodyブロックで定義したカスタムレスポンスボディを参照するキー。
    #     custom_response_body_key = "block_response"
    #     # response_header (Optional)
    #     # 設定内容: レスポンスに追加するHTTPレスポンスヘッダーを定義します。
    #     response_header {
    #       name  = "x-custom-header"
    #       value = "custom-value"
    #     }
    #   }
    # }
  }

  #-------------------------------------------------------------
  # ルール設定
  #-------------------------------------------------------------

  # rule (Optional)
  # 設定内容: ウェブACLのルールを定義します。ルールはウェブリクエストを識別し、
  #   allow・block・count・captcha・challengeのいずれかのアクションを適用します。
  #   複数のruleブロックを指定可能です。
  #
  # 注意: aws_wafv2_web_acl_rule_group_associationリソースと組み合わせる場合は、
  #   lifecycle { ignore_changes = [rule] } を追加して設定ドリフトを防ぐ必要があります。

  # --- マネージドルールグループを使用する例 ---
  rule {
    # name (Required)
    # 設定内容: ルールのフレンドリー名を指定します。
    # 注意: "^ShieldMitigationRuleGroup_<account-id>_<web-acl-guid>_.*" パターンに
    #   マッチする名前はAWSが自動DDoS軽減用に追加するルールと見なされ、
    #   Terraformによって無視されます。
    name = "AWSManagedRulesCommonRuleSet"

    # priority (Required)
    # 設定内容: ルールの評価優先度を数値で指定します。数値が小さいほど優先度が高く先に評価されます。
    # 設定可能な値: 整数（ウェブACL内で一意の値）
    priority = 1

    # override_action (Optional)
    # 設定内容: ルールグループ参照ステートメントまたはマネージドルールグループステートメントを
    #   使用するルールのアクションをオーバーライドします。
    #   actionブロックと排他的です（ルールグループ系はoverride_action、
    #   それ以外はactionを使用）。
    override_action {
      # count (Optional)
      # 設定内容: ルールグループ内のすべてのルールアクションをカウントにオーバーライドします。
      #   空ブロック {} として設定します。
      count {}

      # none (Optional)
      # 設定内容: ルールグループのアクションをそのまま使用します（オーバーライドしない）。
      #   空ブロック {} として設定します。countと排他的です。
      # none {}
    }

    statement {
      # managed_rule_group_statement (Optional)
      # 設定内容: AWSまたはサードパーティが管理するルールグループを実行するステートメントです。
      #   このステートメントはネストできません。
      managed_rule_group_statement {
        # name (Required)
        # 設定内容: マネージドルールグループの名前を指定します。
        # 参考: https://docs.aws.amazon.com/waf/latest/developerguide/aws-managed-rule-groups-list.html
        name = "AWSManagedRulesCommonRuleSet"

        # vendor_name (Required)
        # 設定内容: マネージドルールグループのベンダー名を指定します。
        # 設定可能な値: "AWS"（AWSマネージドルール）またはサードパーティベンダー名
        vendor_name = "AWS"

        # version (Optional)
        # 設定内容: マネージドルールグループのバージョンを指定します。
        # 設定可能な値: "Version_1.0", "Version_1.1" 等のバージョン文字列
        # 省略時: デフォルトバージョンを使用
        # version = "Version_1.0"

        # rule_action_override (Optional)
        # 設定内容: ルールグループ内の個別のルールアクションをオーバーライドします。
        #   最大100個まで指定可能です。
        rule_action_override {
          # name (Required)
          # 設定内容: オーバーライド対象のルール名を指定します。
          # 参考: https://docs.aws.amazon.com/waf/latest/developerguide/aws-managed-rule-groups-list.html
          name = "SizeRestrictions_QUERYSTRING"

          action_to_use {
            # count (Optional)
            # 設定内容: ルールのアクションをカウントに変更します。空ブロック {} として設定します。
            count {}
          }
        }

        # scope_down_statement (Optional)
        # 設定内容: マネージドルールグループが評価するウェブリクエストを絞り込むスコープダウンステートメント。
        #   ネスト可能なステートメントを任意のレベルで指定できます。
        scope_down_statement {
          geo_match_statement {
            # country_codes (Required)
            # 設定内容: 一致する国のISO 3166 alpha-2 2文字国コードの配列を指定します。
            country_codes = ["US", "JP"]
          }
        }

        # managed_rule_group_configs (Optional)
        # 設定内容: Bot Control、ACFP、ATPなどの特定マネージドルールグループの追加設定を指定します。
        # managed_rule_group_configs {
        #   aws_managed_rules_bot_control_rule_set {
        #     # inspection_level (Required)
        #     # 設定内容: Bot Controlルールグループの検査レベルを指定します。
        #     # 設定可能な値: "COMMON", "TARGETED"
        #     inspection_level = "COMMON"
        #     # enable_machine_learning (Optional)
        #     # 設定内容: TARGETEDレベルのみ有効。機械学習でボット関連トラフィックを分析するかを指定します。
        #     # 省略時: true
        #     enable_machine_learning = true
        #   }
        # }
      }
    }

    # captcha_config (Optional)
    # 設定内容: ルールレベルのCAPTCHA評価の処理方法を指定します。
    # captcha_config {
    #   immunity_time_property {
    #     # immunity_time (Optional)
    #     # 設定内容: CAPTCHAまたはチャレンジのタイムスタンプが有効とみなされる秒数。
    #     # 省略時: 300秒
    #     immunity_time = 300
    #   }
    # }

    # challenge_config (Optional)
    # 設定内容: ルールレベルのチャレンジ評価の処理方法を指定します。
    # challenge_config {
    #   immunity_time_property {
    #     immunity_time = 300
    #   }
    # }

    # rule_label (Optional)
    # 設定内容: ルールにマッチしたウェブリクエストに適用するラベルを指定します。
    #   複数のrule_labelブロックを指定可能です。
    # rule_label {
    #   # name (Required)
    #   # 設定内容: ラベル文字列を指定します。
    #   name = "awswaf:managed:aws:core-rule-set:NoUserAgent_HEADER"
    # }

    visibility_config {
      # cloudwatch_metrics_enabled (Required)
      # 設定内容: CloudWatchメトリクスへの送信を有効にするかを指定します。
      # 設定可能な値: true / false
      cloudwatch_metrics_enabled = true

      # metric_name (Required)
      # 設定内容: CloudWatchメトリクス名を指定します。
      # 設定可能な値: 英数字・ハイフン・アンダースコアのみ、1〜128文字。
      #   "All" や "Default_Action" など AWS WAF 予約語は使用不可。
      metric_name = "AWSManagedRulesCommonRuleSet"

      # sampled_requests_enabled (Required)
      # 設定内容: ルールにマッチしたウェブリクエストのサンプリングを有効にするかを指定します。
      # 設定可能な値: true / false
      sampled_requests_enabled = true
    }
  }

  # --- IPセット参照ステートメントを使用する例 ---
  # rule {
  #   name     = "BlockBadIPs"
  #   priority = 2
  #   action {
  #     block {}
  #   }
  #   statement {
  #     ip_set_reference_statement {
  #       # arn (Required)
  #       # 設定内容: 参照するIPセット（aws_wafv2_ip_set）のARNを指定します。
  #       arn = aws_wafv2_ip_set.example.arn
  #       # ip_set_forwarded_ip_config (Optional)
  #       # 設定内容: ウェブリクエストの送信元IPの代わりにHTTPヘッダーのIPアドレスを検査する設定。
  #       # ip_set_forwarded_ip_config {
  #       #   fallback_behavior = "NO_MATCH"
  #       #   header_name       = "X-Forwarded-For"
  #       #   position          = "FIRST"
  #       # }
  #     }
  #   }
  #   visibility_config {
  #     cloudwatch_metrics_enabled = true
  #     metric_name                = "BlockBadIPs"
  #     sampled_requests_enabled   = true
  #   }
  # }

  # --- レートベースルールを使用する例 ---
  # rule {
  #   name     = "RateLimitRule"
  #   priority = 3
  #   action {
  #     block {}
  #   }
  #   statement {
  #     rate_based_statement {
  #       # limit (Required)
  #       # 設定内容: 評価ウィンドウ内の単一集約インスタンスへのリクエスト上限数。
  #       limit = 2000
  #       # aggregate_key_type (Optional)
  #       # 設定内容: リクエスト数の集約方法を指定します。
  #       # 設定可能な値: "IP" (デフォルト), "FORWARDED_IP", "CUSTOM_KEYS", "CONSTANT"
  #       aggregate_key_type = "IP"
  #       # evaluation_window_sec (Optional)
  #       # 設定内容: リクエスト数のカウント対象となる時間ウィンドウ（秒）。
  #       # 設定可能な値: 60, 120, 300 (デフォルト), 600
  #       evaluation_window_sec = 300
  #       # forwarded_ip_config (Optional)
  #       # 設定内容: aggregate_key_typeが"FORWARDED_IP"の場合に必須。
  #       #   HTTPヘッダーからIPアドレスを取得する設定。
  #       # forwarded_ip_config {
  #       #   fallback_behavior = "NO_MATCH"
  #       #   header_name       = "X-Forwarded-For"
  #       # }
  #       # custom_key (Optional)
  #       # 設定内容: aggregate_key_typeが"CUSTOM_KEYS"の場合に使用する集約キーの構成要素。
  #       #   使用可能なキー種別: asn, cookie, forwarded_ip, header, http_method,
  #       #   ip, ja3_fingerprint, ja4_fingerprint, label_namespace, query_argument,
  #       #   query_string, uri_path
  #       # custom_key {
  #       #   header {
  #       #     name = "x-api-key"
  #       #     text_transformation {
  #       #       priority = 0
  #       #       type     = "NONE"
  #       #     }
  #       #   }
  #       # }
  #       # scope_down_statement (Optional)
  #       # 設定内容: レートベースルールの対象を絞り込むネストステートメント。
  #       #   aggregate_key_typeが"CONSTANT"の場合は必須。
  #       # scope_down_statement {
  #       #   geo_match_statement {
  #       #     country_codes = ["CN"]
  #       #   }
  #       # }
  #     }
  #   }
  #   visibility_config {
  #     cloudwatch_metrics_enabled = true
  #     metric_name                = "RateLimitRule"
  #     sampled_requests_enabled   = true
  #   }
  # }

  # --- バイトマッチステートメントを使用する例 ---
  # rule {
  #   name     = "BlockBadUserAgent"
  #   priority = 4
  #   action {
  #     block {}
  #   }
  #   statement {
  #     byte_match_statement {
  #       # search_string (Required)
  #       # 設定内容: AWS WAFが検索する文字列（最大50バイト）。
  #       search_string = "BadBot"
  #       # positional_constraint (Required)
  #       # 設定内容: search_stringの一致位置を指定します。
  #       # 設定可能な値: "EXACTLY", "STARTS_WITH", "ENDS_WITH", "CONTAINS", "CONTAINS_WORD"
  #       positional_constraint = "CONTAINS"
  #       field_to_match {
  #         single_header {
  #           # name (Required)
  #           # 設定内容: 検査するHTTPヘッダー名（小文字で指定）。
  #           name = "user-agent"
  #         }
  #       }
  #       text_transformation {
  #         priority = 0
  #         # type (Required)
  #         # 設定内容: 適用するテキスト変換の種類。
  #         # 参考: https://docs.aws.amazon.com/waf/latest/APIReference/API_TextTransformation.html
  #         type = "NONE"
  #       }
  #     }
  #   }
  #   visibility_config {
  #     cloudwatch_metrics_enabled = true
  #     metric_name                = "BlockBadUserAgent"
  #     sampled_requests_enabled   = true
  #   }
  # }

  # --- SQLインジェクション検出ステートメントを使用する例 ---
  # rule {
  #   name     = "SQLiRule"
  #   priority = 5
  #   action {
  #     block {}
  #   }
  #   statement {
  #     sqli_match_statement {
  #       # sensitivity_level (Optional)
  #       # 設定内容: SQLインジェクション攻撃の検知感度を指定します。
  #       # 設定可能な値: "LOW", "HIGH"
  #       sensitivity_level = "HIGH"
  #       field_to_match {
  #         body {
  #           oversize_handling = "MATCH"
  #         }
  #       }
  #       text_transformation {
  #         priority = 0
  #         type     = "URL_DECODE"
  #       }
  #     }
  #   }
  #   visibility_config {
  #     cloudwatch_metrics_enabled = true
  #     metric_name                = "SQLiRule"
  #     sampled_requests_enabled   = true
  #   }
  # }

  # --- XSS検出ステートメントを使用する例 ---
  # rule {
  #   name     = "XSSRule"
  #   priority = 6
  #   action {
  #     block {}
  #   }
  #   statement {
  #     xss_match_statement {
  #       field_to_match {
  #         body {
  #           oversize_handling = "MATCH"
  #         }
  #       }
  #       text_transformation {
  #         priority = 0
  #         type     = "URL_DECODE"
  #       }
  #     }
  #   }
  #   visibility_config {
  #     cloudwatch_metrics_enabled = true
  #     metric_name                = "XSSRule"
  #     sampled_requests_enabled   = true
  #   }
  # }

  # --- 正規表現マッチステートメントを使用する例 ---
  # rule {
  #   name     = "RegexMatchRule"
  #   priority = 7
  #   action {
  #     block {}
  #   }
  #   statement {
  #     regex_match_statement {
  #       # regex_string (Required)
  #       # 設定内容: 一致する正規表現パターン文字列（1〜512文字）。
  #       regex_string = "^/api/v[0-9]+/admin"
  #       field_to_match {
  #         uri_path {}
  #       }
  #       text_transformation {
  #         priority = 0
  #         type     = "LOWERCASE"
  #       }
  #     }
  #   }
  #   visibility_config {
  #     cloudwatch_metrics_enabled = true
  #     metric_name                = "RegexMatchRule"
  #     sampled_requests_enabled   = true
  #   }
  # }

  # --- 正規表現パターンセット参照ステートメントを使用する例 ---
  # rule {
  #   name     = "RegexPatternSetRule"
  #   priority = 8
  #   action {
  #     block {}
  #   }
  #   statement {
  #     regex_pattern_set_reference_statement {
  #       # arn (Required)
  #       # 設定内容: 参照する正規表現パターンセット（aws_wafv2_regex_pattern_set）のARN。
  #       arn = aws_wafv2_regex_pattern_set.example.arn
  #       field_to_match {
  #         uri_path {}
  #       }
  #       text_transformation {
  #         priority = 0
  #         type     = "NONE"
  #       }
  #     }
  #   }
  #   visibility_config {
  #     cloudwatch_metrics_enabled = true
  #     metric_name                = "RegexPatternSetRule"
  #     sampled_requests_enabled   = true
  #   }
  # }

  # --- サイズ制約ステートメントを使用する例 ---
  # rule {
  #   name     = "SizeConstraintRule"
  #   priority = 9
  #   action {
  #     block {}
  #   }
  #   statement {
  #     size_constraint_statement {
  #       # comparison_operator (Required)
  #       # 設定内容: リクエスト部分のサイズと比較する演算子を指定します。
  #       # 設定可能な値: "EQ", "NE", "LE", "LT", "GE", "GT"
  #       comparison_operator = "GT"
  #       # size (Required)
  #       # 設定内容: 比較するバイト数（0〜21474836480の整数）。
  #       size = 8192
  #       field_to_match {
  #         body {
  #           oversize_handling = "MATCH"
  #         }
  #       }
  #       text_transformation {
  #         priority = 0
  #         type     = "NONE"
  #       }
  #     }
  #   }
  #   visibility_config {
  #     cloudwatch_metrics_enabled = true
  #     metric_name                = "SizeConstraintRule"
  #     sampled_requests_enabled   = true
  #   }
  # }

  # --- ジオマッチステートメントを使用する例 ---
  # rule {
  #   name     = "GeoMatchRule"
  #   priority = 10
  #   action {
  #     block {}
  #   }
  #   statement {
  #     geo_match_statement {
  #       # country_codes (Required)
  #       # 設定内容: ブロックする国のISO 3166 alpha-2 2文字国コードの配列。
  #       # 参考: https://docs.aws.amazon.com/waf/latest/APIReference/API_GeoMatchStatement.html
  #       country_codes = ["CN", "RU", "KP"]
  #       # forwarded_ip_config (Optional)
  #       # 設定内容: ウェブリクエスト送信元IPの代わりにHTTPヘッダーのIPアドレスを使用する設定。
  #       # forwarded_ip_config {
  #       #   fallback_behavior = "NO_MATCH"
  #       #   header_name       = "X-Forwarded-For"
  #       # }
  #     }
  #   }
  #   visibility_config {
  #     cloudwatch_metrics_enabled = true
  #     metric_name                = "GeoMatchRule"
  #     sampled_requests_enabled   = true
  #   }
  # }

  # --- ASNマッチステートメントを使用する例 ---
  # rule {
  #   name     = "ASNMatchRule"
  #   priority = 11
  #   action {
  #     block {}
  #   }
  #   statement {
  #     asn_match_statement {
  #       # asn_list (Required)
  #       # 設定内容: マッチするASN（自律システム番号）の数値リスト。
  #       asn_list = [12345, 67890]
  #       # forwarded_ip_config (Optional)
  #       # 設定内容: ウェブリクエスト送信元IPの代わりにHTTPヘッダーのIPアドレスを使用する設定。
  #       # forwarded_ip_config {
  #       #   fallback_behavior = "NO_MATCH"
  #       #   header_name       = "X-Forwarded-For"
  #       # }
  #     }
  #   }
  #   visibility_config {
  #     cloudwatch_metrics_enabled = true
  #     metric_name                = "ASNMatchRule"
  #     sampled_requests_enabled   = true
  #   }
  # }

  # --- ラベルマッチステートメントを使用する例 ---
  # rule {
  #   name     = "LabelMatchRule"
  #   priority = 12
  #   action {
  #     block {}
  #   }
  #   statement {
  #     label_match_statement {
  #       # scope (Required)
  #       # 設定内容: ラベル名またはネームスペースのいずれかでマッチするかを指定します。
  #       # 設定可能な値: "LABEL", "NAMESPACE"
  #       scope = "LABEL"
  #       # key (Required)
  #       # 設定内容: マッチする対象の文字列（ラベル名またはネームスペース）。
  #       key = "awswaf:managed:aws:core-rule-set:SizeRestrictions_QUERYSTRING"
  #     }
  #   }
  #   visibility_config {
  #     cloudwatch_metrics_enabled = true
  #     metric_name                = "LabelMatchRule"
  #     sampled_requests_enabled   = true
  #   }
  # }

  # --- ルールグループ参照ステートメントを使用する例 ---
  # rule {
  #   name     = "RuleGroupRefRule"
  #   priority = 13
  #   override_action {
  #     none {}
  #   }
  #   statement {
  #     rule_group_reference_statement {
  #       # arn (Required)
  #       # 設定内容: 参照するルールグループ（aws_wafv2_rule_group）のARN。
  #       arn = aws_wafv2_rule_group.example.arn
  #       # rule_action_override (Optional)
  #       # 設定内容: ルールグループ内の個別ルールのアクションをオーバーライドします（最大100個）。
  #       # rule_action_override {
  #       #   name = "rule-to-override"
  #       #   action_to_use {
  #       #     count {}
  #       #   }
  #       # }
  #     }
  #   }
  #   visibility_config {
  #     cloudwatch_metrics_enabled = true
  #     metric_name                = "RuleGroupRefRule"
  #     sampled_requests_enabled   = true
  #   }
  # }

  # --- AND/OR/NOT論理ステートメントを使用する例 ---
  # rule {
  #   name     = "AndStatementRule"
  #   priority = 14
  #   action {
  #     block {}
  #   }
  #   statement {
  #     and_statement {
  #       statement {
  #         geo_match_statement {
  #           country_codes = ["CN"]
  #         }
  #       }
  #       statement {
  #         byte_match_statement {
  #           search_string         = "/admin"
  #           positional_constraint = "STARTS_WITH"
  #           field_to_match {
  #             uri_path {}
  #           }
  #           text_transformation {
  #             priority = 0
  #             type     = "LOWERCASE"
  #           }
  #         }
  #       }
  #     }
  #   }
  #   visibility_config {
  #     cloudwatch_metrics_enabled = true
  #     metric_name                = "AndStatementRule"
  #     sampled_requests_enabled   = true
  #   }
  # }

  # --- CAPTCHAアクションを持つルールの例 ---
  # rule {
  #   name     = "CaptchaRule"
  #   priority = 15
  #   action {
  #     captcha {
  #       # custom_request_handling (Optional)
  #       # 設定内容: ウェブリクエストのカスタム処理を定義します。
  #     }
  #   }
  #   statement {
  #     geo_match_statement {
  #       country_codes = ["US"]
  #     }
  #   }
  #   visibility_config {
  #     cloudwatch_metrics_enabled = true
  #     metric_name                = "CaptchaRule"
  #     sampled_requests_enabled   = true
  #   }
  # }

  #-------------------------------------------------------------
  # カスタムレスポンスボディ設定
  #-------------------------------------------------------------

  # custom_response_body (Optional)
  # 設定内容: custom_responseアクションから参照できるカスタムレスポンスボディを定義します。
  #   複数のcustom_response_bodyブロックを指定可能です。
  # custom_response_body {
  #   # key (Required)
  #   # 設定内容: カスタムレスポンスボディを識別する一意のキー。
  #   #   custom_responseブロックのcustom_response_body_keyから参照されます。
  #   key = "block_response"
  #   # content (Required)
  #   # 設定内容: レスポンスボディのペイロードを指定します。
  #   content = "{\"message\": \"Access denied\"}"
  #   # content_type (Required)
  #   # 設定内容: contentで指定したペイロードのコンテンツタイプを指定します。
  #   # 設定可能な値: "TEXT_PLAIN", "TEXT_HTML", "APPLICATION_JSON"
  #   content_type = "APPLICATION_JSON"
  # }

  #-------------------------------------------------------------
  # CAPTCHAおよびチャレンジ設定
  #-------------------------------------------------------------

  # captcha_config (Optional)
  # 設定内容: ACLレベルのCAPTCHA評価の処理方法を指定します。
  #   AWS Bot Controlマネージドルールグループで使用されます。
  # captcha_config {
  #   immunity_time_property {
  #     # immunity_time (Optional)
  #     # 設定内容: CAPTCHAタイムスタンプが有効とみなされる秒数。
  #     # 省略時: 300秒
  #     immunity_time = 300
  #   }
  # }

  # challenge_config (Optional)
  # 設定内容: ACLレベルのチャレンジ評価の処理方法を指定します。
  #   AWS Bot Controlマネージドルールグループで使用されます。
  # challenge_config {
  #   immunity_time_property {
  #     # immunity_time (Optional)
  #     # 設定内容: チャレンジタイムスタンプが有効とみなされる秒数。
  #     # 省略時: 300秒
  #     immunity_time = 300
  #   }
  # }

  #-------------------------------------------------------------
  # リクエストボディサイズ設定
  #-------------------------------------------------------------

  # association_config (Optional)
  # 設定内容: ウェブACLと保護対象リソースの関連付けに関するカスタム設定を指定します。
  #   保護対象リソース種別ごとにAWS WAFに転送するリクエストボディの最大サイズを設定できます。
  # association_config {
  #   request_body {
  #     # api_gateway (Optional)
  #     # 設定内容: API GatewayのREST APIに対するリクエストボディのカスタム検査サイズ。
  #     api_gateway {
  #       # default_size_inspection_limit (Required)
  #       # 設定内容: AWS WAFに転送するリクエストボディの最大サイズ。
  #       # 設定可能な値: "KB_16", "KB_32", "KB_48", "KB_64"
  #       default_size_inspection_limit = "KB_64"
  #     }
  #     # app_runner_service (Optional)
  #     # 設定内容: App Runnerサービスに対するリクエストボディのカスタム検査サイズ。
  #     app_runner_service {
  #       default_size_inspection_limit = "KB_64"
  #     }
  #     # cloudfront (Optional)
  #     # 設定内容: CloudFrontディストリビューションに対するリクエストボディのカスタム検査サイズ。
  #     #   scopeがREGIONALの場合のみ適用可能。
  #     cloudfront {
  #       default_size_inspection_limit = "KB_64"
  #     }
  #     # cognito_user_pool (Optional)
  #     # 設定内容: Cognitoユーザープールに対するリクエストボディのカスタム検査サイズ。
  #     cognito_user_pool {
  #       default_size_inspection_limit = "KB_64"
  #     }
  #     # verified_access_instance (Optional)
  #     # 設定内容: Verified Accessインスタンスに対するリクエストボディのカスタム検査サイズ。
  #     verified_access_instance {
  #       default_size_inspection_limit = "KB_64"
  #     }
  #   }
  # }

  #-------------------------------------------------------------
  # データ保護設定
  #-------------------------------------------------------------

  # data_protection_config (Optional)
  # 設定内容: ウェブACLレベルのウェブリクエストデータに対するデータ保護設定を指定します。
  #   特定フィールドタイプのデータを置換またはハッシュ化して保護します。
  # data_protection_config {
  #   # data_protection (Required)
  #   # 設定内容: 特定フィールドタイプへのデータ保護設定（最大26個）。
  #   data_protection {
  #     # action (Required)
  #     # 設定内容: フィールドをどのように保護するかを指定します。
  #     # 設定可能な値: "SUBSTITUTION", "HASH"
  #     action = "SUBSTITUTION"
  #     # exclude_rate_based_details (Optional)
  #     # 設定内容: レートベースルールの詳細情報もデータ保護対象から除外するかを指定します。
  #     exclude_rate_based_details = false
  #     # exclude_rule_match_details (Optional)
  #     # 設定内容: ルールマッチ詳細情報もデータ保護対象から除外するかを指定します。
  #     exclude_rule_match_details = false
  #     field {
  #       # field_type (Required)
  #       # 設定内容: 保護するウェブリクエストコンポーネントの種別を指定します。
  #       # 設定可能な値: "SINGLE_HEADER", "SINGLE_COOKIE", "SINGLE_QUERY_ARGUMENT",
  #       #               "QUERY_STRING", "BODY"
  #       field_type = "SINGLE_HEADER"
  #       # field_keys (Optional)
  #       # 設定内容: 指定したfiled_type内で保護対象とするキーの配列。
  #       #   省略時はfield_typeの全キーが保護対象になります。
  #       field_keys = ["authorization"]
  #     }
  #   }
  # }

  #-------------------------------------------------------------
  # 可視性設定
  #-------------------------------------------------------------

  visibility_config {
    # cloudwatch_metrics_enabled (Required)
    # 設定内容: ウェブACL全体のCloudWatchメトリクスへの送信を有効にするかを指定します。
    # 参考: https://docs.aws.amazon.com/waf/latest/developerguide/monitoring-cloudwatch.html#waf-metrics
    cloudwatch_metrics_enabled = true

    # metric_name (Required)
    # 設定内容: ウェブACL全体のCloudWatchメトリクス名を指定します。
    # 設定可能な値: 英数字・ハイフン・アンダースコアのみ、1〜128文字。
    #   "All" や "Default_Action" など AWS WAF 予約語は使用不可。
    metric_name = "ExampleWebACL"

    # sampled_requests_enabled (Required)
    # 設定内容: ルールにマッチしたウェブリクエストのサンプリングを有効にするかを指定します。
    #   サンプリングされたリクエストはAWS WAFコンソールから確認できます。
    sampled_requests_enabled = true
  }

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 注意: プロバイダーレベルのdefault_tags設定と一致するキーのタグはプロバイダー設定を上書きします。
  tags = {
    Name        = "example-web-acl"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: ウェブACLのID。
# - arn: ウェブACLのAmazon Resource Name (ARN)。
# - application_integration_url: マネージドルールグループとのSDK統合に使用するURL。
# - capacity: このウェブACLで現在使用されているウェブACLキャパシティユニット (WCU)。
# - lock_token: リソースの楽観的ロック用トークン。他のクライアントによる変更を防ぐ。
# - tags_all: プロバイダーのdefault_tags設定から継承したタグを含む全タグのマップ。
#---------------------------------------------------------------
