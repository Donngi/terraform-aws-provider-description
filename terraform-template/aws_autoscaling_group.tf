#---------------------------------------------------------------
# AWS Auto Scaling Group
#---------------------------------------------------------------
#
# Amazon EC2 Auto Scaling グループをプロビジョニングするリソースです。
# Auto Scaling グループは、アプリケーションの可用性を維持し、
# 定義した条件に従って EC2 キャパシティを自動的にスケーリングする機能を提供します。
#
# AWS公式ドキュメント:
#   - Auto Scaling グループ: https://docs.aws.amazon.com/autoscaling/ec2/userguide/auto-scaling-groups.html
#   - インスタンスリフレッシュ: https://docs.aws.amazon.com/autoscaling/ec2/userguide/asg-instance-refresh.html
#   - ライフサイクルフック: https://docs.aws.amazon.com/autoscaling/ec2/userguide/lifecycle-hooks.html
#   - ウォームプール: https://docs.aws.amazon.com/autoscaling/ec2/userguide/ec2-auto-scaling-warm-pools.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group
#
# Provider Version: 6.28.0
# Generated: 2026-01-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
# 重要: launch_configuration, launch_template, mixed_instances_policy の
#       いずれか1つを必ず指定する必要があります。
#
#---------------------------------------------------------------

