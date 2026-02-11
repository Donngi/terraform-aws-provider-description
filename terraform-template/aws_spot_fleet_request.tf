#---------------------------------------------------------------
# AWS EC2 Spot Fleet Request
#---------------------------------------------------------------
#
# EC2 Spot Fleetリクエストをプロビジョニングするリソースです。
# Spotマーケットにおいてスポットインスタンスのフリートをリクエストし、
# 指定したターゲット容量を維持または一度限りのリクエストとして起動します。
#
# NOTE: AWSはこのレガシーAPIの使用を推奨していません。
#       代わりに aws_ec2_fleet または aws_autoscaling_group の使用を検討してください。
#       参考: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/spot-best-practices.html#which-spot-request-method-to-use
#
# AWS公式ドキュメント:
#   - Spot Fleetの仕組み: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/how-spot-fleet-works.html
#   - SpotFleetRequestConfigData: https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_SpotFleetRequestConfigData.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/spot_fleet_request
#
# Provider Version: 6.28.0
# Generated: 2026-02-09
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_spot_fleet_request" "example" {
  #-------------------------------------------------------------
  # 基本設定（必須）
  #-------------------------------------------------------------

  # iam_fleet_role (Required)
  # 設定内容: Spot Fleetに対してインスタンスの起動・終了・タグ付けの権限を付与するIAMロールのARNを指定します。
  # 設定可能な値: 有効なIAMロールARN
  # 関連機能: Spot Fleet IAMロール
  #   Spot Fleetがユーザーに代わってSpotインスタンスをリクエスト・起動・終了するために必要な権限を定義します。
  #   - https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/spot-fleet-requests.html#spot-fleet-prerequisites
  iam_fleet_role = "arn:aws:iam::123456789012:role/spot-fleet-role"

  # target_capacity (Required)
  # 設定内容: リクエストするユニット数を指定します。
  # 設定可能な値: 正の整数
  # 注意: インスタンス数、vCPU数、メモリ量など、アプリケーションに重要なパフォーマンス特性に基づいて設定可能。
  #       target_capacity_unit_typeと組み合わせて使用します。
  target_capacity = 2

  #-------------------------------------------------------------
  # 容量・割り当て設定
  #-------------------------------------------------------------

  # allocation_strategy (Optional)
  # 設定内容: Spotプールに対するターゲット容量の割り当て戦略を指定します。
  # 設定可能な値:
  #   - "lowestPrice" (デフォルト): 最低価格のプールを優先
  #   - "diversified": 全プールに均等に分散
  #   - "capacityOptimized": 利用可能な容量が最も多いプールを優先
  #   - "capacityOptimizedPrioritized": 容量最適化に加えてオーバーライドの優先度を考慮
  #   - "priceCapacityOptimized": 価格と容量の両方を最適化
  # 関連機能: Spot Fleet割り当て戦略
  #   - https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/how-spot-fleet-works.html
  allocation_strategy = "lowestPrice"

  # instance_pools_to_use_count (Optional)
  # 設定内容: ターゲットSpot容量を割り当てるSpotプールの数を指定します。
  # 設定可能な値: 正の整数
  # 省略時: 1
  # 注意: allocation_strategyが"lowestPrice"の場合のみ有効。
  #       指定した数のプールの中で最安値のプールを選択し、容量を均等に分配します。
  instance_pools_to_use_count = 1

  # target_capacity_unit_type (Optional)
  # 設定内容: ターゲット容量の単位を指定します。
  # 設定可能な値:
  #   - "units": インスタンス数
  #   - "vcpu": vCPU数
  #   - "memory-mib": メモリ量(MiB)
  # 注意: instance_requirementsを定義している場合のみ使用可能
  target_capacity_unit_type = null

  #-------------------------------------------------------------
  # Spotインスタンス価格設定
  #-------------------------------------------------------------

  # spot_price (Optional)
  # 設定内容: ユニットあたりの最大入札価格（1時間あたり）を指定します。
  # 設定可能な値: 文字列形式の数値（例: "0.03"）
  # 省略時: オンデマンド価格を使用
  spot_price = "0.03"

  #-------------------------------------------------------------
  # フリートタイプ・ライフサイクル設定
  #-------------------------------------------------------------

  # fleet_type (Optional)
  # 設定内容: フリートリクエストのタイプを指定します。
  # 設定可能な値:
  #   - "maintain" (デフォルト): ターゲット容量を継続的に維持。中断されたインスタンスを自動補充
  #   - "request": 一度限りのリクエスト。容量が減少しても補充しない
  # 関連機能: Spot Fleetリクエストタイプ
  #   - https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-fleet-request-type.html
  fleet_type = "maintain"

  # valid_from (Optional)
  # 設定内容: リクエストの開始日時をUTC RFC3339形式で指定します。
  # 設定可能な値: RFC3339形式の日時文字列（例: "2026-01-01T00:00:00Z"）
  # 省略時: 即座にリクエストの実行を開始
  valid_from = null

  # valid_until (Optional)
  # 設定内容: リクエストの終了日時をUTC RFC3339形式で指定します。
  # 設定可能な値: RFC3339形式の日時文字列（例: "2026-12-31T23:59:59Z"）
  # 省略時: リクエストは無期限
  # 注意: この時点以降、新しいSpotインスタンスリクエストは作成されません。
  valid_until = null

  # wait_for_fulfillment (Optional)
  # 設定内容: TerraformがSpotリクエストの完了を待機するかを指定します。
  # 設定可能な値:
  #   - true: リクエストが完了するまで待機（10分のタイムアウト）
  #   - false (デフォルト): 待機しない
  wait_for_fulfillment = false

  #-------------------------------------------------------------
  # インスタンス中断・終了設定
  #-------------------------------------------------------------

  # excess_capacity_termination_policy (Optional)
  # 設定内容: ターゲット容量が減少した場合に実行中のインスタンスを終了するかを指定します。
  # 設定可能な値:
  #   - "Default": 超過容量のインスタンスを終了
  #   - "NoTermination": 超過容量のインスタンスを終了しない
  excess_capacity_termination_policy = null

  # instance_interruption_behaviour (Optional)
  # 設定内容: Spotインスタンスが中断された際の動作を指定します。
  # 設定可能な値:
  #   - "terminate" (デフォルト): インスタンスを終了
  #   - "stop": インスタンスを停止
  #   - "hibernate": インスタンスをハイバネート
  instance_interruption_behaviour = "terminate"

  # terminate_instances_with_expiration (Optional)
  # 設定内容: Spot Fleetリクエストの有効期限切れ時に実行中のインスタンスを終了するかを指定します。
  # 設定可能な値: true / false
  terminate_instances_with_expiration = null

  # terminate_instances_on_delete (Optional)
  # 設定内容: リソース削除（Spot Fleetリクエストのキャンセル）時に実行中のインスタンスを終了するかを指定します。
  # 設定可能な値: "true" / "false"（文字列）
  # 省略時: terminate_instances_with_expirationの値を使用
  terminate_instances_on_delete = null

  # replace_unhealthy_instances (Optional)
  # 設定内容: 異常なインスタンスを置き換えるかを指定します。
  # 設定可能な値: true / false
  # 省略時: false
  replace_unhealthy_instances = false

  #-------------------------------------------------------------
  # オンデマンド設定
  #-------------------------------------------------------------

  # on_demand_allocation_strategy (Optional)
  # 設定内容: オンデマンド容量の起動テンプレートオーバーライドの順序を指定します。
  # 設定可能な値:
  #   - "lowestPrice" (デフォルト): 最低価格を優先
  #   - "prioritized": オーバーライドの優先度順
  on_demand_allocation_strategy = null

  # on_demand_max_total_price (Optional)
  # 設定内容: オンデマンドインスタンスに対して支払う1時間あたりの最大金額を指定します。
  # 設定可能な値: 文字列形式の数値
  # 注意: この金額に達するとターゲット容量が満たされていなくてもインスタンスの起動を停止します。
  on_demand_max_total_price = null

  # on_demand_target_capacity (Optional)
  # 設定内容: リクエストするオンデマンドユニット数を指定します。
  # 設定可能な値: 0以上の整数
  # 注意: リクエストタイプが"maintain"の場合、0を指定して後から容量を追加可能。
  on_demand_target_capacity = null

  #-------------------------------------------------------------
  # ロードバランサー設定
  #-------------------------------------------------------------

  # load_balancers (Optional)
  # 設定内容: Spot FleetリクエストにアタッチするClassic Load Balancerのリストを指定します。
  # 設定可能な値: Classic Load Balancer名のセット
  load_balancers = null

  # target_group_arns (Optional)
  # 設定内容: Spot FleetリクエストにアタッチするALB/NLBターゲットグループのARNリストを指定します。
  # 設定可能な値: ターゲットグループARNのセット
  target_group_arns = null

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
  # その他設定
  #-------------------------------------------------------------

  # context (Optional)
  # 設定内容: 予約済みフィールドです。
  context = null

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
    Name        = "my-spot-fleet"
    Environment = "production"
  }

  #-------------------------------------------------------------
  # 起動仕様 (launch_specification)
  #-------------------------------------------------------------
  # launch_template_configと排他的。どちらか一方を指定する必要があります。
  # 複数指定可能で、異なるマーケットやインスタンスタイプに対する入札を定義します。

  launch_specification {
    # ami (Required)
    # 設定内容: 使用するAMIのIDを指定します。
    ami = "ami-0123456789abcdef0"

    # instance_type (Required)
    # 設定内容: インスタンスタイプを指定します。
    # 設定可能な値: 有効なEC2インスタンスタイプ（例: "m5.large", "t3.micro"）
    instance_type = "m5.large"

    # availability_zone (Optional)
    # 設定内容: リクエストを配置するアベイラビリティゾーンを指定します。
    availability_zone = null

    # subnet_id (Optional)
    # 設定内容: インスタンスを起動するサブネットのIDを指定します。
    subnet_id = null

    # spot_price (Optional)
    # 設定内容: このオーバーライドリクエストの最大スポット入札価格を指定します。
    spot_price = null

    # weighted_capacity (Optional)
    # 設定内容: このリクエストが完了した際にフリートに追加される容量の重みを指定します。
    weighted_capacity = null

    # key_name (Optional)
    # 設定内容: SSHアクセスに使用するキーペア名を指定します。
    key_name = null

    # iam_instance_profile (Optional)
    # 設定内容: IAMインスタンスプロファイルの名前を指定します。
    # 注意: iam_instance_profile_arnと排他的
    iam_instance_profile = null

    # iam_instance_profile_arn (Optional)
    # 設定内容: IAMインスタンスプロファイルのARNを指定します。
    # 注意: iam_instance_profileと排他的
    iam_instance_profile_arn = null

    # vpc_security_group_ids (Optional)
    # 設定内容: VPCセキュリティグループIDのリストを指定します。
    vpc_security_group_ids = null

    # associate_public_ip_address (Optional)
    # 設定内容: パブリックIPアドレスを関連付けるかを指定します。
    # 設定可能な値: true / false
    associate_public_ip_address = null

    # ebs_optimized (Optional)
    # 設定内容: EBS最適化インスタンスとして起動するかを指定します。
    # 設定可能な値: true / false
    ebs_optimized = null

    # monitoring (Optional)
    # 設定内容: 詳細モニタリングを有効にするかを指定します。
    # 設定可能な値: true / false
    monitoring = null

    # placement_group (Optional)
    # 設定内容: インスタンスを配置するプレイスメントグループ名を指定します。
    placement_group = null

    # placement_tenancy (Optional)
    # 設定内容: インスタンスのテナンシーを指定します。
    # 設定可能な値: "default", "dedicated"
    placement_tenancy = null

    # user_data (Optional)
    # 設定内容: インスタンス起動時に実行するユーザーデータを指定します。
    # 設定可能な値: Base64エンコードされた文字列またはプレーンテキスト
    user_data = null

    # tags (Optional)
    # 設定内容: 起動されるインスタンスに割り当てるタグのマップを指定します。
    tags = null

    #-----------------------------------------------------------
    # EBSブロックデバイス (ebs_block_device)
    #-----------------------------------------------------------

    ebs_block_device {
      # device_name (Required)
      # 設定内容: デバイス名を指定します（例: "/dev/sdf"）。
      device_name = "/dev/sdf"

      # volume_type (Optional)
      # 設定内容: EBSボリュームタイプを指定します。
      # 設定可能な値: "gp2", "gp3", "io1", "io2", "st1", "sc1", "standard"
      volume_type = null

      # volume_size (Optional)
      # 設定内容: ボリュームサイズ（GiB）を指定します。
      volume_size = null

      # iops (Optional)
      # 設定内容: プロビジョンドIOPSを指定します。
      # 注意: volume_typeがio1/io2の場合に使用
      iops = null

      # throughput (Optional)
      # 設定内容: スループット（MiB/s）を指定します。
      # 注意: volume_typeがgp3の場合に使用
      throughput = null

      # encrypted (Optional)
      # 設定内容: ボリュームを暗号化するかを指定します。
      encrypted = null

      # kms_key_id (Optional)
      # 設定内容: 暗号化に使用するKMSキーのARNを指定します。
      kms_key_id = null

      # snapshot_id (Optional)
      # 設定内容: ボリュームの作成元となるスナップショットIDを指定します。
      snapshot_id = null

      # delete_on_termination (Optional)
      # 設定内容: インスタンス終了時にボリュームを削除するかを指定します。
      # 設定可能な値: true / false
      delete_on_termination = null
    }

    #-----------------------------------------------------------
    # エフェメラルブロックデバイス (ephemeral_block_device)
    #-----------------------------------------------------------

    ephemeral_block_device {
      # device_name (Required)
      # 設定内容: デバイス名を指定します。
      device_name = "/dev/sdb"

      # virtual_name (Required)
      # 設定内容: 仮想デバイス名を指定します（例: "ephemeral0"）。
      virtual_name = "ephemeral0"
    }

    #-----------------------------------------------------------
    # ルートブロックデバイス (root_block_device)
    #-----------------------------------------------------------

    root_block_device {
      # volume_type (Optional)
      # 設定内容: ルートボリュームタイプを指定します。
      # 設定可能な値: "gp2", "gp3", "io1", "io2", "st1", "sc1", "standard"
      volume_type = null

      # volume_size (Optional)
      # 設定内容: ルートボリュームサイズ（GiB）を指定します。
      volume_size = null

      # iops (Optional)
      # 設定内容: プロビジョンドIOPSを指定します。
      iops = null

      # throughput (Optional)
      # 設定内容: スループット（MiB/s）を指定します。
      throughput = null

      # encrypted (Optional)
      # 設定内容: ルートボリュームを暗号化するかを指定します。
      encrypted = null

      # kms_key_id (Optional)
      # 設定内容: 暗号化に使用するKMSキーのARNを指定します。
      kms_key_id = null

      # delete_on_termination (Optional)
      # 設定内容: インスタンス終了時にルートボリュームを削除するかを指定します。
      delete_on_termination = null
    }
  }

  #-------------------------------------------------------------
  # 起動テンプレート設定 (launch_template_config)
  #-------------------------------------------------------------
  # launch_specificationと排他的。どちらか一方を指定する必要があります。
  # 複数指定可能。

  # launch_template_config {
  #   #---------------------------------------------------------
  #   # 起動テンプレート仕様 (launch_template_specification) - Required
  #   #---------------------------------------------------------
  #
  #   launch_template_specification {
  #     # id (Optional)
  #     # 設定内容: 起動テンプレートのIDを指定します。
  #     # 注意: nameと排他的
  #     id = "lt-0123456789abcdef0"
  #
  #     # name (Optional)
  #     # 設定内容: 起動テンプレートの名前を指定します。
  #     # 注意: idと排他的
  #     # name = "my-launch-template"
  #
  #     # version (Optional)
  #     # 設定内容: テンプレートバージョンを指定します。
  #     # 注意: Auto Scalingと異なり$Latestや$Defaultはサポートされません。
  #     #       aws_launch_templateリソースのlatest_version属性等を使用してください。
  #     version = null
  #   }
  #
  #   #---------------------------------------------------------
  #   # オーバーライド (overrides) - Optional
  #   #---------------------------------------------------------
  #
  #   overrides {
  #     # availability_zone (Optional)
  #     # 設定内容: アベイラビリティゾーンを指定します。
  #     availability_zone = null
  #
  #     # instance_type (Optional)
  #     # 設定内容: インスタンスタイプを指定します。
  #     instance_type = null
  #
  #     # subnet_id (Optional)
  #     # 設定内容: サブネットIDを指定します。
  #     subnet_id = null
  #
  #     # spot_price (Optional)
  #     # 設定内容: 最大スポット入札価格を指定します。
  #     spot_price = null
  #
  #     # weighted_capacity (Optional)
  #     # 設定内容: 容量の重みを指定します。
  #     weighted_capacity = null
  #
  #     # priority (Optional)
  #     # 設定内容: オーバーライドの優先度を指定します。数値が低いほど優先度が高くなります。
  #     priority = null
  #
  #     #-------------------------------------------------------
  #     # インスタンス要件 (instance_requirements) - Optional
  #     #-------------------------------------------------------
  #     # 属性ベースのインスタンスタイプ選択を定義します。
  #
  #     # instance_requirements {
  #     #   # accelerator_manufacturers (Optional)
  #     #   # 設定内容: アクセラレーター製造元のリストを指定します。
  #     #   # 設定可能な値: "amazon-web-services", "amd", "nvidia", "xilinx"
  #     #   accelerator_manufacturers = null
  #     #
  #     #   # accelerator_names (Optional)
  #     #   # 設定内容: アクセラレーター名のリストを指定します。
  #     #   # 設定可能な値: "a100", "v100", "k80", "t4", "m60", "radeon-pro-v520", "vu9p"
  #     #   accelerator_names = null
  #     #
  #     #   # accelerator_types (Optional)
  #     #   # 設定内容: アクセラレータータイプのリストを指定します。
  #     #   # 設定可能な値: "fpga", "gpu", "inference"
  #     #   accelerator_types = null
  #     #
  #     #   # allowed_instance_types (Optional)
  #     #   # 設定内容: 許可するインスタンスタイプのリストを指定します。
  #     #   # 設定可能な値: インスタンスタイプ名（ワイルドカード可）。最大400エントリ。
  #     #   # 注意: excluded_instance_typesと排他的
  #     #   allowed_instance_types = null
  #     #
  #     #   # bare_metal (Optional)
  #     #   # 設定内容: ベアメタルインスタンスタイプの扱いを指定します。
  #     #   # 設定可能な値: "included", "excluded" (デフォルト), "required"
  #     #   bare_metal = null
  #     #
  #     #   # burstable_performance (Optional)
  #     #   # 設定内容: バースト可能パフォーマンスインスタンスタイプの扱いを指定します。
  #     #   # 設定可能な値: "included", "excluded" (デフォルト), "required"
  #     #   burstable_performance = null
  #     #
  #     #   # cpu_manufacturers (Optional)
  #     #   # 設定内容: CPU製造元のリストを指定します。
  #     #   # 設定可能な値: "amazon-web-services", "amd", "intel"
  #     #   cpu_manufacturers = null
  #     #
  #     #   # excluded_instance_types (Optional)
  #     #   # 設定内容: 除外するインスタンスタイプのリストを指定します。
  #     #   # 注意: allowed_instance_typesと排他的
  #     #   excluded_instance_types = null
  #     #
  #     #   # instance_generations (Optional)
  #     #   # 設定内容: インスタンス世代のリストを指定します。
  #     #   # 設定可能な値: "current", "previous"
  #     #   instance_generations = null
  #     #
  #     #   # local_storage (Optional)
  #     #   # 設定内容: ローカルストレージ付きインスタンスタイプの扱いを指定します。
  #     #   # 設定可能な値: "included" (デフォルト), "excluded", "required"
  #     #   local_storage = null
  #     #
  #     #   # local_storage_types (Optional)
  #     #   # 設定内容: ローカルストレージタイプのリストを指定します。
  #     #   # 設定可能な値: "hdd", "ssd"
  #     #   local_storage_types = null
  #     #
  #     #   # on_demand_max_price_percentage_over_lowest_price (Optional)
  #     #   # 設定内容: オンデマンドの価格保護閾値（最安値に対するパーセンテージ）を指定します。
  #     #   # 省略時: 20
  #     #   on_demand_max_price_percentage_over_lowest_price = null
  #     #
  #     #   # spot_max_price_percentage_over_lowest_price (Optional)
  #     #   # 設定内容: Spotの価格保護閾値（最安値に対するパーセンテージ）を指定します。
  #     #   # 省略時: 100
  #     #   spot_max_price_percentage_over_lowest_price = null
  #     #
  #     #   # require_hibernate_support (Optional)
  #     #   # 設定内容: ハイバネーションサポートが必要かを指定します。
  #     #   # 省略時: false
  #     #   require_hibernate_support = null
  #     #
  #     #   # accelerator_count (Optional)
  #     #   # 設定内容: アクセラレーター数の最小・最大値を指定します。
  #     #   # accelerator_count {
  #     #   #   min = null
  #     #   #   max = null
  #     #   # }
  #     #
  #     #   # accelerator_total_memory_mib (Optional)
  #     #   # 設定内容: アクセラレーターの合計メモリ（MiB）の最小・最大値を指定します。
  #     #   # accelerator_total_memory_mib {
  #     #   #   min = null
  #     #   #   max = null
  #     #   # }
  #     #
  #     #   # baseline_ebs_bandwidth_mbps (Optional)
  #     #   # 設定内容: ベースラインEBS帯域幅（Mbps）の最小・最大値を指定します。
  #     #   # baseline_ebs_bandwidth_mbps {
  #     #   #   min = null
  #     #   #   max = null
  #     #   # }
  #     #
  #     #   # memory_gib_per_vcpu (Optional)
  #     #   # 設定内容: vCPUあたりのメモリ（GiB）の最小・最大値を指定します。
  #     #   # memory_gib_per_vcpu {
  #     #   #   min = null
  #     #   #   max = null
  #     #   # }
  #     #
  #     #   # memory_mib (Optional)
  #     #   # 設定内容: メモリ（MiB）の最小・最大値を指定します。
  #     #   # memory_mib {
  #     #   #   min = null
  #     #   #   max = null
  #     #   # }
  #     #
  #     #   # network_bandwidth_gbps (Optional)
  #     #   # 設定内容: ネットワーク帯域幅（Gbps）の最小・最大値を指定します。
  #     #   # network_bandwidth_gbps {
  #     #   #   min = null
  #     #   #   max = null
  #     #   # }
  #     #
  #     #   # network_interface_count (Optional)
  #     #   # 設定内容: ネットワークインターフェース数の最小・最大値を指定します。
  #     #   # network_interface_count {
  #     #   #   min = null
  #     #   #   max = null
  #     #   # }
  #     #
  #     #   # total_local_storage_gb (Optional)
  #     #   # 設定内容: 合計ローカルストレージ（GB）の最小・最大値を指定します。
  #     #   # total_local_storage_gb {
  #     #   #   min = null
  #     #   #   max = null
  #     #   # }
  #     #
  #     #   # vcpu_count (Optional)
  #     #   # 設定内容: vCPU数の最小・最大値を指定します。
  #     #   # vcpu_count {
  #     #   #   min = null
  #     #   #   max = null
  #     #   # }
  #     # }
  #   }
  # }

  #-------------------------------------------------------------
  # Spotメンテナンス戦略 (spot_maintenance_strategies)
  #-------------------------------------------------------------

  spot_maintenance_strategies {
    # capacity_rebalance (Optional)
    # 設定内容: 中断リスクの高いSpotインスタンスの容量リバランス設定を定義します。
    capacity_rebalance {
      # replacement_strategy (Optional)
      # 設定内容: 置き換え戦略を指定します。
      # 設定可能な値:
      #   - "launch": 中断リスクのあるインスタンスの代替を事前に起動
      # 注意: fleet_typeが"maintain"の場合のみ使用可能
      replacement_strategy = null
    }
  }

  #-------------------------------------------------------------
  # タイムアウト設定 (timeouts)
  #-------------------------------------------------------------

  timeouts {
    # create (Optional)
    # 設定内容: リソース作成のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列（例: "10m", "1h"）
    create = null

    # update (Optional)
    # 設定内容: リソース更新のタイムアウト時間を指定します。
    update = null

    # delete (Optional)
    # 設定内容: リソース削除のタイムアウト時間を指定します。
    delete = null
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: Spot Fleetリクエストの一意なID
#
# - client_token: リクエストの冪等性を保証するための一意なトークン
#
# - spot_request_state: Spot Fleetリクエストの状態
#   （例: "submitted", "active", "cancelled", "failed"等）
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
