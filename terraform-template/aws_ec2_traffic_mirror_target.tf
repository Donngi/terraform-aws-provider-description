#-------
# AWS EC2 Traffic Mirror Target
# https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/ec2_traffic_mirror_target
# Provider Version: 6.28.0
# Generated: 2026-02-15
#-------
# NOTE:
# - ターゲットタイプは network_interface_id / network_load_balancer_arn / gateway_load_balancer_endpoint_id のいずれか1つを必須指定
# - 複数のTraffic Mirrorセッションで同一ターゲットを共有可能
# - リージョンを跨いだミラーリングは不可（同一リージョン内のみ）
#-------

# Traffic Mirrorターゲット
# VPC Traffic MirroringでキャプチャしたトラフィックのコピーをENI/NLB/GWLB
# エンドポイントに転送するリソース。監視・侵入検知・パケット分析等のセキュリティ
# ユースケースで利用される。複数セッションで同一ターゲット共有可能。

resource "aws_ec2_traffic_mirror_target" "example" {
  #-------
  # ターゲット設定（いずれか1つ必須）
  #-------

  # ネットワークインターフェイスID（ENI）
  # 設定内容: トラフィックコピーの送信先となるENIのID
  # 設定可能な値: 有効なENI ID（eni-xxxxx形式）
  # 省略時: 他のターゲットタイプを指定する必要がある
  # 注: network_load_balancer_arn / gateway_load_balancer_endpoint_idと排他
  network_interface_id = "eni-0123456789abcdef0"

  # Network Load Balancer ARN
  # 設定内容: トラフィックコピーの送信先となるNLBのARN
  # 設定可能な値: 有効なNLB ARN
  # 省略時: 他のターゲットタイプを指定する必要がある
  # 注: network_interface_id / gateway_load_balancer_endpoint_idと排他
  network_load_balancer_arn = "arn:aws:elasticloadbalancing:us-east-1:123456789012:loadbalancer/net/my-nlb/50dc6c495c0c9188"

  # Gateway Load Balancer エンドポイントID
  # 設定内容: トラフィックコピーの送信先となるGWLBエンドポイントのID
  # 設定可能な値: 有効なGWLBエンドポイントID（vpce-xxxxx形式）
  # 省略時: 他のターゲットタイプを指定する必要がある
  # 注: network_interface_id / network_load_balancer_arnと排他
  gateway_load_balancer_endpoint_id = "vpce-0a1b2c3d4e5f67890"

  #-------
  # 基本設定
  #-------

  # 説明
  # 設定内容: ターゲットの説明文
  # 設定可能な値: 任意の文字列（最大255文字）
  # 省略時: 説明なし
  description = "Traffic mirror target for security monitoring"

  # リージョン設定
  # 設定内容: このリソースを管理するリージョン
  # 設定可能な値: AWS リージョン名（us-east-1, ap-northeast-1等）
  # 省略時: プロバイダー設定のリージョンを使用
  region = "us-east-1"

  #-------
  # タグ設定
  #-------

  # リソースタグ
  # 設定内容: ターゲットに付与するタグ
  # 設定可能な値: キーと値のペア（最大50個）
  # 省略時: タグなし
  tags = {
    Name        = "traffic-mirror-target"
    Environment = "production"
    Purpose     = "security-monitoring"
  }
}

#-------
# Attributes Reference
#-------

# このリソースをデプロイすると以下の属性を参照可能:
#
# - arn:        ターゲットのARN
# - id:         ターゲットID（tmt-xxxxx形式）
# - owner_id:   ターゲットを所有するAWSアカウントID
# - tags_all:   デフォルトタグとリソースタグをマージした全タグ
#
# 参照例:
#   Traffic Mirror SessionでのターゲットID指定
#     traffic_mirror_target_id = aws_ec2_traffic_mirror_target.example.id
