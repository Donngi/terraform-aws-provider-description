#---------------------------------------------------------------
# AWS Network Firewall TLS Inspection Configuration
#---------------------------------------------------------------
#
# AWS Network Firewall の TLS インスペクション設定をプロビジョニングします。
# TLS インスペクションにより、SSL/TLS で暗号化されたトラフィックを復号化し、
# ファイアウォールルールによる検査を行った後、再暗号化して宛先に転送します。
#
# 主なユースケース:
#   - インバウンドトラフィック検査: サーバー証明書を使用した受信 SSL/TLS トラフィックの検査
#   - アウトバウンドトラフィック検査: CA 証明書を使用した送信 SSL/TLS トラフィックの検査
#   - 双方向検査: インバウンドとアウトバウンドの両方を検査
#
# 前提条件:
#   - AWS Certificate Manager (ACM) に SSL/TLS 証明書がインポート済みであること
#   - インバウンド検査: ACM にサーバー証明書をインポート
#   - アウトバウンド検査: ACM に CA 証明書をインポート
#
# AWS公式ドキュメント:
#   - TLS inspection configurations: https://docs.aws.amazon.com/network-firewall/latest/developerguide/tls-inspection-configurations.html
#   - TLS inspection configuration settings: https://docs.aws.amazon.com/network-firewall/latest/developerguide/tls-inspection-settings.html
#   - Creating a TLS inspection configuration: https://docs.aws.amazon.com/network-firewall/latest/developerguide/creating-tls-configuration.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/networkfirewall_tls_inspection_configuration
#
# Provider Version: 6.28.0
# Generated: 2026-01-29
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_networkfirewall_tls_inspection_configuration" "example" {

  #---------------------------------------------------------------
  # 基本設定
  #---------------------------------------------------------------

  # name (Required, Forces new resource)
  # TLS インスペクション設定の名前。
  # リソースの識別に使用される一意の名前を指定します。
  # 変更すると新しいリソースが作成されます（強制的な再作成）。
  name = "example-tls-inspection-config"

  # description (Optional)
  # TLS インスペクション設定の説明。
  # 設定の目的や用途を記述します。
  description = "Example TLS inspection configuration"

  # region (Optional)
  # このリソースを管理するリージョン。
  # 指定しない場合は、プロバイダー設定のリージョンが使用されます。
  # 参照: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "ap-northeast-1"

  # tags (Optional)
  # リソースに付与するタグのマップ。
  # リソースの検索、フィルタリング、コスト追跡に使用します。
  tags = {
    Environment = "production"
    Project     = "example"
  }

  #---------------------------------------------------------------
  # encryption_configuration
  #---------------------------------------------------------------
  # 保管時の暗号化設定。
  # TLS インスペクション設定に関連するデータの暗号化に使用する KMS キーを指定します。
  # 省略した場合、AWS 所有のキーが使用されます。
  #
  # 型: list(object)
  # - key_id: KMS キーの ARN（CUSTOMER_KMS の場合に必須）
  # - type: 暗号化タイプ（AWS_OWNED_KMS_KEY または CUSTOMER_KMS）

  encryption_configuration {
    # key_id (Optional)
    # AWS Key Management Service (KMS) のカスタマーマネージドキーの ARN。
    # type が "CUSTOMER_KMS" の場合に指定が必要です。
    # type が "AWS_OWNED_KMS_KEY" の場合は "AWS_OWNED_KMS_KEY" を指定します。
    key_id = "AWS_OWNED_KMS_KEY"

    # type (Optional)
    # Network Firewall リソースの暗号化に使用する KMS キーのタイプ。
    # 有効な値:
    #   - "AWS_OWNED_KMS_KEY": AWS が所有・管理するキーを使用（デフォルト）
    #   - "CUSTOMER_KMS": カスタマーマネージドキーを使用
    type = "AWS_OWNED_KMS_KEY"
  }

  #---------------------------------------------------------------
  # tls_inspection_configuration
  #---------------------------------------------------------------
  # TLS インスペクションの実際の設定を定義するブロック。
  # server_certificate_configuration で検査対象のトラフィックと
  # 使用する証明書を指定します。

  tls_inspection_configuration {

    #---------------------------------------------------------------
    # server_certificate_configuration
    #---------------------------------------------------------------
    # サーバー証明書の設定ブロック。
    # TLS インスペクションで使用する証明書とトラフィックのスコープを定義します。
    # 複数の設定を指定可能です。

    server_certificate_configuration {

      # certificate_authority_arn (Optional)
      # アウトバウンド SSL/TLS インスペクションに使用する CA 証明書の ARN。
      # Certificate Manager (ACM) にインポートされた CA 証明書を指定します。
      # アウトバウンドトラフィックを検査する場合に必要です。
      # 参照: https://docs.aws.amazon.com/network-firewall/latest/developerguide/tls-inspection-certificate-requirements.html
      # certificate_authority_arn = "arn:aws:acm:ap-northeast-1:123456789012:certificate/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"

      #---------------------------------------------------------------
      # server_certificate
      #---------------------------------------------------------------
      # インバウンド SSL/TLS インスペクションに使用するサーバー証明書の設定。
      # ACM にインポートされた SSL/TLS サーバー証明書を指定します。
      # インバウンドトラフィックを検査する場合に必要です。
      # 複数のサーバー証明書を指定可能です。

      server_certificate {
        # resource_arn (Optional)
        # インバウンド SSL/TLS インスペクションに使用する
        # Certificate Manager SSL/TLS サーバー証明書の ARN。
        resource_arn = "arn:aws:acm:ap-northeast-1:123456789012:certificate/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
      }

      #---------------------------------------------------------------
      # check_certificate_revocation_status
      #---------------------------------------------------------------
      # 証明書失効ステータスのチェック設定。
      # アウトバウンドトラフィックに対する証明書の失効状態をチェックし、
      # 失効または不明な状態の場合のアクションを定義します。

      # check_certificate_revocation_status {
      #   # revoked_status_action (Optional)
      #   # SSL/TLS 証明書が失効している場合に取るアクション。
      #   # 有効な値:
      #   #   - "PASS": トラフィックを許可
      #   #   - "DROP": トラフィックをドロップ
      #   #   - "REJECT": トラフィックを拒否し、TCP RST を送信
      #   revoked_status_action = "REJECT"
      #
      #   # unknown_status_action (Optional)
      #   # SSL/TLS 証明書の失効状態が不明な場合に取るアクション。
      #   # 有効な値:
      #   #   - "PASS": トラフィックを許可
      #   #   - "DROP": トラフィックをドロップ
      #   #   - "REJECT": トラフィックを拒否し、TCP RST を送信
      #   unknown_status_action = "PASS"
      # }

      #---------------------------------------------------------------
      # scope
      #---------------------------------------------------------------
      # TLS インスペクションの対象となるトラフィックの範囲を定義します。
      # 送信元/宛先の IP アドレス、ポート、プロトコルを指定します。
      # 複数の scope ブロックを指定可能です。

      scope {
        # protocols (Required)
        # 検査対象のプロトコルのセット。
        # IANA プロトコル番号で指定します。
        # 現在、Network Firewall は TCP のみをサポートしています。
        # 有効な値: 6 (TCP)
        protocols = [6]

        #---------------------------------------------------------------
        # source
        #---------------------------------------------------------------
        # 検査対象の送信元 IP アドレスとアドレス範囲の設定。
        # CIDR 表記で指定します。
        # 複数の source ブロックを指定可能です。
        # 指定しない場合、すべての送信元アドレスが対象となります。

        source {
          # address_definition (Required)
          # IP アドレスまたは IP アドレスブロック（CIDR 表記）。
          # AWS Network Firewall は IPv4 のすべてのアドレス範囲をサポートします。
          # 例: "10.0.0.0/8", "192.168.1.0/24", "0.0.0.0/0"（すべて）
          address_definition = "0.0.0.0/0"
        }

        #---------------------------------------------------------------
        # source_ports
        #---------------------------------------------------------------
        # 検査対象の送信元ポートの設定。
        # ポート範囲を指定します。
        # 複数の source_ports ブロックを指定可能です。
        # 指定しない場合、すべての送信元ポートが対象となります。

        source_ports {
          # from_port (Required)
          # ポート範囲の下限。
          # to_port 以下の値である必要があります。
          from_port = 0

          # to_port (Required)
          # ポート範囲の上限。
          # from_port 以上の値である必要があります。
          to_port = 65535
        }

        #---------------------------------------------------------------
        # destination
        #---------------------------------------------------------------
        # 検査対象の宛先 IP アドレスとアドレス範囲の設定。
        # CIDR 表記で指定します。
        # 複数の destination ブロックを指定可能です。
        # 指定しない場合、すべての宛先アドレスが対象となります。

        destination {
          # address_definition (Required)
          # IP アドレスまたは IP アドレスブロック（CIDR 表記）。
          # AWS Network Firewall は IPv4 のすべてのアドレス範囲をサポートします。
          # 例: "10.0.0.0/8", "192.168.1.0/24", "0.0.0.0/0"（すべて）
          address_definition = "0.0.0.0/0"
        }

        #---------------------------------------------------------------
        # destination_ports
        #---------------------------------------------------------------
        # 検査対象の宛先ポートの設定。
        # ポート範囲を指定します。
        # 複数の destination_ports ブロックを指定可能です。
        # 指定しない場合、すべての宛先ポートが対象となります。

        destination_ports {
          # from_port (Required)
          # ポート範囲の下限。
          # to_port 以下の値である必要があります。
          from_port = 443

          # to_port (Required)
          # ポート範囲の上限。
          # from_port 以上の値である必要があります。
          to_port = 443
        }
      }
    }
  }

  #---------------------------------------------------------------
  # timeouts
  #---------------------------------------------------------------
  # リソース操作のタイムアウト設定。
  # 各操作の最大待機時間を指定します。
  # 時間は "30s", "5m", "2h45m" のような形式で指定します。

  # timeouts {
  #   # create (Optional)
  #   # リソース作成のタイムアウト。
  #   # デフォルト値はプロバイダーによって設定されます。
  #   create = "30m"
  #
  #   # update (Optional)
  #   # リソース更新のタイムアウト。
  #   # デフォルト値はプロバイダーによって設定されます。
  #   update = "30m"
  #
  #   # delete (Optional)
  #   # リソース削除のタイムアウト。
  #   # デフォルト値はプロバイダーによって設定されます。
  #   delete = "30m"
  # }
}

