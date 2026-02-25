#---------------------------------------------------------------
# AWS Systems Manager State Manager Association
#---------------------------------------------------------------
#
# AWS Systems Manager State Manager のアソシエーションをプロビジョニングするリソースです。
# アソシエーションは、マネージドノードやその他のAWSリソースに対して維持すべき
# 望ましい状態を定義し、SSMドキュメントをインスタンスまたはEC2タグに関連付けます。
# スケジュールに従って設定を自動的に適用し、構成ドリフトを防止します。
#
# AWS公式ドキュメント:
#   - State Manager概要: https://docs.aws.amazon.com/systems-manager/latest/userguide/systems-manager-state.html
#   - アソシエーションの作成: https://docs.aws.amazon.com/systems-manager/latest/userguide/state-manager-associations-creating.html
#   - アソシエーションの操作: https://docs.aws.amazon.com/systems-manager/latest/userguide/state-manager-associations.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_association
#
# Provider Version: 6.28.0
# Generated: 2026-02-19
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_ssm_association" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: 適用するSSMドキュメントの名前を指定します。
  # 設定可能な値: 有効なSSMドキュメント名（AWSマネージドドキュメントまたはカスタムドキュメント）
  #   例: "AmazonCloudWatch-ManageAgent", "AWS-RunShellScript", カスタムドキュメント名
  name = "AmazonCloudWatch-ManageAgent"

  # association_name (Optional)
  # 設定内容: アソシエーションのわかりやすい説明的な名前を指定します。
  # 設定可能な値: 文字列（英数字、ハイフン、アンダースコア）
  # 省略時: アソシエーション名なしで作成されます。
  association_name = "example-association"

  # document_version (Optional)
  # 設定内容: ターゲットに関連付けるドキュメントのバージョンを指定します。
  # 設定可能な値: 特定のバージョン番号（例: "1", "2"）または "$DEFAULT"（デフォルトバージョン）
  # 省略時: AWSが使用するバージョンを決定します。
  document_version = "$DEFAULT"

  #-------------------------------------------------------------
  # パラメーター設定
  #-------------------------------------------------------------

  # parameters (Optional)
  # 設定内容: SSMドキュメントに渡す任意の文字列パラメーターのブロックを指定します。
  # 設定可能な値: 文字列キーと文字列値のマップ
  # 省略時: ドキュメントのデフォルトパラメーターが使用されます。
  parameters = {
    action = "configure"
  }

  #-------------------------------------------------------------
  # スケジュール設定
  #-------------------------------------------------------------

  # schedule_expression (Optional)
  # 設定内容: アソシエーションを実行するスケジュールをcron式またはrate式で指定します。
  # 設定可能な値:
  #   - cron式: "cron(0 2 ? * SUN *)" （毎週日曜日の2時に実行）
  #   - rate式: "rate(7 days)" （7日ごとに実行）
  #   - at式: "at(2024-07-07T15:55:00)" （指定日時に1回実行）
  # 省略時: スケジュールなし（作成・更新時に即時実行）
  # 参考: https://docs.aws.amazon.com/systems-manager/latest/userguide/reference-cron-and-rate-expressions.html
  schedule_expression = "cron(0 2 ? * SUN *)"

  # apply_only_at_cron_interval (Optional)
  # 設定内容: アソシエーションを作成または更新した後に即時実行しないかどうかを指定します。
  # 設定可能な値:
  #   - true: 作成・更新時に即時実行せず、次のスケジュール実行時まで待機
  #   - false (デフォルト): 作成・更新時に即時実行し、以降はスケジュールに従って実行
  # 注意: rate式では使用できません。
  apply_only_at_cron_interval = false

  # calendar_names (Optional)
  # 設定内容: アソシエーションが実行されるSystems Manager Change Calendarの名前を指定します。
  # 設定可能な値: 1つ以上のChange Calendarドキュメント名またはARNのセット
  # 省略時: Change Calendarによる制限なしに実行されます。
  calendar_names = []

  #-------------------------------------------------------------
  # コンプライアンス設定
  #-------------------------------------------------------------

  # compliance_severity (Optional)
  # 設定内容: アソシエーションのコンプライアンス重要度を指定します。
  # 設定可能な値:
  #   - "UNSPECIFIED": 重要度未指定
  #   - "LOW": 低
  #   - "MEDIUM": 中
  #   - "HIGH": 高
  #   - "CRITICAL": 重大
  # 省略時: "UNSPECIFIED" が使用されます。
  compliance_severity = "MEDIUM"

  # sync_compliance (Optional)
  # 設定内容: アソシエーションのコンプライアンスを生成するモードを指定します。
  # 設定可能な値:
  #   - "AUTO": アソシエーション実行後に自動的にコンプライアンスを生成
  #   - "MANUAL": コンプライアンスを手動で生成
  # 省略時: "AUTO" が使用されます。
  sync_compliance = "AUTO"

  #-------------------------------------------------------------
  # レート制御設定
  #-------------------------------------------------------------

  # max_concurrency (Optional)
  # 設定内容: 同時にアソシエーションを実行できるターゲットの最大数を指定します。
  # 設定可能な値: 数値（例: "10"）またはターゲットセットのパーセンテージ（例: "10%"）
  # 省略時: すべてのターゲットで同時実行されます。
  max_concurrency = "50%"

  # max_errors (Optional)
  # 設定内容: 追加のターゲットへのリクエスト送信を停止するまでに許容するエラー数を指定します。
  # 設定可能な値: 数値（例: "10"）またはターゲットセットのパーセンテージ（例: "10%"）
  #   数値で3を指定すると、4番目のエラーが返された時点で停止します。
  #   50件のアソシエーションに対して10%を指定すると、6番目のエラーが返された時点で停止します。
  # 省略時: 制限なし。
  max_errors = "20%"

  # automation_target_parameter_name (Optional)
  # 設定内容: Automationドキュメントを使用してレートコントロールでリソースをターゲットとする際の
  #           SSMドキュメントパラメーター名を指定します。
  # 設定可能な値: Automationドキュメントのパラメーター名
  # 省略時: Automationドキュメントを使用しない場合は不要です。
  automation_target_parameter_name = null

  #-------------------------------------------------------------
  # 待機設定
  #-------------------------------------------------------------

  # wait_for_success_timeout_seconds (Optional)
  # 設定内容: アソシエーションのステータスが "Success" になるまで待機する秒数を指定します。
  # 設定可能な値: 正の整数（秒数）
  # 省略時: 作成操作がステータスを待機せずに完了します。
  # 注意: 指定した時間内に "Success" ステータスに達しない場合、作成操作は失敗します。
  wait_for_success_timeout_seconds = 300

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
  # 出力場所設定
  #-------------------------------------------------------------

  # output_location (Optional)
  # 設定内容: アソシエーションの実行結果を保存するS3バケットの設定ブロックです。
  # 省略時: 実行結果はS3に保存されません。
  output_location {

    # s3_bucket_name (Required)
    # 設定内容: 結果を保存するS3バケット名を指定します。
    # 設定可能な値: 有効なS3バケット名
    s3_bucket_name = "my-ssm-output-bucket"

    # s3_key_prefix (Optional)
    # 設定内容: S3バケット内の結果を保存するプレフィックスを指定します。
    # 設定可能な値: 有効なS3キープレフィックス文字列
    # 省略時: バケットのルートに保存されます。
    s3_key_prefix = "ssm-association-output/"

    # s3_region (Optional)
    # 設定内容: S3バケットが存在するリージョンを指定します。
    # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1）
    # 省略時: 現在のリージョンが使用されます。
    s3_region = "ap-northeast-1"
  }

  #-------------------------------------------------------------
  # ターゲット設定
  #-------------------------------------------------------------

  # targets (Optional)
  # 設定内容: SSMアソシエーションを適用するターゲットを指定するブロックです。
  # 設定可能な値: 最大5つのtargetsブロックを指定可能です。
  # 注意: targetsブロックを指定しない場合、アソシエーションはすべてのマネージドインスタンスに適用されます。
  targets {

    # key (Required)
    # 設定内容: ターゲットのキーを指定します。
    # 設定可能な値:
    #   - "InstanceIds": 特定のインスタンスIDを指定
    #   - "tag:タグ名": EC2タグに基づくターゲット指定（例: "tag:Environment"）
    key = "InstanceIds"

    # values (Required)
    # 設定内容: keyに対応するユーザー定義の条件（インスタンスIDまたはタグ値のリスト）を指定します。
    # 設定可能な値:
    #   - InstanceIds使用時: インスタンスIDのリスト（例: ["i-12345678", "i-87654321"]）
    #                         "*" を指定するとアカウント内の全マネージドインスタンスが対象
    #   - tag使用時: タグ値のリスト（例: ["Development", "Production"]）
    values = ["i-12345678901234567"]
  }

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 省略時: タグなし。プロバイダーのdefault_tagsが設定されている場合はそれが継承されます。
  tags = {
    Name        = "example-ssm-association"
    Environment = "production"
    ManagedBy   = "terraform"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: SSMアソシエーションのARN
# - association_id: SSMアソシエーションのID
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
