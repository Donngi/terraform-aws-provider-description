################################################################################
# AWS EC2 Traffic Mirror Filter Rule
################################################################################
# Provides an Traffic mirror filter rule.
# Read limits and considerations for traffic mirroring:
# https://docs.aws.amazon.com/vpc/latest/mirroring/traffic-mirroring-considerations.html
#
# このリソースは、トラフィックミラーフィルタールールを作成します。
# トラフィックミラーリングの制限と考慮事項を確認してください。

resource "aws_ec2_traffic_mirror_filter_rule" "example" {
  ################################################################################
  # Required Arguments
  ################################################################################

  # ID of the traffic mirror filter to which this rule should be added
  # このルールを追加するトラフィックミラーフィルターのID
  # Example: aws_ec2_traffic_mirror_filter.filter.id
  traffic_mirror_filter_id = aws_ec2_traffic_mirror_filter.filter.id

  # Destination CIDR block to assign to the Traffic Mirror rule
  # トラフィックミラールールに割り当てる宛先CIDRブロック
  # Example: "10.0.0.0/8", "0.0.0.0/0"
  destination_cidr_block = "10.0.0.0/8"

  # Source CIDR block to assign to the Traffic Mirror rule
  # トラフィックミラールールに割り当てる送信元CIDRブロック
  # Example: "10.0.0.0/8", "0.0.0.0/0"
  source_cidr_block = "10.0.0.0/8"

  # Action to take (accept | reject) on the filtered traffic
  # フィルタリングされたトラフィックに対して実行するアクション
  # Valid values: "accept", "reject"
  rule_action = "accept"

  # Number of the Traffic Mirror rule
  # トラフィックミラールールの番号
  # This number must be unique for each Traffic Mirror rule in a given direction
  # この番号は、特定の方向の各トラフィックミラールールに対して一意である必要があります
  # The rules are processed in ascending order by rule number
  # ルールは、ルール番号の昇順で処理されます
  # Example: 1, 100, 200
  rule_number = 1

  # Direction of traffic to be captured
  # キャプチャするトラフィックの方向
  # Valid values: "ingress", "egress"
  traffic_direction = "ingress"

  ################################################################################
  # Optional Arguments
  ################################################################################

  # Description of the traffic mirror filter rule
  # トラフィックミラーフィルタールールの説明
  # Example: "Allow SSH traffic", "Block HTTP traffic"
  description = "test rule"

  # Protocol number to assign to the Traffic Mirror rule
  # トラフィックミラールールに割り当てるプロトコル番号
  # For example: 6 (TCP), 17 (UDP), 1 (ICMP)
  # For information about the protocol value, see Protocol Numbers:
  # https://www.iana.org/assignments/protocol-numbers/protocol-numbers.xhtml
  # Example: 6 (TCP), 17 (UDP)
  protocol = 6

  # Region where this resource will be managed
  # このリソースが管理されるリージョン
  # Defaults to the Region set in the provider configuration
  # プロバイダー設定で設定されたリージョンにデフォルト設定されます
  # Example: "us-east-1", "ap-northeast-1"
  # region = "us-east-1"

  ################################################################################
  # Destination Port Range
  ################################################################################
  # Supported only when the protocol is set to TCP(6) or UDP(17)
  # プロトコルがTCP(6)またはUDP(17)に設定されている場合にのみサポートされます

  destination_port_range {
    # Starting port of the range
    # 範囲の開始ポート
    # Example: 22, 80, 443
    from_port = 22

    # Ending port of the range
    # 範囲の終了ポート
    # Example: 22, 80, 443
    to_port = 53
  }

  ################################################################################
  # Source Port Range
  ################################################################################
  # Supported only when the protocol is set to TCP(6) or UDP(17)
  # プロトコルがTCP(6)またはUDP(17)に設定されている場合にのみサポートされます

  source_port_range {
    # Starting port of the range
    # 範囲の開始ポート
    # Example: 0, 1024, 49152
    from_port = 0

    # Ending port of the range
    # 範囲の終了ポート
    # Example: 65535, 49151, 10
    to_port = 10
  }

  ################################################################################
  # Computed Attributes (Output Only)
  ################################################################################
  # The following attributes are exported:
  # 以下の属性がエクスポートされます:
  #
  # - id: Name of the traffic mirror filter rule
  #   トラフィックミラーフィルタールールの名前
  #
  # - arn: ARN of the traffic mirror filter rule
  #   トラフィックミラーフィルタールールのARN
}

################################################################################
# Example: Traffic Mirror Filter (Dependency)
################################################################################

resource "aws_ec2_traffic_mirror_filter" "filter" {
  description = "traffic mirror filter - terraform example"

  # Network services to mirror
  # ミラーリングするネットワークサービス
  # Example: ["amazon-dns"]
  network_services = ["amazon-dns"]
}

################################################################################
# Example: Egress Rule
################################################################################

resource "aws_ec2_traffic_mirror_filter_rule" "egress_example" {
  description              = "egress rule example"
  traffic_mirror_filter_id = aws_ec2_traffic_mirror_filter.filter.id
  destination_cidr_block   = "10.0.0.0/8"
  source_cidr_block        = "10.0.0.0/8"
  rule_number              = 1
  rule_action              = "accept"
  traffic_direction        = "egress"
}

################################################################################
# Example: Ingress Rule with Port Ranges
################################################################################

resource "aws_ec2_traffic_mirror_filter_rule" "ingress_example" {
  description              = "ingress rule example"
  traffic_mirror_filter_id = aws_ec2_traffic_mirror_filter.filter.id
  destination_cidr_block   = "10.0.0.0/8"
  source_cidr_block        = "10.0.0.0/8"
  rule_number              = 1
  rule_action              = "accept"
  traffic_direction        = "ingress"
  protocol                 = 6

  destination_port_range {
    from_port = 22
    to_port   = 53
  }

  source_port_range {
    from_port = 0
    to_port   = 10
  }
}