#---------------------------------------------------------------
# Attributes Reference (参照専用属性)
#---------------------------------------------------------------
# 以下の属性はリソース作成後に参照可能ですが、
# Terraform 設定で直接指定することはできません（computed only）。
#
# - arn
#     TLS インスペクション設定の ARN。
#     形式: arn:aws:network-firewall:<region>:<account-id>:tls-configuration/<name>
#
# - id
#     リソースの識別子（ARN と同じ）。
#
# - certificate_authority
#     証明書認証局の情報（list of object）。
#     - certificate_arn: CA 証明書の ARN
#     - certificate_serial: 証明書のシリアル番号
#     - status: 証明書のステータス
#     - status_message: ステータスの詳細メッセージ
#
# - certificates
#     関連付けられた証明書のリスト（list of object）。
#     - certificate_arn: 証明書の ARN
#     - certificate_serial: 証明書のシリアル番号
#     - status: 証明書のステータス
#     - status_message: ステータスの詳細メッセージ
#
# - number_of_associations
#     この TLS インスペクション設定を使用しているファイアウォールポリシーの数。
#
# - tags_all
#     デフォルトタグを含む、リソースに適用されたすべてのタグのマップ。
#
# - tls_inspection_configuration_id
#     TLS インスペクション設定の一意識別子。
#
# - update_token
#     リソース更新時に使用されるトークン。
#     同時更新を防ぐための楽観的ロックに使用されます。

