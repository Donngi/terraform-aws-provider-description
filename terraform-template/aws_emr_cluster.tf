#---------------------------------------
# Amazon EMR クラスター
#---------------------------------------
# Provider Version: 6.28.0
# Terraform Registry: https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/emr_cluster
# Generated: 2026-02-17
#
# EMR（Elastic MapReduce）クラスターリソース
# ビッグデータ処理フレームワーク（Hadoop、Spark等）を実行する
# マネージドクラスター環境を提供します
#
# NOTE:
# - 必須項目: name, release_label, service_role
# - マスターノードは1または3のいずれかのみ指定可能
# - core_instance_groupまたはcore_instance_fleetのいずれかを選択
# - step設定は外部管理する場合lifecycle ignore_changesの使用を推奨

resource "aws_emr_cluster" "example" {
  #---------------------------------------
  # 基本設定
  #---------------------------------------
  # 設定内容: クラスター名
  name = "my-emr-cluster"

  # 設定内容: EMRリリースバージョン
  # 設定可能な値: emr-5.x.x, emr-6.x.x など
  release_label = "emr-6.15.0"

  # 設定内容: EMRサービスに割り当てるIAMロール
  # 設定可能な値: IAMロールARNまたはロール名
  service_role = "EMR_DefaultRole"

  #---------------------------------------
  # リージョン設定
  #---------------------------------------
  # 設定内容: リソースを管理するAWSリージョン
  # 省略時: プロバイダー設定のリージョンを使用
  region = null
  # region = "ap-northeast-1"

  #---------------------------------------
  # アプリケーション設定
  #---------------------------------------
  # 設定内容: インストールするアプリケーションのリスト
  # 設定可能な値: Hadoop, Spark, Hive, Presto, Flink, HBase等（大文字小文字区別なし）
  applications = ["Spark", "Hadoop", "Hive"]

  #---------------------------------------
  # 追加機能設定
  #---------------------------------------
  # 設定内容: 追加機能を選択するためのJSON文字列（プロキシ情報等）
  # 注意: Terraform側でドリフト検出不可のため、外部変更は検知されません
  additional_info = null
  # additional_info = jsonencode({
  #   instanceAwsClientConfiguration = {
  #     proxyHost = "proxy.example.com"
  #     proxyPort = 8080
  #   }
  # })

  #---------------------------------------
  # カスタムAMI設定
  #---------------------------------------
  # 設定内容: カスタムLinux AMI ID
  # 設定可能な値: EMR 5.7.0以降で利用可能
  custom_ami_id = null
  # custom_ami_id = "ami-0123456789abcdef0"

  # 設定内容: Linux AMIのEBSルートボリュームサイズ（GiB）
  # 設定可能な値: EMR 4.x以降で利用可能
  ebs_root_volume_size = null
  # ebs_root_volume_size = 20

  # 設定内容: Amazon Linuxリリースラベル
  # 省略時: 最新の検証済みAmazon Linuxリリースを使用
  os_release_label = null
  # os_release_label = "2.0.20230628.0"

  #---------------------------------------
  # ジョブフロー動作設定
  #---------------------------------------
  # 設定内容: ステップがない場合もクラスターを稼働させるか
  # 設定可能な値: true（稼働）, false（停止）
  # 省略時: true
  keep_job_flow_alive_when_no_steps = true

  # 設定内容: 終了保護の有効化
  # 設定可能な値: true（有効）, false（無効）
  # 省略時: false（マスターノード3台構成時は自動的にtrue）
  # 注意: 削除前にfalseへの変更とapplyが必要
  termination_protection = false

  # 設定内容: 異常ノードの自動交換
  # 設定可能な値: true（有効）, false（無効）
  # 省略時: false
  unhealthy_node_replacement = null
  # unhealthy_node_replacement = true

  # 設定内容: 全IAMユーザーへの表示可否
  # 設定可能な値: true（表示）, false（非表示）
  # 省略時: true
  # 注意: 非推奨パラメータのため設定非推奨（特にfalse設定禁止）
  visible_to_all_users = true

  #---------------------------------------
  # スケーリング設定
  #---------------------------------------
  # 設定内容: 自動スケーリングポリシー用のIAMロール
  autoscaling_role = null
  # autoscaling_role = "EMR_AutoScaling_DefaultRole"

  # 設定内容: スケールイン時のEC2インスタンス終了方法
  # 設定可能な値: TERMINATE_AT_INSTANCE_HOUR, TERMINATE_AT_TASK_COMPLETION
  # 省略時: 自動設定される値を使用
  scale_down_behavior = null
  # scale_down_behavior = "TERMINATE_AT_TASK_COMPLETION"

  #---------------------------------------
  # ログ設定
  #---------------------------------------
  # 設定内容: ログファイルの出力先S3 URI
  # 省略時: ログは生成されません
  log_uri = "s3://my-emr-logs-bucket/logs/"

  # 設定内容: ログファイル暗号化用のKMSキーID
  # 設定可能な値: EMR 5.30.0以降で利用可能（6.0.0は除く）
  log_encryption_kms_key_id = null
  # log_encryption_kms_key_id = "arn:aws:kms:ap-northeast-1:123456789012:key/12345678-1234-1234-1234-123456789012"

  #---------------------------------------
  # セキュリティ設定
  #---------------------------------------
  # 設定内容: アタッチするセキュリティ設定名
  # 設定可能な値: EMR 4.8.0以降で利用可能
  security_configuration = null
  # security_configuration = "my-emr-security-config"

  #---------------------------------------
  # ステップ設定
  #---------------------------------------
  # 設定内容: 同時実行可能なステップ数
  # 設定可能な値: 1〜256（EMR 5.28.0以降で利用可能）
  # 省略時: 1
  step_concurrency_level = null
  # step_concurrency_level = 2

  # 設定内容: ステップ状態のフィルタリングリスト
  # 設定可能な値: PENDING, RUNNING, COMPLETED, CANCELLED, FAILED, INTERRUPTED
  list_steps_states = null
  # list_steps_states = ["PENDING", "RUNNING"]

  #---------------------------------------
  # タグ設定
  #---------------------------------------
  tags = {
    Name        = "my-emr-cluster"
    Environment = "production"
    ManagedBy   = "terraform"
  }

  #---------------------------------------
  # 自動終了ポリシー
  #---------------------------------------
  auto_termination_policy {
    # 設定内容: アイドル時間（秒）
    # 設定可能な値: 60〜604800（60秒〜7日間）
    idle_timeout = 3600
  }

  #---------------------------------------
  # EC2属性
  #---------------------------------------
  ec2_attributes {
    # 設定内容: EC2インスタンスに割り当てるIAMインスタンスプロファイル
    instance_profile = "EMR_EC2_DefaultRole"

    # 設定内容: SSHアクセス用のEC2キーペア名
    # key_name = "my-emr-keypair"

    # 設定内容: クラスターを起動するVPCサブネットID（単一AZ）
    # 注意: subnet_idまたはsubnet_idsのいずれかを指定
    # subnet_id = "subnet-12345678"

    # 設定内容: クラスターを起動するVPCサブネットIDリスト（マルチAZ）
    # 注意: EMRが最適なAZを選択します
    subnet_ids = ["subnet-12345678", "subnet-87654321"]

    # 設定内容: マスターノード用の追加セキュリティグループIDリスト（カンマ区切り）
    # additional_master_security_groups = "sg-12345678,sg-87654321"

    # 設定内容: スレーブノード用の追加セキュリティグループIDリスト（カンマ区切り）
    # additional_slave_security_groups = "sg-12345678,sg-87654321"

    # 設定内容: マスターノード用のEMR管理セキュリティグループID
    # 省略時: EMRが自動作成
    # emr_managed_master_security_group = "sg-12345678"

    # 設定内容: スレーブノード用のEMR管理セキュリティグループID
    # 省略時: EMRが自動作成
    # emr_managed_slave_security_group = "sg-87654321"

    # 設定内容: サービスアクセス用セキュリティグループID
    # 設定可能な値: プライベートサブネット起動時は必須
    # 省略時: パブリックサブネットの場合は不要
    # service_access_security_group = "sg-23456789"
  }

  #---------------------------------------
  # マスターインスタンスグループ設定
  #---------------------------------------
  master_instance_group {
    # 設定内容: インスタンスタイプ
    instance_type = "m5.xlarge"

    # 設定内容: インスタンス数
    # 設定可能な値: 1または3
    # 省略時: 1
    # 注意: 3台構成はEMR 5.23.0以降、VPCサブネットでmap_public_ip_on_launch必須
    instance_count = 1

    # 設定内容: インスタンスグループの表示名
    # name = "master-group"

    # 設定内容: スポットインスタンス入札価格（USD）
    # 注意: 設定するとスポットインスタンスとして起動
    # bid_price = "0.30"

    # 設定内容: EBS設定
    ebs_config {
      # 設定内容: ボリュームサイズ（GiB）
      size = 100

      # 設定内容: ボリュームタイプ
      # 設定可能な値: gp3, gp2, io1, io2, standard, st1, sc1
      type = "gp3"

      # 設定内容: IOPS値
      # 設定可能な値: io1, io2, gp3の場合に指定可能
      # iops = 3000

      # 設定内容: スループット（MiB/s）
      # 設定可能な値: gp3の場合に指定可能
      # throughput = 125

      # 設定内容: インスタンスあたりのボリューム数
      # 省略時: 1
      # volumes_per_instance = 1
    }
  }

  #---------------------------------------
  # コアインスタンスグループ設定
  #---------------------------------------
  core_instance_group {
    # 設定内容: インスタンスタイプ
    instance_type = "m5.xlarge"

    # 設定内容: インスタンス数
    # 省略時: 1
    instance_count = 2

    # 設定内容: インスタンスグループの表示名
    # name = "core-group"

    # 設定内容: スポットインスタンス入札価格（USD）
    # 注意: 設定するとスポットインスタンスとして起動
    # bid_price = "0.30"

    # 設定内容: 自動スケーリングポリシーJSON
    # autoscaling_policy = jsonencode({
    #   Constraints = {
    #     MinCapacity = 1
    #     MaxCapacity = 5
    #   }
    #   Rules = [
    #     {
    #       Name   = "ScaleOutMemoryPercentage"
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
    #           Period = 300
    #           Threshold = 15.0
    #           Statistic = "AVERAGE"
    #           Unit = "PERCENT"
    #         }
    #       }
    #     }
    #   ]
    # })

    # 設定内容: EBS設定
    ebs_config {
      # 設定内容: ボリュームサイズ（GiB）
      size = 100

      # 設定内容: ボリュームタイプ
      # 設定可能な値: gp3, gp2, io1, io2, standard, st1, sc1
      type = "gp3"

      # 設定内容: IOPS値
      # 設定可能な値: io1, io2, gp3の場合に指定可能
      # iops = 3000

      # 設定内容: スループット（MiB/s）
      # 設定可能な値: gp3の場合に指定可能
      # throughput = 125

      # 設定内容: インスタンスあたりのボリューム数
      # 省略時: 1
      # volumes_per_instance = 1
    }
  }

  #---------------------------------------
  # マスターインスタンスフリート設定（代替）
  #---------------------------------------
  # 注意: master_instance_groupまたはmaster_instance_fleetのいずれかを選択
  # master_instance_fleet {
  #   # 設定内容: フリートの表示名
  #   name = "master-fleet"
  #
  #   # 設定内容: オンデマンドインスタンスのターゲット容量
  #   target_on_demand_capacity = 1
  #
  #   # 設定内容: スポットインスタンスのターゲット容量
  #   # target_spot_capacity = 1
  #
  #   # 設定内容: インスタンスタイプ設定
  #   instance_type_configs {
  #     # 設定内容: インスタンスタイプ
  #     instance_type = "m5.xlarge"
  #
  #     # 設定内容: 加重容量
  #     # weighted_capacity = 1
  #
  #     # 設定内容: スポット入札価格（USD）
  #     # bid_price = "0.30"
  #
  #     # 設定内容: オンデマンド価格に対するスポット入札価格の割合（%）
  #     # 省略時: 100%
  #     # bid_price_as_percentage_of_on_demand_price = 80
  #
  #     # 設定内容: EBS設定
  #     ebs_config {
  #       size = 100
  #       type = "gp3"
  #       # iops = 3000
  #       # volumes_per_instance = 1
  #     }
  #
  #     # 設定内容: 設定分類
  #     # configurations {
  #     #   classification = "hadoop-env"
  #     #   properties = {
  #     #     "JAVA_HOME" = "/usr/lib/jvm/java-1.8.0"
  #     #   }
  #     # }
  #   }
  #
  #   # 設定内容: 起動仕様
  #   launch_specifications {
  #     # 設定内容: オンデマンド仕様
  #     # on_demand_specification {
  #     #   # 設定内容: アロケーション戦略
  #     #   # 設定可能な値: lowest-price
  #     #   allocation_strategy = "lowest-price"
  #     # }
  #
  #     # 設定内容: スポット仕様
  #     # spot_specification {
  #     #   # 設定内容: アロケーション戦略
  #     #   # 設定可能な値: capacity-optimized, diversified, lowest-price, price-capacity-optimized
  #     #   allocation_strategy = "capacity-optimized"
  #     #
  #     #   # 設定内容: タイムアウト時のアクション
  #     #   # 設定可能な値: TERMINATE_CLUSTER, SWITCH_TO_ON_DEMAND
  #     #   timeout_action = "SWITCH_TO_ON_DEMAND"
  #     #
  #     #   # 設定内容: スポットプロビジョニングタイムアウト時間（分）
  #     #   # 設定可能な値: 5〜1440
  #     #   timeout_duration_minutes = 10
  #     #
  #     #   # 設定内容: ブロック期間（分）
  #     #   # 設定可能な値: 60, 120, 180, 240, 300, 360
  #     #   # block_duration_minutes = 60
  #     # }
  #   }
  # }

  #---------------------------------------
  # コアインスタンスフリート設定（代替）
  #---------------------------------------
  # 注意: core_instance_groupまたはcore_instance_fleetのいずれかを選択
  # core_instance_fleet {
  #   # 設定内容: フリートの表示名
  #   name = "core-fleet"
  #
  #   # 設定内容: オンデマンドインスタンスのターゲット容量
  #   target_on_demand_capacity = 2
  #
  #   # 設定内容: スポットインスタンスのターゲット容量
  #   target_spot_capacity = 2
  #
  #   # 設定内容: インスタンスタイプ設定
  #   instance_type_configs {
  #     instance_type = "m5.xlarge"
  #     weighted_capacity = 1
  #     bid_price_as_percentage_of_on_demand_price = 80
  #
  #     ebs_config {
  #       size = 100
  #       type = "gp3"
  #     }
  #   }
  #
  #   # 設定内容: 複数のインスタンスタイプ設定を追加可能
  #   instance_type_configs {
  #     instance_type = "m5.2xlarge"
  #     weighted_capacity = 2
  #     bid_price_as_percentage_of_on_demand_price = 100
  #
  #     ebs_config {
  #       size = 100
  #       type = "gp3"
  #     }
  #   }
  #
  #   # 設定内容: 起動仕様
  #   launch_specifications {
  #     spot_specification {
  #       allocation_strategy = "capacity-optimized"
  #       timeout_action = "SWITCH_TO_ON_DEMAND"
  #       timeout_duration_minutes = 10
  #     }
  #   }
  # }

  #---------------------------------------
  # ブートストラップアクション
  #---------------------------------------
  # 設定内容: Hadoop起動前に実行するスクリプト
  # bootstrap_action {
  #   # 設定内容: ブートストラップアクションの名前
  #   name = "install-custom-tools"
  #
  #   # 設定内容: スクリプトの場所（S3 URIまたはローカルパス）
  #   path = "s3://my-emr-scripts/bootstrap.sh"
  #
  #   # 設定内容: スクリプトに渡すコマンドライン引数
  #   # args = ["arg1", "arg2"]
  # }

  #---------------------------------------
  # 設定分類（構造化設定）
  #---------------------------------------
  # 設定内容: アプリケーション設定のリスト
  # 注意: configurationsまたはconfigurations_jsonのいずれかを使用
  configurations = null
  # configurations = <<EOF
  # [
  #   {
  #     "Classification": "hadoop-env",
  #     "Configurations": [
  #       {
  #         "Classification": "export",
  #         "Properties": {
  #           "JAVA_HOME": "/usr/lib/jvm/java-1.8.0"
  #         }
  #       }
  #     ],
  #     "Properties": {}
  #   }
  # ]
  # EOF

  # 設定内容: アプリケーション設定のJSON文字列
  # 注意: configurations_jsonを使う場合、空配列は指定せずフィールドごと省略
  configurations_json = null
  # configurations_json = jsonencode([
  #   {
  #     Classification = "spark-defaults"
  #     Properties = {
  #       "spark.executor.memory" = "4g"
  #       "spark.executor.cores" = "2"
  #     }
  #   }
  # ])

  #---------------------------------------
  # ステップ定義
  #---------------------------------------
  # 設定内容: クラスター作成時に実行するステップ
  # 注意: 外部管理する場合lifecycle ignore_changesの使用を推奨
  step = []
  # step = [
  #   {
  #     # 設定内容: ステップ名
  #     name = "Setup Hadoop Debugging"
  #
  #     # 設定内容: 失敗時のアクション
  #     # 設定可能な値: TERMINATE_JOB_FLOW, TERMINATE_CLUSTER, CANCEL_AND_WAIT, CONTINUE
  #     action_on_failure = "TERMINATE_CLUSTER"
  #
  #     # 設定内容: Hadoop JARステップ
  #     hadoop_jar_step = [
  #       {
  #         # 設定内容: 実行するJARファイルのパス
  #         jar = "command-runner.jar"
  #
  #         # 設定内容: JARのmain関数に渡す引数
  #         args = ["state-pusher-script"]
  #
  #         # 設定内容: メインクラス名
  #         # 省略時: JARファイルのマニフェストで指定されたMain-Classを使用
  #         main_class = null
  #         # main_class = "com.example.MainClass"
  #
  #         # 設定内容: ステップ実行時に設定するJavaプロパティ
  #         properties = null
  #         # properties = {
  #         #   "mapred.tasktracker.map.tasks.maximum" = "2"
  #         # }
  #       }
  #     ]
  #   }
  # ]

  #---------------------------------------
  # Kerberos設定
  #---------------------------------------
  # kerberos_attributes {
  #   # 設定内容: Kerberosレルム名
  #   realm = "EC2.INTERNAL"
  #
  #   # 設定内容: KDC管理者パスワード
  #   # 注意: Terraformでドリフト検出不可
  #   kdc_admin_password = "MyKdcAdminPassword"
  #
  #   # 設定内容: クロスレルム信頼プリンシパルパスワード
  #   # 注意: クロスレルム信頼確立時のみ必須、Terraformでドリフト検出不可
  #   # cross_realm_trust_principal_password = "MyCrossRealmPassword"
  #
  #   # 設定内容: Active Directoryドメイン参加ユーザー
  #   # 注意: クロスレルム信頼確立時のみ必須、Terraformでドリフト検出不可
  #   # ad_domain_join_user = "Administrator"
  #
  #   # 設定内容: Active Directoryドメイン参加パスワード
  #   # 注意: クロスレルム信頼確立時のみ必須、Terraformでドリフト検出不可
  #   # ad_domain_join_password = "MyAdPassword"
  # }

  #---------------------------------------
  # プレイスメントグループ設定
  #---------------------------------------
  placement_group_config = []
  # placement_group_config = [
  #   {
  #     # 設定内容: インスタンスのロール
  #     # 設定可能な値: MASTER, CORE, TASK
  #     instance_role = "MASTER"
  #
  #     # 設定内容: プレイスメント戦略
  #     # 設定可能な値: SPREAD, PARTITION, CLUSTER, NONE
  #     placement_strategy = null
  #     # placement_strategy = "SPREAD"
  #   }
  # ]

  #---------------------------------------
  # ライフサイクル管理
  #---------------------------------------
  # lifecycle {
  #   # ステップを外部で管理する場合の設定
  #   ignore_changes = [step]
  # }
}

#---------------------------------------
# Attributes Reference
#---------------------------------------
# arn                           - EMRクラスターのARN
# id                            - クラスターID
# name                          - クラスター名
# cluster_state                 - クラスターの現在の状態
# master_public_dns             - マスターノードのDNS名（プライベートサブネットではプライベートDNS）
# release_label                 - EMRリリースラベル
# service_role                  - EMRサービスロール
# log_uri                       - ログの保存先S3パス
# applications                  - インストール済みアプリケーションリスト
# bootstrap_action              - 実行されたブートストラップアクション
# configurations                - 設定されたアプリケーション設定
# ec2_attributes                - EC2インスタンスの情報（キー名、サブネットID、IAMプロファイル等）
# core_instance_group.0.id      - コアノードインスタンスグループID
# master_instance_group.0.id    - マスターノードインスタンスグループID
# tags_all                      - プロバイダーdefault_tagsを含む全タグ
