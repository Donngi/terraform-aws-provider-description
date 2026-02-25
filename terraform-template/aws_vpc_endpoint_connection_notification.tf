#---------------------------------------------------------------
# AWS VPC Endpoint Connection Notification
#---------------------------------------------------------------
#
# VPCエンドポイントまたはVPCエンドポイントサービスの接続イベントを
# Amazon SNSトピックへ通知するコネクション通知をプロビジョニングするリソースです。
# エンドポイントの承認・接続・削除・拒否などのイベントをSNSで受け取ることができます。
#
# AWS公式ドキュメント:
#   - CreateVpcEndpointConnectionNotification: https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_CreateVpcEndpointConnectionNotification.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint_connection_notification
#
# Provider Version: 6.28.0
# Generated: 2026-02-19
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_vpc_endpoint_connection_notification" "example" {
  #-------------------------------------------------------------
  # 通知先設定
  #-------------------------------------------------------------

  # connection_notification_arn (Required)
  # 設定内容: 通知の送信先となるSNSトピックのARNを指定します。
  # 設定可能な値: 有効なAmazon SNSトピックのARN
  # 注意: SNSトピックのアクセスポリシーで vpce.amazonaws.com にSNS:Publish権限を付与する必要があります。
  connection_notification_arn = "arn:aws:sns:ap-northeast-1:123456789012:vpce-notification-topic"

  #-------------------------------------------------------------
  # 通知イベント設定
  #-------------------------------------------------------------

  # connection_events (Required)
  # 設定内容: 通知を受け取るエンドポイントイベントを1つ以上指定します。
  # 設定可能な値:
  #   - "Accept":  エンドポイント接続リクエストが承認されたとき
  #   - "Connect": エンドポイント接続リクエストが送信されたとき
  #   - "Delete":  エンドポイントまたはエンドポイントサービスが削除されたとき
  #   - "Reject":  エンドポイント接続リクエストが拒否されたとき
  # 参考: https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_CreateVpcEndpointConnectionNotification.html#API_CreateVpcEndpointConnectionNotification_RequestParameters
  connection_events = ["Accept", "Reject"]

  #-------------------------------------------------------------
  # 通知対象設定
  #-------------------------------------------------------------

  # vpc_endpoint_service_id (Optional)
  # 設定内容: 通知を受け取るVPCエンドポイントサービスのIDを指定します。
  # 設定可能な値: 有効なVPCエンドポイントサービスID（例: vpce-svc-xxxxxxxxxxxxxxxxx）
  # 注意: vpc_endpoint_id と vpc_endpoint_service_id のいずれか一方を必ず指定する必要があります。
  vpc_endpoint_service_id = "vpce-svc-xxxxxxxxxxxxxxxxx"

  # vpc_endpoint_id (Optional)
  # 設定内容: 通知を受け取るVPCエンドポイントのIDを指定します。
  # 設定可能な値: 有効なVPCエンドポイントID（例: vpce-xxxxxxxxxxxxxxxxx）
  # 注意: vpc_endpoint_id と vpc_endpoint_service_id のいずれか一方を必ず指定する必要があります。
  vpc_endpoint_id = null

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用します。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id:                VPCコネクション通知のID
# - state:             通知の現在の状態
# - notification_type: 通知のタイプ（VpcEndpoint または VpcEndpointService）
#---------------------------------------------------------------
