# ==============================================================================
# AWS Compute Optimizer Recommendation Preferences
# ==============================================================================
# Generated: 2026-01-19
# Provider Version: 6.28.0
#
# 注意: このテンプレートは生成時点の AWS Provider の仕様に基づいています。
#       最新の仕様や詳細については、必ず以下の公式ドキュメントをご確認ください。
#       - Terraform AWS Provider: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/computeoptimizer_recommendation_preferences
#       - AWS Compute Optimizer: https://docs.aws.amazon.com/compute-optimizer/latest/ug/
# ==============================================================================

# AWS Compute Optimizer の推奨設定プリファレンスを管理するリソース
# Compute Optimizer は、ワークロード要件に基づいてリソース推奨を生成するサービスです。
# このリソースを使用して、推奨設定の生成方法をカスタマイズできます。
#
# 参考: https://docs.aws.amazon.com/compute-optimizer/latest/ug/viewing-recommendation-preferences.html

resource "aws_computeoptimizer_recommendation_preferences" "example" {
  # ============================================================================
  # 必須パラメータ
  # ============================================================================

  # resource_type - (必須) 推奨設定のターゲットとなるリソースタイプ
  # 有効な値:
  #   - Ec2Instance: Amazon EC2 インスタンス
  #   - AutoScalingGroup: Auto Scaling グループ
  #   - RdsDBInstance: Amazon RDS DB インスタンス
  #   - AuroraDBClusterStorage: Amazon Aurora DB クラスターストレージ
  # 参考: https://docs.aws.amazon.com/compute-optimizer/latest/ug/rightsizing-preferences.html
  resource_type = "Ec2Instance"

  # ============================================================================
  # オプションパラメータ - 基本設定
  # ============================================================================

  # region - (オプション) このリソースを管理するリージョン
  # 省略した場合、プロバイダー設定で指定されたリージョンがデフォルトとして使用されます。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = "us-east-1"

  # enhanced_infrastructure_metrics - (オプション) 拡張インフラストラクチャメトリクス推奨設定のステータス
  # 有効な値:
  #   - Active: 拡張メトリクスを有効化（追加のメトリクスを使用して推奨を生成）
  #   - Inactive: 拡張メトリクスを無効化
  # 拡張インフラストラクチャメトリクスを使用すると、Compute Optimizer がより詳細な
  # メトリクスを使用して推奨を生成できます。
  # 参考: https://docs.aws.amazon.com/compute-optimizer/latest/ug/viewing-recommendation-preferences.html
  enhanced_infrastructure_metrics = "Active"

  # inferred_workload_types - (オプション) 推測されるワークロードタイプ推奨設定のステータス
  # 有効な値:
  #   - Active: ワークロードタイプの自動識別を有効化
  #   - Inactive: ワークロードタイプの自動識別を無効化
  # この機能を有効にすると、Compute Optimizer がインスタンスのワークロードタイプを
  # 自動的に識別します。
  # 参考: https://docs.aws.amazon.com/compute-optimizer/latest/ug/viewing-recommendation-preferences.html
  inferred_workload_types = "Active"

  # look_back_period - (オプション) リソースの使用率メトリクスを分析する日数
  # 有効な値:
  #   - DAYS_14: 14日間（デフォルト、追加料金なし）
  #   - DAYS_32: 32日間（追加料金なし）
  #   - DAYS_93: 93日間（追加料金が発生、enhanced_infrastructure_metrics が必要）
  # より長い期間を選択すると、より正確な推奨が得られますが、93日間の場合は
  # 拡張インフラストラクチャメトリクスの有効化と追加料金が必要です。
  # 参考: https://docs.aws.amazon.com/compute-optimizer/latest/ug/rightsizing-preferences.html
  look_back_period = "DAYS_32"

  # savings_estimation_mode - (オプション) 節約見積もりモード設定のステータス
  # 有効な値:
  #   - AfterDiscounts: 割引適用後の節約額を表示
  #   - BeforeDiscounts: 割引適用前の節約額を表示
  # この設定により、推奨によって実現できる節約額の計算方法を制御します。
  # 参考: https://docs.aws.amazon.com/compute-optimizer/latest/ug/viewing-recommendation-preferences.html
  savings_estimation_mode = "AfterDiscounts"

  # ============================================================================
  # ネストブロック - Scope（スコープ設定）
  # ============================================================================

  # scope - (必須) 推奨設定プリファレンスのスコープ
  # 推奨設定を適用する範囲を指定します。
  # 参考: https://docs.aws.amazon.com/compute-optimizer/latest/ug/rightsizing-preferences-process.html
  scope {
    # name - (必須) スコープの名前
    # 有効な値:
    #   - Organization: AWS Organization 全体
    #   - AccountId: 特定の AWS アカウント
    #   - ResourceArn: 特定のリソース（EC2 インスタンスまたは Auto Scaling グループの ARN）
    name = "AccountId"

    # value - (必須) スコープの値
    # name に応じた値を指定:
    #   - Organization の場合: ALL_ACCOUNTS
    #   - AccountId の場合: AWS アカウント ID
    #   - ResourceArn の場合: EC2 インスタンスまたは Auto Scaling グループの ARN
    value = "123456789012"
  }

  # ============================================================================
  # ネストブロック - External Metrics Preference（外部メトリクス設定）
  # ============================================================================

  # external_metrics_preference - (オプション) 外部メトリクス推奨設定のプロバイダー
  # 外部メトリクス統合を使用すると、Compute Optimizer が外部モニタリングサービスの
  # メトリクスを考慮して推奨を生成できます。
  # 参考: https://docs.aws.amazon.com/compute-optimizer/latest/ug/viewing-recommendation-preferences.html
  external_metrics_preference {
    # source - (必須) 外部メトリクスのソースオプション
    # 有効な値:
    #   - Datadog
    #   - Dynatrace
    #   - NewRelic
    #   - Instana
    source = "Datadog"
  }

  # ============================================================================
  # ネストブロック - Preferred Resources（優先リソース設定）
  # ============================================================================

  # preferred_resource - (オプション) ライトサイジング推奨生成時に考慮するリソースタイプの制御
  # 組織のガイドラインや要件（Savings Plans、Reserved Instances、特定のプロセッサなど）に
  # 基づいて、推奨に含めるまたは除外するインスタンスタイプを指定できます。
  # 参考: https://docs.aws.amazon.com/compute-optimizer/latest/ug/rightsizing-preferences.html
  preferred_resource {
    # name - (必須) カスタマイズする優先リソースのタイプ
    # 有効な値:
    #   - Ec2InstanceTypes: EC2 インスタンスタイプ
    name = "Ec2InstanceTypes"

    # include_list - (オプション) 推奨候補に含める優先リソースタイプ値
    # 厳密なリソースタイプ値（例: "m5.large"）またはワイルドカード表現（例: "m5"）を
    # 指定できます。省略した場合、サポートされているすべてのリソースがデフォルトで含まれます。
    # ワイルドカードを使用すると、将来のインスタンスファミリーのバリエーションも自動的に考慮されます。
    include_list = ["m5.xlarge", "r5"]

    # exclude_list - (オプション) 推奨候補から除外する優先リソースタイプ値
    # 省略した場合、サポートされているすべてのリソースがデフォルトで含まれます。
    # include_list と組み合わせて使用することで、より細かい制御が可能です。
    exclude_list = ["t2.micro", "t2.small"]
  }

  # ============================================================================
  # ネストブロック - Utilization Preferences（使用率設定）
  # ============================================================================

  # utilization_preference - (オプション) リソースの CPU 使用率閾値、CPU 使用率ヘッドルーム、
  # およびメモリ使用率ヘッドルームを制御するプリファレンス
  # これらの設定により、推奨の節約志向またはパフォーマンス志向を調整できます。
  # 参考: https://docs.aws.amazon.com/compute-optimizer/latest/ug/rightsizing-preferences.html
  utilization_preference {
    # metric_name - (必須) カスタマイズするリソース使用率メトリクス名
    # 有効な値:
    #   - CpuUtilization: CPU 使用率
    #   - MemoryUtilization: メモリ使用率
    metric_name = "CpuUtilization"

    # metric_parameters - (必須) リソース使用率閾値をカスタマイズする際に設定するパラメータ
    metric_parameters {
      # headroom - (必須) 指定されたメトリクスパラメータに使用されるヘッドルーム値（パーセンテージ）
      # 有効な値:
      #   - PERCENT_30: 30% のヘッドルーム（最大パフォーマンス志向）
      #   - PERCENT_20: 20% のヘッドルーム（バランス型）
      #   - PERCENT_10: 10% のヘッドルーム
      #   - PERCENT_0: 0% のヘッドルーム（最大節約志向）
      # ヘッドルームを大きくすると、パフォーマンスの余裕が増えますが、コストも増加します。
      headroom = "PERCENT_20"

      # threshold - (オプション) 指定されたメトリクスパラメータに使用される閾値
      # CPU 使用率の閾値のみ指定可能です。
      # 有効な値:
      #   - P90: 90パーセンタイル
      #   - P95: 95パーセンタイル
      #   - P99_5: 99.5パーセンタイル
      # より高い閾値を選択すると、ピーク使用率により近い値で推奨が生成されます。
      threshold = "P95"
    }
  }

  # ============================================================================
  # メモリ使用率の設定例
  # ============================================================================

  # メモリ使用率のプリファレンスも設定できます（CPU とは別のブロックとして定義）
  utilization_preference {
    metric_name = "MemoryUtilization"

    metric_parameters {
      # メモリ使用率の場合、threshold は指定できません（headroom のみ）
      headroom = "PERCENT_20"
    }
  }
}
