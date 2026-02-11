#---------------------------------------------------------------
# AWS Network Firewall Rule Group
#---------------------------------------------------------------
#
# AWS Network Firewallのルールグループを作成します。
# ルールグループは、ネットワークトラフィックを検査・制御するための
# 再利用可能なルールセットです。ステートレスまたはステートフルの
# ルールグループを定義でき、ファイアウォールポリシーに追加して使用します。
#
# ステートレスルール: パケットを個別に評価（コンテキストなし）
# ステートフルルール: トラフィックフローのコンテキストでパケットを評価
#   - 標準ステートフルルール: 5-tuple形式でルールを定義
#   - ドメインリスト: ドメイン名のリストでフィルタリング
#   - Suricata互換: Suricata形式のルール文字列を使用
#
# AWS公式ドキュメント:
#   - Rule Groups: https://docs.aws.amazon.com/network-firewall/latest/developerguide/rule-groups.html
#   - Creating Stateful Rule Groups: https://docs.aws.amazon.com/network-firewall/latest/developerguide/rule-group-stateful-creating.html
#   - API Reference (RuleGroup): https://docs.aws.amazon.com/network-firewall/latest/APIReference/API_RuleGroup.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/networkfirewall_rule_group
#
# Provider Version: 6.28.0
# Generated: 2026-01-29
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_networkfirewall_rule_group" "example" {
  #---------------------------------------------------------------
  # 基本設定 (Top-level Attributes)
  #---------------------------------------------------------------

  # (Required) ルールグループの名前。
  # ルールグループを識別するための一意の名前を指定します。
  # リソース作成後の変更は新しいリソースを作成します (Forces new resource)。
  name = "example-rule-group"

  # (Required) ルールグループのタイプ。
  # - "STATEFUL": ステートフルルールグループ（トラフィックフローのコンテキストで評価）
  # - "STATELESS": ステートレスルールグループ（パケットを個別に評価）
  type = "STATEFUL"

  # (Required) ルールグループの最大容量。
  # - ステートレスルールグループ: 個々のルールの容量要件の合計
  # - ステートフルルールグループ: 個々のルールの数（最小値）
  # 一度設定すると変更できません (Forces new resource)。
  capacity = 100

  # (Optional) ルールグループの説明。
  # ルールグループの目的や用途を記述します。
  description = "Example rule group for demonstration"

  # (Optional) ステートフルルールをSuricata互換フォーマットで直接指定。
  # 1行に1つのルールを記述します。既存のSuricataルールをインポートする際に使用。
  # rule_groupブロックと同時には指定できません（どちらか一方を指定）。
  # 例: file("example.rules")
  # rules = null

  # (Optional) リソースを管理するAWSリージョン。
  # 指定しない場合、プロバイダー設定のリージョンが使用されます。
  # region = "ap-northeast-1"

  # (Optional) リソースに関連付けるタグ。
  # Key-Valueペアでリソースを整理・識別するためのメタデータを設定します。
  # プロバイダーレベルのdefault_tagsと組み合わせて使用できます。
  tags = {
    Name        = "example-rule-group"
    Environment = "production"
  }

  #---------------------------------------------------------------
  # KMS暗号化設定 (encryption_configuration)
  #---------------------------------------------------------------
  # (Optional) ルールグループのKMS暗号化設定。
  # Network Firewallリソースの暗号化にカスタマーマネージドキーを使用できます。
  encryption_configuration {
    # (Required) 暗号化タイプ。
    # - "AWS_OWNED_KMS_KEY": AWS管理のKMSキーを使用（デフォルト）
    # - "CUSTOMER_KMS": カスタマーマネージドKMSキーを使用
    type = "AWS_OWNED_KMS_KEY"

    # (Optional) カスタマーマネージドKMSキーのID。
    # type = "CUSTOMER_KMS" の場合に必要です。
    # キーID、キーARN、エイリアス名、エイリアスARNを指定できます。
    # 別アカウントのキーを使用する場合はキーARNを指定してください。
    # key_id = "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"
  }

  #---------------------------------------------------------------
  # ルールグループ設定 (rule_group)
  #---------------------------------------------------------------
  # (Optional) ルールグループのルール定義。
  # rulesパラメータと同時には指定できません（どちらか一方を指定）。
  rule_group {

    #-------------------------------------------------------------
    # 参照セット (reference_sets)
    #-------------------------------------------------------------
    # (Optional) IPセット参照の設定。
    # マネージドプレフィックスリストなど外部のIPセットを参照できます。
    # 最大5つのip_set_referencesを設定可能。
    # reference_sets {
    #   # (Optional) IPセット参照の設定。
    #   ip_set_references {
    #     # (Required) IPセット参照を識別するキー。
    #     # ルール内でこのキーを使用してIPセットを参照します。
    #     key = "EXTERNAL_IPS"
    #
    #     # (Required) IPセット参照の詳細設定。
    #     ip_set_reference {
    #       # (Required) 参照するマネージドプレフィックスリストのARN。
    #       reference_arn = "arn:aws:ec2:us-east-1:123456789012:prefix-list/pl-12345678"
    #     }
    #   }
    # }

    #-------------------------------------------------------------
    # ルール変数 (rule_variables)
    #-------------------------------------------------------------
    # (Optional) ステートフルルールグループで使用する変数定義。
    # IPアドレスやポートの変数を定義し、ルール内で参照できます。
    # ステートフルルールグループでのみ使用可能。
    rule_variables {
      # (Optional) IPセット変数の定義。
      # 複数のip_setsブロックを定義可能。
      ip_sets {
        # (Required) IPセットを識別するキー。
        # ルール内で$キー名として参照します（例: $HOME_NET）。
        key = "HOME_NET"

        # (Required) IPアドレスの定義。
        ip_set {
          # (Required) IPアドレスまたはCIDR形式のアドレス範囲のセット。
          definition = ["10.0.0.0/16", "192.168.0.0/16"]
        }
      }

      ip_sets {
        key = "EXTERNAL_NET"

        ip_set {
          definition = ["0.0.0.0/0"]
        }
      }

      # (Optional) ポートセット変数の定義。
      # 複数のport_setsブロックを定義可能。
      port_sets {
        # (Required) ポートセットを識別するキー。
        # ルール内で$キー名として参照します（例: $HTTP_PORTS）。
        key = "HTTP_PORTS"

        # (Required) ポート範囲の定義。
        port_set {
          # (Required) ポート番号またはポート範囲のセット。
          # 単一ポート: "80"、範囲: "1024:65535"
          definition = ["80", "443", "8080"]
        }
      }
    }

    #-------------------------------------------------------------
    # ルールソース (rules_source) - 必須
    #-------------------------------------------------------------
    # (Required) ルールの検査条件と動作を定義。
    # 以下のいずれか1つを指定:
    # - rules_source_list: ドメインリストルール（ステートフル）
    # - stateful_rule: 5-tupleルール（ステートフル）
    # - rules_string: Suricata形式のルール文字列（ステートフル）
    # - stateless_rules_and_custom_actions: ステートレスルール
    rules_source {
      #-----------------------------------------------------------
      # オプション1: Suricataルール文字列 (rules_string)
      #-----------------------------------------------------------
      # (Optional) Suricata互換形式のステートフル検査ルール。
      # ルールには検査条件とアクションが含まれるため、
      # 別途アクション設定は不要です。
      # rules_string = <<EOF
      # alert tcp $HOME_NET any -> $EXTERNAL_NET 443 (msg:"HTTPS traffic"; sid:1; rev:1;)
      # drop tcp any any -> any 23 (msg:"Block Telnet"; sid:2; rev:1;)
      # EOF

      #-----------------------------------------------------------
      # オプション2: ドメインリスト (rules_source_list)
      #-----------------------------------------------------------
      # (Optional) ドメインリストによるステートフル検査ルール。
      # 特定のドメインへのアクセスを許可または拒否します。
      rules_source_list {
        # (Required) ルールのタイプ。
        # - "ALLOWLIST": targetsに指定したドメインへのアクセスを許可
        # - "DENYLIST": targetsに指定したドメインへのアクセスを拒否
        generated_rules_type = "DENYLIST"

        # (Required) 検査対象のプロトコルタイプ。
        # - "HTTP_HOST": HTTP Hostヘッダーを検査
        # - "TLS_SNI": TLS Server Name Indication (SNI)を検査
        target_types = ["HTTP_HOST", "TLS_SNI"]

        # (Required) 検査対象のドメイン名のセット。
        # ワイルドカード（*.example.com）も使用可能。
        targets = ["malicious.example.com", "*.bad-domain.com"]
      }

      #-----------------------------------------------------------
      # オプション3: ステートフルルール (stateful_rule)
      #-----------------------------------------------------------
      # (Optional) 5-tuple形式のステートフル検査ルール。
      # 複数のstateful_ruleブロックを定義可能。
      # stateful_rule {
      #   # (Required) ルールに一致したパケットに対するアクション。
      #   # - "ALERT": アラートを生成して通過を許可
      #   # - "DROP": パケットを破棄
      #   # - "PASS": パケットを通過させる
      #   # - "REJECT": パケットを拒否（TCP RSTまたはICMP unreachableを送信）
      #   action = "DROP"
      #
      #   # (Required) 5-tuple検査条件の定義。
      #   header {
      #     # (Required) 検査対象の宛先IPアドレスまたはCIDR。
      #     # 任意のアドレスに一致させる場合は "ANY" を指定。
      #     destination = "ANY"
      #
      #     # (Required) 検査対象の宛先ポート。
      #     # 任意のポートに一致させる場合は "ANY" を指定。
      #     # 範囲指定も可能: "1024:65535"
      #     destination_port = "443"
      #
      #     # (Required) 検査対象のトラフィック方向。
      #     # - "ANY": 双方向
      #     # - "FORWARD": ソースから宛先への方向のみ
      #     direction = "ANY"
      #
      #     # (Required) 検査対象のプロトコル。
      #     # 有効な値: IP, TCP, UDP, ICMP, HTTP, FTP, TLS, SMB, DNS,
      #     #           DCERPC, SSH, SMTP, IMAP, MSN, KRB5, IKEV2, TFTP, NTP, DHCP
      #     protocol = "TCP"
      #
      #     # (Required) 検査対象のソースIPアドレスまたはCIDR。
      #     # 任意のアドレスに一致させる場合は "ANY" を指定。
      #     source = "10.0.0.0/16"
      #
      #     # (Required) 検査対象のソースポート。
      #     # 任意のポートに一致させる場合は "ANY" を指定。
      #     source_port = "ANY"
      #   }
      #
      #   # (Required) ルールの追加オプション設定。
      #   # Snort/Suricataのルールオプションを指定します。
      #   # 最低1つのrule_optionが必要です（通常はsidを指定）。
      #   rule_option {
      #     # (Required) ルールオプションのキーワード。
      #     # Snort/Suricataで定義されたキーワードを使用。
      #     # 例: sid, rev, msg, content, flowなど
      #     keyword = "sid"
      #
      #     # (Optional) キーワードの設定値。
      #     # キーワードによって必要な値が異なります。
      #     settings = ["1"]
      #   }
      # }

      #-----------------------------------------------------------
      # オプション4: ステートレスルール (stateless_rules_and_custom_actions)
      #-----------------------------------------------------------
      # (Optional) ステートレスルールとカスタムアクションの定義。
      # type = "STATELESS" の場合にのみ使用。
      # stateless_rules_and_custom_actions {
      #
      #   # (Optional) カスタムアクションの定義。
      #   # CloudWatchメトリクスを発行するカスタムアクションを定義します。
      #   custom_action {
      #     # (Required) カスタムアクションの名前。
      #     # stateless_ruleのactionsで参照します。
      #     action_name = "ExampleCustomAction"
      #
      #     # (Required) カスタムアクションの定義。
      #     action_definition {
      #       # (Required) CloudWatchメトリクス発行アクション。
      #       publish_metric_action {
      #         # (Required) メトリクスのディメンション設定。
      #         # 最低1つのdimensionが必要です。
      #         dimension {
      #           # (Required) ディメンションの値。
      #           # CloudWatchメトリクスのディメンションとして使用されます。
      #           value = "CustomDimension"
      #         }
      #       }
      #     }
      #   }
      #
      #   # (Required) ステートレスルールの定義。
      #   # 最低1つのstateless_ruleが必要です。
      #   stateless_rule {
      #     # (Required) ルールの優先度。
      #     # 数値が小さいほど先に評価されます。
      #     # 同じ優先度を持つルール間の評価順序は未定義です。
      #     priority = 1
      #
      #     # (Required) ルールの定義。
      #     rule_definition {
      #       # (Required) 一致したパケットに対するアクション。
      #       # 標準アクション（1つ必須）:
      #       # - "aws:pass": パケットを通過
      #       # - "aws:drop": パケットを破棄
      #       # - "aws:forward_to_sfe": ステートフルルールエンジンに転送
      #       # カスタムアクションも追加可能。
      #       actions = ["aws:pass", "ExampleCustomAction"]
      #
      #       # (Required) パケットの検査条件。
      #       match_attributes {
      #         # (Optional) 検査対象のプロトコル（IANAプロトコル番号）。
      #         # 例: 6 = TCP, 17 = UDP, 1 = ICMP
      #         # 指定しない場合は全プロトコルに一致。
      #         protocols = [6]
      #
      #         # (Optional) 宛先IPアドレスの検査条件。
      #         # 指定しない場合は任意の宛先に一致。
      #         destination {
      #           # (Required) IPアドレスまたはCIDR形式のアドレス範囲。
      #           # IPv4とIPv6の両方をサポート。
      #           address_definition = "10.0.0.0/8"
      #         }
      #
      #         # (Optional) 宛先ポートの検査条件。
      #         # 指定しない場合は任意のポートに一致。
      #         destination_port {
      #           # (Required) ポート範囲の下限。
      #           # to_port以下の値を指定。
      #           from_port = 443
      #
      #           # (Optional) ポート範囲の上限。
      #           # from_port以上の値を指定。
      #           # 単一ポートの場合はfrom_portと同じ値を指定。
      #           to_port = 443
      #         }
      #
      #         # (Optional) ソースIPアドレスの検査条件。
      #         # 指定しない場合は任意のソースに一致。
      #         source {
      #           # (Required) IPアドレスまたはCIDR形式のアドレス範囲。
      #           address_definition = "192.168.0.0/16"
      #         }
      #
      #         # (Optional) ソースポートの検査条件。
      #         # 指定しない場合は任意のポートに一致。
      #         source_port {
      #           # (Required) ポート範囲の下限。
      #           from_port = 1024
      #
      #           # (Optional) ポート範囲の上限。
      #           to_port = 65535
      #         }
      #
      #         # (Optional) TCPフラグの検査条件。
      #         # TCP以外のプロトコルでは無視されます。
      #         tcp_flag {
      #           # (Required) 検査対象のTCPフラグ。
      #           # masksで指定したフラグのサブセットである必要があります。
      #           # 有効な値: FIN, SYN, RST, PSH, ACK, URG, ECE, CWR
      #           flags = ["SYN"]
      #
      #           # (Optional) 検査対象とするフラグのマスク。
      #           # 空の場合は全フラグを検査対象とします。
      #           # 有効な値: FIN, SYN, RST, PSH, ACK, URG, ECE, CWR
      #           masks = ["SYN", "ACK"]
      #         }
      #       }
      #     }
      #   }
      # }
    }

    #-------------------------------------------------------------
    # ステートフルルールオプション (stateful_rule_options)
    #-------------------------------------------------------------
    # (Optional) ステートフルルールの追加オプション。
    # ステートフルルールグループでのみ使用可能。
    stateful_rule_options {
      # (Required) ルールの評価順序。
      # - "DEFAULT_ACTION_ORDER": デフォルトのアクション順序
      #   (PASS, DROP, ALERT の順で評価)
      # - "STRICT_ORDER": 厳密な順序で評価
      #   (ルールが定義された順序で評価)
      rule_order = "DEFAULT_ACTION_ORDER"
    }
  }
}

#---------------------------------------------------------------
# Attributes Reference (参照専用属性)
#---------------------------------------------------------------
# リソース作成後に以下の属性が利用可能になります（設定不可）:
#
# arn        - ルールグループを識別するAmazon Resource Name (ARN)。
#              ファイアウォールポリシーでルールグループを参照する際に使用。
#
# id         - ルールグループのARN（arnと同じ値）。
#
# tags_all   - プロバイダーレベルのdefault_tagsを含む全てのタグ。
#
# update_token - ルールグループの更新トークン。
#                ルールグループを更新する際の楽観的ロックに使用。
