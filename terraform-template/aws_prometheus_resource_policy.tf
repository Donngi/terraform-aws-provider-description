#------- aws_prometheus_resource_policy -------
#
# Amazon Managed Service for Prometheus (AMP) ワークスペースにリソースポリシーを設定する
# クロスアカウントアクセスなど、ワークスペースへのアクセス制御をIAMポリシードキュメントで定義する
#
# Terraform Registry:
#   https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/prometheus_resource_policy
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: このテンプレートは注釈付きリファレンスです。実際の使用時は不要なコメントを削除してください。
#
#-----------------------------------------------

resource "aws_prometheus_resource_policy" "example" {

  #------- 必須パラメータ -------

  # 設定内容: ポリシーを適用するAMPワークスペースのID
  # 設定可能な値: 既存ワークスペースのID文字列
  # 省略時: 省略不可
  workspace_id = aws_prometheus_workspace.example.id

  # 設定内容: ワークスペースに適用するIAMリソースポリシードキュメント（JSON文字列）
  # 設定可能な値: 有効なIAMポリシーJSON文字列
  # 省略時: 省略不可
  policy_document = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = { AWS = "arn:aws:iam::123456789012:root" }
        Action    = ["aps:RemoteWrite", "aps:QueryMetrics", "aps:GetSeries", "aps:GetLabels", "aps:GetMetricMetadata"]
        Resource  = "*"
      }
    ]
  })

  #------- オプションパラメータ -------

  # 設定内容: リソースを管理するAWSリージョン
  # 設定可能な値: 有効なAWSリージョンコード（例: "ap-northeast-1"）
  # 省略時: プロバイダー設定のリージョンが使用される
  region = null

  # 設定内容: ポリシーのリビジョンID（楽観的ロック制御に使用）
  # 設定可能な値: 既存のリビジョンIDを指定することで意図しない上書きを防止
  # 省略時: 自動で管理される（通常は省略）
  revision_id = null

  #------- タイムアウト設定 -------
  timeouts {
    # 設定内容: リソース作成のタイムアウト時間
    # 設定可能な値: "30s", "5m", "1h" など時間単位付き文字列
    # 省略時: プロバイダーデフォルト値
    create = "5m"

    # 設定内容: リソース更新のタイムアウト時間
    # 設定可能な値: "30s", "5m", "1h" など時間単位付き文字列
    # 省略時: プロバイダーデフォルト値
    update = "5m"

    # 設定内容: リソース削除のタイムアウト時間
    # 設定可能な値: "30s", "5m", "1h" など時間単位付き文字列
    # 省略時: プロバイダーデフォルト値
    delete = "5m"
  }
}

#------- Attributes Reference -------
# id             - ワークスペースID（workspace_idと同一）
# workspace_id   - ポリシーが適用されたAMPワークスペースのID
# policy_document - 現在適用されているIAMリソースポリシードキュメント（JSON文字列）
# revision_id    - ポリシーのリビジョンID（楽観的ロック制御用、自動採番）
# region         - リソースが管理されるAWSリージョン
