#---------------------------------------------------------------
# AWS EC2 Traffic Mirror Filter
#---------------------------------------------------------------
#
# VPC Traffic Mirroring のフィルターをプロビジョニングするリソースです。
# Traffic Mirror Filter は、ミラーリング対象のネットワークトラフィックを
# フィルタリングするためのルールセットを定義します。
# トラフィックミラーリングは、ネットワーク監視、脅威検出、トラブルシューティング
# などのユースケースで使用されます。
#
# AWS公式ドキュメント:
#   - Traffic Mirroring 概要: https://docs.aws.amazon.com/vpc/latest/mirroring/what-is-traffic-mirroring.html
#   - Traffic Mirroring の制限と考慮事項: https://docs.aws.amazon.com/vpc/latest/mirroring/traffic-mirroring-considerations.html
#   - Traffic Mirror Filters: https://docs.aws.amazon.com/vpc/latest/mirroring/traffic-mirroring-filters.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_traffic_mirror_filter
#
# Provider Version: 6.28.0
# Generated: 2026-02-04
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_ec2_traffic_mirror_filter" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # description (Optional, Forces new resource)
  # 設定内容: Traffic Mirror Filter の説明を指定します。
  # 設定可能な値: 文字列
  # 省略時: 説明なし
  # 注意: この値を変更すると、リソースが再作成されます（Forces new resource）
  description = "traffic mirror filter - terraform example"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効な AWS リージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # ネットワークサービス設定
  #-------------------------------------------------------------

  # network_services (Optional)
  # 設定内容: ミラーリングする Amazon ネットワークサービスのリストを指定します。
  # 設定可能な値:
  #   - "amazon-dns": Amazon DNS サービスへのトラフィックをミラーリング
  # 省略時: Amazon ネットワークサービスへのトラフィックはミラーリングされません
  # 関連機能: Traffic Mirroring
  #   Amazon が提供するネットワークサービス（DNS など）へのトラフィックを
  #   監視対象に含めるかどうかを制御します。
  network_services = ["amazon-dns"]

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWS リソースタグ付け
  #   プロバイダーレベルの default_tags 設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "example-traffic-mirror-filter"
    Environment = "production"
  }

  # tags_all (Optional, Computed)
  # 設定内容: プロバイダーの default_tags から継承されたタグを含む全タグのマップです。
  # 注意: 通常は明示的に設定せず、Terraform が自動計算します。
  # tags_all = {}
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: Traffic Mirror Filter の Amazon Resource Name (ARN)
#
# - id: Traffic Mirror Filter の ID (フィルター名)
#
# - tags_all: プロバイダーの default_tags 設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------

#---------------------------------------------------------------
#
# Traffic Mirror Filter は、Traffic Mirror Session と組み合わせて使用します。
# フィルタールールを定義するには、以下のリソースと組み合わせます：
#
# 1. aws_ec2_traffic_mirror_filter_rule (インバウンド/アウトバウンドルール)
#    - プロトコル、送信元/宛先 CIDR、ポート範囲などを指定
#
# 2. aws_ec2_traffic_mirror_target (ミラーリング先)
#    - Network Load Balancer または Network Interface を指定
#
# 3. aws_ec2_traffic_mirror_session (ミラーリングセッション)
#---------------------------------------------------------------
