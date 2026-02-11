################################################################################
# AWS Global Accelerator - Accelerator
################################################################################
# AWS Global Acceleratorは、AWSグローバルネットワーク上でトラフィックをエンドポイント
# にルーティングし、インターネットアプリケーションのパフォーマンスを向上させるサービスです。
#
# アクセラレータには2つのタイプがあります：
# - Standard accelerator: ユーザーの場所、エンドポイントの健全性、エンドポイントの重みに
#   基づいて最適なAWSエンドポイントにトラフィックを振り分けます
# - Custom routing accelerator: ユーザーを特定のEC2宛先に決定論的にルーティングします
#   (このリソースはStandard acceleratorを作成します)
#
# 関連ドキュメント:
# - https://docs.aws.amazon.com/global-accelerator/latest/dg/introduction-components.html
# - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/globalaccelerator_accelerator

################################################################################
# 基本設定
################################################################################

resource "aws_globalaccelerator_accelerator" "example" {
  # (Required) アクセラレータの名前
  # Global Acceleratorコンソールとリストに表示される名前です。
  # 例: "production-api-accelerator", "global-web-app"
  name = "example-accelerator"

  # (Optional) IPアドレスタイプ
  # デフォルト値: "IPV4"
  # 有効な値:
  # - "IPV4": IPv4アドレスのみを使用（2つの静的IPv4アドレスが割り当てられます）
  # - "DUAL_STACK": IPv4とIPv6の両方を使用（2つのIPv4と2つのIPv6アドレスが割り当てられます）
  #
  # Dual-stackの場合:
  # - 合計4つの静的IPアドレスが提供されます（IPv4 x 2、IPv6 x 2）
  # - デュアルスタック用のDNS名が追加で割り当てられます
  #   例: "a1234567890abcdef.dualstack.awsglobalaccelerator.com"
  # - Custom routing acceleratorではdual-stackはサポートされていません
  #
  # 注意: ネットワークゾーンあたり1つのIPアドレスが提供されます。
  # ネットワークゾーンはAWSアベイラビリティゾーンと同様の分離されたユニットで、
  # 1つのアドレスが利用できなくなった場合でも、他のネットワークゾーンから
  # 正常なIPアドレスでクライアントアプリケーションが再試行できます。
  ip_address_type = "IPV4"

  # (Optional) BYOIP（Bring Your Own IP）アクセラレータで使用するIPアドレス
  # デフォルト値: null（サービスがIPアドレスを割り当てます）
  #
  # BYOIP機能を使用する場合:
  # - オンプレミスネットワークから独自のIPv4アドレス範囲をAWSに持ち込むことができます
  # - AWSがインターネット上でこれらのIPアドレスをアドバタイズしますが、所有権は継続します
  # - 同じIPアドレスを複数のAWSサービスで使用することはできません
  # - アドレス範囲をAWSに持ち込む前に、他の場所からのアドバタイズを停止する必要があります
  # - IPv4のみサポート（IPv6はサポートされていません）
  #
  # 有効な値: 1つまたは2つのIPv4アドレス
  #
  # 例:
  # ip_addresses = ["1.2.3.4"]  # 1つのBYOIP IPv4アドレス
  # ip_addresses = ["1.2.3.4", "5.6.7.8"]  # 2つのBYOIP IPv4アドレス
  #
  # BYOIPアドレスを1つ指定した場合:
  # - AWSは2つ目の静的IPアドレスをAmazon IPアドレス範囲から自動的に割り当てます
  #
  # 注意: BYOIPアドレスを使用する場合、事前にアドレス範囲をプロビジョニングし、
  # アドバタイズする必要があります。詳細はBYOIPドキュメントを参照してください。
  # ip_addresses = ["1.2.3.4"]

  # (Optional) アクセラレータが有効かどうかを示します
  # デフォルト値: true
  # 有効な値: true, false
  #
  # false に設定した場合:
  # - アクセラレータはトラフィックを受け入れたりルーティングしたりしません
  # - 静的IPアドレスはアクセラレータに割り当てられたままです
  # - アクセラレータを削除すると、静的IPアドレスは失われ、トラフィックを
  #   ルーティングできなくなります
  #
  # IAMポリシー（タグベースの権限など）を使用して、アクセラレータを削除する
  # 権限を持つユーザーを制限できます。
  enabled = true

  ################################################################################
  # Flow Logs設定
  ################################################################################
  # Flow Logsは、アクセラレータのネットワークインターフェースとの間で送受信される
  # IPアドレストラフィックに関する情報をキャプチャします。ログはAmazon S3に
  # 公開され、データを取得して表示できます。
  #
  # Flow Logsの用途:
  # - ネットワークの問題を診断する
  # - エンドポイントへのトラフィックを監視する
  # - トラフィックフローの分析とトラブルシューティング
  #
  # 注意: Flow LogsをAmazon S3に直接公開する場合でも、CloudWatch Logsの
  # 料金が適用されます。

  attributes {
    # (Optional) Flow Logsが有効かどうかを示します
    # デフォルト値: false
    # 有効な値: true, false
    #
    # true に設定した場合:
    # - flow_logs_s3_bucket と flow_logs_s3_prefix の両方を指定する必要があります
    # - S3バケットが存在し、Global Acceleratorに書き込み権限を付与する
    #   バケットポリシーが必要です
    flow_logs_enabled = false

    # (Optional) Flow Logs用のAmazon S3バケット名
    # flow_logs_enabled が true の場合は必須です
    #
    # 要件:
    # - バケットは事前に存在している必要があります
    # - バケットポリシーでAWS Global Acceleratorに書き込み権限を付与する必要があります
    #
    # バケットポリシーの例:
    # {
    #   "Version": "2012-10-17",
    #   "Statement": [
    #     {
    #       "Sid": "AWSLogDeliveryAclCheck",
    #       "Effect": "Allow",
    #       "Principal": {
    #         "Service": "globalaccelerator.amazonaws.com"
    #       },
    #       "Action": "s3:GetBucketAcl",
    #       "Resource": "arn:aws:s3:::my-flow-logs-bucket"
    #     },
    #     {
    #       "Sid": "AWSLogDeliveryWrite",
    #       "Effect": "Allow",
    #       "Principal": {
    #         "Service": "globalaccelerator.amazonaws.com"
    #       },
    #       "Action": "s3:PutObject",
    #       "Resource": "arn:aws:s3:::my-flow-logs-bucket/*"
    #     }
    #   ]
    # }
    # flow_logs_s3_bucket = "my-flow-logs-bucket"

    # (Optional) Flow Logs用のAmazon S3バケット内のロケーションのプレフィックス
    # flow_logs_enabled が true の場合は必須です
    #
    # プレフィックスの動作:
    # - スラッシュ (/) を指定した場合、ログファイルのバケットフォルダ構造に
    #   ダブルスラッシュ (//) が含まれます
    # - 組織的なログ管理のために論理的なプレフィックスを使用することを推奨します
    #
    # 例:
    # - "flow-logs/" → logs/flow-logs//AWSLogs/...
    # - "accelerator/production/" → logs/accelerator/production//AWSLogs/...
    # - "" → logs/AWSLogs/...（プレフィックスなし）
    #
    # Flow Logsファイルのパス構造:
    # s3://bucket-name/prefix/AWSLogs/account-id/globalaccelerator/region/yyyy/mm/dd/
    # flow_logs_s3_prefix = "flow-logs/"
  }

  ################################################################################
  # タグ
  ################################################################################
  # (Optional) リソースに割り当てるタグのマップ
  # プロバイダーのdefault_tags設定ブロックと併用できます。
  #
  # タグの用途:
  # - リソースの識別と分類
  # - コスト配分とトラッキング
  # - IAMポリシーによるアクセス制御（タグベースの権限）
  # - 自動化とフィルタリング
  #
  # 推奨されるタグ:
  # - Environment: リソースの環境を示します（例: production, staging, development）
  # - Project: プロジェクト名またはアプリケーション名
  # - Owner: リソースの所有者またはチーム
  # - CostCenter: コスト配分用
  #
  # 例:
  # tags = {
  #   Name        = "production-api-accelerator"
  #   Environment = "production"
  #   Project     = "global-api"
  #   ManagedBy   = "terraform"
  #   Owner       = "platform-team"
  #   CostCenter  = "engineering"
  # }
  tags = {
    Name        = "example-accelerator"
    Environment = "development"
    ManagedBy   = "terraform"
  }
}

