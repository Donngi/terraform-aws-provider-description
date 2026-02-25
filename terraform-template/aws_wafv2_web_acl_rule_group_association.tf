#---------------------------------------------------------------
# AWS WAFv2 Web ACL ルールグループ関連付け
#---------------------------------------------------------------
#
# AWS WAFv2 Web ACLにルールグループ（カスタムまたはマネージド）を
# 関連付けるためのリソースです。
# Web ACLに対してルールグループを参照するルールを追加することで、
# 既存のWeb ACLを変更せずにルールグループを適用できます。
# カスタムルールグループとAWS Marketplaceマネージドルールグループの
# 両方に対応しています。
#
# AWS公式ドキュメント:
#   - AWS WAF ルールグループ: https://docs.aws.amazon.com/waf/latest/developerguide/waf-rule-groups.html
#   - マネージドルールグループ: https://docs.aws.amazon.com/waf/latest/developerguide/waf-managed-rule-groups.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_web_acl_rule_group_association
#
# Provider Version: 6.28.0
# Generated: 2026-02-19
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
    # 最大100件まで指定可能です。
    rule_action_override {
      # name (Required)
      # 設定内容: 上書き対象のルール名を指定します。
      # 設定可能な値: ルールグループ内の有効なルール名
      name = "my-rule-to-override"

      # action_to_use (Required)
      # 設定内容: 代わりに使用するアクションを指定します。
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
        block {
          # custom_response (Optional)
          # 設定内容: ブロック時にクライアントへ返すカスタムHTTPレスポンスを指定します。
          custom_response {
            # response_code (Required)
            # 設定内容: クライアントへ返すHTTPステータスコードを指定します。
            # 設定可能な値: 200〜600の整数
            response_code = 403

            # custom_response_body_key (Optional)
            # 設定内容: Web ACLに定義されたカスタムレスポンスボディのキーを指定します。
            # 省略時: カスタムレスポンスボディを使用しない
            custom_response_body_key = null

            # response_header (Optional)
            # 設定内容: レスポンスに追加するカスタムHTTPヘッダーを指定します。
            response_header {
              # name (Required)
              # 設定内容: 追加するHTTPヘッダーの名前を指定します。
              name = "x-blocked-by"

              # value (Required)
              # 設定内容: 追加するHTTPヘッダーの値を指定します。
              value = "waf"
            }
          }
        }

        # captcha (Optional)
        # 設定内容: CAPTCHAチャレンジを要求するアクションを指定します。
        captcha {
          # custom_request_handling (Optional)
          # 設定内容: CAPTCHA成功時にリクエストに追加するカスタムHTTPヘッダーを指定します。
          custom_request_handling {
            insert_header {
              name  = "x-captcha-result"
              value = "passed"
            }
          }
        }

        # challenge (Optional)
        # 設定内容: JavaScriptチャレンジを要求するアクションを指定します。
        challenge {
          # custom_request_handling (Optional)
          # 設定内容: チャレンジ成功時にリクエストに追加するカスタムHTTPヘッダーを指定します。
          custom_request_handling {
            insert_header {
              name  = "x-challenge-result"
              value = "passed"
            }
          }
        }

        # count (Optional)
        # 設定内容: リクエストをカウントのみするアクションを指定します。
        count {
          # custom_request_handling (Optional)
          # 設定内容: カウント時にリクエストに追加するカスタムHTTPヘッダーを指定します。
          custom_request_handling {
            insert_header {
              name  = "x-counted-by"
              value = "waf"
            }
          }
        }
      }
    }
  }

  #-------------------------------------------------------------
  # マネージドルールグループ設定
  #-------------------------------------------------------------

  # managed_rule_group (Optional)
  # 設定内容: AWSマネージドルールグループへの参照を指定します。
  # 注意: rule_group_referenceとmanaged_rule_groupのどちらか一方のみ指定可能です。
  managed_rule_group {
    # name (Required)
    # 設定内容: マネージドルールグループの名前を指定します。
    # 設定可能な値: 有効なマネージドルールグループ名（例: AWSManagedRulesCommonRuleSet）
    name = "AWSManagedRulesCommonRuleSet"

    # vendor_name (Required)
    # 設定内容: マネージドルールグループのベンダー名を指定します。
    # 設定可能な値: "AWS"（AWS管理のルールグループ）または AWS Marketplaceのベンダー名
    vendor_name = "AWS"

    # version (Optional)
    # 設定内容: 使用するマネージドルールグループのバージョンを指定します。
    # 省略時: デフォルトバージョンを使用
    version = null

    # rule_action_override (Optional)
    # 設定内容: マネージドルールグループ内の特定ルールのアクションを上書きする設定です。
    # 最大100件まで指定可能です。
    rule_action_override {
      # name (Required)
      # 設定内容: 上書き対象のルール名を指定します。
      # 設定可能な値: マネージドルールグループ内の有効なルール名
      name = "SizeRestrictions_BODY"

      # action_to_use (Required)
      # 設定内容: 代わりに使用するアクションを指定します。
      action_to_use {
        # count (Optional)
        # 設定内容: リクエストをカウントのみするアクションを指定します。
        count {
          # custom_request_handling (Optional)
          # 設定内容: カウント時にリクエストに追加するカスタムHTTPヘッダーを指定します。
          custom_request_handling {
            insert_header {
              name  = "x-overridden-rule"
              value = "SizeRestrictions_BODY"
            }
          }
        }
      }
    }
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト時間を指定します。
  timeouts {
    # create (Optional)
    # 設定内容: リソース作成時のタイムアウト時間を指定します。
    # 設定可能な値: 時間を表す文字列（例: "5m", "10m", "1h"）
    # 省略時: デフォルトのタイムアウト時間を使用
    create = "5m"

    # update (Optional)
    # 設定内容: リソース更新時のタイムアウト時間を指定します。
    # 設定可能な値: 時間を表す文字列（例: "5m", "10m", "1h"）
    # 省略時: デフォルトのタイムアウト時間を使用
    update = "5m"

    # delete (Optional)
    # 設定内容: リソース削除時のタイムアウト時間を指定します。
    # 設定可能な値: 時間を表す文字列（例: "5m", "10m", "1h"）
    # 省略時: デフォルトのタイムアウト時間を使用
    delete = "5m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: このリソースのID（内部的な識別子）
#
#---------------------------------------------------------------
