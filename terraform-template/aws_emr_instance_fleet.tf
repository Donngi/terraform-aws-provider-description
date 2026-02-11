#---------------------------------------------------------------
# Amazon EMR Instance Fleet
#---------------------------------------------------------------
#
# Amazon EMR Instance Fleetを構成するためのリソース。
# Instance Fleetは、EMRクラスターのノードタイプ（Master、Core、Task）ごとに
# EC2インスタンスタイプとキャパシティを柔軟に管理する機能を提供します。
# On-DemandインスタンスとSpotインスタンスの混在利用が可能で、
# コスト最適化と可用性のバランスを取ることができます。
#
# AWS公式ドキュメント:
#   - Planning and configuring instance fleets: https://docs.aws.amazon.com/emr/latest/ManagementGuide/emr-instance-fleet.html
#   - InstanceFleetConfig API: https://docs.aws.amazon.com/emr/latest/APIReference/API_InstanceFleetConfig.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/emr_instance_fleet
#
# Provider Version: 6.28.0
# Generated: 2026-01-27
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_emr_instance_fleet" "example" {
  #---------------------------------------------------------------
  # 必須パラメータ
  #---------------------------------------------------------------

  # cluster_id - (Required) EMRクラスターのID
  # このInstance Fleetを追加するEMRクラスターのIDを指定します。
  # 変更するとリソースが再作成されます。
  # 型: string
  cluster_id = "j-XXXXXXXXXXXXX"

  #---------------------------------------------------------------
  # オプションパラメータ
  #---------------------------------------------------------------

  # id - (Optional) Instance FleetのID
  # Terraformによって自動的に生成されますが、明示的に指定することも可能です。
  # 通常は指定不要で、computedな値として参照します。
  # 型: string
  # id = null

  # name - (Optional) Instance Fleetの名前
  # Instance Fleetに付ける分かりやすい名前です。
  # 例: "task fleet", "core fleet"
  # 型: string
  name = null

  # region - (Optional) リージョン
  # このリソースが管理されるAWSリージョンを指定します。
  # 指定しない場合、プロバイダー設定のリージョンがデフォルトで使用されます。
  # 詳細: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # 型: string
  # region = null

  # target_on_demand_capacity - (Optional) On-Demandインスタンスの目標キャパシティ
  # Instance FleetでプロビジョニングするOn-Demandインスタンスの目標容量を指定します。
  # この値により、プロビジョニングされるOn-Demandインスタンスの数が決定されます。
  # weighted_capacityを使用している場合、インスタンス数ではなく重み付けされた容量の合計を表します。
  # 型: number
  target_on_demand_capacity = null

  # target_spot_capacity - (Optional) Spotインスタンスの目標キャパシティ
  # Instance FleetでプロビジョニングするSpotインスタンスの目標容量を指定します。
  # この値により、プロビジョニングされるSpotインスタンスの数が決定されます。
  # weighted_capacityを使用している場合、インスタンス数ではなく重み付けされた容量の合計を表します。
  # 型: number
  target_spot_capacity = null

  #---------------------------------------------------------------
  # instance_type_configs - Instance Fleet構成ブロック
  #---------------------------------------------------------------
  # (Optional) Instance Fleetで使用するEC2インスタンスタイプの構成を定義します。
  # 最大5つのインスタンスタイプ（コンソール）、または最大30個（CLI/API）を指定可能です。
  # EMRは指定されたインスタンスタイプの中から、最適なものを自動選択してプロビジョニングします。

  instance_type_configs {
    # instance_type - (Required) EC2インスタンスタイプ
    # 例: "m4.xlarge", "m5.2xlarge", "r5.4xlarge"
    # 型: string
    instance_type = "m4.xlarge"

    # bid_price - (Optional) Spotインスタンスの入札価格
    # Spotインスタンスの最大入札価格をドル単位で指定します。
    # 指定しない場合、On-Demand価格がデフォルトの最大価格として使用されます。
    # bid_price_as_percentage_of_on_demand_priceと併用はできません。
    # 型: string
    # bid_price = null

    # bid_price_as_percentage_of_on_demand_price - (Optional) On-Demand価格に対する入札価格の割合
    # Spotインスタンスの入札価格をOn-Demand価格のパーセンテージで指定します。
    # 例: 100 = On-Demand価格と同額、80 = On-Demand価格の80%
    # bid_priceと併用はできません。
    # 型: number
    bid_price_as_percentage_of_on_demand_price = null

    # weighted_capacity - (Optional) 重み付けキャパシティ
    # このインスタンスタイプが目標キャパシティに対して持つ重みを指定します。
    # 例: m4.xlargeに1、m4.2xlargeに2を設定すると、
    # target_spot_capacity=2の場合、m4.xlarge 2台またはm4.2xlarge 1台がプロビジョニングされます。
    # 指定しない場合、デフォルトは1です。
    # 型: number
    weighted_capacity = null

    #---------------------------------------------------------------
    # configurations - インスタンス構成設定ブロック
    #---------------------------------------------------------------
    # (Optional) このインスタンスタイプに適用するEMRアプリケーション設定を指定します。
    # Hadoop、Spark、Hiveなどのアプリケーション設定をカスタマイズできます。

    configurations {
      # classification - (Optional) 設定の分類
      # 設定を適用するアプリケーションまたはコンポーネントの分類を指定します。
      # 例: "hadoop-env", "spark", "hive-site", "core-site"
      # 型: string
      classification = null

      # properties - (Optional) 設定プロパティ
      # 分類に適用するプロパティをキー/バリューのマップで指定します。
      # 例: { "spark.executor.memory" = "4g", "spark.executor.cores" = "2" }
      # 型: map(string)
      properties = null
    }

    #---------------------------------------------------------------
    # ebs_config - EBSボリューム構成ブロック
    #---------------------------------------------------------------
    # (Optional) インスタンスにアタッチするEBSボリュームの構成を定義します。
    # 複数のebs_configブロックを指定して、異なるタイプのボリュームを追加できます。

    ebs_config {
      # size - (Required) ボリュームサイズ
      # EBSボリュームのサイズをGiB単位で指定します。
      # 型: number
      size = 100

      # type - (Required) ボリュームタイプ
      # EBSボリュームのタイプを指定します。
      # 有効な値: "gp2", "gp3", "io1", "io2", "st1", "sc1", "standard"
      # 型: string
      type = "gp2"

      # iops - (Optional) IOPS
      # プロビジョニングドIOPS（io1、io2、gp3ボリュームタイプで使用）
      # io1/io2の場合: 100-64000、gp3の場合: 3000-16000
      # 型: number
      iops = null

      # volumes_per_instance - (Optional) インスタンスごとのボリューム数
      # 各インスタンスにアタッチするこの設定のEBSボリュームの数を指定します。
      # デフォルトは1です。
      # 型: number
      volumes_per_instance = null
    }
  }

  #---------------------------------------------------------------
  # launch_specifications - 起動仕様ブロック
  #---------------------------------------------------------------
  # (Optional) Instance Fleetの起動仕様を定義します。
  # On-DemandインスタンスとSpotインスタンスの割り当て戦略やタイムアウト設定を指定できます。

  launch_specifications {
    #---------------------------------------------------------------
    # on_demand_specification - On-Demandインスタンス仕様ブロック
    #---------------------------------------------------------------
    # (Optional) On-Demandインスタンスの割り当て戦略を定義します。

    on_demand_specification {
      # allocation_strategy - (Required) 割り当て戦略
      # On-Demandインスタンスの割り当て戦略を指定します。
      # 有効な値: "lowest-price" (最も低価格のインスタンスタイプを選択)
      # EMR 5.12.1以降で利用可能
      # 型: string
      allocation_strategy = "lowest-price"
    }

    #---------------------------------------------------------------
    # spot_specification - Spotインスタンス仕様ブロック
    #---------------------------------------------------------------
    # (Optional) Spotインスタンスの割り当て戦略とタイムアウト動作を定義します。

    spot_specification {
      # allocation_strategy - (Required) 割り当て戦略
      # Spotインスタンスの割り当て戦略を指定します。
      # 有効な値:
      # - "capacity-optimized": 最も利用可能な容量のプールから選択（推奨）
      # - "price-capacity-optimized": 価格と容量のバランスを考慮（EMR 6.15.0以降）
      # - "lowest-price": 最も低価格のプールから選択
      # - "diversified": 複数のプールに分散してプロビジョニング
      # EMR 5.12.1以降で利用可能
      # 型: string
      allocation_strategy = "capacity-optimized"

      # timeout_action - (Required) タイムアウト時のアクション
      # Spotインスタンスのプロビジョニングがタイムアウトした場合のアクションを指定します。
      # 有効な値:
      # - "TERMINATE_CLUSTER": クラスター全体を終了
      # - "SWITCH_TO_ON_DEMAND": On-Demandインスタンスに切り替え
      # 型: string
      timeout_action = "TERMINATE_CLUSTER"

      # timeout_duration_minutes - (Required) タイムアウト時間
      # Spotインスタンスのプロビジョニング待機時間を分単位で指定します。
      # この時間内にSpotインスタンスがプロビジョニングされない場合、timeout_actionが実行されます。
      # 型: number
      timeout_duration_minutes = 10

      # block_duration_minutes - (Optional) ブロック期間
      # Spotインスタンスの定義済み期間（ブロック期間）を分単位で指定します。
      # 指定した期間中はSpotインスタンスが中断されないことが保証されます。
      # 有効な値: 60, 120, 180, 240, 300, 360の倍数
      # 0を指定すると定義済み期間なしで起動します（デフォルト）。
      # 注意: この機能は2021年12月31日に廃止されました。
      # 型: number
      block_duration_minutes = null
    }
  }
}