################################################################################
# 出力値（Computed Attributes）
################################################################################
# このリソースは以下の属性を計算して返します（これらは読み取り専用です）：
#
# - id: アクセラレータのAmazon Resource Name (ARN)
#   例: "arn:aws:globalaccelerator::123456789012:accelerator/1234abcd-abcd-1234-abcd-1234abcdefgh"
#
# - arn: アクセラレータのAmazon Resource Name (ARN)（idと同じ）
#   例: "arn:aws:globalaccelerator::123456789012:accelerator/1234abcd-abcd-1234-abcd-1234abcdefgh"
#
# - dns_name: アクセラレータのDNS名
#   静的IPアドレスを指すデフォルトのDNS名が割り当てられます
#   例: "a5d53ff5ee6bca4ce.awsglobalaccelerator.com"
#   用途: DNSレコードを使用してトラフィックをルーティングする場合に使用
#
# - dual_stack_dns_name: デュアルスタックアクセラレータの4つの静的IPアドレスを
#   指すDNS名（IPv4 x 2、IPv6 x 2）
#   ip_address_type が "DUAL_STACK" の場合にのみ設定されます
#   例: "a1234567890abcdef.dualstack.awsglobalaccelerator.com"
#   用途: IPv4とIPv6の両方をサポートするアプリケーション
#
# - hosted_zone_id: Route 53でエイリアスリソースレコードセットをGlobal Acceleratorに
#   ルーティングするために使用できるホストゾーンID
#   固定値: "Z2BJ6XQ5FK7U4H"（すべてのGlobal Acceleratorで共通）
#   用途: Route 53エイリアスレコードの作成時に使用
#
# - ip_sets: アクセラレータに関連付けられたIPアドレスセット
#   構造:
#   - ip_addresses: IPアドレスセット内のIPアドレスのリスト
#     IPv4の場合: 2つのIPv4アドレス
#     Dual-stackの場合: 2つのIPv4アドレスと2つのIPv6アドレス
#   - ip_family: IPアドレスセットに含まれるIPアドレスのタイプ
#     値: "IPv4" または "IPv6"
#
# - tags_all: リソースに割り当てられたタグのマップ（プロバイダーのdefault_tags
#   設定ブロックから継承されたタグを含む）

