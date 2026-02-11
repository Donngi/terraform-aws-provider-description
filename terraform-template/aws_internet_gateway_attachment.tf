################################################################################
# aws_internet_gateway_attachment
################################################################################
# リソース概要:
# VPCにインターネットゲートウェイをアタッチするためのリソース。
# インターネットゲートウェイは、VPCとインターネット間の通信を可能にする
# 水平スケーリング可能で冗長性の高いコンポーネントです。
#
# ユースケース:
# - VPCにインターネット接続を提供する際に使用
# - パブリックサブネットからのインターネット通信を有効化
# - IPv4およびIPv6トラフィックのルーティングとNAT変換
#
# 制約事項:
# - 1つのVPCに対して1つのインターネットゲートウェイのみアタッチ可能
# - アタッチメントを削除する前に、ルートテーブルからインターネットゲートウェイ
#   への参照を削除する必要がある
# - インターネットゲートウェイ自体のリソース(aws_internet_gateway)が
#   事前に作成されている必要がある
#
# 参考:
# - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway_attachment
# - https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Internet_Gateway.html
# - https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_AttachInternetGateway.html
################################################################################

resource "aws_internet_gateway_attachment" "example" {
  ################################################################################
  # 必須パラメータ
  ################################################################################

  # internet_gateway_id - (必須) string
  # アタッチするインターネットゲートウェイのID。
  #
  # 詳細:
  # - aws_internet_gatewayリソースまたはデータソースから取得したIDを指定
  # - 形式: igw-xxxxxxxxxxxxxxxxx
  # - インターネットゲートウェイは事前に作成されている必要がある
  #
  # 使用例:
  # - 新規作成したゲートウェイ: aws_internet_gateway.main.id
  # - 既存のゲートウェイ: data.aws_internet_gateway.existing.id
  #
  # 制約:
  # - 有効なインターネットゲートウェイIDである必要がある
  # - 指定されたゲートウェイが既に他のVPCにアタッチされていないこと
  #
  # AWS API Reference:
  # - InternetGatewayId parameter in AttachInternetGateway API
  # - https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_AttachInternetGateway.html
  internet_gateway_id = aws_internet_gateway.example.id

  # vpc_id - (必須) string
  # インターネットゲートウェイをアタッチするVPCのID。
  #
  # 詳細:
  # - 形式: vpc-xxxxxxxxxxxxxxxxx
  # - VPCは事前に作成されている必要がある
  # - アタッチメント後、このVPC内のリソースがインターネット接続可能になる
  #
  # 使用例:
  # - 新規作成したVPC: aws_vpc.main.id
  # - 既存のVPC: data.aws_vpc.existing.id
  #
  # 制約:
  # - 有効なVPC IDである必要がある
  # - 1つのVPCには1つのインターネットゲートウェイのみアタッチ可能
  # - VPCに既に別のインターネットゲートウェイがアタッチされていないこと
  #
  # 注意事項:
  # - VPCのルートテーブルに適切なルートを追加する必要がある
  #   (例: 0.0.0.0/0 -> インターネットゲートウェイ)
  # - パブリックIPアドレスまたはElastic IPを持つインスタンスのみが
  #   インターネット通信可能
  #
  # AWS API Reference:
  # - VpcId parameter in AttachInternetGateway API
  # - https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_AttachInternetGateway.html
  vpc_id = aws_vpc.example.id

  ################################################################################
  # オプションパラメータ
  ################################################################################

  # region - (オプション) string
  # このリソースが管理されるAWSリージョン。
  #
  # 詳細:
  # - 省略時はプロバイダー設定のリージョンが使用される
  # - 明示的に指定することで、プロバイダーのデフォルトリージョンと
  #   異なるリージョンでリソースを管理可能
  # - Computed属性でもあるため、省略時は実際に使用されたリージョンが保存される
  #
  # 使用例:
  # - マルチリージョン構成での明示的なリージョン指定
  # - クロスリージョン参照の明確化
  #
  # 形式:
  # - "us-east-1", "ap-northeast-1", "eu-west-1" など
  #
  # 注意事項:
  # - VPCとインターネットゲートウェイは同じリージョンに存在する必要がある
  # - リージョン間でのアタッチメントは不可
  #
  # 参考:
  # - https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-east-1"

  ################################################################################
  # Computed属性（読み取り専用）
  ################################################################################

  # id - (Computed) string
  # VPCとインターネットゲートウェイのIDをコロンで結合した文字列。
  #
  # 詳細:
  # - 形式: vpc-xxxxx:igw-xxxxx
  # - Terraformによって自動的に生成される
  # - このリソースの一意の識別子として使用される
  # - 明示的に設定可能だが、通常は自動生成に任せる
  #
  # 使用例:
  # - 他のリソースからの参照: aws_internet_gateway_attachment.example.id
  # - データソースでの検索キーとして使用可能
  #
  # 注意:
  # - このIDはTerraform State内でのみ意味を持つ
  # - AWS APIでは、アタッチメント自体に独立したIDは存在しない

  ################################################################################
  # タイムアウト設定
  ################################################################################

  # timeouts - (オプション) ブロック
  # リソース操作のタイムアウト時間をカスタマイズ。
  #
  # 詳細:
  # - Terraformがリソース操作を待機する最大時間を定義
  # - ネットワーク遅延やAWS API制限により操作が長時間かかる場合に調整
  # - 指定しない場合はTerraformのデフォルト値が使用される
  #
  # 使用例:
  # - 大規模VPCでのアタッチメント操作
  # - API レート制限が懸念される環境
  #
  # timeouts {
  #   # create - (オプション) string
  #   # インターネットゲートウェイをVPCにアタッチする際のタイムアウト。
  #   #
  #   # デフォルト: "20m" (20分)
  #   # 形式: "10m", "1h", "30s" などの期間文字列
  #   #
  #   # 推奨設定:
  #   # - 通常の環境: デフォルト値で十分
  #   # - 大規模環境やAPI制限がある場合: "30m" など延長を検討
  #   #
  #   # 注意:
  #   # - アタッチメント処理は通常数秒で完了するが、
  #   #   AWS側のキューイングにより時間がかかる場合がある
  #   create = "20m"
  #
  #   # delete - (オプション) string
  #   # VPCからインターネットゲートウェイをデタッチする際のタイムアウト。
  #   #
  #   # デフォルト: "20m" (20分)
  #   # 形式: "10m", "1h", "30s" などの期間文字列
  #   #
  #   # 推奨設定:
  #   # - 通常の環境: デフォルト値で十分
  #   # - 依存リソースが多い場合: "30m" など延長を検討
  #   #
  #   # 注意:
  #   # - デタッチ前にルートテーブルから参照を削除する必要がある
  #   # - 削除時にDependency Violationエラーが発生する場合は、
  #   #   他のリソースがまだゲートウェイを参照している可能性がある
  #   delete = "20m"
  # }
}

