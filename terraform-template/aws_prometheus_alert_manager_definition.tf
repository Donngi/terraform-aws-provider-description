#######################################################################
# Amazon Managed Service for Prometheus - アラートマネージャー定義
#######################################################################
# Amazon Managed Service for Prometheus (AMP) ワークスペースに対して
# Alertmanager 設定を YAML 形式で適用するリソース。
# ルーティング、レシーバー、抑制ルールなどを定義できる。
#
# 主な用途:
# - Prometheus アラートの通知先（SNS・PagerDuty 等）設定
# - アラートのルーティングルール定義
# - アラートの抑制（inhibit_rules）設定
#
# 参考: https://docs.aws.amazon.com/prometheus/latest/userguide/AMP-alert-manager.html
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# Terraform Registry: https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/prometheus_alert_manager_definition
#
# NOTE: このテンプレートの属性は実際の要件に応じてコメントを外して使用してください

resource "aws_prometheus_alert_manager_definition" "example" {

  #------- 必須パラメータ -------

  # 設定内容: アラートマネージャーの定義（YAML 形式の文字列）
  # 設定可能な値: Alertmanager 設定仕様に準拠した YAML 文字列（route / receivers / inhibit_rules など）
  # 省略時: 省略不可
  definition = <<-EOT
    alertmanager_config: |
      route:
        receiver: 'default'
      receivers:
        - name: 'default'
  EOT

  # 設定内容: 定義を適用する AMP ワークスペースの ID
  # 設定可能な値: aws_prometheus_workspace リソースの workspace_id 属性
  # 省略時: 省略不可
  workspace_id = aws_prometheus_workspace.example.id

  #------- オプションパラメータ -------

  # 設定内容: リソースを管理する AWS リージョン
  # 設定可能な値: 有効な AWS リージョンコード（例: "ap-northeast-1"）
  # 省略時: プロバイダー設定のリージョンが使用される
  region = null
}

#------- Attributes Reference -------
# id             - アラートマネージャー定義の識別子（workspace_id と同一）
# workspace_id   - 定義が適用された AMP ワークスペースの ID
# definition     - 現在適用されているアラートマネージャーの YAML 定義
# region         - リソースが管理される AWS リージョン
