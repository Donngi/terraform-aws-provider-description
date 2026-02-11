#---------------------------------------------------------------
# AWS IoT Topic Rule Destination
#---------------------------------------------------------------
#
# AWS IoT Topic Rule Destinationは、IoTルールエンジンがデータをルーティングできる
# 宛先を定義するリソースです。このリソースはVPC内のApache Kafkaクラスタなどに
# データを送信するために使用されます。
#
# VPC Destination機能により、IoTルールエンジンは指定されたサブネット内に
# Elastic Network Interface (ENI) を作成し、VPC内のリソースへの安全な
# 通信を確立します。
#
# AWS公式ドキュメント:
#   - Virtual private cloud (VPC) destinations: https://docs.aws.amazon.com/iot/latest/developerguide/vpc-rule-action.html
#   - Working with HTTP topic rule destinations: https://docs.aws.amazon.com/iot/latest/developerguide/rule-destination.html
#   - CreateTopicRuleDestination API: https://docs.aws.amazon.com/iot/latest/apireference/API_CreateTopicRuleDestination.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iot_topic_rule_destination
#
# Provider Version: 6.28.0
# Generated: 2026-01-28
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_iot_topic_rule_destination" "example" {
  #---------------------------------------------------------------
  # Required Arguments
  #---------------------------------------------------------------

  # VPCの構成設定
  # IoTルールエンジンがVPC内のリソース（Apache Kafkaクラスタなど）に
  # アクセスするための設定を定義します。
  # ルールエンジンは指定された各サブネットにElastic Network Interface (ENI)を作成します。
  # 参考: https://docs.aws.amazon.com/iot/latest/developerguide/vpc-rule-action.html
  vpc_configuration {
    # (Required) ENIの作成とアタッチの権限を持つIAMロールのARN
    # このロールには以下の権限が必要です:
    # - ec2:CreateNetworkInterface
    # - ec2:DescribeNetworkInterfaces
    # - ec2:DescribeVpcs
    # - ec2:DeleteNetworkInterface
    # - ec2:DescribeSubnets
    # - ec2:DescribeVpcAttribute
    # - ec2:DescribeSecurityGroups
    # - ec2:CreateNetworkInterfacePermission
    # - ec2:CreateTags
    role_arn = "arn:aws:iam::123456789012:role/iot-vpc-destination-role"

    # (Required) VPCのサブネットIDのリスト
    # ルールエンジンは各サブネットに1つのネットワークインターフェースを作成します。
    # 高可用性のために複数のサブネットを指定することを推奨します。
    subnet_ids = ["subnet-12345678", "subnet-87654321"]

    # (Required) VPCのID
    # Topic Rule Destinationが作成されるVPCを指定します。
    vpc_id = "vpc-12345678"

    # (Optional) VPCのセキュリティグループのリスト
    # ネットワークインターフェースに適用されるセキュリティグループです。
    # 指定しない場合、VPCのデフォルトセキュリティグループが使用されます。
    security_groups = ["sg-12345678"]
  }

  #---------------------------------------------------------------
  # Optional Arguments
  #---------------------------------------------------------------

  # (Optional) Destinationを有効にするかどうか
  # Default: true
  # VPC Topic Rule Destinationが30日間連続でトラフィックを受信しない場合、
  # 自動的に無効化されます。また、VPCやサブネット、セキュリティグループ、
  # ロールなどのリソースが変更または削除された場合も無効化されます。
  enabled = true

  # (Optional) このリソースが管理されるリージョン
  # プロバイダー設定のリージョンがデフォルト値として使用されます。
  # 明示的に指定することで、プロバイダーとは異なるリージョンで
  # リソースを管理できます。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-east-1"

  #---------------------------------------------------------------
  # Timeouts
  #---------------------------------------------------------------

  # リソース操作のタイムアウト設定
  # デフォルトのタイムアウト値で問題が発生する場合に調整します。
  timeouts {
    # リソース作成時のタイムアウト（デフォルト値が使用されます）
    # create = "10m"

    # リソース更新時のタイムアウト（デフォルト値が使用されます）
    # update = "10m"

    # リソース削除時のタイムアウト（デフォルト値が使用されます）
    # delete = "10m"
  }
}

#---------------------------------------------------------------
# Attributes Reference
#---------------------------------------------------------------
# このリソースをデプロイ後、以下の属性が参照可能になります（computed属性）:
#
# - arn: Topic Rule DestinationのARN
#        例: arn:aws:iot:us-east-1:123456789012:ruledestination/vpc/abc123
#
# - id: Destinationの一意識別子（通常はARNと同じ値）
#
#---------------------------------------------------------------
# 使用例
#---------------------------------------------------------------
# 1. Apache Kafkaクラスタへの接続用Destination
#    VPC内のKafkaクラスタにIoTルールからデータを送信する場合に使用
#
# 2. プライベートエンドポイントへのHTTP送信
#    VPC内のプライベートエンドポイントにデータを送信する場合に使用
#
#---------------------------------------------------------------
# 注意事項
#---------------------------------------------------------------
# - VPC Destinationを無効化してから再度有効化した場合、新しいENIに
#   Elastic IPアドレスを再関連付けする必要があります
#
# - パブリックエンドポイントのKafkaクラスタに接続する場合は、
#   サブネット用のNATゲートウェイを作成する必要があります
#
# - VPC Destinationは料金が発生します。詳細はAWS IoT Core料金ページを
#   参照してください: https://aws.amazon.com/iot-core/pricing/
#
# - 30日間連続でトラフィックがない場合、自動的に無効化されます
#
# - 使用されているリソース（VPC、サブネット、セキュリティグループ、ロール）
#   が変更されると、Destinationは無効化されます
#
#---------------------------------------------------------------
