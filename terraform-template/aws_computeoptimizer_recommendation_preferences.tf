#---------------------------------------------------------------
# AWS Compute Optimizer 推奨設定プリファレンス
#---------------------------------------------------------------
#
# AWS Compute Optimizerで生成される推奨設定をカスタマイズするためのプリファレンス設定。
# リソースタイプ（EC2インスタンス、Auto Scalingグループ、RDS、EBSなど）ごとに
# 強化インフラメトリクス、推測されたワークロードタイプ、外部メトリクス統合、
# ルックバック期間、コスト削減見積もりモード、優先リソースなどを設定できる。
#
# AWS公式ドキュメント:
#   - Recommendation preferences: https://docs.aws.amazon.com/compute-optimizer/latest/ug/viewing-recommendation-preferences.html
#   - PutRecommendationPreferences API: https://docs.aws.amazon.com/compute-optimizer/latest/APIReference/API_PutRecommendationPreferences.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/computeoptimizer_recommendation_preferences
#
# Provider Version: 6.28.0
# Generated: 2026-02-13
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_computeoptimizer_recommendation_preferences" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # resource_type (Required)
  # 設定内容: 推奨設定を生成する対象のリソースタイプ
  # 設定可能な値:
  #   - Ec2Instance: EC2インスタンス
  #   - AutoScalingGroup: Auto Scalingグループ
  #   - EbsVolume: EBSボリューム
  #   - LambdaFunction: Lambda関数
  #   - EcsService: ECSサービス
  #   - RdsDBInstance: RDSデータベースインスタンス
  #   - RdsDatabaseStorageAutoscalingConfiguration: RDSストレージ自動スケーリング設定
  resource_type = "Ec2Instance"

  # region (Optional)
  # 設定内容: このプリファレンスを適用するAWSリージョン
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定のリージョンが使用される
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # メトリクスとワークロード設定
  #-------------------------------------------------------------

  # enhanced_infrastructure_metrics (Optional)
  # 設定内容: より詳細なインフラメトリクスを使用して推奨設定を生成するかどうか
  # 設定可能な値:
  #   - Active: 強化メトリクスを有効化
  #   - Inactive: 強化メトリクスを無効化
  # 省略時: 既存の設定が維持される
  # 注意: 有効化すると追加料金が発生する場合がある
  # 関連機能: Enhanced Infrastructure Metrics
  #   より細かい粒度のメトリクスを収集し、より正確な推奨設定を生成します。
  #   - https://docs.aws.amazon.com/compute-optimizer/latest/ug/viewing-recommendation-preferences.html
  enhanced_infrastructure_metrics = null

  # inferred_workload_types (Optional)
  # 設定内容: ワークロードタイプの自動推測機能を有効化するかどうか
  # 設定可能な値:
  #   - Active: ワークロードタイプ推測を有効化
  #   - Inactive: ワークロードタイプ推測を無効化
  # 省略時: 既存の設定が維持される
  # 注意: EC2インスタンスのみサポート
  # 関連機能: Inferred Workload Types
  #   EC2インスタンスのワークロードタイプを自動的に推測し、
  #   特定のワークロードに最適化された推奨設定を提供します。
  #   - https://docs.aws.amazon.com/compute-optimizer/latest/ug/viewing-recommendation-preferences.html
  inferred_workload_types = null

  #-------------------------------------------------------------
  # 分析期間とコスト設定
  #-------------------------------------------------------------

  # look_back_period (Optional)
  # 設定内容: リソース使用率メトリクスを分析する過去の日数
  # 設定可能な値:
  #   - DAYS_14: 14日間
  #   - DAYS_32: 32日間
  #   - DAYS_93: 93日間
  # 省略時: DAYS_14が使用される
  # 注意: 長い期間を設定すると、より正確な推奨設定が得られるが追加料金が発生する
  # 関連機能: Lookback Period
  #   分析期間を長くすることで、季節性やトレンドを考慮した推奨設定が得られます。
  #   - https://docs.aws.amazon.com/compute-optimizer/latest/ug/viewing-recommendation-preferences.html
  look_back_period = null

  # savings_estimation_mode (Optional)
  # 設定内容: 推奨設定で使用するコスト削減見積もりモード
  # 設定可能な値:
  #   - AfterDiscounts: 割引後の料金に基づく見積もり
  #   - BeforeDiscounts: 割引前の料金に基づく見積もり
  # 省略時: 既存の設定が維持される
  # 関連機能: Savings Estimation Mode
  #   割引（リザーブドインスタンス、Savings Plansなど）を考慮した
  #   正確なコスト削減見積もりを取得できます。
  #   - https://docs.aws.amazon.com/compute-optimizer/latest/ug/viewing-recommendation-preferences.html
  savings_estimation_mode = null

  #-------------------------------------------------------------
  # 外部メトリクス統合設定（オプション）
  #-------------------------------------------------------------

  # external_metrics_preference (Optional)
  # 設定内容: 外部メトリクスソース（DatadogやDynatraceなど）からのメトリクスを
  #          推奨設定生成に使用するための設定
  # 関連機能: External Metrics Ingestion
  #   サードパーティ製の監視ツールからメトリクスを取得して、
  #   より正確な推奨設定を生成できます。
  #   - https://docs.aws.amazon.com/compute-optimizer/latest/ug/viewing-recommendation-preferences.html
  # external_metrics_preference {
  #   # source (Required)
  #   # 設定内容: 外部メトリクスの提供元
  #   # 設定可能な値:
  #   #   - Datadog: Datadogからのメトリクス
  #   #   - Dynatrace: Dynatraceからのメトリクス
  #   #   - NewRelic: New Relicからのメトリクス
  #   #   - Instana: Instanaからのメトリクス
  #   source = "Datadog"
  # }

  #-------------------------------------------------------------
  # 優先リソース設定（オプション）
  #-------------------------------------------------------------

  # preferred_resource (Optional)
  # 設定内容: 推奨設定生成時に優先または除外するリソースを指定
  # 注意: 複数の優先リソース設定を定義可能
  # 関連機能: Preferred Resources
  #   特定のインスタンスタイプやCPUアーキテクチャを優先または除外して、
  #   組織のポリシーに準拠した推奨設定を取得できます。
  #   - https://docs.aws.amazon.com/compute-optimizer/latest/ug/viewing-recommendation-preferences.html
  # preferred_resource {
  #   # name (Required)
  #   # 設定内容: 優先設定の名前（インスタンスタイプやCPUベンダーなど）
  #   # 設定可能な値:
  #   #   - Ec2InstanceTypes: EC2インスタンスタイプ
  #   #   - CpuVendorArchitectures: CPUベンダーアーキテクチャ
  #   name = "Ec2InstanceTypes"
  #
  #   # include_list (Optional)
  #   # 設定内容: 推奨設定に含めるリソースの値のセット
  #   # 注意: exclude_listとinclude_listは同時に指定できない
  #   include_list = null
  #
  #   # exclude_list (Optional)
  #   # 設定内容: 推奨設定から除外するリソースの値のセット
  #   # 注意: exclude_listとinclude_listは同時に指定できない
  #   exclude_list = null
  # }

  # CPUベンダーアーキテクチャの優先設定例（AWS Gravitonベースのインスタンスを推奨）
  # preferred_resource {
  #   name         = "CpuVendorArchitectures"
  #   include_list = ["AWS_ARM64"]
  #   exclude_list = null
  # }

  #-------------------------------------------------------------
  # スコープ設定（オプション）
  #-------------------------------------------------------------

  # scope (Optional)
  # 設定内容: プリファレンスを適用する範囲を指定（アカウント全体または特定の組織単位）
  # 関連機能: Scope
  #   特定のアカウントや組織に対してプリファレンスを適用できます。
  #   - https://docs.aws.amazon.com/compute-optimizer/latest/APIReference/API_PutRecommendationPreferences.html
  # scope {
  #   # name (Required)
  #   # 設定内容: スコープのタイプ
  #   # 設定可能な値:
  #   #   - AccountId: AWSアカウントID
  #   #   - OrganizationId: AWS組織ID
  #   #   - ResourceArn: 特定のリソースARN
  #   name = "AccountId"
  #
  #   # value (Required)
  #   # 設定内容: スコープに対応する値
  #   value = "123456789012"
  # }

  #-------------------------------------------------------------
  # 使用率プリファレンス設定（オプション）
  #-------------------------------------------------------------

  # utilization_preference (Optional)
  # 設定内容: CPUやメモリの使用率しきい値をカスタマイズして、より適切な推奨設定を生成
  # 注意: 複数のメトリクスに対して設定可能
  # 関連機能: Utilization Preferences
  #   CPU使用率やメモリ使用率のしきい値とヘッドルームをカスタマイズすることで、
  #   ワークロードの特性に合わせた推奨設定を取得できます。
  #   - https://docs.aws.amazon.com/compute-optimizer/latest/ug/viewing-recommendation-preferences.html
  # utilization_preference {
  #   # metric_name (Required)
  #   # 設定内容: カスタマイズする使用率メトリクスの名前
  #   # 設定可能な値:
  #   #   - CpuUtilization: CPU使用率
  #   #   - MemoryUtilization: メモリ使用率
  #   metric_name = "CpuUtilization"
  #
  #   # metric_parameters (Optional)
  #   # 設定内容: メトリクスのパラメータ設定
  #   metric_parameters {
  #     # headroom (Required)
  #     # 設定内容: 推奨設定で確保する余裕のパーセンテージ
  #     # 設定可能な値:
  #     #   - PERCENT_30: 30%の余裕
  #     #   - PERCENT_20: 20%の余裕
  #     #   - PERCENT_10: 10%の余裕
  #     #   - PERCENT_0: 余裕なし
  #     headroom = "PERCENT_20"
  #
  #     # threshold (Optional)
  #     # 設定内容: 使用率のしきい値（P90、P95、P99.5など）
  #     # 設定可能な値:
  #     #   - P90: 90パーセンタイル
  #     #   - P95: 95パーセンタイル
  #     #   - P99_5: 99.5パーセンタイル
  #     # 省略時: デフォルトのしきい値が使用される
  #     threshold = null
  #   }
  # }

  # メモリ使用率のプリファレンス設定例
  # utilization_preference {
  #   metric_name = "MemoryUtilization"
  #   metric_parameters {
  #     headroom  = "PERCENT_30"
  #     threshold = "P99_5"
  #   }
  # }
}

#---------------------------------------------------------------
# Attributes Reference
#---------------------------------------------------------------
# id: 推奨設定プリファレンスの一意な識別子（自動生成）
# region: プリファレンスが適用されるリージョン
# resource_type: 対象のリソースタイプ
# enhanced_infrastructure_metrics: 強化インフラメトリクスの有効化状態
# inferred_workload_types: ワークロードタイプ推測の有効化状態
# look_back_period: メトリクス分析期間
# savings_estimation_mode: コスト削減見積もりモード
