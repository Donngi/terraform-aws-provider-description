#---------------------------------------------------------------
# AWS ECS Task Set
#---------------------------------------------------------------
#
# Amazon ECS (Elastic Container Service) のタスクセットをプロビジョニングするリソースです。
# タスクセットは、外部デプロイコントローラーを使用する場合にサービス内でタスクの
# グループを管理するために使用されます。Blue/Greenデプロイメントなどの
# デプロイメント戦略を実装する際に役立ちます。
#
# AWS公式ドキュメント:
#   - Amazon ECS タスクセット: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task-sets.html
#   - ECS デプロイメントタイプ: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/deployment-types.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_set
#
# Provider Version: 6.28.0
# Generated: 2026-01-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_ecs_task_set" "example" {
  #-------------------------------------------------------------
  # 必須設定
  #-------------------------------------------------------------

  # cluster (Required)
  # 設定内容: タスクセットを作成するECSクラスターの短縮名またはARNを指定します。
  # 設定可能な値: 有効なECSクラスター名またはARN
  cluster = "my-ecs-cluster"

  # service (Required)
  # 設定内容: タスクセットを作成するECSサービスの短縮名またはARNを指定します。
  # 設定可能な値: 有効なECSサービス名またはARN
  # 注意: サービスはEXTERNALデプロイメントコントローラータイプで作成されている必要があります
  service = "my-service"

  # task_definition (Required)
  # 設定内容: タスクセットで使用するタスク定義のファミリーとリビジョン（family:revision）
  #           またはタスク定義のARNを指定します。
  # 設定可能な値: タスク定義のファミリー:リビジョン形式またはARN
  task_definition = "my-task-definition:1"

  #-------------------------------------------------------------
  # 起動設定
  #-------------------------------------------------------------

  # launch_type (Optional)
  # 設定内容: タスクを起動するための起動タイプを指定します。
  # 設定可能な値:
  #   - "EC2": EC2インスタンス上でタスクを起動
  #   - "FARGATE": AWS Fargate上でタスクを起動
  #   - "EXTERNAL": 外部インフラストラクチャ上でタスクを起動
  # 省略時: capacity_provider_strategyが指定されていない場合は、サービスのデフォルト起動タイプが使用されます
  # 注意: capacity_provider_strategyと排他的（どちらか一方のみ指定可能）
  # 関連機能: Amazon ECS 起動タイプ
  #   タスクをホストするインフラストラクチャのタイプを決定します。
  #   - https://docs.aws.amazon.com/AmazonECS/latest/developerguide/launch_types.html
  launch_type = "FARGATE"

  # platform_version (Optional)
  # 設定内容: タスクで使用するプラットフォームバージョンを指定します。
  # 設定可能な値: プラットフォームバージョン番号（例: "1.4.0", "LATEST"）
  # 省略時: "LATEST"が使用されます
  # 注意: launch_typeが"FARGATE"の場合のみ指定可能
  # 関連機能: AWS Fargate プラットフォームバージョン
  #   Fargateタスクのランタイム環境のバージョンを指定します。
  #   - https://docs.aws.amazon.com/AmazonECS/latest/developerguide/platform_versions.html
  platform_version = "LATEST"

  #-------------------------------------------------------------
  # 識別設定
  #-------------------------------------------------------------

  # external_id (Optional)
  # 設定内容: タスクセットの外部IDを指定します。
  # 設定可能な値: 文字列
  # 省略時: AWSによって自動生成されます
  # 用途: 外部デプロイメントコントローラーがタスクセットを識別するために使用
  external_id = null

  # id (Optional)
  # 設定内容: リソースのIDを指定します。
  # 設定可能な値: 文字列
  # 省略時: Terraformによって自動生成されます
  # 注意: 通常は明示的に設定する必要はありません
  id = null

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
  # 待機設定
  #-------------------------------------------------------------

  # wait_until_stable (Optional)
  # 設定内容: タスクセットが安定状態になるまで待機するかを指定します。
  # 設定可能な値:
  #   - true: タスクセットが安定状態になるまでTerraformは待機します
  #   - false (デフォルト): 待機しません
  # 用途: デプロイメント完了を確実にしたい場合に使用
  wait_until_stable = false

  # wait_until_stable_timeout (Optional)
  # 設定内容: タスクセットが安定状態になるまでの最大待機時間を指定します。
  # 設定可能な値: 時間の文字列（例: "10m", "1h"）
  # 省略時: デフォルトのタイムアウト値が使用されます
  # 注意: wait_until_stable が true の場合のみ有効
  wait_until_stable_timeout = null

  #-------------------------------------------------------------
  # 削除設定
  #-------------------------------------------------------------

  # force_delete (Optional)
  # 設定内容: タスクセットの強制削除を有効にするかを指定します。
  # 設定可能な値:
  #   - true: タスクセットを強制的に削除します（実行中のタスクがある場合でも）
  #   - false (デフォルト): 通常の削除を行います
  # 用途: 実行中のタスクがある状態でもタスクセットを削除したい場合に使用
  force_delete = false

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  #   - https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs-using-tags.html
  tags = {
    Name        = "my-task-set"
    Environment = "production"
  }

  # tags_all (Optional)
  # 設定内容: プロバイダーのdefault_tagsから継承されたタグを含む、すべてのタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 注意: 通常は明示的に設定せず、tagsとproviderのdefault_tagsの組み合わせで管理します
  tags_all = null

  #-------------------------------------------------------------
  # キャパシティプロバイダー戦略
  #-------------------------------------------------------------

  # capacity_provider_strategy (Optional)
  # 設定内容: タスクセットで使用するキャパシティプロバイダー戦略を指定します。
  # 注意: launch_typeと排他的（どちらか一方のみ指定可能）
  # 関連機能: Amazon ECS キャパシティプロバイダー
  #   タスクを実行するインフラストラクチャを管理する方法を定義します。
  #   - https://docs.aws.amazon.com/AmazonECS/latest/developerguide/cluster-capacity-providers.html
  capacity_provider_strategy {
    # capacity_provider (Required)
    # 設定内容: 使用するキャパシティプロバイダーの短縮名を指定します。
    # 設定可能な値: 有効なキャパシティプロバイダー名
    capacity_provider = "FARGATE"

    # weight (Required)
    # 設定内容: キャパシティプロバイダーの相対的な重みを指定します。
    # 設定可能な値: 0-1000の整数
    # 説明: 複数のキャパシティプロバイダーを使用する場合、この重みに基づいてタスクが分散されます
    weight = 1

    # base (Optional)
    # 設定内容: 指定されたキャパシティプロバイダーで実行する最小タスク数を指定します。
    # 設定可能な値: 0以上の整数
    # 省略時: 0
    # 注意: baseを指定できるのは1つのキャパシティプロバイダーのみです
    base = 0
  }

  #-------------------------------------------------------------
  # ロードバランサー設定
  #-------------------------------------------------------------

  # load_balancer (Optional)
  # 設定内容: タスクセットに関連付けるロードバランサーを指定します。
  # 関連機能: Amazon ECS サービスロードバランシング
  #   ECSタスクへのトラフィックを分散するロードバランサーを構成します。
  #   - https://docs.aws.amazon.com/AmazonECS/latest/developerguide/service-load-balancing.html
  load_balancer {
    # container_name (Required)
    # 設定内容: ロードバランサーに関連付けるコンテナの名前を指定します。
    # 設定可能な値: タスク定義に定義されているコンテナ名
    container_name = "my-container"

    # container_port (Optional)
    # 設定内容: ロードバランサーに関連付けるコンテナのポート番号を指定します。
    # 設定可能な値: 1-65535のポート番号
    # 注意: タスク定義のportMappingsで定義されているポートと一致する必要があります
    container_port = 80

    # load_balancer_name (Optional)
    # 設定内容: 関連付けるClassic Load Balancerの名前を指定します。
    # 設定可能な値: 有効なELB名
    # 注意: target_group_arnと排他的（どちらか一方のみ指定可能）
    load_balancer_name = null

    # target_group_arn (Optional)
    # 設定内容: 関連付けるターゲットグループのARNを指定します。
    # 設定可能な値: 有効なALB/NLBターゲットグループARN
    # 注意: load_balancer_nameと排他的（どちらか一方のみ指定可能）
    target_group_arn = "arn:aws:elasticloadbalancing:ap-northeast-1:123456789012:targetgroup/my-targets/73e2d6bc24d8a067"
  }

  #-------------------------------------------------------------
  # ネットワーク設定
  #-------------------------------------------------------------

  # network_configuration (Optional)
  # 設定内容: タスクのネットワーク設定を指定します。
  # 注意: launch_typeが"FARGATE"の場合は必須です
  # 関連機能: Amazon ECS タスクネットワーキング
  #   タスクのENI設定やセキュリティグループを定義します。
  #   - https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task-networking.html
  network_configuration {
    # subnets (Required)
    # 設定内容: タスクのENIを作成するサブネットIDのセットを指定します。
    # 設定可能な値: 有効なサブネットIDのセット
    subnets = ["subnet-12345678", "subnet-87654321"]

    # security_groups (Optional)
    # 設定内容: タスクのENIに関連付けるセキュリティグループIDのセットを指定します。
    # 設定可能な値: 有効なセキュリティグループIDのセット
    # 省略時: VPCのデフォルトセキュリティグループが使用されます
    security_groups = ["sg-12345678"]

    # assign_public_ip (Optional)
    # 設定内容: タスクのENIにパブリックIPアドレスを割り当てるかを指定します。
    # 設定可能な値:
    #   - true: パブリックIPアドレスを割り当てます
    #   - false: パブリックIPアドレスを割り当てません
    # 省略時: false
    # 注意: パブリックサブネットでインターネットアクセスが必要な場合はtrueに設定します
    assign_public_ip = false
  }

  #-------------------------------------------------------------
  # スケール設定
  #-------------------------------------------------------------

  # scale (Optional)
  # 設定内容: タスクセットのスケール設定を指定します。
  # 関連機能: Amazon ECS タスクセットスケーリング
  #   タスクセット内で実行するタスクの数やパーセンテージを定義します。
  scale {
    # unit (Optional)
    # 設定内容: スケール値の単位を指定します。
    # 設定可能な値:
    #   - "PERCENT": パーセンテージで指定（0-100）
    #   - null: 絶対数で指定
    # 省略時: 絶対数として扱われます
    unit = "PERCENT"

    # value (Optional)
    # 設定内容: スケール値を指定します。
    # 設定可能な値:
    #   - unitが"PERCENT"の場合: 0-100の数値
    #   - unitがnullの場合: 0以上の整数（タスク数）
    # 省略時: 0
    value = 100
  }

  #-------------------------------------------------------------
  # サービスレジストリ設定
  #-------------------------------------------------------------

  # service_registries (Optional)
  # 設定内容: タスクセットのサービスディスカバリー設定を指定します。
  # 関連機能: Amazon ECS サービスディスカバリー
  #   AWS Cloud Mapを使用してサービスの検出と登録を自動化します。
  #   - https://docs.aws.amazon.com/AmazonECS/latest/developerguide/service-discovery.html
  service_registries {
    # registry_arn (Required)
    # 設定内容: サービスレジストリのARNを指定します。
    # 設定可能な値: 有効なAWS Cloud MapサービスのARN
    registry_arn = "arn:aws:servicediscovery:ap-northeast-1:123456789012:service/srv-12345678"

    # container_name (Optional)
    # 設定内容: サービスレジストリに関連付けるコンテナ名を指定します。
    # 設定可能な値: タスク定義に定義されているコンテナ名
    # 注意: SRVレコードを使用する場合は必須です
    container_name = null

    # container_port (Optional)
    # 設定内容: サービスレジストリに関連付けるコンテナポートを指定します。
    # 設定可能な値: 1-65535のポート番号
    # 注意: SRVレコードを使用する場合は必須です
    container_port = null

    # port (Optional)
    # 設定内容: サービスディスカバリーサービスに関連付けるポートを指定します。
    # 設定可能な値: 1-65535のポート番号
    # 注意: SRVレコードを使用する場合に指定します
    port = null
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: タスクセットのAmazon Resource Name (ARN)
#
# - id: タスクセットID（形式: <service>:<task_set_id>）
#
# - stability_status: タスクセットの安定性ステータス
#        値: STEADY_STATE, STABILIZING
#
# - status: タスクセットのステータス
#        値: PRIMARY, ACTIVE, DRAINING
#
# - task_set_id: タスクセットの一意のID
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
