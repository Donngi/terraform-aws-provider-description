#---------------------------------------
# AWS EC2 Fleet
#---------------------------------------
# Provider Version: 6.28.0
# Generated: 2026-02-14
# Terraform Registry: https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/ec2_fleet
#
# NOTE:
# EC2フリートは、複数のインスタンスタイプ、アベイラビリティーゾーン、オンデマンド・スポット購入モデルを組み合わせて
# 単一のAPIコールで大量のEC2インスタンスを起動・管理するためのリソースです。
# フリートは、指定されたターゲットキャパシティを満たすために最適なインスタンスの組み合わせを自動的に選択します。
#
# 主な用途:
# - 大規模なバッチ処理ワークロードの実行
# - コスト最適化されたスポットインスタンスの活用
# - 複数のインスタンスタイプにまたがる柔軟なキャパシティ管理
# - オンデマンドとスポットの混合配置によるコスト削減と可用性のバランス調整
#
# 参考: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-fleet.html

#---------------------------------------
# リソース定義
#---------------------------------------

resource "aws_ec2_fleet" "example" {
  #---------------------------------------
  # フリートタイプとライフサイクル
  #---------------------------------------

  # 設定内容: フリートのタイプ
  # 設定可能な値:
  #   - request: リクエストタイプ（キャパシティ到達後に終了）
  #   - maintain: メンテナンスタイプ（キャパシティを継続的に維持）
  #   - instant: インスタントタイプ（同期的に起動し、フリート自体は即座に削除）
  # 省略時: maintain
  type = "maintain"

  # 設定内容: フリートの状態
  # 設定可能な値:
  #   - active: アクティブ（インスタンス起動を継続）
  #   - deleted: 削除済み
  #   - deleted_running: 削除済みだがインスタンスは実行中
  #   - deleted_terminating: 削除済みでインスタンス終了中
  #   - failed: 失敗
  #   - modifying: 変更中
  #   - submitted: 送信済み
  # 省略時: AWSが自動設定（computed属性）
  fleet_state = "active"

  #---------------------------------------
  # キャパシティ情報（読み取り専用）
  #---------------------------------------

  # 設定内容: 達成された総キャパシティ（computed属性）
  # 設定可能な値: 数値（AWS側で自動計算）
  # 省略時: AWS側で計算
  fulfilled_capacity = 2

  # 設定内容: 達成されたオンデマンドキャパシティ（computed属性）
  # 設定可能な値: 数値（AWS側で自動計算）
  # 省略時: AWS側で計算
  fulfilled_on_demand_capacity = 0

  #---------------------------------------
  # インスタンス管理
  #---------------------------------------

  # 設定内容: フリート削除時にインスタンスも終了するかどうか
  # 設定可能な値: true（終了する）、false（終了しない）
  # 省略時: false
  terminate_instances = false

  # 設定内容: フリートの有効期限到達時にインスタンスを終了するかどうか
  # 設定可能な値: true（終了する）、false（終了しない）
  # 省略時: false
  terminate_instances_with_expiration = false

  # 設定内容: 異常なインスタンスを自動的に置き換えるかどうか
  # 設定可能な値: true（置き換える）、false（置き換えない）
  # 省略時: false
  replace_unhealthy_instances = false

  # 設定内容: 余剰キャパシティの終了ポリシー
  # 設定可能な値:
  #   - termination: 余剰インスタンスを終了
  #   - no-termination: 余剰インスタンスを終了しない
  # 省略時: termination
  excess_capacity_termination_policy = "termination"

  #---------------------------------------
  # フリート有効期間
  #---------------------------------------

  # 設定内容: フリートの有効開始日時（RFC3339形式）
  # 設定可能な値: UTC形式のタイムスタンプ（例: 2024-01-01T00:00:00Z）
  # 省略時: フリート作成時から有効
  valid_from = "2024-01-01T00:00:00Z"

  # 設定内容: フリートの有効終了日時（RFC3339形式）
  # 設定可能な値: UTC形式のタイムスタンプ（例: 2024-12-31T23:59:59Z）
  # 省略時: 無期限
  valid_until = "2024-12-31T23:59:59Z"

  #---------------------------------------
  # その他の設定
  #---------------------------------------

  # 設定内容: フリートに関連付けるコンテキスト情報（任意の文字列）
  # 設定可能な値: 任意の文字列（最大255文字）
  # 省略時: なし
  context = "batch-processing-fleet"

  # 設定内容: フリートが起動するAWSリージョン
  # 設定可能な値: AWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定のリージョン
  region = "ap-northeast-1"

  #---------------------------------------
  # 起動テンプレート設定（必須）
  #---------------------------------------

  launch_template_config {
    launch_template_specification {
      # 設定内容: 起動テンプレートのバージョン（必須）
      # 設定可能な値: バージョン番号、$Latest、$Default
      version = "$Latest"

      # 設定内容: 起動テンプレートID
      # 設定可能な値: 起動テンプレートのID（launch_template_nameと排他）
      # 省略時: launch_template_nameを使用
      # launch_template_id = "lt-0123456789abcdef0"

      # 設定内容: 起動テンプレート名
      # 設定可能な値: 起動テンプレートの名前（launch_template_idと排他）
      # 省略時: launch_template_idを使用
      launch_template_name = "example-template"
    }

    # 設定内容: 起動テンプレートのオーバーライド設定（最大300個）
    # override {
    #   # 設定内容: インスタンスタイプ
    #   # 設定可能な値: EC2インスタンスタイプ（例: t3.micro, c5.large）
    #   # 省略時: 起動テンプレートの設定を使用
    #   instance_type = "t3.micro"
    #
    #   # 設定内容: アベイラビリティーゾーン
    #   # 設定可能な値: AZ名（例: ap-northeast-1a）
    #   # 省略時: 制限なし
    #   # availability_zone = "ap-northeast-1a"
    #
    #   # 設定内容: サブネットID
    #   # 設定可能な値: サブネットのID
    #   # 省略時: 起動テンプレートの設定を使用
    #   # subnet_id = "subnet-0123456789abcdef0"
    #
    #   # 設定内容: スポットインスタンスの最大価格（USD/時間）
    #   # 設定可能な値: 価格（文字列）、on-demand（オンデマンド価格まで）
    #   # 省略時: オンデマンド価格
    #   # max_price = "0.05"
    #
    #   # 設定内容: インスタンスの重み付けキャパシティ
    #   # 設定可能な値: 正の数値
    #   # 省略時: 1
    #   # weighted_capacity = 2
    #
    #   # 設定内容: このオーバーライドの優先度（数値が小さいほど高優先度）
    #   # 設定可能な値: 正の数値
    #   # 省略時: 優先度なし
    #   # priority = 1
    #
    #   # 設定内容: インスタンス要件による属性ベースの選択
    #   # instance_requirements {
    #   #   # 設定内容: 最小メモリ容量（MiB、必須）
    #   #   memory_mib {
    #   #     min = 4096
    #   #     # 設定可能な値: 最大メモリ容量（MiB）
    #   #     # max = 8192
    #   #   }
    #   #
    #   #   # 設定内容: 最小vCPU数（必須）
    #   #   vcpu_count {
    #   #     min = 2
    #   #     # 設定可能な値: 最大vCPU数
    #   #     # max = 4
    #   #   }
    #   #
    #   #   # 設定内容: 許可するインスタンスタイプのリスト
    #   #   # 設定可能な値: インスタンスタイプパターン（例: ["t3.*", "c5.*"]）
    #   #   # allowed_instance_types = ["t3.*"]
    #   #
    #   #   # 設定内容: 除外するインスタンスタイプのリスト
    #   #   # 設定可能な値: インスタンスタイプパターン
    #   #   # excluded_instance_types = ["t3.nano"]
    #   #
    #   #   # 設定内容: CPUメーカーのフィルタ
    #   #   # 設定可能な値: amazon-web-services, amd, intel
    #   #   # cpu_manufacturers = ["intel", "amd"]
    #   #
    #   #   # 設定内容: インスタンス世代のフィルタ
    #   #   # 設定可能な値: current（最新世代）、previous（旧世代）
    #   #   # instance_generations = ["current"]
    #   #
    #   #   # 設定内容: バーストパフォーマンス対応
    #   #   # 設定可能な値: included（含む）、excluded（除外）、required（必須）
    #   #   # burstable_performance = "included"
    #   #
    #   #   # 設定内容: ベアメタルインスタンス
    #   #   # 設定可能な値: included、excluded、required
    #   #   # bare_metal = "excluded"
    #   #
    #   #   # 設定内容: ローカルストレージの要件
    #   #   # 設定可能な値: included、excluded、required
    #   #   # local_storage = "included"
    #   #
    #   #   # 設定内容: ローカルストレージのタイプ
    #   #   # 設定可能な値: hdd、ssd
    #   #   # local_storage_types = ["ssd"]
    #   #
    #   #   # 設定内容: ハイバネーションサポートの要否
    #   #   # 設定可能な値: true、false
    #   #   # require_hibernate_support = false
    #   #
    #   #   # 設定内容: オンデマンド価格に対する最大価格の超過率（%）
    #   #   # 設定可能な値: 正の整数
    #   #   # on_demand_max_price_percentage_over_lowest_price = 20
    #   #
    #   #   # 設定内容: スポット価格に対する最大価格の超過率（%）
    #   #   # 設定可能な値: 正の整数
    #   #   # spot_max_price_percentage_over_lowest_price = 100
    #   #
    #   #   # 設定内容: 最適なオンデマンド価格に対するスポット最大価格の比率（%）
    #   #   # 設定可能な値: 正の整数
    #   #   # max_spot_price_as_percentage_of_optimal_on_demand_price = 100
    #   #
    #   #   # 設定内容: アクセラレーターのメーカー
    #   #   # 設定可能な値: nvidia, amd, amazon-web-services, xilinx
    #   #   # accelerator_manufacturers = ["nvidia"]
    #   #
    #   #   # 設定内容: アクセラレーターの名前
    #   #   # 設定可能な値: a100, v100, k80, t4, m60, radeon-pro-v520, vu9p等
    #   #   # accelerator_names = ["a100"]
    #   #
    #   #   # 設定内容: アクセラレーターのタイプ
    #   #   # 設定可能な値: gpu、fpga、inference
    #   #   # accelerator_types = ["gpu"]
    #   #
    #   #   # 設定内容: アクセラレーター数の範囲
    #   #   # accelerator_count {
    #   #   #   min = 1
    #   #   #   max = 4
    #   #   # }
    #   #
    #   #   # 設定内容: アクセラレーター総メモリ（MiB）の範囲
    #   #   # accelerator_total_memory_mib {
    #   #   #   min = 8192
    #   #   #   max = 16384
    #   #   # }
    #   #
    #   #   # 設定内容: vCPUあたりのメモリ（GiB）の範囲
    #   #   # memory_gib_per_vcpu {
    #   #   #   min = 2
    #   #   #   max = 8
    #   #   # }
    #   #
    #   #   # 設定内容: ベースラインEBS帯域幅（Mbps）の範囲
    #   #   # baseline_ebs_bandwidth_mbps {
    #   #   #   min = 1000
    #   #   #   max = 5000
    #   #   # }
    #   #
    #   #   # 設定内容: ネットワーク帯域幅（Gbps）の範囲
    #   #   # network_bandwidth_gbps {
    #   #   #   min = 10
    #   #   #   max = 100
    #   #   # }
    #   #
    #   #   # 設定内容: ネットワークインターフェース数の範囲
    #   #   # network_interface_count {
    #   #   #   min = 1
    #   #   #   max = 8
    #   #   # }
    #   #
    #   #   # 設定内容: ローカルストレージ総容量（GB）の範囲
    #   #   # total_local_storage_gb {
    #   #   #   min = 100
    #   #   #   max = 1000
    #   #   # }
    #   # }
    # }
  }

  #---------------------------------------
  # ターゲットキャパシティ設定（必須）
  #---------------------------------------

  target_capacity_specification {
    # 設定内容: 総ターゲットキャパシティ（必須）
    # 設定可能な値: 正の整数（ユニットはtarget_capacity_unit_typeで指定）
    total_target_capacity = 2

    # 設定内容: デフォルトのターゲットキャパシティタイプ（必須）
    # 設定可能な値:
    #   - spot: スポットインスタンス
    #   - on-demand: オンデマンドインスタンス
    #   - capacity-block: キャパシティブロック
    default_target_capacity_type = "spot"

    # 設定内容: オンデマンドターゲットキャパシティ
    # 設定可能な値: 0以上の整数
    # 省略時: 0
    # on_demand_target_capacity = 1

    # 設定内容: スポットターゲットキャパシティ
    # 設定可能な値: 0以上の整数
    # 省略時: total_target_capacity - on_demand_target_capacity
    # spot_target_capacity = 1

    # 設定内容: ターゲットキャパシティの単位タイプ
    # 設定可能な値:
    #   - units: ユニット数（デフォルト、インスタンス数またはweighted_capacity）
    #   - vcpu: vCPU数
    #   - memory-mib: メモリ容量（MiB）
    # 省略時: units
    target_capacity_unit_type = "units"
  }

  #---------------------------------------
  # オンデマンドオプション
  #---------------------------------------

  # on_demand_options {
  #   # 設定内容: オンデマンドインスタンスの割り当て戦略
  #   # 設定可能な値:
  #   #   - lowest-price: 最低価格のインスタンスタイプから起動
  #   #   - prioritized: launch_template_configのoverride.priorityに基づいて起動
  #   # 省略時: lowest-price
  #   allocation_strategy = "lowest-price"
  #
  #   # 設定内容: 単一のアベイラビリティーゾーンのみでインスタンスを起動するか
  #   # 設定可能な値: true、false
  #   # 省略時: false
  #   # single_availability_zone = false
  #
  #   # 設定内容: 単一のインスタンスタイプのみで起動するか
  #   # 設定可能な値: true、false
  #   # 省略時: false
  #   # single_instance_type = false
  #
  #   # 設定内容: フリート全体の最大合計価格（USD/時間）
  #   # 設定可能な値: 価格（文字列）
  #   # 省略時: 制限なし
  #   # max_total_price = "1.00"
  #
  #   # 設定内容: フリート起動に必要な最小ターゲットキャパシティ
  #   # 設定可能な値: 0以上の整数
  #   # 省略時: 0
  #   # min_target_capacity = 1
  #
  #   # 設定内容: キャパシティ予約の利用戦略
  #   # capacity_reservation_options {
  #   #   # 設定内容: キャパシティ予約の使用戦略
  #   #   # 設定可能な値: use-capacity-reservations-first
  #   #   # 省略時: 設定なし
  #   #   usage_strategy = "use-capacity-reservations-first"
  #   # }
  # }

  #---------------------------------------
  # スポットオプション
  #---------------------------------------

  # spot_options {
  #   # 設定内容: スポットインスタンスの割り当て戦略
  #   # 設定可能な値:
  #   #   - lowest-price: 最低価格のスポットプールから起動
  #   #   - diversified: すべてのスポットプールに分散して起動
  #   #   - capacity-optimized: キャパシティが最も最適なプールから起動
  #   #   - capacity-optimized-prioritized: キャパシティ最適化+優先度順
  #   #   - price-capacity-optimized: 価格とキャパシティの両方を考慮
  #   # 省略時: lowest-price
  #   allocation_strategy = "price-capacity-optimized"
  #
  #   # 設定内容: スポットインスタンス中断時の動作
  #   # 設定可能な値:
  #   #   - terminate: 終了
  #   #   - stop: 停止
  #   #   - hibernate: ハイバネート
  #   # 省略時: terminate
  #   instance_interruption_behavior = "terminate"
  #
  #   # 設定内容: 使用するインスタンスプール数（lowest-price戦略時のみ）
  #   # 設定可能な値: 1以上の整数
  #   # 省略時: 1
  #   # instance_pools_to_use_count = 2
  #
  #   # 設定内容: 単一のアベイラビリティーゾーンのみでインスタンスを起動するか
  #   # 設定可能な値: true、false
  #   # 省略時: false
  #   # single_availability_zone = false
  #
  #   # 設定内容: 単一のインスタンスタイプのみで起動するか
  #   # 設定可能な値: true、false
  #   # 省略時: false
  #   # single_instance_type = false
  #
  #   # 設定内容: フリート全体の最大合計価格（USD/時間）
  #   # 設定可能な値: 価格（文字列）
  #   # 省略時: 制限なし
  #   # max_total_price = "0.50"
  #
  #   # 設定内容: フリート起動に必要な最小ターゲットキャパシティ
  #   # 設定可能な値: 0以上の整数
  #   # 省略時: 0
  #   # min_target_capacity = 1
  #
  #   # 設定内容: メンテナンス戦略（キャパシティリバランス）
  #   # maintenance_strategies {
  #   #   capacity_rebalance {
  #   #     # 設定内容: 置き換え戦略
  #   #     # 設定可能な値:
  #   #     #   - launch: 新しいインスタンスを起動してから古いものを終了
  #   #     #   - launch-before-terminate: 起動完了を待ってから終了
  #   #     # 省略時: launch
  #   #     replacement_strategy = "launch"
  #   #
  #   #     # 設定内容: 終了遅延（秒）- インスタンス置き換え後に古いインスタンスを維持する時間
  #   #     # 設定可能な値: 0以上の整数
  #   #     # 省略時: 0
  #   #     # termination_delay = 120
  #   #   }
  #   # }
  # }

  #---------------------------------------
  # フリートインスタンスセット（読み取り専用）
  #---------------------------------------

  # 設定内容: フリート内のインスタンス情報（computed属性）
  # fleet_instance_set {
  #   # 設定内容: インスタンスIDのリスト（computed）
  #   # instance_ids = []
  #
  #   # 設定内容: インスタンスタイプ（computed）
  #   # instance_type = ""
  #
  #   # 設定内容: ライフサイクル（computed）
  #   # 設定可能な値: spot、on-demand、capacity-block
  #   # lifecycle = ""
  #
  #   # 設定内容: プラットフォーム（computed）
  #   # 設定可能な値: Linux/UNIX、Windows等
  #   # platform = ""
  # }

  #---------------------------------------
  # タイムアウト設定
  #---------------------------------------

  # timeouts {
  #   # 設定内容: フリート作成のタイムアウト（例: 10m）
  #   # 設定可能な値: 時間文字列（例: 30m、1h）
  #   # 省略時: デフォルトタイムアウト
  #   # create = "10m"
  #
  #   # 設定内容: フリート更新のタイムアウト（例: 10m）
  #   # 設定可能な値: 時間文字列（例: 30m、1h）
  #   # 省略時: デフォルトタイムアウト
  #   # update = "10m"
  #
  #   # 設定内容: フリート削除のタイムアウト（例: 10m）
  #   # 設定可能な値: 時間文字列（例: 30m、1h）
  #   # 省略時: デフォルトタイムアウト
  #   # delete = "10m"
  # }

  #---------------------------------------
  # タグ
  #---------------------------------------

  # 設定内容: フリートに付与するタグ
  # 設定可能な値: キー・バリューのマップ
  # 省略時: なし
  tags = {
    Name        = "example-fleet"
    Environment = "production"
  }
}

#---------------------------------------
# Attributes Reference
#---------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: フリートID
# - arn: フリートのARN
# - fleet_state: フリートの現在の状態
# - fulfilled_capacity: 達成された総キャパシティ
# - fulfilled_on_demand_capacity: 達成されたオンデマンドキャパシティ
# - tags_all: タグの完全なマップ（デフォルトタグを含む）
# - fleet_instance_set: フリート内のインスタンス情報
#   - instance_ids: インスタンスIDのリスト
#   - instance_type: インスタンスタイプ
#   - lifecycle: ライフサイクル（spot/on-demand/capacity-block）
#   - platform: プラットフォーム（Linux/UNIX、Windows等）
#
# 参照例:
# - フリートID: aws_ec2_fleet.example.id
# - フリートARN: aws_ec2_fleet.example.arn
# - 達成されたキャパシティ: aws_ec2_fleet.example.fulfilled_capacity
