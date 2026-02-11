#---------------------------------------------------------------
# AWS Service Discovery Service
#---------------------------------------------------------------
#
# AWS Cloud Mapのサービスをプロビジョニングするリソースです。
# Service Discovery Serviceは、マイクロサービスアーキテクチャにおいて、
# サービスの自動検出とヘルスチェックを実現します。
# サービスインスタンスを登録し、DNSレコードやAPIを通じて動的にサービスを検索できます。
#
# 主要機能:
#   - DNS/HTTP名前空間を使用したサービス検出
#   - Route 53との統合によるDNSベースのサービス検出
#   - ヘルスチェック機能（Route 53またはカスタムヘルスチェック）
#   - ECS、EKS等のコンテナサービスとの統合
#
# AWS公式ドキュメント:
#   - AWS Cloud Map概要: https://docs.aws.amazon.com/cloud-map/latest/dg/what-is-cloud-map.html
#   - サービスの作成: https://docs.aws.amazon.com/cloud-map/latest/dg/working-with-services.html
#   - ヘルスチェック: https://docs.aws.amazon.com/cloud-map/latest/dg/health-checks.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/service_discovery_service
#
# Provider Version: 6.28.0
# Generated: 2026-02-05
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_service_discovery_service" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: サービスの名前を指定します。
  # 制約: 既存のサービスと重複しない一意の名前を使用する必要があります。
  # 注意: この値を変更すると、リソースの再作成が発生します（Forces new resource）。
  name = "example-service"

  # description (Optional)
  # 設定内容: サービスの説明を指定します。
  # 用途: サービスの目的や役割を記述するために使用します。
  description = "Example service discovery service for microservices"

  # namespace_id (Optional, Computed)
  # 設定内容: サービスを作成する名前空間のIDを指定します。
  # 関連リソース: aws_service_discovery_private_dns_namespace または
  #              aws_service_discovery_public_dns_namespace
  # 注意: dns_configブロック内でも指定可能です。
  namespace_id = null

  # type (Optional, Computed)
  # 設定内容: サービスインスタンスの検出方法を指定します。
  # 設定可能な値: "HTTP" - DiscoverInstances APIのみを使用（DNSレコードなし）
  # 省略時: DNS名前空間を使用する場合は省略（DNSベースの検出）
  # 用途: API経由でのみサービス検出を行う場合に"HTTP"を指定
  type = null

  # force_destroy (Optional)
  # 設定内容: サービス削除時に全インスタンスを自動削除するかを指定します。
  # 設定可能な値: true/false
  # デフォルト: false
  # 注意: trueに設定すると、削除されたインスタンスは復旧できません。
  #       本番環境では慎重に使用してください。
  force_destroy = false

  #-------------------------------------------------------------
  # DNS設定
  #-------------------------------------------------------------

  # dns_config (Optional)
  # 設定内容: Route 53で作成するリソースレコードセットの情報を指定します。
  # 注意: HTTPタイプのサービス（type = "HTTP"）の場合は使用しません。
  # 関連: DNS名前空間を使用する場合に必須
  dns_config {
    # namespace_id (Required)
    # 設定内容: DNS設定に使用する名前空間のIDを指定します。
    # 関連リソース: aws_service_discovery_private_dns_namespace または
    #              aws_service_discovery_public_dns_namespace
    # 注意: この値を変更すると、リソースの再作成が発生します（Forces new resource）。
    namespace_id = aws_service_discovery_private_dns_namespace.example.id

    # routing_policy (Optional)
    # 設定内容: Route 53がインスタンス登録時に適用するルーティングポリシーを指定します。
    # 設定可能な値:
    #   - "MULTIVALUE": 複数の値を返す（最大8つのヘルシーなレコード）
    #   - "WEIGHTED": 重み付けルーティング（重みに基づいてトラフィックを分散）
    # デフォルト: MULTIVALUE
    # 用途: ロードバランシングの振る舞いを制御
    routing_policy = "MULTIVALUE"

    # dns_records (Required)
    # 設定内容: Route 53が返すDNSレコードの設定を指定します。
    # 注意: 最低1つのdns_recordsブロックが必須です。
    dns_records {
      # ttl (Required)
      # 設定内容: DNSリゾルバーがこのリソースレコードセットの設定を
      #          キャッシュする時間を秒単位で指定します。
      # 推奨値:
      #   - 10-60秒: 頻繁に変更されるサービスの場合
      #   - 300-3600秒: 安定したサービスの場合
      ttl = 10

      # type (Required)
      # 設定内容: DNSクエリに対してRoute 53が返す値のタイプを指定します。
      # 設定可能な値:
      #   - "A": IPv4アドレス
      #   - "AAAA": IPv6アドレス
      #   - "SRV": サービスロケーター（ポート情報を含む）
      #   - "CNAME": 正規名（別名）
      # 注意: この値を変更すると、リソースの再作成が発生します（Forces new resource）。
      type = "A"
    }
  }

  #-------------------------------------------------------------
  # ヘルスチェック設定
  #-------------------------------------------------------------

  # health_check_config (Optional)
  # 設定内容: Route 53ヘルスチェックの設定を指定します。
  # 注意: パブリックDNS名前空間でのみ使用可能です。
  #      プライベートDNS名前空間では使用できません。
  # 用途: エンドポイントの正常性を自動的に監視し、
  #      異常なインスタンスをDNSクエリ結果から除外します。
  health_check_config {
    # failure_threshold (Optional)
    # 設定内容: Route 53がエンドポイントを異常と判断するまでの
    #          連続したヘルスチェック失敗回数を指定します。
    # 設定可能な値: 1〜10
    # デフォルト: 1
    # 注意: 値を大きくすると、誤検知を減らせますが、
    #      障害検出までの時間が長くなります。
    failure_threshold = 1

    # resource_path (Optional)
    # 設定内容: Route 53がヘルスチェック実行時にリクエストするパスを指定します。
    # デフォルト: "/"
    # 形式: "/health"、"/api/health"など
    # 注意: HTTPまたはHTTPSタイプのヘルスチェックでのみ使用します。
    resource_path = "/"

    # type (Optional)
    # 設定内容: 実行するヘルスチェックのタイプを指定します。
    # 設定可能な値:
    #   - "HTTP": HTTPヘルスチェック（ポート80）
    #   - "HTTPS": HTTPSヘルスチェック（ポート443）
    #   - "TCP": TCPヘルスチェック（指定ポートへの接続確認）
    # 注意: この値を変更すると、リソースの再作成が発生します（Forces new resource）。
    type = "HTTP"
  }

  # health_check_custom_config (Optional, Deprecated)
  # 設定内容: カスタムヘルスチェックの設定を指定します。
  # 注意: 非推奨（Deprecated）です。health_check_configの使用を推奨します。
  #      この値を変更すると、リソースの再作成が発生します（Forces new resource）。
  # 用途: プライベートDNS名前空間でカスタムヘルスチェックロジックを使用する場合
  # health_check_custom_config {
  #   # failure_threshold (Optional, Deprecated)
  #   # 設定内容: カスタムヘルスチェックの失敗閾値を指定します。
  #   # 注意: 値は常に1に設定されます。
  #   #      この値を変更すると、リソースの再作成が発生します（Forces new resource）。
  #   failure_threshold = 1
  # }

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
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: サービスに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 用途: リソースの分類、コスト配分、アクセス制御などに使用
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "example-service"
    Environment = "production"
    Service     = "microservice-a"
  }
}

