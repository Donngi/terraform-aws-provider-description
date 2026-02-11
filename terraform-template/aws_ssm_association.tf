#---------------------------------------------------------------
# AWS Systems Manager Association
#---------------------------------------------------------------
#
# SSMドキュメントをEC2インスタンスまたはタグに関連付けるリソースです。
# State Managerを使用して、管理対象ノードに対してコマンドやスクリプトを
# 定期的に実行したり、構成を適用したりすることができます。
#
# AWS公式ドキュメント:
#   - Systems Manager Association について: https://docs.aws.amazon.com/systems-manager/latest/userguide/systems-manager-state.html
#   - Cron および Rate 式: https://docs.aws.amazon.com/systems-manager/latest/userguide/reference-cron-and-rate-expressions.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_association
#
# Provider Version: 6.28.0
# Generated: 2026-02-05
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_ssm_association" "example" {
  #---------------------------------------------------------------
  # 必須パラメータ
  #---------------------------------------------------------------

  # 適用するSSMドキュメントの名前
  # 例: "AWS-RunShellScript", "AWS-UpdateSSMAgent", カスタムドキュメント名など
  name = "AWS-RunShellScript"

  #---------------------------------------------------------------
  # オプションパラメータ
  #---------------------------------------------------------------

  # Associationの分かりやすい名前
  # 管理を容易にするための識別子として使用
  association_name = null

  # ドキュメントのバージョン
  # 未指定の場合はデフォルトバージョンが使用される
  # 例: "1", "$LATEST", "$DEFAULT"
  document_version = null

  # スケジュール式でのみ実行するかどうか
  # true: 関連付け作成/更新時に即座に実行せず、スケジュールに従ってのみ実行
  # false (デフォルト): 作成/更新時に即座に実行し、その後スケジュールに従う
  # 注: Rate式では未サポート
  apply_only_at_cron_interval = null

  # 関連付けを実行するスケジュール式
  # Cron式の例: "cron(0 2 ? * SUN *)" (毎週日曜日 2:00 AM)
  # At式の例: "at(2020-07-07T15:55:00)" (1回のみ実行)
  # Rate式の例: "rate(7 days)" (7日ごと)
  # 参考: https://docs.aws.amazon.com/systems-manager/latest/userguide/reference-cron-and-rate-expressions.html
  schedule_expression = null

  # Change Calendarの名前（1つ以上）
  # カレンダーが開いている期間のみ関連付けが実行される
  calendar_names = null

  # 関連付けの実行を許可する最大同時ターゲット数
  # 数値（例: "10"）またはパーセンテージ（例: "10%"）で指定
  max_concurrency = null

  # システムがリクエスト送信を停止する前の許容エラー数
  # 数値（例: "10"）またはパーセンテージ（例: "10%"）で指定
  # 例: "3"を指定した場合、4つ目のエラーで停止
  max_errors = null

  # コンプライアンスの重大度
  # 指定可能な値: "UNSPECIFIED", "LOW", "MEDIUM", "HIGH", "CRITICAL"
  compliance_severity = null

  # コンプライアンス生成モード
  # "AUTO": 自動でコンプライアンスを生成
  # "MANUAL": 手動でコンプライアンスを管理
  sync_compliance = null

  # Automationドキュメント用のターゲットパラメータ名
  # Rate controlsを使用してリソースをターゲットにするAutomationドキュメントに必要
  # Automationの分岐方法を定義するSSMドキュメントパラメータを指定
  automation_target_parameter_name = null

  # SSMドキュメントに渡す任意の文字列パラメータのマップ
  # ドキュメントが必要とするパラメータをキー・バリュー形式で指定
  # 例: { "commands" = "echo Hello", "workingDirectory" = "/tmp" }
  parameters = null

  # 関連付けのステータスが Success になるまで待機する秒数
  # 指定時間内に Success にならない場合、作成操作は失敗
  wait_for_success_timeout_seconds = null

  # リージョンの指定
  # 未指定の場合はプロバイダー設定のリージョンが使用される
  region = null

  # リソースに割り当てるタグのマップ
  # プロバイダーの default_tags と組み合わせて使用可能
  tags = null

  # 全てのタグ（プロバイダーの default_tags を含む）
  # 通常は自動的に管理されるため明示的な設定は不要
  tags_all = null

  # IDの明示的な指定（通常は不要）
  # システムが自動的に生成するため、通常は指定しない
  id = null

  #---------------------------------------------------------------
  # ネストブロック: output_location
  #---------------------------------------------------------------
  # 関連付けの実行結果を保存するS3バケットの設定
  # 最大1つまで指定可能

  # output_location {
  #   # S3バケット名（必須）
  #   s3_bucket_name = "my-ssm-output-bucket"
  #
  #   # S3オブジェクトキーのプレフィックス（オプション）
  #   # 未設定の場合はバケットのルートに保存される
  #   s3_key_prefix = "ssm-outputs/"
  #
  #   # S3バケットのリージョン（オプション）
  #   # クロスリージョンでの出力保存に使用
  #   s3_region = "us-east-1"
  # }

  #---------------------------------------------------------------
  # ネストブロック: targets
  #---------------------------------------------------------------
  # 関連付けを適用するターゲット（インスタンスIDまたはタグ）の指定
  # 最大5つまで指定可能

  targets {
    # ターゲットのキー（必須）
    # "InstanceIds": インスタンスIDで指定
    # "tag:TagName": タグで指定（TagNameは実際のタグキー名に置き換える）
    key = "InstanceIds"

    # ターゲットの値（必須）
    # keyが"InstanceIds"の場合: インスタンスIDのリスト、または "*" で全インスタンス
    # keyが"tag:xxx"の場合: タグの値のリスト
    values = ["i-1234567890abcdef0"]
  }

  # タグベースのターゲット指定の例
  # targets {
  #   key    = "tag:Environment"
  #   values = ["Production", "Staging"]
  # }

  # 全インスタンスをターゲットにする例
  # targets {
  #   key    = "InstanceIds"
  #   values = ["*"]
  # }
}

#---------------------------------------------------------------
# Attributes Reference（参照専用属性）
#---------------------------------------------------------------
# 以下の属性はリソース作成後に参照可能（computed）で、
# 設定ファイルでの指定は不要です。
#
# - arn            : SSM AssociationのARN
# - association_id : SSM AssociationのID
#
#---------------------------------------------------------------
