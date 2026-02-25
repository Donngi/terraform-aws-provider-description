# aws_vpc_ipam_scope
# IPAM（IP Address Manager）のスコープを管理するリソース。
# スコープはIPアドレス空間を分離するための論理的なコンテナ。
# 各 IPAM にはデフォルトのプライベートスコープとパブリックスコープが作成される。
#
# Provider Version: 6.28.0
# Generated: 2026-02-19
# Terraform Registry: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_ipam_scope
#
# NOTE: このファイルは全パラメーターを網羅したリファレンス用テンプレートです。
#       実際の利用時は不要なパラメーターを削除してください。
#
# Attributes Reference:
#   id                - スコープ ID
#   arn               - スコープの ARN
#   ipam_arn          - 親 IPAM の ARN
#   ipam_scope_type   - スコープの種別（private または public）
#   is_default        - デフォルトスコープかどうか
#   pool_count        - スコープに含まれるプール数
#   tags_all          - すべてのタグ（プロバイダーデフォルト含む）

#-------

resource "aws_vpc_ipam_scope" "example" {

  #-------
  # IPAM 関連設定
  #-------

  # 設定内容: このスコープを作成する IPAM の ID（必須）
  ipam_id = aws_vpc_ipam.example.id

  #-------
  # 基本設定
  #-------

  # 設定内容: スコープの説明
  # 省略時: 説明なし
  description = "example IPAM scope"

  # 設定内容: リソースを管理する AWS リージョン
  # 省略時: プロバイダー設定のリージョン
  region = null # null を設定するとプロバイダーのデフォルトリージョンを使用

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
