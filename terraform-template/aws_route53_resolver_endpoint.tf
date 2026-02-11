################################################################################
# AWS Route 53 Resolver Endpoint
# https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/route53_resolver_endpoint
################################################################################

# Route 53 Resolver エンドポイントは、オンプレミスネットワークと AWS VPC 間での
# DNS クエリの転送を可能にするリソースです。
#
# 主な用途:
# - INBOUND: オンプレミス DNS からのクエリを VPC Resolver へ転送
#   - DEFAULT モード: IP アドレス指定による転送
#   - DELEGATION モード: サブドメインを VPC Resolver に委任
# - OUTBOUND: VPC からのクエリをオンプレミス DNS へ転送（Resolver ルールと併用）
#
# 重要な制約:
# - 最低 2 つ、最大 10 個の ip_address ブロックが必要
# - エンドポイント 1 つあたり最大 10,000 QPS（ENI あたり）
# - インバウンドエンドポイントは作成しただけでは VPC Resolver の動作を変更しない
# - 異なる AZ のサブネットに IP アドレスを配置して高可用性を確保
#
# 参考資料:
# - Resolver 概要: https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/resolver-overview-DSN-queries-to-vpc.html
# - ハイブリッド DNS パターン: https://docs.aws.amazon.com/whitepapers/latest/hybrid-cloud-dns-options-for-vpc/route-53-resolver-endpoints-and-forwarding-rules.html

