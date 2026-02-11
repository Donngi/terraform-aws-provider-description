#---------------------------------------------------------------
# VPC Endpoint Route Table Association
#---------------------------------------------------------------
#
# VPCエンドポイントとルートテーブルの関連付けをプロビジョニングするリソースです。
# Gateway型VPCエンドポイント（S3、DynamoDBなど）を特定のルートテーブルに関連付け、
# そのルートテーブルに関連するサブネットからエンドポイント経由でサービスにアクセス
# できるようにします。
#
# AWS公式ドキュメント:
#   - Gateway endpoints: https://docs.aws.amazon.com/vpc/latest/privatelink/gateway-endpoints.html
#   - AssociateRouteTable API: https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_AssociateRouteTable.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint_route_table_association
#
# Provider Version: 6.28.0
# Generated: 2026-02-05
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_vpc_endpoint_route_table_association" "example" {
  #-------------------------------------------------------------
  # 識別子設定
  #-------------------------------------------------------------

  # id (Optional, Computed)
  # 設定内容: リソースの識別子を指定します。
  # 設定可能な値: 文字列
  # 省略時: Terraformが自動的にEC2ルートテーブルとVPCエンドポイント識別子の
  #         ハッシュ値を生成します。
  # 注意: 通常は省略し、Terraformに自動生成させることを推奨します。
  id = null

  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # route_table_id (Required)
  # 設定内容: VPCエンドポイントと関連付けるEC2ルートテーブルの識別子を指定します。
  # 設定可能な値: 有効なルートテーブルID（例: rtb-12345678）
  # 関連機能: Gateway Endpoints
  #   Gateway型VPCエンドポイントを使用する場合、各サブネットのルートテーブルに
  #   サービスへのトラフィックをゲートウェイエンドポイントに送信するルートが
  #   必要です。このリソースにより、指定したルートテーブルに自動的にエンドポイント
  #   ルートが追加されます。
  #   - https://docs.aws.amazon.com/vpc/latest/privatelink/gateway-endpoints.html
  route_table_id = aws_route_table.example.id

  # vpc_endpoint_id (Required)
  # 設定内容: ルートテーブルと関連付けるVPCエンドポイントの識別子を指定します。
  # 設定可能な値: 有効なVPCエンドポイントID（例: vpce-12345678）
  # 注意: Gateway型VPCエンドポイント（S3、DynamoDBなど）で使用されます。
  #       Interface型VPCエンドポイントの場合は、このリソースではなく
  #       サブネットとの関連付けを使用します。
  # 参考: https://docs.aws.amazon.com/vpc/latest/privatelink/gateway-endpoints.html
  vpc_endpoint_id = aws_vpc_endpoint.example.id

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: EC2ルートテーブルとVPCエンドポイント識別子のハッシュ値。
#       この値は関連付けの一意の識別子として使用されます。
#---------------------------------------------------------------
