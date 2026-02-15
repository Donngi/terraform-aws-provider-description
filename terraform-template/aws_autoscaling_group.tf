#-----------------------------------------------------------------------
# AWS Auto Scaling Group
#-----------------------------------------------------------------------
# Auto Scaling Groupを作成するためのリソース
# EC2インスタンスの自動スケーリング、ヘルスチェック、
# ロードバランサー統合などの機能を提供
#
# NOTE:
# - launch_configuration、launch_template、mixed_instances_policy
#   のいずれか1つを必ず指定する必要があります
# - load_balancers、target_group_arns、traffic_sourceの重複使用は
#   避けてください（競合が発生します）
#
# 公式ドキュメント:
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group
#
# Provider Version: 6.28.0
# Generated: 2026-02-11
#-----------------------------------------------------------------------

resource "aws_autoscaling_group" "example" {
  #-----------------------------------------------------------------------
  # 必須パラメータ
  #-----------------------------------------------------------------------

  # 設定内容: Auto Scaling Groupの最大インスタンス数
  # 設定可能な値: 0以上の整数
  max_size = 5

  # 設定内容: Auto Scaling Groupの最小インスタンス数
  # 設定可能な値: 0以上の整数
  min_size = 1

  #-----------------------------------------------------------------------
  # 基本設定
  #-----------------------------------------------------------------------

  # 設定内容: Auto Scaling Groupの名前
  # 設定可能な値: 任意の文字列
  # 省略時: AWSが自動生成
  name = "example-asg"

  # 設定内容: Auto Scaling Group名のプレフィックス
  # 設定可能な値: 任意の文字列
  # 省略時: なし
  # 注意: nameと同時に指定不可
  name_prefix = ""

  # 設定内容: Auto Scaling Groupの目標インスタンス数
  # 設定可能な値: min_size〜max_sizeの範囲内の整数
  # 省略時: min_sizeの値
  desired_capacity = 3

  # 設定内容: 目標容量のタイプ
  # 設定可能な値: units, vcpus, memory-mib
  # 省略時: units
  desired_capacity_type = ""

  #-----------------------------------------------------------------------
  # 配置設定
  #-----------------------------------------------------------------------

  # 設定内容: インスタンスを配置するアベイラビリティゾーン
  # 設定可能な値: AZのリスト（例: ["us-east-1a", "us-east-1b"]）
  # 省略時: vpc_zone_identifierから自動決定
  # 注意: vpc_zone_identifierと併用可能
  availability_zones = ["us-east-1a", "us-east-1b"]

  # 設定内容: インスタンスを配置するサブネットID
  # 設定可能な値: サブネットIDのリスト
  # 省略時: なし
  # 注意: VPC内で使用する場合は必須
  vpc_zone_identifier = []

  # 設定内容: Placement Groupの名前
  # 設定可能な値: 既存のPlacement Group名
  # 省略時: なし
  placement_group = ""

  #-----------------------------------------------------------------------
  # 起動設定
  #-----------------------------------------------------------------------

  # 設定内容: 使用する起動設定の名前
  # 設定可能な値: 既存の起動設定名
  # 省略時: なし
  # 注意: launch_template、mixed_instances_policyとは排他的
  launch_configuration = "example-lc"

  #-----------------------------------------------------------------------
  # ヘルスチェック設定
  #-----------------------------------------------------------------------

  # 設定内容: ヘルスチェックのタイプ
  # 設定可能な値: EC2, ELB
  # 省略時: EC2
  health_check_type = "EC2"

  # 設定内容: インスタンス起動後のヘルスチェック猶予期間（秒）
  # 設定可能な値: 0以上の整数
  # 省略時: 300秒
  # 注意: health_check_type=ELBの場合は設定推奨
  health_check_grace_period = 300

  #-----------------------------------------------------------------------
  # スケーリング動作設定
  #-----------------------------------------------------------------------

  # 設定内容: スケーリング操作後のクールダウン期間（秒）
  # 設定可能な値: 0以上の整数
  # 省略時: 300秒
  default_cooldown = 300

  # 設定内容: インスタンスのデフォルトウォームアップ時間（秒）
  # 設定可能な値: 0以上の整数
  # 省略時: なし
  default_instance_warmup = 0

  # 設定内容: Capacity Rebalancingの有効化
  # 設定可能な値: true, false
  # 省略時: false
  # 注意: スポットインスタンス使用時に推奨
  capacity_rebalance = false

  # 設定内容: スケールイン時の保護
  # 設定可能な値: true, false
  # 省略時: false
  protect_from_scale_in = false

  # 設定内容: 失敗したスケーリングアクティビティの無視
  # 設定可能な値: true, false
  # 省略時: false
  ignore_failed_scaling_activities = false

  #-----------------------------------------------------------------------
  # インスタンスライフサイクル設定
  #-----------------------------------------------------------------------

  # 設定内容: インスタンスの最大有効期間（秒）
  # 設定可能な値: 0（無制限）または604800以上の整数
  # 省略時: 0（無制限）
  max_instance_lifetime = 0

  # 設定内容: 終了ポリシー
  # 設定可能な値: OldestInstance, NewestInstance, OldestLaunchConfiguration,
  #               ClosestToNextInstanceHour, Default, OldestLaunchTemplate,
  #               AllocationStrategy
  # 省略時: ["Default"]
  termination_policies = ["Default"]

  # 設定内容: 一時停止するプロセス
  # 設定可能な値: Launch, Terminate, AddToLoadBalancer, AlarmNotification,
  #               AZRebalance, HealthCheck, InstanceRefresh, ReplaceUnhealthy,
  #               ScheduledActions
  # 省略時: なし
  suspended_processes = []

  #-----------------------------------------------------------------------
  # ロードバランサー統合
  #-----------------------------------------------------------------------

  # 設定内容: アタッチするClassic Load Balancerの名前
  # 設定可能な値: ELB名のリスト
  # 省略時: なし
  # 注意: aws_autoscaling_attachmentとの併用不可
  load_balancers = []

  # 設定内容: アタッチするTarget GroupのARN
  # 設定可能な値: Target Group ARNのリスト
  # 省略時: なし
  # 注意: aws_autoscaling_attachmentとの併用不可
  target_group_arns = []

  #-----------------------------------------------------------------------
  # メトリクス収集
  #-----------------------------------------------------------------------

  # 設定内容: 有効化するメトリクス
  # 設定可能な値: GroupMinSize, GroupMaxSize, GroupDesiredCapacity,
  #               GroupInServiceInstances, GroupPendingInstances,
  #               GroupStandbyInstances, GroupTerminatingInstances,
  #               GroupTotalInstances
  # 省略時: なし
  enabled_metrics = []

  # 設定内容: メトリクスの収集間隔
  # 設定可能な値: 1Minute
  # 省略時: 1Minute
  metrics_granularity = "1Minute"

  #-----------------------------------------------------------------------
  # Terraform動作設定
  #-----------------------------------------------------------------------

  # 設定内容: 削除時のインスタンス強制終了
  # 設定可能な値: true, false
  # 省略時: false
  # 注意: trueの場合、削除時に全インスタンスを強制終了
  force_delete = false

  # 設定内容: 削除時のWarm Poolインスタンス強制終了
  # 設定可能な値: true, false
  # 省略時: false
  force_delete_warm_pool = false

  # 設定内容: 容量確保の待機タイムアウト
  # 設定可能な値: 時間文字列（例: 10m）
  # 省略時: 10m
  wait_for_capacity_timeout = "10m"

  # 設定内容: ELBヘルスチェック通過待機数
  # 設定可能な値: 0以上の整数
  # 省略時: なし
  # 注意: health_check_type=ELBの場合に使用可能
  wait_for_elb_capacity = 0

  # 設定内容: ELB容量の最小値
  # 設定可能な値: 0以上の整数
  # 省略時: なし
  min_elb_capacity = 0

  #-----------------------------------------------------------------------
  # その他の設定
  #-----------------------------------------------------------------------

  # 設定内容: Service Linked RoleのARN
  # 設定可能な値: IAM RoleのARN
  # 省略時: デフォルトのService Linked Roleを使用
  service_linked_role_arn = ""

  # 設定内容: リージョンの指定
  # 設定可能な値: AWSリージョンコード
  # 省略時: プロバイダーのデフォルトリージョン
  region = ""

  # 設定内容: コンテキスト情報
  # 設定可能な値: 任意の文字列
  # 省略時: なし
  context = ""

  #-----------------------------------------------------------------------
  # Launch Template設定
  #-----------------------------------------------------------------------

  # launch_template {
  #   # 設定内容: Launch TemplateのID
  #   # 設定可能な値: Launch TemplateのID
  #   # 省略時: nameを使用
  #   # id = aws_launch_template.example.id
  #
  #   # 設定内容: Launch Templateの名前
  #   # 設定可能な値: Launch Template名
  #   # 省略時: idを使用
  #   # name = aws_launch_template.example.name
  #
  #   # 設定内容: Launch Templateのバージョン
  #   # 設定可能な値: バージョン番号、$Latest、$Default
  #   # 省略時: $Default
  #   # version = "$Latest"
  # }

  #-----------------------------------------------------------------------
  # Mixed Instances Policy設定
  #-----------------------------------------------------------------------

  # mixed_instances_policy {
  #   # instances_distribution {
  #   #   # 設定内容: オンデマンドインスタンスの基本容量
  #   #   # 設定可能な値: 0以上の整数
  #   #   # 省略時: 0
  #   #   on_demand_base_capacity = 0
  #   #
  #   #   # 設定内容: 基本容量超過分のオンデマンド割合（%）
  #   #   # 設定可能な値: 0〜100
  #   #   # 省略時: 100
  #   #   on_demand_percentage_above_base_capacity = 25
  #   #
  #   #   # 設定内容: スポットインスタンスの割り当て戦略
  #   #   # 設定可能な値: lowest-price, capacity-optimized,
  #   #   #               capacity-optimized-prioritized, price-capacity-optimized
  #   #   # 省略時: lowest-price
  #   #   spot_allocation_strategy = "capacity-optimized"
  #   #
  #   #   # 設定内容: スポットプールの数（lowest-price戦略時）
  #   #   # 設定可能な値: 1〜20
  #   #   # 省略時: 2
  #   #   spot_instance_pools = 2
  #   #
  #   #   # 設定内容: オンデマンド価格に対するスポット最大価格の割合（%）
  #   #   # 設定可能な値: 任意の文字列（パーセンテージ）
  #   #   # 省略時: 100%
  #   #   spot_max_price = ""
  #   # }
  #   #
  #   # launch_template {
  #   #   launch_template_specification {
  #   #     # 設定内容: Launch TemplateのID
  #   #     # 設定可能な値: Launch TemplateのID
  #   #     # 省略時: launch_template_nameを使用
  #   #     launch_template_id = aws_launch_template.example.id
  #   #
  #   #     # 設定内容: Launch Templateの名前
  #   #     # 設定可能な値: Launch Template名
  #   #     # 省略時: launch_template_idを使用
  #   #     # launch_template_name = aws_launch_template.example.name
  #   #
  #   #     # 設定内容: Launch Templateのバージョン
  #   #     # 設定可能な値: バージョン番号、$Latest、$Default
  #   #     # 省略時: $Default
  #   #     version = "$Latest"
  #   #   }
  #   #
  #   #   # override {
  #   #   #   # 設定内容: オーバーライドするインスタンスタイプ
  #   #   #   # 設定可能な値: EC2インスタンスタイプ
  #   #   #   # 省略時: instance_requirementsを使用
  #   #   #   instance_type = "c4.large"
  #   #   #
  #   #   #   # 設定内容: インスタンスの重み
  #   #   #   # 設定可能な値: 任意の文字列（数値）
  #   #   #   # 省略時: 1
  #   #   #   weighted_capacity = "3"
  #   #   #
  #   #   #   # launch_template_specification {
  #   #   #   #   # インスタンスタイプ固有のLaunch Template設定
  #   #   #   #   launch_template_id = aws_launch_template.override.id
  #   #   #   #   version = "$Latest"
  #   #   #   # }
  #   #   #
  #   #   #   # instance_requirements {
  #   #   #   #   # 設定内容: メモリの要件（MiB）
  #   #   #   #   memory_mib {
  #   #   #   #     min = 1000
  #   #   #   #     max = 8000
  #   #   #   #   }
  #   #   #   #
  #   #   #   #   # 設定内容: vCPUの要件
  #   #   #   #   vcpu_count {
  #   #   #   #     min = 2
  #   #   #   #     max = 8
  #   #   #   #   }
  #   #   #   #
  #   #   #   #   # 設定内容: 許可されるインスタンスタイプ
  #   #   #   #   # 設定可能な値: インスタンスタイプのリスト
  #   #   #   #   # 省略時: すべてのタイプ
  #   #   #   #   # allowed_instance_types = ["c5.*", "c6g.*"]
  #   #   #   #
  #   #   #   #   # 設定内容: 除外するインスタンスタイプ
  #   #   #   #   # 設定可能な値: インスタンスタイプのリスト
  #   #   #   #   # 省略時: なし
  #   #   #   #   # excluded_instance_types = ["t2.*"]
  #   #   #   #
  #   #   #   #   # 設定内容: ベアメタルの要件
  #   #   #   #   # 設定可能な値: included, excluded, required
  #   #   #   #   # 省略時: included
  #   #   #   #   # bare_metal = "excluded"
  #   #   #   #
  #   #   #   #   # 設定内容: バーストパフォーマンスの要件
  #   #   #   #   # 設定可能な値: included, excluded, required
  #   #   #   #   # 省略時: included
  #   #   #   #   # burstable_performance = "excluded"
  #   #   #   #
  #   #   #   #   # 設定内容: CPUメーカーの要件
  #   #   #   #   # 設定可能な値: amazon-web-services, amd, intel
  #   #   #   #   # 省略時: すべてのメーカー
  #   #   #   #   # cpu_manufacturers = ["intel", "amd"]
  #   #   #   #
  #   #   #   #   # 設定内容: インスタンス世代の要件
  #   #   #   #   # 設定可能な値: current, previous
  #   #   #   #   # 省略時: すべての世代
  #   #   #   #   # instance_generations = ["current"]
  #   #   #   #
  #   #   #   #   # 設定内容: ローカルストレージの要件
  #   #   #   #   # 設定可能な値: included, excluded, required
  #   #   #   #   # 省略時: included
  #   #   #   #   # local_storage = "excluded"
  #   #   #   #
  #   #   #   #   # 設定内容: ローカルストレージタイプの要件
  #   #   #   #   # 設定可能な値: hdd, ssd
  #   #   #   #   # 省略時: すべてのタイプ
  #   #   #   #   # local_storage_types = ["ssd"]
  #   #   #   #
  #   #   #   #   # 設定内容: 合計ローカルストレージ容量（GB）
  #   #   #   #   # total_local_storage_gb {
  #   #   #   #   #   min = 100
  #   #   #   #   #   max = 1000
  #   #   #   #   # }
  #   #   #   #
  #   #   #   #   # 設定内容: ベースラインEBSバンド幅（Mbps）
  #   #   #   #   # baseline_ebs_bandwidth_mbps {
  #   #   #   #   #   min = 1000
  #   #   #   #   #   max = 5000
  #   #   #   #   # }
  #   #   #   #
  #   #   #   #   # 設定内容: アクセラレータータイプの要件
  #   #   #   #   # 設定可能な値: gpu, fpga, inference
  #   #   #   #   # 省略時: すべてのタイプ
  #   #   #   #   # accelerator_types = ["gpu"]
  #   #   #   #
  #   #   #   #   # 設定内容: アクセラレーター数
  #   #   #   #   # accelerator_count {
  #   #   #   #   #   min = 1
  #   #   #   #   #   max = 4
  #   #   #   #   # }
  #   #   #   #
  #   #   #   #   # 設定内容: アクセラレーターメーカーの要件
  #   #   #   #   # 設定可能な値: nvidia, amd, amazon-web-services, xilinx
  #   #   #   #   # 省略時: すべてのメーカー
  #   #   #   #   # accelerator_manufacturers = ["nvidia"]
  #   #   #   #
  #   #   #   #   # 設定内容: アクセラレーター名の要件
  #   #   #   #   # 設定可能な値: a100, v100, k80, t4, m60, radeon-pro-v520, vu9p等
  #   #   #   #   # 省略時: すべての名前
  #   #   #   #   # accelerator_names = ["a100", "v100"]
  #   #   #   #
  #   #   #   #   # 設定内容: 合計アクセラレーターメモリ（MiB）
  #   #   #   #   # accelerator_total_memory_mib {
  #   #   #   #   #   min = 8000
  #   #   #   #   #   max = 40000
  #   #   #   #   # }
  #   #   #   #
  #   #   #   #   # 設定内容: ネットワークインターフェース数
  #   #   #   #   # network_interface_count {
  #   #   #   #   #   min = 1
  #   #   #   #   #   max = 4
  #   #   #   #   # }
  #   #   #   #
  #   #   #   #   # 設定内容: オンデマンド最大価格（インスタンス/時間のパーセンテージ）
  #   #   #   #   # 設定可能な値: 1〜999の整数
  #   #   #   #   # 省略時: 上限なし
  #   #   #   #   # on_demand_max_price_percentage_over_lowest_price = 100
  #   #   #   #
  #   #   #   #   # 設定内容: ENA Expressのサポート要件
  #   #   #   #   # 設定可能な値: included, excluded, required
  #   #   #   #   # 省略時: included
  #   #   #   #   # require_hibernate_support = false
  #   #   #   #
  #   #   #   #   # 設定内容: スポット最大価格（インスタンス/時間のパーセンテージ）
  #   #   #   #   # 設定可能な値: 1〜999の整数
  #   #   #   #   # 省略時: 100
  #   #   #   #   # spot_max_price_percentage_over_lowest_price = 100
  #   #   #   #
  #   #   #   #   # 設定内容: ネットワークバンド幅（Gbps）
  #   #   #   #   # network_bandwidth_gbps {
  #   #   #   #   #   min = 10
  #   #   #   #   #   max = 100
  #   #   #   #   # }
  #   #   #   # }
  #   #   # }
  #   # }
  # }

  #-----------------------------------------------------------------------
  # Initial Lifecycle Hook設定
  #-----------------------------------------------------------------------

  # initial_lifecycle_hook {
  #   # 設定内容: ライフサイクルフックの名前
  #   # 設定可能な値: 任意の文字列
  #   name = "example-hook"
  #
  #   # 設定内容: デフォルトの結果
  #   # 設定可能な値: CONTINUE, ABANDON
  #   # 省略時: ABANDON
  #   default_result = "CONTINUE"
  #
  #   # 設定内容: ハートビートタイムアウト（秒）
  #   # 設定可能な値: 30〜7200
  #   # 省略時: 3600
  #   heartbeat_timeout = 3600
  #
  #   # 設定内容: ライフサイクルの遷移タイミング
  #   # 設定可能な値: autoscaling:EC2_INSTANCE_LAUNCHING,
  #   #               autoscaling:EC2_INSTANCE_TERMINATING
  #   lifecycle_transition = "autoscaling:EC2_INSTANCE_LAUNCHING"
  #
  #   # 設定内容: 通知先のARN
  #   # 設定可能な値: SNS TopicまたはSQS QueueのARN
  #   # 省略時: なし
  #   # notification_target_arn = "arn:aws:sns:us-east-1:123456789012:example-topic"
  #
  #   # 設定内容: IAM RoleのARN
  #   # 設定可能な値: IAM RoleのARN
  #   # 省略時: なし
  #   # role_arn = "arn:aws:iam::123456789012:role/example-role"
  #
  #   # 設定内容: 通知メタデータ
  #   # 設定可能な値: 任意の文字列（JSON形式推奨）
  #   # 省略時: なし
  #   # notification_metadata = jsonencode({
  #   #   environment = "production"
  #   # })
  # }

  #-----------------------------------------------------------------------
  # Instance Refresh設定
  #-----------------------------------------------------------------------

  # instance_refresh {
  #   # 設定内容: インスタンスリフレッシュ戦略
  #   # 設定可能な値: Rolling
  #   strategy = "Rolling"
  #
  #   # preferences {
  #   #   # 設定内容: リフレッシュ中に維持する最小ヘルシー率（%）
  #   #   # 設定可能な値: 0〜100
  #   #   # 省略時: 90
  #   #   min_healthy_percentage = 50
  #   #
  #   #   # 設定内容: インスタンスウォームアップ時間（秒）
  #   #   # 設定可能な値: 0以上の整数
  #   #   # 省略時: default_instance_warmupの値
  #   #   instance_warmup = 300
  #   #
  #   #   # 設定内容: チェックポイント到達時のリフレッシュ待機割合（%）
  #   #   # 設定可能な値: 1〜100のリスト
  #   #   # 省略時: なし
  #   #   checkpoint_percentages = [50, 100]
  #   #
  #   #   # 設定内容: チェックポイント到達後の待機時間（秒）
  #   #   # 設定可能な値: 0以上の整数
  #   #   # 省略時: 3600
  #   #   checkpoint_delay = 3600
  #   #
  #   #   # 設定内容: スケールイン保護されたインスタンスのスキップ
  #   #   # 設定可能な値: true, false
  #   #   # 省略時: false
  #   #   skip_matching = false
  #   #
  #   #   # 設定内容: 自動ロールバックの有効化
  #   #   # 設定可能な値: true, false
  #   #   # 省略時: false
  #   #   auto_rollback = false
  #   #
  #   #   # 設定内容: スタンバイインスタンスのスケールイン保護
  #   #   # 設定可能な値: true, false
  #   #   # 省略時: false
  #   #   scale_in_protected_instances = "Ignore"
  #   #
  #   #   # 設定内容: スタンバイインスタンスの処理
  #   #   # 設定可能な値: Ignore, Refresh, Wait
  #   #   # 省略時: Ignore
  #   #   standby_instances = "Ignore"
  #   #
  #   #   # alarm_specification {
  #   #   #   # 設定内容: 監視するCloudWatchアラーム名
  #   #   #   # 設定可能な値: アラーム名のリスト
  #   #   #   alarms = ["example-alarm"]
  #   #   # }
  #   # }
  #
  #   # 設定内容: リフレッシュをトリガーするリソース変更
  #   # 設定可能な値: tag, desired_capacity等のリソース属性名
  #   # 省略時: なし
  #   # triggers = ["tag"]
  # }

  #-----------------------------------------------------------------------
  # Warm Pool設定
  #-----------------------------------------------------------------------

  # warm_pool {
  #   # 設定内容: Warm Pool内のインスタンスの状態
  #   # 設定可能な値: Stopped, Running, Hibernated
  #   # 省略時: Stopped
  #   pool_state = "Stopped"
  #
  #   # 設定内容: Warm Poolの最小サイズ
  #   # 設定可能な値: 0以上の整数
  #   # 省略時: 0
  #   min_size = 0
  #
  #   # 設定内容: Warm Pool内の準備済み最大容量
  #   # 設定可能な値: -1（無制限）または0以上の整数
  #   # 省略時: -1
  #   # 注意: max_sizeと異なる場合の最大容量
  #   max_group_prepared_capacity = -1
  #
  #   # instance_reuse_policy {
  #   #   # 設定内容: スケールイン時のインスタンス再利用
  #   #   # 設定可能な値: true, false
  #   #   # 省略時: false
  #   #   reuse_on_scale_in = true
  #   # }
  # }

  #-----------------------------------------------------------------------
  # Traffic Source設定
  #-----------------------------------------------------------------------

  # traffic_source {
  #   # 設定内容: トラフィックソースの識別子
  #   # 設定可能な値: Target GroupまたはVPC Lattice Target GroupのARN
  #   identifier = "arn:aws:elasticloadbalancing:us-east-1:123456789012:targetgroup/example/1234567890abcdef"
  #
  #   # 設定内容: トラフィックソースのタイプ
  #   # 設定可能な値: elb, elbv2, vpc-lattice
  #   # 省略時: elbv2
  #   type = "elbv2"
  # }

  #-----------------------------------------------------------------------
  # Availability Zone Distribution設定
  #-----------------------------------------------------------------------

  # availability_zone_distribution {
  #   # 設定内容: AZ配置の不均衡処理
  #   # 設定可能な値: best-effort, any, balanced
  #   # 省略時: balanced
  #   capacity_distribution_strategy = "balanced"
  # }

  #-----------------------------------------------------------------------
  # Capacity Reservation設定
  #-----------------------------------------------------------------------

  # capacity_reservation_specification {
  #   # 設定内容: Capacity Reservationの使用設定
  #   # 設定可能な値: open, none, capacity-reservations-only
  #   # 省略時: open
  #   capacity_reservation_preference = "open"
  #
  #   # capacity_reservation_target {
  #   #   # 設定内容: Capacity ReservationのID
  #   #   # 設定可能な値: Capacity ReservationのID
  #   #   # 省略時: capacity_reservation_resource_group_arnを使用
  #   #   capacity_reservation_id = "cr-1234567890abcdef0"
  #   #
  #   #   # 設定内容: Capacity Reservation Resource GroupのARN
  #   #   # 設定可能な値: Resource GroupのARN
  #   #   # 省略時: capacity_reservation_idを使用
  #   #   # capacity_reservation_resource_group_arn = "arn:aws:resource-groups:us-east-1:123456789012:group/example"
  #   # }
  # }

  #-----------------------------------------------------------------------
  # Instance Maintenance Policy設定
  #-----------------------------------------------------------------------

  # instance_maintenance_policy {
  #   # 設定内容: 最小ヘルシー率（%）
  #   # 設定可能な値: 90〜100
  #   # 省略時: 90
  #   min_healthy_percentage = 90
  #
  #   # 設定内容: 最大ヘルシー率（%）
  #   # 設定可能な値: 100〜200
  #   # 省略時: 120
  #   max_healthy_percentage = 120
  # }

  #-----------------------------------------------------------------------
  # タグ設定
  #-----------------------------------------------------------------------

  # tag {
  #   # 設定内容: タグのキー
  #   # 設定可能な値: 任意の文字列
  #   key = "Name"
  #
  #   # 設定内容: タグの値
  #   # 設定可能な値: 任意の文字列
  #   value = "example-asg-instance"
  #
  #   # 設定内容: 起動時のインスタンスへのタグ伝播
  #   # 設定可能な値: true, false
  #   # 省略時: false
  #   propagate_at_launch = true
  # }

  #-----------------------------------------------------------------------
  # タイムアウト設定
  #-----------------------------------------------------------------------

  # timeouts {
  #   # 設定内容: 作成時のタイムアウト
  #   # 設定可能な値: 時間文字列（例: 15m）
  #   # 省略時: 15分
  #   # create = "15m"
  #
  #   # 設定内容: 更新時のタイムアウト
  #   # 設定可能な値: 時間文字列（例: 15m）
  #   # 省略時: 15分
  #   # update = "15m"
  #
  #   # 設定内容: 削除時のタイムアウト
  #   # 設定可能な値: 時間文字列（例: 15m）
  #   # 省略時: 15分
  #   # delete = "15m"
  # }
}

#-----------------------------------------------------------------------
# Attributes Reference
#-----------------------------------------------------------------------
# このリソースでは以下の属性が参照可能です:
#
# - id - Auto Scaling GroupのID（名前と同じ）
# - arn - Auto Scaling GroupのARN
# - name - Auto Scaling Groupの名前
# - availability_zones - 使用中のアベイラビリティゾーン
# - min_size - 最小インスタンス数
# - max_size - 最大インスタンス数
# - desired_capacity - 目標インスタンス数
# - default_cooldown - デフォルトクールダウン期間
# - default_instance_warmup - デフォルトインスタンスウォームアップ時間
# - health_check_type - ヘルスチェックタイプ
# - health_check_grace_period - ヘルスチェック猶予期間
# - launch_configuration - 使用中の起動設定名
# - vpc_zone_identifier - 使用中のサブネットID
# - predicted_capacity - 予測容量
# - warm_pool_size - Warm Poolの現在サイズ
#
# 参照例:
# output "asg_id" {
#   value = aws_autoscaling_group.example.id
# }