################################################################################
# 使用例
################################################################################

# 例1: 基本的なIPv4アクセラレータ
resource "aws_globalaccelerator_accelerator" "basic" {
  name    = "basic-accelerator"
  enabled = true

  tags = {
    Name = "basic-accelerator"
  }
}

# 例2: Flow Logsを有効にしたアクセラレータ
resource "aws_globalaccelerator_accelerator" "with_flow_logs" {
  name            = "accelerator-with-logs"
  ip_address_type = "IPV4"
  enabled         = true

  attributes {
    flow_logs_enabled   = true
    flow_logs_s3_bucket = "my-flow-logs-bucket"
    flow_logs_s3_prefix = "accelerator-logs/"
  }

  tags = {
    Name        = "accelerator-with-logs"
    Environment = "production"
  }
}

# 例3: デュアルスタック（IPv4 + IPv6）アクセラレータ
resource "aws_globalaccelerator_accelerator" "dual_stack" {
  name            = "dual-stack-accelerator"
  ip_address_type = "DUAL_STACK"
  enabled         = true

  tags = {
    Name        = "dual-stack-accelerator"
    Environment = "production"
  }
}

# 例4: BYOIP（Bring Your Own IP）を使用したアクセラレータ
# 注意: BYOIPアドレスは事前にプロビジョニングおよびアドバタイズされている必要があります
resource "aws_globalaccelerator_accelerator" "byoip" {
  name            = "byoip-accelerator"
  ip_address_type = "IPV4"
  ip_addresses    = ["203.0.113.27"] # 自分のIPアドレス範囲からのIP
  enabled         = true

  tags = {
    Name        = "byoip-accelerator"
    Environment = "production"
  }
}

# 例5: 一時的に無効化されたアクセラレータ
# メンテナンスやテスト時に使用
resource "aws_globalaccelerator_accelerator" "disabled" {
  name    = "disabled-accelerator"
  enabled = false # トラフィックを受け入れないがIPアドレスは保持

  tags = {
    Name   = "disabled-accelerator"
    Status = "maintenance"
  }
}

################################################################################
# 出力例
################################################################################

output "accelerator_id" {
  description = "アクセラレータのARN"
  value       = aws_globalaccelerator_accelerator.example.id
}

output "accelerator_dns_name" {
  description = "アクセラレータのDNS名"
  value       = aws_globalaccelerator_accelerator.example.dns_name
}

output "accelerator_ip_addresses" {
  description = "アクセラレータに割り当てられた静的IPアドレス"
  value       = aws_globalaccelerator_accelerator.example.ip_sets[0].ip_addresses
}

output "accelerator_hosted_zone_id" {
  description = "Route 53エイリアスレコード用のホストゾーンID"
  value       = aws_globalaccelerator_accelerator.example.hosted_zone_id
}

