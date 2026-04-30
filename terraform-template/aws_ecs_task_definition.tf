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
# Provider Version: 6.43.0
# Generated: 2026-04-30
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
      #-----------------------------------------------------------
      # 基本パラメータ
      #-----------------------------------------------------------

      # name (Required)
      # 設定内容: コンテナの名前を指定します。
      # 設定可能な値: 1-255文字の英数字、ハイフン、アンダースコア
      # 詳細: タスク定義内で一意である必要があります。
      #       他のコンテナのlinksやdependsOnで参照する際にこの名前を使用します。
      # 参考: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_definition_parameters.html#container_definition_name
      name = "web"

      # image (Required)
      # 設定内容: コンテナの起動に使用するDockerイメージを指定します。
      # 設定可能な値:
      #   - Docker Hubイメージ: "nginx:latest", "ubuntu:22.04"
      #   - ECRイメージ: "123456789012.dkr.ecr.ap-northeast-1.amazonaws.com/my-app:latest"
      #   - ECR Publicイメージ: "public.ecr.aws/nginx/nginx:latest"
      # 詳細: タグを省略した場合は "latest" が使用されます。
      #       ダイジェスト指定も可能です（例: "nginx@sha256:abc123..."）。
      # 参考: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_definition_parameters.html#container_definition_image
      image = "nginx:latest"

      # cpu (Optional)
      # 設定内容: コンテナに予約するCPUユニット数を指定します。
      # 設定可能な値: 0以上の整数（1024ユニット = 1 vCPU）
      # 詳細: タスクレベルのcpuが設定されている場合、全コンテナのcpu合計はタスクレベルを超えられません。
      #       Fargateではタスクレベルのcpuが優先されるため、コンテナレベルのcpuはオプションです。
      # 参考: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_definition_parameters.html#container_definition_environment
      cpu = 256

      # memory (Optional)
      # 設定内容: コンテナに適用するメモリのハードリミット（MiB単位）を指定します。
      # 設定可能な値: 4以上の整数
      # 詳細: コンテナがこの値を超えるメモリを使用しようとすると強制終了されます。
      #       memoryとmemoryReservationの少なくとも一方を指定する必要があります。
      # 参考: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_definition_parameters.html#container_definition_memory
      memory = 512

      # memoryReservation (Optional)
      # 設定内容: コンテナに予約するメモリのソフトリミット（MiB単位）を指定します。
      # 設定可能な値: 4以上の整数（memoryより小さい値）
      # 詳細: コンテナに保証されるメモリ量です。実際の使用量はこの値を超えることができますが、
      #       memoryで指定したハードリミットまでです。
      #       Fargateではタスクレベルのmemoryが使用されます。
      # 参考: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_definition_parameters.html#container_definition_memory
      memoryReservation = 256

      # essential (Optional)
      # 設定内容: このコンテナが必須コンテナかどうかを指定します。
      # 設定可能な値:
      #   - true: このコンテナが停止するとタスク全体が停止（デフォルト）
      #   - false: このコンテナが停止してもタスクは継続
      # 詳細: タスク定義内で少なくとも1つのコンテナがessential=trueである必要があります。
      #       サイドカーコンテナにはfalseを設定します。
      # 参考: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_definition_parameters.html#container_definition_essential
      essential = true

      # versionConsistency (Optional)
      # 設定内容: イメージタグのダイジェスト解決の一貫性を制御します。
      # 設定可能な値:
      #   - "enabled": タスク起動時にイメージタグをダイジェストに解決し、
      #                同一タスク定義リビジョンのすべてのタスクで同じイメージを使用（デフォルト）
      #   - "disabled": タスク起動のたびにイメージタグを再解決
      # 詳細: enabledの場合、初回のタスク起動時に解決されたダイジェストが以降のタスクでも使用されます。
      # 参考: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_definition_parameters.html#container_definition_versionconsistency
      versionConsistency = "enabled"

      #-----------------------------------------------------------
      # ポートマッピング
      #-----------------------------------------------------------

      # portMappings (Optional)
      # 設定内容: コンテナのポートマッピングを指定します。
      # 設定可能な値: ポートマッピングオブジェクトの配列
      # 詳細: コンテナポートとホストポートのマッピングを定義します。
      #       awsvpcネットワークモードではhostPortはcontainerPortと同じ値にする必要があります。
      # 参考: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_definition_parameters.html#container_definition_portmappings
      portMappings = [
        {
          # containerPort (Required)
          # 設定内容: コンテナ側のポート番号を指定します。
          # 設定可能な値: 0-65535の整数
          containerPort = 80

          # hostPort (Optional)
          # 設定内容: ホスト側のポート番号を指定します。
          # 設定可能な値: 0-65535の整数
          # 詳細: awsvpcモードではcontainerPortと同じ値を指定します。
          #       bridgeモードで省略または0を指定すると、動的ポートマッピングが使用されます。
          hostPort = 80

          # protocol (Optional)
          # 設定内容: ポートマッピングで使用するプロトコルを指定します。
          # 設定可能な値: "tcp"（デフォルト）, "udp"
          protocol = "tcp"

          # name (Optional)
          # 設定内容: ポートマッピングの名前を指定します。
          # 設定可能な値: 1-255文字の英数字、ハイフン、アンダースコア
          # 詳細: Service Connectで使用する場合に必要です。
          name = "http"

          # appProtocol (Optional)
          # 設定内容: ポートマッピングのアプリケーションプロトコルを指定します。
          # 設定可能な値: "http", "http2", "grpc"
          # 詳細: Service Connectで使用されます。nameが指定されている場合に設定可能です。
          appProtocol = "http"

          # containerPortRange (Optional)
          # 設定内容: コンテナのポート範囲を指定します。
          # 設定可能な値: "開始ポート-終了ポート"形式の文字列（例: "8000-8100"）
          # 詳細: bridgeネットワークモードでのみ使用可能です。
          #       指定した場合、containerPortとhostPortは使用できません。
          # containerPortRange = "8000-8100"
        }
      ]

      #-----------------------------------------------------------
      # コマンド・実行設定
      #-----------------------------------------------------------

      # command (Optional)
      # 設定内容: コンテナに渡すコマンドを指定します。
      # 設定可能な値: 文字列の配列
      # 詳細: DockerfileのCMD命令を上書きします。
      #       exec形式（配列）で指定します。
      # 参考: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_definition_parameters.html#container_definition_command
      command = ["nginx", "-g", "daemon off;"]

      # entryPoint (Optional)
      # 設定内容: コンテナのエントリポイントを指定します。
      # 設定可能な値: 文字列の配列
      # 詳細: DockerfileのENTRYPOINT命令を上書きします。
      #       exec形式（配列）で指定します。
      # 参考: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_definition_parameters.html#container_definition_entrypoint
      entryPoint = ["/docker-entrypoint.sh"]

      # workingDirectory (Optional)
      # 設定内容: コンテナ内の作業ディレクトリを指定します。
      # 設定可能な値: コンテナ内の絶対パス
      # 詳細: DockerfileのWORKDIR命令を上書きします。
      # 参考: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_definition_parameters.html#container_definition_workingdirectory
      workingDirectory = "/app"

      #-----------------------------------------------------------
      # 環境変数・シークレット
      #-----------------------------------------------------------

      # environment (Optional)
      # 設定内容: コンテナに渡す環境変数を指定します。
      # 設定可能な値: name（変数名）とvalue（値）のオブジェクトの配列
      # 詳細: DockerfileのENV命令で設定された変数を上書きできます。
      #       機密情報にはsecretsの使用を推奨します。
      # 参考: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_definition_parameters.html#container_definition_environment
      environment = [
        {
          name  = "APP_ENV"
          value = "production"
        }
      ]

      # environmentFiles (Optional)
      # 設定内容: S3に保存された環境変数ファイルのリストを指定します。
      # 設定可能な値: value（S3 ARN）とtype（ファイルタイプ）のオブジェクトの配列
      # 詳細: typeは "s3" のみサポートされます。
      #       ファイルは .env 形式（KEY=VALUE）である必要があります。
      #       最大10ファイルまで指定可能です。
      # 参考: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/taskdef-envfiles.html
      environmentFiles = [
        {
          value = "arn:aws:s3:::my-bucket/my-env-file.env"
          type  = "s3"
        }
      ]

      # secrets (Optional)
      # 設定内容: コンテナに渡すシークレットを指定します。
      # 設定可能な値: name（環境変数名）とvalueFrom（シークレットのARN）のオブジェクトの配列
      # 詳細: AWS Secrets ManagerシークレットまたはSSM Parameter StoreパラメータのARNを指定します。
      #       SSMパラメータの場合はフルARNを指定します。
      #       Secrets Managerの特定のキーを指定する場合は "arn::secret-name:json-key:version-stage:version-id" 形式を使用します。
      # 参考: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/specifying-sensitive-data.html
      secrets = [
        {
          name      = "DATABASE_PASSWORD"
          valueFrom = "arn:aws:secretsmanager:ap-northeast-1:123456789012:secret:my-db-password"
        }
      ]

      #-----------------------------------------------------------
      # ネットワーク設定
      #-----------------------------------------------------------

      # disableNetworking (Optional)
      # 設定内容: コンテナ内のネットワーキングを無効にするかを指定します。
      # 設定可能な値:
      #   - true: ネットワーキングを無効化
      #   - false: ネットワーキングを有効化（デフォルト）
      # 詳細: trueの場合、コンテナのポートマッピングは使用できません。
      #       awsvpcネットワークモードでは使用できません。
      # 参考: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_definition_parameters.html#container_definition_network
      disableNetworking = false

      # links (Optional)
      # 設定内容: 他のコンテナへのリンクを指定します。
      # 設定可能な値: "コンテナ名" または "コンテナ名:エイリアス" 形式の文字列の配列
      # 詳細: bridgeネットワークモードでのみ使用可能です。
      #       awsvpcモードでは使用できません。
      #       リンクされたコンテナ間で安全な通信が可能になります。
      # 参考: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_definition_parameters.html#container_definition_links
      # links = ["db:database"]

      # hostname (Optional)
      # 設定内容: コンテナで使用するホスト名を指定します。
      # 設定可能な値: 任意の文字列
      # 詳細: bridgeネットワークモードでのみ使用可能です。
      #       awsvpcモードではコンテナ名がホスト名として使用されます。
      # 参考: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_definition_parameters.html#container_definition_hostname
      # hostname = "web-server"

      # dnsServers (Optional)
      # 設定内容: コンテナに設定するDNSサーバーのリストを指定します。
      # 設定可能な値: IPアドレスの文字列の配列（最大4つ）
      # 詳細: awsvpcネットワークモードでは使用できません。
      # 参考: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_definition_parameters.html#container_definition_dns
      # dnsServers = ["8.8.8.8", "8.8.4.4"]

      # dnsSearchDomains (Optional)
      # 設定内容: コンテナに設定するDNS検索ドメインのリストを指定します。
      # 設定可能な値: ドメイン名の文字列の配列（最大6つ）
      # 詳細: awsvpcネットワークモードでは使用できません。
      # 参考: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_definition_parameters.html#container_definition_dns
      # dnsSearchDomains = ["example.com"]

      # extraHosts (Optional)
      # 設定内容: コンテナの/etc/hostsファイルに追加するホストエントリを指定します。
      # 設定可能な値: hostname（ホスト名）とipAddress（IPアドレス）のオブジェクトの配列
      # 詳細: awsvpcネットワークモードでは使用できません。
      # 参考: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_definition_parameters.html#container_definition_extrahosts
      # extraHosts = [
      #   {
      #     hostname  = "my-service"
      #     ipAddress = "10.0.0.1"
      #   }
      # ]

      #-----------------------------------------------------------
      # ストレージ・ログ
      #-----------------------------------------------------------

      # readonlyRootFilesystem (Optional)
      # 設定内容: コンテナのルートファイルシステムを読み取り専用にするかを指定します。
      # 設定可能な値:
      #   - true: ルートファイルシステムを読み取り専用に設定
      #   - false: ルートファイルシステムへの書き込みを許可（デフォルト）
      # 詳細: セキュリティのベストプラクティスとしてtrueを推奨します。
      #       書き込みが必要な場合はボリュームマウントを使用してください。
      # 参考: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_definition_parameters.html#container_definition_storage
      readonlyRootFilesystem = false

      # mountPoints (Optional)
      # 設定内容: コンテナにマウントするボリュームを指定します。
      # 設定可能な値: sourceVolume、containerPath、readOnlyのオブジェクトの配列
      # 詳細: タスク定義のvolumeセクションで定義されたボリュームを参照します。
      # 参考: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_definition_parameters.html#container_definition_mountpoints
      mountPoints = [
        {
          # sourceVolume: タスク定義のvolumeで定義したボリューム名
          sourceVolume = "service-storage"
          # containerPath: コンテナ内のマウントパス
          containerPath = "/data"
          # readOnly: 読み取り専用でマウントするか（デフォルト: false）
          readOnly = false
        }
      ]

      # volumesFrom (Optional)
      # 設定内容: 他のコンテナからマウントするボリュームを指定します。
      # 設定可能な値: sourceContainer（コンテナ名）とreadOnlyのオブジェクトの配列
      # 詳細: 指定したコンテナが定義しているボリュームマウントを共有します。
      # 参考: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_definition_parameters.html#container_definition_volumesfrom
      # volumesFrom = [
      #   {
      #     sourceContainer = "data-container"
      #     readOnly        = true
      #   }
      # ]

      # logConfiguration (Optional)
      # 設定内容: コンテナのログ設定を指定します。
      # 設定可能な値: logDriver、options、secretOptionsのオブジェクト
      # 詳細: Fargateでは "awslogs", "splunk", "awsfirelens" がサポートされます。
      #       EC2では "json-file", "syslog", "journald", "gelf", "fluentd", "awslogs", "splunk", "awsfirelens" がサポートされます。
      # 参考: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/using_awslogs.html
      logConfiguration = {
        # logDriver (Required): ログドライバー名
        logDriver = "awslogs"
        # options (Optional): ログドライバーに渡す設定オプション
        options = {
          "awslogs-group"         = "/ecs/my-app"
          "awslogs-region"        = "ap-northeast-1"
          "awslogs-stream-prefix" = "web"
        }
        # secretOptions (Optional): ログドライバーに渡すシークレット（name/valueFromの配列）
        # secretOptions = [
        #   {
        #     name      = "api-key"
        #     valueFrom = "arn:aws:secretsmanager:ap-northeast-1:123456789012:secret:log-api-key"
        #   }
        # ]
      }

      # firelensConfiguration (Optional)
      # 設定内容: FireLens設定を指定します。
      # 設定可能な値: type（ルーターの種類）とoptions（設定オプション）のオブジェクト
      # 詳細: FluentdまたはFluent Bitをログルーターとして使用します。
      #       コンテナイメージにFluentd/Fluent Bitがインストールされている必要があります。
      # 参考: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/using_firelens.html
      # firelensConfiguration = {
      #   # type (Required): "fluentd" または "fluentbit"
      #   type = "fluentbit"
      #   # options (Optional): 設定オプション
      #   options = {
      #     "config-file-type"  = "file"
      #     "config-file-value" = "/fluent-bit/configs/parse-json.conf"
      #   }
      # }

      #-----------------------------------------------------------
      # ヘルスチェック・ライフサイクル
      #-----------------------------------------------------------

      # healthCheck (Optional)
      # 設定内容: コンテナのヘルスチェック設定を指定します。
      # 設定可能な値: command、interval、timeout、retries、startPeriodのオブジェクト
      # 詳細: DockerfileのHEALTHCHECK命令を上書きします。
      #       ECSのヘルスチェックはDockerヘルスチェックとは独立して動作します。
      # 参考: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_definition_parameters.html#container_definition_healthcheck
      healthCheck = {
        # command (Required): ヘルスチェックコマンド。
        #   先頭に "CMD" を付けるとコマンドを直接実行、"CMD-SHELL" を付けるとシェル経由で実行
        command = ["CMD-SHELL", "curl -f http://localhost/ || exit 1"]
        # interval (Optional): ヘルスチェックの実行間隔（秒）。デフォルト: 30、最小: 5、最大: 300
        interval = 30
        # timeout (Optional): ヘルスチェックのタイムアウト（秒）。デフォルト: 5、最小: 2、最大: 120
        timeout = 5
        # retries (Optional): unhealthyと判定するまでのリトライ回数。デフォルト: 3、最小: 1、最大: 10
        retries = 3
        # startPeriod (Optional): 起動猶予期間（秒）。この期間中のヘルスチェック失敗はリトライ回数に含まれません。
        #   デフォルト: 0、最小: 0、最大: 300
        startPeriod = 60
      }

      # restartPolicy (Optional)
      # 設定内容: コンテナの再起動ポリシーを指定します。
      # 設定可能な値: enabled、ignoredExitCodes、restartAttemptPeriodのオブジェクト
      # 詳細: essential=falseのコンテナが終了した場合の再起動動作を制御します。
      #       Fargateプラットフォームバージョン1.4.0以降で使用可能です。
      # 参考: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/container-restart-policy.html
      # restartPolicy = {
      #   # enabled (Required): 再起動ポリシーを有効にするか
      #   enabled = true
      #   # ignoredExitCodes (Optional): 再起動をトリガーしない終了コードのリスト
      #   ignoredExitCodes = [0]
      #   # restartAttemptPeriod (Optional): 再起動試行の期間（秒）。デフォルト: 300、最小: 60、最大: 1800
      #   restartAttemptPeriod = 300
      # }

      # dependsOn (Optional)
      # 設定内容: コンテナの起動・停止の依存関係を指定します。
      # 設定可能な値: containerName（依存先コンテナ名）とcondition（条件）のオブジェクトの配列
      # 詳細: 指定した条件が満たされるまでこのコンテナの起動を待機します。
      # 参考: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_definition_parameters.html#container_definition_dependson
      # dependsOn = [
      #   {
      #     # containerName: 依存先のコンテナ名
      #     containerName = "init"
      #     # condition: 依存条件
      #     #   - "START": コンテナが起動したら
      #     #   - "COMPLETE": コンテナが正常終了（終了コード0）したら
      #     #   - "SUCCESS": コンテナが正常終了しヘルスチェックに合格したら
      #     #   - "HEALTHY": コンテナのヘルスチェックが合格したら
      #     condition = "HEALTHY"
      #   }
      # ]

      # startTimeout (Optional)
      # 設定内容: dependsOnの依存関係解決を待つ最大時間（秒）を指定します。
      # 設定可能な値: 0以上の整数（秒）
      # 詳細: この時間内にdependsOnの条件が満たされない場合、コンテナは起動に失敗します。
      #       Fargateではデフォルトで使用可能です。
      # 参考: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_definition_parameters.html#container_definition_timeout
      # startTimeout = 120

      # stopTimeout (Optional)
      # 設定内容: コンテナが自発的に終了しない場合に強制終了するまでの待機時間（秒）を指定します。
      # 設定可能な値: 0以上の整数（秒）
      # 詳細: SIGTERMシグナルを送信後、この時間が経過してもコンテナが終了しない場合にSIGKILLが送信されます。
      #       Fargateのデフォルトは30秒、EC2のデフォルトは30秒です。
      #       Fargateでは最大120秒まで設定可能です。
      # 参考: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_definition_parameters.html#container_definition_timeout
      # stopTimeout = 30

      #-----------------------------------------------------------
      # セキュリティ
      #-----------------------------------------------------------

      # privileged (Optional)
      # 設定内容: コンテナに特権アクセスを付与するかを指定します。
      # 設定可能な値:
      #   - true: ホストのすべてのデバイスにアクセス可能
      #   - false: 特権アクセスなし（デフォルト）
      # 詳細: Fargateでは使用できません（常にfalse）。
      #       セキュリティ上のリスクがあるため、必要な場合のみ使用してください。
      # 参考: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_definition_parameters.html#container_definition_security
      # privileged = false

      # user (Optional)
      # 設定内容: コンテナ内で使用するユーザーを指定します。
      # 設定可能な値:
      #   - "uid" 形式: ユーザーIDで指定（例: "1000"）
      #   - "uid:gid" 形式: ユーザーIDとグループIDで指定（例: "1000:1000"）
      #   - "username" 形式: ユーザー名で指定
      # 詳細: DockerfileのUSER命令を上書きします。
      #       Fargateではroot（UID 0）での実行も可能ですが、非rootユーザーを推奨します。
      # 参考: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_definition_parameters.html#container_definition_security
      # user = "1000:1000"

      # dockerSecurityOptions (Optional)
      # 設定内容: Dockerセキュリティオプションを指定します。
      # 設定可能な値: セキュリティオプション文字列の配列
      # 詳細: SELinuxやAppArmorのカスタムラベルを指定できます。
      #       Fargateでは使用できません。
      #       例: ["label:user:USER", "label:role:ROLE"]
      # 参考: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_definition_parameters.html#container_definition_security
      # dockerSecurityOptions = ["no-new-privileges"]

      # credentialSpecs (Optional)
      # 設定内容: Active Directory認証用のクレデンシャルスペックを指定します。
      # 設定可能な値: クレデンシャルスペックのARNの文字列の配列
      # 詳細: gMSA（Group Managed Service Account）を使用する場合に指定します。
      #       "credentialspecdomainless:arn" または "credentialspec:arn" 形式で指定します。
      # 参考: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/windows-gmsa.html
      # credentialSpecs = ["credentialspecdomainless:arn:aws:s3:::my-bucket/my-credspec.json"]

      # repositoryCredentials (Optional)
      # 設定内容: プライベートリポジトリの認証情報を指定します。
      # 設定可能な値: credentialsParameter（Secrets ManagerシークレットのARN）を含むオブジェクト
      # 詳細: プライベートDockerレジストリの認証情報をSecrets Managerに保存し、そのARNを指定します。
      #       シークレットには username と password のJSON形式で認証情報を格納します。
      # 参考: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/private-auth.html
      # repositoryCredentials = {
      #   credentialsParameter = "arn:aws:secretsmanager:ap-northeast-1:123456789012:secret:my-registry-creds"
      # }

      #-----------------------------------------------------------
      # リソース制限
      #-----------------------------------------------------------

      # ulimits (Optional)
      # 設定内容: コンテナに適用するリソース制限を指定します。
      # 設定可能な値: name（制限名）、softLimit（ソフトリミット）、hardLimit（ハードリミット）のオブジェクトの配列
      # 詳細: Fargateでは "nofile" のみサポートされます。
      #       nameの種類: core, cpu, data, fsize, locks, memlock, msgqueue, nice,
      #                   nofile, nproc, rss, rtprio, rttime, sigpending, stack
      # 参考: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_definition_parameters.html#container_definition_ulimits
      # ulimits = [
      #   {
      #     name      = "nofile"
      #     softLimit = 65536
      #     hardLimit = 65536
      #   }
      # ]

      # resourceRequirements (Optional)
      # 設定内容: コンテナに割り当てるGPU等のリソース要件を指定します。
      # 設定可能な値: type（リソースタイプ）とvalue（リソース量）のオブジェクトの配列
      # 詳細: typeには "GPU"（EC2のみ）または "InferenceAccelerator" を指定します。
      #       GPUの場合、valueはGPUの数を文字列で指定します。
      #       Fargateでは使用できません。
      # 参考: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs-gpu.html
      # resourceRequirements = [
      #   {
      #     type  = "GPU"
      #     value = "1"
      #   }
      # ]

      #-----------------------------------------------------------
      # Linux固有設定
      #-----------------------------------------------------------

      # linuxParameters (Optional)
      # 設定内容: コンテナに適用するLinux固有の設定を指定します。
      # 設定可能な値: 以下のフィールドを持つオブジェクト
      # 詳細: Linuxカーネルの機能（capabilities）、デバイスマッピング、
      #       initプロセス、メモリ/スワップ設定、tmpfsなどを制御します。
      # 参考: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_definition_parameters.html#container_definition_linuxparameters
      # linuxParameters = {
      #   # capabilities (Optional): Linuxケーパビリティの設定
      #   capabilities = {
      #     # add (Optional): 追加するケーパビリティのリスト
      #     #   例: "SYS_PTRACE", "NET_ADMIN", "SYS_ADMIN" など
      #     add = ["SYS_PTRACE"]
      #     # drop (Optional): 削除するケーパビリティのリスト
      #     #   セキュリティ強化のため不要なケーパビリティの削除を推奨
      #     drop = ["ALL"]
      #   }
      #   # devices (Optional): ホストデバイスのマッピング（EC2のみ、Fargateでは使用不可）
      #   # devices = [
      #   #   {
      #   #     hostPath      = "/dev/xvdc"
      #   #     containerPath = "/dev/xvdc"
      #   #     permissions   = ["read", "write"]
      #   #   }
      #   # ]
      #   # initProcessEnabled (Optional): コンテナ内でinitプロセスを実行するか
      #   #   trueにするとゾンビプロセスの刈り取りとシグナル転送が有効になります
      #   initProcessEnabled = true
      #   # maxSwap (Optional): コンテナが使用できるスワップの最大量（MiB）。EC2のみ
      #   # maxSwap = 0
      #   # sharedMemorySize (Optional): /dev/shmボリュームのサイズ（MiB）。EC2のみ
      #   # sharedMemorySize = 64
      #   # swappiness (Optional): メモリのスワップ動作（0-100）。EC2のみ
      #   # swappiness = 60
      #   # tmpfs (Optional): tmpfsマウントの設定（EC2のみ）
      #   # tmpfs = [
      #   #   {
      #   #     containerPath = "/tmp"
      #   #     size          = 100
      #   #     mountOptions  = ["rw", "noexec", "nosuid"]
      #   #   }
      #   # ]
      # }

      #-----------------------------------------------------------
      # メタデータ
      #-----------------------------------------------------------

      # dockerLabels (Optional)
      # 設定内容: コンテナに追加するDockerラベルを指定します。
      # 設定可能な値: キーと値のペアのマップ
      # 詳細: Dockerラベルはコンテナのメタデータとして使用されます。
      #       ECS Container Insightsやサードパーティツールと連携する際に有用です。
      # 参考: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_definition_parameters.html#container_definition_labels
      # dockerLabels = {
      #   "com.example.environment" = "production"
      #   "com.example.team"        = "platform"
      # }

      #-----------------------------------------------------------
      # その他
      #-----------------------------------------------------------

      # interactive (Optional)
      # 設定内容: コンテナをインタラクティブモードで実行するかを指定します。
      # 設定可能な値:
      #   - true: stdinチャネルを開いたままにする（docker run -i に相当）
      #   - false: インタラクティブモードを無効化（デフォルト）
      # 詳細: pseudoTerminalと組み合わせてデバッグ用途で使用します。
      # 参考: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_definition_parameters.html#container_definition_interactive
      # interactive = false

      # pseudoTerminal (Optional)
      # 設定内容: 疑似ターミナル（TTY）を割り当てるかを指定します。
      # 設定可能な値:
      #   - true: 疑似ターミナルを割り当て（docker run -t に相当）
      #   - false: 疑似ターミナルなし（デフォルト）
      # 詳細: interactiveと組み合わせてデバッグ用途で使用します。
      # 参考: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_definition_parameters.html#container_definition_interactive
      # pseudoTerminal = false

      # systemControls (Optional)
      # 設定内容: コンテナに設定するカーネルパラメータを指定します。
      # 設定可能な値: namespace（パラメータ名）とvalue（パラメータ値）のオブジェクトの配列
      # 詳細: awsvpcネットワークモードまたはFargateでは、
      #       namespaceが "System Controls" のパラメータのみ設定可能です。
      #       Fargateでは現在サポートされていません。
      # 参考: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_definition_parameters.html#container_definition_systemcontrols
      # systemControls = [
      #   {
      #     namespace = "net.core.somaxconn"
      #     value     = "1024"
      #   }
      # ]
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

    #-----------------------------------------------------------
    # ネストブロック: s3files_volume_configuration
    #-----------------------------------------------------------
    # 設定内容: Amazon S3 Filesボリュームの設定を定義します。
    # 詳細: Amazon S3に格納されたデータを共有ファイルシステムとしてタスクにマウントします。
    #       Fargate起動タイプとManaged Instances起動タイプで使用可能です（EC2では非対応）。
    #       転送時暗号化は必須で、Task IAMロールにファイルシステムへのアタッチ権限が必要です。
    # 参考: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/s3files-volumes.html

    # s3files_volume_configuration {
    #   # file_system_arn (Required)
    #   # 設定内容: マウントするS3ファイルシステムの完全なARNを指定します。
    #   # 設定可能な値: 有効なS3ファイルシステムARN
    #   # 参考: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/specify-s3files-config.html
    #   file_system_arn = "arn:aws:s3:us-east-1:123456789012:accesspoint/my-s3files-fs"
    #
    #   # access_point_arn (Optional)
    #   # 設定内容: 使用するS3 Filesアクセスポイントの完全なARNを指定します。
    #   # 設定可能な値: 有効なS3 FilesアクセスポイントARN
    #   # 詳細: アクセスポイントを使用すると、アプリケーション固有のアクセス制御が可能になります。
    #   #       access_point_arnを指定する場合、root_directoryは省略するか "/" を設定する必要があります。
    #   # 参考: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/s3files-volumes.html
    #   access_point_arn = "arn:aws:s3:us-east-1:123456789012:accesspoint/my-access-point"
    #
    #   # root_directory (Optional)
    #   # 設定内容: S3ファイルシステム内のルートディレクトリとしてマウントするパスを指定します。
    #   # 設定可能な値: S3ファイルシステム内のパス
    #   # 省略時: S3ファイルシステムのルート ("/") が使用されます。
    #   # 注意: access_point_arnが指定されている場合は省略するか "/" を設定する必要があります
    #   #       （アクセスポイントで設定されたパスが強制適用されるため）。
    #   root_directory = "/data"
    #
    #   # transit_encryption_port (Optional)
    #   # 設定内容: ECSホストとS3ファイルシステム間の暗号化通信に使用するポートを指定します。
    #   # 設定可能な値: 1-65535の整数
    #   # 省略時: Amazon S3 Filesマウントヘルパーが使用するポート選択戦略に従います。
    #   # 詳細: S3 Filesでは転送時暗号化が必須のため、本ポートを介して暗号化通信が行われます。
    #   transit_encryption_port = 2049
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
