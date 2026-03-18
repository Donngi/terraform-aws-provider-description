#---------------------------------------------------------------
# AWS WAFv2 Web ACL ルールグループ関連付け
#---------------------------------------------------------------
#
# AWS WAFv2 Web ACLにルールグループ（カスタムまたはマネージド）を
# 関連付けるためのリソースです。
# Web ACLに対してルールグループを参照するルールを追加することで、
# 既存のWeb ACLを変更せずにルールグループを適用できます。
# カスタムルールグループとAWSマネージドルールグループの両方に対応しています。
#
# 注意: このリソースを使用すると、関連付けられたWeb ACLリソースの rule 引数に
#       設定ドリフトが発生します。Web ACLリソースに
#       lifecycle { ignore_changes = [rule] } を追加してください。
#
# AWS公式ドキュメント:
#   - AWS WAF ルールグループ: https://docs.aws.amazon.com/waf/latest/developerguide/waf-rule-groups.html
#   - マネージドルールグループ: https://docs.aws.amazon.com/waf/latest/developerguide/waf-managed-rule-groups.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_web_acl_rule_group_association
#
# Provider Version: 6.36.0
# Generated: 2026-03-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_wafv2_web_acl_rule_group_association" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # web_acl_arn (Required)
  # 設定内容: ルールグループを関連付けるWeb ACLのARNを指定します。
  # 設定可能な値: 有効なWAFv2 Web ACLのARN
  web_acl_arn = "arn:aws:wafv2:ap-northeast-1:123456789012:regional/webacl/my-web-acl/12345678-1234-1234-1234-123456789012"

  # rule_name (Required)
  # 設定内容: Web ACL内に作成するルールの名前を指定します。
  # 設定可能な値: 1〜128文字の英数字、ハイフン、アンダースコア
  rule_name = "my-rule-group-rule"

  # priority (Required)
  # 設定内容: Web ACL内でこのルールが評価される優先度を指定します。
  # 設定可能な値: 0〜10,000の整数（数値が小さいほど優先度が高い）
  # 注意: 同一Web ACL内で重複した優先度は指定できません。
  priority = 1

  # override_action (Optional)
  # 設定内容: ルールグループのアクションを上書きするアクションを指定します。
  # 設定可能な値: "none"（ルールグループのアクションをそのまま使用）、"count"（カウントのみ実行）
  # 省略時: "none"
  override_action = "none"

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # カスタムルールグループ参照設定
  #-------------------------------------------------------------

  # rule_group_reference (Optional)
  # 設定内容: カスタムルールグループへの参照を指定します。
  # 注意: rule_group_referenceとmanaged_rule_groupのどちらか一方のみ指定可能です。
  rule_group_reference {
    # arn (Required)
    # 設定内容: 関連付けるルールグループのARNを指定します。
    # 設定可能な値: 有効なWAFv2ルールグループのARN
    arn = "arn:aws:wafv2:ap-northeast-1:123456789012:regional/rulegroup/my-rule-group/12345678-1234-1234-1234-123456789012"

    # rule_action_override (Optional)
    # 設定内容: ルールグループ内の特定ルールのアクションを上書きする設定です。
    # 注意: 最大100件まで指定可能です。カスタムルールグループでは、無効なルール名を
    #       指定するとWeb ACLの更新が失敗します。
    rule_action_override {
      # name (Required)
      # 設定内容: 上書き対象のルール名を指定します。
      # 設定可能な値: ルールグループ内の有効なルール名（大文字小文字を区別）
      name = "my-rule-to-override"

      # action_to_use (Required)
      # 設定内容: 代わりに使用するアクションを指定します。
      # 注意: allow, block, captcha, challenge, count のいずれか1つを指定します。
      action_to_use {
        # allow (Optional)
        # 設定内容: リクエストを許可するアクションを指定します。
        allow {
          # custom_request_handling (Optional)
          # 設定内容: 許可時にリクエストに追加するカスタムHTTPヘッダーを指定します。
          custom_request_handling {
            # insert_header (Required)
            # 設定内容: 挿入するHTTPヘッダーの名前と値を指定します。
            insert_header {
              # name (Required)
              # 設定内容: 挿入するHTTPヘッダーの名前を指定します。
              name = "x-custom-header"

              # value (Required)
              # 設定内容: 挿入するHTTPヘッダーの値を指定します。
              value = "allowed"
            }
          }
        }

        # block (Optional)
        # 設定内容: リクエストをブロックするアクションを指定します。
        # block {
        #   # custom_response (Optional)
        #   # 設定内容: ブロック時にクライアントへ返すカスタムHTTPレスポンスを指定します。
        #   custom_response {
        #     # response_code (Required)
        #     # 設定内容: クライアントへ返すHTTPステータスコードを指定します。
        #     # 設定可能な値: 200〜599の整数
        #     response_code = 403
        #
        #     # custom_response_body_key (Optional)
        #     # 設定内容: Web ACLに定義されたカスタムレスポンスボディのキーを指定します。
        #     # 省略時: カスタムレスポンスボディを使用しない
        #     custom_response_body_key = null
        #
        #     # response_header (Optional)
        #     # 設定内容: レスポンスに追加するカスタムHTTPヘッダーを指定します。
        #     response_header {
        #       # name (Required)
        #       # 設定内容: 追加するHTTPヘッダーの名前を指定します。
        #       name = "x-blocked-by"
        #
        #       # value (Required)
        #       # 設定内容: 追加するHTTPヘッダーの値を指定します。
        #       value = "waf"
        #     }
        #   }
        # }

        # captcha (Optional)
        # 設定内容: CAPTCHAチャレンジを要求するアクションを指定します。
        # captcha {
        #   # custom_request_handling (Optional)
        #   # 設定内容: CAPTCHA成功時にリクエストに追加するカスタムHTTPヘッダーを指定します。
        #   custom_request_handling {
        #     insert_header {
        #       name  = "x-captcha-result"
        #       value = "passed"
        #     }
        #   }
        # }

        # challenge (Optional)
        # 設定内容: JavaScriptチャレンジを要求するアクションを指定します。
        # challenge {
        #   # custom_request_handling (Optional)
        #   # 設定内容: チャレンジ成功時にリクエストに追加するカスタムHTTPヘッダーを指定します。
        #   custom_request_handling {
        #     insert_header {
        #       name  = "x-challenge-result"
        #       value = "passed"
        #     }
        #   }
        # }

        # count (Optional)
        # 設定内容: リクエストをカウントのみするアクションを指定します。
        # count {
        #   # custom_request_handling (Optional)
        #   # 設定内容: カウント時にリクエストに追加するカスタムHTTPヘッダーを指定します。
        #   custom_request_handling {
        #     insert_header {
        #       name  = "x-counted-by"
        #       value = "waf"
        #     }
        #   }
        # }
      }
    }
  }

  #-------------------------------------------------------------
  # マネージドルールグループ設定
  #-------------------------------------------------------------

  # managed_rule_group (Optional)
  # 設定内容: AWSマネージドルールグループへの参照を指定します。
  # 注意: rule_group_referenceとmanaged_rule_groupのどちらか一方のみ指定可能です。
  # managed_rule_group {
  #   # name (Required)
  #   # 設定内容: マネージドルールグループの名前を指定します。
  #   # 設定可能な値: 有効なマネージドルールグループ名（例: AWSManagedRulesCommonRuleSet）
  #   name = "AWSManagedRulesCommonRuleSet"
  #
  #   # vendor_name (Required)
  #   # 設定内容: マネージドルールグループのベンダー名を指定します。
  #   # 設定可能な値: "AWS"（AWS管理のルールグループ）またはAWS Marketplaceのベンダー名
  #   vendor_name = "AWS"
  #
  #   # version (Optional)
  #   # 設定内容: 使用するマネージドルールグループのバージョンを指定します。
  #   # 省略時: デフォルトバージョンを使用
  #   version = null
  #
  #   # rule_action_override (Optional)
  #   # 設定内容: マネージドルールグループ内の特定ルールのアクションを上書きする設定です。
  #   # 注意: マネージドルールグループでは、無効なルール名を指定してもWAFは
  #   #       エラーを出さずに無視します。ルール名を正確に確認してください。
  #   rule_action_override {
  #     name = "SizeRestrictions_BODY"
  #
  #     action_to_use {
  #       count {
  #         custom_request_handling {
  #           insert_header {
  #             name  = "x-overridden-rule"
  #             value = "SizeRestrictions_BODY"
  #           }
  #         }
  #       }
  #     }
  #   }
  #
  #   #---------------------------------------------------------
  #   # マネージドルールグループ追加設定
  #   #---------------------------------------------------------
  #
  #   # managed_rule_group_configs (Optional)
  #   # 設定内容: マネージドルールグループの追加設定を指定します。
  #   # 注意: 各configブロックにはルール属性を1つだけ指定できます。
  #   managed_rule_group_configs {
  #
  #     # aws_managed_rules_acfp_rule_set (Optional)
  #     # 設定内容: アカウント作成不正防止（ACFP）マネージドルールグループの追加設定です。
  #     # aws_managed_rules_acfp_rule_set {
  #     #   # creation_path (Required)
  #     #   # 設定内容: アカウント作成エンドポイントのパスを指定します。POSTリクエストを受け付けるページです。
  #     #   creation_path = "/creation"
  #     #
  #     #   # registration_page_path (Required)
  #     #   # 設定内容: アカウント登録ページのパスを指定します。GETリクエストでHTMLを返すページです。
  #     #   registration_page_path = "/registration"
  #     #
  #     #   # enable_regex_in_path (Optional)
  #     #   # 設定内容: パスに正規表現を使用するかどうかを指定します。
  #     #   # 省略時: false
  #     #   enable_regex_in_path = false
  #     #
  #     #   # request_inspection (Optional)
  #     #   # 設定内容: リクエスト検査の設定です。
  #     #   request_inspection {
  #     #     # payload_type (Required)
  #     #     # 設定内容: ペイロードのタイプを指定します。
  #     #     # 設定可能な値: "JSON", "FORM_ENCODED"
  #     #     payload_type = "JSON"
  #     #
  #     #     # email_field (Optional)
  #     #     # 設定内容: メールアドレスフィールドの識別子を指定します。
  #     #     email_field {
  #     #       identifier = "/email"
  #     #     }
  #     #
  #     #     # password_field (Optional)
  #     #     # 設定内容: パスワードフィールドの識別子を指定します。
  #     #     password_field {
  #     #       identifier = "/password"
  #     #     }
  #     #
  #     #     # username_field (Optional)
  #     #     # 設定内容: ユーザー名フィールドの識別子を指定します。
  #     #     username_field {
  #     #       identifier = "/username"
  #     #     }
  #     #
  #     #     # phone_number_fields (Optional)
  #     #     # 設定内容: 電話番号フィールドの識別子を指定します。
  #     #     phone_number_fields {
  #     #       identifiers = ["/phone1", "/phone2"]
  #     #     }
  #     #
  #     #     # address_fields (Optional)
  #     #     # 設定内容: 住所フィールドの識別子を指定します。
  #     #     address_fields {
  #     #       identifiers = ["home", "work"]
  #     #     }
  #     #   }
  #     #
  #     #   # response_inspection (Optional)
  #     #   # 設定内容: レスポンス検査の設定です。CloudFrontディストリビューションを保護するWeb ACLでのみ使用可能です。
  #     #   response_inspection {
  #     #     # status_code (Optional)
  #     #     # 設定内容: レスポンスのステータスコードを検査します。
  #     #     status_code {
  #     #       success_codes = [200, 201]
  #     #       failure_codes = [400, 401, 403]
  #     #     }
  #     #
  #     #     # header (Optional)
  #     #     # 設定内容: レスポンスヘッダーを検査します。
  #     #     # header {
  #     #     #   name           = "x-login-result"
  #     #     #   success_values = ["success"]
  #     #     #   failure_values = ["failure"]
  #     #     # }
  #     #
  #     #     # body_contains (Optional)
  #     #     # 設定内容: レスポンスボディの内容を検査します。
  #     #     # body_contains {
  #     #     #   success_strings = ["login successful"]
  #     #     #   failure_strings = ["login failed"]
  #     #     # }
  #     #
  #     #     # json (Optional)
  #     #     # 設定内容: レスポンスJSONの内容を検査します。
  #     #     # json {
  #     #     #   identifier      = "/result"
  #     #     #   success_values = ["success"]
  #     #     #   failure_values = ["failure"]
  #     #     # }
  #     #   }
  #     # }
  #
  #     # aws_managed_rules_atp_rule_set (Optional)
  #     # 設定内容: アカウント乗っ取り防止（ATP）マネージドルールグループの追加設定です。
  #     # aws_managed_rules_atp_rule_set {
  #     #   # login_path (Required)
  #     #   # 設定内容: ログインエンドポイントのパスを指定します。
  #     #   login_path = "/login"
  #     #
  #     #   # enable_regex_in_path (Optional)
  #     #   # 設定内容: パスに正規表現を使用するかどうかを指定します。
  #     #   # 省略時: false
  #     #   enable_regex_in_path = false
  #     #
  #     #   # request_inspection (Optional)
  #     #   # 設定内容: ログインリクエスト検査の設定です。
  #     #   request_inspection {
  #     #     # payload_type (Required)
  #     #     # 設定内容: ペイロードのタイプを指定します。
  #     #     # 設定可能な値: "JSON", "FORM_ENCODED"
  #     #     payload_type = "JSON"
  #     #
  #     #     # password_field (Optional)
  #     #     # 設定内容: パスワードフィールドの識別子を指定します。
  #     #     password_field {
  #     #       identifier = "/password"
  #     #     }
  #     #
  #     #     # username_field (Optional)
  #     #     # 設定内容: ユーザー名フィールドの識別子を指定します。
  #     #     username_field {
  #     #       identifier = "/username"
  #     #     }
  #     #   }
  #     #
  #     #   # response_inspection (Optional)
  #     #   # 設定内容: レスポンス検査の設定です。CloudFrontディストリビューションを保護するWeb ACLでのみ使用可能です。
  #     #   response_inspection {
  #     #     status_code {
  #     #       success_codes = [200]
  #     #       failure_codes = [401, 403]
  #     #     }
  #     #   }
  #     # }
  #
  #     # aws_managed_rules_bot_control_rule_set (Optional)
  #     # 設定内容: Bot Controlマネージドルールグループの追加設定です。
  #     # aws_managed_rules_bot_control_rule_set {
  #     #   # inspection_level (Required)
  #     #   # 設定内容: ボット制御の検査レベルを指定します。
  #     #   # 設定可能な値: "COMMON", "TARGETED"
  #     #   inspection_level = "COMMON"
  #     #
  #     #   # enable_machine_learning (Optional)
  #     #   # 設定内容: 機械学習を使用してボット関連のアクティビティを分析するかどうかを指定します。
  #     #   # 省略時: false
  #     #   # 注意: TARGETEDレベルの場合のみ適用されます。
  #     #   enable_machine_learning = false
  #     # }
  #
  #     # aws_managed_rules_anti_ddos_rule_set (Optional)
  #     # 設定内容: Anti-DDoSマネージドルールグループの追加設定です。
  #     # aws_managed_rules_anti_ddos_rule_set {
  #     #   # sensitivity_to_block (Optional)
  #     #   # 設定内容: DDoSリクエストルールのブロック感度を指定します。
  #     #   # 設定可能な値: "LOW", "MEDIUM", "HIGH"
  #     #   # 省略時: "LOW"
  #     #   sensitivity_to_block = "LOW"
  #     #
  #     #   # client_side_action_config (Required)
  #     #   # 設定内容: DDoS攻撃時のクライアントサイドアクション設定です。
  #     #   client_side_action_config {
  #     #     # challenge (Required)
  #     #     # 設定内容: ChallengeAllDuringEventおよびChallengeDDoSRequestsルールの設定です。
  #     #     challenge {
  #     #       # usage_of_action (Required)
  #     #       # 設定内容: チャレンジアクションの使用を有効または無効にします。
  #     #       # 設定可能な値: "ENABLED", "DISABLED"
  #     #       usage_of_action = "ENABLED"
  #     #
  #     #       # sensitivity (Optional)
  #     #       # 設定内容: ChallengeDDoSRequestsルールのDDoS疑い判定感度を指定します。
  #     #       # 設定可能な値: "LOW", "MEDIUM", "HIGH"
  #     #       # 省略時: "HIGH"
  #     #       sensitivity = "HIGH"
  #     #
  #     #       # exempt_uri_regular_expression (Optional)
  #     #       # 設定内容: サイレントブラウザチャレンジを処理できないリクエストを識別するためのURI正規表現を指定します。
  #     #       exempt_uri_regular_expression {
  #     #         # regex_string (Optional)
  #     #         # 設定内容: 正規表現文字列を指定します。
  #     #         regex_string = "/api/.*"
  #     #       }
  #     #     }
  #     #   }
  #     # }
  #   }
  # }

  #-------------------------------------------------------------
  # 可視性設定
  #-------------------------------------------------------------

  # visibility_config (Optional)
  # 設定内容: Amazon CloudWatchメトリクスとウェブリクエストのサンプル収集を定義・有効化します。
  # visibility_config {
  #   # cloudwatch_metrics_enabled (Required)
  #   # 設定内容: CloudWatchメトリクスへの送信を有効にするかどうかを指定します。
  #   # 設定可能な値: true, false
  #   # 参考: https://docs.aws.amazon.com/waf/latest/developerguide/monitoring-cloudwatch.html#waf-metrics
  #   cloudwatch_metrics_enabled = true
  #
  #   # metric_name (Required)
  #   # 設定内容: CloudWatchメトリクスの名前を指定します。
  #   # 設定可能な値: 英数字、ハイフン、アンダースコアのみ（1〜128文字）
  #   # 注意: "All"や"Default_Action"などのAWS WAF予約名は使用できません。
  #   metric_name = "my-rule-group-metric"
  #
  #   # sampled_requests_enabled (Required)
  #   # 設定内容: ルールに一致したウェブリクエストのサンプルを保存するかどうかを指定します。
  #   # 設定可能な値: true, false
  #   # 注意: AWS WAFコンソールからサンプルされたリクエストを確認できます。
  #   sampled_requests_enabled = true
  # }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト時間を指定します。
  timeouts {
    # create (Optional)
    # 設定内容: リソース作成時のタイムアウト時間を指定します。
    # 設定可能な値: 時間を表す文字列（例: "30s", "5m", "1h"）
    # 省略時: デフォルトのタイムアウト時間を使用
    create = "5m"

    # update (Optional)
    # 設定内容: リソース更新時のタイムアウト時間を指定します。
    # 設定可能な値: 時間を表す文字列（例: "30s", "5m", "1h"）
    # 省略時: デフォルトのタイムアウト時間を使用
    update = "5m"

    # delete (Optional)
    # 設定内容: リソース削除時のタイムアウト時間を指定します。
    # 設定可能な値: 時間を表す文字列（例: "30s", "5m", "1h"）
    # 省略時: デフォルトのタイムアウト時間を使用
    delete = "5m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: このリソースの内部識別子
#
#---------------------------------------------------------------
