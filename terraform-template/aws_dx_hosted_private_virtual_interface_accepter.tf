#---------------------------------------
# AWS Direct Connect プライベート仮想インターフェース受入設定
#---------------------------------------
# Provider Version: 6.28.0
# Generated: 2026-02-14
# Terraform Registry: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dx_hosted_private_virtual_interface_accepter
#
# 用途: 他のAWSアカウントから共有されたホスト型プライベート仮想インターフェースを受け入れる
#
# 主な用途:
# - クロスアカウントでのDirect Connect接続の確立
# - VPN GatewayまたはDirect Connect Gatewayへの接続
# - プライベートネットワークの拡張
#
# 制限事項:
# - 仮想インターフェースは他のアカウントで作成済みである必要がある
# - vpn_gateway_idとdx_gateway_idは同時に指定できない
# - 受け入れ後の変更には制限がある
#
# NOTE: このテンプレートは全属性を網羅していますが、実際の使用時は必要な属性のみを設定してください

#-------
# 基本設定
#-------
resource "aws_dx_hosted_private_virtual_interface_accepter" "example" {
  # 設定内容: 受け入れる仮想インターフェースのID
  # 形式: vif-xxxxxxxx
  virtual_interface_id = "vif-12345678"

  #-------
  # ゲートウェイ接続設定（いずれか1つを指定）
  #-------
  # 設定内容: 接続先のVPN GatewayのID
  # 省略時: 指定なし（dx_gateway_idと排他的）
  vpn_gateway_id = aws_vpn_gateway.example.id

  # 設定内容: 接続先のDirect Connect GatewayのID
  # 省略時: 指定なし（vpn_gateway_idと排他的）
  dx_gateway_id = aws_dx_gateway.example.id

  #-------
  # リソース管理設定
  #-------
  # 設定内容: リソースを管理するAWSリージョン
  # 省略時: プロバイダー設定のリージョン
  region = "us-east-1"

  # 設定内容: リソースに付与するタグ
  # 省略時: タグなし
  tags = {
    Name        = "example-vif-accepter"
    Environment = "production"
    ManagedBy   = "terraform"
  }

  #-------
  # タイムアウト設定
  #-------
  timeouts {
    # 設定内容: 仮想インターフェース受け入れのタイムアウト時間
    # 省略時: 10分
    create = "10m"

    # 設定内容: 仮想インターフェース削除のタイムアウト時間
    # 省略時: 10分
    delete = "10m"
  }
}

#---------------------------------------
# Outputs
#---------------------------------------
output "virtual_interface_accepter_id" {
  description = "仮想インターフェース受入リソースのID"
  value       = aws_dx_hosted_private_virtual_interface_accepter.example.id
}

output "virtual_interface_accepter_arn" {
  description = "仮想インターフェース受入リソースのARN"
  value       = aws_dx_hosted_private_virtual_interface_accepter.example.arn
}

#---------------------------------------
# Attributes Reference
#---------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: 仮想インターフェースのID
# - arn: 仮想インターフェースのAmazon Resource Name (ARN)
# - virtual_interface_id: 仮想インターフェースのID
# - vpn_gateway_id: 接続先VPN GatewayのID
# - dx_gateway_id: 接続先Direct Connect GatewayのID
# - region: リソースが管理されているリージョン
# - tags_all: プロバイダーのデフォルトタグとリソース固有タグを統合したタグマップ
