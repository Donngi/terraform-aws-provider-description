#---------------------------------------------------------------
# AWS FIS Experiment Template
#---------------------------------------------------------------
#
# AWS Fault Injection Simulator (FIS) の実験テンプレートをプロビジョニングするリソースです。
# 実験テンプレートは、指定されたターゲットに対して実行される1つ以上のアクション、
# 実験が境界を超えないようにする停止条件、実験オプション、レポート設定を含みます。
# テンプレートを使用してカオスエンジニアリング実験を実施できます。
#
# AWS公式ドキュメント:
#   - FIS実験テンプレートの概要: https://docs.aws.amazon.com/fis/latest/userguide/experiment-templates.html
#   - FIS実験テンプレートの例: https://docs.aws.amazon.com/fis/latest/userguide/experiment-template-example.html
#   - FIS実験テンプレートの作成: https://docs.aws.amazon.com/fis/latest/userguide/create-template.html
#   - FISアクションリファレンス: https://docs.aws.amazon.com/fis/latest/userguide/fis-actions-reference.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/fis_experiment_template
#
# Provider Version: 6.28.0
# Generated: 2026-01-27
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_fis_experiment_template" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # description (Required)
  # 設定内容: 実験テンプレートの説明を指定します。
  # 設定可能な値: 文字列（実験の目的や内容を記述）
  # 用途: 実験の内容を識別・理解するための説明文
  description = "EC2 instances termination experiment to test auto-recovery"

  # role_arn (Required)
  # 設定内容: AWS FISサービスがユーザーに代わってサービスアクションを実行するための
  #          IAMロールのARNを指定します。
  # 設定可能な値: 有効なIAMロールARN
  # 関連機能: FIS実験ロール
  #   AWS FISに必要な権限（アクション実行、ターゲットリソースへのアクセス等）を
  #   付与するIAMロール。実験で実行するアクションに応じて適切な権限を設定する必要があります。
  #   - https://docs.aws.amazon.com/fis/latest/userguide/getting-started-iam-service-role.html
  role_arn = "arn:aws:iam::123456789012:role/FISExperimentRole"

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
  # アクション設定（実行する障害注入アクション）
  #-------------------------------------------------------------

  # action (Required, 最小1つ以上)
  # 設定内容: 実験中に実行するアクションを定義します。
  # 複数のアクションを指定でき、順序を制御したり並行実行も可能です。
  # 関連機能: FISアクション
  #   実験で実行する障害注入アクション。EC2インスタンス停止、ネットワーク遅延追加、
  #   API制限、CPU負荷テストなど様々なアクションが用意されています。
  #   - https://docs.aws.amazon.com/fis/latest/userguide/fis-actions-reference.html
  action {
    # name (Required)
    # 設定内容: アクションのわかりやすい名前を指定します。
    # 設定可能な値: 文字列（アクションを識別するための名前）
    name = "terminate-instances"

    # action_id (Required)
    # 設定内容: 実行するアクションのIDを指定します。
    # 設定可能な値: FISでサポートされているアクションID
    #   例: aws:ec2:terminate-instances, aws:ec2:stop-instances,
    #       aws:network:disrupt-connectivity, aws:ecs:drain-container-instances など
    # 参考: サポートされているアクション一覧
    #   - https://docs.aws.amazon.com/fis/latest/userguide/fis-actions-reference.html
    action_id = "aws:ec2:terminate-instances"

    # description (Optional)
    # 設定内容: アクションの説明を指定します。
    # 設定可能な値: 文字列（アクションの目的や詳細を記述）
    # 省略時: 説明なし
    description = "Terminate EC2 instances to test auto-recovery mechanism"

    # start_after (Optional)
    # 設定内容: このアクションを実行する前に完了させる必要があるアクション名のセットを指定します。
    # 設定可能な値: アクション名の文字列セット
    # 省略時: アクション開始時に即座に実行
    # 用途: アクションの実行順序を制御（例: 準備アクション完了後にメインアクションを実行）
    start_after = []

    # parameter (Optional)
    # 設定内容: アクションに渡すパラメーターを指定します。
    # アクションによって必要なパラメーターは異なります。
    # 参考: 各アクションのパラメーター一覧
    #   - https://docs.aws.amazon.com/fis/latest/userguide/fis-actions-reference.html
    parameter {
      # key (Required)
      # 設定内容: パラメーター名を指定します。
      # 設定可能な値: アクションがサポートするパラメーター名
      key = "instanceTerminationPercentage"

      # value (Required)
      # 設定内容: パラメーターの値を指定します。
      # 設定可能な値: パラメーターに応じた有効な値
      value = "50"
    }

    # target (Optional, 最大1つ)
    # 設定内容: アクションのターゲットを指定します。
    # 関連機能: アクションターゲット
    #   アクションを実行する対象リソースの種類とターゲット名を紐付けます。
    #   - https://docs.aws.amazon.com/fis/latest/userguide/action-sequence.html#action-targets
    target {
      # key (Required)
      # 設定内容: ターゲットタイプを指定します。
      # 設定可能な値:
      #   - AutoScalingGroups: EC2 Auto Scalingグループ
      #   - Buckets: S3バケット
      #   - Cluster: EKSクラスター
      #   - Clusters: ECSクラスター
      #   - DBInstances: RDS DBインスタンス
      #   - Functions: Lambda関数
      #   - Instances: EC2インスタンス
      #   - ManagedResources: ARC zonal shiftが有効なリソース
      #   - Nodegroups: EKSノードグループ
      #   - Pods: EKSポッド
      #   - ReplicationGroups: ElastiCache Redisレプリケーショングループ
      #   - Roles: IAMロール
      #   - SpotInstances: EC2スポットインスタンス
      #   - Subnets: VPCサブネット
      #   - Tables: DynamoDB暗号化グローバルテーブル
      #   - Tasks: ECSタスク
      #   - TransitGateways: Transit Gateway
      #   - Volumes: EBSボリューム
      # 参考: https://docs.aws.amazon.com/fis/latest/userguide/action-sequence.html#action-targets
      key = "Instances"

      # value (Required)
      # 設定内容: ターゲット名を指定します。
      # 設定可能な値: 対応するtargetブロックで定義されたターゲット名
      value = "target-ec2-instances"
    }
  }

  #-------------------------------------------------------------
  # 停止条件設定（実験の停止トリガー）
  #-------------------------------------------------------------

  # stop_condition (Required, 最小1つ以上)
  # 設定内容: 実験を停止する条件を定義します。
  # 関連機能: FIS停止条件
  #   アプリケーションパフォーマンスが許容できない閾値に達した場合に
  #   実験を自動停止するためのCloudWatchアラーム条件。
  #   - https://docs.aws.amazon.com/fis/latest/userguide/stop-conditions.html
  stop_condition {
    # source (Required)
    # 設定内容: 停止条件のソースを指定します。
    # 設定可能な値:
    #   - none: 停止条件なし（手動停止のみ）
    #   - aws:cloudwatch:alarm: CloudWatchアラームによる停止
    source = "aws:cloudwatch:alarm"

    # value (Optional)
    # 設定内容: CloudWatchアラームのARNを指定します。
    # 設定可能な値: 有効なCloudWatchアラームARN
    # 省略時: sourceが"none"の場合は不要
    # 注意: sourceが"aws:cloudwatch:alarm"の場合は必須
    value = "arn:aws:cloudwatch:ap-northeast-1:123456789012:alarm:HighCPUAlarm"
  }

  #-------------------------------------------------------------
  # ターゲット設定（障害注入対象リソース）
  #-------------------------------------------------------------

  # target (Optional)
  # 設定内容: アクションの対象となるAWSリソースを定義します。
  # 関連機能: FISターゲット
  #   実験で障害を注入する対象のAWSリソースを指定します。
  #   タグ、ARN、フィルターを使用してターゲットを選択できます。
  #   - https://docs.aws.amazon.com/fis/latest/userguide/targets.html
  target {
    # name (Required)
    # 設定内容: ターゲットのわかりやすい名前を指定します。
    # 設定可能な値: 文字列（アクションからターゲットを参照する際に使用）
    name = "target-ec2-instances"

    # resource_type (Required)
    # 設定内容: AWSリソースタイプを指定します。
    # 設定可能な値: 指定されたアクションでサポートされているリソースタイプ
    #   例: aws:ec2:instance, aws:ecs:cluster, aws:rds:db, aws:lambda:function など
    # 参考: リソースタイプ一覧
    #   - https://docs.aws.amazon.com/fis/latest/userguide/targets.html#resource-types
    resource_type = "aws:ec2:instance"

    # selection_mode (Required)
    # 設定内容: 識別されたリソースのスコープを指定します。
    # 設定可能な値:
    #   - ALL: 識別されたすべてのリソース
    #   - COUNT(n): 識別されたリソースからランダムにn個選択
    #   - PERCENT(n): 識別されたリソースからランダムにn%選択
    # 例: COUNT(1), COUNT(5), PERCENT(20), ALL
    selection_mode = "COUNT(2)"

    # resource_arns (Optional)
    # 設定内容: ターゲットとするリソースのARNセットを指定します。
    # 設定可能な値: リソースARNの文字列セット
    # 省略時: resource_tagまたはfilterで選択
    # 注意: resource_tagと排他的（どちらか一方のみ指定可能）
    resource_arns = []

    # parameters (Optional)
    # 設定内容: リソースタイプパラメーターを指定します。
    # 設定可能な値: キーと値のペアのマップ
    # 省略時: パラメーターなし
    parameters = {}

    # resource_tag (Optional, 最大50個)
    # 設定内容: リソースがアクションの有効なターゲットと見なされるために
    #          必要なタグを指定します。
    # 注意: resource_arnsと排他的（どちらか一方のみ指定可能）
    resource_tag {
      # key (Required)
      # 設定内容: タグキーを指定します。
      # 設定可能な値: 文字列
      key = "Environment"

      # value (Required)
      # 設定内容: タグ値を指定します。
      # 設定可能な値: 文字列
      value = "production"
    }

    # filter (Optional)
    # 設定内容: ターゲットのフィルターを指定します。
    # リソースタイプの該当するdescribeアクションで返される特定の属性に基づいて
    # リソースを選択できます。
    # 関連機能: ターゲットフィルター
    #   リソースの属性値に基づいてターゲットをフィルタリングします。
    #   複数のfilterブロック間の値はAND条件、1つのfilter内の値はOR条件で結合されます。
    #   - https://docs.aws.amazon.com/fis/latest/userguide/targets.html#target-filters
    filter {
      # path (Required)
      # 設定内容: フィルターの属性パスを指定します。
      # 設定可能な値: リソースタイプのdescribe APIで返される属性パス
      #   例: State.Name, Placement.AvailabilityZone など
      path = "State.Name"

      # values (Required)
      # 設定内容: フィルターの属性値セットを指定します。
      # 設定可能な値: 文字列セット（OR条件で評価）
      # 注意: 1つのfilter内の複数の値はOR条件で結合され、
      #      複数のfilterブロック間はAND条件で結合されます。
      values = ["running"]
    }
  }

  #-------------------------------------------------------------
  # 実験オプション設定
  #-------------------------------------------------------------

  # experiment_options (Optional, 最大1つ)
  # 設定内容: 実験テンプレートの追加オプションを指定します。
  # 関連機能: FIS実験オプション
  #   実験の実行方法に関する追加設定。アカウントターゲティング、
  #   空ターゲット解決モードなどを設定できます。
  #   - https://docs.aws.amazon.com/fis/latest/userguide/experiment-options.html
  experiment_options {
    # account_targeting (Optional)
    # 設定内容: 実験のアカウントターゲティング設定を指定します。
    # 設定可能な値:
    #   - single-account: 単一アカウント内でのみ実験を実行
    #   - multi-account: 複数アカウントにまたがって実験を実行
    # 省略時: single-account
    account_targeting = "single-account"

    # empty_target_resolution_mode (Optional)
    # 設定内容: ターゲットが空の場合の解決モードを指定します。
    # 設定可能な値:
    #   - fail: ターゲットが空の場合に実験を失敗させる
    #   - skip: ターゲットが空の場合にアクションをスキップして継続
    # 省略時: fail
    # 用途: ターゲットが見つからない場合の動作を制御
    empty_target_resolution_mode = "fail"
  }

  #-------------------------------------------------------------
  # ログ設定
  #-------------------------------------------------------------

  # log_configuration (Optional, 最大1つ)
  # 設定内容: 実験ログの設定を指定します。
  # 関連機能: FIS実験ログ
  #   実験の実行ログをCloudWatch LogsまたはS3に出力する設定。
  #   実験の動作を追跡・監査するために使用します。
  #   - https://docs.aws.amazon.com/fis/latest/userguide/monitoring-logging.html
  log_configuration {
    # log_schema_version (Required)
    # 設定内容: ログスキーマバージョンを指定します。
    # 設定可能な値: サポートされているスキーマバージョン番号（通常は 1 または 2）
    # 参考: スキーマバージョン一覧
    #   - https://docs.aws.amazon.com/fis/latest/userguide/monitoring-logging.html#experiment-log-schema
    log_schema_version = 2

    # cloudwatch_logs_configuration (Optional, 最大1つ)
    # 設定内容: CloudWatch Logsへのログ出力設定を指定します。
    cloudwatch_logs_configuration {
      # log_group_arn (Required)
      # 設定内容: 送信先のCloudWatch LogsロググループのARNを指定します。
      # 設定可能な値: CloudWatch LogsロググループARN
      # 注意: ARNの末尾は `:*` で終わる必要があります
      log_group_arn = "arn:aws:logs:ap-northeast-1:123456789012:log-group:/aws/fis/experiments:*"
    }

    # s3_configuration (Optional, 最大1つ)
    # 設定内容: S3へのログ出力設定を指定します。
    s3_configuration {
      # bucket_name (Required)
      # 設定内容: 送信先S3バケット名を指定します。
      # 設定可能な値: 有効なS3バケット名
      bucket_name = "my-fis-experiment-logs"

      # prefix (Optional)
      # 設定内容: S3バケット内のプレフィックスを指定します。
      # 設定可能な値: 文字列（ログファイルのパスプレフィックス）
      # 省略時: バケットのルートに保存
      prefix = "fis-logs/"
    }
  }

  #-------------------------------------------------------------
  # 実験レポート設定
  #-------------------------------------------------------------

  # experiment_report_configuration (Optional, 最大1つ)
  # 設定内容: 実験レポートの設定を指定します。
  # 関連機能: FIS実験レポート
  #   実験の結果を視覚化したレポートを生成する設定。
  #   CloudWatchダッシュボードのメトリクスを使用してレポートを作成します。
  #   - https://docs.aws.amazon.com/fis/latest/userguide/experiment-report-configuration.html
  experiment_report_configuration {
    # pre_experiment_duration (Optional)
    # 設定内容: 実験前期間の時間を指定します。
    # 設定可能な値: ISO 8601期間形式（例: PT5M = 5分, PT20M = 20分, PT1H = 1時間）
    # 省略時: PT20M（20分）
    # 用途: 実験前のベースライン期間を定義
    pre_experiment_duration = "PT20M"

    # post_experiment_duration (Optional)
    # 設定内容: 実験後期間の時間を指定します。
    # 設定可能な値: ISO 8601期間形式（例: PT5M = 5分, PT20M = 20分, PT1H = 1時間）
    # 省略時: PT20M（20分）
    # 用途: 実験後の回復期間を定義
    post_experiment_duration = "PT20M"

    # data_sources (Required, 最大1つ)
    # 設定内容: 実験レポートのデータソースを指定します。
    data_sources {
      # cloudwatch_dashboard (Required)
      # 設定内容: CloudWatchダッシュボードの設定を指定します。
      cloudwatch_dashboard {
        # dashboard_arn (Optional)
        # 設定内容: CloudWatchダッシュボードのARNを指定します。
        # 設定可能な値: CloudWatchダッシュボードARN
        # 省略時: ダッシュボード指定なし
        dashboard_arn = "arn:aws:cloudwatch::123456789012:dashboard/MyDashboard"
      }
    }

    # outputs (Required, 最大1つ)
    # 設定内容: 実験レポートの出力設定を指定します。
    outputs {
      # s3_configuration (Required, 最大1つ)
      # 設定内容: S3への出力設定を指定します。
      s3_configuration {
        # bucket_name (Required)
        # 設定内容: 送信先S3バケット名を指定します。
        # 設定可能な値: 有効なS3バケット名
        bucket_name = "my-fis-experiment-reports"

        # prefix (Optional)
        # 設定内容: S3バケット内のプレフィックスを指定します。
        # 設定可能な値: 文字列（レポートファイルのパスプレフィックス）
        # 省略時: バケットのルートに保存
        prefix = "reports/"
      }
    }
  }

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
    Name        = "ec2-termination-experiment"
    Environment = "testing"
    Purpose     = "chaos-engineering"
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウトを指定します。
  timeouts {
    # create (Optional)
    # 設定内容: リソース作成時のタイムアウトを指定します。
    # 設定可能な値: 時間文字列（例: "30m", "1h"）
    # 省略時: デフォルトタイムアウト
    create = null

    # update (Optional)
    # 設定内容: リソース更新時のタイムアウトを指定します。
    # 設定可能な値: 時間文字列（例: "30m", "1h"）
    # 省略時: デフォルトタイムアウト
    update = null

    # delete (Optional)
    # 設定内容: リソース削除時のタイムアウトを指定します。
    # 設定可能な値: 時間文字列（例: "30m", "1h"）
    # 省略時: デフォルトタイムアウト
    delete = null
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: 実験テンプレートID
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
