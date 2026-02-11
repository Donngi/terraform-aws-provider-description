#---------------------------------------------------------------
# Amazon EMR Cluster
#---------------------------------------------------------------
#
# Amazon EMR (Elastic MapReduce) クラスターをプロビジョニングする。
# EMRは大量のデータを効率的に処理するマネージドHadoopフレームワークを提供し、
# Apache Spark、Hive、HBase、Presto等の複数のビッグデータフレームワークを
# サポートする。
#
# AWS公式ドキュメント:
#   - Amazon EMR Documentation: https://aws.amazon.com/documentation/elastic-mapreduce/
#   - Instance Fleets: https://docs.aws.amazon.com/emr/latest/ManagementGuide/emr-instance-fleet.html
#   - Instance Groups: https://docs.aws.amazon.com/emr/latest/ManagementGuide/emr-instance-group-configuration.html
#   - Security Configuration: https://docs.aws.amazon.com/emr/latest/ManagementGuide/emr-create-security-configuration.html
#   - Kerberos Configuration: https://docs.aws.amazon.com/emr/latest/ManagementGuide/emr-kerberos-configure-settings.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/emr_cluster
#
# Provider Version: 6.28.0
# Generated: 2026-01-27
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_emr_cluster" "example" {
  #---------------------------------------------------------------
  # Required Parameters
  #---------------------------------------------------------------

  # クラスター名
  # ジョブフローの識別名
  name = "example-emr-cluster"

  # EMRリリースラベル
  # Amazon EMRのバージョンを指定する（例: emr-6.10.0, emr-5.36.0）
  # 利用可能なバージョンは https://docs.aws.amazon.com/emr/latest/ReleaseGuide/emr-release-components.html を参照
  release_label = "emr-6.10.0"

  # サービスロール
  # Amazon EMRサービスがAWSリソースにアクセスするために使用するIAMロール
  # 通常は "EMR_DefaultRole" または "EMR_DefaultRole_V2" を使用する
  service_role = "EMR_DefaultRole"

  #---------------------------------------------------------------
  # Optional Parameters
  #---------------------------------------------------------------

  # 追加情報（JSON文字列）
  # プロキシ情報など追加機能を選択するためのJSON文字列
  # クラスター作成後にプロバイダーからこの値を取得するAPIがないため、
  # Terraform外で変更された場合の差分検出はできない
  # additional_info = jsonencode({
  #   instanceAwsClientConfiguration = {
  #     proxyPort = 8099
  #     proxyHost = "myproxy.example.com"
  #   }
  # })

  # アプリケーション一覧
  # クラスター起動時にインストールおよび設定するアプリケーションのリスト（大文字小文字を区別しない）
  # 例: ["Spark", "Hive", "Presto", "Hadoop", "HBase", "Flink", "Hue", "Pig", "Tez", "Zeppelin"]
  # 各EMRリリースで利用可能なアプリケーションは上記のリリースガイドを参照
  applications = ["Spark", "Hadoop"]

  # オートスケーリングロール
  # 自動スケーリングポリシーで使用するIAMロール
  # EC2インスタンスを起動・終了する権限を持つ必要がある
  # autoscaling_role = "EMR_AutoScaling_DefaultRole"

  # 設定（非推奨）
  # EMRクラスター用の設定を供給する（非推奨: configurations_jsonを使用すること）
  # configurations = ""

  # 設定（JSON文字列）
  # EMRクラスター用の設定をJSON形式で供給する
  # アプリケーションのデフォルト設定を上書きする
  # 詳細: https://docs.aws.amazon.com/emr/latest/ReleaseGuide/emr-configure-apps.html
  # configurations_json = jsonencode([
  #   {
  #     Classification = "hadoop-env"
  #     Configurations = [
  #       {
  #         Classification = "export"
  #         Properties = {
  #           JAVA_HOME = "/usr/lib/jvm/java-1.8.0"
  #         }
  #       }
  #     ]
  #     Properties = {}
  #   }
  # ])

  # カスタムAMI ID
  # クラスターに使用するカスタムAmazon Linux AMI（EMR所有AMIの代わり）
  # EMR 5.7.0以降で利用可能
  # custom_ami_id = "ami-xxxxxxxxxxxxx"

  # EBSルートボリュームサイズ
  # 各EC2インスタンスで使用するLinux AMIのEBSルートデバイスボリュームのサイズ（GiB単位）
  # EMR 4.x以降で利用可能
  # ebs_root_volume_size = 20

  # ID
  # クラスターのID（通常は指定不要、Terraformが自動的に設定する）
  # id = ""

  # ステップがない時にジョブフローを維持
  # ステップがない状態、または全ステップ完了時にクラスターを実行し続けるかのスイッチ
  # デフォルトはtrue（クラスターを維持）
  # falseに設定すると全ステップ完了後にクラスターが自動終了する
  # keep_job_flow_alive_when_no_steps = true

  # ステップステータスフィルタ
  # 返されるステップをフィルタリングするために使用するステップステータスのリスト
  # 有効な値: PENDING, CANCEL_PENDING, RUNNING, COMPLETED, CANCELLED, FAILED, INTERRUPTED
  # list_steps_states = ["PENDING", "RUNNING"]

  # ログ暗号化KMSキーID
  # ログファイル暗号化に使用するAWS KMSカスタマーマスターキー(CMK)のIDまたはARN
  # EMR 5.30.0以降で利用可能（EMR 6.0.0を除く）
  # log_encryption_kms_key_id = "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"

  # ログURI
  # ジョブフローのログファイルを書き込むS3バケット
  # 値が指定されない場合、ログは作成されない
  # log_uri = "s3://my-emr-logs-bucket/"

  # OSリリースラベル
  # クラスター内の全ノードで使用するAmazon Linuxリリース
  # 指定しない場合、Amazon EMRはクラスター起動用に最新の検証済みAmazon Linuxリリースを使用する
  # os_release_label = "2.0.20220606.1"

  # プレイスメントグループ設定
  # Amazon EMRクラスターの配置グループ設定
  # EC2プレイスメントグループを使用してクラスターノードの配置戦略を制御する
  # placement_group_config = [
  #   {
  #     instance_role      = "MASTER"
  #     placement_strategy = "SPREAD"
  #   }
  # ]

  # リージョン
  # このリソースが管理されるリージョン
  # 指定しない場合、プロバイダー設定のリージョンがデフォルトとなる
  # region = "us-east-1"

  # スケールダウン動作
  # 自動スケールイン処理が発生した時、または instance group がリサイズされた時に
  # 個々のAmazon EC2インスタンスが終了する方法
  # 有効な値: TERMINATE_AT_INSTANCE_HOUR, TERMINATE_AT_TASK_COMPLETION
  # scale_down_behavior = "TERMINATE_AT_TASK_COMPLETION"

  # セキュリティ設定
  # EMRクラスターにアタッチするセキュリティ設定名
  # 暗号化設定やKerberos認証を含む
  # release_label 4.8.0以降でのみ有効
  # security_configuration = "example-security-config"

  # ステップ
  # クラスター作成時に実行するステップのリスト
  # Terraform外で他のステップを管理する場合は、lifecycleブロックでignore_changesの使用を強く推奨
  # step = [
  #   {
  #     action_on_failure = "CONTINUE"
  #     name              = "Example Step"
  #     hadoop_jar_step = [
  #       {
  #         jar        = "command-runner.jar"
  #         args       = ["spark-submit", "--class", "org.example.Main", "s3://bucket/app.jar"]
  #         main_class = null
  #         properties = {}
  #       }
  #     ]
  #   }
  # ]

  # ステップ同時実行レベル
  # 同時に実行できるステップ数（最大256ステップ）
  # release_label 5.28.0以降でのみ有効（デフォルトは1）
  # step_concurrency_level = 1

  # タグ
  # EMRクラスターに適用するタグのリスト
  tags = {
    Name        = "example-emr-cluster"
    Environment = "production"
  }

  # 全タグ（計算値）
  # プロバイダーのdefault_tagsも含む全タグのマップ
  # この属性はTerraformが自動的に管理するため、通常は指定不要
  # tags_all = {}

  # 終了保護
  # 終了保護のオン/オフスイッチ（デフォルトはfalse、複数マスターノード使用時を除く）
  # 終了保護が有効な場合、リソース破棄前にこの設定をfalseに変更して適用する必要がある
  # termination_protection = false

  # 不健全ノード置換
  # クラスター内で劣化したコアノードをAmazon EMRが自動的に置き換えるかどうか
  # デフォルトはfalse
  # unhealthy_node_replacement = false

  # 全ユーザーに可視化
  # ジョブフローがAWSアカウントの全IAMユーザーに可視化されるかどうか
  # デフォルトはtrue
  # 注意: Amazon EMR API仕様により、この引数はサポートされなくなった
  # 特にfalseに設定すると永続的な差分が発生するため、設定しないこと
  # visible_to_all_users = true

  #---------------------------------------------------------------
  # Auto Termination Policy
  # 自動終了ポリシー - アイドル時間経過後のクラスター自動終了設定
  #---------------------------------------------------------------

  # auto_termination_policy {
  #   # アイドルタイムアウト（秒単位）
  #   # クラスターが自動終了するまでのアイドル時間
  #   # 最小60秒、最大604800秒（7日間）
  #   idle_timeout = 3600
  # }

  #---------------------------------------------------------------
  # Bootstrap Action
  # ブートストラップアクション - Hadoop起動前に実行するスクリプト
  #---------------------------------------------------------------

  # bootstrap_action {
  #   # ブートストラップアクションの名前（必須）
  #   name = "Install Custom Software"
  #
  #   # スクリプトの場所（必須）
  #   # ブートストラップアクション中に実行するスクリプトの場所
  #   # Amazon S3またはローカルファイルシステム上の場所を指定可能
  #   path = "s3://my-bucket/bootstrap-actions/install.sh"
  #
  #   # コマンドライン引数
  #   # ブートストラップアクションスクリプトに渡すコマンドライン引数のリスト
  #   args = ["arg1", "arg2"]
  # }

  #---------------------------------------------------------------
  # EC2 Attributes
  # EC2属性 - クラスターのEC2インスタンス設定
  #---------------------------------------------------------------

  ec2_attributes {
    # インスタンスプロファイル（必須）
    # クラスターのEC2インスタンスが引き受けるインスタンスプロファイル
    instance_profile = "EMR_EC2_DefaultRole"

    # 追加マスターセキュリティグループ
    # マスターノード用の追加Amazon EC2セキュリティグループIDをカンマ区切りで含む文字列
    # additional_master_security_groups = "sg-xxxxxxxxxxxxx"

    # 追加スレーブセキュリティグループ
    # スレーブノード用の追加Amazon EC2セキュリティグループIDをカンマ区切りで含む文字列
    # additional_slave_security_groups = "sg-xxxxxxxxxxxxx"

    # EMR管理マスターセキュリティグループ
    # マスターノード用のAmazon EC2 EMR管理セキュリティグループの識別子
    # EMRサービスが必要なルールを自動的に追加・維持する
    # emr_managed_master_security_group = "sg-xxxxxxxxxxxxx"

    # EMR管理スレーブセキュリティグループ
    # スレーブノード用のAmazon EC2 EMR管理セキュリティグループの識別子
    # EMRサービスが必要なルールを自動的に追加・維持する
    # emr_managed_slave_security_group = "sg-xxxxxxxxxxxxx"

    # キー名
    # hadoopユーザーとしてマスターノードにSSH接続するために使用できるAmazon EC2キーペア
    # key_name = "my-key-pair"

    # サービスアクセスセキュリティグループ
    # Amazon EC2サービスアクセスセキュリティグループの識別子
    # プライベートサブネットでクラスターを実行する場合に必須
    # service_access_security_group = "sg-xxxxxxxxxxxxx"

    # サブネットID
    # ジョブフローを起動するVPCサブネットID
    # cc1.4xlargeインスタンスタイプはVPC内では指定不可
    # subnet_id = "subnet-xxxxxxxxxxxxx"

    # サブネットID一覧
    # ジョブフローを起動するVPCサブネットIDのリスト
    # Amazon EMRはフリート仕様に従って最適なアベイラビリティーゾーンを識別する
    # subnet_ids = ["subnet-xxxxxxxxxxxxx", "subnet-yyyyyyyyyyyyy"]
  }

  #---------------------------------------------------------------
  # Master Instance Group / Master Instance Fleet
  # マスターノードの設定（Instance GroupまたはInstance Fleetのいずれか一方のみ使用）
  #---------------------------------------------------------------

  # Master Instance Group
  # インスタンスグループを使用したマスターノード設定
  master_instance_group {
    # インスタンスタイプ（必須）
    # インスタンスグループ内の全インスタンスのEC2インスタンスタイプ
    instance_type = "m5.xlarge"

    # ビッド価格
    # インスタンスグループ内の各EC2インスタンスのビッド価格（USD）
    # この属性を設定するとスポットインスタンスとして宣言され、暗黙的にスポットリクエストが作成される
    # オンデマンドインスタンスを使用する場合は空白のままにする
    # bid_price = "0.30"

    # インスタンス数
    # インスタンスグループのターゲットインスタンス数
    # 1または3である必要がある（デフォルトは1）
    # 複数マスターノードでの起動はEMR 5.23.0+でのみサポート
    # 複数マスターノード起動時はcore_instance_groupの設定が必須
    # パブリックインスタンスはmap_public_ip_on_launchが有効なVPCサブネットで作成する必要がある
    # instance_count = 1

    # 名前
    # インスタンスグループに付ける識別名
    # name = "Master Instance Group"

    # EBS設定
    # インスタンスグループ内の各インスタンスにアタッチするEBSボリュームの設定
    # ebs_config {
    #   # サイズ（必須）
    #   # ボリュームサイズ（GiB単位）
    #   size = 100
    #
    #   # タイプ（必須）
    #   # ボリュームタイプ
    #   # 有効な値: gp3, gp2, io1, io2, standard, st1, sc1
    #   type = "gp3"
    #
    #   # IOPS
    #   # ボリュームがサポートする1秒あたりのI/O操作数
    #   # io1, io2, gp3タイプで使用
    #   iops = 3000
    #
    #   # スループット
    #   # スループット（MiB/s単位）
    #   # gp3タイプで使用
    #   throughput = 125
    #
    #   # インスタンス毎のボリューム数
    #   # この設定でインスタンスグループ内の各EC2インスタンスにアタッチするEBSボリューム数（デフォルトは1）
    #   volumes_per_instance = 1
    # }
  }

  # Master Instance Fleet（Instance Groupと排他的）
  # インスタンスフリートを使用したマスターノード設定
  # Instance Groupとは同時に使用できない
  # master_instance_fleet {
  #   # 名前
  #   # インスタンスフリートに付ける識別名
  #   name = "Master Instance Fleet"
  #
  #   # オンデマンドターゲット容量
  #   # インスタンスフリート用のオンデマンドユニットのターゲット容量
  #   # プロビジョニングするオンデマンドインスタンス数を決定する
  #   target_on_demand_capacity = 1
  #
  #   # スポットターゲット容量
  #   # インスタンスフリート用のスポットユニットのターゲット容量
  #   # プロビジョニングするスポットインスタンス数を決定する
  #   target_spot_capacity = 0
  #
  #   # インスタンスタイプ設定
  #   instance_type_configs {
  #     # インスタンスタイプ（必須）
  #     instance_type = "m5.xlarge"
  #
  #     # ビッド価格
  #     # instance_typeで定義された各EC2スポットインスタンスタイプのビッド価格（USD）
  #     bid_price = "0.30"
  #
  #     # オンデマンド価格に対するビッド価格の割合
  #     # instance_typeで定義された各EC2スポットインスタンスのオンデマンド価格に対する割合
  #     # 数値で表現（例: 20は20%を指定）
  #     bid_price_as_percentage_of_on_demand_price = 80
  #
  #     # 重み付け容量
  #     # このタイプのプロビジョンされたインスタンスがaws_emr_instance_fleetで定義された
  #     # ターゲット容量を満たすために提供するユニット数
  #     weighted_capacity = 1
  #
  #     # EBS設定
  #     ebs_config {
  #       size                 = 100
  #       type                 = "gp3"
  #       iops                 = 3000
  #       volumes_per_instance = 1
  #     }
  #
  #     # 設定
  #     # クラスターインスタンスをプロビジョニングする際に適用される設定分類
  #     configurations {
  #       classification = "spark-env"
  #       properties = {
  #         "SPARK_WORKER_CORES" = "2"
  #       }
  #     }
  #   }
  #
  #   # 起動仕様
  #   launch_specifications {
  #     # オンデマンド仕様
  #     on_demand_specification {
  #       # アロケーション戦略（必須）
  #       # オンデマンドインスタンスフリートの起動戦略
  #       # 現在はlowest-price（デフォルト）のみ利用可能
  #       allocation_strategy = "lowest-price"
  #     }
  #
  #     # スポット仕様
  #     spot_specification {
  #       # アロケーション戦略（必須）
  #       # スポットインスタンスフリートの起動戦略
  #       # 有効な値: capacity-optimized, diversified, lowest-price, price-capacity-optimized
  #       allocation_strategy = "capacity-optimized"
  #
  #       # ブロック期間（分）
  #       # スポットインスタンスの定義期間（スポットブロックとも呼ばれる）（分単位）
  #       # 有効な値: 60, 120, 180, 240, 300, 360
  #       block_duration_minutes = 0
  #
  #       # タイムアウトアクション（必須）
  #       # TimeoutDurationMinutesが経過してもTargetSpotCapacityが満たされなかった場合のアクション
  #       # 有効な値: TERMINATE_CLUSTER, SWITCH_TO_ON_DEMAND
  #       timeout_action = "SWITCH_TO_ON_DEMAND"
  #
  #       # タイムアウト期間（分）（必須）
  #       # スポットプロビジョニングタイムアウト期間（分単位）
  #       # 最小値は5、最大値は1440
  #       # タイムアウトは初期プロビジョニング時（クラスター初回作成時）にのみ適用される
  #       timeout_duration_minutes = 10
  #     }
  #   }
  # }

  #---------------------------------------------------------------
  # Core Instance Group / Core Instance Fleet
  # コアノードの設定（Instance GroupまたはInstance Fleetのいずれか一方のみ使用）
  #---------------------------------------------------------------

  # Core Instance Group
  # インスタンスグループを使用したコアノード設定
  core_instance_group {
    # インスタンスタイプ（必須）
    instance_type = "m5.xlarge"

    # インスタンス数
    # インスタンスグループのターゲットインスタンス数
    # 最低1（デフォルトは1）
    instance_count = 2

    # 名前
    # name = "Core Instance Group"

    # ビッド価格
    # bid_price = "0.30"

    # オートスケーリングポリシー
    # EMR自動スケーリングポリシーのJSON文字列
    # autoscaling_policy = jsonencode({
    #   Constraints = {
    #     MinCapacity = 1
    #     MaxCapacity = 10
    #   }
    #   Rules = [
    #     {
    #       Name = "ScaleOutMemoryPercentage"
    #       Description = "Scale out if YARNMemoryAvailablePercentage is less than 15"
    #       Action = {
    #         SimpleScalingPolicyConfiguration = {
    #           AdjustmentType = "CHANGE_IN_CAPACITY"
    #           ScalingAdjustment = 1
    #           CoolDown = 300
    #         }
    #       }
    #       Trigger = {
    #         CloudWatchAlarmDefinition = {
    #           ComparisonOperator = "LESS_THAN"
    #           EvaluationPeriods = 1
    #           MetricName = "YARNMemoryAvailablePercentage"
    #           Namespace = "AWS/ElasticMapReduce"
    #           Period = 300
    #           Statistic = "AVERAGE"
    #           Threshold = 15.0
    #           Unit = "PERCENT"
    #         }
    #       }
    #     }
    #   ]
    # })

    # EBS設定
    # ebs_config {
    #   size                 = 100
    #   type                 = "gp3"
    #   iops                 = 3000
    #   throughput           = 125
    #   volumes_per_instance = 1
    # }
  }

  # Core Instance Fleet（Instance Groupと排他的）
  # core_instance_fleet {
  #   name                      = "Core Instance Fleet"
  #   target_on_demand_capacity = 2
  #   target_spot_capacity      = 2
  #
  #   instance_type_configs {
  #     instance_type                          = "m5.xlarge"
  #     bid_price_as_percentage_of_on_demand_price = 80
  #     weighted_capacity                      = 1
  #
  #     ebs_config {
  #       size                 = 100
  #       type                 = "gp3"
  #       volumes_per_instance = 1
  #     }
  #   }
  #
  #   instance_type_configs {
  #     instance_type                          = "m5.2xlarge"
  #     bid_price_as_percentage_of_on_demand_price = 100
  #     weighted_capacity                      = 2
  #
  #     ebs_config {
  #       size                 = 100
  #       type                 = "gp3"
  #       volumes_per_instance = 1
  #     }
  #   }
  #
  #   launch_specifications {
  #     spot_specification {
  #       allocation_strategy      = "capacity-optimized"
  #       block_duration_minutes   = 0
  #       timeout_action           = "SWITCH_TO_ON_DEMAND"
  #       timeout_duration_minutes = 10
  #     }
  #   }
  # }

  #---------------------------------------------------------------
  # Kerberos Attributes
  # Kerberos認証設定
  #---------------------------------------------------------------

  # kerberos_attributes {
  #   # KDC管理パスワード（必須）
  #   # クラスター内のkadminサービス用のパスワード
  #   # クラスター専用のKDCでKerberosプリンシパル、パスワードポリシー、キータブを維持する
  #   # Terraformはこの設定の差分検出を実行できない
  #   kdc_admin_password = "SuperSecurePassword123!"
  #
  #   # レルム（必須）
  #   # クラスター内の全ノードが属するKerberosレルム名
  #   # 例: EC2.INTERNAL
  #   realm = "EC2.INTERNAL"
  #
  #   # ADドメイン参加ユーザー
  #   # Active Directoryドメインとのクロスレルムトラストを確立する場合にのみ必須
  #   # ドメインにリソースを参加させるための十分な権限を持つユーザー
  #   # Terraformはこの設定の差分検出を実行できない
  #   ad_domain_join_user = "admin"
  #
  #   # ADドメイン参加パスワード
  #   # ad_domain_join_user用のActive Directoryパスワード
  #   # Terraformはこの設定の差分検出を実行できない
  #   ad_domain_join_password = "ADPassword123!"
  #
  #   # クロスレルムトラストプリンシパルパスワード
  #   # 異なるレルムのKDCとのクロスレルムトラストを確立する場合にのみ必須
  #   # レルム間で同一である必要があるクロスレルムプリンシパルパスワード
  #   # Terraformはこの設定の差分検出を実行できない
  #   cross_realm_trust_principal_password = "CrossRealmPassword123!"
  # }

  #---------------------------------------------------------------
  # Lifecycle Management
  # ライフサイクル管理
  #---------------------------------------------------------------

  # lifecycle {
  #   # ステップを外部で管理する場合、変更を無視する
  #   ignore_changes = [step]
  # }
}

