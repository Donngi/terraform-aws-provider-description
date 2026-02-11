#---------------------------------------------------------------
# AWS WAFv2 Web ACL
#---------------------------------------------------------------
#
# AWS WAF Web ACL（Web Access Control List）をプロビジョニングするリソースです。
# Web ACLは、CloudFront、API Gateway、ALB、AppSync、Cognito User Pool等の
# AWSリソースに対するWebリクエストを検査し、許可・ブロック・カウントする
# ルールのコレクションを定義します。
#
# AWS公式ドキュメント:
#   - AWS WAF概要: https://docs.aws.amazon.com/waf/latest/developerguide/what-is-aws-waf.html
#   - Web ACL: https://docs.aws.amazon.com/waf/latest/developerguide/web-acl.html
#   - マネージドルールグループ: https://docs.aws.amazon.com/waf/latest/developerguide/aws-managed-rule-groups.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_web_acl
#
# Provider Version: 6.28.0
# Generated: 2026-02-06
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_wafv2_web_acl" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Optional, Forces new resource)
  # 設定内容: Web ACLの名前を指定します。
  # 設定可能な値: 1-128文字の文字列（英数字、ハイフン、アンダースコア）
  # 省略時: Terraformがランダムな一意の名前を生成します。
  # 注意: name_prefixと排他的（どちらか一方のみ指定可能）
  name = "example-web-acl"

  # name_prefix (Optional, Forces new resource)
  # 設定内容: Web ACL名のプレフィックスを指定します。
  # 設定可能な値: 文字列。Terraformが後ろにランダムなサフィックスを追加します。
  # 注意: nameと排他的（どちらか一方のみ指定可能）
  # name_prefix = "example-"

  # description (Optional)
  # 設定内容: Web ACLのわかりやすい説明を指定します。
  # 設定可能な値: 任意の文字列
  description = "Example Web ACL for demonstration"

  # scope (Required, Forces new resource)
  # 設定内容: このWeb ACLの適用範囲を指定します。
  # 設定可能な値:
  #   - "REGIONAL": API Gateway REST API、ALB、AppSync GraphQL API、
  #                 Cognito User Pool、App Runner、Verified Access等のリージョナルリソース用
  #   - "CLOUDFRONT": Amazon CloudFrontディストリビューション用
  # 注意: CLOUDFRONTを使用する場合、AWSプロバイダーのリージョンをus-east-1に設定する必要があります
  scope = "REGIONAL"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "ap-northeast-1"

  #-------------------------------------------------------------
  # デフォルトアクション設定 (Required)
  #-------------------------------------------------------------
  # 設定内容: Web ACL内のルールにマッチしないリクエストに対するデフォルトアクション
  # 注意: allowまたはblockのいずれか一方を指定

  default_action {
    # allow (Optional)
    # 設定内容: デフォルトでリクエストを許可します。
    allow {
      # custom_request_handling (Optional)
      # 設定内容: 許可するリクエストにカスタムヘッダーを追加できます。
      # custom_request_handling {
      #   insert_header {
      #     name  = "x-custom-header"
      #     value = "allowed-by-default"
      #   }
      # }
    }

    # block (Optional)
    # 設定内容: デフォルトでリクエストをブロックします。
    # block {
    #   custom_response {
    #     response_code            = 403
    #     custom_response_body_key = "blocked-response"
    #     response_header {
    #       name  = "x-custom-header"
    #       value = "blocked-by-default"
    #     }
    #   }
    # }
  }

  #-------------------------------------------------------------
  # 可視性設定 (Required)
  #-------------------------------------------------------------

  visibility_config {
    # cloudwatch_metrics_enabled (Required)
    # 設定内容: CloudWatchメトリクスを有効にするかを指定します。
    # 設定可能な値:
    #   - true: メトリクスを送信
    #   - false: メトリクスを送信しない
    # 関連機能: AWS WAF メトリクス
    #   リクエストのブロック数、許可数等をモニタリング可能
    #   - https://docs.aws.amazon.com/waf/latest/developerguide/monitoring-cloudwatch.html
    cloudwatch_metrics_enabled = true

    # metric_name (Required)
    # 設定内容: CloudWatchメトリクスの名前を指定します。
    # 設定可能な値: 1-128文字の英数字、ハイフン、アンダースコア
    # 注意: 空白やAWS予約名（All, Default_Action）は使用不可
    metric_name = "exampleWebAclMetric"

    # sampled_requests_enabled (Required)
    # 設定内容: サンプリングされたWebリクエストを収集するかを指定します。
    # 設定可能な値:
    #   - true: サンプルリクエストを収集（AWS WAFコンソールで確認可能）
    #   - false: 収集しない
    sampled_requests_enabled = true
  }

  #-------------------------------------------------------------
  # ルール設定 (Optional)
  #-------------------------------------------------------------
  # 設定内容: Web ACLに含めるルールを定義します。
  # 各ルールにはstatement（条件）とaction（アクション）を指定します。
  # ルールは優先度順（priority値が小さい順）に評価されます。

  #-------------------------------------------------------------
  # ルール例1: AWSマネージドルールグループ（Common Rule Set）
  #-------------------------------------------------------------
  rule {
    # name (Required)
    # 設定内容: ルールの名前を指定します。
    # 注意: ^ShieldMitigationRuleGroup_<account-id>_<web-acl-guid>_.*パターンの名前は
    #       AWSが自動DDoS軽減用に追加するルールとして扱われます
    name = "AWSManagedRulesCommonRuleSet"

    # priority (Required)
    # 設定内容: ルールの優先度を指定します。
    # 設定可能な値: 0以上の整数（小さい値ほど先に評価）
    # 注意: 同一Web ACL内で一意である必要があります
    priority = 1

    # override_action (Optional)
    # 設定内容: ルールグループ参照時のアクションオーバーライドを指定します。
    # 注意: managed_rule_group_statementやrule_group_reference_statement使用時に指定
    #       通常のstatement（byte_match等）ではactionを使用
    override_action {
      # count (Optional)
      # 設定内容: ルールグループのアクションをカウントに上書きします。
      # count {}

      # none (Optional)
      # 設定内容: ルールグループのアクションを上書きしません（そのまま適用）。
      none {}
    }

    statement {
      # managed_rule_group_statement (Optional)
      # 設定内容: AWSまたはMarketplaceベンダーが提供するマネージドルールグループを使用します。
      # 関連機能: AWS Managed Rules
      #   - https://docs.aws.amazon.com/waf/latest/developerguide/aws-managed-rule-groups.html
      managed_rule_group_statement {
        # name (Required)
        # 設定内容: マネージドルールグループの名前を指定します。
        # 設定可能な値: AWSManagedRulesCommonRuleSet, AWSManagedRulesKnownBadInputsRuleSet,
        #              AWSManagedRulesSQLiRuleSet, AWSManagedRulesATPRuleSet等
        name = "AWSManagedRulesCommonRuleSet"

        # vendor_name (Required)
        # 設定内容: ルールグループのベンダー名を指定します。
        # 設定可能な値: "AWS" または Marketplace ベンダー名
        vendor_name = "AWS"

        # version (Optional)
        # 設定内容: マネージドルールグループのバージョンを指定します。
        # 省略時: デフォルトバージョンを使用
        # version = "Version_1.0"

        # rule_action_override (Optional)
        # 設定内容: ルールグループ内の特定ルールのアクションを上書きします。
        rule_action_override {
          # name (Required)
          # 設定内容: 上書き対象のルール名を指定します。
          # 参考: https://docs.aws.amazon.com/waf/latest/developerguide/aws-managed-rule-groups-list.html
          name = "SizeRestrictions_QUERYSTRING"

          # action_to_use (Required)
          # 設定内容: 適用するアクションを指定します。
          # allow {}, block {}, count {}, captcha {}, challenge {} のいずれかを指定
          action_to_use {
            count {}
          }
        }

        # scope_down_statement (Optional)
        # 設定内容: ルールグループを適用するリクエストを絞り込みます。
        # ネスト可能な任意のstatementを使用可能
        # scope_down_statement {
        #   geo_match_statement {
        #     country_codes = ["US", "JP"]
        #   }
        # }

        # managed_rule_group_configs (Optional)
        # 設定内容: マネージドルールグループ固有の設定を指定します。
        # Bot Control、ATP、ACFP、Anti-DDoS等のルールグループで使用
        # managed_rule_group_configs {
        #
        #   # aws_managed_rules_bot_control_rule_set (Optional)
        #   # 設定内容: Bot Controlマネージドルールグループの設定
        #   aws_managed_rules_bot_control_rule_set {
        #     # inspection_level (Optional)
        #     # 設定内容: Bot Control の検査レベル
        #     # 設定可能な値: "COMMON", "TARGETED"
        #     inspection_level = "COMMON"
        #
        #     # enable_machine_learning (Optional)
        #     # 設定内容: 機械学習を使用してボット関連アクティビティを分析するか
        #     # 省略時: true
        #     # 注意: TARGETEDレベルでのみ適用
        #     enable_machine_learning = true
        #   }
        #
        #   # aws_managed_rules_atp_rule_set (Optional)
        #   # 設定内容: Account Takeover Protection (ATP) ルールグループの設定
        #   # aws_managed_rules_atp_rule_set {
        #   #   login_path = "/api/login"
        #   #
        #   #   # enable_regex_in_path (Optional)
        #   #   # 設定内容: ログインパスに正規表現を使用するか
        #   #   # enable_regex_in_path = false
        #   #
        #   #   request_inspection {
        #   #     payload_type = "JSON"
        #   #     username_field {
        #   #       identifier = "/email"
        #   #     }
        #   #     password_field {
        #   #       identifier = "/password"
        #   #     }
        #   #   }
        #   #
        #   #   response_inspection {
        #   #     status_code {
        #   #       success_codes = [200]
        #   #       failure_codes = [401, 403]
        #   #     }
        #   #   }
        #   # }
        #
        #   # aws_managed_rules_acfp_rule_set (Optional)
        #   # 設定内容: Account Creation Fraud Prevention (ACFP) ルールグループの設定
        #   # aws_managed_rules_acfp_rule_set {
        #   #   creation_path          = "/signup"
        #   #   registration_page_path = "/register"
        #   #
        #   #   # enable_regex_in_path (Optional)
        #   #   # 設定内容: パスに正規表現を使用するか
        #   #   # enable_regex_in_path = false
        #   #
        #   #   request_inspection {
        #   #     payload_type = "JSON"
        #   #     email_field {
        #   #       identifier = "/email"
        #   #     }
        #   #     username_field {
        #   #       identifier = "/username"
        #   #     }
        #   #     password_field {
        #   #       identifier = "/password"
        #   #     }
        #   #     # address_fields (Optional)
        #   #     # address_fields {
        #   #     #   identifiers = ["/address/line1", "/address/city"]
        #   #     # }
        #   #     # phone_number_fields (Optional)
        #   #     # phone_number_fields {
        #   #     #   identifiers = ["/phone"]
        #   #     # }
        #   #   }
        #   #
        #   #   response_inspection {
        #   #     status_code {
        #   #       success_codes = [200, 201]
        #   #       failure_codes = [400, 403]
        #   #     }
        #   #   }
        #   # }
        #
        #   # aws_managed_rules_anti_ddos_rule_set (Optional)
        #   # 設定内容: Anti-DDoSマネージドルールグループの設定
        #   # aws_managed_rules_anti_ddos_rule_set {
        #   #   # sensitivity_to_block (Optional)
        #   #   # 設定内容: DDoS疑いラベリングに対する感度
        #   #   # 設定可能な値: "LOW" (デフォルト), "MEDIUM", "HIGH"
        #   #   sensitivity_to_block = "LOW"
        #   #
        #   #   client_side_action_config {
        #   #     challenge {
        #   #       usage_of_action = "ENABLED"
        #   #       sensitivity     = "HIGH"
        #   #       # exempt_uri_regular_expression (Optional)
        #   #       # exempt_uri_regular_expression {
        #   #       #   regex_string = "/api/health"
        #   #       # }
        #   #     }
        #   #   }
        #   # }
        # }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWSManagedRulesCommonRuleSetMetric"
      sampled_requests_enabled   = true
    }

    # captcha_config (Optional)
    # 設定内容: ルールレベルのCAPTCHA設定を指定します。
    # captcha_config {
    #   immunity_time_property {
    #     immunity_time = 300
    #   }
    # }

    # challenge_config (Optional)
    # 設定内容: ルールレベルのチャレンジ設定を指定します。
    # challenge_config {
    #   immunity_time_property {
    #     immunity_time = 300
    #   }
    # }

    # rule_label (Optional)
    # 設定内容: マッチしたリクエストにラベルを付与します。
    # rule_label {
    #   name = "custom-label"
    # }
  }

  #-------------------------------------------------------------
  # ルール例2: レートベースルール
  #-------------------------------------------------------------
  rule {
    name     = "RateLimitRule"
    priority = 2

    # action (Optional)
    # 設定内容: ルールがマッチした場合のアクションを指定します。
    # 注意: 通常のstatement使用時に指定（ルールグループ参照時はoverride_actionを使用）
    action {
      # block (Optional)
      # 設定内容: リクエストをブロックします。
      block {
        # custom_response (Optional)
        # 設定内容: カスタムレスポンスを返します。
        custom_response {
          # response_code (Required)
          # 設定内容: HTTPステータスコードを指定します。
          # 設定可能な値: 200-599
          response_code = 429

          # custom_response_body_key (Optional)
          # 設定内容: custom_response_bodyブロックで定義したキーを参照します。
          # custom_response_body_key = "rate-limited"

          # response_header (Optional)
          # 設定内容: レスポンスヘッダーを追加します。
          response_header {
            name  = "Retry-After"
            value = "300"
          }
        }
      }

      # allow (Optional)
      # 設定内容: リクエストを許可します。
      # allow {
      #   custom_request_handling {
      #     insert_header {
      #       name  = "x-allowed"
      #       value = "true"
      #     }
      #   }
      # }

      # count (Optional)
      # 設定内容: リクエストをカウントします（許可しつつメトリクス収集）。
      # count {
      #   custom_request_handling {
      #     insert_header {
      #       name  = "x-counted"
      #       value = "true"
      #     }
      #   }
      # }

      # captcha (Optional)
      # 設定内容: CAPTCHAチャレンジを実行します。
      # captcha {
      #   custom_request_handling {
      #     insert_header {
      #       name  = "x-captcha-passed"
      #       value = "true"
      #     }
      #   }
      # }

      # challenge (Optional)
      # 設定内容: サイレントチャレンジを実行します。
      # challenge {
      #   custom_request_handling {
      #     insert_header {
      #       name  = "x-challenge-passed"
      #       value = "true"
      #     }
      #   }
      # }
    }

    statement {
      # rate_based_statement (Optional)
      # 設定内容: 指定期間内のリクエスト数に基づいてレート制限を適用します。
      # 注意: このステートメントはネストできません
      # 関連機能: Rate-based rules
      #   - https://docs.aws.amazon.com/waf/latest/developerguide/waf-rule-statement-type-rate-based.html
      rate_based_statement {
        # limit (Required)
        # 設定内容: 評価ウィンドウ内で許可するリクエスト数の上限を指定します。
        # 設定可能な値: 整数
        limit = 2000

        # aggregate_key_type (Optional)
        # 設定内容: リクエストをどのようにグループ化するかを指定します。
        # 設定可能な値:
        #   - "IP" (デフォルト): 送信元IPアドレスでグループ化
        #   - "FORWARDED_IP": X-Forwarded-ForヘッダーのIPでグループ化
        #   - "CONSTANT": すべてのリクエストを1グループとしてカウント
        #   - "CUSTOM_KEYS": カスタムキーでグループ化
        aggregate_key_type = "IP"

        # evaluation_window_sec (Optional)
        # 設定内容: リクエストをカウントする評価ウィンドウ（秒）を指定します。
        # 設定可能な値: 60, 120, 300, 600
        # 省略時: 300（5分）
        # 注意: AWS WAFは約10秒ごとにレートをチェックしますが、
        #       この設定はチェック頻度ではなく、遡って確認する期間を決定します
        evaluation_window_sec = 300

        # forwarded_ip_config (Optional)
        # 設定内容: FORWARDED_IP使用時のIPヘッダー設定を指定します。
        # 注意: aggregate_key_typeが"FORWARDED_IP"の場合に必須
        # forwarded_ip_config {
        #   # fallback_behavior (Required)
        #   # 設定内容: ヘッダーに有効なIPがない場合の動作
        #   # 設定可能な値: "MATCH", "NO_MATCH"
        #   fallback_behavior = "MATCH"
        #
        #   # header_name (Required)
        #   # 設定内容: IPアドレスを含むHTTPヘッダー名
        #   header_name = "X-Forwarded-For"
        # }

        # scope_down_statement (Optional)
        # 設定内容: レート制限を適用するリクエストを絞り込みます。
        # 注意: aggregate_key_typeが"CONSTANT"の場合に必須
        scope_down_statement {
          geo_match_statement {
            country_codes = ["US", "CN"]
          }
        }

        # custom_key (Optional)
        # 設定内容: CUSTOM_KEYS使用時のカスタム集約キーを指定します。
        # 複数のcustom_keyブロックを組み合わせ可能
        # custom_key {
        #   # header (Optional)
        #   # 設定内容: HTTPヘッダーの値をキーとして使用
        #   header {
        #     name = "x-api-key"
        #     text_transformation {
        #       priority = 0
        #       type     = "NONE"
        #     }
        #   }
        # }
        # custom_key {
        #   # cookie (Optional)
        #   # 設定内容: Cookieの値をキーとして使用
        #   cookie {
        #     name = "session-id"
        #     text_transformation {
        #       priority = 0
        #       type     = "NONE"
        #     }
        #   }
        # }
        # custom_key {
        #   # query_argument (Optional)
        #   # 設定内容: クエリ引数の値をキーとして使用
        #   query_argument {
        #     name = "api_key"
        #     text_transformation {
        #       priority = 0
        #       type     = "NONE"
        #     }
        #   }
        # }
        # custom_key {
        #   # query_string (Optional)
        #   # 設定内容: クエリ文字列全体をキーとして使用
        #   query_string {
        #     text_transformation {
        #       priority = 0
        #       type     = "NONE"
        #     }
        #   }
        # }
        # custom_key {
        #   # uri_path (Optional)
        #   # 設定内容: URIパスをキーとして使用
        #   uri_path {
        #     text_transformation {
        #       priority = 0
        #       type     = "NONE"
        #     }
        #   }
        # }
        # custom_key {
        #   # ip (Optional)
        #   # 設定内容: 送信元IPアドレスをキーとして使用
        #   ip {}
        # }
        # custom_key {
        #   # forwarded_ip (Optional)
        #   # 設定内容: 転送IPアドレスをキーとして使用
        #   forwarded_ip {}
        # }
        # custom_key {
        #   # http_method (Optional)
        #   # 設定内容: HTTPメソッドをキーとして使用
        #   http_method {}
        # }
        # custom_key {
        #   # label_namespace (Optional)
        #   # 設定内容: ラベル名前空間をキーとして使用
        #   label_namespace {
        #     namespace = "awswaf:managed:aws:bot-control:bot:category:"
        #   }
        # }
        # custom_key {
        #   # asn (Optional)
        #   # 設定内容: ASN（自律システム番号）をキーとして使用
        #   asn {}
        # }
        # custom_key {
        #   # ja3_fingerprint (Optional)
        #   # 設定内容: JA3フィンガープリントをキーとして使用
        #   ja3_fingerprint {
        #     fallback_behavior = "MATCH"
        #   }
        # }
        # custom_key {
        #   # ja4_fingerprint (Optional)
        #   # 設定内容: JA4フィンガープリントをキーとして使用
        #   ja4_fingerprint {
        #     fallback_behavior = "MATCH"
        #   }
        # }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "RateLimitRuleMetric"
      sampled_requests_enabled   = true
    }
  }

  #-------------------------------------------------------------
  # ルール例3: Geoマッチルール（国別フィルタリング）
  #-------------------------------------------------------------
  rule {
    name     = "BlockSpecificCountries"
    priority = 3

    action {
      block {}
    }

    statement {
      # geo_match_statement (Optional)
      # 設定内容: リクエストの送信元の国に基づいてマッチします。
      # 関連機能: Geographic match rule statement
      #   - https://docs.aws.amazon.com/waf/latest/developerguide/waf-rule-statement-type-geo-match.html
      geo_match_statement {
        # country_codes (Required)
        # 設定内容: マッチさせる国コードのリストを指定します。
        # 設定可能な値: ISO 3166 alpha-2国コード（例: "US", "JP", "CN"）
        # 参考: https://docs.aws.amazon.com/waf/latest/APIReference/API_GeoMatchStatement.html
        country_codes = ["RU", "KP"]

        # forwarded_ip_config (Optional)
        # 設定内容: 転送IPヘッダーから国を判定する設定を指定します。
        # forwarded_ip_config {
        #   fallback_behavior = "MATCH"
        #   header_name       = "X-Forwarded-For"
        # }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "BlockSpecificCountriesMetric"
      sampled_requests_enabled   = true
    }
  }

  #-------------------------------------------------------------
  # ルール例4: IP Setルール
  #-------------------------------------------------------------
  rule {
    name     = "AllowTrustedIPs"
    priority = 0

    action {
      allow {}
    }

    statement {
      # ip_set_reference_statement (Optional)
      # 設定内容: IP Setリソースを参照してIPアドレスベースのマッチを行います。
      # 関連機能: IP set rule statement
      #   - https://docs.aws.amazon.com/waf/latest/developerguide/waf-rule-statement-type-ipset-match.html
      ip_set_reference_statement {
        # arn (Required)
        # 設定内容: 参照するIP SetのARNを指定します。
        arn = "arn:aws:wafv2:ap-northeast-1:123456789012:regional/ipset/trusted-ips/12345678-1234-1234-1234-123456789012"

        # ip_set_forwarded_ip_config (Optional)
        # 設定内容: X-Forwarded-ForヘッダーからIPを取得する設定を指定します。
        # ip_set_forwarded_ip_config {
        #   # fallback_behavior (Required)
        #   # 設定内容: ヘッダーに有効なIPがない場合の動作
        #   # 設定可能な値: "MATCH", "NO_MATCH"
        #   fallback_behavior = "NO_MATCH"
        #
        #   # header_name (Required)
        #   # 設定内容: IPアドレスを含むHTTPヘッダー名
        #   header_name = "X-Forwarded-For"
        #
        #   # position (Required)
        #   # 設定内容: ヘッダー内のIPアドレスの位置
        #   # 設定可能な値: "FIRST", "LAST", "ANY"
        #   # 注意: ANYの場合、ヘッダーに10以上のIPがあると最後の10件を検査
        #   position = "FIRST"
        # }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AllowTrustedIPsMetric"
      sampled_requests_enabled   = true
    }
  }

  #-------------------------------------------------------------
  # ルール例5: バイトマッチルール（文字列マッチング）
  #-------------------------------------------------------------
  rule {
    name     = "BlockBadUserAgents"
    priority = 4

    action {
      block {}
    }

    statement {
      # byte_match_statement (Optional)
      # 設定内容: Webリクエストの指定部分に対して文字列マッチを行います。
      # 関連機能: String match rule statement
      #   - https://docs.aws.amazon.com/waf/latest/developerguide/waf-rule-statement-type-string-match.html
      byte_match_statement {
        # search_string (Required)
        # 設定内容: 検索する文字列を指定します。
        # 設定可能な値: 最大50バイトの文字列
        search_string = "BadBot"

        # positional_constraint (Required)
        # 設定内容: 文字列の検索位置を指定します。
        # 設定可能な値:
        #   - "EXACTLY": 完全一致
        #   - "STARTS_WITH": 前方一致
        #   - "ENDS_WITH": 後方一致
        #   - "CONTAINS": 部分一致
        #   - "CONTAINS_WORD": 単語として部分一致
        # 参考: https://docs.aws.amazon.com/waf/latest/APIReference/API_ByteMatchStatement.html
        positional_constraint = "CONTAINS"

        # field_to_match (Optional)
        # 設定内容: 検査対象のリクエストコンポーネントを指定します。
        field_to_match {
          # single_header (Optional)
          # 設定内容: 特定のヘッダーを検査します。
          single_header {
            # name (Required)
            # 設定内容: ヘッダー名を小文字で指定します。
            name = "user-agent"
          }

          # 他のfield_to_matchオプション:
          #
          # all_query_arguments (Optional)
          # 設定内容: 全クエリ引数を検査します。
          # all_query_arguments {}
          #
          # body (Optional)
          # 設定内容: リクエストボディを検査します。
          # body {
          #   # oversize_handling (Optional)
          #   # 設定内容: ボディサイズが制限（8KB）を超えた場合の処理
          #   # 設定可能な値: "CONTINUE", "MATCH", "NO_MATCH"
          #   oversize_handling = "CONTINUE"
          # }
          #
          # cookies (Optional)
          # 設定内容: Cookieを検査します。
          # cookies {
          #   match_pattern {
          #     # all (Optional): すべてのCookieを検査
          #     # all {}
          #     # included_cookies (Optional): 特定のCookieのみ検査
          #     included_cookies = ["session", "token"]
          #     # excluded_cookies (Optional): 特定のCookieを除外して検査
          #     # excluded_cookies = ["tracking"]
          #   }
          #   match_scope       = "ALL"    # "ALL", "KEY", "VALUE"
          #   oversize_handling = "NO_MATCH"  # "CONTINUE", "MATCH", "NO_MATCH"
          # }
          #
          # headers (Optional)
          # 設定内容: 複数のリクエストヘッダーを検査します。
          # headers {
          #   match_pattern {
          #     # all (Optional): すべてのヘッダーを検査
          #     # all {}
          #     # included_headers (Optional): 特定のヘッダーのみ検査
          #     included_headers = ["referer", "user-agent"]
          #     # excluded_headers (Optional): 特定のヘッダーを除外して検査
          #     # excluded_headers = ["cookie"]
          #   }
          #   match_scope       = "ALL"    # "ALL", "Key", "Value"
          #   oversize_handling = "CONTINUE"  # "CONTINUE", "MATCH", "NO_MATCH"
          # }
          #
          # header_order (Optional)
          # 設定内容: ヘッダー名のリスト（順序付き）を検査します。
          # header_order {
          #   oversize_handling = "CONTINUE"
          # }
          #
          # json_body (Optional)
          # 設定内容: JSONボディを検査します。
          # json_body {
          #   match_pattern {
          #     # all (Optional): JSON全体を検査
          #     # all {}
          #     # included_paths (Optional): 特定のJSONパスを検査
          #     included_paths = ["/action", "/username"]
          #   }
          #   match_scope              = "ALL"    # "ALL", "KEY", "VALUE"
          #   invalid_fallback_behavior = "EVALUATE_AS_STRING"  # "EVALUATE_AS_STRING", "MATCH", "NO_MATCH"
          #   oversize_handling        = "CONTINUE"  # "CONTINUE", "MATCH", "NO_MATCH"
          # }
          #
          # method (Optional)
          # 設定内容: HTTPメソッドを検査します。
          # method {}
          #
          # query_string (Optional)
          # 設定内容: クエリ文字列を検査します。
          # query_string {}
          #
          # single_query_argument (Optional)
          # 設定内容: 特定のクエリ引数を検査します。
          # single_query_argument {
          #   name = "param"
          # }
          #
          # uri_path (Optional)
          # 設定内容: URIパスを検査します。
          # uri_path {}
          #
          # uri_fragment (Optional)
          # 設定内容: URIフラグメント（#以降）を検査します。
          # uri_fragment {
          #   # fallback_behavior (Optional)
          #   # 設定内容: パース失敗時の動作
          #   # 設定可能な値: "MATCH" (デフォルト), "NO_MATCH"
          #   fallback_behavior = "MATCH"
          # }
          #
          # ja3_fingerprint (Optional)
          # 設定内容: JA3フィンガープリントを検査します。
          # ja3_fingerprint {
          #   fallback_behavior = "MATCH"  # "MATCH", "NO_MATCH"
          # }
          #
          # ja4_fingerprint (Optional)
          # 設定内容: JA4フィンガープリントを検査します。
          # ja4_fingerprint {
          #   fallback_behavior = "MATCH"  # "MATCH", "NO_MATCH"
          # }
        }

        # text_transformation (Required)
        # 設定内容: 検査前にテキストに適用する変換を指定します。
        # 注意: 最低1つ必要。攻撃者のエンコード回避を防ぐため
        # 参考: https://docs.aws.amazon.com/waf/latest/APIReference/API_TextTransformation.html
        text_transformation {
          # priority (Required)
          # 設定内容: 変換の適用順序（小さい値から適用）
          priority = 0

          # type (Required)
          # 設定内容: 変換タイプを指定します。
          # 設定可能な値:
          #   - "NONE": 変換なし
          #   - "LOWERCASE": 小文字化
          #   - "HTML_ENTITY_DECODE": HTMLエンティティデコード
          #   - "URL_DECODE": URLデコード
          #   - "CMD_LINE": コマンドライン正規化
          #   - "BASE64_DECODE": Base64デコード
          #   - "COMPRESS_WHITE_SPACE": 空白圧縮
          #   - その他多数（公式ドキュメント参照）
          type = "LOWERCASE"
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "BlockBadUserAgentsMetric"
      sampled_requests_enabled   = true
    }
  }

  #-------------------------------------------------------------
  # ルール例6: 複合条件（AND/OR/NOT）
  #-------------------------------------------------------------
  rule {
    name     = "ComplexConditionRule"
    priority = 5

    action {
      count {}
    }

    statement {
      # and_statement (Optional)
      # 設定内容: 複数のステートメントをAND条件で組み合わせます。
      and_statement {
        statement {
          geo_match_statement {
            country_codes = ["JP"]
          }
        }
        statement {
          # not_statement (Optional)
          # 設定内容: ステートメントの結果を反転します。
          not_statement {
            statement {
              ip_set_reference_statement {
                arn = "arn:aws:wafv2:ap-northeast-1:123456789012:regional/ipset/blocked-ips/12345678-1234-1234-1234-123456789012"
              }
            }
          }
        }
      }

      # or_statement (Optional)
      # 設定内容: 複数のステートメントをOR条件で組み合わせます。
      # or_statement {
      #   statement { ... }
      #   statement { ... }
      # }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "ComplexConditionRuleMetric"
      sampled_requests_enabled   = true
    }
  }

  #-------------------------------------------------------------
  # ルール例7: SQLインジェクション検出
  #-------------------------------------------------------------
  rule {
    name     = "SQLInjectionRule"
    priority = 6

    action {
      block {}
    }

    statement {
      # sqli_match_statement (Optional)
      # 設定内容: SQLインジェクション攻撃パターンを検出します。
      # 関連機能: SQL injection attack rule statement
      #   - https://docs.aws.amazon.com/waf/latest/developerguide/waf-rule-statement-type-sqli-match.html
      sqli_match_statement {
        # sensitivity_level (Optional)
        # 設定内容: 検出感度を指定します。
        # 設定可能な値:
        #   - "LOW": 低感度（誤検知少、検出漏れ可能性あり）
        #   - "HIGH": 高感度（検出率高、誤検知可能性あり）
        sensitivity_level = "HIGH"

        field_to_match {
          query_string {}
        }

        text_transformation {
          priority = 0
          type     = "URL_DECODE"
        }

        text_transformation {
          priority = 1
          type     = "HTML_ENTITY_DECODE"
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "SQLInjectionRuleMetric"
      sampled_requests_enabled   = true
    }
  }

  #-------------------------------------------------------------
  # ルール例8: XSS（クロスサイトスクリプティング）検出
  #-------------------------------------------------------------
  rule {
    name     = "XSSRule"
    priority = 7

    action {
      block {}
    }

    statement {
      # xss_match_statement (Optional)
      # 設定内容: クロスサイトスクリプティング攻撃パターンを検出します。
      # 関連機能: Cross-site scripting attack rule statement
      #   - https://docs.aws.amazon.com/waf/latest/developerguide/waf-rule-statement-type-xss-match.html
      xss_match_statement {
        field_to_match {
          body {
            # oversize_handling (Optional)
            # 設定内容: ボディサイズが制限を超えた場合の処理を指定します。
            # 設定可能な値:
            #   - "CONTINUE": 検査可能な部分のみ検査
            #   - "MATCH": ルールにマッチとみなす
            #   - "NO_MATCH": ルールにマッチしないとみなす
            # 参考: https://docs.aws.amazon.com/waf/latest/developerguide/waf-rule-statement-oversize-handling.html
            oversize_handling = "CONTINUE"
          }
        }

        text_transformation {
          priority = 0
          type     = "URL_DECODE"
        }

        text_transformation {
          priority = 1
          type     = "HTML_ENTITY_DECODE"
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "XSSRuleMetric"
      sampled_requests_enabled   = true
    }
  }

  #-------------------------------------------------------------
  # ルール例9: 正規表現マッチルール
  #-------------------------------------------------------------
  rule {
    name     = "RegexMatchRule"
    priority = 8

    action {
      count {}
    }

    statement {
      # regex_match_statement (Optional)
      # 設定内容: 正規表現パターンでマッチングを行います。
      # 関連機能: Regex match rule statement
      #   - https://docs.aws.amazon.com/waf/latest/developerguide/waf-rule-statement-type-regex-match.html
      regex_match_statement {
        # regex_string (Required)
        # 設定内容: 正規表現パターンを指定します。
        # 設定可能な値: 1-512文字の正規表現
        regex_string = "^/api/v[0-9]+/"

        field_to_match {
          uri_path {}
        }

        text_transformation {
          priority = 0
          type     = "NONE"
        }
      }

      # regex_pattern_set_reference_statement (Optional)
      # 設定内容: Regex Pattern Setリソースを参照してマッチングを行います。
      # regex_pattern_set_reference_statement {
      #   # arn (Required)
      #   # 設定内容: Regex Pattern SetのARN
      #   arn = "arn:aws:wafv2:..."
      #
      #   field_to_match {
      #     uri_path {}
      #   }
      #
      #   text_transformation {
      #     priority = 0
      #     type     = "NONE"
      #   }
      # }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "RegexMatchRuleMetric"
      sampled_requests_enabled   = true
    }
  }

  #-------------------------------------------------------------
  # ルール例10: サイズ制約ルール
  #-------------------------------------------------------------
  rule {
    name     = "SizeConstraintRule"
    priority = 9

    action {
      block {}
    }

    statement {
      # size_constraint_statement (Optional)
      # 設定内容: リクエストコンポーネントのサイズに基づいてマッチします。
      # 関連機能: Size constraint rule statement
      #   - https://docs.aws.amazon.com/waf/latest/developerguide/waf-rule-statement-type-size-constraint-match.html
      size_constraint_statement {
        # comparison_operator (Required)
        # 設定内容: 比較演算子を指定します。
        # 設定可能な値: "EQ", "NE", "LE", "LT", "GE", "GT"
        comparison_operator = "GT"

        # size (Required)
        # 設定内容: 比較対象のサイズ（バイト）を指定します。
        # 設定可能な値: 0-21474836480
        size = 8192

        field_to_match {
          body {
            oversize_handling = "NO_MATCH"
          }
        }

        text_transformation {
          priority = 0
          type     = "NONE"
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "SizeConstraintRuleMetric"
      sampled_requests_enabled   = true
    }
  }

  #-------------------------------------------------------------
  # ルール例11: ラベルマッチルール
  #-------------------------------------------------------------
  rule {
    name     = "LabelMatchRule"
    priority = 10

    action {
      block {}
    }

    statement {
      # label_match_statement (Optional)
      # 設定内容: 先行ルールで付与されたラベルに基づいてマッチします。
      # 関連機能: Label match rule statement
      #   - https://docs.aws.amazon.com/waf/latest/developerguide/waf-rule-label-match-statement.html
      label_match_statement {
        # scope (Required)
        # 設定内容: マッチング対象を指定します。
        # 設定可能な値:
        #   - "LABEL": ラベル名全体
        #   - "NAMESPACE": ラベルの名前空間部分
        scope = "LABEL"

        # key (Required)
        # 設定内容: マッチさせるラベル文字列を指定します。
        key = "awswaf:managed:aws:bot-control:bot:category:http_library"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "LabelMatchRuleMetric"
      sampled_requests_enabled   = true
    }
  }

  #-------------------------------------------------------------
  # ルール例12: ASNマッチルール
  #-------------------------------------------------------------
  rule {
    name     = "ASNMatchRule"
    priority = 11

    action {
      count {}
    }

    statement {
      # asn_match_statement (Optional)
      # 設定内容: リクエストのIPアドレスに関連するASN（自律システム番号）に基づいてマッチします。
      asn_match_statement {
        # asn_list (Required)
        # 設定内容: マッチさせるASN番号のリストを指定します。
        asn_list = [16509, 14618] # Amazon ASNs

        # forwarded_ip_config (Optional)
        # 設定内容: X-Forwarded-ForヘッダーからIPを取得する設定を指定します。
        # forwarded_ip_config {
        #   fallback_behavior = "MATCH"
        #   header_name       = "X-Forwarded-For"
        # }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "ASNMatchRuleMetric"
      sampled_requests_enabled   = true
    }
  }

  #-------------------------------------------------------------
  # ルール例13: ルールグループ参照
  #-------------------------------------------------------------
  rule {
    name     = "CustomRuleGroupReference"
    priority = 12

    override_action {
      none {}
    }

    statement {
      # rule_group_reference_statement (Optional)
      # 設定内容: 自作またはサードパーティのルールグループを参照します。
      rule_group_reference_statement {
        # arn (Required)
        # 設定内容: 参照するルールグループのARNを指定します。
        arn = "arn:aws:wafv2:ap-northeast-1:123456789012:regional/rulegroup/custom-rule-group/12345678-1234-1234-1234-123456789012"

        # rule_action_override (Optional)
        # 設定内容: ルールグループ内の特定ルールのアクションを上書きします。
        # rule_action_override {
        #   name = "rule-to-override"
        #   action_to_use {
        #     count {}
        #   }
        # }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "CustomRuleGroupReferenceMetric"
      sampled_requests_enabled   = true
    }
  }

  #-------------------------------------------------------------
  # rule_json属性 (Optional)
  #-------------------------------------------------------------
  # 設定内容: ルールをJSON形式で指定します。
  # 注意: ruleブロックとrule_json属性は排他的（同時使用不可）
  # 用途: 複雑なルール構造やAPIレスポンスからの直接インポート時に便利
  # rule_json = jsonencode([...])

  #-------------------------------------------------------------
  # カスタムレスポンスボディ設定 (Optional)
  #-------------------------------------------------------------
  # 設定内容: ブロック時に返すカスタムレスポンスボディを定義します。
  # custom_responseブロックのcustom_response_body_keyで参照します。

  custom_response_body {
    # key (Required)
    # 設定内容: このレスポンスボディの一意のキーを指定します。
    key = "blocked-response"

    # content_type (Required)
    # 設定内容: コンテンツのMIMEタイプを指定します。
    # 設定可能な値: "TEXT_PLAIN", "TEXT_HTML", "APPLICATION_JSON"
    content_type = "APPLICATION_JSON"

    # content (Required)
    # 設定内容: レスポンスボディのコンテンツを指定します。
    content = jsonencode({
      error   = "Forbidden"
      message = "Your request has been blocked by WAF"
    })
  }

  #-------------------------------------------------------------
  # CAPTCHA設定 (Optional)
  #-------------------------------------------------------------
  # 設定内容: Web ACLレベルのCAPTCHA設定を指定します。
  # 関連機能: AWS WAF CAPTCHA
  #   AWS Bot Controlで使用されるCAPTCHA評価のACLレベル設定
  #   - https://docs.aws.amazon.com/waf/latest/developerguide/waf-captcha-puzzle.html

  captcha_config {
    immunity_time_property {
      # immunity_time (Optional)
      # 設定内容: CAPTCHAトークンの有効期間（秒）を指定します。
      # 省略時: 300秒
      immunity_time = 300
    }
  }

  #-------------------------------------------------------------
  # チャレンジ設定 (Optional)
  #-------------------------------------------------------------
  # 設定内容: Web ACLレベルのサイレントチャレンジ設定を指定します。
  # 関連機能: AWS WAF Challenge
  #   AWS Bot Controlで使用されるChallenge評価のACLレベル設定
  #   - https://docs.aws.amazon.com/waf/latest/developerguide/waf-challenge.html

  challenge_config {
    immunity_time_property {
      # immunity_time (Optional)
      # 設定内容: チャレンジトークンの有効期間（秒）を指定します。
      # 省略時: 300秒
      immunity_time = 300
    }
  }

  #-------------------------------------------------------------
  # アソシエーション設定 (Optional)
  #-------------------------------------------------------------
  # 設定内容: 保護対象リソースからAWS WAFへ転送されるリクエストボディの
  #          検査設定をカスタマイズします。

  association_config {
    request_body {
      # api_gateway (Optional)
      # 設定内容: API Gatewayからのリクエストボディ検査設定
      # 適用条件: scopeが"REGIONAL"の場合
      api_gateway {
        # default_size_inspection_limit (Required)
        # 設定内容: リクエストボディの最大検査サイズを指定します。
        # 設定可能な値: "KB_16", "KB_32", "KB_48", "KB_64"
        default_size_inspection_limit = "KB_64"
      }

      # app_runner_service (Optional)
      # 設定内容: App Runnerからのリクエストボディ検査設定
      # 適用条件: scopeが"REGIONAL"の場合
      # app_runner_service {
      #   default_size_inspection_limit = "KB_64"
      # }

      # cloudfront (Optional)
      # 設定内容: CloudFrontからのリクエストボディ検査設定
      # 適用条件: scopeが"CLOUDFRONT"の場合
      # cloudfront {
      #   default_size_inspection_limit = "KB_64"
      # }

      # cognito_user_pool (Optional)
      # 設定内容: Cognito User Poolからのリクエストボディ検査設定
      # 適用条件: scopeが"REGIONAL"の場合
      # cognito_user_pool {
      #   default_size_inspection_limit = "KB_64"
      # }

      # verified_access_instance (Optional)
      # 設定内容: Verified Accessからのリクエストボディ検査設定
      # 適用条件: scopeが"REGIONAL"の場合
      # verified_access_instance {
      #   default_size_inspection_limit = "KB_64"
      # }
    }
  }

  #-------------------------------------------------------------
  # データ保護設定 (Optional)
  #-------------------------------------------------------------
  # 設定内容: WAFログに記録されるリクエストデータの保護設定を指定します。
  # センシティブなフィールドをマスキングまたはハッシュ化できます。

  data_protection_config {
    data_protection {
      # action (Required)
      # 設定内容: データ保護のアクションを指定します。
      # 設定可能な値:
      #   - "SUBSTITUTION": データを固定文字列で置換（マスキング）
      #   - "HASH": データをハッシュ化
      action = "HASH"

      # exclude_rate_based_details (Optional)
      # 設定内容: レートベースルールの詳細をデータ保護から除外するかを指定します。
      exclude_rate_based_details = false

      # exclude_rule_match_details (Optional)
      # 設定内容: ルールマッチの詳細をデータ保護から除外するかを指定します。
      # 注意: 非終了マッチルールと終了マッチルールのルールマッチ詳細に適用
      exclude_rule_match_details = false

      field {
        # field_type (Required)
        # 設定内容: 保護対象のフィールドタイプを指定します。
        # 設定可能な値: "SINGLE_HEADER", "SINGLE_COOKIE", "SINGLE_QUERY_ARGUMENT",
        #              "QUERY_STRING", "BODY"
        field_type = "SINGLE_HEADER"

        # field_keys (Optional)
        # 設定内容: 保護対象の特定のキーを指定します。
        # 省略時: 指定タイプのすべてのフィールドを保護
        field_keys = ["authorization", "x-api-key"]
      }
    }
  }

  #-------------------------------------------------------------
  # トークンドメイン設定 (Optional)
  #-------------------------------------------------------------

  # token_domains (Optional)
  # 設定内容: AWS WAFトークンを受け入れるドメインのリストを指定します。
  # 用途: 複数の保護対象Webサイト間でトークンを共有する場合に使用
  # 省略時: 保護対象リソースのドメインのみでトークンを受け入れ
  # 注意: ドメインのプレフィックスサブドメインも自動的に含まれます
  token_domains = ["example.com", "api.example.com"]

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定と重複するキーは上書きされます。
  tags = {
    Name        = "example-web-acl"
    Environment = "production"
    ManagedBy   = "Terraform"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: Web ACLのAmazon Resource Name (ARN)
#
# - id: Web ACLのID
#
# - capacity: このWeb ACLが使用しているWAF容量ユニット（WCU）
#
# - lock_token: Web ACLの同時更新を防止するためのロックトークン
#
# - application_integration_url: マネージドルールグループとのSDK統合で使用するURL
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------

#---------------------------------------------------------------
# 重要な注意事項
#---------------------------------------------------------------
#
# 1. ルールとrule_jsonの排他性:
#    ruleブロックとrule_json属性は同時に使用できません。
#    どちらか一方を選択してください。
#
# 2. Rule Group Associationとの競合:
#    aws_wafv2_web_acl_rule_group_associationリソースを使用する場合、
#    lifecycle { ignore_changes = [rule] }を追加して構成ドリフトを防いでください。
#
# 3. CloudFrontスコープの制約:
#    scope = "CLOUDFRONT"を使用する場合、AWSプロバイダーのリージョンを
#    us-east-1に設定する必要があります。
#
# 4. field_to_matchのoversize_handling:
#    2023年2月以降、bodyブロックのoversize_handling引数は必須として扱ってください。
#
# 5. ルール評価順序:
#    ルールはpriority値の小さい順に評価されます。
#    マッチしたルールのアクションに応じて評価が継続または終了します。
#
# 6. マネージドルールグループの更新:
#    AWSマネージドルールグループは自動更新されることがあります。
#    特定バージョンを固定したい場合はversion引数を指定してください。
#
#---------------------------------------------------------------
