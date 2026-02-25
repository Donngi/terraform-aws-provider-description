#######################################################################
# Amazon Managed Service for Prometheus - ルールグループ名前空間
#######################################################################
# Amazon Managed Service for Prometheus (AMP) ワークスペースに対して
# Prometheus のルーティングルール（recording rules / alerting rules）を
# YAML 形式で定義・適用する名前空間リソース。
#
# 主な用途:
# - Prometheus recording rules（メトリクスの事前集計）の定義
# - Prometheus alerting rules（アラート条件）の定義
# - 複数のルールグループを名前空間単位で整理・管理
#
# 参考: https://docs.aws.amazon.com/prometheus/latest/userguide/AMP-ruler.html
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# Terraform Registry: https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/prometheus_rule_group_namespace
#
# NOTE: このテンプレートの属性は実際の要件に応じてコメントを外して使用してください

resource "aws_prometheus_rule_group_namespace" "example" {

  #------- 必須パラメータ -------

  # 設定内容: ルールグループ名前空間の名前
  # 設定可能な値: 任意の文字列（ワークスペース内で一意）
  # 省略時: 省略不可
  name = "example-rules"

  # 設定内容: ルールグループの定義（YAML 形式の文字列）
  # 設定可能な値: Prometheus ルール設定仕様に準拠した YAML 文字列（groups / rules など）
  # 省略時: 省略不可
  data = <<-EOT
    groups:
      - name: example
        rules:
          - alert: ExampleAlert
            expr: up == 0
            for: 5m
            labels:
              severity: critical
            annotations:
              summary: "Instance {{ $labels.instance }} is down"
  EOT

  # 設定内容: 定義を適用する AMP ワークスペースの ID
  # 設定可能な値: aws_prometheus_workspace リソースの workspace_id 属性
  # 省略時: 省略不可
  workspace_id = aws_prometheus_workspace.example.id

  #------- オプションパラメータ -------

  # 設定内容: リソースに付与するタグ
  # 設定可能な値: key-value ペアの文字列マップ
  # 省略時: タグなし
  tags = null

  # 設定内容: リソースを管理する AWS リージョン
  # 設定可能な値: 有効な AWS リージョンコード（例: "ap-northeast-1"）
  # 省略時: プロバイダー設定のリージョンが使用される
  region = null
}

#------- Attributes Reference -------
# arn          - ルールグループ名前空間の ARN
# id           - ルールグループ名前空間の識別子（ARN と同一）
# name         - ルールグループ名前空間の名前
# data         - 現在適用されている Prometheus ルール定義の YAML 文字列
# workspace_id - 名前空間が属する AMP ワークスペースの ID
# tags_all     - プロバイダーのデフォルトタグを含む全タグのマップ
# region       - リソースが管理される AWS リージョン
