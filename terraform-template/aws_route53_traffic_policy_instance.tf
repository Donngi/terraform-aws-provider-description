#---------------------------------------------------------------
# Amazon Route 53 Traffic Policy Instance
#---------------------------------------------------------------
#
# Amazon Route 53のトラフィックポリシーインスタンスをプロビジョニングするリソースです。
# 指定したホストゾーンにトラフィックポリシーの設定に基づいてリソースレコードセットを
# 作成し、ドメインまたはサブドメイン名と関連付けます。
#
# AWS公式ドキュメント:
#   - TrafficPolicyInstance: https://docs.aws.amazon.com/Route53/latest/APIReference/API_TrafficPolicyInstance.html
#   - CreateTrafficPolicyInstance: https://docs.aws.amazon.com/Route53/latest/APIReference/API_CreateTrafficPolicyInstance.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_traffic_policy_instance
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_route53_traffic_policy_instance" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: Amazon Route 53がDNSクエリに応答するドメイン名を指定します。
  #           Route 53はこのドメイン名に対してリソースレコードセットを作成します。
  # 設定可能な値: 完全修飾ドメイン名（FQDN）。例: "test.example.com"
  # 参考: https://docs.aws.amazon.com/Route53/latest/APIReference/API_TrafficPolicyInstance.html
  name = "test.example.com"

  # hosted_zone_id (Required)
  # 設定内容: Route 53がトラフィックポリシーの設定に基づいてリソースレコードセットを
  #           作成するホストゾーンのIDを指定します。
  # 設定可能な値: Route 53ホストゾーンID（例: "Z033120931TAQO548OGJC"）
  # 参考: https://docs.aws.amazon.com/Route53/latest/APIReference/API_TrafficPolicyInstance.html
  hosted_zone_id = "Z033120931TAQO548OGJC"

  #-------------------------------------------------------------
  # トラフィックポリシー設定
  #-------------------------------------------------------------

  # traffic_policy_id (Required)
  # 設定内容: 指定したホストゾーンでリソースレコードセットを作成するために使用する
  #           トラフィックポリシーのIDを指定します。
  # 設定可能な値: トラフィックポリシーID（例: "b3gb108f-ea6f-45a5-baab-9d112d8b4037"）
  # 参考: https://docs.aws.amazon.com/Route53/latest/APIReference/API_TrafficPolicyInstance.html
  traffic_policy_id = "b3gb108f-ea6f-45a5-baab-9d112d8b4037"

  # traffic_policy_version (Required)
  # 設定内容: 指定したホストゾーンでリソースレコードセットを作成するために使用する
  #           トラフィックポリシーのバージョンを指定します。
  # 設定可能な値: 1〜1000の整数
  # 参考: https://docs.aws.amazon.com/Route53/latest/APIReference/API_TrafficPolicyInstance.html
  traffic_policy_version = 1

  #-------------------------------------------------------------
  # DNS設定
  #-------------------------------------------------------------

  # ttl (Required)
  # 設定内容: Route 53が指定ホストゾーンに作成するすべてのリソースレコードセットに
  #           割り当てるTTL（Time To Live）を秒単位で指定します。
  # 設定可能な値: 0〜2147483647の整数（秒）
  # 参考: https://docs.aws.amazon.com/Route53/latest/APIReference/API_TrafficPolicyInstance.html
  ttl = 360
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: トラフィックポリシーインスタンスのID
#
# - arn: トラフィックポリシーインスタンスのAmazon Resource Name (ARN)
#---------------------------------------------------------------