################################################################################
# 使用例
################################################################################

# 例1: 基本的なVPCへのインターネットゲートウェイアタッチメント
#
# resource "aws_vpc" "main" {
#   cidr_block           = "10.0.0.0/16"
#   enable_dns_hostnames = true
#   enable_dns_support   = true
#
#   tags = {
#     Name = "main-vpc"
#   }
# }
#
# resource "aws_internet_gateway" "main" {
#   tags = {
#     Name = "main-igw"
#   }
# }
#
# resource "aws_internet_gateway_attachment" "main" {
#   internet_gateway_id = aws_internet_gateway.main.id
#   vpc_id              = aws_vpc.main.id
# }
#
# resource "aws_route_table" "public" {
#   vpc_id = aws_vpc.main.id
#
#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.main.id
#   }
#
#   tags = {
#     Name = "public-route-table"
#   }
#
#   depends_on = [aws_internet_gateway_attachment.main]
# }

# 例2: マルチリージョン構成での明示的なリージョン指定
#
# resource "aws_vpc" "us_east" {
#   provider   = aws.us_east_1
#   cidr_block = "10.1.0.0/16"
#
#   tags = {
#     Name = "us-east-vpc"
#   }
# }
#
# resource "aws_internet_gateway" "us_east" {
#   provider = aws.us_east_1
#
#   tags = {
#     Name = "us-east-igw"
#   }
# }
#
# resource "aws_internet_gateway_attachment" "us_east" {
#   provider = aws.us_east_1
#
#   internet_gateway_id = aws_internet_gateway.us_east.id
#   vpc_id              = aws_vpc.us_east.id
#   region              = "us-east-1"
# }

