#-----------------------------------------------------------------------
# AWS EC2 起動テンプレート (aws_launch_template)
#-----------------------------------------------------------------------
#
# EC2インスタンスまたはAuto Scalingグループの起動設定をテンプレートとして管理するリソースです。
# インスタンスタイプ・AMI・ネットワーク設定などを事前定義し、再利用できます。
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
#
# NOTE:
#   - nameとname_prefixは同時に指定できません。どちらか一方を使用してください
#   - instance_typeとinstance_requirementsは同時に指定できません
#   - vpc_security_group_idsとnetwork_interfaces.security_groupsは競合します
#   - security_group_namesはVPC以外（EC2-Classic）向けです。VPC環境ではvpc_security_group_idsを使用してください
#   - default_versionとupdate_default_versionは同時に指定できません
#   - ebs.encryptedにtrueを指定しない場合、kms_key_idは設定できません
#-----------------------------------------------------------------------

resource "aws_launch_template" "example" {
  #-----------------------------------------------------------------------
  # 基本設定
  #-----------------------------------------------------------------------

  # 設定内容: 起動テンプレートの名前
  # 設定可能な値: 文字列（英数字・ハイフン・アンダースコア）
  # 省略時: Terraformが一意の名前を自動生成する。name_prefixと競合
  name = "example-launch-template"

  # 設定内容: 起動テンプレートの名前プレフィックス（名前の先頭に付加される文字列）
  # 設定可能な値: 文字列
  # 省略時: 使用されない。nameと競合
  name_prefix = null

  # 設定内容: 起動テンプレートの説明
  # 設定可能な値: 任意の文字列
  # 省略時: 説明なし
  description = "Example launch template"

  # 設定内容: デフォルトとして使用するテンプレートのバージョン番号
  # 設定可能な値: バージョン番号を表す整数
  # 省略時: 計算される。update_default_versionと競合
  default_version = null

  # 設定内容: 更新のたびにデフォルトバージョンを最新バージョンに更新するかどうか
  # 設定可能な値: true / false
  # 省略時: 計算される。default_versionと競合
  update_default_version = true

  #-----------------------------------------------------------------------
  # イメージ・インスタンス設定
  #-----------------------------------------------------------------------

  # 設定内容: 起動に使用するAMI ID（Systems Managerパラメータ参照も可）
  # 設定可能な値: AMI ID（例: ami-0abcdef1234567890）、resolve:ssm:パラメータパス
  # 省略時: AMIは指定されない（インスタンス起動時に指定が必要）
  image_id = "ami-0abcdef1234567890"

  # 設定内容: インスタンスタイプ
  # 設定可能な値: t3.micro / m5.large / c5.xlarge など各インスタンスファミリー
  # 省略時: インスタンスタイプは指定されない。instance_requirementsと競合
  instance_type = "t3.micro"

  # 設定内容: インスタンスのシャットダウン動作
  # 設定可能な値: "stop"（停止）/ "terminate"（終了）
  # 省略時: "stop"
  instance_initiated_shutdown_behavior = "stop"

  # 設定内容: EBSストレージの最適化を有効にするかどうか
  # 設定可能な値: true / false
  # 省略時: インスタンスタイプのデフォルト設定に従う
  ebs_optimized = true

  # 設定内容: インスタンスのカーネルID
  # 設定可能な値: カーネルID文字列（例: ak-xxxxxxxxx）
  # 省略時: AMIのデフォルトカーネルが使用される
  kernel_id = null

  # 設定内容: インスタンスのRAMディスクID
  # 設定可能な値: RAMディスクID文字列（例: ari-xxxxxxxxx）
  # 省略時: AMIのデフォルトRAMディスクが使用される
  ram_disk_id = null

  # 設定内容: インスタンスに使用するSSHキーペアの名前
  # 設定可能な値: 既存のEC2キーペア名
  # 省略時: キーペアは設定されない（SSH接続不可）
  key_name = null

  # 設定内容: インスタンス起動時に実行するBase64エンコード済みユーザーデータ
  # 設定可能な値: Base64エンコードされた文字列（filebase64()関数での読み込みを推奨）
  # 省略時: ユーザーデータは設定されない
  user_data = null

  #-----------------------------------------------------------------------
  # セキュリティ設定
  #-----------------------------------------------------------------------

  # 設定内容: インスタンスの停止保護を有効にするかどうか（APIによる停止を防止）
  # 設定可能な値: true / false
  # 省略時: 計算される（デフォルトはfalse）
  disable_api_stop = false

  # 設定内容: インスタンスの終了保護を有効にするかどうか（APIによる終了を防止）
  # 設定可能な値: true / false
  # 省略時: 計算される（デフォルトはfalse）
  disable_api_termination = false

  # 設定内容: 関連付けるVPCセキュリティグループIDのリスト
  # 設定可能な値: セキュリティグループIDのリスト（例: ["sg-xxxxxxxxxxxxxxxxx"]）
  # 省略時: セキュリティグループは指定されない。network_interfaces.security_groupsと競合
  vpc_security_group_ids = ["sg-xxxxxxxxxxxxxxxxx"]

  # 設定内容: EC2-Classic向けセキュリティグループ名のリスト（VPC非推奨）
  # 設定可能な値: セキュリティグループ名のリスト
  # 省略時: 使用されない（VPC環境ではvpc_security_group_idsを使用）
  security_group_names = null

  #-----------------------------------------------------------------------
  # リージョン設定
  #-----------------------------------------------------------------------

  # 設定内容: リソースを管理するAWSリージョン
  # 設定可能な値: AWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダーで設定されたリージョンが使用される
  region = null

  #-----------------------------------------------------------------------
  # ブロックデバイスマッピング設定
  #-----------------------------------------------------------------------

  # 設定内容: AMI以外のEBSボリュームまたはインスタンスストアの追加設定
  # 省略時: AMIのデフォルトブロックデバイスマッピングが使用される
  block_device_mappings {
    # 設定内容: マウントするデバイス名（必須）
    # 設定可能な値: "/dev/sda1", "/dev/xvda", "/dev/sdf" など
    device_name = "/dev/sdf"

    # 設定内容: AMIのブロックデバイスマッピングから除外するデバイスの指定
    # 設定可能な値: 任意の文字列（デバイスを抑制する場合に指定）
    # 省略時: 使用されない
    no_device = null

    # 設定内容: インスタンスストアのデバイス名（仮想デバイス名）
    # 設定可能な値: "ephemeral0" / "ephemeral1" など
    # 省略時: 使用されない（EBSボリュームを使用する場合はebsブロックを使用）
    virtual_name = null

    # 設定内容: EBSボリュームのプロパティ設定
    # 省略時: EBSボリュームは追加されない
    ebs {
      # 設定内容: インスタンス終了時にボリュームを削除するかどうか
      # 設定可能な値: true / false
      # 省略時: 計算される
      delete_on_termination = true

      # 設定内容: EBSボリュームを暗号化するかどうか
      # 設定可能な値: true / false
      # 省略時: 計算される（snapshot_idが指定されている場合はそちらの設定に従う）
      encrypted = true

      # 設定内容: プロビジョンドIOPSの数（io1/io2/gp3のみ指定可能）
      # 設定可能な値: io1=100〜64000, io2=100〜256000, gp3=3000〜16000
      # 省略時: ボリュームタイプのデフォルト値
      iops = null

      # 設定内容: 暗号化に使用するカスタマーマネージドKMSキーのID・ARN・エイリアス
      # 設定可能な値: KMSキーID / ARN / エイリアスARN（encrypted=trueの場合に有効）
      # 省略時: AWSマネージドキー（aws/ebs）が使用される
      kms_key_id = null

      # 設定内容: ボリュームの作成元となるスナップショットID
      # 設定可能な値: スナップショットID（例: snap-xxxxxxxxxxxxxxxxx）
      # 省略時: スナップショットは使用されない。encryptedと競合
      snapshot_id = null

      # 設定内容: gp3ボリュームのスループット（MiB/s）
      # 設定可能な値: 125〜1000（MiB/s）
      # 省略時: ボリュームタイプのデフォルト値（gp3は125 MiB/s）
      throughput = null

      # 設定内容: EBSボリュームの初期化レート（MiB/s）
      # 設定可能な値: 100〜300（MiB/s）
      # 省略時: 使用されない
      volume_initialization_rate = null

      # 設定内容: EBSボリュームのサイズ（GiB）
      # 設定可能な値: 1以上の整数（ボリュームタイプごとに上限あり）
      # 省略時: スナップショットのサイズ（スナップショット未指定時はボリュームタイプのデフォルト）
      volume_size = 20

      # 設定内容: EBSボリュームのタイプ
      # 設定可能な値: "standard" / "gp2" / "gp3" / "io1" / "io2" / "sc1" / "st1"
      # 省略時: 計算される（デフォルトは"gp2"）
      volume_type = "gp3"
    }
  }

  #-----------------------------------------------------------------------
  # キャパシティ予約設定
  #-----------------------------------------------------------------------

  # 設定内容: EC2キャパシティ予約のターゲット設定
  # 省略時: キャパシティ予約はデフォルト動作（open）
  capacity_reservation_specification {
    # 設定内容: キャパシティ予約の選択方法
    # 設定可能な値: "capacity-reservations-only" / "open" / "none"
    # 省略時: 計算される。capacity_reservation_targetを指定する場合は"capacity-reservations-only"か省略
    capacity_reservation_preference = "open"

    # 設定内容: 特定のキャパシティ予約ターゲット設定
    # 省略時: 自動的に利用可能な予約が選択される
    # capacity_reservation_target {
    #   # 設定内容: ターゲットのキャパシティ予約ID
    #   # 設定可能な値: キャパシティ予約ID（例: cr-xxxxxxxxxxxxxxxxx）
    #   # 省略時: 使用されない
    #   capacity_reservation_id = null
    #
    #   # 設定内容: ターゲットのキャパシティ予約リソースグループARN
    #   # 設定可能な値: リソースグループARN
    #   # 省略時: 使用されない
    #   capacity_reservation_resource_group_arn = null
    # }
  }

  #-----------------------------------------------------------------------
  # CPUオプション設定
  #-----------------------------------------------------------------------

  # 設定内容: インスタンスのCPUオプション設定
  # 省略時: インスタンスタイプのデフォルトCPU設定が使用される
  cpu_options {
    # 設定内容: AMD SEV-SNP（機密仮想マシン）の有効化設定
    # 設定可能な値: "enabled" / "disabled"
    # 省略時: 計算される（M6a / R6a / C6aインスタンスタイプのみ対応）
    amd_sev_snp = null

    # 設定内容: インスタンスのCPUコア数
    # 設定可能な値: インスタンスタイプが対応するコア数の範囲内の整数
    # 省略時: 計算される（threads_per_coreと同時指定が必要）
    core_count = 4

    # 設定内容: 1コアあたりのスレッド数（ハイパースレッディングの制御）
    # 設定可能な値: 1（無効化）/ 2（有効化）
    # 省略時: 計算される（core_countと同時指定が必要）
    threads_per_core = 2
  }

  #-----------------------------------------------------------------------
  # クレジット仕様設定
  #-----------------------------------------------------------------------

  # 設定内容: バースト対応インスタンス（T系）のCPUクレジット仕様
  # 省略時: インスタンスタイプのデフォルトクレジット仕様が使用される
  credit_specification {
    # 設定内容: CPUクレジット仕様
    # 設定可能な値: "standard"（残高がなくなるとバースト停止）/ "unlimited"（追加料金でバースト継続）
    # 省略時: T2はstandard、T3はunlimited
    cpu_credits = "standard"
  }

  #-----------------------------------------------------------------------
  # エンクレーブオプション設定
  #-----------------------------------------------------------------------

  # 設定内容: AWS Nitro Enclaves（機密コンピューティング環境）の有効化設定
  # 省略時: Nitro Enclavesは無効
  enclave_options {
    # 設定内容: Nitro Enclavesを有効にするかどうか
    # 設定可能な値: true / false
    # 省略時: 計算される
    enabled = false
  }

  #-----------------------------------------------------------------------
  # ハイバネーションオプション設定
  #-----------------------------------------------------------------------

  # 設定内容: インスタンスのハイバネーション（休止）設定
  # 省略時: ハイバネーションは設定されない
  hibernation_options {
    # 設定内容: ハイバネーションを有効にするかどうか
    # 設定可能な値: true / false
    # 省略時: 計算される
    configured = false
  }

  #-----------------------------------------------------------------------
  # IAMインスタンスプロファイル設定
  #-----------------------------------------------------------------------

  # 設定内容: インスタンスに関連付けるIAMインスタンスプロファイルの設定
  # 省略時: IAMインスタンスプロファイルは設定されない
  iam_instance_profile {
    # 設定内容: IAMインスタンスプロファイルのARN
    # 設定可能な値: インスタンスプロファイルARN（例: arn:aws:iam::123456789012:instance-profile/...）
    # 省略時: nameから解決される。nameと競合
    arn = null

    # 設定内容: IAMインスタンスプロファイルの名前
    # 設定可能な値: 既存のIAMインスタンスプロファイル名
    # 省略時: arnから解決される。arnと競合
    name = "example-instance-profile"
  }

  #-----------------------------------------------------------------------
  # インスタンスマーケットオプション設定
  #-----------------------------------------------------------------------

  # 設定内容: スポットインスタンスなどの購入オプション設定
  # 省略時: オンデマンドインスタンスとして起動される
  # instance_market_options {
  #   # 設定内容: マーケットタイプ
  #   # 設定可能な値: "spot"
  #   market_type = "spot"
  #
  #   # 設定内容: スポットインスタンスのオプション設定
  #   spot_options {
  #     # 設定内容: スポットリクエストのブロック期間（分単位）
  #     # 設定可能な値: 60の倍数（60〜360）
  #     # 省略時: 使用されない
  #     block_duration_minutes = null
  #
  #     # 設定内容: スポットインスタンス中断時の動作
  #     # 設定可能な値: "hibernate" / "stop" / "terminate"
  #     # 省略時: "terminate"
  #     instance_interruption_behavior = "terminate"
  #
  #     # 設定内容: スポットインスタンスの最大時間単位価格（USD）
  #     # 設定可能な値: 価格の文字列（例: "0.05"）
  #     # 省略時: オンデマンド価格が上限として使用される
  #     max_price = null
  #
  #     # 設定内容: スポットインスタンスリクエストタイプ
  #     # 設定可能な値: "one-time" / "persistent"
  #     spot_instance_type = "one-time"
  #
  #     # 設定内容: スポットリクエストの有効期限（UTC形式）
  #     # 設定可能な値: UTC形式の日時文字列（例: "2026-12-31T23:59:59Z"）
  #     # 省略時: 期限なし
  #     valid_until = null
  #   }
  # }

  #-----------------------------------------------------------------------
  # インスタンス要件設定（Flexible Instance Types）
  #-----------------------------------------------------------------------

  # 設定内容: 属性ベースのインスタンスタイプ選択設定（instance_typeと競合）
  # 省略時: instance_typeで指定されたインスタンスタイプが使用される
  # instance_requirements {
  #   # 設定内容: アクセラレータ（GPU / FPGA / AWS Inferentiaチップ）の数の範囲
  #   # accelerator_count {
  #   #   min = null
  #   #   max = null
  #   # }
  #
  #   # 設定内容: アクセラレータメーカーのリスト
  #   # 設定可能な値: "amazon-web-services" / "amd" / "nvidia" / "xilinx"
  #   # 省略時: すべてのメーカーが対象
  #   accelerator_manufacturers = []
  #
  #   # 設定内容: アクセラレータ名のリスト
  #   # 設定可能な値: "a100" / "v100" / "k80" / "t4" / "m60" / "radeon-pro-v520" / "vu9p"
  #   # 省略時: すべてのアクセラレータが対象
  #   accelerator_names = []
  #
  #   # 設定内容: アクセラレータの合計メモリ範囲（MiB）
  #   # accelerator_total_memory_mib {
  #   #   min = null
  #   #   max = null
  #   # }
  #
  #   # 設定内容: アクセラレータタイプのリスト
  #   # 設定可能な値: "fpga" / "gpu" / "inference"
  #   # 省略時: すべてのアクセラレータタイプが対象
  #   accelerator_types = []
  #
  #   # 設定内容: 対象とするインスタンスタイプのリスト（ワイルドカード使用可）
  #   # 設定可能な値: インスタンスタイプ文字列のリスト（最大400件、各30文字以内）
  #   # 省略時: すべてのインスタンスタイプが対象。excluded_instance_typesと競合
  #   allowed_instance_types = []
  #
  #   # 設定内容: ベアメタルインスタンスの扱い
  #   # 設定可能な値: "included" / "excluded" / "required"
  #   # 省略時: "excluded"
  #   bare_metal = "excluded"
  #
  #   # 設定内容: EBSベースライン帯域幅の範囲（Mbps）
  #   # baseline_ebs_bandwidth_mbps {
  #   #   min = null
  #   #   max = null
  #   # }
  #
  #   # 設定内容: バースタブルパフォーマンスインスタンスタイプの扱い
  #   # 設定可能な値: "included" / "excluded" / "required"
  #   # 省略時: "excluded"
  #   burstable_performance = "excluded"
  #
  #   # 設定内容: 除外するインスタンスタイプのリスト（ワイルドカード使用可）
  #   # 設定可能な値: インスタンスタイプ文字列のリスト（最大400件、各30文字以内）
  #   # 省略時: 除外なし。allowed_instance_typesと競合
  #   excluded_instance_types = []
  #
  #   # 設定内容: インスタンス世代のリスト
  #   # 設定可能な値: "current" / "previous"
  #   # 省略時: すべての世代が対象
  #   instance_generations = []
  #
  #   # 設定内容: ローカルストレージボリュームを持つインスタンスタイプの扱い
  #   # 設定可能な値: "included" / "excluded" / "required"
  #   # 省略時: "included"
  #   local_storage = "included"
  #
  #   # 設定内容: ローカルストレージタイプのリスト
  #   # 設定可能な値: "hdd" / "ssd"
  #   # 省略時: すべてのストレージタイプが対象
  #   local_storage_types = []
  #
  #   # 設定内容: 最適なオンデマンド価格に対するスポット価格の最大割合
  #   # 設定可能な値: 整数（パーセント。価格保護を無効にする場合は999999）
  #   # 省略時: 100。spot_max_price_percentage_over_lowest_priceと競合
  #   max_spot_price_as_percentage_of_optimal_on_demand_price = null
  #
  #   # 設定内容: vCPUあたりのメモリ範囲（GiB）
  #   # memory_gib_per_vcpu {
  #   #   min = null
  #   #   max = null
  #   # }
  #
  #   # 設定内容: メモリ範囲（MiB）（必須）
  #   memory_mib {
  #     # 設定内容: 最小メモリ量（MiB）（必須）
  #     min = 2048
  #     # 設定内容: 最大メモリ量（MiB）
  #     # 省略時: 上限なし
  #     max = null
  #   }
  #
  #   # 設定内容: ネットワーク帯域幅範囲（Gbps）
  #   # network_bandwidth_gbps {
  #   #   min = null
  #   #   max = null
  #   # }
  #
  #   # 設定内容: ネットワークインターフェース数の範囲
  #   # network_interface_count {
  #   #   min = null
  #   #   max = null
  #   # }
  #
  #   # 設定内容: 最安値M/C/Rインスタンスに対するオンデマンド価格の最大割合
  #   # 設定可能な値: 整数（パーセント。価格保護を無効にする場合は999999）
  #   # 省略時: 20
  #   on_demand_max_price_percentage_over_lowest_price = null
  #
  #   # 設定内容: オンデマンドハイバネーションのサポートを必須とするかどうか
  #   # 設定可能な値: true / false
  #   # 省略時: false
  #   require_hibernate_support = false
  #
  #   # 設定内容: 最安値インスタンスに対するスポット価格の最大割合
  #   # 設定可能な値: 整数（パーセント。価格保護を無効にする場合は999999）
  #   # 省略時: 100。max_spot_price_as_percentage_of_optimal_on_demand_priceと競合
  #   spot_max_price_percentage_over_lowest_price = null
  #
  #   # 設定内容: 合計ローカルストレージ範囲（GB）
  #   # total_local_storage_gb {
  #   #   min = null
  #   #   max = null
  #   # }
  #
  #   # 設定内容: vCPU数の範囲（必須）
  #   vcpu_count {
  #     # 設定内容: 最小vCPU数（必須）
  #     min = 2
  #     # 設定内容: 最大vCPU数
  #     # 省略時: 上限なし
  #     max = null
  #   }
  # }

  #-----------------------------------------------------------------------
  # ライセンス仕様設定
  #-----------------------------------------------------------------------

  # 設定内容: ライセンス設定の関連付け（複数指定可能）
  # 省略時: ライセンス設定は関連付けられない
  # license_specification {
  #   # 設定内容: ライセンス設定のARN（必須）
  #   # 設定可能な値: AWS License ManagerのライセンスARN
  #   license_configuration_arn = "arn:aws:license-manager:..."
  # }

  #-----------------------------------------------------------------------
  # メンテナンスオプション設定
  #-----------------------------------------------------------------------

  # 設定内容: インスタンスの自動リカバリ設定
  # 省略時: デフォルトの自動リカバリ設定が使用される
  maintenance_options {
    # 設定内容: インスタンスの自動リカバリ動作
    # 設定可能な値: "default"（インスタンスタイプのデフォルト）/ "disabled"（自動リカバリ無効）
    # 省略時: 計算される
    auto_recovery = "default"
  }

  #-----------------------------------------------------------------------
  # メタデータオプション設定
  #-----------------------------------------------------------------------

  # 設定内容: EC2インスタンスメタデータサービス（IMDS）の設定
  # 省略時: デフォルト設定が使用される
  metadata_options {
    # 設定内容: メタデータサービスへのHTTPエンドポイントの有効化
    # 設定可能な値: "enabled" / "disabled"
    # 省略時: "enabled"
    http_endpoint = "enabled"

    # 設定内容: IPv6エンドポイントを介したメタデータへのアクセス
    # 設定可能な値: "enabled" / "disabled"
    # 省略時: 計算される
    http_protocol_ipv6 = "disabled"

    # 設定内容: HTTPのPUTレスポンスホップ制限（コンテナからアクセスする場合は2以上を推奨）
    # 設定可能な値: 1〜64
    # 省略時: 計算される（デフォルトは1）
    http_put_response_hop_limit = 1

    # 設定内容: IMDSv2（セッション指向メタデータサービス）の要求設定
    # 設定可能な値: "optional"（IMDSv1とIMDSv2両方を許可）/ "required"（IMDSv2のみ許可）
    # 省略時: 計算される（セキュリティ強化のため"required"を推奨）
    http_tokens = "required"

    # 設定内容: インスタンスタグをメタデータから参照できるようにするかどうか
    # 設定可能な値: "enabled" / "disabled"
    # 省略時: 計算される
    instance_metadata_tags = "disabled"
  }

  #-----------------------------------------------------------------------
  # モニタリング設定
  #-----------------------------------------------------------------------

  # 設定内容: 詳細モニタリング（CloudWatch）の設定
  # 省略時: 基本モニタリングが使用される
  monitoring {
    # 設定内容: 詳細モニタリングを有効にするかどうか
    # 設定可能な値: true / false
    # 省略時: 計算される
    enabled = true
  }

  #-----------------------------------------------------------------------
  # ネットワークインターフェース設定
  #-----------------------------------------------------------------------

  # 設定内容: インスタンス起動時にアタッチするネットワークインターフェースの設定（複数指定可能）
  # 省略時: デフォルトのネットワーク設定が使用される
  # network_interfaces {
  #   # 設定内容: eth0にキャリアIPアドレスを関連付けるかどうか（Wavelength Zone向け）
  #   # 設定可能な値: true / false
  #   # 省略時: 計算される
  #   associate_carrier_ip_address = null
  #
  #   # 設定内容: ネットワークインターフェースにパブリックIPアドレスを関連付けるかどうか
  #   # 設定可能な値: true / false
  #   # 省略時: 計算される
  #   associate_public_ip_address = null
  #
  #   # 設定内容: インスタンス終了時にネットワークインターフェースを削除するかどうか
  #   # 設定可能な値: true / false
  #   # 省略時: 計算される
  #   delete_on_termination = null
  #
  #   # 設定内容: ネットワークインターフェースの説明
  #   # 設定可能な値: 任意の文字列
  #   # 省略時: 説明なし
  #   description = null
  #
  #   # 設定内容: ネットワークインターフェースのデバイスインデックス
  #   # 設定可能な値: 0以上の整数（0はプライマリ）
  #   # 省略時: 計算される
  #   device_index = null
  #
  #   # 設定内容: ネットワークインターフェースのタイプ（EFAの場合は"efa"）
  #   # 設定可能な値: "efa" / その他
  #   # 省略時: 計算される
  #   interface_type = null
  #
  #   # 設定内容: 自動割り当てするIPv4プレフィックス数
  #   # 設定可能な値: 0以上の整数
  #   # 省略時: 計算される。ipv4_prefixesと競合
  #   ipv4_prefix_count = null
  #
  #   # 設定内容: 割り当てるIPv4プレフィックスのリスト
  #   # 設定可能な値: IPv4 CIDRプレフィックスのリスト
  #   # 省略時: 使用されない。ipv4_prefix_countと競合
  #   ipv4_prefixes = []
  #
  #   # 設定内容: 割り当てる特定のIPv6アドレスのリスト
  #   # 設定可能な値: サブネットのIPv6 CIDRブロック内のアドレスのリスト
  #   # 省略時: 使用されない。ipv6_address_countと競合
  #   ipv6_addresses = []
  #
  #   # 設定内容: 割り当てるIPv6アドレスの数
  #   # 設定可能な値: 0以上の整数
  #   # 省略時: 計算される。ipv6_addressesと競合
  #   ipv6_address_count = null
  #
  #   # 設定内容: 自動割り当てするIPv6プレフィックス数
  #   # 設定可能な値: 0以上の整数
  #   # 省略時: 計算される。ipv6_prefixesと競合
  #   ipv6_prefix_count = null
  #
  #   # 設定内容: 割り当てるIPv6プレフィックスのリスト
  #   # 設定可能な値: IPv6 CIDRプレフィックスのリスト
  #   # 省略時: 使用されない。ipv6_prefix_countと競合
  #   ipv6_prefixes = []
  #
  #   # 設定内容: アタッチする既存のネットワークインターフェースのID
  #   # 設定可能な値: ネットワークインターフェースID（例: eni-xxxxxxxxxxxxxxxxx）
  #   # 省略時: 新しいネットワークインターフェースが作成される
  #   network_interface_id = null
  #
  #   # 設定内容: ネットワークカードのインデックス（複数NIC対応インスタンスタイプ向け）
  #   # 設定可能な値: 0以上の整数（プライマリは0）
  #   # 省略時: 0
  #   network_card_index = null
  #
  #   # 設定内容: 最初のIPv6 GUAをプライマリIPv6アドレスにするかどうか
  #   # 設定可能な値: true / false
  #   # 省略時: 計算される
  #   primary_ipv6 = null
  #
  #   # 設定内容: プライマリプライベートIPv4アドレス
  #   # 設定可能な値: サブネットのCIDR範囲内のIPv4アドレス
  #   # 省略時: 自動的に割り当てられる
  #   private_ip_address = null
  #
  #   # 設定内容: セカンダリプライベートIPv4アドレスの数
  #   # 設定可能な値: 0以上の整数
  #   # 省略時: 計算される。ipv4_addressesと競合
  #   ipv4_address_count = null
  #
  #   # 設定内容: 割り当てるプライベートIPv4アドレスのリスト
  #   # 設定可能な値: サブネットのCIDR範囲内のIPv4アドレスのリスト
  #   # 省略時: 使用されない。ipv4_address_countと競合
  #   ipv4_addresses = []
  #
  #   # 設定内容: 関連付けるセキュリティグループIDのリスト
  #   # 設定可能な値: セキュリティグループIDのリスト
  #   # 省略時: 使用されない
  #   security_groups = []
  #
  #   # 設定内容: 関連付けるVPCサブネットのID
  #   # 設定可能な値: サブネットID（例: subnet-xxxxxxxxxxxxxxxxx）
  #   # 省略時: 計算される
  #   subnet_id = null
  #
  #   # 設定内容: ENA Express（Elastic Network Adapter）の設定
  #   ena_srd_specification {
  #     # 設定内容: ENA Expressを有効にするかどうか（TCPパフォーマンス向上）
  #     # 設定可能な値: true / false
  #     # 省略時: 計算される
  #     ena_srd_enabled = null
  #
  #     # 設定内容: ENA Express UDPの最適化設定
  #     ena_srd_udp_specification {
  #       # 設定内容: UDP通信のENA Express最適化を有効にするかどうか
  #       # 設定可能な値: true / false（ena_srd_enabled=trueが前提）
  #       # 省略時: 計算される
  #       ena_srd_udp_enabled = null
  #     }
  #   }
  #
  #   # 設定内容: 接続追跡設定（TCPおよびUDPのアイドルタイムアウト）
  #   connection_tracking_specification {
  #     # 設定内容: 確立済みTCP接続のアイドルタイムアウト（秒）
  #     # 設定可能な値: 60〜432000
  #     # 省略時: 432000（5日間）
  #     tcp_established_timeout = null
  #
  #     # 設定内容: ストリーム分類済みUDPフローのアイドルタイムアウト（秒）
  #     # 設定可能な値: 60〜180
  #     # 省略時: 180
  #     udp_stream_timeout = null
  #
  #     # 設定内容: 単方向UDPフローのアイドルタイムアウト（秒）
  #     # 設定可能な値: 30〜60
  #     # 省略時: 30
  #     udp_timeout = null
  #   }
  # }

  #-----------------------------------------------------------------------
  # 配置設定
  #-----------------------------------------------------------------------

  # 設定内容: インスタンスの配置（アベイラビリティーゾーン・テナンシー等）の設定
  # 省略時: デフォルトの配置設定が使用される
  placement {
    # 設定内容: 専用ホストでのアフィニティ設定
    # 設定可能な値: "default" / "host"
    # 省略時: 計算される
    affinity = null

    # 設定内容: インスタンスを配置するアベイラビリティーゾーン
    # 設定可能な値: AZコード（例: ap-northeast-1a）
    # 省略時: 自動的に選択される
    availability_zone = null

    # 設定内容: 配置グループのID（group_nameと競合）
    # 設定可能な値: 配置グループID（例: pg-xxxxxxxxxxxxxxxxx）
    # 省略時: 使用されない
    group_id = null

    # 設定内容: 配置グループの名前（group_idと競合）
    # 設定可能な値: 既存の配置グループ名
    # 省略時: 使用されない
    group_name = null

    # 設定内容: 専用ホストのID（tenancy="host"の場合に使用）
    # 設定可能な値: 専用ホストID（例: h-xxxxxxxxxxxxxxxxx）
    # 省略時: 計算される
    host_id = null

    # 設定内容: ホストリソースグループのARN（tenancy="host"の場合に使用）
    # 設定可能な値: ホストリソースグループARN
    # 省略時: 計算される
    host_resource_group_arn = null

    # 設定内容: パーティション配置グループのパーティション番号
    # 設定可能な値: 1以上の整数（パーティション配置グループ使用時のみ有効）
    # 省略時: 計算される
    partition_number = null

    # 設定内容: 将来の使用のために予約されているフィールド
    # 設定可能な値: 文字列
    # 省略時: 使用されない
    spread_domain = null

    # 設定内容: インスタンスのテナンシー
    # 設定可能な値: "default"（共有ハードウェア）/ "dedicated"（専用ハードウェア）/ "host"（専用ホスト）
    # 省略時: "default"
    tenancy = "default"
  }

  #-----------------------------------------------------------------------
  # プライベートDNS名オプション設定
  #-----------------------------------------------------------------------

  # 設定内容: インスタンスのプライベートDNSホスト名のオプション設定
  # 省略時: サブネットのデフォルト設定が継承される
  private_dns_name_options {
    # 設定内容: インスタンスホスト名のDNS AAAAレコード（IPv6）を有効にするかどうか
    # 設定可能な値: true / false
    # 省略時: 計算される
    enable_resource_name_dns_aaaa_record = null

    # 設定内容: インスタンスホスト名のDNS Aレコード（IPv4）を有効にするかどうか
    # 設定可能な値: true / false
    # 省略時: 計算される
    enable_resource_name_dns_a_record = null

    # 設定内容: インスタンスホスト名のタイプ
    # 設定可能な値: "ip-name"（IPアドレスベース）/ "resource-name"（リソース名ベース）
    # 省略時: 計算される
    hostname_type = null
  }

  #-----------------------------------------------------------------------
  # タグ仕様設定
  #-----------------------------------------------------------------------

  # 設定内容: 起動時にリソースに適用するタグの設定（複数指定可能）
  # 省略時: タグは適用されない（注意: プロバイダーのdefault_tagsはASGで作成されたリソースには伝播しない）
  tag_specifications {
    # 設定内容: タグを適用するリソースタイプ
    # 設定可能な値: "instance" / "volume" / "network-interface" / "spot-instances-request" / "elastic-gpu" など
    # 省略時: 計算される
    resource_type = "instance"

    # 設定内容: 適用するタグのマップ
    # 設定可能な値: キーと値のペアのマップ
    # 省略時: タグは設定されない
    tags = {
      Name = "example-instance"
    }
  }

  tag_specifications {
    resource_type = "volume"

    tags = {
      Name = "example-volume"
    }
  }

  #-----------------------------------------------------------------------
  # タグ設定
  #-----------------------------------------------------------------------

  # 設定内容: 起動テンプレートリソース自体に割り当てるタグのマップ
  # 設定可能な値: キーと値のペアのマップ
  # 省略時: タグは設定されない
  tags = {
    Name        = "example-launch-template"
    Environment = "production"
    ManagedBy   = "terraform"
  }
}

#-----------------------------------------------------------------------
# Attributes Reference
#-----------------------------------------------------------------------
# このリソースが公開する属性の参照方法
#
# - arn: 起動テンプレートのARN
# - id: 起動テンプレートID（例: lt-xxxxxxxxxxxxxxxxx）
# - latest_version: 起動テンプレートの最新バージョン番号
# - default_version: デフォルトバージョン番号
# - name: 起動テンプレートの名前
# - name_prefix: 起動テンプレートの名前プレフィックス
# - tags_all: プロバイダーのdefault_tagsを含む全タグのマップ
#-----------------------------------------------------------------------
