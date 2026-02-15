#---------------------------------------
# Direct Connect Gateway
#---------------------------------------
# 用途: AWS Direct Connect Gatewayリソースを作成し、複数リージョンのVPCに対して単一のDirect Connect接続を提供
# 実装: プライベートASNの設定、ゲートウェイ名の定義、タグ管理による識別
# 参考: https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/dx_gateway
# Provider Version: 6.28.0
# Generated: 2026-02-14
# NOTE: Direct Connect Gatewayは複数リージョンのVPC接続を統合管理するための中核リソース

#-------
# 基本設定
#-------
resource "aws_dx_gateway" "example" {
  # 設定内容: Direct Connect Gatewayの名前
  # 省略時: 設定不可（必須パラメータ）
  name = "tf-dxg-example"

  # 設定内容: AmazonサイドのASN（自律システム番号）
  # 設定可能な値: 64512-65534 または 4200000000-4294967294（プライベートASN範囲）
  # 省略時: 設定不可（必須パラメータ）
  amazon_side_asn = "64512"

  # 設定内容: リソースに付与するタグのキー・バリューマップ
  # 省略時: タグなし
  tags = {
    Name        = "example-dxg"
    Environment = "production"
  }
}

#-------
# タイムアウト設定
#-------
resource "aws_dx_gateway" "with_timeouts" {
  name            = "tf-dxg-with-timeouts"
  amazon_side_asn = "64513"

  # 設定内容: リソース操作のタイムアウト設定
  timeouts {
    # 設定内容: ゲートウェイ作成時のタイムアウト時間
    # 省略時: 10m
    create = "15m"

    # 設定内容: ゲートウェイ削除時のタイムアウト時間
    # 省略時: 10m
    delete = "15m"
  }

  tags = {
    Name = "example-dxg-timeouts"
  }
}

#-------
# Attributes Reference（参照専用属性）
#-------
# arn               - Direct Connect GatewayのARN
# id                - Direct Connect GatewayのID
# owner_account_id  - ゲートウェイを所有するAWSアカウントID
# tags_all          - プロバイダーのdefault_tagsとマージされた全タグのマップ

#-------
# 出力例
#-------
output "dx_gateway_id" {
  description = "Direct Connect GatewayのID"
  value       = aws_dx_gateway.example.id
}

output "dx_gateway_arn" {
  description = "Direct Connect GatewayのARN"
  value       = aws_dx_gateway.example.arn
}

output "dx_gateway_owner_account_id" {
  description = "ゲートウェイ所有者のAWSアカウントID"
  value       = aws_dx_gateway.example.owner_account_id
}
