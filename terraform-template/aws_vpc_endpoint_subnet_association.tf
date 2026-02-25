#-----------------------------------------------------------------------
# AWS VPC Endpoint Subnet Association
#-----------------------------------------------------------------------
#
# VPCエンドポイントにサブネットを関連付けるリソースです。
# インターフェース型エンドポイントで使用し、指定したサブネットに
# エンドポイントネットワークインターフェース（ENI）を配置します。
# 複数のサブネットに関連付けることで高可用性を実現できます。
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint_subnet_association
#
# Provider Version: 6.28.0
# Generated: 2026-02-19
#
# NOTE:
#   - インターフェース型エンドポイント（aws_vpc_endpoint）にのみ適用可能
#   - 同一サブネットに対して同じエンドポイントを重複して関連付けることはできない
#   - サブネットはエンドポイントと同じVPC内に属している必要がある
#   - エンドポイント削除時にサブネット関連付けも自動的に削除される
#-----------------------------------------------------------------------

# Attributes Reference (25行以内):
# id              - 関連付けのID (フォーマット: <vpc_endpoint_id>/<subnet_id>)
# vpc_endpoint_id - 関連付けられたVPCエンドポイントのID
# subnet_id       - 関連付けられたサブネットのID
# region          - このリソースが管理されるAWSリージョン
#-----------------------------------------------------------------------

resource "aws_vpc_endpoint_subnet_association" "this" {

  #-------
  # エンドポイント・サブネット設定（必須）
  #-------

  # 設定内容: 関連付けるVPCエンドポイントのID
  # 設定可能な値: vpce-xxxxxxxxxxxxxxxxx 形式のインターフェース型エンドポイントID
  vpc_endpoint_id = "vpce-xxxxxxxxxxxxxxxxx"

  # 設定内容: エンドポイントENIを配置するサブネットのID
  # 設定可能な値: subnet-xxxxxxxx 形式のサブネットID（エンドポイントと同一VPC内のサブネット）
  subnet_id = "subnet-xxxxxxxxxxxxxxxxx"

  #-------
  # リージョン設定
  #-------

  # 設定内容: このリソースを管理するAWSリージョン
  # 設定可能な値: "us-east-1", "ap-northeast-1" 等のリージョンコード
  # 省略時: プロバイダー設定のリージョンを使用
  region = null

  #-------
  # タイムアウト設定
  #-------

  timeouts {
    # 設定内容: リソース作成のタイムアウト時間
    # 設定可能な値: "10m", "30m" 等のGo duration形式の文字列
    # 省略時: プロバイダーのデフォルト値を使用
    create = "10m"

    # 設定内容: リソース削除のタイムアウト時間
    # 設定可能な値: "10m", "30m" 等のGo duration形式の文字列
    # 省略時: プロバイダーのデフォルト値を使用
    delete = "10m"
  }
}
