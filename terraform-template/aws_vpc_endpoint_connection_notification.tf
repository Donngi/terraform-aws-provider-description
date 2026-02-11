#---------------------------------------------------------------
# VPC Endpoint Connection Notification
#---------------------------------------------------------------
#
# VPCエンドポイントまたはVPCエンドポイントサービスの接続イベントを
# Amazon SNSトピックに通知するための接続通知リソースをプロビジョニングします。
# 接続通知は、エンドポイントの特定のイベント（Accept、Connect、Delete、Reject）
# が発生したときにサブスクライバーに通知します。
# インターフェースエンドポイントに対してのみ接続通知を作成できます。
#
# AWS公式ドキュメント:
#   - CreateVpcEndpointConnectionNotification: https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_CreateVpcEndpointConnectionNotification.html
#   - Receive alerts for interface endpoint events: https://docs.aws.amazon.com/vpc/latest/privatelink/manage-notifications-endpoint.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint_connection_notification
#
# Provider Version: 6.28.0
# Generated: 2026-02-05
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_vpc_endpoint_connection_notification" "example" {
  #---------------------------------------------------------------
  # Required Parameters
  #---------------------------------------------------------------

  # (Required) エンドポイントイベントの通知先となるSNSトピックのARN
  # 通知を受信するには、SNSトピックに適切なアクセスポリシーを設定する必要があります。
  # ポリシーでは、vpce.amazonaws.comサービスプリンシパルにSNS:Publishアクションを許可します。
  #
  # 例: "arn:aws:sns:us-east-1:123456789012:vpce-notification-topic"
  connection_notification_arn = "arn:aws:sns:us-east-1:123456789012:example-topic"

  # (Required) 通知を受け取るエンドポイントイベントのセット
  # 有効な値:
  #   - "Accept"  : 接続リクエストが承認されたとき
  #   - "Connect" : 接続リクエストが行われたとき
  #   - "Delete"  : インターフェースエンドポイントが削除されたとき
  #   - "Reject"  : 接続リクエストが拒否されたとき
  #
  # 例: ["Accept", "Reject"]
  connection_events = ["Accept", "Connect", "Delete", "Reject"]

  #---------------------------------------------------------------
  # Optional Parameters
  #---------------------------------------------------------------

  # (Optional) VPCエンドポイントサービスのID
  # 通知を受け取るVPCエンドポイントサービスを指定します。
  # vpc_endpoint_service_id または vpc_endpoint_id のいずれかを指定する必要があります。
  #
  # エンドポイントサービスに対する通知を設定する場合に使用します。
  # エンドポイントサービスプロバイダーは、サービスに対する接続リクエストのイベントを
  # 監視する際にこのパラメータを使用します。
  #
  # 例: "vpce-svc-1237881c0d25a3abc"
  vpc_endpoint_service_id = "vpce-svc-1237881c0d25a3abc"

  # (Optional) VPCエンドポイントのID
  # 通知を受け取るVPCエンドポイントを指定します。
  # vpc_endpoint_service_id または vpc_endpoint_id のいずれかを指定する必要があります。
  #
  # 特定のVPCエンドポイントに対する通知を設定する場合に使用します。
  # エンドポイントコンシューマーは、自身のエンドポイントのイベントを
  # 監視する際にこのパラメータを使用します。
  #
  # 例: "vpce-1234151a02f327123"
  # vpc_endpoint_id = "vpce-1234151a02f327123"

  # (Optional) このリソースが管理されるリージョン
  # 指定しない場合は、プロバイダー設定のリージョンがデフォルトで使用されます。
  # マルチリージョン構成でリソースを明示的に特定のリージョンに配置する場合に使用します。
  #
  # 例: "us-east-1"
  # region = "us-east-1"

  # (Optional) リソースの一意の識別子
  # Terraformによって自動的に計算されます。
  # 通常は指定する必要はありませんが、既存リソースをインポートする場合などに使用できます。
  #
  # 例: "vpce-nfn-04bcb952bc8af759b"
  # id = "vpce-nfn-04bcb952bc8af759b"
}

#---------------------------------------------------------------
# Attributes Reference
#---------------------------------------------------------------
# 以下の属性はリソース作成後にTerraformによって自動的に設定されます（Computed）。
# これらは参照のみ可能で、直接設定することはできません。
#
# - id
#     VPC接続通知のID
#     例: "vpce-nfn-04bcb952bc8af759b"
#
# - notification_type
#     通知のタイプ
#     常に "Topic" が返されます
#
# - state
#     通知の状態
#     有効な値: "Enabled", "Disabled"
#
# - region
#     このリソースが管理されているリージョン
#     リージョンを明示的に指定しない場合はプロバイダー設定のリージョンが返されます
#
#---------------------------------------------------------------
# Usage Example
#---------------------------------------------------------------
# output "notification_id" {
#   description = "VPC Endpoint Connection Notification ID"
#   value       = aws_vpc_endpoint_connection_notification.example.id
# }
#
# output "notification_state" {
#   description = "VPC Endpoint Connection Notification State"
#   value       = aws_vpc_endpoint_connection_notification.example.state
# }
#---------------------------------------------------------------
