#---------------------------------------------------------------
# AWS ECS Service
#---------------------------------------------------------------
#
# Amazon Elastic Container Service (ECS) のサービスを管理するリソースです。
# ECSサービスは、指定されたタスク定義のインスタンスを指定された数だけ
# 起動・維持し、ロードバランサーやサービスディスカバリーとの統合、
# デプロイメント戦略の制御などを行います。
#
# 主な機能:
#   - タスクの起動と維持（REPLICA/DAEMONスケジューリング戦略）
#   - ロードバランサーとの統合（ALB/NLB/CLB）
#   - サービスディスカバリー（AWS Cloud Map）
#   - デプロイメント戦略（ローリング/Blue-Green/カナリア/リニア）
#   - キャパシティプロバイダー戦略によるタスク配置
#   - サーキットブレーカーによる自動ロールバック
#   - VPC Lattice統合
#
# Note: サービス削除時の競合状態を防ぐため、関連する aws_iam_role_policy に
#       depends_on を設定してください。ポリシーが早期に削除されると、
#       サービスがDRAINING状態でスタックする可能性があります。
#
# AWS公式ドキュメント:
#   - ECSサービス: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs_services.html
#   - サービスロードバランシング: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/service-load-balancing.html
#   - サービスディスカバリー: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/service-discovery.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_service
#
# Provider Version: 6.36.0
# Generated: 2026-03-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_ecs_service" "example" {
  #-------------------------------------------------------------
  # 必須設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: サービスの名前を指定します。
  # 設定可能な値: 255文字以内の英字、数字、ハイフン、アンダースコア
  name = "example-service"

  #-------------------------------------------------------------
  # クラスター設定
  #-------------------------------------------------------------

  # cluster (Optional)
  # 設定内容: サービスを実行するECSクラスターのARNを指定します。
  # 設定可能な値: 有効なECSクラスターのARN
  # 省略時: デフォルトクラスターを使用
  cluster = "arn:aws:ecs:ap-northeast-1:123456789012:cluster/example-cluster"

  #-------------------------------------------------------------
  # タスク定義設定
  #-------------------------------------------------------------

  # task_definition (Optional)
  # 設定内容: サービスで実行するタスク定義を指定します。
  # 設定可能な値: "family:revision" 形式、または完全なARN
  # 省略時: EXTERNAL デプロイメントコントローラーを使用する場合は不要
  # 注意: リビジョンを指定しない場合、最新のACTIVEリビジョンが使用されます。
  task_definition = "example-task:1"

  #-------------------------------------------------------------
  # タスク数・スケジューリング設定
  #-------------------------------------------------------------

  # desired_count (Optional)
  # 設定内容: 起動・維持するタスクのインスタンス数を指定します。
  # 設定可能な値: 0以上の整数
  # 省略時: 0
  # 注意: DAEMONスケジューリング戦略を使用する場合は指定しないでください。
  desired_count = 2

  # scheduling_strategy (Optional)
  # 設定内容: サービスのスケジューリング戦略を指定します。
  # 設定可能な値:
  #   - "REPLICA": 指定された数のタスクを維持（デフォルト）
  #   - "DAEMON": 各コンテナインスタンスで1タスクを実行
  # 省略時: "REPLICA"
  # 注意: Fargate起動タイプ、CODE_DEPLOY、EXTERNALデプロイメントコントローラーを使用する場合は
  #       DAEMONスケジューリング戦略はサポートされません。
  # 参考: https://docs.aws.amazon.com/AmazonECS/latest/APIReference/API_CreateService.html
  scheduling_strategy = "REPLICA"

  # availability_zone_rebalancing (Optional)
  # 設定内容: アベイラビリティーゾーン間でのタスク再配分を有効化するかを指定します。
  # 設定可能な値:
  #   - "ENABLED": AZ間の自動タスク再配分を有効化
  #   - "DISABLED": AZ間の自動タスク再配分を無効化
  # 省略時: 新規サービス作成時は "ENABLED"（サービスが対応している場合）
  #        既存サービス更新時は現在の設定を維持
  # 関連機能: インフラストラクチャ障害やタスクライフサイクルアクティビティによる
  #          アプリケーション可用性の低下リスクを軽減します。
  availability_zone_rebalancing = null

  #-------------------------------------------------------------
  # 起動タイプ設定
  #-------------------------------------------------------------

  # launch_type (Optional)
  # 設定内容: タスクを実行する起動タイプを指定します。
  # 設定可能な値:
  #   - "EC2": EC2インスタンス上で実行
  #   - "FARGATE": Fargateサーバーレスコンピューティング上で実行
  #   - "EXTERNAL": 外部インスタンス（ECS Anywhere）上で実行
  # 省略時: "EC2"
  # 注意: capacity_provider_strategy と同時に指定できません。
  launch_type = "FARGATE"

  # platform_version (Optional)
  # 設定内容: Fargateプラットフォームバージョンを指定します。
  # 設定可能な値: Fargateプラットフォームバージョン（例: "LATEST", "1.4.0"）
  # 省略時: "LATEST"
  # 注意: launch_type が "FARGATE" の場合のみ適用されます。
  # 参考: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/platform_versions.html
  platform_version = "LATEST"

  #-------------------------------------------------------------
  # デプロイメント設定
  #-------------------------------------------------------------

  # deployment_maximum_percent (Optional)
  # 設定内容: デプロイメント中に実行可能なタスクの最大数をdesired_countのパーセンテージで指定します。
  # 設定可能な値: 0-200の整数（パーセンテージ）
  # 省略時: サービスのデフォルト値
  # 注意: DAEMONスケジューリング戦略を使用する場合は無効です。
  deployment_maximum_percent = 200

  # deployment_minimum_healthy_percent (Optional)
  # 設定内容: デプロイメント中に実行・正常状態を保つべきタスクの最小数をdesired_countのパーセンテージで指定します。
  # 設定可能な値: 0-100の整数（パーセンテージ）
  # 省略時: サービスのデフォルト値
  deployment_minimum_healthy_percent = 100

  # force_new_deployment (Optional)
  # 設定内容: 適用のたびに強制的に新しいデプロイメントを実行するかを指定します。
  # 設定可能な値: true または false
  # 省略時: false
  # 関連機能:
  #   - 同じイメージ/タグの組み合わせで新しいDockerイメージを使用
  #   - Fargateタスクを新しいプラットフォームバージョンに移行
  #   - ordered_placement_strategy や placement_constraints の更新を即座に反映
  force_new_deployment = false

  # sigint_rollback (Optional)
  # 設定内容: SIGINT シグナルを使用したデプロイメントの安全な中断とロールバックを有効化するかを指定します。
  # 設定可能な値: true または false
  # 省略時: false
  # 注意: ECSデプロイメントコントローラーを使用し、wait_for_steady_state = true の場合のみ適用されます。
  # 関連機能: 進行中のデプロイメントを安全にキャンセルし、自動的に前の安定した状態にロールバックします。
  sigint_rollback = false

  # wait_for_steady_state (Optional)
  # 設定内容: サービスが安定状態に到達するまでTerraformが待機するかを指定します。
  # 設定可能な値: true または false
  # 省略時: false
  # 関連機能: aws ecs wait services-stable コマンドと同等の動作を提供します。
  # 参考: https://docs.aws.amazon.com/cli/latest/reference/ecs/wait/services-stable.html
  wait_for_steady_state = false

  #-------------------------------------------------------------
  # ロードバランサー設定
  #-------------------------------------------------------------

  # health_check_grace_period_seconds (Optional)
  # 設定内容: 新しく起動されたタスクのロードバランサーヘルスチェック失敗を無視する期間（秒）を指定します。
  # 設定可能な値: 0-2147483647の整数
  # 省略時: ヘルスチェックグレースピリオドなし
  # 注意: ロードバランサーを使用するサービスの場合のみ有効です。
  health_check_grace_period_seconds = 60

  # iam_role (Optional)
  # 設定内容: ロードバランサーへの呼び出しを可能にするIAMロールのARNを指定します。
  # 設定可能な値: 有効なIAMロールのARN
  # 省略時: アカウントのECSサービスリンクロールを使用
  # 注意: タスク定義が awsvpc ネットワークモードを使用する場合は指定しないでください。
  #       awsvpc モードの場合、このロールは不要です。
  iam_role = null

  #-------------------------------------------------------------
  # タグ・メタデータ設定
  #-------------------------------------------------------------

  # enable_ecs_managed_tags (Optional)
  # 設定内容: サービス内のタスクにAmazon ECS管理タグを有効化するかを指定します。
  # 設定可能な値: true または false
  # 省略時: false
  enable_ecs_managed_tags = false

  # propagate_tags (Optional)
  # 設定内容: タスク定義またはサービスからタスクへのタグ伝播を有効化するかを指定します。
  # 設定可能な値:
  #   - "SERVICE": サービスのタグをタスクに伝播
  #   - "TASK_DEFINITION": タスク定義のタグをタスクに伝播
  # 省略時: タグは伝播されません
  propagate_tags = null

  #-------------------------------------------------------------
  # ECS Exec設定
  #-------------------------------------------------------------

  # enable_execute_command (Optional)
  # 設定内容: サービス内のタスクでAmazon ECS Exec機能を有効化するかを指定します。
  # 設定可能な値: true または false
  # 省略時: false
  # 関連機能: ECS Exec
  #   実行中のコンテナに対してインタラクティブなシェルまたは
  #   単一コマンドを実行できる機能を提供します。
  enable_execute_command = false

  #-------------------------------------------------------------
  # サービス削除設定
  #-------------------------------------------------------------

  # force_delete (Optional)
  # 設定内容: タスクを0にスケールダウンせずにサービスを削除できるようにするかを指定します。
  # 設定可能な値: true または false
  # 省略時: false
  # 注意: REPLICAスケジューリング戦略を使用するサービスの場合のみ必要です。
  force_delete = false

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
  # トリガー設定
  #-------------------------------------------------------------

  # triggers (Optional)
  # 設定内容: 変更時にその場で更新（再デプロイ）をトリガーする任意のキーと値のマップを指定します。
  # 設定可能な値: 文字列のキーと値のマップ
  # 関連機能: plantimestamp() などの関数と組み合わせて、毎回再デプロイを強制できます。
  # 例: triggers = { redeployment = plantimestamp() }
  triggers = null

  #-------------------------------------------------------------
  # キャパシティプロバイダー戦略設定
  #-------------------------------------------------------------

  # capacity_provider_strategy {
  #   # capacity_provider (Required)
  #   # 設定内容: 使用するキャパシティプロバイダーの短縮名を指定します。
  #   # 設定可能な値: 有効なキャパシティプロバイダー名
  #   capacity_provider = "FARGATE"
  #
  #   # base (Optional)
  #   # 設定内容: 指定したキャパシティプロバイダーで実行する最小タスク数を指定します。
  #   # 設定可能な値: 0以上の整数
  #   # 省略時: 0
  #   # 注意: キャパシティプロバイダー戦略内で1つのキャパシティプロバイダーのみがbase定義を持てます。
  #   base = 1
  #
  #   # weight (Optional)
  #   # 設定内容: 起動されたタスクの総数に対する相対的なパーセンテージを指定します。
  #   # 設定可能な値: 0-1000の整数
  #   # 省略時: 0
  #   weight = 100
  # }
  #
  # # 注意: launch_type と同時に指定できません。
  # # 関連機能: force_new_deployment = true が必要です。

  #-------------------------------------------------------------
  # ネットワーク設定
  #-------------------------------------------------------------

  network_configuration {
    # subnets (Required)
    # 設定内容: タスクまたはサービスに関連付けるサブネットのIDを指定します。
    # 設定可能な値: サブネットIDのセット
    subnets = ["subnet-12345678", "subnet-87654321"]

    # security_groups (Optional)
    # 設定内容: タスクまたはサービスに関連付けるセキュリティグループのIDを指定します。
    # 設定可能な値: セキュリティグループIDのセット
    # 省略時: VPCのデフォルトセキュリティグループを使用
    security_groups = ["sg-12345678"]

    # assign_public_ip (Optional)
    # 設定内容: ENIにパブリックIPアドレスを割り当てるかを指定します。
    # 設定可能な値: true または false
    # 省略時: false
    # 注意: Fargate起動タイプの場合のみ有効です。
    assign_public_ip = false
  }

  # 参考: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task-networking.html

  #-------------------------------------------------------------
  # ロードバランサー統合
  #-------------------------------------------------------------

  # load_balancer {
  #   # container_name (Required)
  #   # 設定内容: ロードバランサーに関連付けるコンテナの名前を指定します。
  #   # 設定可能な値: タスク定義に定義されたコンテナ名
  #   container_name = "web"
  #
  #   # container_port (Required)
  #   # 設定内容: ロードバランサーに関連付けるコンテナのポート番号を指定します。
  #   # 設定可能な値: 1-65535の整数
  #   container_port = 80
  #
  #   # target_group_arn (Optional)
  #   # 設定内容: サービスに関連付けるロードバランサーターゲットグループのARNを指定します。
  #   # 設定可能な値: 有効なターゲットグループのARN
  #   # 注意: ALB/NLBの場合に必須です。
  #   target_group_arn = "arn:aws:elasticloadbalancing:ap-northeast-1:123456789012:targetgroup/example/1234567890123456"
  #
  #   # elb_name (Optional)
  #   # 設定内容: サービスに関連付けるELB（Classic）の名前を指定します。
  #   # 設定可能な値: 有効なELB名
  #   # 注意: ELB Classicの場合に必須です。
  #   elb_name = null
  #
  #   #-----------------------------------------------------------
  #   # Blue/Greenデプロイメント高度な設定
  #   #-----------------------------------------------------------
  #   # advanced_configuration {
  #   #   # alternate_target_group_arn (Required)
  #   #   # 設定内容: Blue/Greenデプロイメントで使用する代替ターゲットグループのARNを指定します。
  #   #   alternate_target_group_arn = "arn:aws:elasticloadbalancing:ap-northeast-1:123456789012:targetgroup/example-alternate/1234567890123456"
  #   #
  #   #   # production_listener_rule (Required)
  #   #   # 設定内容: 本番トラフィックをルーティングするリスナールールのARNを指定します。
  #   #   production_listener_rule = "arn:aws:elasticloadbalancing:ap-northeast-1:123456789012:listener-rule/app/example/1234567890123456/1234567890123456/1234567890123456"
  #   #
  #   #   # role_arn (Required)
  #   #   # 設定内容: ECSがターゲットグループを管理できるようにするIAMロールのARNを指定します。
  #   #   role_arn = "arn:aws:iam::123456789012:role/ecsServiceRole"
  #   #
  #   #   # test_listener_rule (Optional)
  #   #   # 設定内容: テストトラフィックをルーティングするリスナールールのARNを指定します。
  #   #   test_listener_rule = null
  #   # }
  # }
  #
  # # Note: 複数のロードバランサーをサポートしています（Provider version 2.22.0以降）。
  # #       ECSサービスは複数のターゲットグループをサポートします。
  # # 参考: https://aws.amazon.com/about-aws/whats-new/2019/07/amazon-ecs-services-now-support-multiple-load-balancer-target-groups/

  #-------------------------------------------------------------
  # サービスディスカバリー設定
  #-------------------------------------------------------------

  # service_registries {
  #   # registry_arn (Required)
  #   # 設定内容: サービスレジストリのARNを指定します。
  #   # 設定可能な値: Route 53 Auto Naming Service（aws_service_discovery_service）のARN
  #   # 参考: https://docs.aws.amazon.com/Route53/latest/APIReference/API_autonaming_Service.html
  #   registry_arn = "arn:aws:servicediscovery:ap-northeast-1:123456789012:service/srv-12345678"
  #
  #   # container_name (Optional)
  #   # 設定内容: サービスディスカバリーサービスに使用するコンテナ名を指定します。
  #   # 設定可能な値: タスク定義で既に指定されているコンテナ名
  #   container_name = null
  #
  #   # container_port (Optional)
  #   # 設定内容: サービスディスカバリーサービスに使用するポート値を指定します。
  #   # 設定可能な値: タスク定義で既に指定されているポート値
  #   container_port = null
  #
  #   # port (Optional)
  #   # 設定内容: Service Discovery サービスがSRVレコードを指定している場合に使用するポート値を指定します。
  #   port = null
  # }

  #-------------------------------------------------------------
  # タスク配置戦略設定
  #-------------------------------------------------------------

  # ordered_placement_strategy {
  #   # type (Required)
  #   # 設定内容: 配置戦略のタイプを指定します。
  #   # 設定可能な値:
  #   #   - "binpack": メモリまたはCPUの使用率を最小化
  #   #   - "random": ランダムに配置
  #   #   - "spread": 指定した値に基づいて均等に分散
  #   type = "spread"
  #
  #   # field (Optional)
  #   # 設定内容: 配置戦略を適用するフィールドを指定します。
  #   # 設定可能な値:
  #   #   - spread戦略の場合: "instanceId"（または"host"、同じ効果）、
  #   #     またはコンテナインスタンスに適用されるプラットフォーム属性またはカスタム属性
  #   #   - binpack戦略の場合: "memory" または "cpu"
  #   #   - random戦略の場合: この属性は不要
  #   # 省略時: 戦略のタイプによって異なる
  #   # 参考: https://docs.aws.amazon.com/AmazonECS/latest/APIReference/API_PlacementStrategy.html
  #   field = "attribute:ecs.availability-zone"
  # }
  #
  # # 注意: 最大5個の ordered_placement_strategy ブロックを指定できます。
  # #       リストは上から下へ優先度順に考慮されます。
  # #       force_new_deployment = true で更新を次のタスクデプロイメントで反映できます。

  #-------------------------------------------------------------
  # タスク配置制約設定
  #-------------------------------------------------------------

  # placement_constraints {
  #   # type (Required)
  #   # 設定内容: 制約のタイプを指定します。
  #   # 設定可能な値:
  #   #   - "memberOf": Cluster Query Languageで指定したクラスター内のインスタンスにタスクを配置
  #   #   - "distinctInstance": 各タスクを異なるコンテナインスタンスに配置
  #   type = "memberOf"
  #
  #   # expression (Optional)
  #   # 設定内容: 制約に適用するCluster Query Language式を指定します。
  #   # 設定可能な値: Cluster Query Language式の文字列
  #   # 省略時: distinctInstance タイプの場合は不要
  #   # 参考: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/cluster-query-language.html
  #   expression = "attribute:ecs.instance-type =~ t2.*"
  # }
  #
  # # 注意: 最大10個の placement_constraints ブロックを指定できます。
  # #       force_new_deployment = true で更新を次のタスクデプロイメントで反映できます。

  #-------------------------------------------------------------
  # デプロイメント設定ブロック
  #-------------------------------------------------------------

  # deployment_configuration {
  #   # strategy (Optional)
  #   # 設定内容: デプロイメント戦略のタイプを指定します。
  #   # 設定可能な値:
  #   #   - "ROLLING": ローリング更新（デフォルト）
  #   #   - "BLUE_GREEN": Blue/Greenデプロイメント
  #   #   - "LINEAR": リニアデプロイメント
  #   #   - "CANARY": カナリアデプロイメント
  #   # 省略時: "ROLLING"
  #   strategy = "ROLLING"
  #
  #   # bake_time_in_minutes (Optional)
  #   # 設定内容: 新しいデプロイメントが完全にプロビジョニングされた後、古いデプロイメントを終了するまでの待機時間（分）を指定します。
  #   # 設定可能な値: 0-1440の整数
  #   # 省略時: 0
  #   # 注意: BLUE_GREEN、LINEAR、CANARY戦略で使用されます。
  #   bake_time_in_minutes = null
  #
  #   #-----------------------------------------------------------
  #   # カナリア設定
  #   #-----------------------------------------------------------
  #   # canary_configuration {
  #   #   # canary_percent (Required)
  #   #   # 設定内容: カナリアデプロイメントにルーティングするトラフィックのパーセンテージを指定します。
  #   #   # 設定可能な値: 0.1-100.0の数値
  #   #   canary_percent = 10.0
  #   #
  #   #   # canary_bake_time_in_minutes (Optional)
  #   #   # 設定内容: すべてのトラフィックを新しいデプロイメントにシフトする前に待機する時間（分）を指定します。
  #   #   # 設定可能な値: 0-1440の整数
  #   #   # 省略時: 0
  #   #   canary_bake_time_in_minutes = 5
  #   # }
  #   #
  #   # # 注意: strategy = "CANARY" の場合に必須です。
  #
  #   #-----------------------------------------------------------
  #   # リニア設定
  #   #-----------------------------------------------------------
  #   # linear_configuration {
  #   #   # step_percent (Required)
  #   #   # 設定内容: リニアデプロイメント中に各ステップでシフトするトラフィックのパーセンテージを指定します。
  #   #   # 設定可能な値: 3.0-100.0の数値
  #   #   step_percent = 25.0
  #   #
  #   #   # step_bake_time_in_minutes (Optional)
  #   #   # 設定内容: リニアデプロイメント中に各ステップ間で待機する時間（分）を指定します。
  #   #   # 設定可能な値: 0-1440の整数
  #   #   # 省略時: 0
  #   #   step_bake_time_in_minutes = 5
  #   # }
  #   #
  #   # # 注意: strategy = "LINEAR" の場合に必須です。
  #
  #   #-----------------------------------------------------------
  #   # ライフサイクルフック設定
  #   #-----------------------------------------------------------
  #   # lifecycle_hook {
  #   #   # hook_target_arn (Required)
  #   #   # 設定内容: ライフサイクルフックで呼び出すLambda関数のARNを指定します。
  #   #   hook_target_arn = "arn:aws:lambda:ap-northeast-1:123456789012:function:example-lifecycle-hook"
  #   #
  #   #   # lifecycle_stages (Required)
  #   #   # 設定内容: フックを呼び出すデプロイメント中のステージを指定します。
  #   #   # 設定可能な値:
  #   #   #   - "RECONCILE_SERVICE": サービスの調整
  #   #   #   - "PRE_SCALE_UP": スケールアップ前
  #   #   #   - "POST_SCALE_UP": スケールアップ後
  #   #   #   - "TEST_TRAFFIC_SHIFT": テストトラフィックシフト
  #   #   #   - "POST_TEST_TRAFFIC_SHIFT": テストトラフィックシフト後
  #   #   #   - "PRODUCTION_TRAFFIC_SHIFT": 本番トラフィックシフト
  #   #   #   - "POST_PRODUCTION_TRAFFIC_SHIFT": 本番トラフィックシフト後
  #   #   lifecycle_stages = ["PRE_SCALE_UP"]
  #   #
  #   #   # role_arn (Required)
  #   #   # 設定内容: サービスがLambda関数を呼び出す権限を付与するIAMロールのARNを指定します。
  #   #   role_arn = "arn:aws:iam::123456789012:role/ecsEventsRole"
  #   #
  #   #   # hook_details (Optional)
  #   #   # 設定内容: Amazon ECSがフックターゲット呼び出し（Lambda関数など）に渡すカスタムパラメータを指定します。
  #   #   hook_details = null
  #   # }
  # }

  #-------------------------------------------------------------
  # デプロイメントコントローラー設定
  #-------------------------------------------------------------

  # deployment_controller {
  #   # type (Optional)
  #   # 設定内容: デプロイメントコントローラーのタイプを指定します。
  #   # 設定可能な値:
  #   #   - "CODE_DEPLOY": AWS CodeDeployを使用
  #   #   - "ECS": Amazon ECSのローリング更新を使用（デフォルト）
  #   #   - "EXTERNAL": 外部デプロイメントコントローラーを使用
  #   # 省略時: "ECS"
  #   type = "ECS"
  # }

  #-------------------------------------------------------------
  # サーキットブレーカー設定
  #-------------------------------------------------------------

  # deployment_circuit_breaker {
  #   # enable (Required)
  #   # 設定内容: サービスのデプロイメントサーキットブレーカーロジックを有効化するかを指定します。
  #   # 設定可能な値: true または false
  #   enable = true
  #
  #   # rollback (Required)
  #   # 設定内容: サービスデプロイメントが失敗した場合にAmazon ECSがサービスをロールバックするかを指定します。
  #   # 設定可能な値: true または false
  #   # 関連機能: ロールバックが有効な場合、デプロイメントが失敗すると、
  #   #          最後に正常に完了したデプロイメントにサービスがロールバックされます。
  #   rollback = true
  # }

  #-------------------------------------------------------------
  # CloudWatchアラーム設定
  #-------------------------------------------------------------

  # alarms {
  #   # enable (Required)
  #   # 設定内容: サービスデプロイメントプロセスでCloudWatchアラームオプションを使用するかを指定します。
  #   # 設定可能な値: true または false
  #   enable = true
  #
  #   # rollback (Required)
  #   # 設定内容: サービスデプロイメントが失敗した場合にAmazon ECSがサービスをロールバックするように設定するかを指定します。
  #   # 設定可能な値: true または false
  #   # 関連機能: ロールバックが有効な場合、デプロイメントが失敗すると、
  #   #          最後に正常に完了したデプロイメントにサービスがロールバックされます。
  #   rollback = true
  #
  #   # alarm_names (Required)
  #   # 設定内容: 監視する1つ以上のCloudWatchアラーム名を指定します。
  #   # 設定可能な値: CloudWatchアラーム名のセット
  #   alarm_names = ["example-alarm"]
  # }

  #-------------------------------------------------------------
  # サービスコネクト設定
  #-------------------------------------------------------------

  # service_connect_configuration {
  #   # enabled (Required)
  #   # 設定内容: このサービスでService Connectを使用するかを指定します。
  #   # 設定可能な値: true または false
  #   enabled = true
  #
  #   # namespace (Optional)
  #   # 設定内容: Service Connectで使用するService Discoveryの名前空間名またはARNを指定します。
  #   # 設定可能な値: aws_service_discovery_http_namespace の名前空間名またはARN
  #   # 省略時: Service Connectなしで動作
  #   namespace = null
  #
  #   #-----------------------------------------------------------
  #   # ログ設定
  #   #-----------------------------------------------------------
  #   # log_configuration {
  #   #   # log_driver (Required)
  #   #   # 設定内容: コンテナで使用するログドライバーを指定します。
  #   #   # 設定可能な値: "awslogs", "fluentd", "gelf", "json-file", "journald", "logentries", "splunk", "syslog"
  #   #   log_driver = "awslogs"
  #   #
  #   #   # options (Optional)
  #   #   # 設定内容: ログドライバーに送信する設定オプションを指定します。
  #   #   # 設定可能な値: キーと値のマップ
  #   #   # 省略時: 空のマップ
  #   #   options = {
  #   #     "awslogs-group"         = "/ecs/service-connect"
  #   #     "awslogs-region"        = "ap-northeast-1"
  #   #     "awslogs-stream-prefix" = "ecs"
  #   #   }
  #   #
  #   #   #---------------------------------------------------------
  #   #   # シークレットオプション
  #   #   #---------------------------------------------------------
  #   #   # secret_option {
  #   #   #   # name (Required)
  #   #   #   # 設定内容: シークレットの名前を指定します。
  #   #   #   name = "secret-name"
  #   #   #
  #   #   #   # value_from (Required)
  #   #   #   # 設定内容: コンテナに公開するシークレットを指定します。
  #   #   #   # 設定可能な値: AWS Secrets ManagerシークレットのフルARN、
  #   #   #   #              またはSSM Parameter StoreパラメータのフルARN
  #   #   #   value_from = "arn:aws:secretsmanager:ap-northeast-1:123456789012:secret:example-secret"
  #   #   # }
  #   # }
  #
  #   #-----------------------------------------------------------
  #   # アクセスログ設定
  #   #-----------------------------------------------------------
  #   # access_log_configuration {
  #   #   # format (Required)
  #   #   # 設定内容: Service Connectアクセスログの出力形式を指定します。
  #   #   # 設定可能な値: "TEXT", "JSON"
  #   #   # 参考: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/service-connect-envoy-access-logs.html
  #   #   format = "TEXT"
  #   #
  #   #   # include_query_parameters (Optional)
  #   #   # 設定内容: Service Connectアクセスログにクエリパラメータを含めるかを指定します。
  #   #   # 設定可能な値: "ENABLED", "DISABLED"
  #   #   # 省略時: "DISABLED"
  #   #   # 注意: アクセスログは log_configuration ブロックで指定されたログ送信先に配信されます。
  #   #   #       "ENABLED" にすると、リクエストID、トークン等のセンシティブ情報がログに含まれる可能性があります。
  #   #   include_query_parameters = "DISABLED"
  #   # }
  #
  #   #-----------------------------------------------------------
  #   # サービス設定
  #   #-----------------------------------------------------------
  #   # service {
  #   #   # port_name (Required)
  #   #   # 設定内容: このAmazon ECSサービスのタスク定義の portMappings の1つの名前を指定します。
  #   #   port_name = "http"
  #   #
  #   #   # discovery_name (Optional)
  #   #   # 設定内容: Amazon ECSがこのAmazon ECSサービス用に作成する新しいAWS Cloud Mapサービスの名前を指定します。
  #   #   # 省略時: port_name と同じ名前を使用
  #   #   discovery_name = null
  #   #
  #   #   # ingress_port_override (Optional)
  #   #   # 設定内容: Service Connectプロキシがリッスンするポート番号を指定します。
  #   #   ingress_port_override = null
  #   #
  #   #   #---------------------------------------------------------
  #   #   # クライアントエイリアス設定
  #   #   #---------------------------------------------------------
  #   #   # client_alias {
  #   #   #   # port (Required)
  #   #   #   # 設定内容: Service Connectプロキシのリスニングポート番号を指定します。
  #   #   #   #          このポートは同じ名前空間内のすべてのタスク内で利用可能です。
  #   #   #   port = 8080
  #   #   #
  #   #   #   # dns_name (Optional)
  #   #   #   # 設定内容: クライアントタスクのアプリケーションでこのサービスに接続するために使用する名前を指定します。
  #   #   #   # 省略時: discovery_name を使用
  #   #   #   dns_name = null
  #   #   #
  #   #   #   #-------------------------------------------------------
  #   #   #   # テストトラフィックルール設定
  #   #   #   #-------------------------------------------------------
  #   #   #   # test_traffic_rules {
  #   #   #   #   #-----------------------------------------------------
  #   #   #   #   # ヘッダー設定
  #   #   #   #   #-----------------------------------------------------
  #   #   #   #   # header {
  #   #   #   #   #   # name (Required)
  #   #   #   #   #   # 設定内容: 一致させるHTTPヘッダーの名前を指定します。
  #   #   #   #   #   name = "X-Test-Version"
  #   #   #   #   #
  #   #   #   #   #   #---------------------------------------------------
  #   #   #   #   #   # ヘッダー値設定
  #   #   #   #   #   #---------------------------------------------------
  #   #   #   #   #   # value {
  #   #   #   #   #   #   # exact (Required)
  #   #   #   #   #   #   # 設定内容: ヘッダーで一致させる正確な文字列値を指定します。
  #   #   #   #   #   #   exact = "v2"
  #   #   #   #   #   # }
  #   #   #   #   # }
  #   #   #   # }
  #   #   # }
  #   #
  #   #   #---------------------------------------------------------
  #   #   # タイムアウト設定
  #   #   #---------------------------------------------------------
  #   #   # timeout {
  #   #   #   # idle_timeout_seconds (Optional)
  #   #   #   # 設定内容: アイドル時に接続がアクティブな状態を維持する時間（秒）を指定します。
  #   #   #   # 設定可能な値: 整数、0を設定すると idleTimeout を無効化
  #   #   #   # 省略時: デフォルトのアイドルタイムアウトを使用
  #   #   #   idle_timeout_seconds = null
  #   #   #
  #   #   #   # per_request_timeout_seconds (Optional)
  #   #   #   # 設定内容: アップストリームがリクエストごとに完全なレスポンスを返すまでの時間（秒）を指定します。
  #   #   #   # 設定可能な値: 整数、0を設定すると perRequestTimeout を無効化
  #   #   #   # 省略時: デフォルトのリクエストタイムアウトを使用
  #   #   #   # 注意: appProtocol が TCP でない場合にのみ設定可能です。
  #   #   #   per_request_timeout_seconds = null
  #   #   # }
  #   #
  #   #   #---------------------------------------------------------
  #   #   # TLS設定
  #   #   #---------------------------------------------------------
  #   #   # tls {
  #   #   #   # kms_key (Optional)
  #   #   #   # 設定内容: Secrets Managerでプライベートキーを暗号化するために使用するKMSキーを指定します。
  #   #   #   kms_key = null
  #   #   #
  #   #   #   # role_arn (Optional)
  #   #   #   # 設定内容: Service Connect TLSに関連付けられたIAMロールのARNを指定します。
  #   #   #   role_arn = null
  #   #   #
  #   #   #   #-------------------------------------------------------
  #   #   #   # 発行者証明機関設定
  #   #   #   #-------------------------------------------------------
  #   #   #   # issuer_cert_authority {
  #   #   #   #   # aws_pca_authority_arn (Required)
  #   #   #   #   # 設定内容: TLS証明書を作成するために使用する aws_acmpca_certificate_authority のARNを指定します。
  #   #   #   #   aws_pca_authority_arn = "arn:aws:acm-pca:ap-northeast-1:123456789012:certificate-authority/12345678-1234-1234-1234-123456789012"
  #   #   #   # }
  #   #   # }
  #   # }
  # }

  #-------------------------------------------------------------
  # ボリューム設定
  #-------------------------------------------------------------

  # volume_configuration {
  #   # name (Required)
  #   # 設定内容: ボリュームの名前を指定します。
  #   name = "example-volume"
  #
  #   #-----------------------------------------------------------
  #   # 管理型EBSボリューム設定
  #   #-----------------------------------------------------------
  #   # managed_ebs_volume {
  #   #   # role_arn (Required)
  #   #   # 設定内容: AWSインフラストラクチャを管理するAmazon ECS インフラストラクチャIAMロールのARNを指定します。
  #   #   # 推奨: AmazonECSInfrastructureRolePolicyForVolumes IAMポリシーをこのロールに使用してください。
  #   #   role_arn = "arn:aws:iam::123456789012:role/ecsInfrastructureRole"
  #   #
  #   #   # encrypted (Optional)
  #   #   # 設定内容: ボリュームを暗号化するかを指定します。
  #   #   # 設定可能な値: true または false
  #   #   # 省略時: true
  #   #   encrypted = true
  #   #
  #   #   # file_system_type (Optional)
  #   #   # 設定内容: ボリュームのLinuxファイルシステムタイプを指定します。
  #   #   # 設定可能な値: "ext3", "ext4", "xfs"
  #   #   # 省略時: "xfs"
  #   #   # 注意: スナップショットから作成されたボリュームの場合、スナップショットが使用していた
  #   #   #       同じファイルシステムタイプを指定する必要があります。
  #   #   file_system_type = "xfs"
  #   #
  #   #   # iops (Optional)
  #   #   # 設定内容: 1秒あたりのI/O操作数（IOPS）を指定します。
  #   #   iops = null
  #   #
  #   #   # kms_key_id (Optional)
  #   #   # 設定内容: Amazon EBS暗号化に使用するAWS Key Management Serviceキーの識別子（ARN）を指定します。
  #   #   kms_key_id = null
  #   #
  #   #   # size_in_gb (Optional)
  #   #   # 設定内容: ボリュームのサイズ（GiB）を指定します。
  #   #   # 注意: size_in_gb または snapshot_id のいずれかを指定する必要があります。
  #   #   #       オプションで、スナップショットサイズ以上のボリュームサイズを指定できます。
  #   #   size_in_gb = null
  #   #
  #   #   # snapshot_id (Optional)
  #   #   # 設定内容: Amazon ECSがボリュームを作成するために使用するスナップショットを指定します。
  #   #   # 注意: size_in_gb または snapshot_id のいずれかを指定する必要があります。
  #   #   snapshot_id = null
  #   #
  #   #   # throughput (Optional)
  #   #   # 設定内容: ボリュームにプロビジョニングするスループット（MiB/s）を指定します。
  #   #   # 設定可能な値: 最大1,000 MiB/s
  #   #   throughput = null
  #   #
  #   #   # volume_initialization_rate (Optional)
  #   #   # 設定内容: ボリューム初期化レート（MiB/s）を指定します。
  #   #   # 注意: snapshot_id も指定する必要があります。
  #   #   volume_initialization_rate = null
  #   #
  #   #   # volume_type (Optional)
  #   #   # 設定内容: ボリュームタイプを指定します。
  #   #   # 設定可能な値: "gp2", "gp3", "io1", "io2", "sc1", "st1", "standard"
  #   #   volume_type = null
  #   #
  #   #   #---------------------------------------------------------
  #   #   # タグ仕様設定
  #   #   #---------------------------------------------------------
  #   #   # tag_specifications {
  #   #   #   # resource_type (Required)
  #   #   #   # 設定内容: ボリュームリソースのタイプを指定します。
  #   #   #   # 設定可能な値: "volume"
  #   #   #   resource_type = "volume"
  #   #   #
  #   #   #   # propagate_tags (Optional)
  #   #   #   # 設定内容: タスク定義からAmazon EBSボリュームにタグを伝播するかを指定します。
  #   #   #   # 設定可能な値: "TASK_DEFINITION", "SERVICE", "NONE"
  #   #   #   propagate_tags = null
  #   #   #
  #   #   #   # tags (Optional)
  #   #   #   # 設定内容: このAmazon EBSボリュームに適用するタグを指定します。
  #   #   #   # 注意: AmazonECSCreated および AmazonECSManaged は予約タグで使用できません。
  #   #   #   tags = {
  #   #   #     Name = "example-volume"
  #   #   #   }
  #   #   # }
  #   # }
  # }

  #-------------------------------------------------------------
  # VPC Lattice設定
  #-------------------------------------------------------------

  # vpc_lattice_configurations {
  #   # port_name (Required)
  #   # 設定内容: VPC Lattice設定に関連付けられたターゲットグループのポート名を指定します。
  #   port_name = "http"
  #
  #   # role_arn (Required)
  #   # 設定内容: AWSインフラストラクチャを管理するために使用されるAmazon ECS インフラストラクチャIAMロールのARNを指定します。
  #   role_arn = "arn:aws:iam::123456789012:role/ecsInfrastructureRole"
  #
  #   # target_group_arn (Required)
  #   # 設定内容: VPC Lattice設定に関連付けられたターゲットグループの完全なARNを指定します。
  #   target_group_arn = "arn:aws:vpc-lattice:ap-northeast-1:123456789012:targetgroup/tg-12345678901234567"
  # }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts {
  #   # create (Optional)
  #   # 設定内容: サービス作成のタイムアウトを指定します。
  #   # 省略時: デフォルトのタイムアウトを使用
  #   create = null
  #
  #   # update (Optional)
  #   # 設定内容: サービス更新のタイムアウトを指定します。
  #   # 省略時: デフォルトのタイムアウトを使用
  #   update = null
  #
  #   # delete (Optional)
  #   # 設定内容: サービス削除のタイムアウトを指定します。
  #   # 省略時: デフォルトのタイムアウトを使用
  #   delete = null
  # }

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
    Name        = "example-service"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: サービスを識別するARN
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
