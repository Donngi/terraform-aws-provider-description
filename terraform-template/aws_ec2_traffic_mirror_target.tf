#==============================================================================
# AWS EC2 Traffic Mirror Target - 全プロパティ解説テンプレート
#==============================================================================
# このファイルについて:
#   - 生成日: 2026-01-22
#   - Provider Version: hashicorp/aws 6.28.0
#   - このテンプレートは生成時点の情報に基づいています
#   - 最新の仕様は公式ドキュメントを参照してください:
#     https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_traffic_mirror_target
#
# Traffic Mirror Targetについて:
#   Traffic Mirror Targetは、VPC Traffic Mirroringの宛先となるリソースです。
#   ミラーリングされたネットワークトラフィックのコピーを受信し、
#   監視や分析のために転送します。ターゲットとして以下の3種類が利用可能です:
#   - Network Interface (ENI)
#   - Network Load Balancer (NLB)
#   - Gateway Load Balancer Endpoint (GWLBE)
#
# 参考リンク:
#   - Traffic Mirroring Targets: https://docs.aws.amazon.com/vpc/latest/mirroring/traffic-mirroring-targets.html
#   - Traffic Mirroring概要: https://docs.aws.amazon.com/vpc/latest/mirroring/traffic-mirroring-considerations.html
#   - API Reference: https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_CreateTrafficMirrorTarget.html
#==============================================================================

resource "aws_ec2_traffic_mirror_target" "example" {
  #----------------------------------------------------------------------------
  # 必須設定なし - いずれか1つのターゲットタイプを指定
  #----------------------------------------------------------------------------

  #----------------------------------------------------------------------------
  # オプション設定
  #----------------------------------------------------------------------------

  # description: Traffic Mirror Targetの説明
  # - 用途や目的を明確にするための説明文
  # - Forces new: この値を変更すると新しいリソースが作成されます
  # - 例: "Production traffic analysis target", "Security monitoring NLB"
  description = "Example traffic mirror target"

  # network_interface_id: ターゲットとして使用するネットワークインターフェースのID
  # - ENIを直接ターゲットとして使用する場合に指定
  # - ミラーリングされたトラフィックは直接このENIに送信されます
  # - Forces new: この値を変更すると新しいリソースが作成されます
  # - 注意: network_load_balancer_arn, gateway_load_balancer_endpoint_id とは排他的
  #        (いずれか1つのみ指定可能)
  # - セキュリティグループでVXLAN traffic (UDP 4789) を許可する必要があります
  # - 例: "eni-1234567890abcdef0"
  network_interface_id = null

  # network_load_balancer_arn: ターゲットとして使用するNetwork Load BalancerのARN
  # - NLBをターゲットとして使用する場合に指定
  # - 高可用性が必要な場合に推奨されるオプション
  # - NLBはUDP 4789ポートでリスナーを設定する必要があります
  # - クロスゾーン負荷分散を有効化することが推奨されます
  # - Forces new: この値を変更すると新しいリソースが作成されます
  # - 注意: network_interface_id, gateway_load_balancer_endpoint_id とは排他的
  # - 例: "arn:aws:elasticloadbalancing:us-west-2:123456789012:loadbalancer/net/my-nlb/50dc6c495c0c9188"
  network_load_balancer_arn = null

  # gateway_load_balancer_endpoint_id: ターゲットとして使用するGateway Load Balancer EndpointのVPC Endpoint ID
  # - GWLBエンドポイントをターゲットとして使用する場合に指定
  # - セキュリティアプライアンスへのトラフィック転送に適しています
  # - クロスゾーン負荷分散を有効化することが推奨されます
  # - GWLBの最大MTUは8500です
  # - Forces new: この値を変更すると新しいリソースが作成されます
  # - 注意: network_interface_id, network_load_balancer_arn とは排他的
  # - 例: "vpce-1234567890abcdef0"
  gateway_load_balancer_endpoint_id = null

  # region: このリソースを管理するAWSリージョン
  # - 指定しない場合、プロバイダー設定のリージョンがデフォルトで使用されます
  # - トラフィックミラーソースとターゲットは同じVPCまたは
  #   VPCピアリング/Transit Gatewayで接続された異なるVPCに配置可能です
  # - 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # - 例: "us-west-2", "ap-northeast-1"
  region = null

  # tags: リソースに付与するタグ（キーと値のマップ）
  # - リソースの分類、管理、コスト配分などに使用
  # - provider default_tags と併用可能（マージされます）
  # - 例: { Environment = "production", Team = "security", Application = "traffic-analysis" }
  tags = {
    Name        = "example-traffic-mirror-target"
    Environment = "dev"
  }

  # tags_all: すべてのタグ（プロバイダーのdefault_tagsを含む）
  # - Computed属性のため、通常は明示的に設定する必要はありません
  # - provider設定のdefault_tagsとリソース固有のtagsがマージされた結果
  # - 明示的に設定する場合、provider default_tagsを上書きすることができます
  # tags_all = {}

  #----------------------------------------------------------------------------
  # 重要な注意事項
  #----------------------------------------------------------------------------
  # 1. ターゲットタイプの選択:
  #    - network_interface_id, network_load_balancer_arn, gateway_load_balancer_endpoint_id
  #      のいずれか1つのみを指定してください
  #    - 複数指定するとエラーになります
  #
  # 2. VXLANトラフィック:
  #    - ミラーリングされたトラフィックはVXLANパケットでカプセル化されます
  #    - ターゲットのセキュリティグループでVXLANトラフィック（UDP 4789）を許可する必要があります
  #    - ミラーリングターゲットの監視ソフトウェアはVXLANパケットを処理できる必要があります
  #
  # 3. ルーティング:
  #    - トラフィックミラーソースのサブネットのルートテーブルに、
  #      ミラーリングトラフィックをターゲットに送信するルートが必要があります
  #
  # 4. 高可用性:
  #    - 本番環境では、Network Load BalancerまたはGateway Load Balancer Endpointの
  #      使用が推奨されます（単一ENIよりも高い可用性）
  #
  # 5. Cross-VPC Mirroring:
  #    - ソースとターゲットは、VPCピアリングまたはTransit Gatewayで
  #      接続された異なるVPCに配置することができます
}

