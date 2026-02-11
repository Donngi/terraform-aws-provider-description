#---------------------------------------------------------------
# Amazon OpenSearch Serverless VPC Endpoint
#---------------------------------------------------------------
#
# AWS PrivateLinkを使用してVPCからAmazon OpenSearch Serverlessへ
# プライベート接続を確立するためのインターフェースエンドポイントを
# プロビジョニングします。このエンドポイントを使用することで、
# インターネットゲートウェイ、NATデバイス、VPN接続、Direct Connect接続を
# 使用せずに、VPC内からOpenSearch Serverlessコレクションやダッシュボードに
# 安全にアクセスできます。
#
# AWS公式ドキュメント:
#   - Access Amazon OpenSearch Serverless using an interface endpoint (AWS PrivateLink): https://docs.aws.amazon.com/opensearch-service/latest/developerguide/serverless-vpc.html
#   - CreateVpcEndpoint API: https://docs.aws.amazon.com/opensearch-service/latest/ServerlessAPIReference/API_CreateVpcEndpoint.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/opensearchserverless_vpc_endpoint
#
# Provider Version: 6.28.0
# Generated: 2026-02-03
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_opensearchserverless_vpc_endpoint" "example" {
  #---------------------------------------------------------------
  # Required Parameters
  #---------------------------------------------------------------

  # インターフェースエンドポイントの名前
  #
  # 制約:
  #   - 最小長: 3文字
  #   - 最大長: 32文字
  #   - パターン: [a-z][a-z0-9-]+（小文字の英字で始まり、小文字の英数字とハイフンのみ使用可能）
  #
  # 例: "myendpoint", "opensearch-prod-endpoint"
  name = "myendpoint"

  # OpenSearch Serverlessへのアクセスに使用するサブネットIDのリスト
  #
  # 詳細:
  #   - VPC内の1つ以上のサブネットIDを指定します
  #   - 最大6つのサブネットを指定可能
  #   - 指定したサブネットごとにエンドポイントネットワークインターフェースが作成されます
  #   - これらのインターフェースがOpenSearch Serverlessへのトラフィックのエントリポイントとなります
  #
  # 考慮事項:
  #   - VPCエンドポイントは同一リージョン内でのみサポートされます
  #   - IPv4、IPv6、またはDualstackのIPアドレスタイプは、指定したサブネットに基づいて決定されます
  #
  # 例: ["subnet-12345678", "subnet-87654321"]
  subnet_ids = ["subnet-12345678"]

  # OpenSearch Serverlessへのアクセス元となるVPCのID
  #
  # 制約:
  #   - 最小長: 1文字
  #   - 最大長: 255文字
  #   - パターン: vpc-[0-9a-z]*
  #
  # 詳細:
  #   - このVPC内からOpenSearch Serverlessコレクションにアクセスできるようになります
  #   - VPCエンドポイントを作成すると、Route 53プライベートホストゾーンが作成され、
  #     VPCにアタッチされます
  #   - リージョン内の全てのコレクションとダッシュボードにアクセスするには、
  #     VPC内に1つのOpenSearch Serverless VPCエンドポイントがあれば十分です
  #
  # 例: "vpc-0a1b2c3d"
  vpc_id = "vpc-0a1b2c3d"

  #---------------------------------------------------------------
  # Optional Parameters
  #---------------------------------------------------------------

  # このリソースを管理するリージョン
  #
  # デフォルト:
  #   - プロバイダー設定で指定されたリージョンが使用されます
  #
  # 詳細:
  #   - 明示的にリージョンを指定しない場合、プロバイダー設定のリージョンが適用されます
  #   - VPCエンドポイントは同一リージョン内でのみサポートされるため、
  #     アクセスしたいOpenSearch ServerlessコレクションとVPCは同じリージョンに存在する必要があります
  #
  # 例: "us-east-1", "ap-northeast-1"
  # region = "us-east-1"

  # エンドポイントへのインバウンドトラフィックのポート、プロトコル、ソースを
  # 定義する1つ以上のセキュリティグループのID
  #
  # 制約:
  #   - 最大5つのセキュリティグループを指定可能
  #
  # 詳細:
  #   - エンドポイントネットワークインターフェースに関連付けられます
  #   - OpenSearch Serverlessへのアクセスを許可するため、HTTPS（ポート443）を許可する必要があります
  #   - 指定しない場合、VPCのデフォルトセキュリティグループが使用されます
  #
  # セキュリティグループ設定例:
  #   - インバウンドルール: HTTPS（443）を必要なソースから許可
  #   - アウトバウンドルール: 通常は全トラフィックを許可
  #
  # ベストプラクティス:
  #   - 最小権限の原則に従い、必要な送信元からのHTTPSトラフィックのみを許可します
  #   - VPC内の特定のサブネットやセキュリティグループからのアクセスのみを許可することを検討してください
  #
  # 例: ["sg-12345678", "sg-87654321"]
  # security_group_ids = ["sg-12345678"]

  #---------------------------------------------------------------
  # Timeouts
  #---------------------------------------------------------------

  # リソース作成、更新、削除操作のタイムアウト設定
  #
  # VPCエンドポイントの作成や削除には時間がかかる場合があるため、
  # 必要に応じてタイムアウト値を調整できます。
  #
  # 形式: "30s", "5m", "2h45m" など（秒: s、分: m、時間: h）
  #
  # timeouts {
  #   create = "30m"
  #   update = "30m"
  #   delete = "30m"
  # }
}

