#---------------------------------------------------------------
# AWS ECS Express Gateway Service
#---------------------------------------------------------------
#
# Amazon Elastic Container Service (ECS) のExpress Gateway Serviceをプロビジョニングする
# リソースです。Express Modeはコンテナ化されたWebアプリケーションをAmazon ECS上に
# 簡単にデプロイするためのマネージド型サービスで、Application Load Balancer、
# ターゲットグループ、セキュリティグループ、Auto Scalingポリシー等を自動的に
# プロビジョニングおよび構成します。
#
# サービスリビジョンアーキテクチャを採用しており、複数のアクティブな構成を保持できるため、
# Blue/Greenデプロイメントや段階的なロールアウトに対応します。利用にはタスク実行ロール
# （execution_role_arn）とインフラストラクチャロール（infrastructure_role_arn）の指定が必須です。
#
# AWS公式ドキュメント:
#   - ECSExpressGatewayService API: https://docs.aws.amazon.com/AmazonECS/latest/APIReference/API_ECSExpressGatewayService.html
#   - CreateExpressGatewayService API: https://docs.aws.amazon.com/AmazonECS/latest/APIReference/API_CreateExpressGatewayService.html
#   - Express Mode 入門: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/express-service-getting-started.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_express_gateway_service
#
# Provider Version: 6.43.0
# Generated: 2026-04-30
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_ecs_express_gateway_service" "example" {
  #-------------------------------------------------------------
  # IAMロール設定
  #-------------------------------------------------------------

  # execution_role_arn (Required)
  # 設定内容: タスク実行ロール(タスク実行ロール)のARNを指定します。
  #          ECSコンテナエージェントがユーザーに代わってAWS APIを呼び出す際に使用します。
  #          ECRからのイメージ取得、CloudWatch Logsへのログ送信、
  #          Secrets ManagerやSSM Parameter Storeからの機密情報取得時に必要です。
  # 設定可能な値: 有効なIAMロールのARN
  # 関連機能: Amazon ECSタスク実行IAMロール
  #   AmazonECSTaskExecutionRolePolicyマネージドポリシーまたは同等の権限を含める必要があります。
  #   - https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_execution_IAM_role.html
  execution_role_arn = "arn:aws:iam::123456789012:role/ecsTaskExecutionRole"

  # infrastructure_role_arn (Required)
  # 設定内容: インフラストラクチャロールのARNを指定します。
  #          Express Gateway Serviceが代理でApplication Load Balancer、ターゲットグループ、
  #          セキュリティグループ、Auto Scalingポリシー等のAWSリソースを作成・管理する際に使用します。
  # 設定可能な値: 有効なIAMロールのARN
  # 注意: このロールにはElastic Load Balancing、Application Auto Scaling、
  #       Amazon EC2(セキュリティグループ用)等の権限が必要です。
  #       Express Service作成・更新・削除操作中のみ使用されます。
  infrastructure_role_arn = "arn:aws:iam::123456789012:role/ecsInfrastructureRole"

  # task_role_arn (Optional)
  # 設定内容: タスク内のコンテナがアプリケーションコードから他のAWSサービスを呼び出す際に
  #          引き受けるIAMロールのARNを指定します。
  # 設定可能な値: 有効なIAMロールのARN
  # 省略時: タスクロールなし(コンテナ内アプリからAWS APIを呼び出さない場合)
  # 注意: execution_role_arnとは役割が異なります。
  #       execution_role_arnはECSエージェントがタスク起動・運用に使用するロール、
  #       task_role_arnはコンテナ内のアプリケーションコードが使用するロールです。
  # 参考: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task-iam-roles.html
  task_role_arn = "arn:aws:iam::123456789012:role/ecsTaskRole"

  #-------------------------------------------------------------
  # サービス基本設定
  #-------------------------------------------------------------

  # service_name (Optional)
  # 設定内容: Express Gateway Serviceの名前を指定します。
  # 設定可能な値: 大文字・小文字・数字・アンダースコア・ハイフンを含む最大255文字
  # 省略時: ECSが一意な名前を自動生成します。
  # 注意: クラスター内で一意である必要があります。
  #       サービス名はサービスARNの一部となり、作成後は変更できません。
  service_name = "example-express-service"

  # cluster (Optional)
  # 設定内容: Express Gateway Serviceをホストするクラスターの短縮名またはフルARNを指定します。
  # 設定可能な値: クラスター名 または クラスターのARN
  # 省略時: "default"クラスターが使用されます。
  cluster = "example-cluster"

  #-------------------------------------------------------------
  # コンピューティングリソース設定
  #-------------------------------------------------------------

  # cpu (Optional)
  # 設定内容: タスクが使用するCPUユニット数を文字列で指定します。
  # 設定可能な値: "256" (.25 vCPU), "512", "1024", "2048", "4096", "8192", "16384" 等
  # 省略時: "256" (.25 vCPU)
  # 注意: cpuとmemoryの組み合わせにはFargate互換の制約があります。
  # 参考: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task-cpu-memory-error.html
  cpu = "256"

  # memory (Optional)
  # 設定内容: タスクが使用するメモリ量(MiB単位)を文字列で指定します。
  # 設定可能な値: "512", "1024", "2048", "3072", "4096" 等(cpuとの組み合わせ制約あり)
  # 省略時: "512" (512 MiB)
  # 注意: cpuの値に応じて指定可能なmemoryの範囲が決まります。
  memory = "512"

  #-------------------------------------------------------------
  # ネットワーク設定
  #-------------------------------------------------------------

  # network_configuration (Optional)
  # 設定内容: Express Gateway Serviceのタスクが配置されるネットワーク構成を指定するブロックです。
  # 省略時: デフォルトVPCの構成を使用し、必要なセキュリティグループは自動作成されます。
  # 関連機能: ECS Express Gateway ネットワーク構成
  #   タスクとVPCの統合方法、ネットワークアクセス範囲を制御します。
  #   - https://docs.aws.amazon.com/AmazonECS/latest/APIReference/API_ExpressGatewayServiceNetworkConfiguration.html
  network_configuration {

    # subnets (Optional)
    # 設定内容: タスクを配置するサブネットIDのセットを指定します。
    # 設定可能な値: サブネットIDの集合
    # 省略時: デフォルトVPCのサブネットが使用されます。
    # 注意: 高可用性のため複数のアベイラビリティゾーンにまたがるサブネットの指定を推奨します。
    subnets = ["subnet-12345678", "subnet-87654321"]

    # security_groups (Optional)
    # 設定内容: タスクに適用するセキュリティグループIDのセットを指定します。
    # 設定可能な値: セキュリティグループIDの集合
    # 省略時: ECSが適切なセキュリティグループを自動作成します。
    security_groups = ["sg-12345678"]
  }

  #-------------------------------------------------------------
  # ヘルスチェック設定
  #-------------------------------------------------------------

  # health_check_path (Optional)
  # 設定内容: Application Load Balancerがコンテナのヘルスチェックに使用するパスを指定します。
  # 設定可能な値: スラッシュで始まる有効なHTTPパス(クエリパラメータ可)
  #   例: "/health", "/api/status", "/ping?format=json"
  # 省略時: "/ping"
  # 注意: アプリケーションが正常時にHTTP 200を返すエンドポイントを指定する必要があります。
  health_check_path = "/health"

  #-------------------------------------------------------------
  # Auto Scaling設定
  #-------------------------------------------------------------

  # scaling_target (Optional)
  # 設定内容: 需要に応じて実行タスク数を自動調整する設定ブロックです。
  # 省略時: AWSデフォルトのAuto Scaling設定が適用されます(ターゲット値はデフォルト60)。
  # 関連機能: Application Auto Scaling
  #   メトリクスベースでタスク数を自動調整します。
  scaling_target {

    # min_task_count (Optional)
    # 設定内容: Auto Scalingが維持する最小タスク数を指定します。
    # 設定可能な値: 1以上の整数
    # 省略時: AWSデフォルト値
    min_task_count = 1

    # max_task_count (Optional)
    # 設定内容: Auto Scalingが起動可能な最大タスク数を指定します。
    # 設定可能な値: min_task_count以上の整数
    # 省略時: AWSデフォルト値
    max_task_count = 10

    # auto_scaling_metric (Optional)
    # 設定内容: Auto Scalingのトリガーに使用するメトリクスを指定します。
    # 設定可能な値:
    #   - "CPU": CPU使用率に基づくスケーリング
    #   - "MEMORY": メモリ使用率に基づくスケーリング
    #   - "REQUEST_COUNT": ターゲットあたりのリクエスト数に基づくスケーリング
    # 省略時: AWSデフォルト値
    auto_scaling_metric = "CPU"

    # auto_scaling_target_value (Optional)
    # 設定内容: Auto Scalingメトリクスのターゲット値を指定します。
    # 設定可能な値:
    #   - CPU/MEMORY: 0.0から100.0までの数値(パーセンテージ)
    #   - REQUEST_COUNT: タスクあたりのリクエスト数
    # 省略時: 60(AWS仕様のデフォルト値)
    auto_scaling_target_value = 70.0
  }

  #-------------------------------------------------------------
  # デプロイメント挙動設定
  #-------------------------------------------------------------

  # wait_for_steady_state (Optional)
  # 設定内容: サービスが安定状態(steady state)に到達するまでTerraformが待機するかを指定します。
  # 設定可能な値:
  #   - true: サービスが安定状態になるまでTerraformが待機します。
  #   - false: 待機せずに次の処理へ進みます。
  # 省略時: false
  # 注意: trueに設定するとapplyに時間がかかる場合がありますが、
  #       デプロイ完了の確認に有用です。
  wait_for_steady_state = false

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード(例: ap-northeast-1, us-east-1)
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ(最大50個)
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
  # 設定内容: Application Load Balancerからトラフィックを受信するメインアプリケーションコンテナの
  #          設定ブロックです。コンテナイメージ・ポート・環境変数・シークレット・ログ設定を定義します。
  # 関連機能: ECS Express Gateway プライマリコンテナ
  #   - https://docs.aws.amazon.com/AmazonECS/latest/APIReference/API_ExpressGatewayContainer.html
  primary_container {

    #-----------------------------------------------------------
    # コンテナイメージ設定
    #-----------------------------------------------------------

    # image (Required)
    # 設定内容: コンテナの起動に使用するイメージURIを指定します。
    # 設定可能な値: Docker Hub、Amazon ECR、ECR Public、その他コンテナレジストリのイメージURI
    #   例:
    #     - Docker Hub: nginx:1.21
    #     - ECR Public: public.ecr.aws/nginx/nginx:latest
    #     - ECR Private: 123456789012.dkr.ecr.ap-northeast-1.amazonaws.com/my-app:v1.0
    # 注意: プライベートレジストリにアクセスする場合は、execution_role_arnに適切な権限が必要です。
    # 参考: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_definition_parameters.html#container_definition_image
    image = "nginx:latest"

    # container_port (Optional)
    # 設定内容: コンテナが公開するポート番号を指定します。
    # 設定可能な値: 1から65535までの整数
    # 省略時: 80
    # 注意: Application Load Balancerはこのポートにトラフィックを転送します。
    container_port = 80

    #-----------------------------------------------------------
    # コンテナ起動コマンド設定
    #-----------------------------------------------------------

    # command (Optional)
    # 設定内容: コンテナ起動時に実行するコマンドを指定します。
    # 設定可能な値: 文字列のリスト(コマンドと引数を要素ごとに分割)
    # 省略時: コンテナイメージに含まれるCMDを使用
    # 注意: DockerfileのCMDを上書きします。
    command = ["nginx", "-g", "daemon off;"]

    #-----------------------------------------------------------
    # 環境変数設定
    #-----------------------------------------------------------

    # environment (Optional)
    # 設定内容: コンテナに渡す環境変数を指定する繰り返し可能なブロックです。
    # 注意: 機密情報は含めないでください。機密情報はsecretブロックを使用してください。
    environment {

      # name (Required)
      # 設定内容: 環境変数の名前を指定します。
      # 設定可能な値: 環境変数名(例: APP_ENV, LOG_LEVEL)
      name = "APP_ENV"

      # value (Required)
      # 設定内容: 環境変数の値を指定します。
      # 設定可能な値: 任意の文字列
      value = "production"
    }

    #-----------------------------------------------------------
    # シークレット設定
    #-----------------------------------------------------------

    # secret (Optional)
    # 設定内容: AWS Secrets ManagerまたはSSM Parameter Storeから機密情報を取得し、
    #          環境変数としてコンテナに注入する繰り返し可能なブロックです。
    # 関連機能: ECS シークレットを通じた機密データの指定
    #   execution_role_arnに対し、Secrets ManagerやSSM Parameter Storeへの読み取り権限が必要です。
    #   - https://docs.aws.amazon.com/AmazonECS/latest/developerguide/specifying-sensitive-data.html
    secret {

      # name (Required)
      # 設定内容: コンテナ内で使用する環境変数名を指定します。
      # 設定可能な値: 環境変数名(例: DB_PASSWORD, API_KEY)
      name = "DB_PASSWORD"

      # value_from (Required)
      # 設定内容: シークレットの値を取得するARNまたはパラメータ名を指定します。
      # 設定可能な値:
      #   - Secrets Manager: arn:aws:secretsmanager:<region>:<account-id>:secret:<secret-name>
      #   - SSM Parameter Store: arn:aws:ssm:<region>:<account-id>:parameter/<parameter-name>
      value_from = "arn:aws:secretsmanager:ap-northeast-1:123456789012:secret:db-password"
    }

    #-----------------------------------------------------------
    # プライベートレジストリ認証設定
    #-----------------------------------------------------------

    # repository_credentials (Optional)
    # 設定内容: プライベートDockerレジストリへの認証情報を指定するブロックです。
    # 省略時: 認証なし(パブリックレジストリやECRの場合は不要)
    # 注意: ECRの場合は通常不要です(execution_role_arnで認証されます)。
    # 関連機能: ECS プライベートレジストリ認証
    #   - https://docs.aws.amazon.com/AmazonECS/latest/developerguide/private-auth.html
    repository_credentials {

      # credentials_parameter (Required)
      # 設定内容: 認証情報を含むSecrets ManagerシークレットのARNを指定します。
      # 設定可能な値: Secrets ManagerシークレットのARN
      # 注意: シークレット値は {"username":"<user>","password":"<pass>"} のJSON形式である必要があります。
      credentials_parameter = "arn:aws:secretsmanager:ap-northeast-1:123456789012:secret:docker-credentials"
    }

    #-----------------------------------------------------------
    # ログ設定
    #-----------------------------------------------------------

    # aws_logs_configuration (Optional)
    # 設定内容: コンテナログをAmazon CloudWatch Logsへ送信する設定ブロックです。
    # 省略時: AWS既定のロギング動作
    # 関連機能: ECS awslogsログドライバー
    #   - https://docs.aws.amazon.com/AmazonECS/latest/developerguide/using_awslogs.html
    aws_logs_configuration {

      # log_group (Optional)
      # 設定内容: ログを送信するCloudWatch Logsのロググループ名を指定します。
      # 設定可能な値: 既存のロググループ名
      # 省略時: AWSが自動生成
      log_group = "/ecs/example-express-service"

      # log_stream_prefix (Optional)
      # 設定内容: 作成されるログストリーム名のプレフィックスを指定します。
      # 設定可能な値: プレフィックス文字列
      # 省略時: コンテナ名がプレフィックスとして使用されます。
      log_stream_prefix = "example"
    }
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作ごとのタイムアウトを指定するブロックです。
  # 関連機能: Terraform Timeouts
  #   - https://developer.hashicorp.com/terraform/language/resources/syntax#operation-timeouts
  timeouts {

    # create (Optional)
    # 設定内容: 作成操作のタイムアウトを指定します。
    # 設定可能な値: 期間文字列(例: "30s", "15m", "2h45m")
    # 省略時: プロバイダー既定値
    create = "30m"

    # update (Optional)
    # 設定内容: 更新操作のタイムアウトを指定します。
    # 設定可能な値: 期間文字列(例: "30s", "15m", "2h45m")
    # 省略時: プロバイダー既定値
    update = "30m"

    # delete (Optional)
    # 設定内容: 削除操作のタイムアウトを指定します。
    # 設定可能な値: 期間文字列(例: "30s", "15m", "2h45m")
    # 省略時: プロバイダー既定値
    # 注意: destroy前にstateへ保存された変更がある場合のみ適用されます。
    delete = "30m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - service_arn: Express Gateway ServiceのARN
# - service_revision_arn: 現在アクティブなサービスリビジョンのARN
# - current_deployment: 現在のデプロイメント設定 (deprecated)
# - ingress_paths: サービスへのアクセスパス情報のリスト
#                  各要素は access_type と endpoint を持つオブジェクト
# - tags_all: プロバイダーのdefault_tagsから継承したタグを含む全タグマップ
#---------------------------------------------------------------
