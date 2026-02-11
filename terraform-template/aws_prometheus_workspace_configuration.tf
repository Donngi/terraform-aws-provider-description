#---------------------------------------------------------------
# Amazon Managed Service for Prometheus Workspace Configuration
#---------------------------------------------------------------
#
# Amazon Managed Service for Prometheusワークスペースの設定を管理します。
# ラベルセットごとのメトリクス取り込み制限や、データ保持期間を設定できます。
#
# AWS公式ドキュメント:
#   - Configure your workspace: https://docs.aws.amazon.com/prometheus/latest/userguide/AMP-workspace-configuration.html
#   - UpdateWorkspaceConfiguration API: https://docs.aws.amazon.com/prometheus/latest/APIReference/API_UpdateWorkspaceConfiguration.html
#   - WorkspaceConfigurationDescription: https://docs.aws.amazon.com/prometheus/latest/APIReference/API_WorkspaceConfigurationDescription.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/prometheus_workspace_configuration
#
# Provider Version: 6.28.0
# Generated: 2026-02-04
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_prometheus_workspace_configuration" "example" {
  #---------------------------------------------------------------
  # 必須パラメータ
  #---------------------------------------------------------------

  # 設定対象のワークスペースID
  # 既存のaws_prometheus_workspaceリソースのIDを指定
  workspace_id = "ws-example-id"

  #---------------------------------------------------------------
  # オプションパラメータ
  #---------------------------------------------------------------

  # メトリクスデータの保持期間（日数）
  # ワークスペースに保存されるメトリクスデータが保持される日数を指定
  # 最小値: 1日、最大値: 1095日（3年間）
  # 指定しない場合、デフォルトの保持期間が適用される
  retention_period_in_days = 90

  # このリソースを管理するリージョン
  # 指定しない場合、プロバイダー設定のリージョンが使用される
  # ワークスペースが存在するリージョンと同じである必要がある
  region = "us-east-1"

  #---------------------------------------------------------------
  # ラベルセットごとの制限設定
  #---------------------------------------------------------------

  # ラベルセットとそれに対する取り込み制限を定義
  # 特定のラベルを持つメトリクスに対して、アクティブな時系列数の上限を設定できる
  # これにより、特定のテナントやソースでの急激なメトリクス増加が
  # 他のテナントやソースに影響を与えないようにできる

  # 例1: デフォルトバケット（他のラベルセットに一致しないメトリクス用）
  limits_per_label_set {
    # ラベルセット定義（空のマップはデフォルトバケットを示す）
    # name/valueペアのマップで、時系列メトリクスにコンテキストを提供
    # 空のマップは、他のどのラベルセットにも一致しないメトリクスを表す
    label_set = {}

    # このラベルセットに適用される制限
    limits {
      # 取り込み可能なアクティブ時系列の最大数
      # この数を超えると、該当するメトリクスの取り込みが制限される
      max_series = 50000
    }
  }

  # 例2: 開発環境用のラベルセット
  limits_per_label_set {
    # 開発環境（env=dev）のメトリクスを識別するラベルセット
    label_set = {
      env = "dev"
    }

    limits {
      # 開発環境では10万シリーズまで許可
      max_series = 100000
    }
  }

  # 例3: 本番環境用のラベルセット
  limits_per_label_set {
    # 本番環境（env=prod）のメトリクスを識別するラベルセット
    label_set = {
      env = "prod"
    }

    limits {
      # 本番環境では40万シリーズまで許可（開発環境より多く設定）
      max_series = 400000
    }
  }

  # 例4: 特定チームと環境の組み合わせ
  limits_per_label_set {
    # 複数のラベルを組み合わせた制限設定も可能
    label_set = {
      team = "platform"
      env  = "prod"
    }

    limits {
      # プラットフォームチームの本番環境用に高い制限を設定
      max_series = 500000
    }
  }

  #---------------------------------------------------------------
  # タイムアウト設定
  #---------------------------------------------------------------

  timeouts {
    # 設定の作成時のタイムアウト
    # "30s"、"2h45m" などの形式で指定（秒: s、分: m、時間: h）
    create = "5m"

    # 設定の更新時のタイムアウト
    # "30s"、"2h45m" などの形式で指定（秒: s、分: m、時間: h）
    update = "5m"
  }
}

#---------------------------------------------------------------
# Attributes Reference
#---------------------------------------------------------------
# このリソースでは以下の属性が参照可能です（computed only）:
#
# (このリソースには computed only の属性は特にありません)
#
#---------------------------------------------------------------