resource "aws_route53_resolver_endpoint" "example" {
  # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  # 必須パラメータ
  # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  # (Required) DNS クエリの方向
  # - INBOUND: オンプレミス → VPC への DNS 転送
  # - OUTBOUND: VPC → オンプレミスへの DNS 転送（Resolver ルール経由）
  # - INBOUND_DELEGATION: サブドメインを Route 53 プライベートホストゾーンに委任
  #
  # 設計指針:
  # - INBOUND: オンプレミスから AWS リソースを名前解決する場合
  # - OUTBOUND: AWS から社内システムを名前解決する場合
  # - INBOUND_DELEGATION: サブドメイン単位で委任する場合
  direction = "INBOUND"

  # (Required) エンドポイントへのアクセスを制御するセキュリティグループ
  # - INBOUND: UDP/53, TCP/53 をオンプレミスネットワーク CIDR から許可
  # - OUTBOUND: UDP/53, TCP/53 をオンプレミス DNS サーバーへ許可
  # - DoH 使用時: TCP/443 も許可
  #
  # 注意事項:
  # - 作成後は変更不可（エンドポイント再作成が必要）
  # - 複数のセキュリティグループを指定可能
  # - VPC フローログで通信を監視することを推奨
  security_group_ids = [
    "sg-0123456789abcdef0",
  ]

  # (Required) DNS クエリが通過する IP アドレスとサブネット
  # - 最小 2 個、最大 10 個まで指定可能
  # - 高可用性のため、異なる AZ のサブネットに配置を推奨
  # - ENI あたり 10,000 QPS の処理能力
  #
  # ベストプラクティス:
  # - 本番環境: 最低 2 つの AZ に配置
  # - IP アドレスは手動指定を推奨（自動割り当ての追跡が困難なため）
  # - CloudWatch メトリクスでクエリボリュームを監視
  ip_address {
    # (Required) IP アドレスを配置するサブネット ID
    subnet_id = "subnet-0123456789abcdef0"

    # (Optional) IPv4 アドレスを手動指定
    # - 未指定時: サブネットから自動割り当て
    # - 指定時: サブネット CIDR 範囲内の利用可能な IP を指定
    #
    # 推奨:
    # - 運用管理の観点から手動指定を推奨
    # - オンプレミス DNS の転送先として明示的に設定
    ip = "10.0.1.10"

    # (Optional) IPv6 アドレスを手動指定
    # - resolver_endpoint_type が IPV6 または DUALSTACK の場合のみ使用
    # - ip と同時指定可能（DUALSTACK の場合）
    # ipv6 = "2001:db8:1234:1a00::10"
  }

  # 異なる AZ のサブネットに 2 番目の IP アドレスを配置（高可用性）
  ip_address {
    subnet_id = "subnet-0fedcba9876543210"
    ip        = "10.0.2.10"
  }

  # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  # オプションパラメータ
  # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  # (Optional) エンドポイントのわかりやすい名前
  # - 最大 64 文字
  # - 運用管理のため、命名規則に従った名前を推奨
  name = "example-resolver-endpoint"

  # (Optional) エンドポイントで使用するプロトコル
  # - Do53: 標準 DNS over Port 53（デフォルト）
  # - DoH: DNS over HTTPS（暗号化通信）
  # - DoH-FIPS: FIPS 140-2 準拠の DoH
  #
  # 注意事項:
  # - 複数指定可能（例: ["Do53", "DoH"]）
  # - DoH 使用時はセキュリティグループで TCP/443 を許可
  # - 未指定時は Do53 のみが有効
  protocols = ["Do53", "DoH"]

  # (Optional) エンドポイント IP アドレスのタイプ
  # - IPV4: IPv4 のみ（デフォルト）
  # - IPV6: IPv6 のみ
  # - DUALSTACK: IPv4 と IPv6 の両方
  #
  # 設計指針:
  # - 既存ネットワークが IPv4 のみの場合: IPV4
  # - IPv6 移行中または両方必要な場合: DUALSTACK
  # - すべての IP アドレスに適用される
  resolver_endpoint_type = "IPV4"

  # (Optional) RNI 拡張メトリクスの有効化
  # - true: RNI（Route 53 Network Inspector）の拡張メトリクスを有効化
  # - false: 無効化（デフォルト）
  #
  # 注意事項:
  # - 一度有効にした後、無効化する場合は明示的に false を指定
  # - 引数を削除するだけでは無効にならない
  # - 追加のメトリクスにより詳細な監視が可能
  # rni_enhanced_metrics_enabled = false

  # (Optional) ターゲットネームサーバーメトリクスの有効化
  # - true: OUTBOUND エンドポイントのネームサーバーメトリクスを有効化
  # - false: 無効化（デフォルト）
  #
  # 制約:
  # - OUTBOUND エンドポイントでのみサポート
  # - INBOUND エンドポイントでは使用不可
  # - 一度有効化後、無効化する場合は明示的に false を指定
  # target_name_server_metrics_enabled = false

  # (Optional) リソースに割り当てるタグ
  # - プロバイダーの default_tags と組み合わせ可能
  # - 環境、コスト配分、運用管理のためのタグ付けを推奨
  tags = {
    Name        = "example-resolver-endpoint"
    Environment = "production"
    ManagedBy   = "terraform"
  }

  # (Optional) リージョンの明示的指定
  # - 未指定時: プロバイダー設定のリージョンを使用
  # - クロスリージョン管理が必要な場合のみ指定
  # region = "us-east-1"

  # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  # タイムアウト設定
  # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  timeouts {
    # 作成タイムアウト（デフォルト: 10 分）
    create = "10m"

    # 更新タイムアウト（デフォルト: 10 分）
    update = "10m"

    # 削除タイムアウト（デフォルト: 10 分）
    delete = "10m"
  }
}

################################################################################
# 出力値（Computed Attributes）
################################################################################

# ARN（Amazon Resource Name）
# - エンドポイントの一意識別子
# - IAM ポリシーやリソースベースポリシーで使用
output "resolver_endpoint_arn" {
  description = "ARN of the Route 53 Resolver endpoint"
  value       = aws_route53_resolver_endpoint.example.arn
}

