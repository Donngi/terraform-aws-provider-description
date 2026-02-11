#---------------------------------------------------------------
# VPC Endpoint Connection Accepter
#---------------------------------------------------------------
#
# VPCエンドポイントサービスへのVPCエンドポイント接続受入れリクエストを
# 承認するためのリソースです。VPCエンドポイントサービスへの接続要求が
# 保留（pending-acceptance）状態になっている場合に、それを承認することで
# 接続を確立します。
#
# AWS公式ドキュメント:
#   - VPC Endpoint Connections: https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_VpcEndpointConnection.html
#   - Accept VPC Endpoint Connections: https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_AcceptVpcEndpointConnections.html
#   - Configure an endpoint service: https://docs.aws.amazon.com/vpc/latest/privatelink/configure-endpoint-service.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint_connection_accepter
#
# Provider Version: 6.28.0
# Generated: 2026-02-05
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_vpc_endpoint_connection_accepter" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # vpc_endpoint_service_id (Required)
  # 設定内容: VPCエンドポイントサービスのIDを指定します。
  # 設定可能な値: 有効なVPCエンドポイントサービスID（例: vpce-svc-xxxxxxxxxxxxxxxxx）
  # 注意: VPCエンドポイントサービスの所有者アカウントで、このリソースを作成する必要があります。
  # 参考: https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_AcceptVpcEndpointConnections.html
  vpc_endpoint_service_id = "vpce-svc-xxxxxxxxxxxxxxxxx"

  # vpc_endpoint_id (Required)
  # 設定内容: 接続を承認するVPCエンドポイントのIDを指定します。
  # 設定可能な値: 有効なVPCエンドポイントID（例: vpce-xxxxxxxxxxxxxxxxx）
  # 関連機能: VPC Endpoint Connection
  #   VPCエンドポイントとVPCエンドポイントサービス間の接続を確立します。
  #   接続リクエストは、サービス側で承認が必要な場合、pending-acceptance状態となります。
  #   - https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_VpcEndpointConnection.html
  vpc_endpoint_id = "vpce-xxxxxxxxxxxxxxxxx"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # その他の設定
  #-------------------------------------------------------------

  # id (Optional)
  # 設定内容: リソースのIDを指定します。
  # 省略時: Terraformが自動的にIDを生成します。
  # 注意: 通常、この属性を明示的に設定する必要はありません。
  id = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - vpc_endpoint_state: VPCエンドポイントの状態。
#                       PendingAcceptance, Pending, Available, Deleting,
#                       Deleted, Rejected, Failed, Expired, Partialのいずれかの値。
#---------------------------------------------------------------
