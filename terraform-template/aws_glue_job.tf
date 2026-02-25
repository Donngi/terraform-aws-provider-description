#---------------------------------------------------------------
# AWS Glue Job
#---------------------------------------------------------------
#
# AWS Glue JobをプロビジョニングするリソースAWS Glue ETLジョブを作成・管理します。
# GlueジョブはPython/Scalaスクリプトを実行してデータの抽出・変換・ロード（ETL）を行います。
# glueetl（Spark）、pythonshell、gluestreaming（ストリーミング）、glueray（Ray）の
# 4種類のジョブタイプに対応しています。
#
# AWS公式ドキュメント:
#   - Glue Jobの概要: https://docs.aws.amazon.com/glue/latest/dg/add-job.html
#   - ジョブ特殊パラメータ: https://docs.aws.amazon.com/glue/latest/dg/aws-glue-programming-etl-glue-arguments.html
#   - ワーカータイプ: https://docs.aws.amazon.com/glue/latest/dg/worker-types.html
#   - Glueバージョン: https://docs.aws.amazon.com/glue/latest/dg/release-notes.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/glue_job
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_glue_job" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: ジョブの一意な名前を指定します。アカウント内で一意である必要があります。
  # 設定可能な値: 英数字、ハイフン、アンダースコアを含む文字列
  name = "example-glue-job"

  # role_arn (Required)
  # 設定内容: ジョブに関連付けるIAMロールのARNを指定します。
  #           Glueジョブがデータソースやデータターゲットにアクセスするために使用します。
  # 設定可能な値: 有効なIAMロールARN
  role_arn = "arn:aws:iam::123456789012:role/AWSGlueServiceRole-example"

  #-------------------------------------------------------------
  # コマンド設定（ジョブタイプ定義）
  #-------------------------------------------------------------

  # command (Required)
  # 設定内容: ジョブで実行するコマンドの設定ブロックです。ジョブタイプとスクリプトパスを定義します。
  command {

    # name (Optional)
    # 設定内容: ジョブコマンド名を指定します。ジョブタイプに対応します。
    # 設定可能な値:
    #   - "glueetl": Spark ETLジョブ（デフォルト）
    #   - "pythonshell": Python Shellジョブ（max_capacity設定が必要）
    #   - "gluestreaming": Spark Streamingジョブ
    #   - "glueray": Ray ジョブ（glue_version 4.0以上が必要）
    # 省略時: "glueetl"
    name = "glueetl"

    # script_location (Required)
    # 設定内容: ジョブを実行するスクリプトのS3パスを指定します。
    # 設定可能な値: s3://バケット名/パス 形式のS3 URI
    script_location = "s3://example-bucket/scripts/etl_job.py"

    # python_version (Optional)
    # 設定内容: Python Shellジョブで使用するPythonバージョンを指定します。
    #           glue_version 5.0設定時のバージョン3はPython 3.11を指します。
    # 設定可能な値:
    #   - "2": Python 2（非推奨）
    #   - "3": Python 3.x（glueetlジョブ）
    #   - "3.9": Python 3.9（pythonshellおよびgluerayジョブ）
    # 省略時: glueetlの場合は "3"
    python_version = "3"

    # runtime (Optional)
    # 設定内容: Rayジョブで使用するランタイム環境を指定します（gluerayジョブのみ）。
    #           RayのバージョンとPython、追加ライブラリのバージョンを指定します。
    # 設定可能な値: "Ray2.4" などのサポートされているRayランタイム文字列
    # 省略時: null（glueray以外のジョブタイプでは使用しない）
    # 参考: https://docs.aws.amazon.com/glue/latest/dg/ray-jobs-section.html#author-job-ray-runtimes
    runtime = null
  }

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
  # ジョブ説明・分類設定
  #-------------------------------------------------------------

  # description (Optional)
  # 設定内容: ジョブの説明文を指定します。
  # 設定可能な値: 任意の文字列
  # 省略時: 説明なし
  description = "Example AWS Glue ETL job"

  # job_mode (Optional)
  # 設定内容: ジョブの作成方法を指定します。
  # 設定可能な値:
  #   - "SCRIPT": スクリプトベースのジョブ
  #   - "NOTEBOOK": Notebookベースのジョブ
  #   - "VISUAL": Glue Studioビジュアルエディタで作成したジョブ
  # 省略時: null
  job_mode = null

  #-------------------------------------------------------------
  # Glueバージョン・ワーカー設定
  #-------------------------------------------------------------

  # glue_version (Optional)
  # 設定内容: 使用するGlueのバージョンを指定します。
  #           RayジョブはGlueバージョン4.0以上が必要です。
  # 設定可能な値: "1.0", "2.0", "3.0", "4.0", "5.0" など
  # 省略時: デフォルトバージョン（古いバージョン）
  # 参考: https://docs.aws.amazon.com/glue/latest/dg/release-notes.html
  glue_version = "5.0"

  # worker_type (Optional)
  # 設定内容: ジョブ実行時に割り当てる定義済みワーカーのタイプを指定します。
  #           glue_version 2.0以上ではnumber_of_workersと組み合わせて使用します。
  # 設定可能な値:
  #   - "Standard": 標準ワーカー（G.1Xの旧世代）
  #   - "G.025X": 0.25 DPU（pythonshell向け）
  #   - "G.1X": 1 DPU（メモリ効率型）
  #   - "G.2X": 2 DPU（標準型、デフォルト）
  #   - "G.4X": 4 DPU（大規模データ向け）
  #   - "G.8X": 8 DPU（超大規模データ向け）
  #   - "G.12X": 12 DPU
  #   - "G.16X": 16 DPU
  #   - "R.1X": 1 DPU（メモリ最適化型）
  #   - "R.2X": 2 DPU（メモリ最適化型）
  #   - "R.4X": 4 DPU（メモリ最適化型）
  #   - "R.8X": 8 DPU（メモリ最適化型）
  #   - "Z.2X": 2 DPU（Rayジョブ専用）
  # 省略時: null（max_capacity使用時は省略）
  # 参考: https://docs.aws.amazon.com/glue/latest/dg/worker-types.html
  worker_type = "G.1X"

  # number_of_workers (Optional)
  # 設定内容: ジョブ実行時に割り当てる指定のworker_typeのワーカー数を指定します。
  #           glue_version 2.0以上でworker_typeと組み合わせて使用します。
  # 設定可能な値: 正の整数
  # 省略時: null（max_capacity使用時は省略）
  number_of_workers = 2

  # max_capacity (Optional)
  # 設定内容: ジョブ実行時に割り当て可能な最大Glueデータ処理ユニット（DPU）数を指定します。
  #           pythonshellジョブでは必須で0.0625または1.0のみ受け付けます。
  #           glue_version 2.0以上ではworker_typeとnumber_of_workersを使用してください。
  # 設定可能な値: 0.0625（pythonshell最小）、1.0（pythonshell最大）、または正の数値
  # 省略時: null（worker_typeとnumber_of_workers使用時は省略）
  max_capacity = null

  #-------------------------------------------------------------
  # 実行クラス・タイムアウト設定
  #-------------------------------------------------------------

  # execution_class (Optional)
  # 設定内容: ジョブの実行クラスを指定します。
  #           標準クラスはタイムセンシティブなワークロード向けで、
  #           フレキシブルクラスはコスト最適化向けです。
  # 設定可能な値:
  #   - "STANDARD": 標準実行クラス（専用リソース、高速起動）
  #   - "FLEX": フレキシブル実行クラス（余剰キャパシティ使用、コスト最適化）
  # 省略時: "STANDARD"
  execution_class = "STANDARD"

  # timeout (Optional)
  # 設定内容: ジョブのタイムアウト時間を分単位で指定します。
  #           glueetlおよびpythonshellジョブのデフォルトは2880分（48時間）、
  #           gluestreamingジョブのデフォルトは0（無制限）です。
  #           gluerayジョブではこの属性を未設定のままにしてください。
  # 設定可能な値: 正の整数（分）、または0（無制限、gluestreamingのみ）
  # 省略時: glueetl/pythonshellは2880、gluestreamingは0
  timeout = 2880

  # max_retries (Optional)
  # 設定内容: ジョブが失敗した場合の最大リトライ回数を指定します。
  # 設定可能な値: 0から10の整数
  # 省略時: 0
  max_retries = 0

  #-------------------------------------------------------------
  # 接続・セキュリティ設定
  #-------------------------------------------------------------

  # connections (Optional)
  # 設定内容: ジョブで使用するGlue接続名のリストを指定します。
  # 設定可能な値: 既存のGlue接続名のリスト
  # 省略時: 接続なし
  connections = []

  # security_configuration (Optional)
  # 設定内容: ジョブに関連付けるセキュリティ設定の名前を指定します。
  #           暗号化設定（S3、CloudWatch、ジョブブックマーク）を適用します。
  # 設定可能な値: 既存のGlueセキュリティ設定名
  # 省略時: セキュリティ設定なし
  # 参考: https://docs.aws.amazon.com/glue/latest/dg/console-security-configurations.html
  security_configuration = null

  #-------------------------------------------------------------
  # キュー・メンテナンス設定
  #-------------------------------------------------------------

  # job_run_queuing_enabled (Optional)
  # 設定内容: ジョブ実行のキュー機能を有効にするかを指定します。
  #           trueに設定するとリソースが利用可能になるまでジョブ実行をキューに追加します。
  # 設定可能な値:
  #   - true: キュー機能を有効化
  #   - false: キュー機能を無効化
  # 省略時: false
  job_run_queuing_enabled = false

  # maintenance_window (Optional)
  # 設定内容: ストリーミングジョブのメンテナンスウィンドウの曜日と時間を指定します。
  # 設定可能な値: "曜日:時間" 形式（例: "Sun:14"）
  # 省略時: null
  maintenance_window = null

  #-------------------------------------------------------------
  # デフォルト引数設定
  #-------------------------------------------------------------

  # default_arguments (Optional)
  # 設定内容: ジョブのデフォルト引数のマップを指定します。
  #           ジョブスクリプトが使用する引数とGlue自体が使用するシステム引数を指定できます。
  # 設定可能な値: キーと値のペアのマップ。主な特殊パラメータ:
  #   - "--job-language": ジョブ言語 ("python" または "scala")
  #   - "--continuous-log-logGroup": CloudWatch Logsグループ名
  #   - "--enable-continuous-cloudwatch-log": 継続的ログを有効化 ("true"/"false")
  #   - "--enable-continuous-log-filter": ドライバー/エグゼキュータログのフィルタリング
  #   - "--enable-metrics": Glueメトリクスの有効化 (値は空文字列 "")
  #   - "--enable-auto-scaling": Glue Auto Scalingの有効化 ("true"/"false")
  #   - "--TempDir": 一時データ用S3パス
  #   - "--job-bookmark-option": ジョブブックマーク設定
  #     "job-bookmark-enable": ブックマーク有効化
  #     "job-bookmark-disable": ブックマーク無効化
  # 省略時: null
  # 参考: https://docs.aws.amazon.com/glue/latest/dg/aws-glue-programming-etl-glue-arguments.html
  default_arguments = {
    "--job-language"                     = "python"
    "--continuous-log-logGroup"          = "/aws-glue/jobs"
    "--enable-continuous-cloudwatch-log" = "true"
    "--enable-continuous-log-filter"     = "true"
    "--enable-metrics"                   = ""
    "--enable-auto-scaling"              = "true"
    "--TempDir"                          = "s3://example-bucket/temp/"
  }

  # non_overridable_arguments (Optional)
  # 設定内容: ジョブ実行時に上書きできない引数を名前と値のペアで指定します。
  #           セキュリティ上の理由から変更を禁止する引数に使用します。
  # 設定可能な値: キーと値のペアのマップ
  # 省略時: null
  non_overridable_arguments = null

  #-------------------------------------------------------------
  # 実行プロパティ設定
  #-------------------------------------------------------------

  # execution_property (Optional)
  # 設定内容: ジョブの実行プロパティを設定するブロックです。
  execution_property {

    # max_concurrent_runs (Optional)
    # 設定内容: ジョブで許可される最大同時実行数を指定します。
    # 設定可能な値: 正の整数
    # 省略時: 1
    max_concurrent_runs = 1
  }

  #-------------------------------------------------------------
  # 通知プロパティ設定
  #-------------------------------------------------------------

  # notification_property (Optional)
  # 設定内容: ジョブの通知プロパティを設定するブロックです。
  notification_property {

    # notify_delay_after (Optional)
    # 設定内容: ジョブ実行開始後、ジョブ実行遅延通知を送信するまでの待機時間を分単位で指定します。
    # 設定可能な値: 正の整数（分）
    # 省略時: 通知なし
    notify_delay_after = 3
  }

  #-------------------------------------------------------------
  # ソースコントロール設定
  #-------------------------------------------------------------

  # source_control_details (Optional)
  # 設定内容: ジョブアーティファクトをリモートリポジトリと同期するためのソースコントロール設定ブロックです。
  # source_control_details {

    # provider (Optional)
    # 設定内容: リモートリポジトリのプロバイダーを指定します。
    # 設定可能な値: "GITHUB", "GITLAB", "BITBUCKET", "AWS_CODE_COMMIT"
    # 省略時: null
    # provider = "GITHUB"

    # repository (Optional)
    # 設定内容: ジョブアーティファクトを含むリモートリポジトリ名を指定します。
    # 設定可能な値: 任意の文字列
    # 省略時: null
    # repository = "my-glue-repo"

    # owner (Optional)
    # 設定内容: ジョブアーティファクトを含むリモートリポジトリのオーナーを指定します。
    # 設定可能な値: 任意の文字列
    # 省略時: null
    # owner = "my-github-org"

    # branch (Optional)
    # 設定内容: リモートリポジトリのブランチ名を指定します。
    # 設定可能な値: 任意の文字列
    # 省略時: null
    # branch = "main"

    # folder (Optional)
    # 設定内容: リモートリポジトリ内のフォルダパスを指定します。
    # 設定可能な値: 任意の文字列
    # 省略時: null
    # folder = "glue-scripts"

    # last_commit_id (Optional)
    # 設定内容: リモートリポジトリのコミットIDを指定します。
    # 設定可能な値: 任意のコミットID文字列
    # 省略時: null
    # last_commit_id = null

    # auth_strategy (Optional)
    # 設定内容: 認証方式を指定します。AWS Secrets ManagerまたはPersonalアクセストークンを選択します。
    # 設定可能な値:
    #   - "PERSONAL_ACCESS_TOKEN": 個人アクセストークンを使用
    #   - "AWS_SECRETS_MANAGER": AWS Secrets Managerに格納されたトークンを使用
    # 省略時: null
    # auth_strategy = "AWS_SECRETS_MANAGER"

    # auth_token (Optional)
    # 設定内容: 認証トークンの値を指定します。
    # 設定可能な値: 認証トークン文字列またはSecrets Manager シークレットARN
    # 省略時: null
    # auth_token = null

  # }

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 省略時: タグなし
  # 参考: プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #       一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "example-glue-job"
    Environment = "production"
    ManagedBy   = "terraform"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: Glue JobのAmazon Resource Name (ARN)
# - id: ジョブ名（nameと同一）
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