#---------------------------------------------------------------
# Attributes Reference
#---------------------------------------------------------------
#
# このリソースは以下の属性をエクスポートします:
#
# - id
#   VPCエンドポイントの一意の識別子
#   他のリソースでこのエンドポイントを参照する際に使用できます
#
#   使用例: aws_opensearchserverless_vpc_endpoint.example.id
#
#   補足:
#     - OpenSearch Serverlessのネットワークアクセスポリシーで
#       このVPCエンドポイントIDを指定することで、
#       このエンドポイント経由でのアクセスを許可できます
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# 使用例
#---------------------------------------------------------------
#
# # 基本的な使用例
# resource "aws_opensearchserverless_vpc_endpoint" "example" {
#   name       = "myendpoint"
#   subnet_ids = [aws_subnet.example.id]
#   vpc_id     = aws_vpc.example.id
# }
#
# # セキュリティグループを指定した使用例
# resource "aws_opensearchserverless_vpc_endpoint" "example" {
#   name               = "secure-endpoint"
#   subnet_ids         = [aws_subnet.private_a.id, aws_subnet.private_b.id]
#   vpc_id             = aws_vpc.main.id
#   security_group_ids = [aws_security_group.opensearch_endpoint.id]
# }
#
# # ネットワークアクセスポリシーと組み合わせた使用例
# # VPCエンドポイント経由でのアクセスを許可するネットワークポリシー
# resource "aws_opensearchserverless_access_policy" "network" {
#   name = "example-network-policy"
#   type = "network"
#   policy = jsonencode([
#     {
#       Rules = [
#         {
#           ResourceType = "collection"
#           Resource     = ["collection/${aws_opensearchserverless_collection.example.name}"]
#         }
#       ]
#       AllowFromPublic = false
#       SourceVPCEs     = [aws_opensearchserverless_vpc_endpoint.example.id]
#     }
#   ])
# }
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# 重要な考慮事項
#---------------------------------------------------------------
#
# 1. DNSの解決
#    VPCエンドポイントを作成すると、OpenSearch ServerlessはRoute 53プライベート
#    ホストゾーンを作成し、VPCにアタッチします。このプライベートホストゾーンには、
#    OpenSearch ServerlessコレクションのワイルドカードDNSレコード
#    (*.aoss.<region>.amazonaws.com)をエンドポイントのインターフェース
#    アドレスに解決するレコードが含まれます。
#
# 2. ネットワークアクセスポリシー
#    VPCエンドポイントを作成するだけでは、OpenSearch Serverlessコレクションへの
#    アクセスは許可されません。ネットワークアクセスポリシーで、このVPCエンドポイント
#    からのアクセスを明示的に許可する必要があります。
#
# 3. データアクセスポリシー
#    ネットワークレベルのアクセスに加えて、データアクセスポリシーを設定して、
#    コレクション内のデータやインデックスに対する操作の権限を制御する必要があります。
#
# 4. リージョンのサポート
#    VPCエンドポイントは同一リージョン内でのみサポートされます。
#    VPCとOpenSearch Serverlessコレクションは同じリージョンに存在する必要があります。
#
# 5. セキュリティグループ
#    セキュリティグループでHTTPS（ポート443）のインバウンドトラフィックを許可する
#    必要があります。VPC内のリソースからエンドポイントへのアクセスを制御します。
#
# 6. エンドポイントポリシー
#    VPCエンドポイントにエンドポイントポリシーをアタッチして、OpenSearch Serverless
#    APIへのアクセスを制御できます（例: ListCollections、BatchGetCollectionなど）。
#
# 7. コスト最適化
#    1つのリージョン内の全てのコレクションとダッシュボードにアクセスするには、
#    VPC内に1つのOpenSearch Serverless VPCエンドポイントがあれば十分です。
#    複数のアカウントにまたがる場合でも、各VPCに1つのエンドポイントを作成し、
#    ネットワークポリシーで複数のVPCエンドポイントIDを指定することを推奨します。
#
# 8. FIPS準拠
#    FIPSコンプライアンスが必要な場合、OpenSearch ServerlessはFIPS 140-2対応の
#    エンドポイントをサポートしています。FIPS準拠のエンドポイントは、
#    FIPS検証済みの暗号化ライブラリを使用して安全な通信を行います。
#
#---------------------------------------------------------------
