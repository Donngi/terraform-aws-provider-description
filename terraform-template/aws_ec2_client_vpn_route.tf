#-------------------------------------------------------------------------------
# aws_ec2_client_vpn_route
#-------------------------------------------------------------------------------
# Provider Version: 6.28.0
# Generated: 2026-02-14
# Terraform Registry: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_client_vpn_route
#
# NOTE: このテンプレートは参考実装です。実際の環境に合わせて適切に修正してください。
#
# Client VPNエンドポイントのルートテーブルにネットワーク経路を追加するリソース。
# VPCピアリング、オンプレミスネットワーク、インターネットへのルートを手動追加する際に使用します。
#
# ルートテーブルは最長プレフィックスマッチングで評価され、最も具体的なルートが優先されます。
# サブネット関連付け時に自動追加されるローカルルートは、このリソースでは削除できません。
# 削除するにはターゲットネットワークを切り離す必要があります。
#
# 【主な用途】
# - VPCピアリング接続先へのルーティング設定
# - オンプレミスネットワークへの経路追加
# - インターネットアクセス用のデフォルトルート（0.0.0.0/0）設定
# - スプリットトンネル構成でのカスタムルート定義
#
# 【注意事項】
# - ターゲットサブネットは最小/27以上のCIDRブロックが必要
# - ターゲットサブネットには最低20個の使用可能なIPアドレスが必要
# - 複数のサブネットを関連付ける場合は異なるAZに配置する必要がある
# - クライアントデバイスが処理できるルート数を考慮してルートテーブルを設計すること

#-------
# Resource Definition
#-------
resource "aws_ec2_client_vpn_route" "this" {
  #-------
  # 必須パラメータ
  #-------

  # Client VPNエンドポイント識別子
  # 設定内容: ルートを追加するClient VPNエンドポイントのID
  # 備考: 変更すると再作成が発生
  client_vpn_endpoint_id = var.client_vpn_endpoint_id

  # 宛先CIDRブロック
  # 設定内容: ルートの宛先となるIPv4アドレス範囲（CIDR表記）
  # 設定可能な値: 有効なIPv4 CIDR（例: 0.0.0.0/0, 10.0.0.0/16, 192.168.1.0/24）
  # 備考:
  #  - 最長プレフィックスマッチングで評価される（より具体的なルートが優先）
  #  - 0.0.0.0/0は全トラフィックをカバーするデフォルトルート
  #  - クライアントCIDR範囲と重複してはいけない
  #  - 変更すると再作成が発生
  destination_cidr_block = var.destination_cidr_block

  # ターゲットVPCサブネット識別子
  # 設定内容: トラフィックをルーティングするサブネットのID
  # 備考:
  #  - サブネットは/27以上のCIDRブロックが必要
  #  - 最低20個の使用可能なIPアドレスが必要
  #  - Client VPNエンドポイントに関連付けられたサブネットである必要がある
  #  - 変更すると再作成が発生
  target_vpc_subnet_id = var.target_vpc_subnet_id

  #-------
  # オプションパラメータ
  #-------

  # ルートの説明
  # 設定内容: ルートの目的や用途を説明するテキスト
  # 省略時: 説明なし
  # 備考: 管理やトラブルシューティングのために設定を推奨
  description = var.description

  # リージョン設定
  # 設定内容: このリソースを管理するAWSリージョン
  # 省略時: プロバイダー設定のリージョンを使用
  # 備考:
  #  - マルチリージョン構成で明示的なリージョン指定が必要な場合に使用
  #  - 通常はプロバイダー設定を使用するため指定不要
  region = var.region

  #-------
  # タイムアウト設定
  #-------

  timeouts {
    # ルート作成のタイムアウト時間
    # 設定内容: ルート作成完了を待機する最大時間
    # 省略時: 1m（1分）
    # 設定可能な値: 時間文字列（例: 30s, 2m, 1h）
    create = var.timeouts_create

    # ルート削除のタイムアウト時間
    # 設定内容: ルート削除完了を待機する最大時間
    # 省略時: 1m（1分）
    # 設定可能な値: 時間文字列（例: 30s, 2m, 1h）
    delete = var.timeouts_delete
  }

  #-------
  # タグ設定
  #-------
  # 備考: このリソースはタグをサポートしていません

  #-------
  # ライフサイクル設定
  #-------

  lifecycle {
    # 本番環境では削除保護を有効化することを推奨
    prevent_destroy = false

    # 重要なルートを保護する場合は以下を設定
    # ignore_changes = [
    #   description,
    # ]
  }
}

#-------
# Outputs
#-------
output "ec2_client_vpn_route_id" {
  description = "Client VPNルートの識別子"
  value       = aws_ec2_client_vpn_route.this.id
}

output "ec2_client_vpn_route_origin" {
  description = "ルートの起源（add-route APIで追加された場合はadd-route、サブネット関連付け時に自動追加された場合はassociate-subnet）"
  value       = aws_ec2_client_vpn_route.this.origin
}

output "ec2_client_vpn_route_type" {
  description = "ルートのタイプ（NAT経由の場合はnat、ローカルルートの場合はlocal）"
  value       = aws_ec2_client_vpn_route.this.type
}

#-------
# Variables (参考実装)
#-------
# variable "client_vpn_endpoint_id" {
#   description = "Client VPNエンドポイントのID"
#   type        = string
# }
#
# variable "destination_cidr_block" {
#   description = "宛先CIDRブロック（例: 0.0.0.0/0, 10.0.0.0/16）"
#   type        = string
# }
#
# variable "target_vpc_subnet_id" {
#   description = "ターゲットVPCサブネットのID"
#   type        = string
# }
#
# variable "description" {
#   description = "ルートの説明"
#   type        = string
#   default     = null
# }
#
# variable "region" {
#   description = "リソースを管理するAWSリージョン"
#   type        = string
#   default     = null
# }
#
# variable "timeouts_create" {
#   description = "ルート作成のタイムアウト時間"
#   type        = string
#   default     = null
# }
#
# variable "timeouts_delete" {
#   description = "ルート削除のタイムアウト時間"
#   type        = string
#   default     = null
# }

#-------
# Attributes Reference
#-------
# 以下の属性がエクスポートされ、他のリソースから参照可能:
#
# - id: Client VPNルートの識別子（形式: endpoint-id,target-subnet-id,destination-cidr）
# - origin: ルートの起源
#   - "add-route": CreateClientVpnRoute APIで手動追加されたルート
#   - "associate-subnet": サブネット関連付け時に自動追加されたルート
# - type: ルートのタイプ
#   - "nat": NATゲートウェイ経由のルート
#   - "local": VPCローカルルート
# - client_vpn_endpoint_id: Client VPNエンドポイントID（入力値）
# - destination_cidr_block: 宛先CIDRブロック（入力値）
# - target_vpc_subnet_id: ターゲットサブネットID（入力値）
# - description: ルートの説明（入力値）
# - region: リソースが管理されているリージョン
