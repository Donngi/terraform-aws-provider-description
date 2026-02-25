#-------
# Amazon EMR Instance Fleet
#-------
# Provider Version: 6.28.0
# Terraform Registry: https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/emr_instance_fleet
# Generated: 2026-02-17
#
# NOTE: Instance FleetはAPIやWebコンソールから削除できません。EMRクラスタの削除時に
# Instance Fleetも削除されます。Terraformでリソースを削除する際は、フリートのサイズを
# 0にリサイズします。
#
# EMRクラスタのインスタンスフリート設定を提供します。
# Instance Fleetを使用すると、複数のEC2インスタンスタイプを指定し、
# スポットインスタンスとオンデマンドインスタンスを柔軟に組み合わせて
# 目標容量を満たすことができます。
#
# 【重要な制限事項】
# - Instance FleetはAPIやWebコンソールから削除できません
# - EMRクラスタの削除時にInstance Fleetも削除されます
# - Terraformでリソースを削除する際は、フリートのサイズを0にリサイズします
# - ノードタイプごとに1つのInstance Fleetのみ作成可能です
#
# 【対応バージョン】
# - Amazon EMR 4.8.0以降（ただし5.0.xは除く）
#
# ユースケース:
# - コスト最適化：スポットとオンデマンドを混在させてコスト削減
# - 高可用性：複数のインスタンスタイプと複数のアベイラビリティゾーンを使用
# - 柔軟なスケーリング：加重容量に基づく動的なプロビジョニング
# - タスクフリート：一時的な処理能力の追加
#
# 関連ドキュメント:
# https://docs.aws.amazon.com/emr/latest/ManagementGuide/emr-instance-fleet.html
# https://docs.aws.amazon.com/emr/latest/APIReference/API_InstanceFleetConfig.html
#-------

#-------
# 基本設定
#-------

