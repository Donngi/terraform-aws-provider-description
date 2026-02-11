#---------------------------------------------------------------
# VPC Endpoint Service
#---------------------------------------------------------------
#
# VPC Endpoint Serviceをプロビジョニングするリソースです。
# サービス利用者はこのサービスに接続するためのインターフェイス型VPCエンドポイントを
# 作成できます。Network Load BalancerまたはGateway Load Balancerを使用して
# プライベートサービスを提供し、他のVPCからのアクセスを可能にします。
#
# AWS公式ドキュメント:
#   - VPC Endpoint Service概要: https://docs.aws.amazon.com/vpc/latest/privatelink/privatelink-share-your-services.html
#   - VPC Endpoint Serviceの作成: https://docs.aws.amazon.com/vpc/latest/privatelink/create-endpoint-service.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint_service
#
# Provider Version: 6.28.0
# Generated: 2026-02-05
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_vpc_endpoint_service" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # acceptance_required (Required)
  # 設定内容: サービスへのVPCエンドポイント接続リクエストをサービス所有者が
  #          承認する必要があるかを指定します。
  # 設定可能な値:
  #   - true: 接続リクエストの手動承認が必要
  #   - false: 接続リクエストが自動承認される
  # 用途: セキュリティ要件に応じて接続制御を実施
  # 参考: https://docs.aws.amazon.com/vpc/latest/privatelink/configure-endpoint-service.html#accept-reject-connection-requests
  acceptance_required = false

  #-------------------------------------------------------------
  # ロードバランサー設定
  #-------------------------------------------------------------

  # network_load_balancer_arns (Optional)
  # 設定内容: エンドポイントサービス用の1つ以上のNetwork Load BalancerのARNを指定します。
  # 設定可能な値: Network Load BalancerのARNのセット
  # 注意: gateway_load_balancer_arnsと排他的（どちらか一方のみ指定可能）
  # 参考: https://docs.aws.amazon.com/vpc/latest/privatelink/privatelink-share-your-services.html
  network_load_balancer_arns = [
    "arn:aws:elasticloadbalancing:ap-northeast-1:123456789012:loadbalancer/net/example/1234567890abcdef"
  ]

  # gateway_load_balancer_arns (Optional)
  # 設定内容: エンドポイントサービス用の1つ以上のGateway Load BalancerのARNを指定します。
  # 設定可能な値: Gateway Load BalancerのARNのセット
  # 注意: network_load_balancer_arnsと排他的（どちらか一方のみ指定可能）
  # 用途: セキュリティアプライアンスやネットワーク仮想アプライアンスを配置する場合に使用
  # 参考: https://docs.aws.amazon.com/vpc/latest/privatelink/vpce-gateway-load-balancer.html
  gateway_load_balancer_arns = null

  #-------------------------------------------------------------
  # アクセス制御設定
  #-------------------------------------------------------------

  # allowed_principals (Optional)
  # 設定内容: エンドポイントサービスを検出できる1つ以上のプリンシパルのARNを指定します。
  # 設定可能な値: AWSアカウント、IAMユーザー、IAMロールのARNのセット
  # 省略時: 設定されたプリンシパルのみがサービスを検出可能
  # 関連機能: VPC Endpoint Service Allowed Principal
  #   スタンドアロンのaws_vpc_endpoint_service_allowed_principalリソースと併用しないこと。
  #   競合してアソシエーションが上書きされます。
  # 参考: https://docs.aws.amazon.com/vpc/latest/privatelink/configure-endpoint-service.html#add-remove-permissions
  allowed_principals = [
    "arn:aws:iam::987654321098:root"
  ]

  #-------------------------------------------------------------
  # DNS設定
  #-------------------------------------------------------------

  # private_dns_name (Optional)
  # 設定内容: サービスのプライベートDNS名を指定します。
  # 設定可能な値: 有効なDNS名（例: example.com）
  # 省略時: プライベートDNS名は設定されません
  # 注意: プライベートDNS名を使用するには、ドメインの所有権を証明するための
  #      DNS検証レコードの設定が必要です
  # 参考: https://docs.aws.amazon.com/vpc/latest/privatelink/manage-dns-names.html
  private_dns_name = "example.com"

  #-------------------------------------------------------------
  # ネットワーク設定
  #-------------------------------------------------------------

  # supported_ip_address_types (Optional)
  # 設定内容: サポートされるIPアドレスタイプを指定します。
  # 設定可能な値:
  #   - "ipv4": IPv4のみサポート
  #   - "ipv6": IPv6のみサポート
  # 省略時: デフォルトのIPアドレスタイプが使用されます
  # 用途: デュアルスタック環境やIPv6専用環境での利用
  supported_ip_address_types = ["ipv4"]

  # supported_regions (Optional)
  # 設定内容: サービス利用者がサービスにアクセスできるリージョンのセットを指定します。
  # 設定可能な値: 有効なAWSリージョンコードのセット（例: ap-northeast-1, us-east-1）
  # 省略時: サービスが作成されたリージョンからのみアクセス可能
  # 用途: マルチリージョン展開での利用制御
  supported_regions = ["ap-northeast-1", "ap-southeast-1"]

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
  # リソースID設定
  #-------------------------------------------------------------

  # id (Optional)
  # 設定内容: リソースのIDを指定します。
  # 設定可能な値: 文字列
  # 省略時: AWSによって自動生成されます
  # 注意: 通常は明示的に設定せず、自動生成されたIDを使用します
  id = null

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
    Name        = "example-vpc-endpoint-service"
    Environment = "production"
  }

  # tags_all (Optional)
  # 設定内容: リソースに割り当てられたすべてのタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 省略時: tagsとプロバイダーのdefault_tagsが結合されて自動的に設定されます
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックから継承されたタグを含む、
  #   すべてのタグが含まれます。通常は明示的に設定する必要はありません。
  tags_all = null

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  timeouts {
    # create (Optional)
    # 設定内容: リソース作成時のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列（例: "10m", "1h"）
    # 省略時: デフォルトのタイムアウト時間が使用されます
    create = "10m"

    # update (Optional)
    # 設定内容: リソース更新時のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列（例: "10m", "1h"）
    # 省略時: デフォルトのタイムアウト時間が使用されます
    update = "10m"

    # delete (Optional)
    # 設定内容: リソース削除時のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列（例: "10m", "1h"）
    # 省略時: デフォルトのタイムアウト時間が使用されます
    delete = "10m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: VPCエンドポイントサービスのID
#
# - arn: VPCエンドポイントサービスのAmazon Resource Name (ARN)
#
# - availability_zones: サービスが利用可能なアベイラビリティーゾーンのセット
#
# - base_endpoint_dns_names: サービスのDNS名のセット
#
# - manages_vpc_endpoints: サービスがVPCエンドポイントを管理するかどうか (true/false)
#
# - service_name: サービス名
#
# - service_type: サービスタイプ（Gateway または Interface）
#
# - state: VPCエンドポイントサービスの状態
#
# - private_dns_name_configuration: エンドポイントサービスのプライベートDNS名設定に
#                                    関する情報を含むオブジェクトのリスト
#     * name: サービスプロバイダーが作成する必要があるレコードサブドメインの名前
#     * state: VPCエンドポイントサービスの検証状態。stateが"verified"の場合のみ、
#---------------------------------------------------------------