#---------------------------------------------------------------
# 使用例
#---------------------------------------------------------------

# 例1: インバウンド（受信）トラフィック検査
# サーバー証明書を使用して、外部からサーバーへの HTTPS トラフィックを検査
#
# resource "aws_networkfirewall_tls_inspection_configuration" "inbound" {
#   name        = "inbound-inspection"
#   description = "Inbound TLS inspection"
#
#   encryption_configuration {
#     key_id = "AWS_OWNED_KMS_KEY"
#     type   = "AWS_OWNED_KMS_KEY"
#   }
#
#   tls_inspection_configuration {
#     server_certificate_configuration {
#       server_certificate {
#         resource_arn = aws_acm_certificate.server.arn
#       }
#       scope {
#         protocols = [6]
#         source {
#           address_definition = "0.0.0.0/0"
#         }
#         source_ports {
#           from_port = 0
#           to_port   = 65535
#         }
#         destination {
#           address_definition = "10.0.0.0/8"
#         }
#         destination_ports {
#           from_port = 443
#           to_port   = 443
#         }
#       }
#     }
#   }
# }

# 例2: アウトバウンド（送信）トラフィック検査
# CA 証明書を使用して、内部からインターネットへの HTTPS トラフィックを検査
#
# resource "aws_networkfirewall_tls_inspection_configuration" "outbound" {
#   name        = "outbound-inspection"
#   description = "Outbound TLS inspection"
#
#   encryption_configuration {
#     key_id = "AWS_OWNED_KMS_KEY"
#     type   = "AWS_OWNED_KMS_KEY"
#   }
#
#   tls_inspection_configuration {
#     server_certificate_configuration {
#       certificate_authority_arn = aws_acm_certificate.ca.arn
#       check_certificate_revocation_status {
#         revoked_status_action = "REJECT"
#         unknown_status_action = "PASS"
#       }
#       scope {
#         protocols = [6]
#         source {
#           address_definition = "10.0.0.0/8"
#         }
#         source_ports {
#           from_port = 0
#           to_port   = 65535
#         }
#         destination {
#           address_definition = "0.0.0.0/0"
#         }
#         destination_ports {
#           from_port = 443
#           to_port   = 443
#         }
#       }
#     }
#   }
# }

# 例3: カスタマーマネージド KMS キーを使用した暗号化
#
# resource "aws_kms_key" "firewall" {
#   description             = "KMS key for Network Firewall TLS inspection"
#   deletion_window_in_days = 7
# }
#
# resource "aws_networkfirewall_tls_inspection_configuration" "encrypted" {
#   name        = "encrypted-inspection"
#   description = "TLS inspection with customer managed key"
#
#   encryption_configuration {
#     key_id = aws_kms_key.firewall.arn
#     type   = "CUSTOMER_KMS"
#   }
#
#   tls_inspection_configuration {
#     server_certificate_configuration {
#       server_certificate {
#         resource_arn = aws_acm_certificate.server.arn
#       }
#       scope {
#         protocols = [6]
#         source {
#           address_definition = "0.0.0.0/0"
#         }
#         source_ports {
#           from_port = 0
#           to_port   = 65535
#         }
#         destination {
#           address_definition = "0.0.0.0/0"
#         }
#         destination_ports {
#           from_port = 443
#           to_port   = 443
#         }
#       }
#     }
#   }
# }
