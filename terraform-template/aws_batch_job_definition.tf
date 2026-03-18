#---------------------------------------------------------------
# AWS Batch Job Definition
#---------------------------------------------------------------
#
# AWS Batchのジョブ定義をプロビジョニングするリソースです。
# ジョブ定義は、ジョブの実行方法を指定するテンプレートで、使用するDockerイメージ、
# vCPU・メモリ、コマンド、環境変数、IAMロールなどの設定を定義します。
#
# AWS公式ドキュメント:
#   - AWS Batch Job Definitions: https://docs.aws.amazon.com/batch/latest/userguide/job_definitions.html
#   - RegisterJobDefinition API: https://docs.aws.amazon.com/batch/latest/APIReference/API_RegisterJobDefinition.html
#   - ContainerProperties: https://docs.aws.amazon.com/batch/latest/APIReference/API_ContainerProperties.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/batch_job_definition
#
# Provider Version: 6.36.0
# Generated: 2026-03-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_batch_job_definition" "example" {
  #-------------------------------------------------------------
  # 基本設定（必須）
  #-------------------------------------------------------------

  # name (Required, Forces new resource)
  # 設定内容: ジョブ定義の名前を指定します。
  # 設定可能な値: 最大128文字の文字列（英数字、ハイフン、アンダースコア）
  name = "my-batch-job-definition"

  # type (Required, Forces new resource)
  # 設定内容: ジョブ定義のタイプを指定します。
  # 設定可能な値:
  #   - "container": 単一コンテナジョブ
  #   - "multinode": マルチノード並列ジョブ
  type = "container"

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
  # コンテナプロパティ（JSON形式）
  #-------------------------------------------------------------

  # container_properties (Optional)
  # 設定内容: ECSベースのコンテナジョブのプロパティをJSON形式で指定します。
  # 設定可能な値: 有効なContainerProperties JSON
  # 条件: typeが"container"の場合にのみ有効
  # 関連機能: AWS Batch ContainerProperties
  #   使用するDockerイメージ、vCPU・メモリ、コマンド、環境変数、ボリュームなどを定義。
  #   - https://docs.aws.amazon.com/batch/latest/APIReference/API_ContainerProperties.html
  # 注意: ecs_properties、eks_propertiesとは排他的
  container_properties = jsonencode({
    # 使用するDockerイメージ
    image = "busybox"

    # コンテナで実行するコマンド
    command = ["ls", "-la"]

    # リソース要件（vCPU、メモリ）
    resourceRequirements = [
      {
        type  = "VCPU"
        value = "0.25"
      },
      {
        type  = "MEMORY"
        value = "512"
      }
    ]

    # 環境変数
    environment = [
      {
        name  = "ENVIRONMENT"
        value = "production"
      }
    ]

    # ボリューム設定
    volumes = [
      {
        name = "tmp"
        host = {
          sourcePath = "/tmp"
        }
      }
    ]

    # マウントポイント設定
    mountPoints = [
      {
        containerPath = "/tmp"
        sourceVolume  = "tmp"
        readOnly      = false
      }
    ]

    # Fargate使用時は以下も設定
    # executionRoleArn = "arn:aws:iam::123456789012:role/ecsTaskExecutionRole"
    # fargatePlatformConfiguration = {
    #   platformVersion = "LATEST"
    # }
  })

  #-------------------------------------------------------------
  # ECSプロパティ（JSON形式）
  #-------------------------------------------------------------

  # ecs_properties (Optional)
  # 設定内容: ECSプロパティをJSON形式で指定します（マルチコンテナジョブ用）。
  # 設定可能な値: 有効なEcsProperties JSON
  # 条件: typeが"container"の場合にのみ有効
  # 関連機能: AWS Batch EcsProperties
  #   複数のコンテナを持つECSベースのジョブを定義。
  #   - https://docs.aws.amazon.com/batch/latest/APIReference/API_RegisterJobDefinition.html
  # 注意: container_properties、eks_propertiesとは排他的
  ecs_properties = null

  #-------------------------------------------------------------
  # ノードプロパティ（JSON形式）
  #-------------------------------------------------------------

  # node_properties (Optional)
  # 設定内容: マルチノード並列ジョブのノードプロパティをJSON形式で指定します。
  # 設定可能な値: 有効なNodeProperties JSON
  # 条件: typeが"multinode"の場合に必須
  # 関連機能: AWS Batch Multi-node Parallel Jobs
  #   複数のノードで並列実行されるジョブを定義。
  #   - https://docs.aws.amazon.com/batch/latest/userguide/multi-node-parallel-jobs.html
  node_properties = null

  #-------------------------------------------------------------
  # プラットフォーム設定
  #-------------------------------------------------------------

  # platform_capabilities (Optional)
  # 設定内容: ジョブ定義に必要なプラットフォーム機能を指定します。
  # 設定可能な値:
  #   - "EC2": EC2インスタンス上で実行（デフォルト）
  #   - "FARGATE": AWS Fargate上で実行
  # 関連機能: AWS Batch Platform Capabilities
  #   ジョブを実行するプラットフォームの種類を指定。
  #   - https://docs.aws.amazon.com/batch/latest/userguide/job_definitions.html
  platform_capabilities = ["EC2"]

  #-------------------------------------------------------------
  # パラメータ設定
  #-------------------------------------------------------------

  # parameters (Optional)
  # 設定内容: ジョブ定義に設定するパラメータ置換プレースホルダーを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWS Batch Parameter Substitution
  #   コマンドでRef::パラメータ名の形式で参照可能なパラメータを定義。
  #   - https://docs.aws.amazon.com/batch/latest/userguide/job_definition_parameters.html
  parameters = {
    "Param1" = "Value1"
  }

  #-------------------------------------------------------------
  # スケジューリング設定
  #-------------------------------------------------------------

  # scheduling_priority (Optional)
  # 設定内容: ジョブ定義のスケジューリング優先度を指定します。
  # 設定可能な値: 0〜9999の整数
  # 関連機能: AWS Batch Fair Share Scheduling
  #   フェアシェアポリシーを持つジョブキュー内のジョブの優先度を決定。
  #   高い値のジョブが低い値のジョブより先にスケジュールされます。
  #   - https://docs.aws.amazon.com/batch/latest/userguide/job-priority.html
  scheduling_priority = 0

  #-------------------------------------------------------------
  # タグ伝播設定
  #-------------------------------------------------------------

  # propagate_tags (Optional)
  # 設定内容: ジョブ定義からECSタスクへタグを伝播するかを指定します。
  # 設定可能な値:
  #   - true: タグを伝播する
  #   - false: タグを伝播しない（デフォルト）
  propagate_tags = false

  #-------------------------------------------------------------
  # リビジョン管理設定
  #-------------------------------------------------------------

  # deregister_on_new_revision (Optional)
  # 設定内容: 新しいリビジョン作成時に以前のバージョンを登録解除するかを指定します。
  # 設定可能な値:
  #   - true: 以前のバージョンをINACTIVEに登録解除（デフォルト）
  #   - false: 以前のバージョンをACTIVEのまま維持
  deregister_on_new_revision = true

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
    Name        = "my-batch-job-definition"
    Environment = "production"
  }

  #-------------------------------------------------------------
  # EKSプロパティ（ネストブロック）
  #-------------------------------------------------------------

  # eks_properties (Optional)
  # 設定内容: EKSベースのジョブのプロパティを指定します。
  # 条件: typeが"container"の場合にのみ有効
  # 関連機能: AWS Batch on Amazon EKS
  #   EKS上でBatchジョブを実行するための設定。
  #   - https://docs.aws.amazon.com/batch/latest/APIReference/API_EksProperties.html
  # 注意: container_properties、ecs_propertiesとは排他的
  #
  # eks_properties {
  #   pod_properties {
  #     #---------------------------------------------------------
  #     # Pod基本設定
  #     #---------------------------------------------------------
  #
  #     # dns_policy (Optional)
  #     # 設定内容: PodのDNSポリシーを指定します。
  #     # 設定可能な値:
  #     #   - "ClusterFirst": クラスタードメインサフィックスに一致しないDNSクエリを
  #     #                     ノードから継承したアップストリームネームサーバーに転送
  #     #   - "ClusterFirstWithHostNet": host_network未指定時のデフォルト
  #     #   - "Default": Podはノードの名前解決設定を継承
  #     # 省略時: host_network指定時は"ClusterFirst"、未指定時は"ClusterFirstWithHostNet"
  #     dns_policy = "ClusterFirst"
  #
  #     # host_network (Optional)
  #     # 設定内容: Podがホストのネットワーク名前空間を使用するかを指定します。
  #     # 設定可能な値:
  #     #   - true: ホストのネットワークIPアドレスを使用（デフォルト）
  #     #   - false: Kubernetesポッドネットワーキングモデルを有効化
  #     # 注意: falseに設定するとIP割り当てのオーバーヘッドを回避できます
  #     host_network = true
  #
  #     # service_account_name (Optional)
  #     # 設定内容: Podの実行に使用するサービスアカウント名を指定します。
  #     # 設定可能な値: Kubernetes Namespaceに存在するServiceAccount名
  #     service_account_name = "batch-service-account"
  #
  #     # share_process_namespace (Optional)
  #     # 設定内容: コンテナ間でプロセス名前空間を共有するかを指定します。
  #     # 設定可能な値:
  #     #   - true: コンテナ内のプロセスが他のコンテナから見える
  #     #   - false: プロセスを共有しない
  #     share_process_namespace = false
  #
  #     #---------------------------------------------------------
  #     # コンテナ設定（必須、最大10個）
  #     #---------------------------------------------------------
  #
  #     containers {
  #       # image (Required)
  #       # 設定内容: コンテナの起動に使用するDockerイメージを指定します。
  #       # 設定可能な値: 有効なDockerイメージURI
  #       image = "public.ecr.aws/amazonlinux/amazonlinux:1"
  #
  #       # name (Optional)
  #       # 設定内容: コンテナの名前を指定します。
  #       # 設定可能な値: 文字列
  #       # 省略時: "Default"
  #       # 注意: Pod内の各コンテナは一意の名前を持つ必要があります
  #       name = "main"
  #
  #       # command (Optional)
  #       # 設定内容: コンテナのエントリポイントを指定します。
  #       # 設定可能な値: 文字列のリスト
  #       # 省略時: コンテナイメージのENTRYPOINTを使用
  #       # 注意: シェル内で実行されません
  #       command = ["sleep", "60"]
  #
  #       # args (Optional)
  #       # 設定内容: エントリポイントへの引数を指定します。
  #       # 設定可能な値: 文字列のリスト
  #       # 省略時: コンテナイメージのCMDを使用
  #       args = []
  #
  #       # image_pull_policy (Optional)
  #       # 設定内容: コンテナのイメージプルポリシーを指定します。
  #       # 設定可能な値:
  #       #   - "Always": 常にイメージをプル
  #       #   - "IfNotPresent": ローカルに存在しない場合のみプル
  #       #   - "Never": プルしない
  #       image_pull_policy = "IfNotPresent"
  #
  #       #-------------------------------------------------------
  #       # 環境変数設定
  #       #-------------------------------------------------------
  #
  #       env {
  #         # name (Required)
  #         # 設定内容: 環境変数の名前を指定します。
  #         # 注意: "AWS_BATCH"で始まる名前は使用できません
  #         name = "ENVIRONMENT"
  #
  #         # value (Required)
  #         # 設定内容: 環境変数の値を指定します。
  #         value = "production"
  #       }
  #
  #       #-------------------------------------------------------
  #       # リソース設定
  #       #-------------------------------------------------------
  #
  #       resources {
  #         # limits (Optional)
  #         # 設定内容: コンテナのリソース制限を指定します。
  #         # 設定可能な値: memory, cpu, nvidia.com/gpu のマップ
  #         limits = {
  #           cpu    = "1"
  #           memory = "1024Mi"
  #         }
  #
  #         # requests (Optional)
  #         # 設定内容: コンテナのリソース要求を指定します。
  #         # 設定可能な値: memory, cpu, nvidia.com/gpu のマップ
  #         requests = {
  #           cpu    = "0.5"
  #           memory = "512Mi"
  #         }
  #       }
  #
  #       #-------------------------------------------------------
  #       # セキュリティコンテキスト設定
  #       #-------------------------------------------------------
  #
  #       security_context {
  #         # allow_privilege_escalation (Optional)
  #         # 設定内容: コンテナまたはPodが親プロセスよりも多くの特権を取得できるかを指定します。
  #         # 設定可能な値: true/false
  #         # 省略時: false
  #         allow_privilege_escalation = false
  #
  #         # privileged (Optional)
  #         # 設定内容: コンテナを特権モードで実行するかを指定します。
  #         # 設定可能な値: true/false
  #         privileged = false
  #
  #         # read_only_root_file_system (Optional)
  #         # 設定内容: ルートファイルシステムを読み取り専用にするかを指定します。
  #         # 設定可能な値: true/false
  #         read_only_root_file_system = false
  #
  #         # run_as_user (Optional)
  #         # 設定内容: コンテナプロセスを実行するユーザーIDを指定します。
  #         # 設定可能な値: 数値（UID）
  #         run_as_user = 1000
  #
  #         # run_as_group (Optional)
  #         # 設定内容: コンテナプロセスを実行するグループIDを指定します。
  #         # 設定可能な値: 数値（GID）
  #         run_as_group = 1000
  #
  #         # run_as_non_root (Optional)
  #         # 設定内容: コンテナを非rootユーザーとして実行するかを指定します。
  #         # 設定可能な値: true/false
  #         run_as_non_root = true
  #       }
  #
  #       #-------------------------------------------------------
  #       # ボリュームマウント設定
  #       #-------------------------------------------------------
  #
  #       volume_mounts {
  #         # name (Required)
  #         # 設定内容: マウントするボリュームの名前を指定します。
  #         # 設定可能な値: volumesで定義されたボリューム名
  #         name = "data-volume"
  #
  #         # mount_path (Required)
  #         # 設定内容: コンテナ内のマウントパスを指定します。
  #         # 設定可能な値: 絶対パス
  #         mount_path = "/data"
  #
  #         # read_only (Optional)
  #         # 設定内容: 読み取り専用でマウントするかを指定します。
  #         # 設定可能な値: true/false
  #         read_only = false
  #       }
  #     }
  #
  #     #---------------------------------------------------------
  #     # 初期化コンテナ設定（オプション、最大10個）
  #     #---------------------------------------------------------
  #     # init_containersはアプリケーションコンテナの前に実行され、
  #     # 完了するまで次のコンテナが開始されません。
  #
  #     # init_containers {
  #     #   image   = "busybox"
  #     #   name    = "init"
  #     #   command = ["sh", "-c", "echo Initializing..."]
  #     #
  #     #   resources {
  #     #     limits = {
  #     #       cpu    = "0.25"
  #     #       memory = "256Mi"
  #     #     }
  #     #   }
  #     # }
  #
  #     #---------------------------------------------------------
  #     # イメージプルシークレット設定
  #     #---------------------------------------------------------
  #
  #     # image_pull_secret {
  #     #   # name (Required)
  #     #   # 設定内容: Kubernetesシークレットの名前を指定します。
  #     #   # 設定可能な値: Kubernetes Namespaceに存在するSecret名
  #     #   name = "my-registry-secret"
  #     # }
  #
  #     #---------------------------------------------------------
  #     # メタデータ設定
  #     #---------------------------------------------------------
  #
  #     metadata {
  #       # labels (Optional)
  #       # 設定内容: Kubernetesリソースを識別・整理するためのラベルを指定します。
  #       # 設定可能な値: キーと値のペアのマップ
  #       labels = {
  #         environment = "production"
  #         app         = "batch-job"
  #       }
  #     }
  #
  #     #---------------------------------------------------------
  #     # ボリューム設定
  #     #---------------------------------------------------------
  #
  #     volumes {
  #       # name (Optional)
  #       # 設定内容: ボリュームの名前を指定します。
  #       # 設定可能な値: 文字列
  #       name = "data-volume"
  #
  #       #-------------------------------------------------------
  #       # emptyDir - 一時的な空ディレクトリ
  #       #-------------------------------------------------------
  #
  #       empty_dir {
  #         # size_limit (Required)
  #         # 設定内容: ボリュームの最大サイズを指定します。
  #         # 設定可能な値: Kubernetes形式のサイズ（例: "1Gi"）
  #         size_limit = "1Gi"
  #
  #         # medium (Optional)
  #         # 設定内容: ボリュームを格納するメディアを指定します。
  #         # 設定可能な値:
  #         #   - "" (空文字列): ノードのストレージを使用（デフォルト）
  #         #   - "Memory": tmpfs（RAMベースファイルシステム）を使用
  #         medium = ""
  #       }
  #
  #       #-------------------------------------------------------
  #       # hostPath - ホストのパスをマウント
  #       #-------------------------------------------------------
  #
  #       # host_path {
  #       #   # path (Required)
  #       #   # 設定内容: ホスト上のファイルまたはディレクトリのパスを指定します。
  #       #   # 設定可能な値: 絶対パス
  #       #   path = "/var/log"
  #       # }
  #
  #       #-------------------------------------------------------
  #       # secret - Kubernetesシークレットをマウント
  #       #-------------------------------------------------------
  #
  #       # secret {
  #       #   # secret_name (Required)
  #       #   # 設定内容: マウントするシークレットの名前を指定します。
  #       #   # 設定可能な値: DNSサブドメイン名として有効な名前
  #       #   secret_name = "my-secret"
  #       #
  #       #   # optional (Optional)
  #       #   # 設定内容: シークレットまたはそのキーが存在する必要があるかを指定します。
  #       #   # 設定可能な値: true/false
  #       #   optional = false
  #       # }
  #     }
  #   }
  # }

  #-------------------------------------------------------------
  # リトライ戦略設定
  #-------------------------------------------------------------

  # retry_strategy (Optional)
  # 設定内容: 失敗したジョブのリトライ戦略を指定します。
  # 関連機能: AWS Batch Retry Strategy
  #   ジョブ失敗時の自動リトライを設定。
  #   - https://docs.aws.amazon.com/batch/latest/userguide/job_retries.html
  retry_strategy {
    # attempts (Optional)
    # 設定内容: ジョブをRUNNABLE状態に移行する最大試行回数を指定します。
    # 設定可能な値: 1〜10の整数
    attempts = 3

    # evaluate_on_exit (Optional, 最大5個)
    # 設定内容: リトライまたは終了の条件を評価するルールを指定します。
    evaluate_on_exit {
      # action (Required)
      # 設定内容: 条件が満たされた場合のアクションを指定します。
      # 設定可能な値:
      #   - "retry": ジョブをリトライ
      #   - "exit": リトライせずに終了
      action = "retry"

      # on_exit_code (Optional)
      # 設定内容: 終了コードに一致するglobパターンを指定します。
      # 設定可能な値: 終了コードの10進数表現に対するglobパターン
      on_exit_code = "*"

      # on_reason (Optional)
      # 設定内容: ジョブ終了理由に一致するglobパターンを指定します。
      # 設定可能な値: globパターン
      on_reason = null

      # on_status_reason (Optional)
      # 設定内容: ステータス理由に一致するglobパターンを指定します。
      # 設定可能な値: globパターン
      on_status_reason = null
    }
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeout (Optional)
  # 設定内容: ジョブのタイムアウト設定を指定します。
  # 関連機能: AWS Batch Job Timeout
  #   指定時間を超えて実行されるジョブを自動終了。
  #   - https://docs.aws.amazon.com/batch/latest/userguide/job_timeouts.html
  timeout {
    # attempt_duration_seconds (Optional)
    # 設定内容: ジョブを終了するまでの時間（秒）を指定します。
    # 設定可能な値: 60以上の整数
    # 注意: 最小値は60秒
    attempt_duration_seconds = 600
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: ジョブ定義のAmazon Resource Name (ARN)。
#         リビジョン番号（:#）を含みます。
#
# - arn_prefix: リビジョン番号を除いたARN。
#
# - revision: ジョブ定義のリビジョン番号。
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
