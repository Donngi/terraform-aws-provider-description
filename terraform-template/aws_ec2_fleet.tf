#---------------------------------------------------------------
# AWS EC2 Fleet
#---------------------------------------------------------------
#
# EC2 Fleetを管理するリソースです。
# EC2 Fleetは、複数のインスタンスタイプとアベイラビリティゾーンにまたがる
# オンデマンドインスタンスとスポットインスタンスのグループを作成・管理できます。
#
# 属性ベースのインスタンスタイプ選択を使用することで、
# 必要な属性（vCPU数、メモリ、ローカルストレージ等）を指定し、
# フリートが要件を満たすインスタンスタイプを自動的に選択できます。
#
# AWS公式ドキュメント:
#   - EC2 Fleet設定オプション: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-fleet-configuration-strategies.html
#   - 属性ベースインスタンスタイプ選択: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-fleet-attribute-based-instance-type-selection.html
#   - アロケーション戦略: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-fleet-allocation-strategy.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_fleet
#
# Provider Version: 6.28.0
# Generated: 2026-01-23
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_ec2_fleet" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # type (Optional)
  # 設定内容: リクエストのタイプを指定します。
  # 設定可能な値:
  #   - "maintain" (デフォルト): ターゲット容量を維持（中断されたインスタンスを自動補充）
  #   - "request": ターゲット容量をリクエストのみ（補充しない）
  #   - "instant": 即時起動（同期的に1回のみリクエスト）
  # 注意: typeによって使用可能なオプションが異なります
  type = "maintain"

  # context (Optional)
  # 設定内容: 予約済みフィールド
  # 設定可能な値: 任意の文字列
  context = null

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
  # 容量終了ポリシー設定
  #-------------------------------------------------------------

  # excess_capacity_termination_policy (Optional)
  # 設定内容: ターゲット容量を下回った場合に既存インスタンスを終了するかを指定します。
  # 設定可能な値:
  #   - "termination" (デフォルト): 超過容量のインスタンスを終了
  #   - "no-termination": 超過容量のインスタンスを維持
  # 注意: typeが"maintain"のフリートでのみサポート
  excess_capacity_termination_policy = "termination"

  #-------------------------------------------------------------
  # インスタンス管理設定
  #-------------------------------------------------------------

  # replace_unhealthy_instances (Optional)
  # 設定内容: 異常なインスタンスを置き換えるかを指定します。
  # 設定可能な値:
  #   - true: 異常なインスタンスを自動的に置き換え
  #   - false (デフォルト): 異常なインスタンスを置き換えない
  # 注意: typeが"maintain"のフリートでのみサポート
  replace_unhealthy_instances = false

  # terminate_instances (Optional)
  # 設定内容: フリート削除成功時にインスタンスを終了するかを指定します。
  # 設定可能な値:
  #   - true: フリート削除時にインスタンスを終了
  #   - false (デフォルト): フリート削除時にインスタンスを維持
  terminate_instances = false

  # terminate_instances_with_expiration (Optional)
  # 設定内容: フリート有効期限切れ時にインスタンスを終了するかを指定します。
  # 設定可能な値:
  #   - true: 有効期限切れ時にインスタンスを終了
  #   - false (デフォルト): 有効期限切れ時にインスタンスを維持
  terminate_instances_with_expiration = false

  #-------------------------------------------------------------
  # 有効期間設定
  #-------------------------------------------------------------

  # valid_from (Optional)
  # 設定内容: リクエストの開始日時を指定します。
  # 設定可能な値: UTC形式の日時文字列（YYYY-MM-DDTHH:MM:SSZ）
  # 省略時: 即時実行開始
  valid_from = null

  # valid_until (Optional)
  # 設定内容: リクエストの終了日時を指定します。
  # 設定可能な値: UTC形式の日時文字列（YYYY-MM-DDTHH:MM:SSZ）
  # 省略時: 無期限（キャンセルするまで有効）
  valid_until = null

  #-------------------------------------------------------------
  # 起動テンプレート設定 (Required)
  #-------------------------------------------------------------

  # launch_template_config (Required)
  # 設定内容: EC2起動テンプレートの設定を定義します。
  # 最小: 1個、最大: 50個まで指定可能
  launch_template_config {

    # launch_template_specification (Optional)
    # 設定内容: 使用する起動テンプレートを指定します。
    launch_template_specification {
      # launch_template_id (Optional)
      # 設定内容: 起動テンプレートのIDを指定します。
      # 設定可能な値: 有効な起動テンプレートID
      # 注意: launch_template_nameと排他（どちらか一方を指定）
      launch_template_id = "lt-xxxxxxxxxxxxxxxxx"

      # launch_template_name (Optional)
      # 設定内容: 起動テンプレートの名前を指定します。
      # 設定可能な値: 有効な起動テンプレート名
      # 注意: launch_template_idと排他（どちらか一方を指定）
      # launch_template_name = "my-launch-template"

      # version (Required)
      # 設定内容: 起動テンプレートのバージョンを指定します。
      # 設定可能な値:
      #   - バージョン番号（例: "1", "2"）
      #   - "$Latest": 最新バージョン
      #   - "$Default": デフォルトバージョン
      version = "$Latest"
    }

    # override (Optional)
    # 設定内容: 起動テンプレートの設定を上書きするパラメータを指定します。
    # 最大: 300個まで指定可能
    override {
      # availability_zone (Optional)
      # 設定内容: インスタンスを起動するアベイラビリティゾーンを指定します。
      # 設定可能な値: 有効なアベイラビリティゾーン（例: ap-northeast-1a）
      availability_zone = "ap-northeast-1a"

      # instance_type (Optional)
      # 設定内容: インスタンスタイプを指定します。
      # 設定可能な値: 有効なインスタンスタイプ（例: t3.micro, m5.large）
      # 注意: instance_requirementsと排他
      instance_type = "t3.micro"

      # max_price (Optional)
      # 設定内容: スポットインスタンスの時間あたり最大支払価格を指定します。
      # 設定可能な値: 価格を表す文字列（例: "0.05"）
      # 省略時: オンデマンド価格が上限
      max_price = null

      # priority (Optional)
      # 設定内容: 起動テンプレートオーバーライドの優先度を指定します。
      # 設定可能な値: 0以上の整数（数値が低いほど優先度が高い）
      # 関連機能: on_demand_optionsのallocation_strategyが"prioritized"の場合に使用
      priority = null

      # subnet_id (Optional)
      # 設定内容: インスタンスを起動するサブネットIDを指定します。
      # 設定可能な値: 有効なサブネットID
      subnet_id = null

      # weighted_capacity (Optional)
      # 設定内容: 指定したインスタンスタイプが提供するユニット数を指定します。
      # 設定可能な値: 正の数値
      # 用途: インスタンスウェイティングによる容量計算に使用
      weighted_capacity = null

      # instance_requirements (Optional)
      # 設定内容: 起動テンプレートのインスタンスタイプを、要件を満たすインスタンスタイプで上書きします。
      # 注意: instance_typeと排他
      # instance_requirements {
      #   #-------------------------------------------------------------
      #   # CPU/メモリ要件 (Required)
      #   #-------------------------------------------------------------
      #
      #   # memory_mib (Required)
      #   # 設定内容: メモリの最小・最大量（MiB）を指定します。
      #   memory_mib {
      #     # min (Required)
      #     # 設定内容: 最小メモリ量（MiB）を指定します。
      #     # 設定可能な値: 0以上の整数
      #     min = 1024
      #
      #     # max (Optional)
      #     # 設定内容: 最大メモリ量（MiB）を指定します。
      #     # 省略時: 上限なし
      #     max = null
      #   }
      #
      #   # vcpu_count (Required)
      #   # 設定内容: vCPUの最小・最大数を指定します。
      #   vcpu_count {
      #     # min (Required)
      #     # 設定内容: 最小vCPU数を指定します。
      #     # 設定可能な値: 0以上の整数
      #     min = 1
      #
      #     # max (Optional)
      #     # 設定内容: 最大vCPU数を指定します。
      #     # 省略時: 上限なし
      #     max = null
      #   }
      #
      #   #-------------------------------------------------------------
      #   # vCPUあたりメモリ設定 (Optional)
      #   #-------------------------------------------------------------
      #
      #   # memory_gib_per_vcpu (Optional)
      #   # 設定内容: vCPUあたりのメモリ量（GiB）の最小・最大を指定します。
      #   # memory_gib_per_vcpu {
      #   #   min = null  # 最小量（GiB/vCPU）
      #   #   max = null  # 最大量（GiB/vCPU）
      #   # }
      #
      #   #-------------------------------------------------------------
      #   # インスタンスタイプフィルタ設定 (Optional)
      #   #-------------------------------------------------------------
      #
      #   # allowed_instance_types (Optional)
      #   # 設定内容: 許可するインスタンスタイプを指定します。
      #   # 設定可能な値: インスタンスタイプ名の配列（ワイルドカード使用可）
      #   # 例: ["c5*", "m5a.*", "r*", "*3*"]
      #   # 注意: excluded_instance_typesと排他
      #   # 最大: 400エントリ（各エントリ最大30文字）
      #   # allowed_instance_types = ["t3.*", "t2.*"]
      #
      #   # excluded_instance_types (Optional)
      #   # 設定内容: 除外するインスタンスタイプを指定します。
      #   # 設定可能な値: インスタンスタイプ名の配列（ワイルドカード使用可）
      #   # 注意: allowed_instance_typesと排他
      #   # 最大: 400エントリ（各エントリ最大30文字）
      #   # excluded_instance_types = ["t2.micro"]
      #
      #   # instance_generations (Optional)
      #   # 設定内容: 含めるインスタンス世代を指定します。
      #   # 設定可能な値:
      #   #   - "current": 現行世代（推奨）
      #   #   - "previous": 旧世代
      #   # デフォルト: current と previous の両方
      #   # instance_generations = ["current"]
      #
      #   #-------------------------------------------------------------
      #   # アーキテクチャ/パフォーマンス設定 (Optional)
      #   #-------------------------------------------------------------
      #
      #   # cpu_manufacturers (Optional)
      #   # 設定内容: CPUメーカーを指定します。
      #   # 設定可能な値:
      #   #   - "intel"
      #   #   - "amd"
      #   #   - "amazon-web-services" (AWS Graviton)
      #   # デフォルト: 全メーカー
      #   # cpu_manufacturers = ["intel", "amd"]
      #
      #   # bare_metal (Optional)
      #   # 設定内容: ベアメタルインスタンスを含めるかを指定します。
      #   # 設定可能な値:
      #   #   - "included": ベアメタルを含める
      #   #   - "excluded" (デフォルト): ベアメタルを除外
      #   #   - "required": ベアメタルのみ
      #   # bare_metal = "excluded"
      #
      #   # burstable_performance (Optional)
      #   # 設定内容: バースト可能パフォーマンスインスタンス（Tインスタンス）を含めるかを指定します。
      #   # 設定可能な値:
      #   #   - "included": バースト可能を含める
      #   #   - "excluded" (デフォルト): バースト可能を除外
      #   #   - "required": バースト可能のみ
      #   # burstable_performance = "excluded"
      #
      #   # require_hibernate_support (Optional)
      #   # 設定内容: ハイバネーション対応インスタンスを必須とするかを指定します。
      #   # 設定可能な値:
      #   #   - true: ハイバネーション対応必須
      #   #   - false (デフォルト): ハイバネーション対応不要
      #   # require_hibernate_support = false
      #
      #   #-------------------------------------------------------------
      #   # ストレージ設定 (Optional)
      #   #-------------------------------------------------------------
      #
      #   # local_storage (Optional)
      #   # 設定内容: ローカルストレージを含めるかを指定します。
      #   # 設定可能な値:
      #   #   - "included" (デフォルト): ローカルストレージを含める
      #   #   - "excluded": ローカルストレージを除外
      #   #   - "required": ローカルストレージ必須
      #   # local_storage = "included"
      #
      #   # local_storage_types (Optional)
      #   # 設定内容: ローカルストレージのタイプを指定します。
      #   # 設定可能な値:
      #   #   - "hdd": ハードディスクドライブ
      #   #   - "ssd": ソリッドステートドライブ
      #   # デフォルト: 全タイプ
      #   # local_storage_types = ["ssd"]
      #
      #   # total_local_storage_gb (Optional)
      #   # 設定内容: ローカルストレージ合計の最小・最大（GB）を指定します。
      #   # total_local_storage_gb {
      #   #   min = null  # 最小GB
      #   #   max = null  # 最大GB
      #   # }
      #
      #   #-------------------------------------------------------------
      #   # EBS帯域幅設定 (Optional)
      #   #-------------------------------------------------------------
      #
      #   # baseline_ebs_bandwidth_mbps (Optional)
      #   # 設定内容: ベースラインEBS帯域幅の最小・最大（Mbps）を指定します。
      #   # baseline_ebs_bandwidth_mbps {
      #   #   min = null  # 最小Mbps
      #   #   max = null  # 最大Mbps
      #   # }
      #
      #   #-------------------------------------------------------------
      #   # ネットワーク設定 (Optional)
      #   #-------------------------------------------------------------
      #
      #   # network_bandwidth_gbps (Optional)
      #   # 設定内容: ネットワーク帯域幅の最小・最大（Gbps）を指定します。
      #   # network_bandwidth_gbps {
      #   #   min = null  # 最小Gbps
      #   #   max = null  # 最大Gbps
      #   # }
      #
      #   # network_interface_count (Optional)
      #   # 設定内容: ネットワークインターフェース数の最小・最大を指定します。
      #   # network_interface_count {
      #   #   min = null  # 最小数
      #   #   max = null  # 最大数
      #   # }
      #
      #   #-------------------------------------------------------------
      #   # アクセラレータ設定 (Optional)
      #   #-------------------------------------------------------------
      #
      #   # accelerator_count (Optional)
      #   # 設定内容: アクセラレータ（GPU、FPGA、AWS Inferentia）の最小・最大数を指定します。
      #   # accelerator_count {
      #   #   min = null  # 最小数
      #   #   max = null  # 最大数（0でアクセラレータなしインスタンスのみ）
      #   # }
      #
      #   # accelerator_manufacturers (Optional)
      #   # 設定内容: アクセラレータのメーカーを指定します。
      #   # 設定可能な値:
      #   #   - "nvidia"
      #   #   - "amd"
      #   #   - "amazon-web-services"
      #   #   - "xilinx"
      #   # デフォルト: 全メーカー
      #   # accelerator_manufacturers = ["nvidia"]
      #
      #   # accelerator_names (Optional)
      #   # 設定内容: アクセラレータの名前を指定します。
      #   # 設定可能な値:
      #   #   - "a100", "v100", "k80", "t4", "m60" (NVIDIA)
      #   #   - "radeon-pro-v520" (AMD)
      #   #   - "vu9p" (Xilinx)
      #   # デフォルト: 全アクセラレータ
      #   # accelerator_names = ["t4", "v100"]
      #
      #   # accelerator_types (Optional)
      #   # 設定内容: アクセラレータのタイプを指定します。
      #   # 設定可能な値:
      #   #   - "gpu"
      #   #   - "fpga"
      #   #   - "inference"
      #   # デフォルト: 全タイプ
      #   # accelerator_types = ["gpu"]
      #
      #   # accelerator_total_memory_mib (Optional)
      #   # 設定内容: アクセラレータメモリ合計の最小・最大（MiB）を指定します。
      #   # accelerator_total_memory_mib {
      #   #   min = null  # 最小MiB
      #   #   max = null  # 最大MiB
      #   # }
      #
      #   #-------------------------------------------------------------
      #   # 価格保護設定 (Optional)
      #   #-------------------------------------------------------------
      #
      #   # on_demand_max_price_percentage_over_lowest_price (Optional)
      #   # 設定内容: オンデマンドインスタンスの価格保護閾値を指定します。
      #   # 設定可能な値: 整数（パーセンテージ）
      #   # デフォルト: 20
      #   # 用途: 最も安いM, C, Rインスタンスタイプより指定%高い価格のインスタンスを除外
      #   # on_demand_max_price_percentage_over_lowest_price = 20
      #
      #   # spot_max_price_percentage_over_lowest_price (Optional)
      #   # 設定内容: スポットインスタンスの価格保護閾値を指定します。
      #   # 設定可能な値: 整数（パーセンテージ）
      #   # デフォルト: 100
      #   # 注意: max_spot_price_as_percentage_of_optimal_on_demand_priceと競合
      #   # spot_max_price_percentage_over_lowest_price = 100
      #
      #   # max_spot_price_as_percentage_of_optimal_on_demand_price (Optional)
      #   # 設定内容: スポットインスタンスの価格保護閾値（オンデマンド価格比）を指定します。
      #   # 設定可能な値: 整数（パーセンテージ）
      #   # 注意: spot_max_price_percentage_over_lowest_priceと競合
      #   # max_spot_price_as_percentage_of_optimal_on_demand_price = null
      # }
    }
  }

  #-------------------------------------------------------------
  # ターゲット容量設定 (Required)
  #-------------------------------------------------------------

  # target_capacity_specification (Required)
  # 設定内容: フリートのターゲット容量を定義します。
  target_capacity_specification {
    # default_target_capacity_type (Required)
    # 設定内容: デフォルトのターゲット容量タイプを指定します。
    # 設定可能な値:
    #   - "on-demand": オンデマンドインスタンス
    #   - "spot": スポットインスタンス
    default_target_capacity_type = "spot"

    # total_target_capacity (Required)
    # 設定内容: リクエストするユニットの総数を指定します。
    # 設定可能な値: 正の整数
    # 用途: default_target_capacity_typeを使用してこの数を満たす
    total_target_capacity = 5

    # on_demand_target_capacity (Optional)
    # 設定内容: リクエストするオンデマンドユニット数を指定します。
    # 設定可能な値: 0以上の整数
    on_demand_target_capacity = null

    # spot_target_capacity (Optional)
    # 設定内容: リクエストするスポットユニット数を指定します。
    # 設定可能な値: 0以上の整数
    spot_target_capacity = null

    # target_capacity_unit_type (Optional)
    # 設定内容: ターゲット容量の単位を指定します。
    # 設定可能な値:
    #   - "units" (デフォルト): インスタンス数
    #   - "vcpu": vCPU数
    #   - "memory-mib": メモリ量（MiB）
    # 注意: vcpuまたはmemory-mibを指定する場合、instance_requirementsが必要
    target_capacity_unit_type = null
  }

  #-------------------------------------------------------------
  # オンデマンドオプション設定 (Optional)
  #-------------------------------------------------------------

  # on_demand_options (Optional)
  # 設定内容: オンデマンドインスタンスの設定を定義します。
  on_demand_options {
    # allocation_strategy (Optional)
    # 設定内容: オンデマンド容量を満たす際の起動テンプレートオーバーライドの順序を指定します。
    # 設定可能な値:
    #   - "lowestPrice" (デフォルト): 最低価格のプールから起動
    #   - "prioritized": 優先度順に起動（overrideのpriorityを参照）
    allocation_strategy = "lowestPrice"

    # max_total_price (Optional)
    # 設定内容: オンデマンドインスタンスの時間あたり最大支払額を指定します。
    # 設定可能な値: 価格を表す文字列（例: "1.00"）
    max_total_price = null

    # min_target_capacity (Optional)
    # 設定内容: オンデマンドインスタンスの最小ターゲット容量を指定します。
    # 設定可能な値: 0以上の整数
    # 注意: typeが"instant"のフリートでのみサポート
    # 注意: 指定時、single_availability_zoneまたはsingle_instance_typeの指定が必要
    min_target_capacity = null

    # single_availability_zone (Optional)
    # 設定内容: 全オンデマンドインスタンスを単一アベイラビリティゾーンで起動するかを指定します。
    # 設定可能な値:
    #   - true: 単一AZで起動
    #   - false: 複数AZで起動可能
    # 注意: typeが"instant"のフリートでのみサポート
    single_availability_zone = null

    # single_instance_type (Optional)
    # 設定内容: 全オンデマンドインスタンスを単一インスタンスタイプで起動するかを指定します。
    # 設定可能な値:
    #   - true: 単一インスタンスタイプで起動
    #   - false: 複数インスタンスタイプで起動可能
    # 注意: typeが"instant"のフリートでのみサポート
    single_instance_type = null

    # capacity_reservation_options (Optional)
    # 設定内容: キャパシティ予約の使用オプションを定義します。
    # capacity_reservation_options {
    #   # usage_strategy (Optional)
    #   # 設定内容: 未使用のキャパシティ予約をオンデマンド容量の充足に使用するかを指定します。
    #   # 設定可能な値:
    #   #   - "use-capacity-reservations-first": キャパシティ予約を優先使用
    #   #   - 省略時: キャパシティ予約を使用しない
    #   usage_strategy = "use-capacity-reservations-first"
    # }
  }

  #-------------------------------------------------------------
  # スポットオプション設定 (Optional)
  #-------------------------------------------------------------

  # spot_options (Optional)
  # 設定内容: スポットインスタンスの設定を定義します。
  spot_options {
    # allocation_strategy (Optional)
    # 設定内容: スポット容量の割り当て戦略を指定します。
    # 設定可能な値:
    #   - "lowestPrice" (デフォルト): 最低価格のプールから起動
    #   - "diversified": 全プールに分散して起動
    #   - "capacity-optimized": 最も容量のあるプールから起動（中断リスク低減）
    #   - "capacity-optimized-prioritized": 容量最適化＋優先度考慮
    #   - "price-capacity-optimized" (推奨): 価格と容量を両方考慮
    allocation_strategy = "price-capacity-optimized"

    # instance_interruption_behavior (Optional)
    # 設定内容: スポットインスタンス中断時の動作を指定します。
    # 設定可能な値:
    #   - "terminate" (デフォルト): インスタンスを終了
    #   - "stop": インスタンスを停止
    #   - "hibernate": インスタンスをハイバネート
    instance_interruption_behavior = "terminate"

    # instance_pools_to_use_count (Optional)
    # 設定内容: ターゲット容量を割り当てるスポットプール数を指定します。
    # 設定可能な値: 正の整数
    # デフォルト: 1
    # 注意: allocation_strategyが"lowestPrice"の場合のみ有効
    instance_pools_to_use_count = null

    # max_total_price (Optional)
    # 設定内容: スポットインスタンスの時間あたり最大支払額を指定します。
    # 設定可能な値: 価格を表す文字列（例: "0.50"）
    max_total_price = null

    # min_target_capacity (Optional)
    # 設定内容: スポットインスタンスの最小ターゲット容量を指定します。
    # 設定可能な値: 0以上の整数
    # 注意: typeが"instant"のフリートでのみサポート
    min_target_capacity = null

    # single_availability_zone (Optional)
    # 設定内容: 全スポットインスタンスを単一アベイラビリティゾーンで起動するかを指定します。
    # 設定可能な値:
    #   - true: 単一AZで起動
    #   - false: 複数AZで起動可能
    # 注意: typeが"instant"のフリートでのみサポート
    single_availability_zone = null

    # single_instance_type (Optional)
    # 設定内容: 全スポットインスタンスを単一インスタンスタイプで起動するかを指定します。
    # 設定可能な値:
    #   - true: 単一インスタンスタイプで起動
    #   - false: 複数インスタンスタイプで起動可能
    # 注意: typeが"instant"のフリートでのみサポート
    single_instance_type = null

    # maintenance_strategies (Optional)
    # 設定内容: 中断リスクの高いスポットインスタンスを管理するメンテナンス戦略を定義します。
    maintenance_strategies {
      # capacity_rebalance (Optional)
      # 設定内容: 容量リバランス設定を定義します。
      capacity_rebalance {
        # replacement_strategy (Optional)
        # 設定内容: 置き換え戦略を指定します。
        # 設定可能な値:
        #   - "launch": リバランス推奨を受けたら代替インスタンスを起動
        # 注意: typeが"maintain"のフリートでのみ有効
        replacement_strategy = "launch"

        # termination_delay (Optional)
        # 設定内容: 元のインスタンス終了までの遅延時間（秒）を指定します。
        # 設定可能な値: 120〜7200の整数
        # 用途: アプリケーションの graceful shutdown に時間を確保
        termination_delay = null
      }
    }
  }

  #-------------------------------------------------------------
  # フリートインスタンスセット設定 (Optional)
  #-------------------------------------------------------------

  # fleet_instance_set (Optional, Computed)
  # 設定内容: フリートによって起動されたインスタンスの情報
  # 注意: typeが"instant"の場合のみ使用可能
  # 通常はcomputed属性として出力されるが、Terraform stateの整合性のために
  # 明示的に設定することも可能
  # fleet_instance_set {
  #   instance_ids  = null  # 起動されたインスタンスのID一覧
  #   instance_type = null  # インスタンスタイプ
  #   lifecycle     = null  # "spot" または "on-demand"
  #   platform      = null  # Windowsの場合は"Windows"、それ以外は空
  # }

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: フリートリソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 注意: 起動時にインスタンスにタグを付けるには、起動テンプレートでタグを指定してください
  # 関連機能: プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #           一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "my-ec2-fleet"
    Environment = "production"
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト時間を指定します。
  timeouts {
    # create (Optional)
    # 設定内容: リソース作成のタイムアウト時間を指定します。
    # 設定可能な値: 時間を表す文字列（例: "10m", "1h"）
    create = null

    # update (Optional)
    # 設定内容: リソース更新のタイムアウト時間を指定します。
    # 設定可能な値: 時間を表す文字列（例: "10m", "1h"）
    update = null

    # delete (Optional)
    # 設定内容: リソース削除のタイムアウト時間を指定します。
    # 設定可能な値: 時間を表す文字列（例: "10m", "1h"）
    delete = null
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: フリートのAmazon Resource Name (ARN)
#
# - id: フリート識別子（Fleet ID）
#
# - fleet_state: フリートの状態
#
# - fulfilled_capacity: ターゲット容量に対して満たされたユニット数
#
# - fulfilled_on_demand_capacity: ターゲットオンデマンド容量に対して満たされたユニット数
#
# - fleet_instance_set: フリートによって起動されたインスタンスの情報
#                       （typeが"instant"の場合のみ利用可能）
#   - instance_ids: 起動されたインスタンスのID一覧
#   - instance_type: インスタンスタイプ
#   - lifecycle: スポットまたはオンデマンド
#   - platform: Windowsの場合は"Windows"、それ以外は空白
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
