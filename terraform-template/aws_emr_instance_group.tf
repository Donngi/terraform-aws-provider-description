#---------------------------------------------------------------
# EMR Instance Group
#---------------------------------------------------------------
#
# Amazon EMR (Elastic MapReduce) クラスターのインスタンスグループを設定します。
# インスタンスグループは、同じインスタンスタイプと購入オプションを共有する
# EC2インスタンスの集合で、コアノードまたはタスクノードとして機能します。
#
# 主な用途:
#   - EMRクラスターにコアノードまたはタスクノードを追加
#   - 自動スケーリングポリシーの設定
#   - スポットインスタンスを使用したコスト最適化
#   - EBS設定によるストレージのカスタマイズ
#
# 注意事項:
#   - インスタンスグループは作成後にインスタンスタイプを変更できません
#   - APIやWebコンソールから削除できず、EMRクラスターと共に削除されます
#   - Terraformはリソース削除時にインスタンス数を0にリサイズします
#
# AWS公式ドキュメント:
#   - Instance Groups: https://docs.aws.amazon.com/emr/latest/ManagementGuide/emr-uniform-instance-group.html
#   - Automatic Scaling: https://docs.aws.amazon.com/emr/latest/ManagementGuide/emr-automatic-scaling.html
#   - API Reference: https://docs.aws.amazon.com/emr/latest/APIReference/API_InstanceGroupConfig.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/emr_instance_group
#
# Provider Version: 6.28.0
# Generated: 2026-01-27
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_emr_instance_group" "example" {
  #---------------------------------------------------------------
  # 必須パラメータ
  #---------------------------------------------------------------

  # EMRクラスターのID
  # このインスタンスグループを追加するEMRクラスターの識別子を指定します。
  # aws_emr_cluster リソースから参照する場合は、aws_emr_cluster.example.id を使用します。
  cluster_id = "j-XXXXXXXXXXXXX"

  # インスタンスタイプ
  # インスタンスグループ内の全てのEC2インスタンスのタイプを指定します。
  # 一般的なタイプ:
  #   - 汎用: m5.xlarge, m5.2xlarge, m6g.xlarge
  #   - コンピューティング最適化: c5.xlarge, c5.2xlarge
  #   - メモリ最適化: r5.xlarge, r5.2xlarge
  #   - ストレージ最適化: i3.xlarge, d2.xlarge
  # 注意: クラスター作成後は変更できません。
  instance_type = "m5.xlarge"

  #---------------------------------------------------------------
  # オプションパラメータ
  #---------------------------------------------------------------

  # 自動スケーリングポリシー
  # CloudWatchメトリクスに基づいてインスタンス数を自動調整するポリシーをJSON形式で指定します。
  # コアノードまたはタスクノードに設定可能です（マスターノードには不可）。
  # ポリシーには以下を含めます:
  #   - Constraints: 最小/最大インスタンス数
  #   - Rules: スケールアウト/スケールインのルール
  # 使用には VisibleToAllUsers=true とEMR_AutoScaling_DefaultRole が必要です。
  # 詳細: https://docs.aws.amazon.com/emr/latest/ManagementGuide/emr-automatic-scaling.html
  # 例:
  # autoscaling_policy = jsonencode({
  #   Constraints = {
  #     MinCapacity = 1
  #     MaxCapacity = 10
  #   }
  #   Rules = [
  #     {
  #       Name        = "ScaleOutRule"
  #       Description = "Scale out based on YARN memory"
  #       Action = {
  #         SimpleScalingPolicyConfiguration = {
  #           AdjustmentType  = "CHANGE_IN_CAPACITY"
  #           ScalingAdjustment = 2
  #           CoolDown        = 300
  #         }
  #       }
  #       Trigger = {
  #         CloudWatchAlarmDefinition = {
  #           ComparisonOperator = "LESS_THAN"
  #           EvaluationPeriods  = 1
  #           MetricName         = "YARNMemoryAvailablePercentage"
  #           Namespace          = "AWS/ElasticMapReduce"
  #           Period             = 300
  #           Statistic          = "AVERAGE"
  #           Threshold          = 15.0
  #         }
  #       }
  #     }
  #   ]
  # })
  autoscaling_policy = null

  # 入札価格（スポットインスタンス用）
  # EC2スポットインスタンスの最大入札価格をUSDで指定します。
  # 設定するとインスタンスグループがスポットインスタンスとして起動されます。
  # 未設定の場合はオンデマンドインスタンスが使用されます。
  # タスクノードでの使用を推奨（永続データを保持しないため）。
  # 例: "0.05" (USD/時間)
  bid_price = null

  # 設定JSON
  # EMRインスタンスグループ固有の設定をJSON配列形式で指定します。
  # Hadoop、Spark、Hiveなどのアプリケーション設定をカスタマイズできます。
  # 注意: EMR 5.21以降でのみ変更可能です。
  # 例:
  # configurations_json = jsonencode([
  #   {
  #     Classification = "hadoop-env"
  #     Configurations = [
  #       {
  #         Classification = "export"
  #         Properties = {
  #           JAVA_HOME = "/usr/lib/jvm/java-1.8.0"
  #         }
  #       }
  #     ]
  #     Properties = {}
  #   }
  # ])
  configurations_json = null

  # EBS最適化
  # EBS最適化インスタンスとして起動するかを指定します。
  # true を設定すると、EBSボリュームへの専用スループットが提供されます。
  # ストレージI/Oが多いワークロードに推奨されます。
  # 注意: 一部のインスタンスタイプはデフォルトでEBS最適化されています。
  ebs_optimized = null

  # ID
  # Terraformによって管理されるリソースのID。
  # 通常は指定不要（自動生成されます）。
  id = null

  # インスタンス数
  # インスタンスグループ内のEC2インスタンスの目標数を指定します。
  # 自動スケーリングポリシーを使用する場合は、ポリシー内の制約に従って動的に調整されます。
  # 指定しない場合、既存の値が維持されます（computed）。
  # 例: 3
  instance_count = null

  # 名前
  # インスタンスグループの識別用の名前を指定します。
  # EMRコンソールやログで表示されます。
  # 例: "my-task-instance-group", "core-instances"
  name = null

  # リージョン
  # リソースが管理されるAWSリージョンを指定します。
  # 指定しない場合、プロバイダー設定のリージョンがデフォルトで使用されます。
  # 例: "us-east-1", "ap-northeast-1"
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #---------------------------------------------------------------
  # ネストブロック: EBS設定
  #---------------------------------------------------------------

  # EBSボリューム設定
  # インスタンスグループの各EC2インスタンスに接続するEBSボリュームを設定します。
  # 複数のebs_configブロックを指定して、異なるタイプのボリュームを組み合わせることができます。
  # 永続的なデータストレージやI/O性能の向上に使用します。
  ebs_config {
    # ボリュームサイズ（必須）
    # EBSボリュームのサイズをGiB単位で指定します。
    # 範囲: 1〜1024 GiB
    # EBS最適化インスタンスの場合、最小値は10 GiBです。
    size = 100

    # ボリュームタイプ（必須）
    # EBSボリュームのタイプを指定します。
    # 有効な値:
    #   - "gp2": 汎用SSD（コストと性能のバランス）
    #   - "gp3": 汎用SSD第3世代（gp2より柔軟な性能設定）
    #   - "io1": プロビジョンドIOPS SSD（高性能）
    #   - "io2": プロビジョンドIOPS SSD第2世代（io1より耐久性向上）
    #   - "st1": スループット最適化HDD（大容量・低コスト）
    #   - "sc1": コールドHDD（アクセス頻度が低いデータ）
    #   - "standard": マグネティックボリューム（旧世代）
    type = "gp2"

    # IOPS（オプション）
    # ボリュームがサポートするI/O操作数を指定します。
    # io1/io2ボリュームタイプでのみ有効です。
    # io1: 100〜64,000 IOPS（ボリュームサイズに応じて制限あり）
    # io2: 100〜64,000 IOPS（より高い耐久性）
    # gp3: 3,000〜16,000 IOPS
    # 注意: io1/io2では、IOPS:GiBの比率が50:1を超えないようにしてください。
    iops = null

    # インスタンスあたりのボリューム数（オプション）
    # 各EC2インスタンスに接続するこのタイプのEBSボリュームの数を指定します。
    # デフォルト: 1
    # 例: 2（各インスタンスに2つのボリュームを接続）
    volumes_per_instance = null
  }
}

#---------------------------------------------------------------
# Attributes Reference (Read-Only)
#---------------------------------------------------------------
# 以下の属性は computed only であり、リソース作成後に参照可能です。
# Terraformコード内で他のリソースから参照する際に使用できます。
#
# - id                      : EMRインスタンスグループのID
# - running_instance_count  : インスタンスグループで現在実行中のインスタンス数
# - status                  : インスタンスグループの現在のステータス
#                             (例: PROVISIONING, BOOTSTRAPPING, RUNNING, RESIZING, SUSPENDED, TERMINATING, TERMINATED, ARRESTED, SHUTTING_DOWN)
#---------------------------------------------------------------

# 使用例: 他のリソースから参照
# output "instance_group_id" {
#   value = aws_emr_instance_group.example.id
# }
#
# output "running_instances" {
#   value = aws_emr_instance_group.example.running_instance_count
# }
