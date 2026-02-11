#---------------------------------------------------------------
# AWS Network Firewall Firewall Policy
#---------------------------------------------------------------
#
# AWS Network Firewallのファイアウォールポリシーをプロビジョニングする。
# ファイアウォールポリシーは、ステートレスおよびステートフルなルールグループと、
# それらのルールにマッチしないパケットに対するデフォルトアクションを定義する。
#
# AWS公式ドキュメント:
#   - Firewall policy settings: https://docs.aws.amazon.com/network-firewall/latest/developerguide/firewall-policy-settings.html
#   - Stateless and stateful rules engines: https://docs.aws.amazon.com/network-firewall/latest/developerguide/firewall-rules-engines.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/networkfirewall_firewall_policy
#
# Provider Version: 6.28.0
# Generated: 2026-01-29
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_networkfirewall_firewall_policy" "this" {
  #---------------------------------------------------------------
  # 基本設定
  #---------------------------------------------------------------

  # name (Required, Forces new resource)
  # ファイアウォールポリシーの名前。
  # 作成後は変更不可。一意な識別子として使用される。
  name = "example-firewall-policy"

  # description (Optional)
  # ファイアウォールポリシーの説明。
  # ポリシーの目的や用途を記述するために使用。
  description = "Example firewall policy for network traffic filtering"

  # region (Optional)
  # このリソースを管理するAWSリージョン。
  # 指定しない場合、プロバイダー設定のリージョンが使用される。
  region = null

  #---------------------------------------------------------------
  # firewall_policy ブロック (Required)
  #---------------------------------------------------------------
  # ファイアウォールポリシーの本体設定。
  # ルールグループの参照とデフォルトアクションを定義する。

  firewall_policy {
    #-------------------------------------------------------------
    # ステートレスルール設定 (Required)
    #-------------------------------------------------------------

    # stateless_default_actions (Required)
    # ステートレスルールにマッチしないパケットに対するデフォルトアクション。
    # 以下のいずれかを指定:
    #   - "aws:pass"          : パケットを通過させる
    #   - "aws:drop"          : パケットを破棄する
    #   - "aws:forward_to_sfe": ステートフル検査エンジンに転送する
    # カスタムアクションも追加可能。
    stateless_default_actions = ["aws:forward_to_sfe"]

    # stateless_fragment_default_actions (Required)
    # フラグメント化されたUDPパケットでステートレスルールにマッチしないものに対するデフォルトアクション。
    # 指定可能な値は stateless_default_actions と同様。
    stateless_fragment_default_actions = ["aws:forward_to_sfe"]

    #-------------------------------------------------------------
    # ステートフルルール設定 (Optional)
    #-------------------------------------------------------------

    # stateful_default_actions (Optional)
    # ステートフルルールにマッチしないパケットに対するデフォルトアクション。
    # stateful_engine_options で rule_order = "STRICT_ORDER" を指定した場合のみ設定可能。
    # 指定可能な値:
    #   - "aws:drop_strict"
    #   - "aws:drop_established"
    #   - "aws:drop_established_app_layer"
    #   - "aws:alert_strict"
    #   - "aws:alert_established"
    #   - "aws:alert_established_app_layer"
    stateful_default_actions = null

    # tls_inspection_configuration_arn (Optional)
    # TLS検査設定のARN。SSL/TLSトラフィックの復号化と再暗号化を行う。
    # 注意: リソース作成時にのみ設定可能。既存のポリシーには追加できない。
    # また、一度設定すると削除もできない。
    tls_inspection_configuration_arn = null

    #-------------------------------------------------------------
    # stateful_engine_options ブロック (Optional)
    #-------------------------------------------------------------
    # ステートフルルールの処理オプションを設定。

    # stateful_engine_options {
    #   # rule_order (Optional)
    #   # ステートフルルールの評価順序。
    #   # 指定可能な値:
    #   #   - "DEFAULT_ACTION_ORDER": アクション設定の順序で処理（pass -> drop -> alert）
    #   #   - "STRICT_ORDER"        : 優先度の順序で処理
    #   # デフォルト: "DEFAULT_ACTION_ORDER"
    #   rule_order = "DEFAULT_ACTION_ORDER"

    #   # stream_exception_policy (Optional)
    #   # ネットワーク接続が中断した場合のトラフィック処理方法。
    #   # 指定可能な値:
    #   #   - "DROP"     : パケットを破棄
    #   #   - "CONTINUE" : 処理を継続
    #   #   - "REJECT"   : 接続を拒否
    #   # デフォルト: "DROP"
    #   stream_exception_policy = "DROP"

    #   # flow_timeouts ブロック (Optional)
    #   # フローのアイドルタイムアウト設定。
    #   # flow_timeouts {
    #   #   # tcp_idle_timeout_seconds (Optional)
    #   #   # TCPトラフィックがない状態でファイアウォールが接続をアイドルと判断するまでの秒数。
    #   #   # アイドルタイムアウト後、データパケットは破棄されるが、
    #   #   # 次のTCP SYNパケットは新しいフローとして処理される。
    #   #   # クライアントまたはターゲットはTCPキープアライブでアイドルタイムアウトをリセット可能。
    #   #   # デフォルト: 350
    #   #   tcp_idle_timeout_seconds = 350
    #   # }
    # }

    #-------------------------------------------------------------
    # policy_variables ブロック (Optional)
    #-------------------------------------------------------------
    # Suricataのデフォルト設定を上書きするための変数を定義。

    # policy_variables {
    #   # rule_variables ブロック (Optional)
    #   # ルール変数を定義。現在は HOME_NET のみサポート。
    #   # rule_variables {
    #   #   # key (Required)
    #   #   # 変数のキー名。現在は "HOME_NET" のみ有効。
    #   #   key = "HOME_NET"

    #   #   # ip_set ブロック (Required)
    #   #   # IPアドレスセットの定義。
    #   #   ip_set {
    #   #     # definition (Required)
    #   #     # CIDR表記のIPv4またはIPv6アドレスのセット。
    #   #     # SuricataのHOME_NET変数として使用される。
    #   #     definition = ["10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16"]
    #   #   }
    #   # }
    # }

    #-------------------------------------------------------------
    # stateful_rule_group_reference ブロック (Optional, Multiple)
    #-------------------------------------------------------------
    # ステートフルルールグループへの参照を定義。
    # 複数のルールグループを参照可能。

    # stateful_rule_group_reference {
    #   # resource_arn (Required)
    #   # ステートフルルールグループのARN。
    #   resource_arn = "arn:aws:network-firewall:us-east-1:123456789012:stateful-rulegroup/example"

    #   # priority (Optional)
    #   # ルールグループの処理優先度（数値が小さいほど優先度が高い）。
    #   # stateful_engine_options で rule_order = "STRICT_ORDER" を指定した場合のみ必須。
    #   priority = 1

    #   # deep_threat_inspection (Optional)
    #   # ディープ脅威検査を有効にするかどうか。
    #   # AWSがサービスログを分析して脅威インジケーターを識別することを許可する。
    #   # Active Threat Defense (ATD) マネージドルールグループにのみ適用。
    #   deep_threat_inspection = null

    #   # override ブロック (Optional)
    #   # ルールグループの動作をオーバーライドする設定。
    #   # override {
    #   #   # action (Optional)
    #   #   # マネージドルールグループのアクションをDROPからALERTに変更する。
    #   #   # マネージドルールグループにのみ適用可能。
    #   #   action = "ALERT_ESTABLISHED"
    #   # }
    # }

    #-------------------------------------------------------------
    # stateless_rule_group_reference ブロック (Optional, Multiple)
    #-------------------------------------------------------------
    # ステートレスルールグループへの参照を定義。
    # 複数のルールグループを参照可能。

    # stateless_rule_group_reference {
    #   # resource_arn (Required)
    #   # ステートレスルールグループのARN。
    #   resource_arn = "arn:aws:network-firewall:us-east-1:123456789012:stateless-rulegroup/example"

    #   # priority (Required)
    #   # ルールグループの処理優先度（数値が小さいほど優先度が高い）。
    #   # Network Firewallは優先度の低い順にルールグループを処理する。
    #   priority = 1
    # }

    #-------------------------------------------------------------
    # stateless_custom_action ブロック (Optional, Multiple)
    #-------------------------------------------------------------
    # ステートレスルールで使用可能なカスタムアクションを定義。
    # CloudWatchメトリクスの発行に使用。

    # stateless_custom_action {
    #   # action_name (Required, Forces new resource)
    #   # カスタムアクションの名前。
    #   # stateless_default_actions で参照するために使用。
    #   action_name = "CustomMetricAction"

    #   # action_definition ブロック (Required)
    #   # カスタムアクションの定義。
    #   action_definition {
    #     # publish_metric_action ブロック (Required)
    #     # CloudWatchメトリクスを発行するアクション。
    #     publish_metric_action {
    #       # dimension ブロック (Required, Multiple)
    #       # CloudWatchカスタムメトリクスのディメンション設定。
    #       dimension {
    #         # value (Required)
    #         # カスタムメトリクスディメンションの値。
    #         value = "blocked-packets"
    #       }
    #     }
    #   }
    # }
  }

  #---------------------------------------------------------------
  # encryption_configuration ブロック (Optional)
  #---------------------------------------------------------------
  # Network Firewallリソースの暗号化設定。
  # AWS管理キーまたはカスタマー管理キーを使用可能。

  # encryption_configuration {
  #   # type (Required)
  #   # 暗号化に使用するKMSキーのタイプ。
  #   # 指定可能な値:
  #   #   - "AWS_OWNED_KMS_KEY" : AWS管理のKMSキーを使用
  #   #   - "CUSTOMER_KMS"      : カスタマー管理のKMSキーを使用
  #   type = "AWS_OWNED_KMS_KEY"

  #   # key_id (Optional)
  #   # カスタマー管理KMSキーのID。
  #   # type = "CUSTOMER_KMS" の場合に必須。
  #   # キーID、キーARN、エイリアスARNのいずれかを指定可能。
  #   # 別のアカウントのキーを使用する場合はARNで指定。
  #   key_id = null
  # }

  #---------------------------------------------------------------
  # タグ設定
  #---------------------------------------------------------------

  # tags (Optional)
  # リソースに付与するタグのマップ。
  # プロバイダーの default_tags で同じキーのタグが設定されている場合、
  # このタグが優先される。
  tags = {
    Name        = "example-firewall-policy"
    Environment = "development"
  }

  # tags_all (Optional/Computed)
  # プロバイダーの default_tags を含む全てのタグ。
  # 通常は直接設定せず、tags と default_tags から自動計算される。
  # tags_all = {}
}

#---------------------------------------------------------------
# Attributes Reference (Computed)
#---------------------------------------------------------------
# 以下の属性はリソース作成後にAWSによって自動的に設定される。
# Terraform設定ファイルでは指定できないが、他のリソースから参照可能。
#
# arn         - ファイアウォールポリシーを識別するAmazon Resource Name (ARN)。
#               例: arn:aws:network-firewall:us-east-1:123456789012:firewall-policy/example
#
# update_token - ファイアウォールポリシー更新時に使用されるトークン文字列。
#               楽観的ロックのために使用され、並行更新を防止する。
