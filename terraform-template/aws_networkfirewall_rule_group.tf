#---------------------------------------------------------------
# AWS Network Firewall Rule Group
#---------------------------------------------------------------
#
# AWS Network Firewall のルールグループをプロビジョニングするリソースです。
# ルールグループはネットワークトラフィックを検査・処理するための基準セットです。
# ステートレス（パケット単位）とステートフル（フロー単位）の2種類があります。
# ステートフルルールグループはSuricata互換のIPS仕様を利用します。
#
# AWS公式ドキュメント:
#   - ルールグループの管理: https://docs.aws.amazon.com/network-firewall/latest/developerguide/rule-groups.html
#   - ステートフルルールグループ: https://docs.aws.amazon.com/network-firewall/latest/developerguide/stateful-rule-groups-ips.html
#   - ステートレス・ステートフルエンジン: https://docs.aws.amazon.com/network-firewall/latest/developerguide/firewall-rules-engines.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/networkfirewall_rule_group
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_networkfirewall_rule_group" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required, Forces new resource)
  # 設定内容: ルールグループのフレンドリーな名前を指定します。
  # 設定可能な値: 英数字、ハイフン、アンダースコアを含む文字列
  name = "example-rule-group"

  # type (Required)
  # 設定内容: ルールグループがステートレスかステートフルかを指定します。
  # 設定可能な値:
  #   - "STATEFUL": ステートフルルール（トラフィックフロー単位で検査）
  #   - "STATELESS": ステートレスルール（パケット単位で検査）
  # 参考: https://docs.aws.amazon.com/network-firewall/latest/developerguide/firewall-rules-engines.html
  type = "STATEFUL"

  # capacity (Required, Forces new resource)
  # 設定内容: このルールグループが使用できる最大リソース数を指定します。
  # 設定可能な値:
  #   - ステートレスルールグループ: 個々のルールのキャパシティ要件の合計
  #   - ステートフルルールグループ: 個々のルール数の最小値
  # 注意: 作成後は変更できません。適切な値を事前に見積もる必要があります。
  capacity = 100

  # description (Optional)
  # 設定内容: ルールグループのフレンドリーな説明を指定します。
  # 設定可能な値: 文字列
  description = "Example stateful rule group"

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # Suricataルール文字列設定
  #-------------------------------------------------------------

  # rules (Optional)
  # 設定内容: Suricataフォーマットのステートフルルールグループルール仕様を指定します。
  #           1行に1つのルールを記述します。既存のSuricata互換ルールグループをインポートする際に使用します。
  # 設定可能な値: Suricata互換のルール文字列（複数行）
  # 注意: rule_group ブロックと排他的です。どちらか一方のみ指定可能です。
  # 参考: https://docs.aws.amazon.com/network-firewall/latest/developerguide/stateful-rule-groups-ips.html
  rules = null

  #-------------------------------------------------------------
  # 暗号化設定
  #-------------------------------------------------------------

  # encryption_configuration (Optional)
  # 設定内容: Network Firewallリソースの暗号化設定ブロックです。
  # 参考: https://docs.aws.amazon.com/network-firewall/latest/developerguide/encryption-at-rest.html
  encryption_configuration {

    # type (Required)
    # 設定内容: Network Firewallリソースの暗号化に使用するAWS KMSキーのタイプを指定します。
    # 設定可能な値:
    #   - "CUSTOMER_KMS": カスタマーマネージドキーを使用
    #   - "AWS_OWNED_KMS_KEY": AWS所有のKMSキーを使用
    type = "AWS_OWNED_KMS_KEY"

    # key_id (Optional)
    # 設定内容: カスタマーマネージドキーのIDを指定します。
    # 設定可能な値: KMSがサポートするキー識別子（キーID、キーARN、エイリアス名、エイリアスARN）
    # 注意: 別アカウントが管理するキーを使用する場合はキーARNを指定してください。
    #       type = "CUSTOMER_KMS" の場合のみ有効です。
    # key_id = "arn:aws:kms:ap-northeast-1:123456789012:key/12345678-1234-1234-1234-123456789012"
  }

  #-------------------------------------------------------------
  # ルールグループ設定
  #-------------------------------------------------------------

  # rule_group (Optional)
  # 設定内容: ルールグループのルールを定義する設定ブロックです。
  #           rules を指定しない場合は必須です。
  # 注意: rules ブロックと排他的です。どちらか一方のみ指定可能です。
  rule_group {

    #-------------------------------------------------------------
    # ルール変数設定
    #-------------------------------------------------------------

    # rule_variables (Optional)
    # 設定内容: ルールグループ内のルールで使用可能な追加設定を定義するブロックです。
    #           ステートフルルールグループにのみ指定可能です。
    rule_variables {

      # ip_sets (Optional)
      # 設定内容: IPアドレス情報を定義する設定ブロックのセットです。
      ip_sets {

        # key (Required)
        # 設定内容: ip_set を識別する一意の英数字文字列を指定します。
        # 設定可能な値: 英数字文字列
        key = "WEBSERVERS_HOSTS"

        # ip_set (Required)
        # 設定内容: IPアドレスのセットを定義するブロックです。
        ip_set {

          # definition (Required)
          # 設定内容: CIDR表記のIPアドレスおよびアドレス範囲のセットを指定します。
          # 設定可能な値: CIDR表記のIPアドレス文字列のセット
          definition = ["10.0.0.0/16", "192.168.0.0/16"]
        }
      }

      # port_sets (Optional)
      # 設定内容: ポート範囲情報を定義する設定ブロックのセットです。
      port_sets {

        # key (Required)
        # 設定内容: port_set を識別する一意の英数字文字列を指定します。
        # 設定可能な値: 英数字文字列
        key = "HTTP_PORTS"

        # port_set (Required)
        # 設定内容: ポート範囲のセットを定義するブロックです。
        port_set {

          # definition (Required)
          # 設定内容: ポート範囲のセットを指定します。
          # 設定可能な値: ポート番号または範囲（例: "443", "80", "1024:65535"）の文字列セット
          definition = ["443", "80"]
        }
      }
    }

    #-------------------------------------------------------------
    # 参照セット設定
    #-------------------------------------------------------------

    # reference_sets (Optional)
    # 設定内容: ルールグループのIPセット参照を定義する設定ブロックです。
    # 注意: reference_sets は最大5つまで指定可能です。
    # 参考: https://docs.aws.amazon.com/network-firewall/latest/developerguide/rule-groups-ip-set-references.html
    reference_sets {

      # ip_set_references (Optional)
      # 設定内容: IPセット参照情報を定義するブロックのセットです。最大5つまで指定可能です。
      ip_set_references {

        # key (Required)
        # 設定内容: ip_set_reference を識別する一意の英数字文字列を指定します。
        # 設定可能な値: 英数字文字列
        key = "example_ip_set"

        # ip_set_reference (Optional)
        # 設定内容: IP参照情報を定義するブロックです。
        ip_set_reference {

          # reference_arn (Required)
          # 設定内容: マネージドプレフィックスIPのARNのセットを指定します。
          # 設定可能な値: EC2マネージドプレフィックスリストのARN
          reference_arn = "arn:aws:ec2:ap-northeast-1:123456789012:prefix-list/pl-12345678"
        }
      }
    }

    #-------------------------------------------------------------
    # ルールソース設定
    #-------------------------------------------------------------

    # rules_source (Required)
    # 設定内容: ルールグループのステートフルまたはステートレスルールを定義するブロックです。
    rules_source {

      # rules_string (Optional)
      # 設定内容: Suricata互換形式のステートフル検査基準を指定します。
      #           これらのルールには検査基準とトラフィックが基準に一致した場合のアクションが含まれます。
      # 設定可能な値: Suricata互換のルール文字列
      # 注意: rules_source_list、stateful_rule と組み合わせることはできません。
      # rules_string = file("suricata_rules_file")

      #-------------------------------------------------------------
      # ドメインリストルールソース設定（ステートフル専用）
      #-------------------------------------------------------------

      # rules_source_list (Optional)
      # 設定内容: ドメインリストルールグループのステートフル検査基準を定義するブロックです。
      # 参考: https://docs.aws.amazon.com/network-firewall/latest/developerguide/stateful-rule-group-options.html
      rules_source_list {

        # generated_rules_type (Required)
        # 設定内容: ターゲットリスト内のドメインへのアクセスを許可するか拒否するかを指定します。
        # 設定可能な値:
        #   - "ALLOWLIST": 許可リスト（リスト内のドメインへのアクセスを許可）
        #   - "DENYLIST": 拒否リスト（リスト内のドメインへのアクセスを拒否）
        generated_rules_type = "DENYLIST"

        # target_types (Required)
        # 設定内容: targets 引数で提供されるドメイン仕様のタイプのセットを指定します。
        # 設定可能な値:
        #   - "HTTP_HOST": HTTPホストヘッダーを検査
        #   - "TLS_SNI": TLS SNI（Server Name Indication）を検査
        target_types = ["HTTP_HOST", "TLS_SNI"]

        # targets (Required)
        # 設定内容: トラフィックフローで検査するドメインのセットを指定します。
        # 設定可能な値: ドメイン名の文字列セット（例: "test.example.com", ".example.com"）
        targets = ["test.example.com"]
      }

      #-------------------------------------------------------------
      # ステートフルルール設定
      #-------------------------------------------------------------

      # stateful_rule (Optional)
      # 設定内容: ルールグループで使用するステートフル5タプルルールの設定ブロックのセットです。
      # 参考: https://docs.aws.amazon.com/network-firewall/latest/developerguide/stateful-rule-groups-basic.html
      stateful_rule {

        # action (Required)
        # 設定内容: ステートフルルール基準にフローが一致した場合にパケットに対して実行するアクションを指定します。
        # 設定可能な値:
        #   - "ALERT": アラートを生成してパケットを通過させます
        #   - "DROP": パケットを破棄します
        #   - "PASS": パケットを通過させます
        #   - "REJECT": パケットを拒否します（TCPのRSTパケットを送信）
        action = "DROP"

        # header (Required)
        # 設定内容: ルールのステートフル5タプル検査基準を含む設定ブロックです。
        header {

          # protocol (Required)
          # 設定内容: 検査するプロトコルを指定します。
          # 設定可能な値:
          #   IP, TCP, UDP, ICMP, HTTP, FTP, TLS, SMB, DNS, DCERPC,
          #   SSH, SMTP, IMAP, MSN, KRB5, IKEV2, TFTP, NTP, DHCP
          protocol = "TCP"

          # source (Required)
          # 設定内容: 検査する送信元IPアドレスまたはアドレス範囲をCIDR表記で指定します。
          # 設定可能な値: CIDR表記のIPアドレスまたは "ANY"（任意のアドレスに一致）
          source = "1.2.3.4/32"

          # source_port (Required)
          # 設定内容: 検査する送信元ポートを指定します。
          # 設定可能な値: ポート番号の文字列または "ANY"（任意のポートに一致）
          source_port = "ANY"

          # destination (Required)
          # 設定内容: 検査する宛先IPアドレスまたはアドレス範囲をCIDR表記で指定します。
          # 設定可能な値: CIDR表記のIPアドレスまたは "ANY"（任意のアドレスに一致）
          destination = "124.1.1.24/32"

          # destination_port (Required)
          # 設定内容: 検査する宛先ポートを指定します。
          # 設定可能な値: ポート番号の文字列または "ANY"（任意のポートに一致）
          destination_port = "443"

          # direction (Required)
          # 設定内容: 検査するトラフィックフローの方向を指定します。
          # 設定可能な値:
          #   - "ANY": 双方向のトラフィックを検査
          #   - "FORWARD": 順方向（送信元から宛先）のトラフィックのみ検査
          direction = "ANY"
        }

        # rule_option (Required)
        # 設定内容: ステートフルルールの追加設定を含む設定ブロックのセットです。
        # 参考: https://docs.aws.amazon.com/network-firewall/latest/developerguide/stateful-rule-groups-basic.html
        rule_option {

          # keyword (Required)
          # 設定内容: Snort/SuricataなどのオープンソースIPS検出システムで定義されたキーワードを指定します。
          # 設定可能な値: Suricataルールキーワード（例: "sid", "rev", "msg"）
          # 参考: https://suricata.readthedocs.io/en/suricata-5.0.1/rules/intro.html#rule-options
          keyword = "sid"

          # settings (Optional)
          # 設定内容: ステートフルルール検査で使用する追加設定の文字列セットを指定します。
          # 設定可能な値: 文字列のセット
          settings = ["1"]
        }
      }

      #-------------------------------------------------------------
      # ステートレスルールとカスタムアクション設定
      #-------------------------------------------------------------

      # stateless_rules_and_custom_actions (Optional)
      # 設定内容: ステートレスルールグループのステートレス検査基準を定義するブロックです。
      # 注意: type = "STATELESS" の場合に使用します。
      stateless_rules_and_custom_actions {

        # custom_action (Optional)
        # 設定内容: stateless_rule セットで使用可能なカスタムアクション定義の設定ブロックのセットです。
        custom_action {

          # action_name (Required, Forces new resource)
          # 設定内容: カスタムアクションのフレンドリーな名前を指定します。
          # 設定可能な値: 英数字とアンダースコアを含む文字列
          action_name = "ExampleMetricsAction"

          # action_definition (Required)
          # 設定内容: action_name に関連付けるカスタムアクションを記述するブロックです。
          action_definition {

            # publish_metric_action (Required)
            # 設定内容: 一致したパケットに対してAmazon CloudWatchに指定のメトリクスを公開するステートレス検査基準です。
            publish_metric_action {

              # dimension (Required)
              # 設定内容: Amazon CloudWatchカスタムメトリクスに使用するディメンション設定ブロックのセットです。
              dimension {

                # value (Required)
                # 設定内容: カスタムメトリクスディメンションで使用する値を指定します。
                # 設定可能な値: 文字列
                value = "2"
              }
            }
          }
        }

        # stateless_rule (Required)
        # 設定内容: ステートレスルールグループで使用するステートレスルールの設定ブロックのセットです。
        stateless_rule {

          # priority (Required)
          # 設定内容: ステートレスルールグループ内の全ルールに対してこのルールを実行する順序を指定します。
          # 設定可能な値: 正の整数。数値が小さいほど優先度が高くなります。
          # 注意: AWS Network Firewallは最小の優先度設定からルールを評価します。
          priority = 1

          # rule_definition (Required)
          # 設定内容: ステートレス5タプルパケット検査基準とパケットが基準に一致した場合のアクションを定義するブロックです。
          rule_definition {

            # actions (Required)
            # 設定内容: ステートレスルール定義の match_attributes に一致するパケットに対して実行するアクションのセットです。
            # 設定可能な値:
            #   標準アクション（必ず1つ指定）:
            #   - "aws:pass": パケットを通過させます
            #   - "aws:drop": パケットを破棄します
            #   - "aws:forward_to_sfe": ステートフルルールエンジンにパケットを転送します
            #   カスタムアクション: custom_action で定義したアクション名も指定可能
            actions = ["aws:pass", "ExampleMetricsAction"]

            # match_attributes (Required)
            # 設定内容: AWS Network Firewallがステートレスルール検査で個々のパケットを検査するための基準ブロックです。
            match_attributes {

              # protocols (Optional)
              # 設定内容: 検査するプロトコルのセットをIANA割り当てのインターネットプロトコル番号で指定します。
              # 設定可能な値: IANAプロトコル番号のセット（例: 6 = TCP, 17 = UDP, 1 = ICMP）
              # 省略時: 任意のプロトコルに一致します。
              protocols = [6]

              # source (Optional)
              # 設定内容: 検査する送信元IPアドレスおよびアドレス範囲をCIDR表記で記述する設定ブロックのセットです。
              # 省略時: 任意の送信元アドレスに一致します。
              source {

                # address_definition (Required)
                # 設定内容: CIDR表記のIPアドレスまたはブロックを指定します。IPv4・IPv6の全アドレス範囲をサポートします。
                # 設定可能な値: CIDR表記のIPアドレス文字列
                address_definition = "1.2.3.4/32"
              }

              # source_port (Optional)
              # 設定内容: 検査する送信元ポートを記述する設定ブロックのセットです。
              # 省略時: 任意の送信元ポートに一致します。
              source_port {

                # from_port (Required)
                # 設定内容: ポート範囲の下限を指定します。to_port 以下である必要があります。
                # 設定可能な値: 0〜65535 のポート番号
                from_port = 443

                # to_port (Optional)
                # 設定内容: ポート範囲の上限を指定します。from_port 以上である必要があります。
                # 設定可能な値: 0〜65535 のポート番号
                # 省略時: from_port と同じ値（単一ポートを指定）
                to_port = 443
              }

              # destination (Optional)
              # 設定内容: 検査する宛先IPアドレスおよびアドレス範囲をCIDR表記で記述する設定ブロックのセットです。
              # 省略時: 任意の宛先アドレスに一致します。
              destination {

                # address_definition (Required)
                # 設定内容: CIDR表記のIPアドレスまたはブロックを指定します。IPv4・IPv6の全アドレス範囲をサポートします。
                # 設定可能な値: CIDR表記のIPアドレス文字列
                address_definition = "124.1.1.5/32"
              }

              # destination_port (Optional)
              # 設定内容: 検査する宛先ポートを記述する設定ブロックのセットです。
              # 省略時: 任意の宛先ポートに一致します。
              destination_port {

                # from_port (Required)
                # 設定内容: ポート範囲の下限を指定します。to_port 以下である必要があります。
                # 設定可能な値: 0〜65535 のポート番号
                from_port = 443

                # to_port (Optional)
                # 設定内容: ポート範囲の上限を指定します。from_port 以上である必要があります。
                # 設定可能な値: 0〜65535 のポート番号
                # 省略時: from_port と同じ値（単一ポートを指定）
                to_port = 443
              }

              # tcp_flag (Optional)
              # 設定内容: 検査するTCPフラグとマスクを含む設定ブロックのセットです。
              # 省略時: 任意の設定に一致します。
              tcp_flag {

                # flags (Required)
                # 設定内容: パケット内で検索するフラグのセットを指定します。masks にも指定されている値のみ設定可能です。
                # 設定可能な値: "FIN", "SYN", "RST", "PSH", "ACK", "URG", "ECE", "CWR"
                flags = ["SYN"]

                # masks (Optional)
                # 設定内容: 検査で考慮するフラグのセットを指定します。空にすると全フラグを検査します。
                # 設定可能な値: "FIN", "SYN", "RST", "PSH", "ACK", "URG", "ECE", "CWR"
                masks = ["SYN", "ACK"]
              }
            }
          }
        }
      }
    }

    #-------------------------------------------------------------
    # ステートフルルールオプション設定
    #-------------------------------------------------------------

    # stateful_rule_options (Optional)
    # 設定内容: ルールグループのステートフルルールオプションを定義するブロックです。
    # 参考: https://docs.aws.amazon.com/network-firewall/latest/developerguide/stateful-rule-groups-ips.html
    stateful_rule_options {

      # rule_order (Required)
      # 設定内容: ルールグループのルール評価順序を管理する方法を指定します。
      # 設定可能な値:
      #   - "DEFAULT_ACTION_ORDER": アクション設定の順序でルールを評価（デフォルト）
      #                              pass → drop → alert の順に処理されます
      #   - "STRICT_ORDER": ルールに割り当てた優先度の順序でルールを評価します
      # 注意: この設定はルールグループ作成時のみ指定可能で、後から変更できません。
      rule_order = "DEFAULT_ACTION_ORDER"
    }
  }

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 参考: プロバイダーレベルの default_tags 設定ブロックで定義されたタグと
  #       一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "example-rule-group"
    Environment = "production"
    ManagedBy   = "terraform"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: ルールグループを識別するAmazon Resource Name (ARN)
# - arn: ルールグループのAmazon Resource Name (ARN)
# - update_token: ルールグループを更新する際に使用する文字列トークン
# - tags_all: プロバイダーの default_tags 設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
