#---------------------------------------------------------------
# AWS VPC Lattice Resource Configuration
#---------------------------------------------------------------
#
# Amazon VPC Lattice のリソース設定をプロビジョニングするリソースです。
# リソース設定は VPC Lattice がバックエンドリソース（IPアドレス、
# DNSホスト名、ARNで参照されるリソース）へのアクセスを管理するために
# 使用されます。リソースゲートウェイを通じてサービスネットワークから
# バックエンドリソースへの接続を確立します。
#
# AWS公式ドキュメント:
#   - VPC Lattice リソース設定: https://docs.aws.amazon.com/vpc-lattice/latest/ug/resource-configuration.html
#   - VPC Lattice リソースゲートウェイ: https://docs.aws.amazon.com/vpc-lattice/latest/ug/resource-gateways.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpclattice_resource_configuration
#
# Provider Version: 6.28.0
# Generated: 2026-02-19
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_vpclattice_resource_configuration" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: リソース設定の名前を指定します。
  # 設定可能な値: 3～40文字の英数字とハイフン
  name = "example-resource-configuration"

  # type (Optional)
  # 設定内容: リソース設定のタイプを指定します。
  # 設定可能な値:
  #   - "SINGLE"  : 単一のバックエンドリソースを設定
  #   - "GROUP"   : 複数リソースのグループ設定（resource_configuration_group_id と組み合わせ）
  #   - "CHILD"   : 既存グループに属する子リソース設定
  #   - "ARN"     : ARNで識別されるリソース
  # 省略時: AWSがリソース定義に基づいて自動設定
  # 関連機能: VPC Lattice リソース設定タイプ
  #   - https://docs.aws.amazon.com/vpc-lattice/latest/ug/resource-configuration.html
  type = "SINGLE"

  #-------------------------------------------------------------
  # ネットワーク設定
  #-------------------------------------------------------------

  # resource_gateway_identifier (Optional)
  # 設定内容: バックエンドリソースへの接続に使用するリソースゲートウェイのIDまたはARNを指定します。
  # 設定可能な値: 有効なVPC LatticeリソースゲートウェイのIDまたはARN
  # 省略時: AWSが自動設定（computed）
  # 関連機能: リソースゲートウェイ - VPC内のリソースへのアクセスを仲介するゲートウェイ
  #   - https://docs.aws.amazon.com/vpc-lattice/latest/ug/resource-gateways.html
  resource_gateway_identifier = aws_vpclattice_resource_gateway.example.id

  # port_ranges (Optional)
  # 設定内容: バックエンドリソースが受け付けるポート範囲をセットで指定します。
  # 設定可能な値: "1-65535" 形式の文字列、またはポート単体（例: "443", "80-8080"）
  # 省略時: AWSが自動設定（computed）
  port_ranges = ["443", "80"]

  # protocol (Optional)
  # 設定内容: バックエンドリソースとの通信プロトコルを指定します。
  # 設定可能な値:
  #   - "TCP"  : TCPプロトコル
  # 省略時: AWSが自動設定（computed）
  protocol = "TCP"

  #-------------------------------------------------------------
  # カスタムドメイン設定
  #-------------------------------------------------------------

  # custom_domain_name (Optional)
  # 設定内容: リソース設定に関連付けるカスタムドメイン名を指定します。
  # 設定可能な値: 完全修飾ドメイン名（FQDN）
  # 省略時: カスタムドメインなし
  # 関連機能: カスタムドメインによるリソースへのアクセス
  #   - https://docs.aws.amazon.com/vpc-lattice/latest/ug/resource-configuration.html
  custom_domain_name = null

  # domain_verification_id (Optional)
  # 設定内容: カスタムドメインの検証IDを指定します。custom_domain_nameを設定する場合に使用します。
  # 設定可能な値: 有効なドメイン検証ID（aws_vpclattice_domain_verification リソースのid属性）
  # 省略時: AWSが自動設定（computed）
  domain_verification_id = null

  #-------------------------------------------------------------
  # グループ設定
  #-------------------------------------------------------------

  # resource_configuration_group_id (Optional)
  # 設定内容: このリソース設定が属するグループリソース設定のIDを指定します。
  #           type = "CHILD" の場合に使用します。
  # 設定可能な値: 有効なVPC LatticeグループリソースのID
  # 省略時: グループに属さない独立したリソース設定
  resource_configuration_group_id = null

  # allow_association_to_shareable_service_network (Optional)
  # 設定内容: 共有可能なサービスネットワークへの関連付けを許可するかどうかを指定します。
  # 設定可能な値: true（許可）/ false（拒否）
  # 省略時: AWSが自動設定（computed）
  allow_association_to_shareable_service_network = false

  #-------------------------------------------------------------
  # リソース定義設定
  #-------------------------------------------------------------

  # resource_configuration_definition ブロックでバックエンドリソースの接続先を定義します。
  # arn_resource, dns_resource, ip_resource のいずれか1つを指定します。
  resource_configuration_definition {
    # ip_resource - IPアドレスでリソースを指定する場合
    # 設定内容: バックエンドリソースのIPアドレスを指定します。
    ip_resource {
      # ip_address (Required)
      # 設定内容: バックエンドリソースのIPアドレスを指定します。
      # 設定可能な値: 有効なIPv4またはIPv6アドレス
      ip_address = "10.0.1.100"
    }

    # dns_resource - DNSホスト名でリソースを指定する場合
    # 設定内容: DNSホスト名とIPアドレスタイプでバックエンドリソースを指定します。
    # dns_resource {
    #   # domain_name (Required)
    #   # 設定内容: バックエンドリソースのドメイン名を指定します。
    #   # 設定可能な値: 完全修飾ドメイン名（FQDN）
    #   domain_name = "internal.example.com"
    #
    #   # ip_address_type (Required)
    #   # 設定内容: ドメイン名解決で使用するIPアドレスタイプを指定します。
    #   # 設定可能な値: "IPV4" / "IPV6" / "DUALSTACK"
    #   ip_address_type = "IPV4"
    # }

    # arn_resource - ARNでリソースを指定する場合
    # 設定内容: ARNで識別されるAWSリソースをバックエンドリソースとして指定します。
    # arn_resource {
    #   # arn (Required)
    #   # 設定内容: バックエンドリソースのARNを指定します。
    #   # 設定可能な値: 有効なAWSリソースARN
    #   arn = "arn:aws:rds:ap-northeast-1:123456789012:db:example-db"
    # }
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
  # 設定内容: リソースに付与するタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ（文字列のみ）
  # 省略時: タグなし（プロバイダーの default_tags は自動適用）
  tags = {
    Name        = "example-resource-configuration"
    Environment = "production"
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  timeouts {
    # create (Optional)
    # 設定内容: リソース作成時のタイムアウト時間を指定します。
    # 設定可能な値: "30s", "5m", "2h" などの時間文字列（s=秒, m=分, h=時間）
    # 省略時: プロバイダーのデフォルトタイムアウトを使用
    create = "30m"

    # update (Optional)
    # 設定内容: リソース更新時のタイムアウト時間を指定します。
    # 設定可能な値: "30s", "5m", "2h" などの時間文字列（s=秒, m=分, h=時間）
    # 省略時: プロバイダーのデフォルトタイムアウトを使用
    update = "30m"

    # delete (Optional)
    # 設定内容: リソース削除時のタイムアウト時間を指定します。
    # 設定可能な値: "30s", "5m", "2h" などの時間文字列（s=秒, m=分, h=時間）
    # 省略時: プロバイダーのデフォルトタイムアウトを使用
    delete = "30m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: リソース設定のID
# - arn: リソース設定のARN
# - domain_verification_arn: ドメイン検証のARN
# - domain_verification_status: ドメイン検証のステータス
# - tags_all: プロバイダーのdefault_tagsとtagsをマージした全タグのマップ
#
#---------------------------------------------------------------