resource "aws_autoscaling_group" "example" {
  #-------------------------------------------------------------
  # 基本設定 (必須)
  #-------------------------------------------------------------

  # max_size (Required)
  # 設定内容: Auto Scaling グループの最大インスタンス数を指定します。
  # 設定可能な値: 0 以上の整数
  max_size = 4

  # min_size (Required)
  # 設定内容: Auto Scaling グループの最小インスタンス数を指定します。
  # 設定可能な値: 0 以上の整数
  min_size = 1

  #-------------------------------------------------------------
  # 名前設定
  #-------------------------------------------------------------

  # name (Optional, Forces new resource)
  # 設定内容: Auto Scaling グループの名前を指定します。
  # 設定可能な値: 文字列
  # 省略時: Terraform がランダムな一意の名前を生成します。
  # 注意: name_prefix と排他的（どちらか一方のみ指定可能）
  name = "my-asg"

  # name_prefix (Optional, Forces new resource)
  # 設定内容: Auto Scaling グループ名のプレフィックスを指定します。
  # 設定可能な値: 文字列。Terraform が後ろにランダムなサフィックスを追加します。
  # 注意: name と排他的（どちらか一方のみ指定可能）
  # name_prefix = "my-asg-"

  #-------------------------------------------------------------
  # 希望キャパシティ設定
  #-------------------------------------------------------------

  # desired_capacity (Optional)
  # 設定内容: 希望するインスタンス数を指定します。
  # 設定可能な値: min_size 以上、max_size 以下の整数
  # 省略時: min_size の値が使用されます。
  desired_capacity = 2

  # desired_capacity_type (Optional)
  # 設定内容: 希望キャパシティの単位を指定します。
  # 設定可能な値:
  #   - "units" (デフォルト): インスタンス数
  #   - "vcpu": vCPU 数
  #   - "memory-mib": メモリ量 (MiB)
  # 関連機能: 属性ベースのインスタンス選択
  #   vCPU やメモリに基づいてスケーリングする場合に使用します。
  desired_capacity_type = "units"

  #-------------------------------------------------------------
  # 起動設定
  #-------------------------------------------------------------

  # launch_configuration (Optional)
  # 設定内容: 起動設定の名前または ID を指定します。
  # 注意: launch_template または mixed_instances_policy と排他的
  # 非推奨: launch_template の使用が推奨されています。
  # launch_configuration = aws_launch_configuration.example.name

  # launch_template (Optional)
  # 設定内容: 起動テンプレートを指定します。
  # 注意: launch_configuration または mixed_instances_policy と排他的
  launch_template {
    # id (Optional)
    # 設定内容: 起動テンプレートの ID を指定します。
    # 注意: name と排他的
    id = "lt-0123456789abcdef0"

    # name (Optional)
    # 設定内容: 起動テンプレートの名前を指定します。
    # 注意: id と排他的
    # name = "my-launch-template"

    # version (Optional)
    # 設定内容: 起動テンプレートのバージョンを指定します。
    # 設定可能な値:
    #   - "$Latest": 最新バージョン
    #   - "$Default": デフォルトバージョン
    #   - 特定のバージョン番号 (例: "1")
    version = "$Latest"
  }

  #-------------------------------------------------------------
  # mixed_instances_policy (Optional)
  #-------------------------------------------------------------
  # 設定内容: オンデマンドとスポットインスタンスを混合して使用するポリシーを指定します。
  # 注意: launch_configuration または launch_template と排他的
  # 関連機能: Mixed Instances Policy
  #   複数のインスタンスタイプとスポット/オンデマンドの組み合わせで
  #   コスト最適化と可用性を両立させることができます。
  #   - https://docs.aws.amazon.com/autoscaling/ec2/userguide/ec2-auto-scaling-mixed-instances-groups.html

  # mixed_instances_policy {
  #   #---------------------------------------------------------
  #   # instances_distribution (Optional)
  #   #---------------------------------------------------------
  #   # 設定内容: オンデマンドとスポットインスタンスの配分を設定します。
  #   instances_distribution {
  #     # on_demand_allocation_strategy (Optional)
  #     # 設定内容: オンデマンドインスタンスの割り当て戦略を指定します。
  #     # 設定可能な値:
  #     #   - "prioritized" (デフォルト): 起動テンプレートの override で指定した順序で優先
  #     #   - "lowest-price": 最も低価格のインスタンスタイプを優先
  #     on_demand_allocation_strategy = "prioritized"

  #     # on_demand_base_capacity (Optional)
  #     # 設定内容: オンデマンドインスタンスで満たす最小容量を指定します。
  #     # 設定可能な値: 0 以上の整数
  #     # 省略時: 0
  #     on_demand_base_capacity = 0

  #     # on_demand_percentage_above_base_capacity (Optional)
  #     # 設定内容: ベース容量を超えた分のオンデマンドインスタンスの割合を指定します。
  #     # 設定可能な値: 0-100 の整数
  #     # 省略時: 100 (全てオンデマンド)
  #     on_demand_percentage_above_base_capacity = 25

  #     # spot_allocation_strategy (Optional)
  #     # 設定内容: スポットインスタンスの割り当て戦略を指定します。
  #     # 設定可能な値:
  #     #   - "capacity-optimized" (推奨): 最も利用可能なキャパシティを持つプールを優先
  #     #   - "capacity-optimized-prioritized": キャパシティ最適化しつつ override の順序を考慮
  #     #   - "lowest-price": 最も低価格のプールを優先
  #     #   - "price-capacity-optimized": 価格とキャパシティのバランスを取る
  #     spot_allocation_strategy = "capacity-optimized"

  #     # spot_instance_pools (Optional)
  #     # 設定内容: lowest-price 戦略で使用するスポットプール数を指定します。
  #     # 設定可能な値: 1-20 の整数
  #     # 省略時: 2
  #     # 注意: spot_allocation_strategy が lowest-price の場合のみ有効
  #     spot_instance_pools = 2

  #     # spot_max_price (Optional)
  #     # 設定内容: スポットインスタンスの最大価格を指定します。
  #     # 設定可能な値: 価格を表す文字列 (例: "0.05")
  #     # 省略時: オンデマンド価格が上限
  #     spot_max_price = ""
  #   }

  #   #---------------------------------------------------------
  #   # launch_template (Required within mixed_instances_policy)
  #   #---------------------------------------------------------
  #   launch_template {
  #     # launch_template_specification (Required)
  #     launch_template_specification {
  #       # launch_template_id (Optional)
  #       # 設定内容: 起動テンプレートの ID を指定します。
  #       launch_template_id = "lt-0123456789abcdef0"

  #       # launch_template_name (Optional)
  #       # 設定内容: 起動テンプレートの名前を指定します。
  #       # launch_template_name = "my-launch-template"

  #       # version (Optional)
  #       # 設定内容: 起動テンプレートのバージョンを指定します。
  #       version = "$Latest"
  #     }

  #     # override (Optional)
  #     # 設定内容: 起動テンプレートを上書きする設定を指定します。
  #     override {
  #       # instance_type (Optional)
  #       # 設定内容: インスタンスタイプを指定します。
  #       instance_type = "c5.large"

  #       # weighted_capacity (Optional)
  #       # 設定内容: このインスタンスタイプの重み付けキャパシティを指定します。
  #       weighted_capacity = "1"

  #       # launch_template_specification (Optional)
  #       # 設定内容: この override 専用の起動テンプレートを指定します。
  #       # launch_template_specification {
  #       #   launch_template_id = "lt-0123456789abcdef1"
  #       #   version            = "$Latest"
  #       # }

  #       # instance_requirements (Optional)
  #       # 設定内容: 属性ベースのインスタンス選択要件を指定します。
  #       # instance_requirements {
  #       #   # vcpu_count (Optional)
  #       #   vcpu_count {
  #       #     min = 2
  #       #     max = 8
  #       #   }
  #       #
  #       #   # memory_mib (Optional)
  #       #   memory_mib {
  #       #     min = 4096
  #       #     max = 16384
  #       #   }
  #       #
  #       #   # memory_gib_per_vcpu (Optional)
  #       #   # memory_gib_per_vcpu {
  #       #   #   min = 1
  #       #   #   max = 4
  #       #   # }
  #       #
  #       #   # accelerator_count (Optional)
  #       #   # accelerator_count {
  #       #   #   min = 0
  #       #   #   max = 0
  #       #   # }
  #       #
  #       #   # accelerator_manufacturers (Optional)
  #       #   # 設定可能な値: "amazon-web-services", "amd", "nvidia", "xilinx"
  #       #   # accelerator_manufacturers = ["nvidia"]
  #       #
  #       #   # accelerator_names (Optional)
  #       #   # 設定可能な値: "a100", "v100", "k80", "t4", "m60", "radeon-pro-v520", "vu9p"
  #       #   # accelerator_names = ["t4"]
  #       #
  #       #   # accelerator_total_memory_mib (Optional)
  #       #   # accelerator_total_memory_mib {
  #       #   #   min = 0
  #       #   #   max = 0
  #       #   # }
  #       #
  #       #   # accelerator_types (Optional)
  #       #   # 設定可能な値: "gpu", "fpga", "inference"
  #       #   # accelerator_types = ["gpu"]
  #       #
  #       #   # allowed_instance_types (Optional)
  #       #   # 設定内容: 許可するインスタンスタイプのリスト
  #       #   # allowed_instance_types = ["c5.*", "m5.*"]
  #       #
  #       #   # bare_metal (Optional)
  #       #   # 設定可能な値: "included", "excluded", "required"
  #       #   # bare_metal = "excluded"
  #       #
  #       #   # baseline_ebs_bandwidth_mbps (Optional)
  #       #   # baseline_ebs_bandwidth_mbps {
  #       #   #   min = 0
  #       #   #   max = 10000
  #       #   # }
  #       #
  #       #   # burstable_performance (Optional)
  #       #   # 設定可能な値: "included", "excluded", "required"
  #       #   # burstable_performance = "excluded"
  #       #
  #       #   # cpu_manufacturers (Optional)
  #       #   # 設定可能な値: "intel", "amd", "amazon-web-services"
  #       #   # cpu_manufacturers = ["intel", "amd"]
  #       #
  #       #   # excluded_instance_types (Optional)
  #       #   # 設定内容: 除外するインスタンスタイプのリスト
  #       #   # excluded_instance_types = ["t2.*"]
  #       #
  #       #   # instance_generations (Optional)
  #       #   # 設定可能な値: "current", "previous"
  #       #   # instance_generations = ["current"]
  #       #
  #       #   # local_storage (Optional)
  #       #   # 設定可能な値: "included", "excluded", "required"
  #       #   # local_storage = "excluded"
  #       #
  #       #   # local_storage_types (Optional)
  #       #   # 設定可能な値: "hdd", "ssd"
  #       #   # local_storage_types = ["ssd"]
  #       #
  #       #   # max_spot_price_as_percentage_of_optimal_on_demand_price (Optional)
  #       #   # 設定内容: 最適なオンデマンド価格に対するスポット価格の最大割合
  #       #   # max_spot_price_as_percentage_of_optimal_on_demand_price = 100
  #       #
  #       #   # network_bandwidth_gbps (Optional)
  #       #   # network_bandwidth_gbps {
  #       #   #   min = 0
  #       #   #   max = 100
  #       #   # }
  #       #
  #       #   # network_interface_count (Optional)
  #       #   # network_interface_count {
  #       #   #   min = 1
  #       #   #   max = 8
  #       #   # }
  #       #
  #       #   # on_demand_max_price_percentage_over_lowest_price (Optional)
  #       #   # 設定内容: 最低オンデマンド価格に対する最大価格の割合
  #       #   # on_demand_max_price_percentage_over_lowest_price = 20
  #       #
  #       #   # require_hibernate_support (Optional)
  #       #   # 設定内容: ハイバネーションサポートを要求するか
  #       #   # require_hibernate_support = false
  #       #
  #       #   # spot_max_price_percentage_over_lowest_price (Optional)
  #       #   # 設定内容: 最低スポット価格に対する最大価格の割合
  #       #   # spot_max_price_percentage_over_lowest_price = 100
  #       #
  #       #   # total_local_storage_gb (Optional)
  #       #   # total_local_storage_gb {
  #       #   #   min = 0
  #       #   #   max = 1000
  #       #   # }
  #       # }
  #     }

  #     override {
  #       instance_type     = "c4.large"
  #       weighted_capacity = "1"
  #     }
  #   }
  # }

  #-------------------------------------------------------------
  # ネットワーク設定
  #-------------------------------------------------------------

  # availability_zones (Optional)
  # 設定内容: インスタンスを起動するアベイラビリティーゾーンのリストを指定します。
  # 設定可能な値: 有効な AZ 名のリスト (例: ["ap-northeast-1a", "ap-northeast-1c"])
  # 注意: vpc_zone_identifier を指定した場合、そのサブネットの AZ が優先されます。
  availability_zones = ["ap-northeast-1a", "ap-northeast-1c"]

  # vpc_zone_identifier (Optional)
  # 設定内容: インスタンスを起動する VPC サブネット ID のリストを指定します。
  # 設定可能な値: 有効なサブネット ID のリスト
  # 推奨: availability_zones よりも vpc_zone_identifier の使用が推奨されます。
  # vpc_zone_identifier = ["subnet-0123456789abcdef0", "subnet-0123456789abcdef1"]

  # placement_group (Optional)
  # 設定内容: インスタンスを起動するプレイスメントグループの名前を指定します。
  # 設定可能な値: 有効なプレイスメントグループ名
  # 関連機能: プレイスメントグループ
  #   インスタンス間の低レイテンシー通信が必要な場合に使用します。
  #   - https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/placement-groups.html
  # placement_group = "my-placement-group"

  #-------------------------------------------------------------
  # availability_zone_distribution (Optional)
  #-------------------------------------------------------------
  # 設定内容: アベイラビリティーゾーン間の容量分散戦略を指定します。
  # 関連機能: Availability Zone Distribution
  #   複数の AZ にまたがるグループでの容量分散方法を制御します。

  # availability_zone_distribution {
  #   # capacity_distribution_strategy (Optional)
  #   # 設定内容: 容量分散戦略を指定します。
  #   # 設定可能な値:
  #   #   - "balanced-only": AZ 間でバランスを維持
  #   #   - "balanced-best-effort": 可能な限りバランスを維持
  #   capacity_distribution_strategy = "balanced-best-effort"
  # }

  #-------------------------------------------------------------
  # capacity_reservation_specification (Optional)
  #-------------------------------------------------------------
  # 設定内容: キャパシティ予約の設定を指定します。
  # 関連機能: EC2 Capacity Reservations
  #   特定のアベイラビリティーゾーンで EC2 キャパシティを予約できます。
  #   - https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-capacity-reservations.html

  # capacity_reservation_specification {
  #   # capacity_reservation_preference (Optional)
  #   # 設定内容: キャパシティ予約の優先設定を指定します。
  #   # 設定可能な値:
  #   #   - "open": 一致するオープンなキャパシティ予約を使用
  #   #   - "none": キャパシティ予約を使用しない
  #   capacity_reservation_preference = "open"

  #   # capacity_reservation_target (Optional)
  #   # 設定内容: 特定のキャパシティ予約をターゲットにします。
  #   # capacity_reservation_target {
  #   #   # capacity_reservation_ids (Optional)
  #   #   # 設定内容: ターゲットとするキャパシティ予約 ID のリスト
  #   #   capacity_reservation_ids = ["cr-0123456789abcdef0"]

  #   #   # capacity_reservation_resource_group_arns (Optional)
  #   #   # 設定内容: キャパシティ予約リソースグループの ARN のリスト
  #   #   # capacity_reservation_resource_group_arns = ["arn:aws:resource-groups:..."]
  #   # }
  # }

  #-------------------------------------------------------------
  # ロードバランサー設定
  #-------------------------------------------------------------

  # load_balancers (Optional)
  # 設定内容: Classic Load Balancer の名前のリストを指定します。
  # 設定可能な値: CLB 名のリスト
  # 注意: target_group_arns または traffic_source と併用しないでください。
  # load_balancers = ["my-classic-lb"]

  # target_group_arns (Optional)
  # 設定内容: ALB/NLB/GLB ターゲットグループの ARN のリストを指定します。
  # 設定可能な値: ターゲットグループ ARN のリスト
  # 注意: traffic_source との併用に注意（同じターゲットを重複指定しないこと）
  # target_group_arns = ["arn:aws:elasticloadbalancing:ap-northeast-1:123456789012:targetgroup/my-tg/0123456789abcdef"]

  #-------------------------------------------------------------
  # traffic_source (Optional)
  #-------------------------------------------------------------
  # 設定内容: トラフィックソースを指定します。
  # 関連機能: Traffic Sources
  #   ELB ターゲットグループや VPC Lattice ターゲットグループをアタッチできます。
  # 注意: target_group_arns との併用に注意（同じターゲットを重複指定しないこと）

  # traffic_source {
  #   # identifier (Required)
  #   # 設定内容: トラフィックソースの識別子 (ターゲットグループ ARN など) を指定します。
  #   identifier = "arn:aws:elasticloadbalancing:ap-northeast-1:123456789012:targetgroup/my-tg/0123456789abcdef"

  #   # type (Optional)
  #   # 設定内容: トラフィックソースのタイプを指定します。
  #   # 設定可能な値:
  #   #   - "elb": Elastic Load Balancing ターゲットグループ
  #   #   - "vpc-lattice": VPC Lattice ターゲットグループ
  #   type = "elb"
  # }

  #-------------------------------------------------------------
  # ヘルスチェック設定
  #-------------------------------------------------------------

  # health_check_type (Optional)
  # 設定内容: ヘルスチェックのタイプを指定します。
  # 設定可能な値:
  #   - "EC2" (デフォルト): EC2 インスタンスのステータスチェックを使用
  #   - "ELB": ELB のヘルスチェックも使用
  #   - "VPC_LATTICE": VPC Lattice のヘルスチェックも使用
  # 注意: "ELB" 指定時は health_check_grace_period の設定が必須
  health_check_type = "EC2"

  # health_check_grace_period (Optional)
  # 設定内容: インスタンス起動後、ヘルスチェックを開始するまでの猶予時間（秒）を指定します。
  # 設定可能な値: 0 以上の整数
  # 省略時: 300 秒
  # 推奨: アプリケーションの起動に必要な時間を考慮して設定
  health_check_grace_period = 300

  #-------------------------------------------------------------
  # スケーリング設定
  #-------------------------------------------------------------

  # default_cooldown (Optional)
  # 設定内容: デフォルトのクールダウン期間（秒）を指定します。
  # 設定可能な値: 0 以上の整数
  # 省略時: 300 秒
  # 関連機能: クールダウン期間
  #   スケーリングアクティビティ間の待機時間を制御します。
  #   - https://docs.aws.amazon.com/autoscaling/ec2/userguide/ec2-auto-scaling-scaling-cooldowns.html
  default_cooldown = 300

  # default_instance_warmup (Optional)
  # 設定内容: デフォルトのインスタンスウォームアップ時間（秒）を指定します。
  # 設定可能な値: 0 以上の整数
  # 関連機能: インスタンスウォームアップ
  #   新しいインスタンスがメトリクスに貢献し始めるまでの時間を指定します。
  #   - https://docs.aws.amazon.com/autoscaling/ec2/userguide/ec2-auto-scaling-default-instance-warmup.html
  # default_instance_warmup = 120

  # capacity_rebalance (Optional)
  # 設定内容: キャパシティリバランスを有効にするかを指定します。
  # 設定可能な値:
  #   - true: スポットインスタンスの中断リスクが高い場合に事前に新しいインスタンスを起動
  #   - false (デフォルト): キャパシティリバランスを無効
  # 関連機能: Capacity Rebalancing
  #   スポットインスタンスの中断前に新しいインスタンスを起動し、可用性を維持します。
  #   - https://docs.aws.amazon.com/autoscaling/ec2/userguide/ec2-auto-scaling-capacity-rebalancing.html
  # capacity_rebalance = true

  # protect_from_scale_in (Optional)
  # 設定内容: 新しく起動したインスタンスにスケールイン保護を適用するかを指定します。
  # 設定可能な値:
  #   - true: スケールインから保護
  #   - false (デフォルト): 保護なし
  # 関連機能: Instance Scale-In Protection
  #   特定のインスタンスがスケールインイベントで終了されないように保護します。
  #   - https://docs.aws.amazon.com/autoscaling/ec2/userguide/ec2-auto-scaling-instance-protection.html
  # protect_from_scale_in = false

  # max_instance_lifetime (Optional)
  # 設定内容: インスタンスの最大ライフタイム（秒）を指定します。
  # 設定可能な値: 0 または 86400 (1日) 以上の整数
  # 省略時: 制限なし
  # 関連機能: Maximum Instance Lifetime
  #   インスタンスを定期的に更新することで、セキュリティパッチやソフトウェア更新を適用します。
  #   - https://docs.aws.amazon.com/autoscaling/ec2/userguide/asg-max-instance-lifetime.html
  # max_instance_lifetime = 604800

  #-------------------------------------------------------------
  # termination_policies (Optional)
  #-------------------------------------------------------------
  # 設定内容: スケールイン時のインスタンス終了ポリシーを指定します。
  # 設定可能な値 (複数指定可、リスト順で評価):
  #   - "Default": デフォルトの終了ポリシー
  #   - "AllocationStrategy": アロケーション戦略に基づく
  #   - "OldestLaunchTemplate": 最も古い起動テンプレートのインスタンスを優先
  #   - "OldestLaunchConfiguration": 最も古い起動設定のインスタンスを優先
  #   - "ClosestToNextInstanceHour": 次の課金時間に最も近いインスタンスを優先
  #   - "NewestInstance": 最も新しいインスタンスを優先
  #   - "OldestInstance": 最も古いインスタンスを優先
  # 関連機能: Termination Policies
  #   - https://docs.aws.amazon.com/autoscaling/ec2/userguide/ec2-auto-scaling-termination-policies.html
  termination_policies = ["Default"]

  # suspended_processes (Optional)
  # 設定内容: 一時停止するプロセスのリストを指定します。
  # 設定可能な値:
  #   - "Launch": インスタンスの起動
  #   - "Terminate": インスタンスの終了
  #   - "HealthCheck": ヘルスチェック
  #   - "ReplaceUnhealthy": 異常なインスタンスの置換
  #   - "AZRebalance": AZ リバランス
  #   - "AlarmNotification": アラーム通知
  #   - "ScheduledActions": スケジュールされたアクション
  #   - "AddToLoadBalancer": ロードバランサーへの追加
  #   - "InstanceRefresh": インスタンスリフレッシュ
  # 関連機能: Suspending and Resuming Processes
  #   - https://docs.aws.amazon.com/autoscaling/ec2/userguide/as-suspend-resume-processes.html
  # suspended_processes = ["AZRebalance"]

  #-------------------------------------------------------------
  # メトリクス設定
  #-------------------------------------------------------------

  # enabled_metrics (Optional)
  # 設定内容: 収集する CloudWatch メトリクスを指定します。
  # 設定可能な値:
  #   - "GroupDesiredCapacity"
  #   - "GroupInServiceCapacity"
  #   - "GroupPendingCapacity"
  #   - "GroupMinSize"
  #   - "GroupMaxSize"
  #   - "GroupInServiceInstances"
  #   - "GroupPendingInstances"
  #   - "GroupStandbyInstances"
  #   - "GroupStandbyCapacity"
  #   - "GroupTerminatingCapacity"
  #   - "GroupTerminatingInstances"
  #   - "GroupTotalCapacity"
  #   - "GroupTotalInstances"
  #   - "WarmPoolDesiredCapacity"
  #   - "WarmPoolWarmedCapacity"
  #   - "WarmPoolPendingCapacity"
  #   - "WarmPoolTerminatingCapacity"
  #   - "WarmPoolTotalCapacity"
  #   - "GroupAndWarmPoolDesiredCapacity"
  #   - "GroupAndWarmPoolTotalCapacity"
  # enabled_metrics = ["GroupDesiredCapacity", "GroupInServiceInstances"]

  # metrics_granularity (Optional)
  # 設定内容: メトリクスの収集粒度を指定します。
  # 設定可能な値: "1Minute"
  # 注意: enabled_metrics と組み合わせて使用
  # metrics_granularity = "1Minute"

  #-------------------------------------------------------------
  # instance_maintenance_policy (Optional)
  #-------------------------------------------------------------
  # 設定内容: インスタンスメンテナンスポリシーを指定します。
  # 関連機能: Instance Maintenance Policy
  #   インスタンスのメンテナンス中に維持する健全なインスタンスの割合を制御します。

  # instance_maintenance_policy {
  #   # max_healthy_percentage (Required)
  #   # 設定内容: 最大健全インスタンスの割合を指定します。
  #   # 設定可能な値: 100-200 の整数
  #   max_healthy_percentage = 110

  #   # min_healthy_percentage (Required)
  #   # 設定内容: 最小健全インスタンスの割合を指定します。
  #   # 設定可能な値: 0-100 の整数 (max_healthy_percentage との差は 100 以下)
  #   min_healthy_percentage = 90
  # }

  #-------------------------------------------------------------
  # instance_refresh (Optional)
  #-------------------------------------------------------------
  # 設定内容: インスタンスリフレッシュの設定を指定します。
  # 関連機能: Instance Refresh
  #   AMI やインスタンスタイプの更新をローリング方式で適用します。
  #   - https://docs.aws.amazon.com/autoscaling/ec2/userguide/asg-instance-refresh.html

  # instance_refresh {
  #   # strategy (Required)
  #   # 設定内容: リフレッシュ戦略を指定します。
  #   # 設定可能な値: "Rolling"
  #   strategy = "Rolling"

  #   # triggers (Optional)
  #   # 設定内容: インスタンスリフレッシュをトリガーする属性を指定します。
  #   # 設定可能な値: Auto Scaling グループの属性名のリスト (例: ["tag", "launch_template"])
  #   triggers = ["tag"]

  #   # preferences (Optional)
  #   # 設定内容: リフレッシュの詳細設定を指定します。
  #   preferences {
  #     # min_healthy_percentage (Optional)
  #     # 設定内容: リフレッシュ中に維持する最小健全インスタンスの割合を指定します。
  #     # 設定可能な値: 0-100 の整数
  #     # 省略時: 90
  #     min_healthy_percentage = 90

  #     # max_healthy_percentage (Optional)
  #     # 設定内容: リフレッシュ中の最大健全インスタンスの割合を指定します。
  #     # 設定可能な値: 100-200 の整数
  #     max_healthy_percentage = 110

  #     # instance_warmup (Optional)
  #     # 設定内容: 新しいインスタンスのウォームアップ時間を指定します。
  #     # 設定可能な値: 時間を表す文字列 (例: "300")
  #     # 省略時: ヘルスチェック猶予期間を使用
  #     instance_warmup = "300"

  #     # skip_matching (Optional)
  #     # 設定内容: 既に最新の設定を持つインスタンスをスキップするかを指定します。
  #     # 設定可能な値: true/false
  #     # 省略時: false
  #     skip_matching = true

  #     # auto_rollback (Optional)
  #     # 設定内容: 失敗時に自動ロールバックするかを指定します。
  #     # 設定可能な値: true/false
  #     auto_rollback = true

  #     # checkpoint_delay (Optional)
  #     # 設定内容: チェックポイント間の待機時間を指定します。
  #     # 設定可能な値: 時間を表す文字列 (例: "3600" = 1時間)
  #     # checkpoint_delay = "3600"

  #     # checkpoint_percentages (Optional)
  #     # 設定内容: チェックポイントを設定する割合のリストを指定します。
  #     # 設定可能な値: 割合のリスト (例: [25, 50, 100])
  #     # checkpoint_percentages = [25, 50, 100]

  #     # scale_in_protected_instances (Optional)
  #     # 設定内容: スケールイン保護されたインスタンスの扱いを指定します。
  #     # 設定可能な値:
  #     #   - "Refresh": リフレッシュ対象とする
  #     #   - "Ignore": リフレッシュ対象から除外
  #     #   - "Wait": 保護が解除されるまで待機
  #     # scale_in_protected_instances = "Ignore"

  #     # standby_instances (Optional)
  #     # 設定内容: スタンバイ状態のインスタンスの扱いを指定します。
  #     # 設定可能な値:
  #     #   - "Terminate": 終了する
  #     #   - "Ignore": リフレッシュ対象から除外
  #     #   - "Wait": スタンバイが解除されるまで待機
  #     # standby_instances = "Ignore"

  #     # alarm_specification (Optional)
  #     # 設定内容: ロールバックをトリガーする CloudWatch アラームを指定します。
  #     # alarm_specification {
  #     #   # alarms (Optional)
  #     #   # 設定内容: CloudWatch アラーム名のリスト
  #     #   alarms = ["my-alarm-1", "my-alarm-2"]
  #     # }
  #   }
  # }

  #-------------------------------------------------------------
  # initial_lifecycle_hook (Optional)
  #-------------------------------------------------------------
  # 設定内容: Auto Scaling グループ作成時に追加するライフサイクルフックを指定します。
  # 関連機能: Lifecycle Hooks
  #   インスタンスの起動・終了時にカスタムアクションを実行できます。
  #   - https://docs.aws.amazon.com/autoscaling/ec2/userguide/lifecycle-hooks.html
  # 注意: aws_autoscaling_lifecycle_hook リソースとの重複に注意

  # initial_lifecycle_hook {
  #   # name (Required)
  #   # 設定内容: ライフサイクルフックの名前を指定します。
  #   name = "launch-hook"

  #   # lifecycle_transition (Required)
  #   # 設定内容: フックを適用するライフサイクル遷移を指定します。
  #   # 設定可能な値:
  #   #   - "autoscaling:EC2_INSTANCE_LAUNCHING": インスタンス起動時
  #   #   - "autoscaling:EC2_INSTANCE_TERMINATING": インスタンス終了時
  #   lifecycle_transition = "autoscaling:EC2_INSTANCE_LAUNCHING"

  #   # default_result (Optional)
  #   # 設定内容: タイムアウト時のデフォルトアクションを指定します。
  #   # 設定可能な値:
  #   #   - "CONTINUE": ライフサイクルを続行
  #   #   - "ABANDON": インスタンスを終了/起動を中止
  #   # 省略時: "ABANDON"
  #   default_result = "CONTINUE"

  #   # heartbeat_timeout (Optional)
  #   # 設定内容: ハートビートタイムアウト（秒）を指定します。
  #   # 設定可能な値: 30-7200 の整数
  #   # 省略時: 3600 (1時間)
  #   heartbeat_timeout = 3600

  #   # notification_metadata (Optional)
  #   # 設定内容: 通知に含める追加メタデータを指定します。
  #   # notification_metadata = "{\"key\": \"value\"}"

  #   # notification_target_arn (Optional)
  #   # 設定内容: 通知先の SNS トピックまたは SQS キューの ARN を指定します。
  #   # notification_target_arn = "arn:aws:sns:ap-northeast-1:123456789012:my-topic"

  #   # role_arn (Optional)
  #   # 設定内容: 通知を送信するための IAM ロールの ARN を指定します。
  #   # role_arn = "arn:aws:iam::123456789012:role/my-lifecycle-hook-role"
  # }

  #-------------------------------------------------------------
  # warm_pool (Optional)
  #-------------------------------------------------------------
  # 設定内容: ウォームプールの設定を指定します。
  # 関連機能: Warm Pools
  #   事前に初期化されたインスタンスのプールを維持し、スケールアウト時間を短縮します。
  #   - https://docs.aws.amazon.com/autoscaling/ec2/userguide/ec2-auto-scaling-warm-pools.html

  # warm_pool {
  #   # pool_state (Optional)
  #   # 設定内容: ウォームプール内のインスタンスの状態を指定します。
  #   # 設定可能な値:
  #   #   - "Stopped": インスタンスを停止状態で維持
  #   #   - "Running": インスタンスを実行状態で維持
  #   #   - "Hibernated": インスタンスを休止状態で維持
  #   pool_state = "Stopped"

  #   # min_size (Optional)
  #   # 設定内容: ウォームプールの最小インスタンス数を指定します。
  #   # 設定可能な値: 0 以上の整数
  #   # 省略時: 0
  #   min_size = 1

  #   # max_group_prepared_capacity (Optional)
  #   # 設定内容: グループで準備されるインスタンスの最大数を指定します。
  #   # 設定可能な値: -1 (Auto Scaling グループの max_size と同じ) または 0 以上の整数
  #   # 省略時: -1
  #   max_group_prepared_capacity = 10

  #   # instance_reuse_policy (Optional)
  #   # 設定内容: インスタンス再利用ポリシーを指定します。
  #   instance_reuse_policy {
  #     # reuse_on_scale_in (Optional)
  #     # 設定内容: スケールイン時にインスタンスをウォームプールに戻すかを指定します。
  #     # 設定可能な値: true/false
  #     # 省略時: false
  #     reuse_on_scale_in = true
  #   }
  # }

  #-------------------------------------------------------------
  # tag (Optional)
  #-------------------------------------------------------------
  # 設定内容: Auto Scaling グループおよびインスタンスに適用するタグを指定します。

  tag {
    # key (Required)
    # 設定内容: タグキーを指定します。
    key = "Name"

    # value (Required)
    # 設定内容: タグ値を指定します。
    value = "my-asg-instance"

    # propagate_at_launch (Required)
    # 設定内容: 起動時にインスタンスにタグを伝播するかを指定します。
    # 設定可能な値: true/false
    propagate_at_launch = true
  }

  tag {
    key                 = "Environment"
    value               = "production"
    propagate_at_launch = true
  }

  #-------------------------------------------------------------
  # Terraform 固有の設定
  #-------------------------------------------------------------

  # wait_for_capacity_timeout (Optional)
  # 設定内容: 希望容量に達するまでの待機タイムアウトを指定します。
  # 設定可能な値: 時間を表す文字列 (例: "10m", "0" で待機しない)
  # 省略時: "10m"
  # wait_for_capacity_timeout = "10m"

  # min_elb_capacity (Optional)
  # 設定内容: ELB のヘルスチェックをパスするまで待機するインスタンス数を指定します。
  # 設定可能な値: 0 以上の整数
  # 注意: wait_for_elb_capacity よりも min_elb_capacity が優先されます。
  # min_elb_capacity = 1

  # wait_for_elb_capacity (Optional)
  # 設定内容: ELB の InService 状態になるまで待機するインスタンス数を指定します。
  # 設定可能な値: 0 以上の整数
  # 注意: min_elb_capacity が設定されている場合はそちらが優先されます。
  # wait_for_elb_capacity = 1

  # force_delete (Optional)
  # 設定内容: Terraform destroy 時にインスタンスを強制削除するかを指定します。
  # 設定可能な値:
  #   - true: 全インスタンスを強制削除してからグループを削除
  #   - false (デフォルト): 通常の削除フロー
  # force_delete = false

  # force_delete_warm_pool (Optional)
  # 設定内容: destroy 時にウォームプールを強制削除するかを指定します。
  # 設定可能な値: true/false
  # 省略時: false
  # force_delete_warm_pool = false

  # ignore_failed_scaling_activities (Optional)
  # 設定内容: 失敗したスケーリングアクティビティを無視するかを指定します。
  # 設定可能な値: true/false
  # 省略時: false
  # ignore_failed_scaling_activities = false

  # context (Optional)
  # 設定内容: 予約済み (内部使用)
  # context = ""

  #-------------------------------------------------------------
  # サービスリンクロール設定
  #-------------------------------------------------------------

  # service_linked_role_arn (Optional)
  # 設定内容: Auto Scaling サービスリンクロールの ARN を指定します。
  # 設定可能な値: 有効な IAM サービスリンクロール ARN
  # 省略時: デフォルトのサービスリンクロールを使用
  # service_linked_role_arn = "arn:aws:iam::123456789012:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効な AWS リージョンコード (例: ap-northeast-1, us-east-1)
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "ap-northeast-1"

  #-------------------------------------------------------------
  # timeouts (Optional)
  #-------------------------------------------------------------
  # 設定内容: リソース操作のタイムアウトを指定します。

  timeouts {
    # delete (Optional)
    # 設定内容: 削除操作のタイムアウトを指定します。
    # 設定可能な値: 時間を表す文字列 (例: "15m")
    delete = "15m"

    # update (Optional)
    # 設定内容: 更新操作のタイムアウトを指定します。
    # 設定可能な値: 時間を表す文字列 (例: "10m")
    update = "10m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: Auto Scaling グループの Amazon Resource Name (ARN)
#
# - id: Auto Scaling グループの ID (名前と同じ)
#
# - predicted_capacity: 予測されるキャパシティ (予測スケーリングが有効な場合)
#
# - warm_pool_size: 現在のウォームプールのサイズ
#
# - availability_zones: Auto Scaling グループのアベイラビリティーゾーン
#
# - default_cooldown: デフォルトのクールダウン期間
#
# - desired_capacity: 希望するインスタンス数
#
# - health_check_type: ヘルスチェックのタイプ
#
# - launch_configuration: 起動設定名
#
# - load_balancers: アタッチされた Classic Load Balancer のリスト
#
# - target_group_arns: アタッチされたターゲットグループ ARN のリスト
#
# - vpc_zone_identifier: VPC サブネット ID のリスト
#
# - name: Auto Scaling グループの名前
#
# - name_prefix: Auto Scaling グループ名のプレフィックス
#
# - service_linked_role_arn: サービスリンクロールの ARN
#---------------------------------------------------------------