#---------------------------------------------------------------
# Attributes Reference（読み取り専用属性）
#---------------------------------------------------------------
#
# 以下の属性はリソース作成後に参照可能な読み取り専用属性です。
# これらは設定不可（computed only）であり、出力値として使用できます。
#
# - arn
#     クラスターのARN
#
# - cluster_state
#     クラスターの現在の状態
#     値: STARTING, BOOTSTRAPPING, RUNNING, WAITING, TERMINATING, TERMINATED, TERMINATED_WITH_ERRORS
#
# - id
#     クラスターのID（EMRクラスター識別子）
#
# - master_public_dns
#     マスターノードのDNS名
#     プライベートサブネット上の場合はプライベートDNS名
#     パブリックサブネット上の場合はパブリックDNS名
#
# - core_instance_group.0.id
#     コアノードタイプのInstance Group ID（Instance Groupを使用している場合）
#
# - core_instance_fleet.0.id
#     コアノードタイプのInstance Fleet ID（Instance Fleetを使用している場合）
#
# - core_instance_fleet.0.provisioned_on_demand_capacity
#     プロビジョン済みオンデマンド容量
#
# - core_instance_fleet.0.provisioned_spot_capacity
#     プロビジョン済みスポット容量
#
# - master_instance_group.0.id
#     マスターノードタイプのInstance Group ID（Instance Groupを使用している場合）
#
# - master_instance_fleet.0.id
#     マスターノードタイプのInstance Fleet ID（Instance Fleetを使用している場合）
#
# - master_instance_fleet.0.provisioned_on_demand_capacity
#     プロビジョン済みオンデマンド容量
#
# - master_instance_fleet.0.provisioned_spot_capacity
#     プロビジョン済みスポット容量
#
# - tags_all
#     プロバイダーのdefault_tagsも含む、リソースに割り当てられた全タグのマップ
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# 使用例
#---------------------------------------------------------------

# 出力例: クラスターIDとマスターノードのDNS名を取得
# output "emr_cluster_id" {
#   value = aws_emr_cluster.example.id
# }
#
# output "emr_master_public_dns" {
#   value = aws_emr_cluster.example.master_public_dns
# }
#
# output "emr_cluster_arn" {
#   value = aws_emr_cluster.example.arn
# }