# デュアルスタックの場合の出力例
output "dual_stack_dns_name" {
  description = "デュアルスタックアクセラレータのDNS名"
  value       = try(aws_globalaccelerator_accelerator.dual_stack.dual_stack_dns_name, null)
}

################################################################################
# 関連リソース
################################################################################
# Global Acceleratorを完全に設定するには、以下のリソースも必要です：
#
# 1. aws_globalaccelerator_listener
#    - ポート（またはポート範囲）とプロトコルに基づいてクライアントからの
#      インバウンド接続を処理します
#    - TCP、UDP、またはその両方のプロトコルを設定できます
#
# 2. aws_globalaccelerator_endpoint_group
#    - 特定のAWSリージョンに関連付けられます
#    - リージョン内の1つ以上のエンドポイントを含みます
#    - トラフィックダイヤルを使用してトラフィックの割合を調整できます
#
# 3. aws_globalaccelerator_endpoint
#    - Network Load Balancer、Application Load Balancer、EC2インスタンス、
#      またはElastic IPアドレスが指定できます
#    - 重みを設定してトラフィックの割合を制御できます
#
# 典型的な構成順序:
# Accelerator → Listener → Endpoint Group → Endpoint

################################################################################
# 重要な考慮事項
################################################################################
#
# 1. 静的IPアドレスの永続性:
#    - アクセラレータを無効化（enabled = false）しても、静的IPアドレスは保持されます
#    - アクセラレータを削除すると、静的IPアドレスは失われ、再利用できません
#    - 誤削除を防ぐため、IAMポリシーで削除権限を制限することを推奨します
#
# 2. ネットワークゾーンと可用性:
#    - Global Acceleratorは2つのネットワークゾーンから静的IPアドレスを提供します
#    - 1つのIPアドレスが利用不可になっても、もう1つのIPアドレスで継続できます
#    - これにより高可用性が実現されます
#
# 3. Flow Logsのコスト:
#    - Flow LogsをS3に直接公開する場合でも、CloudWatch Logsの料金が発生します
#    - S3ストレージコストも考慮する必要があります
#    - 必要な場合のみFlow Logsを有効化してください
#
# 4. デュアルスタック（DUAL_STACK）の制限:
#    - Custom routing acceleratorではサポートされていません
#    - Standard acceleratorでのみ使用可能です
#
# 5. BYOIPの要件:
#    - IPv4アドレス範囲のみサポート（IPv6は非サポート）
#    - アドレス範囲を持ち込む前に、他の場所からのアドバタイズを停止する必要があります
#    - 同じIPアドレスを複数のAWSサービスで使用できません
#    - 事前にアドレス範囲のプロビジョニングとアドバタイズが必要です
#
# 6. DNSアドレッシング:
#    - 静的IPアドレスまたはDNS名を使用してトラフィックをルーティングできます
#    - Route 53でカスタムドメイン名を設定することも可能です
#    - hosted_zone_id を使用してRoute 53エイリアスレコードを作成できます
#
# 7. タグベースのアクセス制御:
#    - タグを使用してIAMポリシーでアクセス制御を実装できます
#    - 特定のタグを持つリソースのみを操作できるように制限可能です
#
# 8. リージョン:
#    - Global Acceleratorはグローバルサービスですが、リソースはus-west-2リージョンに
#      作成されます
#    - プロバイダーの設定で適切なリージョンを指定してください

################################################################################
# セキュリティのベストプラクティス
################################################################################
#
# 1. Flow Logsの有効化:
#    - セキュリティ監査とトラブルシューティングのため、本番環境では有効化を推奨
#    - Amazon Athenaを使用してFlow Logsを分析できます
#
# 2. S3バケットのセキュリティ:
#    - Flow Logs用のS3バケットには適切なバケットポリシーを設定
#    - 暗号化を有効化（SSE-S3またはSSE-KMS）
#    - バケットのバージョニングとライフサイクルポリシーを検討
#
# 3. IAM権限の最小化:
#    - アクセラレータの作成・削除には慎重な権限管理が必要
#    - タグベースのポリシーを使用して権限を細かく制御
#
# 4. タグ付けの標準化:
#    - 一貫したタグ付け戦略を実装
#    - Environment、Owner、CostCenterなどの必須タグを定義
#
# 5. モニタリング:
#    - CloudWatch メトリクスを使用してアクセラレータのパフォーマンスを監視
#    - アラームを設定して異常なトラフィックパターンを検出
