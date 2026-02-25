#---------------------------------------------------------------
# AWS Network Firewall Policy
#---------------------------------------------------------------
#
# AWS Network Firewallのファイアウォールポリシーをプロビジョニングするリソースです。
# ファイアウォールポリシーは、ステートレスおよびステートフルなルールグループの参照と、
# それらのルールグループに対するデフォルトアクションを定義します。
# ファイアウォールポリシーはファイアウォールに関連付けて使用します。
#
# AWS公式ドキュメント:
#   - Network Firewall ポリシー: https://docs.aws.amazon.com/network-firewall/latest/developerguide/firewall-policies.html
#   - AWS Network Firewall 開発者ガイド: https://docs.aws.amazon.com/network-firewall/latest/developerguide/
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/networkfirewall_firewall_policy
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_networkfirewall_firewall_policy" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: ファイアウォールポリシーのフレンドリーな名前を指定します。
  # 設定可能な値: 文字列（英数字、ハイフン、アンダースコア）
  name = "example-firewall-policy"

  # description (Optional)
  # 設定内容: ファイアウォールポリシーのフレンドリーな説明を指定します。
  # 設定可能な値: 文字列
  # 省略時: 説明なし
  description = "Example Network Firewall Policy"

  #-------------------------------------------------------------
  # 暗号化設定
  #-------------------------------------------------------------

  # encryption_configuration (Optional)
  # 設定内容: ファイアウォールポリシーの暗号化設定を指定します。
  # 省略時: AWSマネージドキー（AWS_OWNED_KMS_KEY）を使用して暗号化されます。
  encryption_configuration {
    # key_id (Optional)
    # 設定内容: 暗号化に使用するAWS KMSキーのARNまたはIDを指定します。
    # 設定可能な値: KMSキーのARN、キーID、またはキーエイリアス
    # 省略時: typeがCUSTOMER_KMSの場合は必須。AWS_OWNED_KMS_KEYの場合は不要。
    key_id = null

    # type (Required)
    # 設定内容: 暗号化キーの種類を指定します。
    # 設定可能な値:
    #   - "CUSTOMER_KMS": カスタマーマネージドKMSキーを使用
    #   - "AWS_OWNED_KMS_KEY": AWSが管理するKMSキーを使用（デフォルト）
    type = "AWS_OWNED_KMS_KEY"
  }

  #-------------------------------------------------------------
  # ファイアウォールポリシー設定
  #-------------------------------------------------------------

  # firewall_policy (Required)
  # 設定内容: ファイアウォールのトラフィック処理動作を定義するポリシー本体を指定します。
  # 注意: このブロックは必須で、最大1つまで指定できます。
  firewall_policy {
    # stateless_default_actions (Required)
    # 設定内容: ステートレスルールグループのいずれにもマッチしないパケットへの
    #           デフォルトアクションを指定します。
    # 設定可能な値:
    #   - "aws:pass": パケットを許可してルール評価を終了
    #   - "aws:drop": パケットを破棄
    #   - "aws:forward_to_sfe": ステートフルルールエンジンに転送
    #   カスタムアクション名も指定可能（stateless_custom_actionで定義したもの）
    stateless_default_actions = ["aws:forward_to_sfe"]

    # stateless_fragment_default_actions (Required)
    # 設定内容: フラグメント化されたパケットへのデフォルトアクションを指定します。
    # 設定可能な値: stateless_default_actionsと同様
    # 注意: フラグメントパケットはTCPポートなどの情報を持たないため、
    #       ステートレスルールで評価が難しく、個別の設定が必要です。
    stateless_fragment_default_actions = ["aws:drop"]

    # stateful_default_actions (Optional)
    # 設定内容: ステートフルエンジンがSTRICT_ORDERモードの場合の
    #           デフォルトアクションを指定します。
    # 設定可能な値:
    #   - "aws:drop_strict": マッチしないパケットを全て破棄（推奨）
    #   - "aws:drop_established": 確立済みセッションのみ破棄
    #   - "aws:alert_strict": マッチしないパケットにアラート
    #   - "aws:alert_established": 確立済みセッションにアラート
    # 省略時: ルールグループのデフォルトアクションに従います。
    stateful_default_actions = ["aws:drop_strict"]

    # tls_inspection_configuration_arn (Optional)
    # 設定内容: TLSインスペクションを行う設定のARNを指定します。
    # 設定可能な値: aws_networkfirewall_tls_inspection_configurationリソースのARN
    # 省略時: TLSインスペクションなし
    tls_inspection_configuration_arn = null

    #-----------------------------------------------------------
    # ポリシー変数設定
    #-----------------------------------------------------------

    # policy_variables (Optional)
    # 設定内容: ルールグループで参照できるポリシーレベルの変数を定義します。
    # 省略時: ポリシー変数なし
    policy_variables {
      # rule_variables (Optional)
      # 設定内容: IPセット変数を定義します。ルールグループのSuricataルールから
      #           $HOME_NETなどの変数名で参照できます。
      rule_variables {
        # key (Required)
        # 設定内容: ルール変数の名前を指定します。
        # 設定可能な値: 文字列（例: "HOME_NET", "EXTERNAL_NET"）
        key = "HOME_NET"

        # ip_set (Required)
        # 設定内容: ルール変数が参照するIPセットを指定します。
        ip_set {
          # definition (Required)
          # 設定内容: IPセットのCIDRアドレスリストを指定します。
          # 設定可能な値: CIDR表記のIPアドレス/範囲の集合
          definition = ["10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16"]
        }
      }
    }

    #-----------------------------------------------------------
    # ステートフルエンジンオプション
    #-----------------------------------------------------------

    # stateful_engine_options (Optional)
    # 設定内容: ステートフルルールエンジンの動作オプションを指定します。
    # 省略時: デフォルトの設定でステートフルエンジンが動作します。
    stateful_engine_options {
      # rule_order (Optional)
      # 設定内容: ステートフルルールの評価順序を指定します。
      # 設定可能な値:
      #   - "DEFAULT_ACTION_ORDER": アクション（pass > drop > alert）の順に評価
      #   - "STRICT_ORDER": ルールグループおよびルールの優先度順に評価（推奨）
      # 省略時: DEFAULT_ACTION_ORDER
      rule_order = "STRICT_ORDER"

      # stream_exception_policy (Optional)
      # 設定内容: ストリーム例外（TCPセッション異常）時のポリシーを指定します。
      # 設定可能な値:
      #   - "DROP": 例外パケットを破棄
      #   - "CONTINUE": 評価を継続
      #   - "REJECT": 例外パケットを拒否（RSTを返送）
      # 省略時: DROP
      stream_exception_policy = "DROP"

      # flow_timeouts (Optional)
      # 設定内容: フロータイムアウト設定を指定します。
      # 省略時: デフォルトのタイムアウト値を使用します。
      flow_timeouts {
        # tcp_idle_timeout_seconds (Optional)
        # 設定内容: TCPアイドルセッションのタイムアウト秒数を指定します。
        # 設定可能な値: 60〜6000（秒）
        # 省略時: デフォルト値を使用
        tcp_idle_timeout_seconds = 350
      }
    }

    #-----------------------------------------------------------
    # ステートフルルールグループ参照
    #-----------------------------------------------------------

    # stateful_rule_group_reference (Optional)
    # 設定内容: このポリシーで使用するステートフルルールグループを参照します。
    # 省略時: ステートフルルールグループなし
    # 注意: 複数のブロックを指定して複数のルールグループを参照できます。
    stateful_rule_group_reference {
      # resource_arn (Required)
      # 設定内容: 参照するステートフルルールグループのARNを指定します。
      # 設定可能な値: aws_networkfirewall_rule_groupリソースのARN
      resource_arn = "arn:aws:network-firewall:ap-northeast-1:123456789012:stateful-rulegroup/example-stateful-rule-group"

      # priority (Optional)
      # 設定内容: STRICT_ORDERモード時のルールグループの評価優先度を指定します。
      # 設定可能な値: 1〜65535（数値が小さいほど優先度が高い）
      # 省略時: DEFAULT_ACTION_ORDERモードでは不要
      priority = 100

      # deep_threat_inspection (Optional)
      # 設定内容: 深層脅威検査を有効にするかどうかを指定します。
      # 設定可能な値: "ENABLED", "DISABLED"
      # 省略時: AWSが自動的に判断します。
      deep_threat_inspection = null

      # override (Optional)
      # 設定内容: このルールグループのルールアクションを上書きするための設定です。
      # 省略時: ルールグループのデフォルトアクションを使用します。
      override {
        # action (Optional)
        # 設定内容: ルールグループのすべてのルールアクションを上書きするアクションを指定します。
        # 設定可能な値:
        #   - "DROP_TO_ALERT": DROP/REJECTアクションをALERTに変更（テスト用途）
        # 省略時: ルールグループのアクションを変更しません。
        action = null
      }
    }

    #-----------------------------------------------------------
    # ステートレスルールグループ参照
    #-----------------------------------------------------------

    # stateless_rule_group_reference (Optional)
    # 設定内容: このポリシーで使用するステートレスルールグループを参照します。
    # 省略時: ステートレスルールグループなし
    # 注意: 複数のブロックを指定して複数のルールグループを参照できます。
    stateless_rule_group_reference {
      # resource_arn (Required)
      # 設定内容: 参照するステートレスルールグループのARNを指定します。
      # 設定可能な値: aws_networkfirewall_rule_groupリソースのARN（stateless）
      resource_arn = "arn:aws:network-firewall:ap-northeast-1:123456789012:stateless-rulegroup/example-stateless-rule-group"

      # priority (Required)
      # 設定内容: ルールグループの評価優先度を指定します。
      # 設定可能な値: 1〜65535（数値が小さいほど優先度が高い）
      # 注意: 同じポリシー内でユニークな値を設定する必要があります。
      priority = 10
    }

    #-----------------------------------------------------------
    # カスタムアクション設定
    #-----------------------------------------------------------

    # stateless_custom_action (Optional)
    # 設定内容: ステートレスルールで使用できるカスタムアクションを定義します。
    # 省略時: カスタムアクションなし
    # 注意: カスタムアクション名はstateless_default_actionsなどで参照できます。
    stateless_custom_action {
      # action_name (Required)
      # 設定内容: カスタムアクションの名前を指定します。
      # 設定可能な値: 文字列（英数字、ハイフン、アンダースコア）
      # 注意: aws:プレフィックスは予約済みのため使用不可
      action_name = "ExampleMetricAction"

      # action_definition (Required)
      # 設定内容: カスタムアクションが実行するアクション定義を指定します。
      action_definition {
        # publish_metric_action (Required)
        # 設定内容: CloudWatchメトリクスにカスタムデータを発行する設定です。
        publish_metric_action {
          # dimension (Required)
          # 設定内容: CloudWatchメトリクスに追加するディメンションを指定します。
          # 注意: 1つ以上のdimensionブロックが必要です。
          dimension {
            # value (Required)
            # 設定内容: ディメンションの値を指定します。
            # 設定可能な値: 文字列
            value = "example-dimension"
          }
        }
      }
    }
  }

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
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 省略時: タグなし
  tags = {
    Name        = "example-firewall-policy"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: ファイアウォールポリシーのARN
#
# - arn: ファイアウォールポリシーのAmazon Resource Name (ARN)
#
# - update_token: リソース更新時に使用するトークン。
#                 同時更新の競合を防ぐ楽観的ロックに使用されます。
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
