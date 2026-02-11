#---------------------------------------------------------------
# Amazon EC2 Launch Template
#---------------------------------------------------------------
#
# EC2起動テンプレートを定義するリソースです。
# Auto ScalingグループやEC2インスタンス起動時の設定を標準化できます。
# バージョン管理機能により、設定変更の履歴管理とロールバックが可能です。
#
# AWS公式ドキュメント:
#   - 起動テンプレート: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-launch-templates.html
#   - 起動テンプレートの作成: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/create-launch-template.html
#   - Auto Scalingでの使用: https://docs.aws.amazon.com/autoscaling/ec2/userguide/launch-templates.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template
#
# Provider Version: 6.28.0
# Generated: 2026-02-04
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_launch_template" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Optional)
  # 設定内容: 起動テンプレートの名前を指定します。
  # 設定可能な値: 最大128文字の英数字、ハイフン、アンダースコア
  # 注意: name_prefixと競合します。どちらか一方のみ指定してください。
  # 省略時: AWS側で自動生成されます
  name = "example-launch-template"

  # name_prefix (Optional)
  # 設定内容: 起動テンプレート名のプレフィックスを指定します。
  # 設定可能な値: 文字列（TerraformがユニークなIDを付与）
  # 注意: nameと競合します。どちらか一方のみ指定してください。
  # 用途: 複数のテンプレートを体系的に管理する場合に便利
  name_prefix = null

  # description (Optional)
  # 設定内容: 起動テンプレートの説明を指定します。
  # 設定可能な値: 最大255文字の任意の文字列
  # 用途: テンプレートの目的や用途を記録
  description = "Example launch template for web servers"

  # default_version (Optional)
  # 設定内容: デフォルトバージョン番号を指定します。
  # 設定可能な値: 正の整数値（バージョン番号）
  # 省略時: 最新バージョンが自動的にデフォルトになります
  # 注意: update_default_versionと併用することで管理を自動化できます
  default_version = null

  # update_default_version (Optional)
  # 設定内容: テンプレート更新時にデフォルトバージョンを自動更新するかを指定します。
  # 設定可能な値: true / false
  # 省略時: false（自動更新されない）
  # 用途: 常に最新バージョンを使用したい場合に有効化
  update_default_version = null

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
  # インスタンス基本設定
  #-------------------------------------------------------------

  # image_id (Optional)
  # 設定内容: インスタンスに使用するAMI IDを指定します。
  # 設定可能な値: 有効なAMI ID（例: ami-0c55b159cbfafe1f0）
  # 注意: instance_requirementsを使用する場合は指定不要です
  image_id = "ami-0c55b159cbfafe1f0"

  # instance_type (Optional)
  # 設定内容: インスタンスタイプを指定します。
  # 設定可能な値: 有効なインスタンスタイプ（例: t3.micro, m5.large, c5.xlarge）
  # 注意: instance_requirementsを使用する場合は指定不要です
  # 参考: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/instance-types.html
  instance_type = "t3.micro"

  # kernel_id (Optional)
  # 設定内容: カーネルIDを指定します。
  # 設定可能な値: 有効なカーネルID
  # 用途: 特定のカーネルバージョンを使用する場合に指定
  kernel_id = null

  # ram_disk_id (Optional)
  # 設定内容: RAMディスクIDを指定します。
  # 設定可能な値: 有効なRAMディスクID
  # 用途: 特定のRAMディスクを使用する場合に指定
  ram_disk_id = null

  # key_name (Optional)
  # 設定内容: インスタンスに関連付けるキーペア名を指定します。
  # 設定可能な値: 既存のEC2キーペア名
  # 用途: SSH接続時の認証に使用
  key_name = "my-key-pair"

  #-------------------------------------------------------------
  # インスタンス動作設定
  #-------------------------------------------------------------

  # ebs_optimized (Optional)
  # 設定内容: EBS最適化インスタンスとして起動するかを指定します。
  # 設定可能な値: "true" / "false" （文字列型）
  # 注意: 一部のインスタンスタイプはデフォルトでEBS最適化されています
  # 参考: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/EBSOptimized.html
  ebs_optimized = null

  # disable_api_stop (Optional)
  # 設定内容: API経由でのインスタンス停止を無効化するかを指定します。
  # 設定可能な値: true / false
  # 用途: 重要なワークロードの誤停止を防止
  disable_api_stop = null

  # disable_api_termination (Optional)
  # 設定内容: API経由でのインスタンス終了を無効化するかを指定します。
  # 設定可能な値: true / false
  # 用途: 本番環境での誤削除を防止
  disable_api_termination = null

  # instance_initiated_shutdown_behavior (Optional)
  # 設定内容: インスタンス内部からシャットダウンした際の動作を指定します。
  # 設定可能な値:
  #   - "stop": インスタンスを停止
  #   - "terminate": インスタンスを終了
  # 省略時: "stop"
  instance_initiated_shutdown_behavior = null

  #-------------------------------------------------------------
  # ユーザーデータ
  #-------------------------------------------------------------

  # user_data (Optional)
  # 設定内容: インスタンス起動時に実行するユーザーデータスクリプトを指定します。
  # 設定可能な値: Base64エンコードされた文字列
  # 注意: Terraformのbase64encode関数を使用してエンコードしてください
  # 参考: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/user-data.html
  user_data = null
  # 例:
  # user_data = base64encode(<<-EOF
  #   #!/bin/bash
  #   yum update -y
  #   yum install -y httpd
  #   systemctl start httpd
  # EOF
  # )

  #-------------------------------------------------------------
  # ネットワーク・セキュリティ設定
  #-------------------------------------------------------------

  # vpc_security_group_ids (Optional)
  # 設定内容: インスタンスに関連付けるVPCセキュリティグループIDのリストを指定します。
  # 設定可能な値: セキュリティグループIDのセット
  # 注意: network_interfacesブロックでセキュリティグループを指定している場合は競合します
  vpc_security_group_ids = null
  # 例: vpc_security_group_ids = ["sg-12345678", "sg-87654321"]

  # security_group_names (Optional)
  # 設定内容: EC2-ClassicまたはデフォルトVPC用のセキュリティグループ名を指定します。
  # 設定可能な値: セキュリティグループ名のセット
  # 注意: VPC環境ではvpc_security_group_idsを使用してください
  security_group_names = null

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: 起動テンプレート自体に付与するタグを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 注意: tag_specificationsブロックは起動されるリソースに付与するタグです
  tags = {
    Name        = "example-launch-template"
    Environment = "production"
    ManagedBy   = "terraform"
  }

  # tags_all (Optional)
  # 設定内容: プロバイダーのdefault_tagsとマージされたすべてのタグ
  # 設定可能な値: キーと値のペアのマップ
  # 注意: 通常は自動的に管理されるため、明示的な指定は不要です
  tags_all = null

  #-------------------------------------------------------------
  # ブロックデバイスマッピング
  #-------------------------------------------------------------

  # block_device_mappings (Optional)
  # 設定内容: インスタンスのブロックデバイス設定を定義します。
  # 用途: ルートボリュームや追加EBSボリュームの設定
  block_device_mappings {
    # device_name (Optional)
    # 設定内容: デバイス名を指定します。
    # 設定可能な値: /dev/sda1, /dev/xvda, /dev/sdf など
    # 注意: OSやAMIによって使用可能なデバイス名が異なります
    device_name = "/dev/sda1"

    # no_device (Optional)
    # 設定内容: AMIのブロックデバイスマッピングを抑制する場合に指定します。
    # 設定可能な値: 空文字列 ""
    # 用途: AMIに含まれる不要なデバイスを無効化
    no_device = null

    # virtual_name (Optional)
    # 設定内容: インスタンスストアボリュームの仮想デバイス名を指定します。
    # 設定可能な値: ephemeral0, ephemeral1 など
    # 用途: インスタンスストアを使用する場合に指定
    virtual_name = null

    ebs {
      # delete_on_termination (Optional)
      # 設定内容: インスタンス終了時にボリュームを削除するかを指定します。
      # 設定可能な値: "true" / "false" （文字列型）
      # 省略時: "true"
      delete_on_termination = "true"

      # encrypted (Optional)
      # 設定内容: ボリュームを暗号化するかを指定します。
      # 設定可能な値: "true" / "false" （文字列型）
      # 注意: snapshot_idが暗号化されている場合は自動的にtrueになります
      encrypted = "true"

      # iops (Optional)
      # 設定内容: プロビジョンドIOPS（io1/io2/gp3）の値を指定します。
      # 設定可能な値: 正の整数値
      # 注意: volume_typeがio1/io2/gp3の場合のみ有効
      # 参考: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ebs-volume-types.html
      iops = null

      # kms_key_id (Optional)
      # 設定内容: 暗号化に使用するKMSキーのARNを指定します。
      # 設定可能な値: KMSキーのARN
      # 注意: encryptedがtrueの場合に使用可能
      kms_key_id = null

      # snapshot_id (Optional)
      # 設定内容: ボリュームの作成元となるスナップショットIDを指定します。
      # 設定可能な値: 有効なスナップショットID
      # 用途: 既存のスナップショットからボリュームを作成
      snapshot_id = null

      # throughput (Optional)
      # 設定内容: スループット（gp3のみ）をMiB/sで指定します。
      # 設定可能な値: 125〜1000 MiB/s
      # 注意: volume_typeがgp3の場合のみ有効
      throughput = null

      # volume_size (Optional)
      # 設定内容: ボリュームサイズをGiBで指定します。
      # 設定可能な値: 正の整数値
      # 注意: snapshot_idを指定した場合は自動的に計算されます
      volume_size = 20

      # volume_type (Optional)
      # 設定内容: ボリュームタイプを指定します。
      # 設定可能な値:
      #   - "gp2": 汎用SSD（従来世代）
      #   - "gp3": 汎用SSD（最新世代）
      #   - "io1": プロビジョンドIOPS SSD
      #   - "io2": プロビジョンドIOPS SSD（高耐久性）
      #   - "st1": スループット最適化HDD
      #   - "sc1": Cold HDD
      #   - "standard": マグネティック（非推奨）
      # 省略時: "gp2"
      # 参考: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ebs-volume-types.html
      volume_type = "gp3"

      # volume_initialization_rate (Optional)
      # 設定内容: ボリューム初期化レート（Fast Snapshot Restore使用時）
      # 設定可能な値: 正の整数値
      # 注意: 通常は自動計算されるため明示的な指定は不要
      volume_initialization_rate = null
    }
  }

  #-------------------------------------------------------------
  # Capacity Reservation設定
  #-------------------------------------------------------------

  # capacity_reservation_specification (Optional)
  # 設定内容: キャパシティ予約の設定を指定します。
  # 用途: オンデマンドキャパシティ予約の使用
  # 参考: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/capacity-reservations-using.html
  capacity_reservation_specification {
    # capacity_reservation_preference (Optional)
    # 設定内容: キャパシティ予約の使用優先度を指定します。
    # 設定可能な値:
    #   - "open": 一致するキャパシティ予約があれば使用
    #   - "none": キャパシティ予約を使用しない
    # 省略時: "open"
    capacity_reservation_preference = null

    capacity_reservation_target {
      # capacity_reservation_id (Optional)
      # 設定内容: 使用する特定のキャパシティ予約IDを指定します。
      # 設定可能な値: 有効なキャパシティ予約ID
      # 注意: capacity_reservation_resource_group_arnと競合します
      capacity_reservation_id = null

      # capacity_reservation_resource_group_arn (Optional)
      # 設定内容: キャパシティ予約リソースグループのARNを指定します。
      # 設定可能な値: リソースグループのARN
      # 注意: capacity_reservation_idと競合します
      capacity_reservation_resource_group_arn = null
    }
  }

  #-------------------------------------------------------------
  # CPU設定
  #-------------------------------------------------------------

  # cpu_options (Optional)
  # 設定内容: CPUオプションを指定します。
  # 用途: コア数やスレッド数のカスタマイズ
  # 参考: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/instance-optimize-cpu.html
  cpu_options {
    # core_count (Optional)
    # 設定内容: CPUコア数を指定します。
    # 設定可能な値: インスタンスタイプでサポートされるコア数
    # 用途: ライセンスコストの最適化
    core_count = null

    # threads_per_core (Optional)
    # 設定内容: コアあたりのスレッド数を指定します。
    # 設定可能な値:
    #   - 1: ハイパースレッディング無効
    #   - 2: ハイパースレッディング有効（デフォルト）
    # 用途: ハイパースレッディングの制御
    threads_per_core = null

    # amd_sev_snp (Optional)
    # 設定内容: AMD SEV-SNP（Secure Encrypted Virtualization）を有効化するかを指定します。
    # 設定可能な値: "enabled" / "disabled"
    # 注意: AMD EPYC プロセッサを使用するインスタンスタイプのみサポート
    # 用途: 機密コンピューティングワークロード
    amd_sev_snp = null
  }

  #-------------------------------------------------------------
  # クレジット仕様（バースタブルインスタンス用）
  #-------------------------------------------------------------

  # credit_specification (Optional)
  # 設定内容: T2/T3/T4gインスタンスのCPUクレジット設定を指定します。
  # 用途: バースタブルパフォーマンスインスタンスのクレジット動作を制御
  # 参考: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/burstable-credits-baseline-concepts.html
  credit_specification {
    # cpu_credits (Optional)
    # 設定内容: CPUクレジットのオプションを指定します。
    # 設定可能な値:
    #   - "standard": 標準モード（T2のみ。クレジット蓄積に制限あり）
    #   - "unlimited": 無制限モード（追加料金でベースライン以上のパフォーマンス）
    # 省略時: T2は"standard"、T3/T4gは"unlimited"
    cpu_credits = null
  }

  #-------------------------------------------------------------
  # Enclave設定
  #-------------------------------------------------------------

  # enclave_options (Optional)
  # 設定内容: AWS Nitro Enclavesの有効化を指定します。
  # 用途: 機密データ処理用の隔離されたコンピューティング環境を使用
  # 参考: https://docs.aws.amazon.com/enclaves/latest/user/nitro-enclave.html
  enclave_options {
    # enabled (Optional)
    # 設定内容: Nitro Enclavesを有効化するかを指定します。
    # 設定可能な値: true / false
    # 注意: サポートされているインスタンスタイプのみで使用可能
    enabled = null
  }

  #-------------------------------------------------------------
  # ハイバネーション設定
  #-------------------------------------------------------------

  # hibernation_options (Optional)
  # 設定内容: インスタンスのハイバネーション機能を設定します。
  # 用途: インスタンスの状態を保存して一時停止
  # 参考: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/Hibernate.html
  hibernation_options {
    # configured (Required)
    # 設定内容: ハイバネーションを有効化するかを指定します。
    # 設定可能な値: true / false
    # 注意: ハイバネーション対応のAMIとインスタンスタイプが必要
    configured = false
  }

  #-------------------------------------------------------------
  # IAMインスタンスプロファイル
  #-------------------------------------------------------------

  # iam_instance_profile (Optional)
  # 設定内容: インスタンスに関連付けるIAMインスタンスプロファイルを指定します。
  # 用途: インスタンスにAWS APIへのアクセス権限を付与
  iam_instance_profile {
    # name (Optional)
    # 設定内容: IAMインスタンスプロファイルの名前を指定します。
    # 設定可能な値: 既存のインスタンスプロファイル名
    # 注意: arnと競合します。どちらか一方のみ指定
    name = null

    # arn (Optional)
    # 設定内容: IAMインスタンスプロファイルのARNを指定します。
    # 設定可能な値: インスタンスプロファイルのARN
    # 注意: nameと競合します。どちらか一方のみ指定
    arn = null
  }

  #-------------------------------------------------------------
  # インスタンスマーケットオプション（スポットインスタンス）
  #-------------------------------------------------------------

  # instance_market_options (Optional)
  # 設定内容: インスタンスの市場オプションを指定します。
  # 用途: スポットインスタンスとしての起動設定
  # 参考: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-spot-instances.html
  instance_market_options {
    # market_type (Optional)
    # 設定内容: 市場タイプを指定します。
    # 設定可能な値: "spot" （現在はspotのみサポート）
    # 省略時: オンデマンドインスタンスとして起動
    market_type = null

    spot_options {
      # block_duration_minutes (Optional)
      # 設定内容: スポットインスタンスの予約時間を分単位で指定します。
      # 設定可能な値: 60, 120, 180, 240, 300, 360
      # 注意: 2021年以降、新規作成は非推奨です
      block_duration_minutes = null

      # instance_interruption_behavior (Optional)
      # 設定内容: スポットインスタンスが中断された際の動作を指定します。
      # 設定可能な値:
      #   - "terminate": インスタンスを終了（デフォルト）
      #   - "stop": インスタンスを停止
      #   - "hibernate": インスタンスをハイバネート
      # 注意: stopやhibernateは永続ルートボリュームが必要
      instance_interruption_behavior = null

      # max_price (Optional)
      # 設定内容: スポットインスタンスの最大入札価格を指定します。
      # 設定可能な値: 時間あたりの価格（USD）
      # 省略時: オンデマンド価格が上限
      # 推奨: 通常は省略して、オンデマンド価格を上限とすることを推奨
      max_price = null

      # spot_instance_type (Optional)
      # 設定内容: スポットリクエストのタイプを指定します。
      # 設定可能な値:
      #   - "one-time": 一度のみ実行（デフォルト）
      #   - "persistent": 中断後も再起動を試行
      # 省略時: "one-time"
      spot_instance_type = null

      # valid_until (Optional)
      # 設定内容: スポットリクエストの有効期限を指定します。
      # 設定可能な値: RFC3339形式のタイムスタンプ
      # 注意: spot_instance_typeが"persistent"の場合のみ有効
      # 例: "2024-12-31T23:59:59Z"
      valid_until = null
    }
  }

  #-------------------------------------------------------------
  # インスタンス要件（属性ベースのインスタンス選択）
  #-------------------------------------------------------------

  # instance_requirements (Optional)
  # 設定内容: Auto Scalingグループ用の属性ベースのインスタンスタイプ選択を設定します。
  # 注意: instance_typeと競合します。どちらか一方のみ指定
  # 用途: 複数のインスタンスタイプから最適なものを自動選択
  # 参考: https://docs.aws.amazon.com/autoscaling/ec2/userguide/create-asg-instance-type-requirements.html
  instance_requirements {
    # accelerator_manufacturers (Optional)
    # 設定内容: アクセラレータメーカーを指定します。
    # 設定可能な値: ["nvidia", "amd", "amazon-web-services", "xilinx"]
    accelerator_manufacturers = null

    # accelerator_names (Optional)
    # 設定内容: アクセラレータ名を指定します。
    # 設定可能な値: ["a100", "v100", "k80", "t4", "m60", "radeon-pro-v520", "vu9p"]
    accelerator_names = null

    # accelerator_types (Optional)
    # 設定内容: アクセラレータタイプを指定します。
    # 設定可能な値: ["gpu", "fpga", "inference"]
    accelerator_types = null

    # allowed_instance_types (Optional)
    # 設定内容: 許可するインスタンスタイプのパターンを指定します。
    # 設定可能な値: インスタンスタイプのリスト（ワイルドカード使用可）
    # 例: ["m5.*", "c5.*"] で m5とc5ファミリーのすべてのサイズを許可
    allowed_instance_types = null

    # bare_metal (Optional)
    # 設定内容: ベアメタルインスタンスを含めるかを指定します。
    # 設定可能な値:
    #   - "included": ベアメタルを含む
    #   - "excluded": ベアメタルを除外
    #   - "required": ベアメタルのみ
    bare_metal = null

    # burstable_performance (Optional)
    # 設定内容: バースタブルパフォーマンスインスタンス（T系）を含めるかを指定します。
    # 設定可能な値:
    #   - "included": バースタブルを含む
    #   - "excluded": バースタブルを除外
    #   - "required": バースタブルのみ
    burstable_performance = null

    # cpu_manufacturers (Optional)
    # 設定内容: CPUメーカーを指定します。
    # 設定可能な値: ["intel", "amd", "amazon-web-services"]
    cpu_manufacturers = null

    # excluded_instance_types (Optional)
    # 設定内容: 除外するインスタンスタイプのパターンを指定します。
    # 設定可能な値: インスタンスタイプのリスト（ワイルドカード使用可）
    # 例: ["t2.*", "t3.*"] でT2とT3を除外
    excluded_instance_types = null

    # instance_generations (Optional)
    # 設定内容: インスタンス世代を指定します。
    # 設定可能な値: ["current", "previous"]
    # 推奨: ["current"] で最新世代のみを使用
    instance_generations = null

    # local_storage (Optional)
    # 設定内容: ローカルストレージの要件を指定します。
    # 設定可能な値:
    #   - "included": ローカルストレージを含む
    #   - "excluded": ローカルストレージを除外
    #   - "required": ローカルストレージ必須
    local_storage = null

    # local_storage_types (Optional)
    # 設定内容: ローカルストレージのタイプを指定します。
    # 設定可能な値: ["hdd", "ssd"]
    local_storage_types = null

    # max_spot_price_as_percentage_of_optimal_on_demand_price (Optional)
    # 設定内容: スポット価格の上限を最適なオンデマンド価格の割合で指定します。
    # 設定可能な値: 正の整数（パーセンテージ）
    # 用途: スポットインスタンス使用時のコスト制御
    max_spot_price_as_percentage_of_optimal_on_demand_price = null

    # on_demand_max_price_percentage_over_lowest_price (Optional)
    # 設定内容: オンデマンド価格の上限を最低価格からの割合で指定します。
    # 設定可能な値: 正の整数（パーセンテージ）
    # 省略時: 20
    on_demand_max_price_percentage_over_lowest_price = null

    # require_hibernate_support (Optional)
    # 設定内容: ハイバネーション対応のインスタンスタイプのみを選択するかを指定します。
    # 設定可能な値: true / false
    require_hibernate_support = null

    # spot_max_price_percentage_over_lowest_price (Optional)
    # 設定内容: スポット価格の上限を最低価格からの割合で指定します。
    # 設定可能な値: 正の整数（パーセンテージ）
    # 省略時: 100
    spot_max_price_percentage_over_lowest_price = null

    # accelerator_count (Optional)
    # 設定内容: アクセラレータの数の範囲を指定します。
    accelerator_count {
      # min (Optional)
      # 設定内容: 最小アクセラレータ数
      # 設定可能な値: 正の整数
      min = null

      # max (Optional)
      # 設定内容: 最大アクセラレータ数
      # 設定可能な値: 正の整数
      max = null
    }

    # accelerator_total_memory_mib (Optional)
    # 設定内容: アクセラレータの総メモリ量の範囲をMiBで指定します。
    accelerator_total_memory_mib {
      # min (Optional)
      # 設定内容: 最小メモリ量（MiB）
      min = null

      # max (Optional)
      # 設定内容: 最大メモリ量（MiB）
      max = null
    }

    # baseline_ebs_bandwidth_mbps (Optional)
    # 設定内容: ベースラインEBS帯域幅の範囲をMbpsで指定します。
    baseline_ebs_bandwidth_mbps {
      # min (Optional)
      # 設定内容: 最小帯域幅（Mbps）
      min = null

      # max (Optional)
      # 設定内容: 最大帯域幅（Mbps）
      max = null
    }

    # memory_gib_per_vcpu (Optional)
    # 設定内容: vCPUあたりのメモリ量の範囲をGiBで指定します。
    memory_gib_per_vcpu {
      # min (Optional)
      # 設定内容: 最小メモリ量（GiB/vCPU）
      min = null

      # max (Optional)
      # 設定内容: 最大メモリ量（GiB/vCPU）
      max = null
    }

    # memory_mib (Required when using instance_requirements)
    # 設定内容: メモリ量の範囲をMiBで指定します。
    # 注意: instance_requirementsを使用する場合は必須
    memory_mib {
      # min (Required)
      # 設定内容: 最小メモリ量（MiB）
      # 例: 2048 (2GiB), 4096 (4GiB), 8192 (8GiB)
      min = 2048

      # max (Optional)
      # 設定内容: 最大メモリ量（MiB）
      max = null
    }

    # network_bandwidth_gbps (Optional)
    # 設定内容: ネットワーク帯域幅の範囲をGbpsで指定します。
    network_bandwidth_gbps {
      # min (Optional)
      # 設定内容: 最小帯域幅（Gbps）
      min = null

      # max (Optional)
      # 設定内容: 最大帯域幅（Gbps）
      max = null
    }

    # network_interface_count (Optional)
    # 設定内容: ネットワークインターフェース数の範囲を指定します。
    network_interface_count {
      # min (Optional)
      # 設定内容: 最小インターフェース数
      min = null

      # max (Optional)
      # 設定内容: 最大インターフェース数
      max = null
    }

    # total_local_storage_gb (Optional)
    # 設定内容: ローカルストレージの総容量の範囲をGBで指定します。
    total_local_storage_gb {
      # min (Optional)
      # 設定内容: 最小容量（GB）
      min = null

      # max (Optional)
      # 設定内容: 最大容量（GB）
      max = null
    }

    # vcpu_count (Required when using instance_requirements)
    # 設定内容: vCPU数の範囲を指定します。
    # 注意: instance_requirementsを使用する場合は必須
    vcpu_count {
      # min (Required)
      # 設定内容: 最小vCPU数
      # 例: 2, 4, 8
      min = 2

      # max (Optional)
      # 設定内容: 最大vCPU数
      max = null
    }
  }

  #-------------------------------------------------------------
  # ライセンス設定
  #-------------------------------------------------------------

  # license_specification (Optional)
  # 設定内容: AWS License Managerで管理されるライセンス設定を指定します。
  # 用途: BYOLライセンスの追跡と管理
  # 参考: https://docs.aws.amazon.com/license-manager/latest/userguide/license-configurations.html
  license_specification {
    # license_configuration_arn (Required)
    # 設定内容: ライセンス設定のARNを指定します。
    # 設定可能な値: License Managerで作成したライセンス設定のARN
    license_configuration_arn = "arn:aws:license-manager:us-east-1:123456789012:license-configuration:lic-1234567890abcdef"
  }

  #-------------------------------------------------------------
  # メンテナンスオプション
  #-------------------------------------------------------------

  # maintenance_options (Optional)
  # 設定内容: インスタンスのメンテナンスオプションを指定します。
  # 用途: 自動リカバリの制御
  maintenance_options {
    # auto_recovery (Optional)
    # 設定内容: 自動リカバリの設定を指定します。
    # 設定可能な値:
    #   - "default": デフォルト動作（自動リカバリ有効）
    #   - "disabled": 自動リカバリ無効
    # 省略時: "default"
    # 参考: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-instance-recover.html
    auto_recovery = null
  }

  #-------------------------------------------------------------
  # メタデータオプション
  #-------------------------------------------------------------

  # metadata_options (Optional)
  # 設定内容: インスタンスメタデータサービス(IMDS)の設定を指定します。
  # 用途: セキュリティ強化のためのIMDSv2の有効化
  # 参考: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/configuring-instance-metadata-service.html
  metadata_options {
    # http_endpoint (Optional)
    # 設定内容: HTTPメタデータエンドポイントの有効化を指定します。
    # 設定可能な値:
    #   - "enabled": 有効（デフォルト）
    #   - "disabled": 無効
    # 推奨: セキュリティ要件により無効化が必要な場合以外は有効を推奨
    http_endpoint = null

    # http_tokens (Optional)
    # 設定内容: メタデータ取得時のトークン使用を指定します。
    # 設定可能な値:
    #   - "optional": IMDSv1とv2の両方を許可（デフォルト）
    #   - "required": IMDSv2のみ許可（推奨）
    # 推奨: "required"を指定してセキュリティを強化
    http_tokens = "required"

    # http_put_response_hop_limit (Optional)
    # 設定内容: メタデータトークンのホップ制限を指定します。
    # 設定可能な値: 1〜64の整数
    # 省略時: 1
    # 注意: コンテナやプロキシ経由でメタデータにアクセスする場合は大きい値を設定
    http_put_response_hop_limit = null

    # http_protocol_ipv6 (Optional)
    # 設定内容: IPv6経由のメタデータアクセスを有効化するかを指定します。
    # 設定可能な値:
    #   - "enabled": 有効
    #   - "disabled": 無効（デフォルト）
    http_protocol_ipv6 = null

    # instance_metadata_tags (Optional)
    # 設定内容: インスタンスメタデータでインスタンスタグへのアクセスを有効化するかを指定します。
    # 設定可能な値:
    #   - "enabled": 有効
    #   - "disabled": 無効（デフォルト）
    # 用途: メタデータ経由でタグ情報を取得
    instance_metadata_tags = null
  }

  #-------------------------------------------------------------
  # モニタリング設定
  #-------------------------------------------------------------

  # monitoring (Optional)
  # 設定内容: 詳細モニタリング（CloudWatch）の設定を指定します。
  # 用途: 1分間隔のメトリクス収集を有効化
  # 参考: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-cloudwatch-new.html
  monitoring {
    # enabled (Optional)
    # 設定内容: 詳細モニタリングを有効化するかを指定します。
    # 設定可能な値: true / false
    # 省略時: false（5分間隔の基本モニタリング）
    # 注意: 詳細モニタリングには追加料金が発生します
    enabled = true
  }

  #-------------------------------------------------------------
  # ネットワークインターフェース設定
  #-------------------------------------------------------------

  # network_interfaces (Optional)
  # 設定内容: ネットワークインターフェースの詳細設定を指定します。
  # 注意: このブロックを使用する場合、vpc_security_group_ids等と競合します
  # 用途: 複数のENI設定、固定IPアドレスの割り当て等
  network_interfaces {
    # device_index (Optional)
    # 設定内容: ネットワークインターフェースのデバイスインデックスを指定します。
    # 設定可能な値: 0から始まる整数（0がプライマリインターフェース）
    device_index = 0

    # network_interface_id (Optional)
    # 設定内容: 既存のENI IDを指定します。
    # 設定可能な値: 既存のENI ID
    # 注意: 他のネットワーク関連設定と競合する可能性があります
    network_interface_id = null

    # subnet_id (Optional)
    # 設定内容: インターフェースを作成するサブネットIDを指定します。
    # 設定可能な値: 有効なサブネットID
    subnet_id = null

    # description (Optional)
    # 設定内容: ネットワークインターフェースの説明を指定します。
    # 設定可能な値: 任意の文字列
    description = null

    # private_ip_address (Optional)
    # 設定内容: プライマリプライベートIPアドレスを指定します。
    # 設定可能な値: サブネット範囲内の有効なIPアドレス
    # 省略時: サブネット範囲から自動割り当て
    private_ip_address = null

    # ipv4_addresses (Optional)
    # 設定内容: セカンダリプライベートIPv4アドレスのリストを指定します。
    # 設定可能な値: IPアドレスのセット
    # 注意: ipv4_address_countと競合します
    ipv4_addresses = null

    # ipv4_address_count (Optional)
    # 設定内容: セカンダリIPv4アドレスの数を指定します。
    # 設定可能な値: 正の整数
    # 注意: ipv4_addressesと競合します
    ipv4_address_count = null

    # ipv4_prefix_count (Optional)
    # 設定内容: IPv4プレフィックスの数を指定します。
    # 設定可能な値: 正の整数
    # 注意: ipv4_prefixesと競合します
    ipv4_prefix_count = null

    # ipv4_prefixes (Optional)
    # 設定内容: IPv4プレフィックスのリストを指定します。
    # 設定可能な値: CIDR形式のIPv4プレフィックスのセット
    # 注意: ipv4_prefix_countと競合します
    ipv4_prefixes = null

    # ipv6_addresses (Optional)
    # 設定内容: IPv6アドレスのリストを指定します。
    # 設定可能な値: IPv6アドレスのセット
    # 注意: ipv6_address_countと競合します
    ipv6_addresses = null

    # ipv6_address_count (Optional)
    # 設定内容: IPv6アドレスの数を指定します。
    # 設定可能な値: 正の整数
    # 注意: ipv6_addressesと競合します
    ipv6_address_count = null

    # ipv6_prefix_count (Optional)
    # 設定内容: IPv6プレフィックスの数を指定します。
    # 設定可能な値: 正の整数
    # 注意: ipv6_prefixesと競合します
    ipv6_prefix_count = null

    # ipv6_prefixes (Optional)
    # 設定内容: IPv6プレフィックスのリストを指定します。
    # 設定可能な値: CIDR形式のIPv6プレフィックスのセット
    # 注意: ipv6_prefix_countと競合します
    ipv6_prefixes = null

    # primary_ipv6 (Optional)
    # 設定内容: プライマリIPv6アドレスを指定します。
    # 設定可能な値: 有効なIPv6アドレス
    primary_ipv6 = null

    # security_groups (Optional)
    # 設定内容: このインターフェースに関連付けるセキュリティグループIDのリストを指定します。
    # 設定可能な値: セキュリティグループIDのセット
    security_groups = null

    # associate_public_ip_address (Optional)
    # 設定内容: パブリックIPアドレスを関連付けるかを指定します。
    # 設定可能な値: "true" / "false" （文字列型）
    # 注意: device_index=0の場合のみ有効
    associate_public_ip_address = null

    # associate_carrier_ip_address (Optional)
    # 設定内容: キャリアIPアドレスを関連付けるかを指定します。
    # 設定可能な値: "true" / "false" （文字列型）
    # 用途: Wavelengthゾーンでの使用
    associate_carrier_ip_address = null

    # delete_on_termination (Optional)
    # 設定内容: インスタンス終了時にネットワークインターフェースを削除するかを指定します。
    # 設定可能な値: "true" / "false" （文字列型）
    # 省略時: "false"
    delete_on_termination = null

    # interface_type (Optional)
    # 設定内容: インターフェースタイプを指定します。
    # 設定可能な値:
    #   - "interface": 標準ENI（デフォルト）
    #   - "efa": Elastic Fabric Adapter
    # 用途: HPCワークロードでEFAを使用する場合に指定
    # 参考: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/efa.html
    interface_type = null

    # network_card_index (Optional)
    # 設定内容: ネットワークカードのインデックスを指定します。
    # 設定可能な値: 0から始まる整数
    # 用途: 複数のネットワークカードをサポートするインスタンスタイプで使用
    network_card_index = null

    # connection_tracking_specification (Optional)
    # 設定内容: 接続追跡の設定を指定します。
    # 用途: タイムアウト値のカスタマイズ
    connection_tracking_specification {
      # tcp_established_timeout (Optional)
      # 設定内容: TCP確立済み接続のタイムアウトを秒単位で指定します。
      # 設定可能な値: 60〜432000秒（1分〜5日）
      # 省略時: 432000秒（5日）
      tcp_established_timeout = null

      # udp_timeout (Optional)
      # 設定内容: UDPタイムアウトを秒単位で指定します。
      # 設定可能な値: 30〜180秒
      # 省略時: 30秒
      udp_timeout = null

      # udp_stream_timeout (Optional)
      # 設定内容: UDPストリームタイムアウトを秒単位で指定します。
      # 設定可能な値: 60〜180秒
      # 省略時: 180秒
      udp_stream_timeout = null
    }

    # ena_srd_specification (Optional)
    # 設定内容: ENA Express（SRD）の設定を指定します。
    # 用途: ネットワークパフォーマンスの向上
    # 参考: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ena-express.html
    ena_srd_specification {
      # ena_srd_enabled (Optional)
      # 設定内容: ENA SRDを有効化するかを指定します。
      # 設定可能な値: true / false
      # 注意: サポートされているインスタンスタイプのみで使用可能
      ena_srd_enabled = null

      ena_srd_udp_specification {
        # ena_srd_udp_enabled (Optional)
        # 設定内容: UDP向けのENA SRDを有効化するかを指定します。
        # 設定可能な値: true / false
        ena_srd_udp_enabled = null
      }
    }
  }

  #-------------------------------------------------------------
  # 配置設定
  #-------------------------------------------------------------

  # placement (Optional)
  # 設定内容: インスタンスの配置設定を指定します。
  # 用途: アベイラビリティゾーンや配置グループの設定
  placement {
    # availability_zone (Optional)
    # 設定内容: インスタンスを起動するアベイラビリティゾーンを指定します。
    # 設定可能な値: 有効なAZ名（例: ap-northeast-1a）
    availability_zone = null

    # group_name (Optional)
    # 設定内容: 配置グループ名を指定します。
    # 設定可能な値: 既存の配置グループ名
    # 注意: group_idと競合します
    # 参考: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/placement-groups.html
    group_name = null

    # group_id (Optional)
    # 設定内容: 配置グループIDを指定します。
    # 設定可能な値: 既存の配置グループID
    # 注意: group_nameと競合します
    group_id = null

    # tenancy (Optional)
    # 設定内容: インスタンスのテナンシーを指定します。
    # 設定可能な値:
    #   - "default": 共有ハードウェア
    #   - "dedicated": 専用ハードウェア
    #   - "host": 専用ホスト
    tenancy = null

    # host_id (Optional)
    # 設定内容: 専用ホストのIDを指定します。
    # 設定可能な値: 専用ホストのID
    # 用途: tenancy="host"の場合に特定のホストを指定
    host_id = null

    # host_resource_group_arn (Optional)
    # 設定内容: ホストリソースグループのARNを指定します。
    # 設定可能な値: リソースグループのARN
    # 用途: License Managerホストリソースグループでの管理
    host_resource_group_arn = null

    # partition_number (Optional)
    # 設定内容: パーティション番号を指定します。
    # 設定可能な値: 整数値
    # 注意: 配置グループのstrategyが"partition"の場合のみ有効
    partition_number = null

    # spread_domain (Optional)
    # 設定内容: スプレッドドメインを指定します。
    # 設定可能な値: 文字列
    # 注意: 配置グループのstrategyが"spread"の場合のみ有効
    spread_domain = null

    # affinity (Optional)
    # 設定内容: ホストアフィニティを指定します。
    # 設定可能な値:
    #   - "default": アフィニティなし
    #   - "host": ホストアフィニティあり
    # 用途: 専用ホストでのインスタンス配置制御
    affinity = null
  }

  #-------------------------------------------------------------
  # プライベートDNS名オプション
  #-------------------------------------------------------------

  # private_dns_name_options (Optional)
  # 設定内容: プライベートDNS名の設定を指定します。
  # 用途: リソース名ベースのDNS名の有効化
  # 参考: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-instance-naming.html
  private_dns_name_options {
    # hostname_type (Optional)
    # 設定内容: ホスト名のタイプを指定します。
    # 設定可能な値:
    #   - "ip-name": IPベースの名前（デフォルト）
    #   - "resource-name": リソース名ベースの名前
    hostname_type = null

    # enable_resource_name_dns_a_record (Optional)
    # 設定内容: リソース名のDNS Aレコードを有効化するかを指定します。
    # 設定可能な値: true / false
    # 注意: hostname_type="resource-name"の場合に有効
    enable_resource_name_dns_a_record = null

    # enable_resource_name_dns_aaaa_record (Optional)
    # 設定内容: リソース名のDNS AAAAレコードを有効化するかを指定します。
    # 設定可能な値: true / false
    # 注意: hostname_type="resource-name"かつIPv6有効の場合に有効
    enable_resource_name_dns_aaaa_record = null
  }

  #-------------------------------------------------------------
  # タグ仕様（起動されるリソースへのタグ付け）
  #-------------------------------------------------------------

  # tag_specifications (Optional)
  # 設定内容: 起動時に作成されるリソースに付与するタグを指定します。
  # 注意: 起動テンプレート自体のタグは最上位のtagsブロックで指定
  tag_specifications {
    # resource_type (Optional)
    # 設定内容: タグを適用するリソースタイプを指定します。
    # 設定可能な値:
    #   - "instance": EC2インスタンス
    #   - "volume": EBSボリューム
    #   - "network-interface": ネットワークインターフェース
    #   - "spot-instances-request": スポットインスタンスリクエスト
    resource_type = "instance"

    # tags (Optional)
    # 設定内容: リソースに付与するタグを指定します。
    # 設定可能な値: キーと値のペアのマップ
    tags = {
      Name        = "example-instance"
      Environment = "production"
    }
  }

  tag_specifications {
    resource_type = "volume"
    tags = {
      Name        = "example-volume"
      Environment = "production"
    }
  }
}

#---------------------------------------------------------------
# 出力値（Computed Attributes）
#---------------------------------------------------------------

# arn
# 設定内容: 起動テンプレートのARN
# 型: string
# 用途: 他のリソースでの参照、IAMポリシーでの使用
# 例: arn:aws:ec2:us-east-1:123456789012:launch-template/lt-1234567890abcdef

# id
# 設定内容: 起動テンプレートのID
# 型: string
# 用途: Auto Scalingグループ等での参照
# 例: lt-1234567890abcdef

# latest_version
# 設定内容: 最新バージョン番号
# 型: number
# 用途: バージョン管理、Auto Scalingグループでの使用
# 例: 5

# default_version
# 設定内容: デフォルトバージョン番号
# 型: number
# 注意: 明示的に設定しない限り、latest_versionと同じ値
# 例: 3