#---------------------------------------------------------------
# Attributes Reference (Computed/Read-Only)
#---------------------------------------------------------------
# 以下の属性は、リソース作成後に参照可能です（入力不可）:
#
# - id
#   Instance Fleetの一意な識別子
#
# - provisioned_on_demand_capacity
#   Instance FleetでプロビジョニングされたOn-Demandユニットの数
#   TargetOnDemandCapacityを満たすためにプロビジョニングされた容量で、
#   目標値より多いまたは少ない場合があります。
#
# - provisioned_spot_capacity
#   Instance FleetでプロビジョニングされたSpotユニットの数
#   TargetSpotCapacityを満たすためにプロビジョニングされた容量で、
#   目標値より多いまたは少ない場合があります。
#
# - status
#   Instance Fleetの現在のステータス

#---------------------------------------------------------------
# 使用例
#---------------------------------------------------------------
# resource "aws_emr_instance_fleet" "task" {
#   cluster_id = aws_emr_cluster.cluster.id
#   name       = "task fleet"
#
#   target_on_demand_capacity = 1
#   target_spot_capacity      = 1
#
#   instance_type_configs {
#     instance_type                          = "m4.xlarge"
#     weighted_capacity                      = 1
#     bid_price_as_percentage_of_on_demand_price = 100
#
#     ebs_config {
#       size                 = 100
#       type                 = "gp2"
#       volumes_per_instance = 1
#     }
#   }
#
#   instance_type_configs {
#     instance_type                          = "m4.2xlarge"
#     weighted_capacity                      = 2
#     bid_price_as_percentage_of_on_demand_price = 100
#
#     ebs_config {
#       size                 = 100
#       type                 = "gp2"
#       volumes_per_instance = 1
#     }
#   }
#
#   launch_specifications {
#     spot_specification {
#       allocation_strategy      = "capacity-optimized"
#       timeout_action           = "TERMINATE_CLUSTER"
#       timeout_duration_minutes = 10
#     }
#   }
# }

#---------------------------------------------------------------
# 重要な注意事項
#---------------------------------------------------------------
# 1. Instance Fleetの削除について
#    現時点では、APIまたはWebインターフェースを通じてInstance Fleetを
#    削除することはできません。Instance FleetはEMRクラスターが削除される
#    ときに一緒に削除されます。Terraformでこのリソースを削除する際は、
#    Instance Fleetのサイズを0にリサイズします。
#
# 2. ノードタイプごとのInstance Fleet
#    各ノードタイプ（Master、Core、Task）に対して1つのInstance Fleetのみ
#    設定できます。
#
# 3. target_on_demand_capacityとtarget_spot_capacity
#    少なくともどちらか一方は0より大きい値を指定する必要があります。
#    Masterインスタンスfleetの場合、どちらか一方のみ指定可能で、その値は1でなければなりません。
#
# 4. 割り当て戦略
#    On-DemandおよびSpot割り当て戦略はEMR 5.12.1以降で利用可能です。
#
# 5. block_duration_minutes（廃止機能）
#    Spotブロック期間機能は2021年12月31日に廃止されました。
#    既存のブロック期間は引き続き機能しますが、新規作成は推奨されません。
