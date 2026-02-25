#---------------------------------------------------------------
# AWS ECS Capacity Provider
#---------------------------------------------------------------
#
# Amazon ECS Capacity Provider をプロビジョニングするリソースです。
# キャパシティプロバイダーは、ECSクラスターで使用するコンピューティング容量の
# ソースを定義し、Auto Scalingグループまたはマネージドインスタンスを通じて
# タスクを実行するインフラストラクチャを管理します。
#
# 主な機能:
# - Auto Scaling Group (ASG) ベースのキャパシティ管理
# - ECS Managed Instances (Fargate相当のサーバーレスEC2) によるキャパシティ管理
# - マネージドスケーリング、ドレイニング、終了保護の自動化
#
# AWS公式ドキュメント:
#   - キャパシティプロバイダー: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/cluster-capacity-providers.html
#   - Auto Scalingグループキャパシティプロバイダー: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/asg-capacity-providers.html
#   - マネージドインスタンス: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs-managed-instances.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_capacity_provider
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_ecs_capacity_provider" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required, Forces new resource)
  # 設定内容: キャパシティプロバイダーの名前を指定します。
  # 設定可能な値: 英数字、ハイフン、アンダースコア (最大255文字)
  # 注意: 変更すると新しいリソースが作成されます。
  name = "example-capacity-provider"

  #-------------------------------------------------------------
  # クラスター関連付け (廃止予定)
  #-------------------------------------------------------------

  # cluster (Optional, Deprecated)
  # 設定内容: キャパシティプロバイダーを関連付けるECSクラスターを指定します。
  # 注意: この属性は廃止予定です。代わりに aws_ecs_cluster_capacity_providers リソースを使用してください。
  #       https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_cluster_capacity_providers
  cluster = null

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: キャパシティプロバイダーに付与するタグを指定します。
  # 設定可能な値: キーと値のペア（最大50タグ）
  # 用途: コスト配分、リソース管理、アクセス制御など
  tags = {
    Environment = "production"
    ManagedBy   = "terraform"
  }

  # tags_all (Optional, Computed)
  # 設定内容: すべてのタグ（デフォルトタグを含む）を表示します。
  # 省略時: プロバイダーのdefault_tagsと上記tagsがマージされた値が使用されます。
  # 注意: 通常は明示的に設定する必要はありません。
  tags_all = null

  #---------------------------------------------------------------
  # Auto Scaling Group キャパシティプロバイダー設定
  #---------------------------------------------------------------
  # ASGを使用してEC2インスタンスのキャパシティを管理する場合に設定します。
  # managed_instances_provider と排他的です（どちらか一方のみ設定）。

  auto_scaling_group_provider {
    # auto_scaling_group_arn (Required)
    # 設定内容: キャパシティプロバイダーに関連付けるAuto Scaling GroupのARNを指定します。
    # 設定可能な値: 有効なAuto Scaling GroupのARN
    # 注意: ASGには以下の設定が推奨されます
    #       - インスタンス保護: 有効
    #       - ヘルスチェックタイプ: EC2
    auto_scaling_group_arn = aws_autoscaling_group.ecs_asg.arn

    #-----------------------------------------------------------
    # マネージドスケーリング設定
    #-----------------------------------------------------------
    # ECSがASGのスケーリングを自動管理する機能です。

    managed_scaling {
      # status (Optional)
      # 設定内容: マネージドスケーリングの有効/無効を指定します。
      # 設定可能な値:
      #   - "ENABLED": マネージドスケーリングを有効化
      #   - "DISABLED": マネージドスケーリングを無効化
      # 省略時: "ENABLED"
      status = "ENABLED"

      # target_capacity (Optional)
      # 設定内容: クラスターの目標使用率をパーセンテージで指定します。
      # 設定可能な値: 1-100の整数
      # 省略時: 100
      # 推奨: 通常は80-90%に設定し、バッファを確保
      target_capacity = 80

      # minimum_scaling_step_size (Optional)
      # 設定内容: スケールアウト時の最小インスタンス増加数を指定します。
      # 設定可能な値: 1-10000の整数
      # 省略時: 1
      # 注意: 急速なスケーリングが必要な場合は大きな値を設定
      minimum_scaling_step_size = 1

      # maximum_scaling_step_size (Optional)
      # 設定内容: スケールアウト時の最大インスタンス増加数を指定します。
      # 設定可能な値: 1-10000の整数
      # 省略時: 10000
      # 注意: コスト管理のため、上限を設定することを推奨
      maximum_scaling_step_size = 10

      # instance_warmup_period (Optional)
      # 設定内容: 新しいインスタンスが起動してからタスク実行可能になるまでの待機時間を秒単位で指定します。
      # 設定可能な値: 0-10000の整数
      # 省略時: 300秒
      # 注意: AMIの起動時間、コンテナイメージのダウンロード時間を考慮して設定
      instance_warmup_period = 300
    }

    #-----------------------------------------------------------
    # マネージドドレイニング設定
    #-----------------------------------------------------------

    # managed_draining (Optional)
    # 設定内容: インスタンス終了時のコンテナドレイニングを自動管理するかを指定します。
    # 設定可能な値:
    #   - "ENABLED": マネージドドレイニングを有効化（推奨）
    #   - "DISABLED": マネージドドレイニングを無効化
    # 省略時: "ENABLED"
    # 関連機能: コンテナインスタンスドレイニング
    #   スケールイン時に実行中のタスクを安全に終了し、新しいタスクの配置を防ぎます。
    #   https://docs.aws.amazon.com/AmazonECS/latest/developerguide/container-instance-draining.html
    managed_draining = "ENABLED"

    #-----------------------------------------------------------
    # マネージド終了保護設定
    #-----------------------------------------------------------

    # managed_termination_protection (Optional)
    # 設定内容: 実行中のタスクがあるインスタンスの終了保護を有効にするかを指定します。
    # 設定可能な値:
    #   - "ENABLED": 終了保護を有効化（推奨）
    #   - "DISABLED": 終了保護を無効化
    # 省略時: "DISABLED"
    # 関連機能: マネージド終了保護
    #   ASGのスケールイン時に、実行中のタスクがあるインスタンスが終了されることを防ぎます。
    #   https://docs.aws.amazon.com/AmazonECS/latest/developerguide/cluster-auto-scaling.html#managed-termination-protection
    managed_termination_protection = "ENABLED"
  }

  #---------------------------------------------------------------
  # マネージドインスタンス キャパシティプロバイダー設定
  #---------------------------------------------------------------
  # ECSマネージドインスタンス（Fargate相当のサーバーレスEC2）を使用する場合に設定します。
  # auto_scaling_group_provider と排他的です（どちらか一方のみ設定）。

  # managed_instances_provider {
  #   # infrastructure_role_arn (Required)
  #   # 設定内容: ECSがインフラストラクチャを管理するために使用するIAMロールのARNを指定します。
  #   # 設定可能な値: 有効なIAMロールARN
  #   # 必要な権限: ec2:*, elasticloadbalancing:*, ecs:*, autoscaling:*, logs:*
  #   # 信頼ポリシー: ecs.amazonaws.com からの AssumeRole を許可
  #   infrastructure_role_arn = aws_iam_role.ecs_infrastructure.arn
  #
  #   #-----------------------------------------------------------
  #   # タグ伝播設定
  #   #-----------------------------------------------------------
  #
  #   # propagate_tags (Optional)
  #   # 設定内容: タスクまたはサービスからマネージドインスタンスへのタグ伝播を指定します。
  #   # 設定可能な値:
  #   #   - "TASK": タスクレベルのタグを伝播
  #   #   - "SERVICE": サービスレベルのタグを伝播
  #   #   - "NONE": タグを伝播しない
  #   # 注意: 設定値は大文字である必要があります。
  #   propagate_tags = "SERVICE"
  #
  #   #-----------------------------------------------------------
  #   # インフラストラクチャ最適化設定
  #   #-----------------------------------------------------------
  #
  #   infrastructure_optimization {
  #     # scale_in_after (Optional)
  #     # 設定内容: マネージドインスタンスがアイドル状態になってから終了するまでの待機時間を秒単位で指定します。
  #     # 設定可能な値: 60-604800 (1分-7日) の整数
  #     # 注意: インスタンスの起動・終了コストとアイドル時間のコストバランスを考慮して設定
  #     scale_in_after = 3600  # 1時間
  #   }
  #
  #   #-----------------------------------------------------------
  #   # インスタンス起動テンプレート設定
  #   #-----------------------------------------------------------
  #
  #   instance_launch_template {
  #     # ec2_instance_profile_arn (Required)
  #     # 設定内容: マネージドインスタンスに割り当てるIAMインスタンスプロファイルのARNを指定します。
  #     # 設定可能な値: 有効なIAMインスタンスプロファイルARN
  #     # 必要な権限: AmazonEC2ContainerServiceforEC2Role など
  #     ec2_instance_profile_arn = aws_iam_instance_profile.ecs_instance.arn
  #
  #     #---------------------------------------------------------
  #     # キャパシティオプション設定
  #     #---------------------------------------------------------
  #
  #     # capacity_option_type (Optional)
  #     # 設定内容: マネージドインスタンスのキャパシティタイプを指定します。
  #     # 設定可能な値:
  #     #   - "ON_DEMAND": オンデマンドインスタンス（デフォルト）
  #     #   - "SPOT": スポットインスタンス（コスト削減可能）
  #     # 省略時: "ON_DEMAND"
  #     capacity_option_type = "ON_DEMAND"
  #
  #     #---------------------------------------------------------
  #     # モニタリング設定
  #     #---------------------------------------------------------
  #
  #     # monitoring (Optional)
  #     # 設定内容: CloudWatch詳細モニタリングの有効/無効を指定します。
  #     # 設定可能な値:
  #     #   - "ENABLED": 詳細モニタリング有効（1分間隔）
  #     #   - "DISABLED": 基本モニタリング（5分間隔）
  #     # 注意: 詳細モニタリングは追加料金が発生します。
  #     monitoring = "DISABLED"
  #
  #     #---------------------------------------------------------
  #     # インスタンス要件設定
  #     #---------------------------------------------------------
  #     # 属性ベースインスタンス選択により、インスタンスタイプを動的に選択できます。
  #
  #     instance_requirements {
  #       #-------------------------------------------------------
  #       # vCPU設定 (Required)
  #       #-------------------------------------------------------
  #
  #       vcpu_count {
  #         # min (Required)
  #         # 設定内容: 最小vCPU数を指定します。
  #         # 設定可能な値: 1以上の整数
  #         min = 2
  #
  #         # max (Optional)
  #         # 設定内容: 最大vCPU数を指定します。
  #         # 設定可能な値: min以上の整数
  #         max = 8
  #       }
  #
  #       #-------------------------------------------------------
  #       # メモリ設定 (Required)
  #       #-------------------------------------------------------
  #
  #       memory_mib {
  #         # min (Required)
  #         # 設定内容: 最小メモリ容量をMiB単位で指定します。
  #         # 設定可能な値: 1以上の整数
  #         min = 4096
  #
  #         # max (Optional)
  #         # 設定内容: 最大メモリ容量をMiB単位で指定します。
  #         # 設定可能な値: min以上の整数
  #         max = 32768
  #       }
  #
  #       #-------------------------------------------------------
  #       # インスタンスタイプフィルター
  #       #-------------------------------------------------------
  #
  #       # allowed_instance_types (Optional)
  #       # 設定内容: 許可するインスタンスタイプのリストを指定します。
  #       # 設定可能な値: インスタンスタイプ名のセット（例: ["t3.large", "m5.large"]）
  #       # 注意: excluded_instance_types と排他的です。ワイルドカード使用可能（例: "m5.*"）
  #       allowed_instance_types = ["t3.*", "m5.*"]
  #
  #       # excluded_instance_types (Optional)
  #       # 設定内容: 除外するインスタンスタイプのリストを指定します。
  #       # 設定可能な値: インスタンスタイプ名のセット
  #       # 注意: allowed_instance_types と排他的です。ワイルドカード使用可能
  #       excluded_instance_types = null
  #
  #       #-------------------------------------------------------
  #       # プロセッサー設定
  #       #-------------------------------------------------------
  #
  #       # cpu_manufacturers (Optional)
  #       # 設定内容: 許可するCPUメーカーを指定します。
  #       # 設定可能な値: "amazon-web-services", "amd", "intel"
  #       cpu_manufacturers = ["intel", "amd"]
  #
  #       # instance_generations (Optional)
  #       # 設定内容: 許可するインスタンス世代を指定します。
  #       # 設定可能な値: "current" (最新世代), "previous" (前世代)
  #       instance_generations = ["current"]
  #
  #       #-------------------------------------------------------
  #       # パフォーマンス設定
  #       #-------------------------------------------------------
  #
  #       # burstable_performance (Optional)
  #       # 設定内容: バースト可能なパフォーマンスインスタンス（Tファミリー）を含めるかを指定します。
  #       # 設定可能な値:
  #       #   - "included": バースト可能なインスタンスを含める
  #       #   - "excluded": バースト可能なインスタンスを除外
  #       #   - "required": バースト可能なインスタンスのみ
  #       burstable_performance = "excluded"
  #
  #       #-------------------------------------------------------
  #       # ストレージ設定
  #       #-------------------------------------------------------
  #
  #       # local_storage (Optional)
  #       # 設定内容: ローカルストレージの要件を指定します。
  #       # 設定可能な値:
  #       #   - "included": ローカルストレージを含める
  #       #   - "excluded": ローカルストレージを除外
  #       #   - "required": ローカルストレージが必須
  #       local_storage = null
  #
  #       # local_storage_types (Optional)
  #       # 設定内容: 許可するローカルストレージタイプを指定します。
  #       # 設定可能な値: "hdd", "ssd"
  #       local_storage_types = null
  #
  #       #-------------------------------------------------------
  #       # ハードウェア設定
  #       #-------------------------------------------------------
  #
  #       # bare_metal (Optional)
  #       # 設定内容: ベアメタルインスタンスの要件を指定します。
  #       # 設定可能な値:
  #       #   - "included": ベアメタルインスタンスを含める
  #       #   - "excluded": ベアメタルインスタンスを除外
  #       #   - "required": ベアメタルインスタンスのみ
  #       bare_metal = "excluded"
  #
  #       # require_hibernate_support (Optional)
  #       # 設定内容: ハイバネーション機能のサポートを必須とするかを指定します。
  #       # 設定可能な値: true, false
  #       require_hibernate_support = null
  #
  #       #-------------------------------------------------------
  #       # アクセラレータ設定（GPU等）
  #       #-------------------------------------------------------
  #
  #       # accelerator_types (Optional)
  #       # 設定内容: 許可するアクセラレータタイプを指定します。
  #       # 設定可能な値: "gpu", "fpga", "inference"
  #       accelerator_types = null
  #
  #       # accelerator_names (Optional)
  #       # 設定内容: 許可するアクセラレータ名を指定します。
  #       # 設定可能な値: "a100", "v100", "k80", "t4", "m60", "radeon-pro-v520", "vu9p" など
  #       accelerator_names = null
  #
  #       # accelerator_manufacturers (Optional)
  #       # 設定内容: 許可するアクセラレータメーカーを指定します。
  #       # 設定可能な値: "nvidia", "amd", "amazon-web-services", "xilinx"
  #       accelerator_manufacturers = null
  #
  #       #-------------------------------------------------------
  #       # アクセラレータ数の範囲設定
  #       #-------------------------------------------------------
  #
  #       # accelerator_count {
  #       #   # min (Optional)
  #       #   # 設定内容: 最小アクセラレータ数を指定します。
  #       #   # 設定可能な値: 0以上の整数
  #       #   min = null
  #       #
  #       #   # max (Optional)
  #       #   # 設定内容: 最大アクセラレータ数を指定します。
  #       #   # 設定可能な値: min以上の整数
  #       #   max = null
  #       # }
  #
  #       #-------------------------------------------------------
  #       # アクセラレータメモリの範囲設定
  #       #-------------------------------------------------------
  #
  #       # accelerator_total_memory_mib {
  #       #   # min (Optional)
  #       #   # 設定内容: 最小アクセラレータメモリをMiB単位で指定します。
  #       #   # 設定可能な値: 0以上の整数
  #       #   min = null
  #       #
  #       #   # max (Optional)
  #       #   # 設定内容: 最大アクセラレータメモリをMiB単位で指定します。
  #       #   # 設定可能な値: min以上の整数
  #       #   max = null
  #       # }
  #
  #       #-------------------------------------------------------
  #       # ネットワーク設定
  #       #-------------------------------------------------------
  #
  #       # network_interface_count {
  #       #   # min (Optional)
  #       #   # 設定内容: 最小ネットワークインターフェース数を指定します。
  #       #   # 設定可能な値: 0以上の整数
  #       #   min = null
  #       #
  #       #   # max (Optional)
  #       #   # 設定内容: 最大ネットワークインターフェース数を指定します。
  #       #   # 設定可能な値: min以上の整数
  #       #   max = null
  #       # }
  #
  #       # network_bandwidth_gbps {
  #       #   # min (Optional)
  #       #   # 設定内容: 最小ネットワーク帯域幅をGbps単位で指定します。
  #       #   # 設定可能な値: 0以上の数値
  #       #   min = null
  #       #
  #       #   # max (Optional)
  #       #   # 設定内容: 最大ネットワーク帯域幅をGbps単位で指定します。
  #       #   # 設定可能な値: min以上の数値
  #       #   max = null
  #       # }
  #
  #       #-------------------------------------------------------
  #       # ストレージ帯域幅・容量設定
  #       #-------------------------------------------------------
  #
  #       # baseline_ebs_bandwidth_mbps {
  #       #   # min (Optional)
  #       #   # 設定内容: 最小ベースラインEBS帯域幅をMbps単位で指定します。
  #       #   # 設定可能な値: 0以上の整数
  #       #   min = null
  #       #
  #       #   # max (Optional)
  #       #   # 設定内容: 最大ベースラインEBS帯域幅をMbps単位で指定します。
  #       #   # 設定可能な値: min以上の整数
  #       #   max = null
  #       # }
  #
  #       # total_local_storage_gb {
  #       #   # min (Optional)
  #       #   # 設定内容: 最小ローカルストレージ容量をGB単位で指定します。
  #       #   # 設定可能な値: 0以上の数値
  #       #   min = null
  #       #
  #       #   # max (Optional)
  #       #   # 設定内容: 最大ローカルストレージ容量をGB単位で指定します。
  #       #   # 設定可能な値: min以上の数値
  #       #   max = null
  #       # }
  #
  #       #-------------------------------------------------------
  #       # メモリ比率設定
  #       #-------------------------------------------------------
  #
  #       # memory_gib_per_vcpu {
  #       #   # min (Optional)
  #       #   # 設定内容: vCPUあたりの最小メモリをGiB単位で指定します。
  #       #   # 設定可能な値: 0以上の数値
  #       #   min = null
  #       #
  #       #   # max (Optional)
  #       #   # 設定内容: vCPUあたりの最大メモリをGiB単位で指定します。
  #       #   # 設定可能な値: min以上の数値
  #       #   max = null
  #       # }
  #
  #       #-------------------------------------------------------
  #       # スポットインスタンス価格設定
  #       #-------------------------------------------------------
  #
  #       # on_demand_max_price_percentage_over_lowest_price (Optional)
  #       # 設定内容: オンデマンド価格の最大許容率を指定します。
  #       # 設定可能な値: 0以上の整数（最安値のインスタンスタイプからの上乗せ率%）
  #       # 注意: 値が小さいほど選択肢が限定され、利用可能なインスタンスが少なくなる可能性があります。
  #       on_demand_max_price_percentage_over_lowest_price = null
  #
  #       # spot_max_price_percentage_over_lowest_price (Optional)
  #       # 設定内容: スポット価格の最大許容率を指定します。
  #       # 設定可能な値: 0以上の整数（最安値のインスタンスタイプからの上乗せ率%）
  #       spot_max_price_percentage_over_lowest_price = null
  #
  #       # max_spot_price_as_percentage_of_optimal_on_demand_price (Optional)
  #       # 設定内容: オンデマンド価格に対するスポット価格の最大許容率を指定します。
  #       # 設定可能な値: 0-100の整数（オンデマンド価格の何%まで許容するか）
  #       max_spot_price_as_percentage_of_optimal_on_demand_price = null
  #     }
  #
  #     #---------------------------------------------------------
  #     # ネットワーク設定 (Required)
  #     #---------------------------------------------------------
  #
  #     network_configuration {
  #       # subnets (Required)
  #       # 設定内容: マネージドインスタンスを配置するサブネットIDのリストを指定します。
  #       # 設定可能な値: 有効なサブネットIDのセット
  #       # 推奨: 高可用性のため、複数のアベイラビリティゾーンにまたがるサブネットを指定
  #       subnets = ["subnet-12345678", "subnet-87654321"]
  #
  #       # security_groups (Optional)
  #       # 設定内容: マネージドインスタンスに適用するセキュリティグループIDのリストを指定します。
  #       # 設定可能な値: 有効なセキュリティグループIDのセット
  #       # 注意: 最大5つまで指定可能
  #       security_groups = ["sg-12345678"]
  #     }
  #
  #     #---------------------------------------------------------
  #     # ストレージ設定
  #     #---------------------------------------------------------
  #
  #     storage_configuration {
  #       # storage_size_gib (Required)
  #       # 設定内容: マネージドインスタンスのストレージサイズをGiB単位で指定します。
  #       # 設定可能な値: 1以上の整数
  #       # 推奨: コンテナイメージサイズと実行時ストレージ要件を考慮して設定
  #       storage_size_gib = 30
  #     }
  #   }
  # }
}

#---------------------------------------------------------------
# Attributes Reference
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# arn: キャパシティプロバイダーのARN
# id: キャパシティプロバイダーの名前（nameと同じ値）
# tags_all: すべてのタグ（デフォルトタグ含む）
#
# 参照:
#   aws_ecs_capacity_provider.example.arn
#   aws_ecs_capacity_provider.example.id
#
# ECSクラスターで利用する際は aws_ecs_cluster_capacity_providers リソースで
# このキャパシティプロバイダーを参照します。
#
#---------------------------------------------------------------
