#---------------------------------------------------------------
# VPC IPAM
#---------------------------------------------------------------
#
# VPC IP Address Manager (IPAM) を管理するリソース。
# IPアドレスの計画・追跡・監視を一元管理するためのサービス。
# 複数のリージョンにわたる IP アドレス空間を一元的に管理・可視化できる。
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_ipam
#
# Provider Version: 6.28.0
# Generated: 2026-02-19
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
# 実際の利用時はAWSの公式ドキュメントおよびTerraformプロバイダーのドキュメントを確認してください。
#
# Attributes Reference (25行以内):
#   id                                        - IPAM ID
#   arn                                       - IPAM の ARN
#   private_default_scope_id                  - デフォルトプライベートスコープ ID
#   public_default_scope_id                   - デフォルトパブリックスコープ ID
#   scope_count                               - スコープ数
#   default_resource_discovery_id             - デフォルトリソースディスカバリ ID
#   default_resource_discovery_association_id - デフォルトリソースディスカバリ関連付け ID
#   tags_all                                  - すべてのタグ（プロバイダーデフォルト含む）

#-------

resource "aws_vpc_ipam" "example" {

  #-------
  # 動作リージョン設定
  #-------

  # 設定内容: IPAM が動作するリージョンの一覧（必須、複数指定可）
  operating_regions {
    # 設定内容: 動作リージョン名
    region_name = "ap-northeast-1"
  }

  # 複数リージョンを追加する場合は operating_regions ブロックを複数記述する
  # operating_regions {
  #   region_name = "us-east-1"
  # }

  #-------
  # 基本設定
  #-------

  # 設定内容: IPAM の説明
  # 省略時: 説明なし
  description = "example IPAM"

  # 設定内容: IPAM の階層
  # 設定可能な値: "free", "advanced"
  # 省略時: "free"
  tier = "free"

  # 設定内容: プライベート GUA（Globally Unique Address）アドレスを有効化するか
  # 設定可能な値: true, false
  # 省略時: false
  enable_private_gua = false

  # 設定内容: 課金対象アカウントの設定
  # 設定可能な値: "ipam-owner", "resource-owner"
  # 省略時: "ipam-owner"
  metered_account = "ipam-owner"

  # 設定内容: IPAM 削除時に子リソースも連鎖削除するか
  # 設定可能な値: true, false
  # 省略時: false
  cascade = false

  # 設定内容: リソースを管理する AWS リージョン
  # 省略時: プロバイダー設定のリージョン
  region = null

  #-------
  # タグ設定
  #-------

  tags = {
    Name = "example"
  }

  #-------
  # タイムアウト設定
  #-------

  timeouts {
    # 設定内容: 作成タイムアウト
    # 省略時: デフォルトタイムアウト
    create = "30m"

    # 設定内容: 更新タイムアウト
    # 省略時: デフォルトタイムアウト
    update = "30m"

    # 設定内容: 削除タイムアウト
    # 省略時: デフォルトタイムアウト
    delete = "30m"
  }
}
