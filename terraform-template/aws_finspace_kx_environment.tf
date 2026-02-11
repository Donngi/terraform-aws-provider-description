#---------------------------------------------------------------
# AWS FinSpace Kx Environment
#---------------------------------------------------------------
#
# Amazon FinSpaceのManaged kdb Insights環境をプロビジョニングするリソースです。
# Managed kdb環境は、kdbクラスターの起動と実行、および関連データの保存を行う
# 論理的なコンテナです。すべてのリソースはAWSマネージドアカウントで実行され、
# 顧客アカウントには配置されません。
#
# 重要: Amazon FinSpaceは2025年10月7日以降新規顧客の受付を終了し、
#       2026年10月7日にサービスを完全に終了します。
#
# AWS公式ドキュメント:
#   - Managed kdb Insights環境: https://docs.aws.amazon.com/finspace/latest/userguide/finspace-managed-kdb-environment.html
#   - FinSpace概要: https://docs.aws.amazon.com/finspace/latest/userguide/finspace-what-is.html
#   - CreateKxEnvironment API: https://docs.aws.amazon.com/finspace/latest/management-api/API_CreateKxEnvironment.html
#   - データ暗号化: https://docs.aws.amazon.com/finspace/latest/userguide/data-encryption.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/finspace_kx_environment
#
# Provider Version: 6.28.0
# Generated: 2026-01-27
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_finspace_kx_environment" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: 作成するKx環境の名前を指定します。
  # 設定可能な値: 文字列
  # 用途: 環境を識別するための一意の名前
  name = "my-kx-environment"

  # description (Optional)
  # 設定内容: Kx環境の説明を指定します。
  # 設定可能な値: 文字列
  # 用途: 環境の目的や用途を記述
  description = "Production kdb environment for trading analytics"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional, Computed)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # 暗号化設定
  #-------------------------------------------------------------

  # kms_key_id (Required)
  # 設定内容: FinSpace環境内のデータを暗号化するためのKMSキーIDを指定します。
  # 設定可能な値: KMSキーのARN
  # 関連機能: データ保管時の暗号化
  #   Amazon FinSpaceは、AWS KMSの顧客所有キーを使用してデータを暗号化します。
  #   環境作成時に指定したKMSキーで、環境内のすべてのデータとメタデータが暗号化されます。
  #   - https://docs.aws.amazon.com/finspace/latest/userguide/data-encryption.html
  kms_key_id = "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"

  #-------------------------------------------------------------
  # ネットワーク設定 - Transit Gateway
  #-------------------------------------------------------------

  # transit_gateway_configuration (Optional, Block, Max: 1)
  # 設定内容: Kx環境を内部ネットワークに接続するためのTransit Gatewayとネットワーク構成を指定します。
  # 関連機能: ネットワーク接続
  #   Transit Gatewayを使用して、FinSpace環境VPCと顧客の内部ネットワークを接続します。
  #   kdbクラスターからのアウトバウンドトラフィックを管理できます。
  #   - https://docs.aws.amazon.com/finspace/latest/management-api/API_TransitGatewayConfiguration.html
  transit_gateway_configuration {
    # transit_gateway_id (Required)
    # 設定内容: kdbネットワークから内部ネットワークへのアウトバウンドトラフィックを接続するために
    #           顧客が作成したTransit GatewayのIDを指定します。
    # 設定可能な値: Transit Gateway ID（例: tgw-xxxxxxxxxxxxxxxxx）
    transit_gateway_id = "tgw-0123456789abcdef0"

    # routable_cidr_space (Required)
    # 設定内容: Kx環境を代表するルーティングCIDRを指定します。
    # 設定可能な値: 100.64.0.0 CIDR空間内の任意の/26範囲
    # 動作: 指定後、顧客のTransit Gatewayルーティングテーブルに追加され、
    #       トラフィックがKxネットワークにルーティングされるようになります。
    # 注意: /26範囲（64個のIPアドレス）が必要です
    routable_cidr_space = "100.64.0.0/26"

    # attachment_network_acl_configuration (Optional, Block, Max: 100)
    # 設定内容: kdbネットワークから内部ネットワークへのアウトバウンドトラフィックを管理するルールを定義します。
    # 関連機能: Network ACL
    #   Transit Gateway VPCアタッチメントに適用されるネットワークACLルールを定義し、
    #   トラフィックフローを制御します。
    #   - https://docs.aws.amazon.com/vpc/latest/tgw/tgw-nacls.html
    attachment_network_acl_configuration {
      # rule_number (Required)
      # 設定内容: エントリのルール番号を指定します。
      # 設定可能な値: 数値
      # 動作: すべてのネットワークACLエントリはルール番号の昇順で処理されます。
      rule_number = 1

      # protocol (Required)
      # 設定内容: プロトコル番号を指定します。
      # 設定可能な値:
      #   - "6": TCP
      #   - "17": UDP
      #   - "1": ICMPv4
      #   - "-1": すべてのプロトコル
      # 参考: https://www.iana.org/assignments/protocol-numbers/protocol-numbers.xhtml
      protocol = "6"

      # rule_action (Required)
      # 設定内容: ルールに一致するトラフィックを許可するか拒否するかを指定します。
      # 設定可能な値:
      #   - "allow": トラフィックを許可
      #   - "deny": トラフィックを拒否
      rule_action = "allow"

      # cidr_block (Required)
      # 設定内容: 許可または拒否するIPv4ネットワーク範囲をCIDR表記で指定します。
      # 設定可能な値: CIDR表記の文字列（例: 0.0.0.0/0, 10.0.0.0/16）
      # 注意: 指定されたCIDRブロックは正規形式に変換されます。
      #       例: 100.68.0.18/18 → 100.68.0.0/18
      cidr_block = "0.0.0.0/0"

      # port_range (Optional, Block, Max: 1)
      # 設定内容: ルールが適用されるポート範囲を定義します。
      # 用途: TCPまたはUDPプロトコルのポート範囲を制限
      port_range {
        # from (Required)
        # 設定内容: 範囲の最初のポートを指定します。
        # 設定可能な値: 0-65535
        from = 443

        # to (Required)
        # 設定内容: 範囲の最後のポートを指定します。
        # 設定可能な値: 0-65535
        to = 443
      }

      # icmp_type_code (Optional, Block, Max: 1)
      # 設定内容: ICMPタイプとコードで構成されるICMPプロトコルを定義します。
      # 用途: ICMPトラフィックの制御（プロトコルが"1"の場合に使用）
      icmp_type_code {
        # type (Required)
        # 設定内容: ICMPタイプを指定します。
        # 設定可能な値: -1（すべてのタイプ）または特定のICMPタイプ番号
        # 参考: https://www.iana.org/assignments/icmp-parameters/icmp-parameters.xhtml
        type = -1

        # code (Required)
        # 設定内容: ICMPコードを指定します。
        # 設定可能な値: -1（指定されたICMPタイプのすべてのコード）または特定のICMPコード番号
        code = -1
      }
    }
  }

  #-------------------------------------------------------------
  # ネットワーク設定 - カスタムDNS
  #-------------------------------------------------------------

  # custom_dns_configuration (Optional, Block)
  # 設定内容: Route 53アウトバウンドリゾルバーを設定するためのDNSサーバー名とIPのリストを指定します。
  # 関連機能: DNS解決
  #   カスタムDNSサーバーを構成して、kdb環境から内部ネットワークリソースへの名前解決を可能にします。
  #   - https://docs.aws.amazon.com/finspace/latest/userguide/step1-config-ntw.html
  custom_dns_configuration {
    # custom_dns_server_name (Required)
    # 設定内容: DNSサーバーの名前を指定します。
    # 設定可能な値: DNS名（FQDN形式）
    custom_dns_server_name = "example.finspace.amazonaws.com"

    # custom_dns_server_ip (Required)
    # 設定内容: DNSサーバーのIPアドレスを指定します。
    # 設定可能な値: IPv4アドレス
    custom_dns_server_ip = "10.0.0.76"
  }

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "production-kx-environment"
    Environment = "production"
    Purpose     = "trading-analytics"
  }

  # tags_all (Optional, Computed)
  # 設定内容: プロバイダーのdefault_tagsを含む全てのタグを明示的に管理します。
  # 設定可能な値: キーと値のペアのマップ
  # 省略時: プロバイダーのdefault_tagsとリソースのtagsが自動的にマージされます。
  # 注意: 通常は設定不要。明示的な制御が必要な場合のみ使用してください。
  tags_all = null

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional, Block)
  # 設定内容: リソース操作のタイムアウト時間を指定します。
  timeouts {
    # create (Optional)
    # 設定内容: 環境作成のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列（例: "60m", "1h"）
    # デフォルト: 設定されていない場合はプロバイダーのデフォルト値を使用
    create = "60m"

    # update (Optional)
    # 設定内容: 環境更新のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列（例: "60m", "1h"）
    # デフォルト: 設定されていない場合はプロバイダーのデフォルト値を使用
    update = "60m"

    # delete (Optional)
    # 設定内容: 環境削除のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列（例: "60m", "1h"）
    # デフォルト: 設定されていない場合はプロバイダーのデフォルト値を使用
    delete = "60m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: Kx環境のAmazon Resource Name (ARN)
#
# - id: Kx環境の一意識別子
#
# - availability_zones: この環境が利用可能なAWSアベイラビリティゾーンID。
#                        クラスター作成時にVPCサブネットを選択する際に重要です。
#
# - created_timestamp: 環境がFinSpaceで作成されたタイムスタンプ。
#                      エポック時刻（秒）で表されます。
#                      例: 2021年11月1日 12:00:00 PM UTC = 1635768000
#
# - infrastructure_account_id: AWS環境インフラストラクチャアカウントの一意識別子
#
# - last_modified_timestamp: 環境がFinSpaceで最後に更新されたタイムスタンプ。
#                            エポック時刻（秒）で表されます。
#
# - status: 環境作成のステータス
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