# 例3: タイムアウトをカスタマイズした設定
#
# resource "aws_internet_gateway_attachment" "custom_timeout" {
#   internet_gateway_id = aws_internet_gateway.main.id
#   vpc_id              = aws_vpc.main.id
#
#   timeouts {
#     create = "30m"
#     delete = "30m"
#   }
# }

################################################################################
# 関連リソース
################################################################################

# aws_internet_gateway - インターネットゲートウェイリソース本体
# aws_vpc - Virtual Private Cloud
# aws_route_table - VPCのルートテーブル
# aws_route - ルートテーブルのルート設定
# aws_subnet - VPCサブネット

################################################################################
# 重要な注意事項
################################################################################

# 1. アタッチメントの順序:
#    - インターネットゲートウェイとVPCを作成後にアタッチメントを実行
#    - ルートテーブルの設定はアタッチメント完了後に行う
#
# 2. 削除時の依存関係:
#    - ルートテーブルからインターネットゲートウェイへの参照を先に削除
#    - その後、アタッチメントを削除
#    - 最後にインターネットゲートウェイ自体を削除
#
# 3. VPCあたりの制限:
#    - 1つのVPCには1つのインターネットゲートウェイのみアタッチ可能
#    - 複数アタッチしようとするとエラーが発生
#
# 4. ネットワーク設計:
#    - パブリックサブネットのルートテーブルに0.0.0.0/0のルートを設定
#    - インスタンスにはパブリックIPまたはElastic IPが必要
#    - セキュリティグループでアウトバウンドトラフィックを許可
#
# 5. IPv6サポート:
#    - IPv6 CIDR BlockをVPCに割り当てている場合、::/0のルートも設定可能
#    - IPv6アドレスはグローバルにユニークで、直接インターネット通信が可能
#
# 6. コスト:
#    - インターネットゲートウェイ自体に料金は発生しない
#    - データ転送料金のみが課金対象
#
# 7. 高可用性:
#    - インターネットゲートウェイは自動的に冗長化されている
#    - 複数のAZにまたがって自動的にスケール
#
# 8. セキュリティ:
#    - インターネットゲートウェイは状態を保持しない
#    - セキュリティグループとNACLでトラフィックを制御
#    - プライベートサブネットにはインターネットゲートウェイへのルートを設定しない

################################################################################
# ベストプラクティス
################################################################################

# 1. 明示的な依存関係の定義:
#    - depends_onを使用してリソース間の依存関係を明確にする
#    - 特にルートテーブルとアタッチメントの順序に注意
#
# 2. タグ付け:
#    - インターネットゲートウェイとVPCに適切なタグを設定
#    - 環境、プロジェクト、コスト配分のためのタグを含める
#
# 3. ネットワーク分離:
#    - パブリックサブネットとプライベートサブネットを明確に分離
#    - プライベートサブネットからのインターネット接続にはNAT Gatewayを使用
#
# 4. モニタリング:
#    - VPC Flow Logsを有効化してトラフィックを監視
#    - CloudWatch Metricsでネットワークパフォーマンスを追跡
#
# 5. Infrastructure as Code:
#    - アタッチメントをコードで管理し、手動での変更を避ける
#    - Terraform Stateを安全に保管し、チーム間で共有
#
# 6. テスト環境:
#    - 本番環境と同様の構成でテスト環境を構築
#    - 変更前にテスト環境で動作確認を実施
