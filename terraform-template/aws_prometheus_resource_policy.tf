#---------------------------------------------------------------
# AWS Prometheus Resource Policy
#---------------------------------------------------------------
#
# Amazon Managed Service for Prometheus (AMP) ワークスペースに対して
# リソースベースのポリシーをアタッチするためのリソースです。
# リソースベースポリシーにより、他のAWSアカウントやAWSサービスに対して
# Prometheusワークスペースへのアクセス権限を付与できます。
#
# 主な用途:
#   - クロスアカウントアクセスの設定
#   - AWSサービス（Grafanaなど）からのアクセス許可
#   - メトリクスの書き込み・クエリ権限の細かな制御
#
# AWS公式ドキュメント:
#   - AMP リソースベースポリシー: https://docs.aws.amazon.com/prometheus/latest/userguide/AMP-resource-based-policy.html
#   - PutWorkspaceResourcePolicy API: https://docs.aws.amazon.com/prometheus/latest/APIReference/API_PutWorkspaceResourcePolicy.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/prometheus_resource_policy
#
# Provider Version: 6.28.0
# Generated: 2026-02-04
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_prometheus_resource_policy" "example" {
  #-------------------------------------------------------------
  # ワークスペースID設定
  #-------------------------------------------------------------

  # workspace_id (Required)
  # 設定内容: リソースベースポリシーを関連付けるPrometheusワークスペースのIDを指定します。
  # 設定可能な値: 有効なAMPワークスペースID
  # 関連機能: Amazon Managed Service for Prometheus
  #   AMPワークスペースは、Prometheusメトリクスを収集・保存・クエリするための
  #   マネージドなPrometheus互換環境です。リソースベースポリシーにより、
  #   他のアカウントやサービスからのアクセスを制御できます。
  #   - https://docs.aws.amazon.com/prometheus/latest/userguide/what-is-Amazon-Managed-Service-Prometheus.html
  workspace_id = aws_prometheus_workspace.example.id

  #-------------------------------------------------------------
  # ポリシードキュメント設定
  #-------------------------------------------------------------

  # policy_document (Required)
  # 設定内容: ワークスペースにアタッチするJSON形式のIAMポリシーを指定します。
  # 設定可能な値: 有効なJSON形式のIAMポリシードキュメント
  # 関連機能: AMP リソースベースポリシー
  #   リソースベースポリシーにより、以下のようなアクセス制御が可能です:
  #   - クロスアカウントからのメトリクス書き込み（RemoteWrite）
  #   - クロスアカウントからのメトリクスクエリ（QueryMetrics）
  #   - Amazon Managed Grafanaからの読み取りアクセス
  #   - メトリクスメタデータやラベルへのアクセス制御
  #   利用可能なアクション:
  #     - aps:RemoteWrite: Prometheusメトリクスの書き込み
  #     - aps:QueryMetrics: PromQLクエリの実行
  #     - aps:GetSeries: メトリクス系列の取得
  #     - aps:GetLabels: ラベル情報の取得
  #     - aps:GetMetricMetadata: メトリクスメタデータの取得
  #   - https://docs.aws.amazon.com/prometheus/latest/userguide/AMP-resource-based-policy.html
  policy_document = data.aws_iam_policy_document.example.json

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null
}

#---------------------------------------------------------------
# IAMポリシードキュメントの例
#---------------------------------------------------------------
# 以下は、Prometheusワークスペースへのアクセスを許可するポリシーの例です。
# 実際の使用時は、適切なプリンシパル、ARN、アクションを指定してください。
#---------------------------------------------------------------

data "aws_caller_identity" "current" {}

# 例1: 同一アカウント内での基本的なアクセス許可
data "aws_iam_policy_document" "example" {
  statement {
    sid    = "AllowPrometheusAccess"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = [data.aws_caller_identity.current.account_id]
    }

    actions = [
      "aps:RemoteWrite",
      "aps:QueryMetrics",
      "aps:GetSeries",
      "aps:GetLabels",
      "aps:GetMetricMetadata"
    ]

    resources = [aws_prometheus_workspace.example.arn]
  }
}

# 例2: クロスアカウントアクセスの許可
data "aws_iam_policy_document" "prometheus_cross_account" {
  statement {
    sid    = "AllowCrossAccountAccess"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::123456789012:root"]
    }

    actions = [
      "aps:RemoteWrite",
      "aps:QueryMetrics"
    ]

    resources = [aws_prometheus_workspace.example.arn]
  }
}

# 例3: Amazon Managed Grafanaからのアクセス許可
data "aws_iam_policy_document" "prometheus_grafana" {
  statement {
    sid    = "AllowGrafanaAccess"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["grafana.amazonaws.com"]
    }

    actions = [
      "aps:QueryMetrics",
      "aps:GetSeries",
      "aps:GetLabels",
      "aps:GetMetricMetadata"
    ]

    resources = [aws_prometheus_workspace.example.arn]
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - policy_status: リソースベースポリシーの現在のステータス
#   取りうる値: CREATING, ACTIVE, UPDATING, DELETING
#   ポリシーの作成・更新・削除の進行状況を示します。
#
# - revision_id: 現在のリソースベースポリシーのリビジョンID
#   ポリシーが更新される度に変更され、ポリシーのバージョン管理に使用できます。
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# 使用例とベストプラクティス
#---------------------------------------------------------------
#
# 1. クロスアカウント監視の実装:
#    複数のAWSアカウントからメトリクスを集約する場合、
#    各アカウントにRemoteWrite権限を付与します。
#
# 2. Grafanaダッシュボード統合:
#    Amazon Managed Grafanaと統合する場合、
#    grafana.amazonaws.comサービスプリンシパルに読み取り権限を付与します。
#
# 3. 最小権限の原則:
#    必要最小限のアクションのみを許可し、リソースを明示的に指定します。
#    例えば、読み取り専用アクセスには、RemoteWriteを含めないようにします。
#
# 4. 条件キーの活用:
#    aws:SourceAccountやaws:SourceArnなどの条件キーを使用して、
#    特定のリソースからのアクセスに限定できます。
#
# 5. プリンシパルの明示的な指定:
#    ワイルドカード（*）の使用は避け、具体的なアカウントIDやARNを指定してください。
#
# 6. ポリシーのバージョン管理:
#    revision_idを追跡し、ポリシー変更の履歴を管理してください。
#
#---------------------------------------------------------------