#---------------------------------------------------------------
# VPC内でのサービス検出を実現する典型的な構成例です。

# VPCの作成
resource "aws_vpc" "example" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "example-vpc"
  }
}

# プライベートDNS名前空間の作成
resource "aws_service_discovery_private_dns_namespace" "example" {
  name        = "example.internal"
  description = "Private DNS namespace for service discovery"
  vpc         = aws_vpc.example.id

  tags = {
    Name = "example-namespace"
  }
}

#---------------------------------------------------------------
# インターネット経由でのサービス検出を実現する構成例です。
# ヘルスチェックを使用して、異常なエンドポイントを自動的に除外します。

# パブリックDNS名前空間の作成
# resource "aws_service_discovery_public_dns_namespace" "example" {
#   name        = "example.com"
#   description = "Public DNS namespace for service discovery"
#
#   tags = {
#     Name = "example-public-namespace"
#   }
# }

# パブリック名前空間を使用したサービス
# resource "aws_service_discovery_service" "public" {
#   name = "public-service"
#
#   dns_config {
#     namespace_id = aws_service_discovery_public_dns_namespace.example.id
#
#     dns_records {
#       ttl  = 10
#       type = "A"
#     }
#   }
#
#   health_check_config {
#     failure_threshold = 10
#     resource_path     = "/health"
#     type              = "HTTP"
#   }
#
#   tags = {
#     Name = "public-service"
#   }
# }

#---------------------------------------------------------------
# DNS登録を行わず、DiscoverInstances APIのみでサービス検出を行う構成例です。

# HTTP名前空間の作成
# resource "aws_service_discovery_http_namespace" "example" {
#   name        = "example-http"
#   description = "HTTP namespace for API-based service discovery"
#
#   tags = {
#     Name = "example-http-namespace"
#   }
# }

# HTTP名前空間を使用したサービス
# resource "aws_service_discovery_service" "http" {
#   name         = "http-service"
#   namespace_id = aws_service_discovery_http_namespace.example.id
#   type         = "HTTP"
#
#   tags = {
#     Name = "http-service"
#   }
# }

#---------------------------------------------------------------
# ECSタスクの自動登録とヘルスチェックを実現する構成例です。

# ECSサービスでのサービス検出設定
# resource "aws_ecs_service" "example" {
#   name            = "example-ecs-service"
#   cluster         = aws_ecs_cluster.example.id
#   task_definition = aws_ecs_task_definition.example.arn
#   desired_count   = 2
#
#   service_registries {
#     registry_arn = aws_service_discovery_service.example.arn
#     # コンテナ名とポートを指定してSRVレコードを使用する場合
#     # container_name = "app"
#     # container_port = 8080
#   }
#
#   network_configuration {
#     subnets = aws_subnet.example[*].id
#   }
# }

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: サービスのID
#
# - arn: サービスのAmazon Resource Name (ARN)
#   形式: arn:aws:servicediscovery:region:account-id:service/service-id
#   用途: IAMポリシー、CloudWatch Logs、その他AWSサービスでの参照に使用
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------

#---------------------------------------------------------------
# Import
#---------------------------------------------------------------
# 既存のService Discovery Serviceは以下のコマンドでインポートできます:
#
# terraform import aws_service_discovery_service.example srv-xxxxxxxxx
#
# srv-xxxxxxxxxの部分は、AWSコンソールまたはCLIで確認できるサービスIDです。
#---------------------------------------------------------------
