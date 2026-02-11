#---------------------------------------------------------------
# AWS ECS Capacity Provider
#---------------------------------------------------------------
#
# Amazon Elastic Container Service (ECS) のキャパシティプロバイダーを
# プロビジョニングするリソースです。キャパシティプロバイダーは、
# ECSクラスターがタスクを実行するためのインフラストラクチャを管理します。
#
# キャパシティプロバイダーには2つのタイプがあります:
# 1. Auto Scaling Group Provider: EC2 Auto Scaling グループを使用
# 2. Managed Instances Provider: ECS Managed Instances を使用
#
# 重要: auto_scaling_group_provider または managed_instances_provider の
#       いずれか1つのみを指定する必要があります。
#
# AWS公式ドキュメント:
#   - ECS Capacity Providers: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/cluster-capacity-providers.html
#   - ECS Managed Instances: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs-managed-instances.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_capacity_provider
#
# Provider Version: 6.28.0
# Generated: 2026-01-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# Example 1: Auto Scaling Group Provider
#---------------------------------------------------------------
resource "aws_ecs_capacity_provider" "asg_example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: キャパシティプロバイダーの名前を指定します。
  # 設定可能な値: 英数字、ハイフン、アンダースコア
  # 注意: 作成後の変更はリソースの再作成を伴います。
  name = "example-asg-capacity-provider"

  # region (Optional, Computed)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョン (例: us-east-1, ap-northeast-1)
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "ap-northeast-1"

  # cluster (Optional)
  # 設定内容: ECSクラスターの名前を指定します。
  # 注意: managed_instances_providerを使用する場合は必須です。
  #       auto_scaling_group_providerを使用する場合は設定してはいけません。
  # cluster = "my-cluster"

  #-------------------------------------------------------------
  # Auto Scaling Group Provider 設定
  #-------------------------------------------------------------

  # auto_scaling_group_provider (Optional)
  # 設定内容: ECS Auto Scalingグループのプロバイダー設定を定義します。
  # 関連機能: EC2 Auto Scaling との統合
  #   ECSタスクの需要に基づいて、Auto Scalingグループ内のEC2インスタンスを
  #   自動的にスケーリングします。
  #   - https://docs.aws.amazon.com/AmazonECS/latest/developerguide/asg-capacity-providers.html
  # 注意: managed_instances_providerとは同時に指定できません。
  #       また、Auto Scalingグループに「AmazonECSManaged」タグを追加する必要があります。
  auto_scaling_group_provider {
    # auto_scaling_group_arn (Required)
    # 設定内容: 関連付けるAuto ScalingグループのARNを指定します。
    # 設定可能な値: 有効なAuto Scaling グループのARN
    # 注意: Auto Scalingグループには「AmazonECSManaged」タグが必要です。
    auto_scaling_group_arn = aws_autoscaling_group.example.arn

    # managed_termination_protection (Optional, Computed)
    # 設定内容: コンテナアウェアなインスタンス終了保護を有効化するかを指定します。
    # 設定可能な値:
    #   - ENABLED: タスクが実行中のインスタンスはスケールイン時に保護される
    #   - DISABLED: 通常のAuto Scalingの終了ポリシーに従う
    # デフォルト: DISABLED
    # 参考: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/managed-termination-protection.html
    managed_termination_protection = "ENABLED"

    # managed_draining (Optional, Computed)
    # 設定内容: インスタンス終了時のグレースフルドレイニングを有効化するかを指定します。
    # 設定可能な値:
    #   - ENABLED: 終了前にタスクを安全に別のインスタンスに移動
    #   - DISABLED: ドレイニングなしで即座に終了
    # デフォルト: キャパシティプロバイダー作成時はENABLED
    # 用途: ワークロードを中断せずにインスタンスをシャットダウンします。
    managed_draining = "ENABLED"

    # managed_scaling (Optional)
    # 設定内容: Auto Scalingのパラメータを定義します。
    # 関連機能: ECS Managed Scaling
    #   CloudWatchメトリクスに基づいて、Auto Scalingグループを自動的にスケールします。
    managed_scaling {
      # status (Optional, Computed)
      # 設定内容: Auto ScalingがECSによって管理されるかを指定します。
      # 設定可能な値:
      #   - ENABLED: ECSがAuto Scalingを管理
      #   - DISABLED: 手動でAuto Scalingを管理
      # デフォルト: ENABLED
      status = "ENABLED"

      # target_capacity (Optional, Computed)
      # 設定内容: キャパシティプロバイダーの目標使用率を指定します。
      # 設定可能な値: 1-100の整数（パーセンテージ）
      # 用途: ECSはこの値を維持するようにインスタンス数を調整します。
      #       例: 100に設定すると、クラスターの使用率を100%に近づけます。
      target_capacity = 10

      # minimum_scaling_step_size (Optional, Computed)
      # 設定内容: 最小スケーリングステップサイズを指定します。
      # 設定可能な値: 1-10,000の整数
      # デフォルト: 1
      # 用途: スケールアウト/インの際の最小インスタンス増減数を制御します。
      minimum_scaling_step_size = 1

      # maximum_scaling_step_size (Optional, Computed)
      # 設定内容: 最大スケーリングステップサイズを指定します。
      # 設定可能な値: 1-10,000の整数
      # デフォルト: 10,000
      # 用途: スケールアウト/インの際の最大インスタンス増減数を制御します。
      maximum_scaling_step_size = 1000

      # instance_warmup_period (Optional, Computed)
      # 設定内容: 新しく起動したEC2インスタンスがCloudWatchメトリクスに貢献できるまでの期間（秒）を指定します。
      # 設定可能な値: 秒数（整数）
      # デフォルト: 300秒
      # 用途: インスタンスの起動時間を考慮し、スケーリング判断の精度を向上させます。
      #       長い遅延は新しいタスクを既存のインスタンスに配置する可能性を高め、
      #       短い遅延はコストを削減しますが、頻繁なスケーリングにつながる可能性があります。
      # 参考: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/managed-termination-protection.html
      instance_warmup_period = 300
    }
  }

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "example-asg-capacity-provider"
    Environment = "production"
    ManagedBy   = "Terraform"
  }
}

