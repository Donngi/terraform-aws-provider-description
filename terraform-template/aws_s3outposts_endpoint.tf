#---------------------------------------------------------------
# AWS S3 on Outposts Endpoint
#---------------------------------------------------------------
#
# Amazon S3 on Outposts のエンドポイントをプロビジョニングするリソースです。
# エンドポイントは、Outpost 上の S3 アクセスポイントへのリクエストをルーティングし、
# VPC から Outpost バケットへのプライベート接続を実現します。
# 各 VPC につき 1 つのエンドポイントを関連付けることができ、
# 作成には最大 5 分かかる場合があります。
#
# AWS公式ドキュメント:
#   - S3 on Outposts のネットワーキング: https://docs.aws.amazon.com/AmazonS3/latest/s3-outposts/S3OutpostsNetworking.html
#   - エンドポイントの作成: https://docs.aws.amazon.com/AmazonS3/latest/s3-outposts/S3OutpostsCreateEndpoint.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3outposts_endpoint
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_s3outposts_endpoint" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # outpost_id (Required, Forces new resource)
  # 設定内容: エンドポイントを配置する Outpost の識別子を指定します。
  # 設定可能な値: 有効な Outpost ID（例: op-xxxxxxxxxxxxxxxxx）
  # 参考: https://docs.aws.amazon.com/outposts/latest/userguide/work-with-outposts.html
  outpost_id = "op-xxxxxxxxxxxxxxxxx"

  # subnet_id (Required, Forces new resource)
  # 設定内容: エンドポイントに関連付ける EC2 サブネットの識別子を指定します。
  # 設定可能な値: 有効なサブネット ID（例: subnet-xxxxxxxxxxxxxxxxx）
  # 注意: サブネットは Outpost と同じ VPC に属している必要があります。
  subnet_id = "subnet-xxxxxxxxxxxxxxxxx"

  # security_group_id (Required, Forces new resource)
  # 設定内容: エンドポイントに関連付ける EC2 セキュリティグループの識別子を指定します。
  # 設定可能な値: 有効なセキュリティグループ ID（例: sg-xxxxxxxxxxxxxxxxx）
  security_group_id = "sg-xxxxxxxxxxxxxxxxx"

  #-------------------------------------------------------------
  # ネットワークアクセス設定
  #-------------------------------------------------------------

  # access_type (Optional, Forces new resource)
  # 設定内容: ネットワーク接続のアクセスタイプを指定します。
  # 設定可能な値:
  #   - "Private": VPC ルーティングを使用したプライベートアクセス。
  #               VPC 内のインスタンスはパブリック IP アドレスなしで Outpost と通信可能。
  #               トラフィックは AWS ネットワーク内に留まります。
  #   - "CustomerOwnedIp": カスタマー所有 IP アドレスプールを使用したアクセス。
  #                        オンプレミスネットワークおよび VPC 内から S3 on Outposts に
  #                        アクセス可能。ローカルゲートウェイの帯域幅に制限されます。
  # 省略時: "Private" が使用されます。
  # 注意: "CustomerOwnedIp" を指定する場合は customer_owned_ipv4_pool の指定が必要です。
  # 参考: https://docs.aws.amazon.com/AmazonS3/latest/s3-outposts/S3OutpostsNetworking.html
  access_type = "Private"

  # customer_owned_ipv4_pool (Optional, Forces new resource)
  # 設定内容: カスタマー所有 IP アドレスプールの ID を指定します。
  # 設定可能な値: 有効な CoIP プール ID（例: ipv4pool-coip-xxxxxxxxxxxxxxxxx）
  # 省略時: access_type が "CustomerOwnedIp" の場合は必須です。"Private" の場合は不要です。
  # 参考: https://docs.aws.amazon.com/outposts/latest/userguide/local-rack.html#local-gateway-subnet
  customer_owned_ipv4_pool = null

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効な AWS リージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用します。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: エンドポイントの Amazon Resource Name (ARN)
# - cidr_block: エンドポイントの VPC CIDR ブロック
# - creation_time: エンドポイントの作成日時（RFC3339 形式の UTC 時刻）
# - network_interfaces: 関連付けられた Elastic Network Interface (ENI) のセット
#                       各要素の network_interface_id に ENI の識別子が格納されます
#---------------------------------------------------------------
