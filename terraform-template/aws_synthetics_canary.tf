#---------------------------------------------------------------
# Amazon CloudWatch Synthetics Canary
#---------------------------------------------------------------
#
# CloudWatch Syntheticsのカナリアをプロビジョニングするリソースです。
# カナリアはスクリプトを定期的に実行してエンドポイントやAPIの可用性・
# パフォーマンスを継続的に監視するモニタリングコンポーネントです。
# Node.js または Python ランタイムのスクリプトを使用してカナリアを構成できます。
#
# AWS公式ドキュメント:
#   - CloudWatch Synthetics 概要: https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/CloudWatch_Synthetics_Canaries.html
#   - カナリアの作成: https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/CloudWatch_Synthetics_Canaries_Create.html
#   - ランタイムバージョン: https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/CloudWatch_Synthetics_Canaries_Library.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/synthetics_canary
#
# Provider Version: 6.28.0
# Generated: 2026-02-19
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_synthetics_canary" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required, Forces new resource)
  # 設定内容: カナリアの名前を指定します。
  # 設定可能な値: 1〜21文字の小文字英数字・ハイフンのみ使用可能な文字列。
  #   先頭は英字である必要があります。
  name = "example-canary"

  # handler (Required)
  # 設定内容: カナリアスクリプトのエントリーポイントとなるハンドラー関数を指定します。
  # 設定可能な値: "ファイル名.エクスポート関数名" 形式の文字列
  #   例: "pageLoadBlueprint.handler" (Node.js の場合)
  #       "canary.handler" (Python の場合)
  handler = "pageLoadBlueprint.handler"

  # runtime_version (Required)
  # 設定内容: カナリアが使用するランタイムバージョンを指定します。
  # 設定可能な値: "syn-nodejs-puppeteer-X.X" または "syn-python-selenium-X.X" 形式の文字列
  #   例: "syn-nodejs-puppeteer-9.1", "syn-python-selenium-5.0"
  # 参考: https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/CloudWatch_Synthetics_Canaries_Library.html
  runtime_version = "syn-nodejs-puppeteer-9.1"

  # execution_role_arn (Required)
  # 設定内容: カナリアの実行に使用するIAMロールのARNを指定します。
  #   このロールにはカナリアの実行に必要な権限（S3書き込み、CloudWatch Logs書き込み等）が必要です。
  # 設定可能な値: 有効なIAMロールARN文字列
  execution_role_arn = "arn:aws:iam::123456789012:role/synthetics-canary-role"

  # artifact_s3_location (Required)
  # 設定内容: カナリアの実行結果（スクリーンショット、HAR、ログ等）を保存するS3の場所を指定します。
  # 設定可能な値: "s3://バケット名" または "s3://バケット名/プレフィックス/" 形式の文字列
  artifact_s3_location = "s3://my-canary-artifacts-bucket"

  #-------------------------------------------------------------
  # スクリプトコード設定（zip_file または s3_bucket/s3_key のいずれかを指定）
  #-------------------------------------------------------------

  # zip_file (Optional)
  # 設定内容: カナリアスクリプトを含むzipファイルのローカルパスをBase64エンコードして指定します。
  # 設定可能な値: ローカルファイルへのパス文字列（filebase64() 関数で読み込む）
  # 注意: s3_bucket/s3_key と排他的。どちらか一方のみ指定可能。
  zip_file = null

  # s3_bucket (Optional)
  # 設定内容: カナリアスクリプトのzipファイルが格納されているS3バケット名を指定します。
  # 設定可能な値: 有効なS3バケット名文字列
  # 注意: zip_file と排他的。s3_key との併用が必要。
  s3_bucket = null

  # s3_key (Optional)
  # 設定内容: S3バケット内のカナリアスクリプトzipファイルのキー（パス）を指定します。
  # 設定可能な値: 有効なS3オブジェクトキー文字列
  # 注意: zip_file と排他的。s3_bucket との併用が必要。
  s3_key = null

  # s3_version (Optional)
  # 設定内容: S3バケット内のカナリアスクリプトzipファイルのバージョンIDを指定します。
  # 設定可能な値: 有効なS3オブジェクトバージョンID文字列
  # 省略時: 最新バージョンを使用
  s3_version = null

  #-------------------------------------------------------------
  # 実行制御設定
  #-------------------------------------------------------------

  # start_canary (Optional)
  # 設定内容: カナリアを作成後に自動的に開始するかを指定します。
  # 設定可能な値:
  #   - true: 作成後にカナリアを自動開始
  #   - false: 作成後にカナリアを停止状態に保つ
  # 省略時: false
  start_canary = false

  # delete_lambda (Optional)
  # 設定内容: カナリアを削除する際に、関連するLambda関数も削除するかを指定します。
  # 設定可能な値:
  #   - true: カナリア削除時にLambda関数も削除
  #   - false: カナリア削除時にLambda関数を保持
  # 省略時: false
  delete_lambda = false

  # failure_retention_period (Optional)
  # 設定内容: 失敗したカナリア実行の結果をS3に保持する日数を指定します。
  # 設定可能な値: 1〜455の整数（日数）
  # 省略時: 31
  failure_retention_period = 31

  # success_retention_period (Optional)
  # 設定内容: 成功したカナリア実行の結果をS3に保持する日数を指定します。
  # 設定可能な値: 1〜455の整数（日数）
  # 省略時: 31
  success_retention_period = 31

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
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  tags = {
    Name        = "example-canary"
    Environment = "production"
  }

  #-------------------------------------------------------------
  # スケジュール設定
  #-------------------------------------------------------------

  # schedule (Required)
  # 設定内容: カナリアの実行スケジュールを設定するブロックです。
  schedule {
    # expression (Required)
    # 設定内容: カナリアの実行間隔をrate式またはcron式で指定します。
    # 設定可能な値:
    #   - "rate(0 minute)": 一度だけ実行（オンデマンド）
    #   - "rate(1 minute)": 1分ごとに実行
    #   - "rate(5 minutes)": 5分ごとに実行
    #   - "cron(0 * * * ? *)": 毎時0分に実行（cron式）
    # 参考: https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/CloudWatch_Synthetics_Canaries_cron.html
    expression = "rate(5 minutes)"

    # duration_in_seconds (Optional)
    # 設定内容: カナリアの継続実行時間を秒数で指定します。
    #   この時間を経過するとカナリアは停止します。
    # 設定可能な値: 正の整数（秒数）。0はカナリアを無期限に実行。
    # 省略時: 0（無期限）
    duration_in_seconds = 0

    # retry_config (Optional)
    # 設定内容: カナリア実行失敗時のリトライ設定ブロックです。
    retry_config {
      # max_retries (Required)
      # 設定内容: カナリア実行が失敗した場合の最大リトライ回数を指定します。
      # 設定可能な値: 0〜2の整数
      max_retries = 0
    }
  }

  #-------------------------------------------------------------
  # 実行設定
  #-------------------------------------------------------------

  # run_config (Optional)
  # 設定内容: カナリアの実行環境に関する設定ブロックです。
  run_config {
    # timeout_in_seconds (Optional)
    # 設定内容: カナリアが1回の実行でタイムアウトするまでの秒数を指定します。
    # 設定可能な値: 3〜840の整数（秒数）
    # 省略時: カナリアのランタイムに基づくデフォルト値（通常840秒）
    timeout_in_seconds = 60

    # memory_in_mb (Optional)
    # 設定内容: カナリアの実行に割り当てるメモリ量をMB単位で指定します。
    # 設定可能な値: 960〜3008の整数（MB）。64MBの倍数である必要があります。
    # 省略時: 1000
    memory_in_mb = 960

    # active_tracing (Optional)
    # 設定内容: カナリアのX-Rayアクティブトレースを有効にするかを指定します。
    # 設定可能な値:
    #   - true: X-Rayアクティブトレースを有効化
    #   - false: X-Rayアクティブトレースを無効化
    # 省略時: false
    # 注意: runtime_version に "syn-nodejs-puppeteer-3.4" 以降が必要
    active_tracing = false

    # environment_variables (Optional)
    # 設定内容: カナリアスクリプトに渡す環境変数のマップを指定します。
    # 設定可能な値: キーと値のペアのマップ（値は文字列）
    # 省略時: 環境変数なし
    environment_variables = {}

    # ephemeral_storage (Optional)
    # 設定内容: カナリアの実行環境に割り当てる一時ストレージの容量をMB単位で指定します。
    # 設定可能な値: 512〜10240の整数（MB）
    # 省略時: AWSが設定するデフォルト値
    ephemeral_storage = null
  }

  #-------------------------------------------------------------
  # アーティファクト暗号化設定
  #-------------------------------------------------------------

  # artifact_config (Optional)
  # 設定内容: カナリアのアーティファクト（実行結果ファイル）の暗号化設定ブロックです。
  artifact_config {
    # s3_encryption (Optional)
    # 設定内容: アーティファクトを保存するS3バケットの暗号化設定ブロックです。
    s3_encryption {
      # encryption_mode (Optional)
      # 設定内容: S3アーティファクトの暗号化モードを指定します。
      # 設定可能な値:
      #   - "SSE_S3": S3管理キーによるサーバーサイド暗号化
      #   - "SSE_KMS": AWS KMS管理キーによるサーバーサイド暗号化
      # 省略時: SSE_S3
      encryption_mode = "SSE_S3"

      # kms_key_arn (Optional)
      # 設定内容: SSE_KMS暗号化に使用するKMSキーのARNを指定します。
      # 設定可能な値: 有効なKMSキーARN文字列
      # 省略時: encryption_mode が "SSE_KMS" の場合はデフォルトのKMSキーを使用
      # 注意: encryption_mode が "SSE_KMS" の場合のみ有効
      kms_key_arn = null
    }
  }

  #-------------------------------------------------------------
  # VPC設定
  #-------------------------------------------------------------

  # vpc_config (Optional)
  # 設定内容: カナリアをVPC内から実行するためのVPC設定ブロックです。
  #   VPC内のリソースへアクセスする場合に設定します。
  # vpc_config {
  #   # subnet_ids (Optional)
  #   # 設定内容: カナリアを実行するサブネットIDのセットを指定します。
  #   # 設定可能な値: 有効なサブネットIDのセット
  #   subnet_ids = ["subnet-xxxxxxxx"]
  #
  #   # security_group_ids (Optional)
  #   # 設定内容: カナリアに関連付けるセキュリティグループIDのセットを指定します。
  #   # 設定可能な値: 有効なセキュリティグループIDのセット
  #   security_group_ids = ["sg-xxxxxxxx"]
  #
  #   # ipv6_allowed_for_dual_stack (Optional)
  #   # 設定内容: デュアルスタックサブネットでIPv6を許可するかを指定します。
  #   # 設定可能な値:
  #   #   - true: IPv6を許可
  #   #   - false: IPv6を許可しない
  #   # 省略時: false
  #   ipv6_allowed_for_dual_stack = false
  # }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: カナリアの名前
# - arn: カナリアのARN
# - engine_arn: カナリアを実行するLambda関数のARN
# - source_location_arn: カナリアのコードが格納されているS3の場所のARN
# - status: カナリアの現在のステータス
# - timeline: カナリアの作成・変更・起動・停止の時刻情報リスト
#   - created: カナリアの作成日時
#   - last_modified: カナリアの最終更新日時
#   - last_started: カナリアの最後の起動日時
#   - last_stopped: カナリアの最後の停止日時
# - tags_all: プロバイダーの default_tags 設定から継承されたタグを含む全タグマップ
#---------------------------------------------------------------
