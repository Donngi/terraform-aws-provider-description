#---------------------------------------
# Terraform AWS Client VPN 認可ルール
#---------------------------------------
# Provider Version: 6.28.0
# Generated: 2026-02-14
# Terraform Registry: https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/ec2_client_vpn_authorization_rule
#
# NOTE:
# AWS Client VPNエンドポイントに対するネットワークベースの認可ルールを定義します。
# このリソースは、特定のネットワーク（CIDR範囲）へのアクセスを許可するユーザーグループを制御します。
#
# 主な用途:
#   - Client VPN経由でアクセス可能なネットワークの指定
#   - Active DirectoryまたはSAML IdPグループごとのアクセス制御
#   - VPC内リソースへの細かいアクセス権限管理
#
# 注意事項:
#   - 各ネットワーク（CIDR）ごとに認可ルールを定義する必要があります
#   - access_group_idとauthorize_all_groupsは排他的に使用してください
#   - 認可ルールはファイアウォールルールとして機能します

#-------
# 基本設定
#-------

resource "aws_ec2_client_vpn_authorization_rule" "example" {
  # 設定内容: Client VPNエンドポイントのID
  # 必須項目: このルールを適用するエンドポイントを指定
  client_vpn_endpoint_id = "cvpn-endpoint-123456789123abcde"

  # 設定内容: アクセスを許可するターゲットネットワークのCIDR
  # 必須項目: VPCサブネットやインターネット(0.0.0.0/0)などを指定
  # 例: "10.0.0.0/16" (VPC全体), "10.0.1.0/24" (特定サブネット), "0.0.0.0/0" (インターネット)
  target_network_cidr = "10.0.0.0/16"

  #-------
  # アクセス制御設定
  #-------

  # 設定内容: アクセスを許可するActive DirectoryまたはSAML IdPグループのID
  # 省略時: 指定なし（authorize_all_groupsと排他的に使用）
  # Active Directoryの場合: セキュリティグループのSID
  # SAML IdPの場合: SAMLアサーション内のGroupAttributeの値
  access_group_id = "S-1-5-21-123456789-1234567890-1234567890-1234"

  # 設定内容: すべてのクライアントにアクセスを許可するかどうか
  # 設定可能な値: true（全ユーザー許可）, false（特定グループのみ）
  # 省略時: false
  # 注意: trueにすると全クライアントがアクセス可能になるためセキュリティリスクがあります
  authorize_all_groups = true

  #-------
  # 管理・運用設定
  #-------

  # 設定内容: 認可ルールの説明
  # 省略時: 説明なし
  # 推奨: ルールの目的やアクセス許可理由を記載
  description = "VPC内リソースへのアクセスを許可"

  # 設定内容: このリソースを管理するAWSリージョン
  # 省略時: プロバイダー設定のリージョンを使用
  # 注意: Client VPNエンドポイントと同じリージョンである必要があります
  region = "ap-northeast-1"

  #-------
  # タイムアウト設定
  #-------

  timeouts {
    # 設定内容: 認可ルール作成時の最大待機時間
    # 省略時: 10m
    # 形式: 時間文字列（例: "5m", "1h"）
    create = "10m"

    # 設定内容: 認可ルール削除時の最大待機時間
    # 省略時: 10m
    # 形式: 時間文字列（例: "5m", "1h"）
    delete = "10m"
  }
}

#---------------------------------------
# Attributes Reference（参照可能な属性）
#---------------------------------------
# このリソースでは以下の属性を参照できます:
#
# - id
#   リソースの一意識別子（<client_vpn_endpoint_id>/<target_network_cidr>形式）
#
# - region
#   リソースが管理されているAWSリージョン
#
# 参照方法:
#   aws_ec2_client_vpn_authorization_rule.example.id
#   aws_ec2_client_vpn_authorization_rule.example.region
