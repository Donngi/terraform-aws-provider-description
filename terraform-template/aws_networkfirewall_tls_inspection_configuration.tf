#---------------------------------------------------------------
# AWS Network Firewall TLS Inspection Configuration
#---------------------------------------------------------------
#
# AWS Network FirewallのTLS検査設定をプロビジョニングするリソースです。
# TLS検査設定を使用することで、Network FirewallはSSL/TLSトラフィックを
# 復号して検査し、ファイアウォールポリシーのステートフルルールを適用した後、
# 再暗号化して宛先に転送します。
# インバウンド（受信）、アウトバウンド（送信）、またはその両方の
# TLSトラフィックの検査を有効化できます。
#
# AWS公式ドキュメント:
#   - TLS検査設定の概要: https://docs.aws.amazon.com/network-firewall/latest/developerguide/tls-inspection-configurations.html
#   - TLS検査設定の作成: https://docs.aws.amazon.com/network-firewall/latest/developerguide/creating-tls-configuration.html
#   - SSL/TLS証明書の要件: https://docs.aws.amazon.com/network-firewall/latest/developerguide/tls-inspection-certificate-requirements.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/networkfirewall_tls_inspection_configuration
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_networkfirewall_tls_inspection_configuration" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required, Forces new resource)
  # 設定内容: TLS検査設定の名前を指定します。
  # 設定可能な値: 1-128文字の英数字、ハイフン、アンダースコア
  name = "example-tls-inspection"

  # description (Optional)
  # 設定内容: TLS検査設定の説明を指定します。
  # 設定可能な値: 最大512文字の文字列
  # 省略時: 説明なし
  description = "TLS検査設定の説明"

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
  # 暗号化設定
  #-------------------------------------------------------------

  # encryption_configuration (Optional)
  # 設定内容: TLS検査設定の保存時暗号化に使用するKMSキーの設定ブロックです。
  # 省略時: AWSマネージドKMSキー（AWS_OWNED_KMS_KEY）を使用
  # 関連機能: Network Firewall 保存時暗号化
  #   AWS KMSを使用してNetwork Firewallリソースを暗号化。
  #   - https://docs.aws.amazon.com/network-firewall/latest/developerguide/tls-inspection-settings.html
  encryption_configuration {

    # type (Optional)
    # 設定内容: 暗号化に使用するKMSキーの種類を指定します。
    # 設定可能な値:
    #   - "AWS_OWNED_KMS_KEY": AWSが管理するKMSキーを使用（デフォルト）
    #   - "CUSTOMER_KMS": カスタマーマネージドキー（CMK）を使用
    # 省略時: "AWS_OWNED_KMS_KEY"
    type = "AWS_OWNED_KMS_KEY"

    # key_id (Optional)
    # 設定内容: カスタマーマネージドキー（CMK）のARNを指定します。
    # 設定可能な値: 有効なKMSキーARN
    # 注意: type = "CUSTOMER_KMS" の場合に指定が必要
    # 省略時: type = "AWS_OWNED_KMS_KEY" の場合は "AWS_OWNED_KMS_KEY" を指定
    key_id = "AWS_OWNED_KMS_KEY"
  }

  #-------------------------------------------------------------
  # TLS検査設定
  #-------------------------------------------------------------

  # tls_inspection_configuration (Required)
  # 設定内容: TLS検査の詳細設定ブロックです。
  # サーバー証明書の設定とトラフィックのスコープを定義します。
  # 関連機能: Network Firewall TLS検査
  #   SSL/TLSトラフィックを復号して検査し、再暗号化して転送します。
  #   - https://docs.aws.amazon.com/network-firewall/latest/developerguide/tls-inspection-configurations.html
  tls_inspection_configuration {

    # server_certificate_configuration (Required)
    # 設定内容: TLS設定に関連付けるサーバー証明書の設定ブロックです。
    # インバウンド検査、アウトバウンド検査、または両方の設定が可能です。
    server_certificate_configuration {

      # certificate_authority_arn (Optional)
      # 設定内容: アウトバウンドSSL/TLS検査に使用するACMのCA証明書ARNを指定します。
      # 設定可能な値: ACMにインポートされたCA証明書の有効なARN
      # 省略時: アウトバウンド検査を行わない場合は省略可能
      # 注意: アウトバウンドSSL/TLS検査を行う場合に指定。CA証明書の制限事項については
      #       公式ドキュメントを参照してください。
      # 参考: https://docs.aws.amazon.com/network-firewall/latest/developerguide/tls-inspection-certificate-requirements.html
      certificate_authority_arn = "arn:aws:acm:ap-northeast-1:123456789012:certificate/12345678-1234-1234-1234-123456789012"

      #-----------------------------------------------------------
      # 証明書失効ステータス確認設定
      #-----------------------------------------------------------

      # check_certificate_revocation_status (Optional)
      # 設定内容: アウトバウンドトラフィックの証明書失効ステータス確認の設定ブロックです。
      # 省略時: 証明書失効ステータスの確認を行わない
      # 注意: アウトバウンドSSL/TLS検査（certificate_authority_arn指定時）でのみ有効
      # 参考: https://docs.aws.amazon.com/network-firewall/latest/developerguide/tls-inspection-certificate-requirements.html
      check_certificate_revocation_status {

        # revoked_status_action (Optional)
        # 設定内容: 失効した証明書のトラフィックに対するアクションを指定します。
        # 設定可能な値:
        #   - "PASS": 失効した証明書のトラフィックをそのまま通過させる
        #   - "DROP": 失効した証明書のトラフィックをドロップする
        #   - "REJECT": 失効した証明書のトラフィックを拒否してTCPリセットを送信する
        # 省略時: アクションなし
        revoked_status_action = "REJECT"

        # unknown_status_action (Optional)
        # 設定内容: 失効ステータスが不明な証明書のトラフィックに対するアクションを指定します。
        # 設定可能な値:
        #   - "PASS": 不明な証明書のトラフィックをそのまま通過させる
        #   - "DROP": 不明な証明書のトラフィックをドロップする
        #   - "REJECT": 不明な証明書のトラフィックを拒否してTCPリセットを送信する
        # 省略時: アクションなし
        unknown_status_action = "PASS"
      }

      #-----------------------------------------------------------
      # サーバー証明書設定（インバウンド検査用）
      #-----------------------------------------------------------

      # server_certificate (Optional)
      # 設定内容: インバウンドSSL/TLS検査に使用するACMサーバー証明書のARNを指定します。
      # 複数の server_certificate ブロックを指定可能です。
      # 省略時: インバウンド検査を行わない場合は省略可能
      # 参考: https://docs.aws.amazon.com/network-firewall/latest/developerguide/tls-inspection-certificate-requirements.html
      server_certificate {

        # resource_arn (Optional)
        # 設定内容: インバウンドSSL/TLS検査用のACMサーバー証明書ARNを指定します。
        # 設定可能な値: ACMの有効なサーバー証明書ARN
        resource_arn = "arn:aws:acm:ap-northeast-1:123456789012:certificate/87654321-4321-4321-4321-210987654321"
      }

      #-----------------------------------------------------------
      # スコープ設定
      #-----------------------------------------------------------

      # scope (Required)
      # 設定内容: 検査対象のトラフィックスコープ（送受信アドレス・ポート）の設定ブロックです。
      # 複数の scope ブロックを指定可能です。
      # 関連機能: Network Firewall TLS検査スコープ
      #   復号・検査するトラフィックの範囲をCIDR表記のIPアドレスとポート範囲で定義します。
      #   - https://docs.aws.amazon.com/network-firewall/latest/developerguide/tls-inspection-settings.html
      scope {

        # protocols (Required)
        # 設定内容: 検査対象のプロトコルをIANAプロトコル番号のセットで指定します。
        # 設定可能な値:
        #   - 6: TCP（現在Network FirewallはTCPのみサポート）
        protocols = [6]

        # destination (Required)
        # 設定内容: 検査対象の宛先IPアドレスまたはアドレス範囲をCIDR表記で指定します。
        # 複数の destination ブロックを指定可能です。
        # 省略時: すべての宛先アドレスにマッチ
        destination {

          # address_definition (Required)
          # 設定内容: CIDRブロック形式のIPアドレスまたはアドレス範囲を指定します。
          # 設定可能な値: IPv4のすべてのアドレス範囲（CIDR表記）
          # 例: "0.0.0.0/0"（すべて）、"10.0.0.0/8"（プライベートネットワーク）
          address_definition = "0.0.0.0/0"
        }

        # destination_ports (Optional)
        # 設定内容: 検査対象の宛先ポート範囲の設定ブロックです。
        # 複数の destination_ports ブロックを指定可能です。
        # 省略時: すべての宛先ポートにマッチ
        destination_ports {

          # from_port (Required)
          # 設定内容: ポート範囲の下限を指定します。
          # 設定可能な値: 0-65535の整数。to_port以下の値を指定
          from_port = 443

          # to_port (Required)
          # 設定内容: ポート範囲の上限を指定します。
          # 設定可能な値: 0-65535の整数。from_port以上の値を指定
          to_port = 443
        }

        # source (Optional)
        # 設定内容: 検査対象の送信元IPアドレスまたはアドレス範囲をCIDR表記で指定します。
        # 複数の source ブロックを指定可能です。
        # 省略時: すべての送信元アドレスにマッチ
        source {

          # address_definition (Required)
          # 設定内容: CIDRブロック形式のIPアドレスまたはアドレス範囲を指定します。
          # 設定可能な値: IPv4のすべてのアドレス範囲（CIDR表記）
          address_definition = "0.0.0.0/0"
        }

        # source_ports (Optional)
        # 設定内容: 検査対象の送信元ポート範囲の設定ブロックです。
        # 複数の source_ports ブロックを指定可能です。
        # 省略時: すべての送信元ポートにマッチ
        source_ports {

          # from_port (Required)
          # 設定内容: ポート範囲の下限を指定します。
          # 設定可能な値: 0-65535の整数。to_port以下の値を指定
          from_port = 0

          # to_port (Required)
          # 設定内容: ポート範囲の上限を指定します。
          # 設定可能な値: 0-65535の整数。from_port以上の値を指定
          to_port = 65535
        }
      }
    }
  }

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 省略時: タグなし
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "example-tls-inspection"
    Environment = "production"
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト時間を設定するブロックです。
  timeouts {

    # create (Optional)
    # 設定内容: リソース作成操作のタイムアウト時間を指定します。
    # 設定可能な値: "30s", "5m", "2h" などの時間文字列（s: 秒, m: 分, h: 時間）
    # 省略時: プロバイダーのデフォルトタイムアウトを使用
    create = "30m"

    # update (Optional)
    # 設定内容: リソース更新操作のタイムアウト時間を指定します。
    # 設定可能な値: "30s", "5m", "2h" などの時間文字列（s: 秒, m: 分, h: 時間）
    # 省略時: プロバイダーのデフォルトタイムアウトを使用
    update = "30m"

    # delete (Optional)
    # 設定内容: リソース削除操作のタイムアウト時間を指定します。
    # 設定可能な値: "30s", "5m", "2h" などの時間文字列（s: 秒, m: 分, h: 時間）
    # 省略時: プロバイダーのデフォルトタイムアウトを使用
    delete = "30m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: TLS検査設定のARN
# - tls_inspection_configuration_id: TLS検査設定の一意の識別子
# - update_token: リソース更新時に使用するトークン文字列
# - number_of_associations: この設定を使用しているファイアウォールポリシーの数
# - certificate_authority: CA証明書の情報ブロック（certificate_arn, certificate_serial,
#                          status, status_message）
# - certificates: TLS検査設定に関連付けられた証明書情報のリスト
#                 （certificate_arn, certificate_serial, status, status_message）
# - id: TLS検査設定のARN（arnと同一）
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