#==============================================================================
# Computed Attributes（参照のみ可能な属性）
#==============================================================================
# 以下の属性はTerraformによって自動的に計算され、参照のみ可能です:
#
# - arn: Traffic Mirror TargetのAmazon Resource Name (ARN)
#   - 例: "arn:aws:ec2:us-west-2:123456789012:traffic-mirror-target/tmt-1234567890abcdef0"
#   - 参照方法: aws_ec2_traffic_mirror_target.example.arn
#
# - id: Traffic Mirror TargetのID
#   - 例: "tmt-1234567890abcdef0"
#   - 参照方法: aws_ec2_traffic_mirror_target.example.id
#
# - owner_id: このTraffic Mirror Targetを所有するAWSアカウントのID
#   - 例: "123456789012"
#   - 参照方法: aws_ec2_traffic_mirror_target.example.owner_id
#==============================================================================

#==============================================================================
# 使用例
#==============================================================================

# 例1: Network Interfaceをターゲットとする
# resource "aws_ec2_traffic_mirror_target" "eni_target" {
#   description          = "ENI target for traffic analysis"
#   network_interface_id = aws_instance.monitor.primary_network_interface_id
#
#   tags = {
#     Name = "monitor-eni-target"
#   }
# }

# 例2: Network Load Balancerをターゲットとする
# resource "aws_ec2_traffic_mirror_target" "nlb_target" {
#   description               = "NLB target for distributed monitoring"
#   network_load_balancer_arn = aws_lb.monitor_nlb.arn
#
#   tags = {
#     Name = "monitor-nlb-target"
#   }
# }

# 例3: Gateway Load Balancer Endpointをターゲットとする
# resource "aws_ec2_traffic_mirror_target" "gwlb_target" {
#   description                       = "GWLB endpoint for security appliances"
#   gateway_load_balancer_endpoint_id = aws_vpc_endpoint.gwlb_endpoint.id
#
#   tags = {
#     Name = "security-gwlb-target"
#   }
# }

#==============================================================================
# 関連リソース
#==============================================================================
# - aws_ec2_traffic_mirror_session: Traffic Mirror Sessionの作成
# - aws_ec2_traffic_mirror_filter: トラフィックフィルタリングルールの定義
# - aws_lb: Network Load Balancerの作成
# - aws_vpc_endpoint: Gateway Load Balancer Endpointの作成
# - aws_network_interface: ネットワークインターフェースの作成
#==============================================================================
