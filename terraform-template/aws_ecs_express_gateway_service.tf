#---------------------------------------------------------------
# Amazon ECS Express ゲートウェイサービス
#---------------------------------------------------------------
#
# Amazon Elastic Container Service (ECS) の Express ゲートウェイサービスを作成します。
# Express サービスは、コンテナ化されたWebアプリケーションをAmazon ECS上に簡単にデプロイするための
# マネージド型のサービスで、Application Load Balancer、ターゲットグループ、セキュリティグループ、
# Auto Scalingポリシーなどを自動的にプロビジョニングおよび構成します。
#
# Express サービスはサービスリビジョンアーキテクチャを使用し、複数の構成を持つことができるため、
# Blue/Greenデプロイメントや段階的なロールアウトが可能です。実行ロールとインフラストラクチャロールを
# 指定する必要があり、プライマリコンテナ設定では、コンテナイメージ、環境変数、シークレット、
# ログ設定などを定義します。
#
# AWS公式ドキュメント:
#   - ECS Express Gateway Service: https://docs.aws.amazon.com/AmazonECS/latest/APIReference/API_ECSExpressGatewayService.html
#   - CreateExpressGatewayService: https://docs.aws.amazon.com/AmazonECS/latest/APIReference/API_CreateExpressGatewayService.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_express_gateway_service
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_ecs_express_gateway_service" "example" {
  #-------------------------------------------------------------
  # 必須設定
  #-------------------------------------------------------------

  # execution_role_arn (Required)
  # 設定内容: タスクの起動時とランタイムにコンテナ管理操作を実行するために使用されるIAMロールのARNを指定します。
  #          ECSエージェントがECRからイメージをプル、CloudWatch Logsへログを送信、
  #          Secrets Managerまたはパラメータストアからシークレットを取得する際に使用されます。
  # 設定可能な値: IAMロールのARN（例: arn:aws:iam::123456789012:role/ecsTaskExecutionRole）
  # 参考: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_execution_IAM_role.html
  execution_role_arn = "arn:aws:iam::123456789012:role/ecsTaskExecutionRole"

  # infrastructure_role_arn (Required)
  # 設定内容: Expressサービスに代わってAWSリソース（ALB、ターゲットグループ、セキュリティグループなど）を
  #          プロビジョニングおよび管理するために使用されるIAMロールのARNを指定します。
  # 設定可能な値: IAMロールのARN（例: arn:aws:iam::123456789012:role/ecsInfrastructureRole）
  # 注意: このロールには、EC2、Elastic Load Balancing、Auto Scalingに対する適切な権限が必要です
  infrastructure_role_arn = "arn:aws:iam::123456789012:role/ecsInfrastructureRole"

  #-------------------------------------------------------------
  # サービス基本設定
  #-------------------------------------------------------------

  # service_name (Optional)
  # 設定内容: Expressサービスの名前を指定します。
  # 設定可能な値: 最大255文字の英字、数字、ハイフン、アンダースコア
  # 省略時: AWSが自動生成
  service_name = "example-express-service"

  # cluster (Optional)
  # 設定内容: Expressサービスをホストするクラスターの短縮名またはARNを指定します。
  # 設定可能な値: クラスター名またはクラスターのARN
  # 省略時: デフォルトクラスター
  cluster = "example-cluster"

  #-------------------------------------------------------------
  # リソース設定
  #-------------------------------------------------------------

  # cpu (Optional)
  # 設定内容: タスクに割り当てるCPUユニット数を指定します。
  # 設定可能な値: "256", "512", "1024", "2048", "4096", "8192", "16384"
  # 省略時: "256"
  # 注意: cpuとmemoryの組み合わせには制約があります
  # 参考: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task-cpu-memory-error.html
  cpu = "256"

  # memory (Optional)
  # 設定内容: タスクに割り当てるメモリ量（MiB）を指定します。
  # 設定可能な値: "512", "1024", "2048", "3072", "4096", "5120", "6144", "7168", "8192"から"30720"まで
  # 省略時: "512"
  # 注意: cpuとmemoryの組み合わせには制約があります
  memory = "512"

  # task_role_arn (Optional)
  # 設定内容: タスク内のコンテナが他のAWSサービスを呼び出す際に使用するIAMロールのARNを指定します。
  # 設定可能な値: IAMロールのARN
  # 注意: execution_role_arnとは異なり、タスクロールはアプリケーションコード自体が使用する権限を定義します
  task_role_arn = null

  #-------------------------------------------------------------
  # ネットワーク設定
  #-------------------------------------------------------------

  # network_configuration (Optional)
  # 設定内容: Expressサービスのネットワーク設定を指定します。
  # 省略時: デフォルトVPCのサブネットとセキュリティグループを使用
  # 参考: https://docs.aws.amazon.com/AmazonECS/latest/APIReference/API_ExpressGatewayServiceNetworkConfiguration.html
  network_configuration {
    # subnets (Optional)
    # 設定内容: タスクを配置するサブネットIDのリストを指定します。
    # 設定可能な値: サブネットIDのセット
    # 省略時: デフォルトVPCのサブネット
    subnets = ["subnet-12345678", "subnet-87654321"]

    # security_groups (Optional)
    # 設定内容: タスクに適用するセキュリティグループIDのリストを指定します。
    # 設定可能な値: セキュリティグループIDのセット
    # 省略時: デフォルトVPCのセキュリティグループ
    security_groups = ["sg-12345678"]
  }

  #-------------------------------------------------------------
  # ヘルスチェック設定
  #-------------------------------------------------------------

  # health_check_path (Optional)
  # 設定内容: Application Load Balancerがヘルスチェックに使用するパスを指定します。
  # 設定可能な値: HTTPパス（例: "/", "/health", "/api/health"）
  # 省略時: "/"
  health_check_path = "/health"

  #-------------------------------------------------------------
  # Auto Scaling設定
  #-------------------------------------------------------------

  # scaling_target (Optional)
  # 設定内容: Expressサービスの自動スケーリング設定を指定します。
  # 省略時: Auto Scalingが無効
  scaling_target {
    # min_task_count (Optional)
    # 設定内容: 最小タスク数を指定します。
    # 設定可能な値: 1以上の整数
    # 省略時: 1
    min_task_count = 1

    # max_task_count (Optional)
    # 設定内容: 最大タスク数を指定します。
    # 設定可能な値: min_task_count以上の整数
    # 省略時: 3
    max_task_count = 10

    # auto_scaling_metric (Optional)
    # 設定内容: Auto Scalingに使用するメトリクスを指定します。
    # 設定可能な値: "CPU", "MEMORY", "REQUEST_COUNT"
    # 省略時: "CPU"
    auto_scaling_metric = "CPU"

    # auto_scaling_target_value (Optional)
    # 設定内容: Auto Scalingのターゲット値を指定します。
    # 設定可能な値:
    #   - CPU/MEMORY: 0.0から100.0（パーセンテージ）
    #   - REQUEST_COUNT: タスクあたりのリクエスト数
    # 省略時: 70.0（CPU/MEMORYの場合）
    auto_scaling_target_value = 70.0
  }

  #-------------------------------------------------------------
  # デプロイメント設定
  #-------------------------------------------------------------

  # wait_for_steady_state (Optional)
  # 設定内容: サービスが安定状態に達するまでTerraformが待機するかどうかを指定します。
  # 設定可能な値: true, false
  # 省略時: false
  # 注意: trueに設定すると、デプロイメントに時間がかかる場合があります
  wait_for_steady_state = false

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  #   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  tags = {
    Name        = "example-express-service"
    Environment = "production"
  }

  #-------------------------------------------------------------
  # プライマリコンテナ設定
  #-------------------------------------------------------------

  # primary_container (Required)
  # 設定内容: Expressサービスのプライマリコンテナ設定を指定します。
  #          コンテナイメージ、ポート、環境変数、シークレット、ログ設定を定義します。
  primary_container {
    #-----------------------------------------------------------
    # コンテナイメージ設定
    #-----------------------------------------------------------

    # image (Required)
    # 設定内容: コンテナの起動に使用するイメージを指定します。
    # 設定可能な値: Docker イメージURI
    #   - Docker Hub: library/nginx:latest, nginx:1.21
    #   - ECR Public: public.ecr.aws/nginx/nginx:latest
    #   - ECR Private: 123456789012.dkr.ecr.us-east-1.amazonaws.com/my-app:v1.0
    # 参考: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_definition_parameters.html#container_definition_image
    image = "nginx:latest"

    # container_port (Optional)
    # 設定内容: コンテナが公開するポート番号を指定します。
    # 設定可能な値: 1から65535までの整数
    # 省略時: 80
    # 注意: Application Load Balancerはこのポートにトラフィックを転送します
    container_port = 80

    #-----------------------------------------------------------
    # コンテナ起動設定
    #-----------------------------------------------------------

    # command (Optional)
    # 設定内容: コンテナの起動時に実行するコマンドを指定します。
    # 設定可能な値: 文字列のリスト
    # 注意: Dockerfileで定義されたCMDを上書きします
    # command = ["nginx", "-g", "daemon off;"]

    #-----------------------------------------------------------
    # 環境変数設定
    #-----------------------------------------------------------

    # environment (Optional)
    # 設定内容: コンテナに渡す環境変数を指定します。
    # 注意: 機密情報を含めないでください。機密情報はsecretブロックを使用してください
    # environment {
    #   # name (Required)
    #   # 設定内容: 環境変数の名前を指定します。
    #   # 設定可能な値: 環境変数名（例: APP_ENV, LOG_LEVEL）
    #   name = "APP_ENV"
    #
    #   # value (Required)
    #   # 設定内容: 環境変数の値を指定します。
    #   # 設定可能な値: 環境変数の値
    #   value = "production"
    # }

    #-----------------------------------------------------------
    # シークレット設定
    #-----------------------------------------------------------

    # secret (Optional)
    # 設定内容: AWS Secrets ManagerまたはSystems Manager Parameter Storeから取得する
    #          機密情報を環境変数として注入します。
    # 参考: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/specifying-sensitive-data.html
    # secret {
    #   # name (Required)
    #   # 設定内容: コンテナ内で使用する環境変数名を指定します。
    #   # 設定可能な値: 環境変数名（例: DB_PASSWORD, API_KEY）
    #   name = "DB_PASSWORD"
    #
    #   # value_from (Required)
    #   # 設定内容: シークレットの値を取得するARNまたはパラメータ名を指定します。
    #   # 設定可能な値:
    #   #   - Secrets Manager: arn:aws:secretsmanager:region:account-id:secret:secret-name
    #   #   - Parameter Store: arn:aws:ssm:region:account-id:parameter/parameter-name
    #   # 注意: execution_role_arnに適切な権限が必要です
    #   value_from = "arn:aws:secretsmanager:us-east-1:123456789012:secret:db-password"
    # }

    #-----------------------------------------------------------
    # プライベートレジストリ認証設定
    #-----------------------------------------------------------

    # repository_credentials (Optional)
    # 設定内容: プライベートDockerレジストリへの認証情報を指定します。
    # 注意: ECRの場合は不要です（execution_role_arnで認証されます）
    # repository_credentials {
    #   # credentials_parameter (Required)
    #   # 設定内容: 認証情報を含むSecrets ManagerシークレットのARNを指定します。
    #   # 設定可能な値: Secrets ManagerシークレットのARN
    #   # 注意: シークレットには以下の形式のJSONが必要です
    #   #       {"username":"user","password":"pass"}
    #   # 参考: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/private-auth.html
    #   credentials_parameter = "arn:aws:secretsmanager:us-east-1:123456789012:secret:docker-credentials"
    # }

    #-----------------------------------------------------------
    # ログ設定
    #-----------------------------------------------------------

    # aws_logs_configuration (Optional)
    # 設定内容: CloudWatch Logsへのログ送信設定を指定します。
    # 省略時: ログ記録が無効
    # 参考: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/using_awslogs.html
    # aws_logs_configuration {
    #   # log_group (Optional)
    #   # 設定内容: ログを送信するCloudWatch Logsのロググループ名を指定します。
    #   # 設定可能な値: ロググループ名
    #   # 省略時: AWSが自動生成
    #   log_group = "/ecs/example-express-service"
    #
    #   # log_stream_prefix (Optional)
    #   # 設定内容: ログストリームのプレフィックスを指定します。
    #   # 設定可能な値: プレフィックス文字列
    #   # 省略時: コンテナ名
    #   log_stream_prefix = "example"
    # }
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウトを指定します。
  # timeouts {
  #   # create (Optional)
  #   # 設定内容: 作成操作のタイムアウトを指定します。
  #   # 設定可能な値: 期間文字列（例: "30s", "2h45m"）
  #   # 省略時: デフォルトタイムアウト
  #   create = "15m"
  #
  #   # update (Optional)
  #   # 設定内容: 更新操作のタイムアウトを指定します。
  #   # 設定可能な値: 期間文字列（例: "30s", "2h45m"）
  #   # 省略時: デフォルトタイムアウト
  #   update = "15m"
  #
  #   # delete (Optional)
  #   # 設定内容: 削除操作のタイムアウトを指定します。
  #   # 設定可能な値: 期間文字列（例: "30s", "2h45m"）
  #   # 省略時: デフォルトタイムアウト
  #   delete = "15m"
  # }
}

#---------------------------------------------------------------
# Attributes Reference（出力可能な属性）
#---------------------------------------------------------------
#
# このリソースから参照できる主要な属性:
#
# - service_arn
#   Expressサービスを識別するARN
#
# - service_revision_arn
#   現在のサービスリビジョンのARN
#
# - current_deployment
#   現在のデプロイメント設定
#
# - ingress_paths
#   サービスへのアクセスパス情報（access_type, endpoint）のリスト
#
# - tags_all
#   リソースに割り当てられたすべてのタグ（default_tagsとtagsの統合）
#
#---------------------------------------------------------------