resource "aws_emr_instance_fleet" "example" {
  # 設定内容: アタッチ先のEMRクラスタID
  # 設定可能な値: 有効なEMRクラスタのID
  # 補足: この値を変更すると新しいリソースが作成されます
  cluster_id = aws_emr_cluster.example.id

  # 設定内容: Instance Fleetの識別名
  # 設定可能な値: 任意の文字列（例: "task fleet", "core fleet"）
  # 省略時: 名前なしで作成されます
  name = "task fleet"

  # 設定内容: リソース管理対象リージョン
  # 設定可能な値: AWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンが使用されます
  region = "ap-northeast-1"

  #-------
  # 容量設定
  #-------

  # 設定内容: オンデマンドインスタンスの目標容量（ユニット数）
  # 設定可能な値: 0以上の整数
  # 補足:
  # - target_on_demand_capacityとtarget_spot_capacityの少なくとも一方は0より大きい値が必要
  # - MASTERフリートの場合は、どちらか一方のみ指定でき、値は1である必要があります
  # - 加重容量を使用する場合、実際のインスタンス数は容量/加重容量で計算されます
  target_on_demand_capacity = 1

  # 設定内容: スポットインスタンスの目標容量（ユニット数）
  # 設定可能な値: 0以上の整数
  # 補足: スポット容量が利用できない場合、タイムアウトアクションが実行されます
  target_spot_capacity = 1

  #-------
  # インスタンスタイプ設定
  #-------
  # 最大5つのインスタンスタイプを指定可能（CLI/API使用時は最大30）
  # EMRは指定されたタイプから最適なものを選択してプロビジョニングします

  instance_type_configs {
    # 設定内容: EC2インスタンスタイプ
    # 設定可能な値: 有効なEC2インスタンスタイプ（例: m4.xlarge, m5.2xlarge, r5.xlarge）
    instance_type = "m4.xlarge"

    # 設定内容: 加重容量
    # 設定可能な値: 正の整数
    # 補足: インスタンスが目標容量に対して持つユニット数を定義
    # 例: weighted_capacity=2の場合、1インスタンスで容量2ユニット分としてカウント
    weighted_capacity = 1

    # 設定内容: スポットインスタンスの入札価格（USD/時間）
    # 設定可能な値: 数値文字列（例: "0.50"）
    # 補足: bid_priceとbid_price_as_percentage_of_on_demand_priceは排他的
    # bid_price = "0.50"

    # 設定内容: オンデマンド価格に対する入札価格の割合
    # 設定可能な値: 0～100の数値
    # 補足: 100を指定するとオンデマンド価格と同額まで入札
    bid_price_as_percentage_of_on_demand_price = 100

    #-------
    # EBSストレージ設定
    #-------

    ebs_config {
      # 設定内容: EBSボリュームのサイズ（GB）
      # 設定可能な値: ボリュームタイプに応じた有効なサイズ
      size = 100

      # 設定内容: EBSボリュームタイプ
      # 設定可能な値: gp2, gp3, io1, io2, st1, sc1, standard
      # 補足:
      # - gp2/gp3: 汎用SSD（コストバランス重視）
      # - io1/io2: プロビジョンドIOPS SSD（高性能）
      # - st1: スループット最適化HDD（ビッグデータ向け）
      # - sc1: コールドHDD（アクセス頻度低）
      type = "gp2"

      # 設定内容: インスタンスあたりのEBSボリューム数
      # 設定可能な値: 1以上の整数
      # 省略時: 1
      volumes_per_instance = 1

      # 設定内容: プロビジョンドIOPS
      # 設定可能な値: ボリュームタイプに応じた有効なIOPS値
      # 補足: io1/io2/gp3タイプでのみ使用可能
      # iops = 3000
    }

    #-------
    # インスタンス設定のカスタマイズ
    #-------

    configurations {
      # 設定内容: 設定の分類
      # 設定可能な値: EMRアプリケーション設定の分類名
      # 例: "hadoop-env", "spark-env", "hive-site"
      classification = "hadoop-env"

      # 設定内容: 設定プロパティのキー・バリューペア
      # 設定可能な値: 分類に応じた設定プロパティのマップ
      properties = {
        "JAVA_HOME" = "/usr/lib/jvm/java-1.8.0"
      }
    }
  }

  # 2つ目のインスタンスタイプ設定例
  instance_type_configs {
    instance_type                                  = "m4.2xlarge"
    weighted_capacity                              = 2
    bid_price_as_percentage_of_on_demand_price     = 100

    ebs_config {
      size                 = 100
      type                 = "gp2"
      volumes_per_instance = 1
    }
  }

  #-------
  # 起動仕様
  #-------

  launch_specifications {
    # オンデマンドインスタンスの起動仕様
    # on_demand_specification {
    #   # 設定内容: オンデマンドインスタンスの割り当て戦略
    #   # 設定可能な値: "lowest-price"
    #   # 補足: 最も安価なインスタンスタイプから優先的にプロビジョニング
    #   allocation_strategy = "lowest-price"
    # }

    # スポットインスタンスの起動仕様
    spot_specification {
      # 設定内容: スポットインスタンスの割り当て戦略
      # 設定可能な値:
      # - "capacity-optimized": 容量が最も利用可能なプールから起動（推奨）
      # - "price-capacity-optimized": 価格と容量のバランスを最適化（推奨）
      # - "lowest-price": 最も安価なプールから起動
      # - "diversified": 複数のプールに分散して起動
      allocation_strategy = "capacity-optimized"

      # 設定内容: スポットインスタンスのブロック期間（分）
      # 設定可能な値: 0, 60, 120, 180, 240, 300, 360
      # 補足:
      # - 0を指定するとブロック期間なし
      # - ブロック期間中は中断されません
      # - この機能は非推奨で、新しいワークロードでは使用を避けてください
      block_duration_minutes = 0

      # 設定内容: スポットインスタンスのプロビジョニングタイムアウト時のアクション
      # 設定可能な値:
      # - "TERMINATE_CLUSTER": クラスタを終了
      # - "SWITCH_TO_ON_DEMAND": オンデマンドインスタンスに切り替え
      timeout_action = "TERMINATE_CLUSTER"

      # 設定内容: スポットプロビジョニングのタイムアウト期間（分）
      # 設定可能な値: 正の整数
      # 補足: この期間内にスポット容量を満たせない場合、timeout_actionが実行されます
      timeout_duration_minutes = 10
    }
  }
}

#-------
# Attributes Reference（参照可能な属性）
#-------
# このリソースから参照可能な属性:
#
# - id: Instance Fleetの一意の識別子
#
# - provisioned_on_demand_capacity: プロビジョニングされたオンデマンド容量
#   目標容量を満たすために実際にプロビジョニングされたユニット数
#   target_on_demand_capacityより多い/少ない場合があります
#
# - provisioned_spot_capacity: プロビジョニングされたスポット容量
#   目標容量を満たすために実際にプロビジョニングされたユニット数
#   target_spot_capacityより多い/少ない場合があります
#
# 参照例:
# - aws_emr_instance_fleet.example.id
# - aws_emr_instance_fleet.example.provisioned_on_demand_capacity
# - aws_emr_instance_fleet.example.provisioned_spot_capacity
#-------
