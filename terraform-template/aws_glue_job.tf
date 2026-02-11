#---------------------------------------------------------------
# AWS Glue Job
#---------------------------------------------------------------
#
# AWS Glue ETL (Extract, Transform, Load) ジョブの定義。
# データソースからデータを取得し、変換処理を行い、ターゲットに書き込む
# Spark、Ray、Python Shell スクリプトを実行できる。
#
# AWS公式ドキュメント:
#   - Using job parameters in AWS Glue jobs: https://docs.aws.amazon.com/glue/latest/dg/aws-glue-programming-etl-glue-arguments.html
#   - Job (API Reference): https://docs.aws.amazon.com/glue/latest/webapi/API_Job.html
#   - Streaming ETL jobs in AWS Glue: https://docs.aws.amazon.com/glue/latest/dg/add-job-streaming.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/glue_job
#
# Provider Version: 6.28.0
# Generated: 2026-01-27
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_glue_job" "example" {
  #---------------------------------------------------------------
  # 必須パラメータ
  #---------------------------------------------------------------

  # (Required) ジョブに割り当てる名前。アカウント内で一意である必要がある。
  name = "example-glue-job"

  # (Required) このジョブに関連付けられる IAM ロールの ARN。
  # Glue ジョブがデータソースやターゲット (S3, RDS等) にアクセスするための権限を持つロールを指定。
  role_arn = "arn:aws:iam::123456789012:role/GlueJobRole"

  #---------------------------------------------------------------
  # オプションパラメータ - 基本設定
  #---------------------------------------------------------------

  # (Optional) ジョブの説明文。
  description = "Example ETL job for data processing"

  # (Optional) Glue のバージョン。例: "1.0", "2.0", "3.0", "4.0", "5.0"
  # Ray ジョブの場合は 4.0 以上を指定。
  # 利用可能なバージョンは https://docs.aws.amazon.com/glue/latest/dg/release-notes.html を参照。
  glue_version = "5.0"

  # (Optional) ジョブが標準実行クラスまたはフレキシブル実行クラスで実行されるかを指定。
  # 標準実行クラスは時間に敏感なワークロードに適している。
  # 有効な値: "FLEX", "STANDARD"
  execution_class = "STANDARD"

  # (Optional) ジョブの作成方法を記述する。
  # 有効な値: "SCRIPT", "NOTEBOOK", "VISUAL"
  job_mode = "SCRIPT"

  # (Optional) このジョブのジョブ実行のキューイングが有効かどうか。
  # true の場合、ジョブ実行のキューイングが有効になる。
  job_run_queuing_enabled = false

  # (Optional) ストリーミングジョブのメンテナンスウィンドウの曜日と時刻を指定。
  maintenance_window = "mon:03:00-mon:04:00"

  #---------------------------------------------------------------
  # オプションパラメータ - リソース設定
  #---------------------------------------------------------------

  # (Optional) ジョブ実行時に割り当て可能な AWS Glue データ処理ユニット (DPU) の最大数。
  # pythonshell を使用する場合は必須で、0.0625 または 1.0 を指定。
  # glue_version 2.0 以降では number_of_workers と worker_type を代わりに使用。
  max_capacity = null

  # (Optional) ジョブ実行時に割り当てられる workerType のワーカー数。
  number_of_workers = 2

  # (Optional) ジョブ実行時に割り当てられる事前定義されたワーカータイプ。
  # 有効な値: "Standard", "G.1X", "G.2X", "G.025X", "G.4X", "G.8X", "G.12X", "G.16X",
  #           "R.1X", "R.2X", "R.4X", "R.8X", "Z.2X" (Ray ジョブ用)
  # 詳細は https://docs.aws.amazon.com/glue/latest/dg/worker-types.html を参照。
  worker_type = "G.1X"

  #---------------------------------------------------------------
  # オプションパラメータ - 実行制御
  #---------------------------------------------------------------

  # (Optional) このジョブが失敗した場合の最大再試行回数。
  max_retries = 1

  # (Optional) ジョブのタイムアウト時間 (分単位)。
  # glueetl と pythonshell ジョブのデフォルトは 2880 分 (48 時間)。
  # gluestreaming ジョブのデフォルトは 0 (無制限)。
  # glueray ジョブではこの属性を未設定のままにする。
  timeout = 2880

  #---------------------------------------------------------------
  # オプションパラメータ - 接続とセキュリティ
  #---------------------------------------------------------------

  # (Optional) このジョブで使用される接続のリスト。
  connections = ["example-connection"]

  # (Optional) ジョブに関連付けられるセキュリティ設定の名前。
  security_configuration = "example-security-config"

  # (Optional) AWS プロバイダー設定で設定されたリージョンとは異なる場合、
  # このリソースが管理されるリージョンを指定。
  region = null

  #---------------------------------------------------------------
  # オプションパラメータ - ジョブパラメータ
  #---------------------------------------------------------------

  # (Optional) このジョブのデフォルト引数のマップ。
  # 独自のジョブ実行スクリプトが使用する引数と、AWS Glue 自体が使用する引数を指定できる。
  # 特殊パラメータの詳細: http://docs.aws.amazon.com/glue/latest/dg/aws-glue-programming-python-glue-arguments.html
  default_arguments = {
    "--job-language"                     = "python"
    "--continuous-log-logGroup"          = "/aws-glue/jobs/example"
    "--enable-continuous-cloudwatch-log" = "true"
    "--enable-continuous-log-filter"     = "true"
    "--enable-metrics"                   = ""
    "--enable-auto-scaling"              = "true"
  }

  # (Optional) このジョブに対する上書き不可能な引数を名前と値のペアで指定。
  # ジョブ実行時に引数を指定しても、これらの値は上書きされない。
  non_overridable_arguments = {}

  #---------------------------------------------------------------
  # オプションパラメータ - タグ
  #---------------------------------------------------------------

  # (Optional) リソースタグのキーバリューマップ。
  # プロバイダーの default_tags 設定ブロックと併用する場合、
  # 一致するキーを持つタグはプロバイダーレベルで定義されたものを上書き。
  tags = {
    Environment = "production"
    ManagedBy   = "terraform"
  }

  #---------------------------------------------------------------
  # ネストブロック: command (必須)
  #---------------------------------------------------------------

  # (Required) ジョブのコマンド定義。
  command {
    # (Required) ジョブを実行するスクリプトの S3 パスを指定。
    script_location = "s3://example-bucket/scripts/etl_job.py"

    # (Optional) ジョブコマンドの名前。デフォルトは "glueetl"。
    # Python Shell ジョブには "pythonshell"、Ray ジョブには "glueray"、
    # ストリーミングジョブには "gluestreaming" を使用。
    # pythonshell を選択した場合は max_capacity を設定する必要がある。
    name = "glueetl"

    # (Optional) Python Shell ジョブを実行するために使用される Python バージョン。
    # 許可される値: 2, 3, 3.9
    # バージョン 3 は glue_version が 5.0 の場合、Python 3.11 を指す。
    python_version = "3"

    # (Optional) Ray ジョブで、Ray、Python、追加ライブラリのバージョンを指定するために使用。
    # 他のジョブタイプでは使用されない。
    # サポートされるランタイム環境の値については、
    # https://docs.aws.amazon.com/glue/latest/dg/ray-jobs-section.html#author-job-ray-runtimes を参照。
    runtime = null
  }

  #---------------------------------------------------------------
  # ネストブロック: execution_property (オプション)
  #---------------------------------------------------------------

  # (Optional) ジョブの実行プロパティ。
  execution_property {
    # (Optional) ジョブに許可される同時実行の最大数。デフォルトは 1。
    max_concurrent_runs = 1
  }

  #---------------------------------------------------------------
  # ネストブロック: notification_property (オプション)
  #---------------------------------------------------------------

  # (Optional) ジョブの通知プロパティ。
  notification_property {
    # (Optional) ジョブ実行の開始後、ジョブ実行遅延通知を送信するまでの分数。
    notify_delay_after = 30
  }

  #---------------------------------------------------------------
  # ネストブロック: source_control_details (オプション)
  #---------------------------------------------------------------

  # (Optional) ジョブのソース管理設定の詳細。
  # リモートリポジトリとのジョブアーティファクトの同期を可能にする。
  # source_control_details {
  #   # (Optional) 認証のタイプ。Amazon Web Services Secrets Manager に保存された
  #   # 認証トークン、または個人アクセストークンを指定。
  #   # 有効な値: "PERSONAL_ACCESS_TOKEN", "AWS_SECRETS_MANAGER"
  #   auth_strategy = "PERSONAL_ACCESS_TOKEN"
  #
  #   # (Optional) 認証トークンの値。
  #   auth_token = "ghp_xxxxxxxxxxxx"
  #
  #   # (Optional) リモートリポジトリのブランチ。
  #   branch = "main"
  #
  #   # (Optional) リモートリポジトリのフォルダ。
  #   folder = "glue-jobs"
  #
  #   # (Optional) リモートリポジトリの最後のコミット ID。
  #   last_commit_id = null
  #
  #   # (Optional) ジョブアーティファクトを含むリモートリポジトリの所有者。
  #   owner = "example-owner"
  #
  #   # (Optional) リモートリポジトリのプロバイダー。
  #   # 有効な値: "GITHUB", "GITLAB", "BITBUCKET", "AWS_CODE_COMMIT"
  #   provider = "GITHUB"
  #
  #   # (Optional) ジョブアーティファクトを含むリモートリポジトリの名前。
  #   repository = "example-repo"
  # }
}

#---------------------------------------------------------------
# Attributes Reference
#---------------------------------------------------------------
# 以下の属性がエクスポートされます (computed のみ):
#
# - arn: Glue Job の Amazon Resource Name (ARN)
# - id: ジョブ名
# - tags_all: リソースに割り当てられたタグのマップ。
#             プロバイダーの default_tags 設定ブロックから継承されたものも含む。
#
# 使用例:
#   output "glue_job_arn" {
#     value = aws_glue_job.example.arn
#   }
#---------------------------------------------------------------
