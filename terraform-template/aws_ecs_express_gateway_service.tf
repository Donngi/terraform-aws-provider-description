#---------------------------------------------------------------
# Amazon ECS Express Gateway Service
#---------------------------------------------------------------
#
# Amazon ECS Express Gateway Serviceは、コンテナ化されたWebアプリケーションを
# Amazon ECS上に簡単にデプロイするためのマネージドサービスです。
# Application Load Balancer、ターゲットグループ、セキュリティグループ、
# Auto Scalingポリシーを自動的にプロビジョニング・管理します。
#
# Express Serviceは以下を提供します：
# - 自動的なインフラストラクチャのプロビジョニングと更新
# - ゼロダウンタイムのローリングデプロイメント
# - ビルトインのロードバランシングとAuto Scaling機能
# - 複数のアクティブ構成によるBlue/Greenデプロイメントのサポート
#
# AWS公式ドキュメント:
#   - API Reference: https://docs.aws.amazon.com/AmazonECS/latest/APIReference/API_CreateExpressGatewayService.html
#   - Getting Started: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/express-service-getting-started.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_express_gateway_service
#
# Provider Version: 6.28.0
# Generated: 2026-01-26
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_ecs_express_gateway_service" "example" {
  #---------------------------------------------------------------
  # 必須パラメータ
  #---------------------------------------------------------------

  # ECSがコンテナイメージをプルし、CloudWatch Logsにログを公開するための
  # IAMロールのARN
  # 必須。タスクの起動時とランタイム時に使用されます。
  execution_role_arn = "arn:aws:iam::123456789012:role/ecsTaskExecutionRole"

  # ECSがAWSインフラストラクチャを管理するためのIAMロールのARN
  # 必須。ALB、ターゲットグループ、セキュリティグループなどのリソースを
  # プロビジョニング・管理するために使用されます。
  # 重要: サービス作成後は変更できません。変更する場合は新しいリソースが作成されます。
  infrastructure_role_arn = "arn:aws:iam::123456789012:role/ecsInfrastructureRole"

  #---------------------------------------------------------------
  # プライマリコンテナ設定（必須ブロック）
  #---------------------------------------------------------------

  primary_container {
    # コンテナイメージ（必須）
    # Docker Hubまたはプライベートレジストリ（Amazon ECR等）のイメージ
    image = "nginx:latest"

    # コンテナで実行するコマンド（オプション）
    # Dockerイメージのデフォルトコマンドをオーバーライドします
    # command = ["/bin/sh", "-c", "echo hello"]

    # コンテナが接続を待ち受けるポート（オプション）
    # 指定しない場合、コンテナのEXPOSEディレクティブから自動検出されます
    # container_port = 80

    # CloudWatch Logs設定（オプション）
    # aws_logs_configuration {
    #   # CloudWatch Logsのロググループ名（必須）
    #   log_group = "/ecs/express-service"
    #
    #   # ログストリーム名のプレフィックス（オプション）
    #   # 指定しない場合、デフォルトのプレフィックスが使用されます
    #   # log_stream_prefix = "app"
    # }

    # 環境変数（オプション、複数指定可能）
    # environment {
    #   # 環境変数名（必須）
    #   name = "ENVIRONMENT"
    #
    #   # 環境変数の値（必須）
    #   value = "production"
    # }
    #
    # environment {
    #   name  = "LOG_LEVEL"
    #   value = "info"
    # }

    # プライベートリポジトリの認証情報（オプション）
    # repository_credentials {
    #   # リポジトリ認証情報を含むSystems ManagerパラメータのARN（必須）
    #   credentials_parameter = "arn:aws:ssm:region:123456789012:parameter/docker-credentials"
    # }

    # シークレット（オプション、複数指定可能）
    # Secrets ManagerまたはSystems Managerパラメータストアから取得
    # secret {
    #   # シークレットの名前（必須）
    #   name = "DB_PASSWORD"
    #
    #   # シークレットの値を含むARN（必須）
    #   # Secrets ManagerのシークレットまたはSystems ManagerパラメータのARN
    #   value_from = "arn:aws:secretsmanager:region:123456789012:secret:db-password-abc123"
    # }
    #
    # secret {
    #   name       = "API_KEY"
    #   value_from = "arn:aws:ssm:region:123456789012:parameter/api-key"
    # }
  }

  #---------------------------------------------------------------
  # オプションパラメータ
  #---------------------------------------------------------------

  # ECSクラスター名またはARN（オプション）
  # 指定しない場合、デフォルトクラスターが使用されます
  # cluster = "default"

  # タスクが使用するCPUユニット数（オプション）
  # 有効な値: 256から4096の間の2の累乗（256, 512, 1024, 2048, 4096）
  # 指定しない場合、デフォルト値が使用されます
  # cpu = "256"

  # ヘルスチェックのパス（オプション）
  # ALBがこのパスにリクエストを送信してコンテナの状態を確認します
  # デフォルト: /ping
  # health_check_path = "/health"

  # タスクが使用するメモリ量（MiB）（オプション）
  # 有効な値: 512から8192の間
  # 指定しない場合、デフォルト値が使用されます
  # memory = "512"

  # ネットワーク設定（オプション）
  # network_configuration {
  #   # タスクに関連付けるセキュリティグループ（オプション）
  #   # 指定しない場合、VPCのデフォルトセキュリティグループが使用されます
  #   # security_groups = ["sg-12345678"]
  #
  #   # タスクに関連付けるサブネット（オプション）
  #   # ネットワーク設定を使用する場合、最低2つのサブネットを指定する必要があります
  #   # 指定しない場合、デフォルトサブネットが使用されます
  #   # subnets = ["subnet-12345678", "subnet-87654321"]
  # }

  # サービスを作成するAWSリージョン（オプション）
  # 指定しない場合、プロバイダーで設定されたリージョンが使用されます
  # region = "us-east-1"

  # Auto Scaling設定（オプション）
  # scaling_target {
  #   # Auto Scalingで使用するメトリクス（オプション）
  #   # 有効な値: CPU, MEMORY
  #   # auto_scaling_metric = "CPU"
  #
  #   # Auto Scalingメトリクスのターゲット値（パーセンテージ）（オプション）
  #   # デフォルト: 60
  #   # auto_scaling_target_value = 60
  #
  #   # 実行する最大タスク数（オプション）
  #   # max_task_count = 10
  #
  #   # 実行する最小タスク数（オプション）
  #   # min_task_count = 1
  # }

  # サービス名（オプション）
  # 指定しない場合、名前が自動生成されます
  # 変更する場合は新しいリソースが作成されます
  # service_name = "my-express-service"

  # リソースタグ（オプション）
  # キーと値のマップ。プロバイダーのdefault_tags設定ブロックで定義されたタグと
  # マージされます
  # tags = {
  #   Environment = "production"
  #   Application = "web-app"
  # }

  # ECSコンテナタスクが他のAWSサービスを呼び出すためのIAMロールのARN（オプション）
  # タスク実行ロール（execution_role_arn）とは異なり、アプリケーションコードから
  # AWSサービスにアクセスする際に使用されます
  # task_role_arn = "arn:aws:iam::123456789012:role/ecsTaskRole"

  # サービスが安定状態に達するまで待機するかどうか（オプション）
  # trueの場合、サービスが安定状態になるまでTerraformの処理が待機します
  # デフォルト: false
  # wait_for_steady_state = false

  #---------------------------------------------------------------
  # タイムアウト設定（オプション）
  #---------------------------------------------------------------

  # timeouts {
  #   # 作成時のタイムアウト（オプション）
  #   # 例: "30s", "2h45m"
  #   # create = "20m"
  #
  #   # 更新時のタイムアウト（オプション）
  #   # update = "20m"
  #
  #   # 削除時のタイムアウト（オプション）
  #   # delete = "20m"
  # }
}

#---------------------------------------------------------------
# Attributes Reference
#---------------------------------------------------------------
# 以下の属性はリソース作成後に参照可能です（computed属性）:
#
# - current_deployment: 現在のデプロイメント設定のARN
# - ingress_paths: アクセスタイプとエンドポイント情報を含む
#                  イングレスパスのリスト
#   - access_type: アクセスタイプ
#   - endpoint: エンドポイントURL
# - service_arn: Express Gateway ServiceのARN
# - service_revision_arn: サービスリビジョンのARN
# - tags_all: リソースに割り当てられたすべてのタグのマップ
#             （プロバイダーのdefault_tags設定ブロックから継承されたものを含む）
#
# 使用例:
# output "service_arn" {
#   value = aws_ecs_express_gateway_service.example.service_arn
# }
#
# output "service_endpoint" {
#   value = aws_ecs_express_gateway_service.example.ingress_paths[0].endpoint
# }
#---------------------------------------------------------------