# エンドポイント ID
# - Resolver ルールでの参照に使用（OUTBOUND の場合）
# - AWS CLI/API での操作に使用
output "resolver_endpoint_id" {
  description = "ID of the Route 53 Resolver endpoint"
  value       = aws_route53_resolver_endpoint.example.id
}

# ホスト VPC ID
# - エンドポイントが作成された VPC の ID
# - サブネットから自動的に判定される
output "resolver_endpoint_host_vpc_id" {
  description = "ID of the VPC that contains the resolver endpoint"
  value       = aws_route53_resolver_endpoint.example.host_vpc_id
}

# すべてのタグ（プロバイダーの default_tags を含む）
# - リソース管理とタグ付け戦略の追跡に使用
output "resolver_endpoint_tags_all" {
  description = "Map of all tags assigned to the resource"
  value       = aws_route53_resolver_endpoint.example.tags_all
}

################################################################################
# 運用ノート
################################################################################

# 設計パターン:
# 1. 基本的なインバウンドエンドポイント:
#    - direction = "INBOUND"
#    - 2 つの AZ に IP アドレスを配置
#    - オンプレミス DNS から VPC Resolver へ転送
#
# 2. アウトバウンドエンドポイント（Resolver ルールと併用）:
#    - direction = "OUTBOUND"
#    - aws_route53_resolver_rule でドメインごとの転送ルールを定義
#    - target_name_server_metrics_enabled = true で監視強化
#
# 3. デュアルスタックエンドポイント:
#    - resolver_endpoint_type = "DUALSTACK"
#    - ip_address ブロックで ip と ipv6 の両方を指定
#    - IPv6 移行期間中のハイブリッド構成に最適
#
# 4. DoH 暗号化エンドポイント:
#    - protocols = ["DoH"]
#    - セキュリティグループで TCP/443 を許可
#    - PCI-DSS や HIPAA などのコンプライアンス要件に対応

# 監視とトラブルシューティング:
# - CloudWatch メトリクス:
#   - InboundQueryVolume: インバウンドクエリ数
#   - OutboundQueryVolume: アウトバウンドクエリ数
#   - OutboundQueryAggregateVolume: 集約クエリ数
# - VPC フローログで DNS トラフィック（UDP/53, TCP/53）を監視
# - Resolver クエリログを有効化して詳細な DNS クエリを記録
#   （aws_route53_resolver_query_log_config リソース）

# セキュリティのベストプラクティス:
# - セキュリティグループで送信元 IP を厳密に制限
# - DoH プロトコルを使用して DNS クエリを暗号化
# - CloudWatch Logs で異常なクエリパターンを監視
# - AWS WAF と組み合わせて DNS ベースの攻撃を防御

# コスト最適化:
# - エンドポイント時間料金: $0.125/時間（us-east-1）
# - クエリ料金: 最初の 10 億クエリまで $0.40/百万クエリ
# - 不要な IP アドレス（ENI）を削減してコストを最適化
# - CloudWatch メトリクスでクエリボリュームを監視して適切なサイズを維持

# 制限事項:
# - 1 リージョンあたり 4 つのエンドポイントまで（デフォルト）
# - 1 エンドポイントあたり 2～10 個の IP アドレス
# - ENI あたり 10,000 QPS の処理能力
# - 専有インスタンス（dedicated tenancy）の VPC では作成不可
# - 所有していない VPC にはエンドポイントを作成できない

# 高可用性の考慮事項:
# - 最低 2 つの AZ に IP アドレスを配置
# - オンプレミス側でも複数の DNS 転送先を設定
# - ヘルスチェックと自動フェイルオーバーを実装
# - Route 53 Resolver は AWS が管理する高可用性サービス

# マルチアカウント環境での運用:
# - AWS Resource Access Manager (RAM) で Resolver ルールを共有
# - Transit Gateway 経由で複数 VPC から 1 つのエンドポイントを利用
# - Route 53 Profiles でエンドポイント設定を一元管理
# - 共有サービス VPC に集約エンドポイントを配置
