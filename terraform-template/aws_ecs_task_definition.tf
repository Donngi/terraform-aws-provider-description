#---------------------------------------------------------------
# AWS ECS Task Definition
#---------------------------------------------------------------
#
# Amazon ECS（Elastic Container Service）のタスク定義をプロビジョニングするリソースです。
# タスク定義は、ECSタスクを実行するためのブループリントとして機能し、
# コンテナ定義、CPU/メモリ要件、ネットワークモード、IAMロールなどを指定します。
#
# AWS公式ドキュメント:
#   - ECS タスク定義概要: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_definitions.html
#   - タスク定義パラメータ: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_definition_parameters.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition
#
# Provider Version: 6.28.0
# Generated: 2026-01-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_ecs_task_definition" "example" {
  #-------------------------------------------------------------
  # 必須パラメータ
  #-------------------------------------------------------------

  # family (Required)
  # 設定内容: タスク定義のファミリー名を指定します。
  # 設定可能な値: 1-255文字の英数字、ハイフン、アンダースコア
  # 詳細: ファミリーは同じタスク定義の複数のバージョンをグループ化するための名前です。
  #       新しいリビジョンを作成するたびに、同じファミリー名を使用します。
  # 参考: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_definition_parameters.html#family
  family = "my-app-task"

  # container_definitions (Required)
  # 設定内容: タスクを構成する1つ以上のコンテナ定義をJSON形式で指定します。
  # 設定可能な値: JSON形式の文字列（コンテナ名、イメージ、メモリ、CPU、ポートマッピングなどを含む）
  # 詳細: 各コンテナの設定を定義します。最大10個のコンテナを定義可能です。
  #       jsonencode()関数を使用してHCL形式で記述することも可能です。
  # 参考: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_definition_parameters.html#container_definitions
  container_definitions = jsonencode([
    {
      name      = "web"
      image     = "nginx:latest"
      cpu       = 256
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
          protocol      = "tcp"
        }
      ]
    }
  ])

  #-------------------------------------------------------------
  # コンピューティングリソース設定
  #-------------------------------------------------------------

  # cpu (Optional)
  # 設定内容: タスクレベルのCPUユニットを指定します。
  # 設定可能な値: 
  #   - Fargate起動タイプ: 256 (.25 vCPU), 512 (.5 vCPU), 1024 (1 vCPU), 2048 (2 vCPU), 4096 (4 vCPU), 
  #                        8192 (8 vCPU), 16384 (16 vCPU)
  #   - EC2起動タイプ: 128以上の整数値（CPU単位）
  # 詳細: Fargate起動タイプでは必須です。EC2起動タイプではオプションです。
  #       1024ユニット = 1 vCPU
  # 参考: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task-cpu-memory-error.html
  cpu = "256"

  # memory (Optional)
  # 設定内容: タスクレベルのメモリ量をMiB単位で指定します。
  # 設定可能な値: 
  #   - Fargate起動タイプ: CPUの値に応じて512MiB～120GiBの範囲で指定
  #   - EC2起動タイプ: 整数値（MiB単位）
  # 詳細: Fargate起動タイプでは必須です。EC2起動タイプではオプションです。
  #       CPUとメモリの組み合わせには制約があります。
  # 参考: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task-cpu-memory-error.html
  memory = "512"

  #-------------------------------------------------------------
  # IAMロール設定
  #-------------------------------------------------------------

  # task_role_arn (Optional)
  # 設定内容: タスク内のコンテナが使用するIAMロールのARNを指定します。
  # 設定可能な値: 有効なIAMロールARN
  # 詳細: タスク内のコンテナがAWSサービスAPIを呼び出すための権限を付与します。
  #       これはアプリケーションコードが使用する権限です。
  # 参考: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task-iam-roles.html
  task_role_arn = null

  # execution_role_arn (Optional)
  # 設定内容: ECSエージェントが使用するIAMロールのARNを指定します。
  # 設定可能な値: 有効なIAMロールARN
  # 詳細: ECRからイメージをプル、CloudWatch Logsにログを送信するなど、
  #       ECSエージェントの操作に必要な権限を付与します。Fargate起動タイプでは必須です。
  # 参考: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_execution_IAM_role.html
  execution_role_arn = null

  #-------------------------------------------------------------
  # ネットワーク設定
  #-------------------------------------------------------------

  # network_mode (Optional)
  # 設定内容: タスクで使用するDockerネットワークモードを指定します。
  # 設定可能な値:
  #   - "awsvpc": タスクに独自のElastic Network Interface (ENI)を割り当て
  #   - "bridge": Dockerの組み込み仮想ネットワークを使用（デフォルト、EC2のみ）
  #   - "host": ホストのネットワークスタックを直接使用（EC2のみ）
  #   - "none": ネットワーキングを無効化
  # 詳細: Fargate起動タイプでは "awsvpc" が必須です。
  #       awsvpcモードではタスクごとにENIが必要になります。
  # 参考: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task-networking.html
  network_mode = "awsvpc"

  # ipc_mode (Optional)
  # 設定内容: タスクのコンテナで使用するIPCリソース名前空間を指定します。
  # 設定可能な値:
  #   - "host": ホストのIPCリソース名前空間を使用
  #   - "task": タスク内のすべてのコンテナ間でIPCリソースを共有
  #   - "none": IPCリソースを共有しない
  # 詳細: Fargateでは "host" と "task" のみサポートされます。
  # 参考: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_definition_parameters.html#task_definition_ipcmode
  ipc_mode = null

  # pid_mode (Optional)
  # 設定内容: タスクのコンテナで使用するプロセス名前空間を指定します。
  # 設定可能な値:
  #   - "host": ホストのプロセス名前空間を使用
  #   - "task": タスク内のすべてのコンテナ間でプロセス名前空間を共有
  # 詳細: Fargateでは "task" のみサポートされます。
  # 参考: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_definition_parameters.html#task_definition_pidmode
  pid_mode = null

  #-------------------------------------------------------------
  # 起動タイプ設定
  #-------------------------------------------------------------

  # requires_compatibilities (Optional)
  # 設定内容: タスク定義が互換性を持つ起動タイプを指定します。
  # 設定可能な値: 
  #   - ["FARGATE"]: Fargate起動タイプで実行可能
  #   - ["EC2"]: EC2起動タイプで実行可能
  #   - ["FARGATE", "EC2"]: 両方の起動タイプで実行可能
  #   - ["EXTERNAL"]: ECS Anywhere用
  # 詳細: 指定した起動タイプでタスクを実行できるようにするため、
  #       適切なパラメータ（CPU、メモリなど）を設定する必要があります。
  # 参考: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_definition_parameters.html#requires_compatibilities
  requires_compatibilities = ["FARGATE"]

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
  # フォールトインジェクション設定
  #-------------------------------------------------------------

  # enable_fault_injection (Optional)
  # 設定内容: AWS Fault Injection Service（FIS）を有効にするかを指定します。
  # 設定可能な値:
  #   - true: フォールトインジェクションを有効化
  #   - false: フォールトインジェクションを無効化
  # 詳細: 有効にすると、FISを使用してタスクに対する障害シナリオをテストできます。
  # 参考: https://docs.aws.amazon.com/fis/latest/userguide/what-is.html
  enable_fault_injection = null

  #-------------------------------------------------------------
  # ライフサイクル設定
  #-------------------------------------------------------------

  # skip_destroy (Optional)
  # 設定内容: Terraform destroy時にタスク定義を削除しないかを指定します。
  # 設定可能な値:
  #   - true: destroy時にタスク定義をAWSから削除せず、Terraform stateから削除のみ
  #   - false (デフォルト): destroy時にタスク定義を削除
  # 用途: 実行中のサービスに影響を与えずにTerraformの管理から外したい場合に使用
  skip_destroy = false

  # track_latest (Optional)
  # 設定内容: タスク定義の最新リビジョンを自動的に追跡するかを指定します。
  # 設定可能な値:
  #   - true: 最新のACTIVEリビジョンを自動的に使用
  #   - false (デフォルト): 明示的に指定されたリビジョンを使用
  # 詳細: trueに設定すると、ECSサービスは常に最新のタスク定義リビジョンを使用します。
  track_latest = false

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 詳細: プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #       一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  # 参考: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs-using-tags.html
  tags = {
    Name        = "my-app-task"
    Environment = "production"
  }

  # tags_all (Optional, Computed)
  # 設定内容: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
  #          リソースに割り当てられたすべてのタグのマップ。
  # 注意: 通常は明示的に設定する必要はありません。Terraformが自動的に管理します。
  tags_all = null

  # id (Optional, Computed)
  # 設定内容: Terraformリソースの一意識別子。
  # 注意: 通常は明示的に設定する必要はありません。Terraformが自動的に管理します。
  id = null

  #-------------------------------------------------------------
  # ネストブロック: ephemeral_storage
  #-------------------------------------------------------------
  # 設定内容: Fargateタスクの一時ストレージ容量を設定します。
  # 詳細: Fargateタスクのデフォルトは20GiBです。20～200GiBの範囲で設定可能です。
  # 参考: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_definition_parameters.html#ephemeral_storage

  ephemeral_storage {
    # size_in_gib (Required)
    # 設定内容: 一時ストレージのサイズをGiB単位で指定します。
    # 設定可能な値: 20～200の整数
    # デフォルト: 20 GiB
    size_in_gib = 21
  }

  #-------------------------------------------------------------
  # ネストブロック: placement_constraints
  #-------------------------------------------------------------
  # 設定内容: タスクの配置制約を定義します（EC2起動タイプのみ）。
  # 詳細: タスクを配置するEC2インスタンスを制限できます。最大10個まで定義可能です。
  # 参考: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task-placement-constraints.html

  placement_constraints {
    # type (Required)
    # 設定内容: 配置制約のタイプを指定します。
    # 設定可能な値:
    #   - "memberOf": クエリ式に基づいてインスタンスを選択
    #   - "distinctInstance": 各タスクを別々のインスタンスに配置
    type = "memberOf"

    # expression (Optional)
    # 設定内容: クラスタクエリ言語を使用した制約式を指定します。
    # 設定可能な値: クラスタクエリ言語の式（type="memberOf"の場合に使用）
    # 例: "attribute:ecs.instance-type =~ t2.*"
    # 参考: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/cluster-query-language.html
    expression = "attribute:ecs.availability-zone in [us-east-1a, us-east-1b]"
  }

  #-------------------------------------------------------------
  # ネストブロック: proxy_configuration
  #-------------------------------------------------------------
  # 設定内容: タスク内のコンテナに対するApp Meshプロキシ設定を定義します。
  # 詳細: AWS App Meshを使用する場合に、Envoyプロキシコンテナの設定を行います。
  # 参考: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_definition_parameters.html#proxyConfiguration

  proxy_configuration {
    # container_name (Required)
    # 設定内容: プロキシとして機能するコンテナの名前を指定します。
    # 設定可能な値: container_definitionsで定義されたコンテナ名
    container_name = "envoy"

    # type (Optional)
    # 設定内容: プロキシのタイプを指定します。
    # 設定可能な値: 
    #   - "APPMESH": AWS App Mesh Envoyプロキシ（デフォルト）
    type = "APPMESH"

    # properties (Optional)
    # 設定内容: プロキシ設定のプロパティを定義します。
    # 設定可能な値: キーと値のペアのマップ
    # 例: App Meshの場合、IgnoredUID、IgnoredGID、AppPorts、ProxyIngressPort、ProxyEgressPortなど
    properties = {
      AppPorts         = "8080"
      EgressIgnoredIPs = "169.254.170.2,169.254.169.254"
      IgnoredUID       = "1337"
      ProxyEgressPort  = "15001"
      ProxyIngressPort = "15000"
    }
  }

  #-------------------------------------------------------------
  # ネストブロック: runtime_platform
  #-------------------------------------------------------------
  # 設定内容: タスクのランタイムプラットフォーム設定を定義します。
  # 詳細: タスクを実行するOSとCPUアーキテクチャを指定します。
  # 参考: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_definition_parameters.html#runtime-platform

  runtime_platform {
    # cpu_architecture (Optional)
    # 設定内容: タスクで使用するCPUアーキテクチャを指定します。
    # 設定可能な値:
    #   - "X86_64": x86-64アーキテクチャ（デフォルト）
    #   - "ARM64": ARM64アーキテクチャ（Gravitonプロセッサ）
    # 詳細: ARM64を使用すると、コスト効率が向上する場合があります。
    cpu_architecture = "X86_64"

    # operating_system_family (Optional)
    # 設定内容: タスクで使用するOSファミリーを指定します。
    # 設定可能な値:
    #   - "LINUX": Linux（デフォルト）
    #   - "WINDOWS_SERVER_2019_FULL": Windows Server 2019 Full
    #   - "WINDOWS_SERVER_2019_CORE": Windows Server 2019 Core
    #   - "WINDOWS_SERVER_2022_FULL": Windows Server 2022 Full
    #   - "WINDOWS_SERVER_2022_CORE": Windows Server 2022 Core
    operating_system_family = "LINUX"
  }

  #-------------------------------------------------------------
  # ネストブロック: volume
  #-------------------------------------------------------------
  # 設定内容: タスク内のコンテナ間で共有するボリュームを定義します。
  # 詳細: ホストボリューム、EFSボリューム、Dockerボリューム、FSx for Windowsボリュームを定義可能です。
  # 参考: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/using_data_volumes.html

  volume {
    # name (Required)
    # 設定内容: ボリュームの名前を指定します。
    # 設定可能な値: 1-255文字の英数字、ハイフン、アンダースコア
    # 詳細: コンテナ定義のmountPointsセクションで、この名前を参照してボリュームをマウントします。
    name = "service-storage"

    # host_path (Optional)
    # 設定内容: ホスト上のパスを指定します（EC2起動タイプでホストボリュームを使用する場合）。
    # 設定可能な値: 絶対パス
    # 注意: Fargate起動タイプでは使用できません。
    host_path = null

    # configure_at_launch (Optional, Computed)
    # 設定内容: タスク起動時にボリューム設定を行うかを指定します。
    # 設定可能な値:
    #   - true: タスク起動時にボリューム設定を行う
    #   - false: 事前定義の設定を使用
    configure_at_launch = null

    #-----------------------------------------------------------
    # ネストブロック: docker_volume_configuration
    #-----------------------------------------------------------
    # 設定内容: Dockerボリュームの設定を定義します。
    # 詳細: Dockerボリュームドライバーを使用してボリュームを管理します。
    # 参考: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/docker-volumes.html

    docker_volume_configuration {
      # scope (Optional, Computed)
      # 設定内容: Dockerボリュームのスコープを指定します。
      # 設定可能な値:
      #   - "task": タスクごとにボリュームを作成（デフォルト）
      #   - "shared": 複数のタスク間でボリュームを共有
      scope = "task"

      # autoprovision (Optional)
      # 設定内容: ボリュームが存在しない場合に自動的にプロビジョニングするかを指定します。
      # 設定可能な値:
      #   - true: 自動プロビジョニングを有効化
      #   - false: 自動プロビジョニングを無効化
      autoprovision = true

      # driver (Optional, Computed)
      # 設定内容: 使用するDockerボリュームドライバーを指定します。
      # 設定可能な値: 有効なDockerボリュームドライバー名
      # デフォルト: "local"
      driver = "local"

      # driver_opts (Optional)
      # 設定内容: ボリュームドライバーに渡すオプションを指定します。
      # 設定可能な値: キーと値のペアのマップ
      driver_opts = {
        type   = "nfs"
        device = ":/docker/containers"
        o      = "addr=10.0.0.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2"
      }

      # labels (Optional)
      # 設定内容: Dockerボリュームに付けるラベルを指定します。
      # 設定可能な値: キーと値のペアのマップ
      labels = {
        environment = "production"
      }
    }

    #-----------------------------------------------------------
    # ネストブロック: efs_volume_configuration
    #-----------------------------------------------------------
    # 設定内容: Amazon EFS（Elastic File System）ボリュームの設定を定義します。
    # 詳細: EFSファイルシステムをタスクにマウントします。Fargateでも使用可能です。
    # 参考: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/efs-volumes.html

    # efs_volume_configuration {
    #   # file_system_id (Required)
    #   # 設定内容: 使用するEFSファイルシステムのIDを指定します。
    #   # 設定可能な値: 有効なEFSファイルシステムID
    #   file_system_id = "fs-1234567890abcdef0"
    #
    #   # root_directory (Optional)
    #   # 設定内容: EFSファイルシステム内のルートディレクトリを指定します。
    #   # 設定可能な値: EFS内のパス
    #   # デフォルト: "/" (ファイルシステムのルート)
    #   root_directory = "/data"
    #
    #   # transit_encryption (Optional)
    #   # 設定内容: EFSボリュームとタスク間の転送時暗号化を有効にするかを指定します。
    #   # 設定可能な値:
    #   #   - "ENABLED": 暗号化を有効化
    #   #   - "DISABLED": 暗号化を無効化（デフォルト）
    #   transit_encryption = "ENABLED"
    #
    #   # transit_encryption_port (Optional)
    #   # 設定内容: EFSクライアントとファイルシステム間の暗号化通信で使用するポートを指定します。
    #   # 設定可能な値: 1-65535の整数
    #   # デフォルト: 2049（NFSポート）
    #   # 注意: transit_encryptionが"ENABLED"の場合にのみ使用
    #   transit_encryption_port = 2049
    #
    #   #---------------------------------------------------------
    #   # ネストブロック: authorization_config
    #   #---------------------------------------------------------
    #   # 設定内容: EFSファイルシステムの認証設定を定義します。
    #   # 詳細: EFSアクセスポイントを使用したアクセス制御を設定します。
    #
    #   authorization_config {
    #     # access_point_id (Optional)
    #     # 設定内容: 使用するEFSアクセスポイントのIDを指定します。
    #     # 設定可能な値: 有効なEFSアクセスポイントID
    #     # 詳細: アクセスポイントを使用すると、特定のディレクトリへのアクセスと
    #     #       ユーザー/グループIDの強制が可能になります。
    #     access_point_id = "fsap-1234567890abcdef0"
    #
    #     # iam (Optional)
    #     # 設定内容: IAM認証を使用してEFSにアクセスするかを指定します。
    #     # 設定可能な値:
    #     #   - "ENABLED": IAM認証を有効化
    #     #   - "DISABLED": IAM認証を無効化（デフォルト）
    #     iam = "ENABLED"
    #   }
    # }

    #-----------------------------------------------------------
    # ネストブロック: fsx_windows_file_server_volume_configuration
    #-----------------------------------------------------------
    # 設定内容: Amazon FSx for Windows File Serverボリュームの設定を定義します。
    # 詳細: FSx for Windows File Serverファイルシステムをタスクにマウントします（Windowsコンテナのみ）。
    # 参考: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/wfsx-volumes.html

    # fsx_windows_file_server_volume_configuration {
    #   # file_system_id (Required)
    #   # 設定内容: 使用するFSx for Windows File ServerファイルシステムのIDを指定します。
    #   # 設定可能な値: 有効なFSxファイルシステムID
    #   file_system_id = "fs-0123456789abcdef0"
    #
    #   # root_directory (Required)
    #   # 設定内容: FSxファイルシステム内のルートディレクトリを指定します。
    #   # 設定可能な値: FSx内のWindowsパス（例: "\\share"）
    #   root_directory = "\\share"
    #
    #   #---------------------------------------------------------
    #   # ネストブロック: authorization_config
    #   #---------------------------------------------------------
    #   # 設定内容: FSx for Windows File Serverの認証設定を定義します。
    #   # 詳細: Active Directory認証情報を使用したアクセス制御を設定します。
    #
    #   authorization_config {
    #     # credentials_parameter (Required)
    #     # 設定内容: Active Directory認証情報を含むAWS Secrets ManagerシークレットのARNを指定します。
    #     # 設定可能な値: 有効なSecrets Manager ARN
    #     credentials_parameter = "arn:aws:secretsmanager:us-east-1:123456789012:secret:my-secret"
    #
    #     # domain (Required)
    #     # 設定内容: Active DirectoryドメインのFQDNを指定します。
    #     # 設定可能な値: 有効なFQDN
    #     domain = "example.com"
    #   }
    # }
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: タスク定義のAmazon Resource Name (ARN)（リビジョン番号を含む完全なARN）
#        例: arn:aws:ecs:us-east-1:123456789012:task-definition/my-app-task:3
#
# - arn_without_revision: リビジョン番号を含まないタスク定義のARN
#        例: arn:aws:ecs:us-east-1:123456789012:task-definition/my-app-task
#
# - revision: タスク定義のリビジョン番号
#        同じファミリーの新しいタスク定義を登録するたびに自動的にインクリメントされます
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