#---------------------------------------------------------------
# Example 2: Managed Instances Provider
#---------------------------------------------------------------
resource "aws_ecs_capacity_provider" "managed_example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  name = "example-managed-capacity-provider"

  # cluster (Required for managed_instances_provider)
  # 設定内容: このキャパシティプロバイダーが属するECSクラスターの名前を指定します。
  # 注意: managed_instances_providerを使用する場合は必須です。
  cluster = "my-cluster"

  #-------------------------------------------------------------
  # Managed Instances Provider 設定
  #-------------------------------------------------------------

  # managed_instances_provider (Optional)
  # 設定内容: ECS Managed Instancesのプロバイダー設定を定義します。
  # 関連機能: ECS Managed Instances
  #   ECSが自動的にEC2インスタンスを起動、管理、終了します。
  #   Auto Scalingグループを手動で管理する必要はありません。
  #   - https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs-managed-instances.html
  # 注意: auto_scaling_group_providerとは同時に指定できません。
  managed_instances_provider {
    # infrastructure_role_arn (Required)
    # 設定内容: ECSがユーザーの代わりにインスタンスを管理するために使用する
    #           インフラストラクチャロールのARNを指定します。
    # 設定可能な値: 有効なIAM RoleのARN
    # 必要な権限: EC2インスタンスの起動、終了、管理、およびECS Managed Instances
    #            機能に必要な他のAWSサービスへのアクセス権限
    # 参考: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/infrastructure_IAM_role.html
    infrastructure_role_arn = aws_iam_role.ecs_infrastructure.arn

    # propagate_tags (Optional)
    # 設定内容: キャパシティプロバイダーからECS Managed Instancesへタグを伝播するかを指定します。
    # 設定可能な値:
    #   - CAPACITY_PROVIDER: キャパシティプロバイダーのタグをインスタンスに適用
    #   - NONE: タグを伝播しない
    # 用途: タグ付けポリシーの一貫性を保ちます。
    propagate_tags = "CAPACITY_PROVIDER"

    #-------------------------------------------------------------
    # Instance Launch Template 設定
    #-------------------------------------------------------------

    # instance_launch_template (Required)
    # 設定内容: ECSがEC2インスタンスを起動する際の設定を指定します。
    # 関連機能: EC2 Launch Templates
    #   インスタンスプロファイル、ネットワーク設定、ストレージ設定、
    #   属性ベースのインスタンスタイプ選択の要件を含みます。
    #   - https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-launch-templates.html
    instance_launch_template {
      # ec2_instance_profile_arn (Required)
      # 設定内容: ECS Managed InstancesにECSが適用するインスタンスプロファイルのARNを指定します。
      # 設定可能な値: 有効なIAM Instance ProfileのARN
      # 必要な権限: タスクがAWSサービスやリソースにアクセスするために必要な権限
      # 参考: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/instance_IAM_role.html
      ec2_instance_profile_arn = aws_iam_instance_profile.ecs_instance.arn

      # capacity_option_type (Optional, Computed)
      # 設定内容: キャパシティプロバイダーで使用するEC2インスタンスの購入オプションを指定します。
      # 設定可能な値:
      #   - ON_DEMAND: オンデマンドインスタンス
      #   - SPOT: スポットインスタンス
      # デフォルト: ON_DEMAND
      # 注意: この値を変更すると、キャパシティプロバイダーの再作成が必要になります。
      # 参考: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/instance-purchasing-options.html
      capacity_option_type = "ON_DEMAND"

      # monitoring (Optional)
      # 設定内容: CloudWatchモニタリングのレベルを指定します。
      # 設定可能な値:
      #   - BASIC: 基本モニタリング（5分間隔）
      #   - DETAILED: 詳細モニタリング（1分間隔）
      # デフォルト: BASIC
      # 用途: より迅速に問題を特定し、対処するために詳細モニタリングを有効化できます。
      # 参考: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/cloudwatch-metrics.html
      monitoring = "BASIC"

      #-------------------------------------------------------------
      # Network Configuration
      #-------------------------------------------------------------

      # network_configuration (Required)
      # 設定内容: ECS Managed Instancesのネットワーク設定を指定します。
      # 関連機能: VPCネットワーキング
      #   インスタンスがネットワーク接続に使用するサブネットとセキュリティグループを指定します。
      network_configuration {
        # subnets (Required)
        # 設定内容: ECSがECS Managed Instancesを起動できるサブネットIDのリストを指定します。
        # 設定可能な値: サブネットIDのセット
        # 注意: すべてのサブネットは同じVPC内に存在する必要があります。
        # 用途: 高可用性のため、複数のアベイラビリティーゾーンにまたがるサブネットを指定します。
        subnets = [aws_subnet.example.id]

        # security_groups (Optional)
        # 設定内容: ECS Managed Instancesに適用するセキュリティグループIDのリストを指定します。
        # 設定可能な値: セキュリティグループIDのセット
        # 用途: インスタンスへの/からのネットワークトラフィックを制御します。
        security_groups = [aws_security_group.example.id]
      }

      #-------------------------------------------------------------
      # Storage Configuration
      #-------------------------------------------------------------

      # storage_configuration (Optional)
      # 設定内容: ECS Managed Instancesのストレージ設定を定義します。
      # 関連機能: EBSボリューム管理
      #   インスタンスのルートボリュームのサイズとタイプを定義します。
      storage_configuration {
        # storage_size_gib (Required)
        # 設定内容: タスクボリュームのサイズをGiBで指定します。
        # 設定可能な値: 1以上の整数
        # 注意: 最小値は1GiBです。
        # 用途: コンテナイメージやタスクデータを保存するための十分な容量を確保します。
        storage_size_gib = 30
      }

      #-------------------------------------------------------------
      # Instance Requirements (属性ベースのインスタンスタイプ選択)
      #-------------------------------------------------------------

      # instance_requirements (Optional)
      # 設定内容: インスタンス要件を指定します。
      # 関連機能: 属性ベースのインスタンスタイプ選択
      #   vCPU数、メモリ、ネットワークパフォーマンス、アクセラレーター仕様など
      #   のインスタンス要件を指定できます。ECSは指定された基準に一致する
      #   インスタンスを自動的に選択します。
      #   - https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-fleet-attribute-based-instance-type-selection.html
      instance_requirements {
        # memory_mib (Required)
        # 設定内容: インスタンスタイプの最小および最大メモリ量（MiB）を指定します。
        # 設定可能な値: メビバイト単位の整数
        # 用途: ECSは、この範囲内のメモリを持つインスタンスタイプを選択します。
        memory_mib {
          # min (Required)
          # 設定内容: 最小メモリ量（MiB）を指定します。
          min = 1024

          # max (Optional)
          # 設定内容: 最大メモリ量（MiB）を指定します。
          max = 8192
        }

        # vcpu_count (Required)
        # 設定内容: インスタンスタイプの最小および最大vCPU数を指定します。
        # 設定可能な値: 整数
        # 用途: ECSは、この範囲内のvCPUを持つインスタンスタイプを選択します。
        vcpu_count {
          # min (Required)
          # 設定内容: 最小vCPU数を指定します。
          min = 1

          # max (Optional)
          # 設定内容: 最大vCPU数を指定します。
          max = 4
        }

        # instance_generations (Optional)
        # 設定内容: 含めるインスタンス世代を指定します。
        # 設定可能な値:
        #   - current: 最新世代のインスタンス
        #   - previous: 前世代のインスタンス
        # 用途: 最新世代のインスタンスを使用する場合は「current」を、
        #       コスト最適化のために前世代も含める場合は「previous」も追加します。
        instance_generations = ["current"]

        # cpu_manufacturers (Optional)
        # 設定内容: 含めるCPUメーカーを指定します。
        # 設定可能な値:
        #   - intel: Intel製CPU
        #   - amd: AMD製CPU
        #   - amazon-web-services: AWS Graviton プロセッサ
        # 用途: ワークロードに使用するCPUタイプを制御します。
        cpu_manufacturers = ["intel", "amd"]

        # allowed_instance_types (Optional)
        # 設定内容: 選択に含めるインスタンスタイプを指定します。
        # 設定可能な値: インスタンスタイプのセット（最大400個）
        # 用途: 特定のインスタンスタイプのみを使用したい場合に指定します。
        #       ワイルドカードを使用できます（例: m5.*）。
        # allowed_instance_types = ["t3.micro", "t3.small", "t3.medium"]

        # excluded_instance_types (Optional)
        # 設定内容: 選択から除外するインスタンスタイプを指定します。
        # 設定可能な値: インスタンスタイプのセット（最大400個）
        # 用途: ワークロードに適さない特定のインスタンスタイプを除外します。
        # excluded_instance_types = ["t2.nano", "t2.micro"]

        # bare_metal (Optional)
        # 設定内容: ベアメタルインスタンスタイプを含めるかを指定します。
        # 設定可能な値:
        #   - included: ベアメタルインスタンスを許可
        #   - excluded: ベアメタルインスタンスを除外
        #   - required: ベアメタルインスタンスのみを使用
        # bare_metal = "excluded"

        # burstable_performance (Optional)
        # 設定内容: バースト可能なパフォーマンスインスタンスタイプ（T2、T3、T3a、T4g）を含めるかを指定します。
        # 設定可能な値:
        #   - included: バースト可能インスタンスを許可
        #   - excluded: バースト可能インスタンスを除外
        #   - required: バースト可能インスタンスのみを使用
        # burstable_performance = "included"

        # local_storage (Optional)
        # 設定内容: ローカルストレージを持つインスタンスタイプを含めるかを指定します。
        # 設定可能な値:
        #   - included: ローカルストレージを許可
        #   - excluded: ローカルストレージを除外
        #   - required: ローカルストレージを持つインスタンスのみを使用
        # local_storage = "excluded"

        # local_storage_types (Optional)
        # 設定内容: 含めるローカルストレージタイプを指定します。
        # 設定可能な値:
        #   - hdd: ハードディスクドライブ
        #   - ssd: ソリッドステートドライブ
        # local_storage_types = ["ssd"]

        # require_hibernate_support (Optional)
        # 設定内容: インスタンスタイプがハイバネーションをサポートする必要があるかを指定します。
        # 設定可能な値: true/false
        # 用途: trueに設定すると、ハイバネーションをサポートするインスタンスタイプのみが選択されます。
        # require_hibernate_support = false

        # on_demand_max_price_percentage_over_lowest_price (Optional)
        # 設定内容: オンデマンドインスタンスの価格保護閾値を、
        #           特定されたオンデマンド価格よりも高いパーセンテージとして指定します。
        # 設定可能な値: 整数（パーセンテージ）
        # 用途: 指定された閾値を超える価格のインスタンスタイプは除外されます。
        # on_demand_max_price_percentage_over_lowest_price = 20

        # spot_max_price_percentage_over_lowest_price (Optional)
        # 設定内容: スポットインスタンスの最大価格を、最低価格のオンデマンドインスタンスよりも
        #           高いパーセンテージとして指定します。
        # 設定可能な値: 整数（パーセンテージ）
        # 用途: スポットインスタンスのコストを制御しながら、キャパシティへのアクセスを維持します。
        # spot_max_price_percentage_over_lowest_price = 100

        # max_spot_price_as_percentage_of_optimal_on_demand_price (Optional)
        # 設定内容: スポットインスタンスの最大価格を、最適なオンデマンド価格の
        #           パーセンテージとして指定します。
        # 設定可能な値: 整数（パーセンテージ）
        # 用途: スポットインスタンス選択に対してより精密なコスト制御を提供します。
        # max_spot_price_as_percentage_of_optimal_on_demand_price = 100

        # memory_gib_per_vcpu (Optional)
        # 設定内容: vCPUあたりの最小および最大メモリ量（GiB）を指定します。
        # 用途: インスタンスタイプが適切なメモリ対CPU比率を持つことを保証します。
        # memory_gib_per_vcpu {
        #   min = 1.0
        #   max = 8.0
        # }

        # network_bandwidth_gbps (Optional)
        # 設定内容: 最小および最大ネットワーク帯域幅（Gbps）を指定します。
        # 用途: 高スループットを必要とするネットワーク集約型ワークロードに重要です。
        # network_bandwidth_gbps {
        #   min = 1.0
        #   max = 100.0
        # }

        # network_interface_count (Optional)
        # 設定内容: インスタンスタイプの最小および最大ネットワークインターフェース数を指定します。
        # 用途: 複数のネットワークインターフェースが必要なワークロードに有用です。
        # network_interface_count {
        #   min = 1
        #   max = 8
        # }

        # baseline_ebs_bandwidth_mbps (Optional)
        # 設定内容: 最小および最大ベースラインAmazon EBS帯域幅（Mbps）を指定します。
        # 用途: ストレージI/O要件が高いワークロードに重要です。
        # baseline_ebs_bandwidth_mbps {
        #   min = 1000
        #   max = 10000
        # }

        # total_local_storage_gb (Optional)
        # 設定内容: ローカルストレージを持つインスタンスタイプの
        #           最小および最大合計ローカルストレージ（GB）を指定します。
        # total_local_storage_gb {
        #   min = 100
        #   max = 1000
        # }

        #-------------------------------------------------------------
        # Accelerator (アクセラレーター) 設定
        #-------------------------------------------------------------
        # GPU、FPGA、推論アクセラレーターを必要とするワークロード向けの設定です。

        # accelerator_count (Optional)
        # 設定内容: インスタンスタイプの最小および最大アクセラレーター数を指定します。
        # 用途: 特定の数のGPUや他のアクセラレーターが必要な場合に使用します。
        # accelerator_count {
        #   min = 1
        #   max = 4
        # }

        # accelerator_manufacturers (Optional)
        # 設定内容: 含めるアクセラレーターメーカーを指定します。
        # 設定可能な値:
        #   - nvidia: NVIDIA製GPU
        #   - amd: AMD製GPU
        #   - amazon-web-services: AWS製アクセラレーター
        #   - xilinx: Xilinx製FPGA
        #   - habana: Habana Labs製アクセラレーター
        # accelerator_manufacturers = ["nvidia"]

        # accelerator_names (Optional)
        # 設定内容: 含める特定のアクセラレーター名を指定します。
        # 設定可能な値:
        #   - a100, v100, k80: NVIDIA GPU
        #   - inferentia: AWS Inferentia
        #   - t4, a10g, h100, t4g: その他のGPU/アクセラレーター
        # accelerator_names = ["a100", "v100"]

        # accelerator_types (Optional)
        # 設定内容: 含めるアクセラレータータイプを指定します。
        # 設定可能な値:
        #   - gpu: グラフィック処理ユニット
        #   - fpga: フィールドプログラマブルゲートアレイ
        #   - inference: 機械学習推論アクセラレーター
        # accelerator_types = ["gpu"]

        # accelerator_total_memory_mib (Optional)
        # 設定内容: 最小および最大合計アクセラレーターメモリ（MiB）を指定します。
        # 用途: 特定量のビデオメモリを必要とするGPUワークロードに重要です。
        # accelerator_total_memory_mib {
        #   min = 8192
        #   max = 40960
        # }
      }
    }

    #-------------------------------------------------------------
    # Infrastructure Optimization 設定
    #-------------------------------------------------------------

    # infrastructure_optimization (Optional)
    # 設定内容: ECS Managed Instancesがキャパシティプロバイダー内のインフラストラクチャを
    #           最適化する方法を定義します。
    # 関連機能: アイドルインスタンス最適化
    #   キャパシティプロバイダー内のインフラストラクチャ最適化のオン/オフを切り替え、
    #   アイドルEC2インスタンスの最適化遅延を制御します。
    infrastructure_optimization {
      # scale_in_after (Optional)
      # 設定内容: ECS Managed Instancesがアイドルまたは使用率の低いEC2インスタンスを
      #           最適化するまでの待機秒数を定義します。
      # 設定可能な値:
      #   - 未設定 (null): デフォルトの最適化動作を使用
      #   - -1: 自動インフラストラクチャ最適化を無効化
      #   - 0-3600: インスタンスを最適化する前に待機する秒数
      # 用途: 長い遅延はアイドルインスタンスに新しいタスクを配置する可能性を高め、
      #       起動時間を削減します。短い遅延はアイドルインスタンスをより迅速に
      #       最適化することで、インフラストラクチャコストを削減します。
      scale_in_after = 300
    }
  }

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  tags = {
    Name        = "example-managed-capacity-provider"
    Environment = "production"
    ManagedBy   = "Terraform"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: キャパシティプロバイダーを識別するARN
#
# - id: キャパシティプロバイダーのID（nameと同じ値）
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------

#---------------------------------------------------------------
# 重要な注意事項
#---------------------------------------------------------------
# 1. Auto Scaling Group との統合
#    Auto Scaling Group Providerを使用する場合、Auto Scalingグループに
#    「AmazonECSManaged」タグを追加する必要があります:
#
#    resource "aws_autoscaling_group" "example" {
#      # ... other configuration ...
#      tag {
#        key                 = "AmazonECSManaged"
#        value               = true
#        propagate_at_launch = true
#      }
#    }
#
# 2. 相互排他的な設定
#    - auto_scaling_group_provider と managed_instances_provider は同時に指定できません。
#    - managed_instances_providerを使用する場合、cluster パラメータは必須です。
#    - auto_scaling_group_providerを使用する場合、cluster パラメータは設定してはいけません。
#
# 3. IAMロールの要件
#    - Managed Instances Provider: infrastructure_role_arn が必須
#    - インスタンスプロファイル: ec2_instance_profile_arn が必須
#
# 4. Terraform後の手動作業
#    既存のAuto Scalingグループ内のEC2インスタンスには、手動で
#    「AmazonECSManaged」タグを追加する必要があります。タグがないと、
#    予期しないスケーリング動作やメトリクスの問題が発生する可能性があります。
#---------------------------------------------------------------
