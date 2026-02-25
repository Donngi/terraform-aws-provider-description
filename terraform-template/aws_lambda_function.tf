#---------------------------------------------------------------
# AWS Lambda Function
#---------------------------------------------------------------
#
# AWS Lambdaのサーバーレス関数をプロビジョニングするリソースです。
# コードをアップロードするだけでサーバーの管理なしにイベント駆動で実行できます。
# Zipパッケージ・コンテナイメージの両デプロイ形式に対応しています。
#
# AWS公式ドキュメント:
#   - AWS Lambda とは: https://docs.aws.amazon.com/lambda/latest/dg/welcome.html
#   - Lambda 関数の設定: https://docs.aws.amazon.com/lambda/latest/dg/configuration-function-common.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_lambda_function" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # function_name (Required)
  # 設定内容: Lambda関数の一意な名前を指定します。
  # 設定可能な値: 最大64文字。英数字、ハイフン、アンダースコアが使用可能
  function_name = "example-lambda-function"

  # role (Required)
  # 設定内容: 関数の実行ロールのARNを指定します。ロールが関数のIDとAWSサービスへのアクセスを提供します。
  # 設定可能な値: 有効なIAMロールARN
  role = "arn:aws:iam::123456789012:role/lambda-execution-role"

  # description (Optional)
  # 設定内容: Lambda関数の説明を指定します。
  # 設定可能な値: 任意の文字列
  # 省略時: 説明なし
  description = "Example Lambda function"

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # デプロイパッケージ設定
  #-------------------------------------------------------------

  # package_type (Optional)
  # 設定内容: Lambdaデプロイパッケージの種別を指定します。
  # 設定可能な値:
  #   - "Zip" (デフォルト): ZIPアーカイブファイル形式
  #   - "Image": コンテナイメージ形式
  # 省略時: "Zip"
  package_type = "Zip"

  # filename (Optional)
  # 設定内容: ローカルファイルシステム上のデプロイパッケージのパスを指定します。
  # 設定可能な値: 有効なファイルパス文字列
  # 省略時: image_uri または s3_bucket を指定する必要があります
  # 注意: image_uri および s3_bucket と排他的。filename / image_uri / s3_bucket のいずれか1つが必須
  filename = "function.zip"

  # s3_bucket (Optional)
  # 設定内容: デプロイパッケージを含むS3バケットを指定します。
  # 設定可能な値: 有効なS3バケット名
  # 注意: filename および image_uri と排他的。s3_key も合わせて指定が必要
  s3_bucket = null

  # s3_key (Optional)
  # 設定内容: S3バケット内のデプロイパッケージのオブジェクトキーを指定します。
  # 設定可能な値: 有効なS3オブジェクトキー文字列
  # 省略時: s3_bucket を指定した場合は必須
  s3_key = null

  # s3_object_version (Optional)
  # 設定内容: デプロイパッケージのS3オブジェクトバージョンを指定します。
  # 設定可能な値: 有効なS3オブジェクトバージョンID文字列
  # 注意: filename および image_uri と排他的
  s3_object_version = null

  # image_uri (Optional)
  # 設定内容: コンテナイメージのECR URIを指定します。
  # 設定可能な値: 有効なECRイメージURI（例: 123456789012.dkr.ecr.ap-northeast-1.amazonaws.com/repo:tag）
  # 注意: filename および s3_bucket と排他的
  image_uri = null

  # source_code_hash (Optional)
  # 設定内容: ソースコードパッケージファイルのユーザー定義ハッシュ値を指定します。
  #           ローカルソースコード変更を更新トリガーとして利用する場合に使用します。
  # 設定可能な値: ハッシュ文字列
  # 省略時: ハッシュによる変更検知は行われません
  # 注意: code_sha256 は帯域外変更も含む変更を捕捉するためこちらを推奨
  source_code_hash = null

  # code_sha256 (Optional)
  # 設定内容: ソースコードパッケージファイルのBase64エンコードされたSHA-256ハッシュを指定します。
  #           ソースコード変更を更新トリガーとして利用する場合に使用します。
  # 設定可能な値: Base64エンコードされたSHA-256ハッシュ文字列
  # 省略時: ハッシュによる変更検知は行われません
  code_sha256 = null

  # source_kms_key_arn (Optional)
  # 設定内容: .zipデプロイパッケージの暗号化に使用するKMSキーのARNを指定します。
  # 設定可能な値: 有効なKMSキーARN
  # 注意: image_uri と排他的
  source_kms_key_arn = null

  #-------------------------------------------------------------
  # ランタイム設定
  #-------------------------------------------------------------

  # runtime (Optional)
  # 設定内容: 関数のランタイム識別子を指定します。
  # 設定可能な値: nodejs20.x, nodejs22.x, python3.12, python3.13, java21, dotnet8, ruby3.3 等
  #   参考: https://docs.aws.amazon.com/lambda/latest/dg/API_CreateFunction.html#SSS-CreateFunction-request-Runtime
  # 省略時: package_type = "Image" の場合は不要。"Zip" の場合は必須
  runtime = "nodejs20.x"

  # handler (Optional)
  # 設定内容: コード内の関数エントリーポイントを指定します。
  # 設定可能な値: <ファイル名>.<関数名> 形式の文字列（例: index.handler）
  # 省略時: package_type = "Image" の場合は不要。"Zip" の場合は必須
  handler = "index.handler"

  # architectures (Optional)
  # 設定内容: Lambda関数の命令セットアーキテクチャを指定します。
  # 設定可能な値:
  #   - ["x86_64"] (デフォルト): x86_64アーキテクチャ
  #   - ["arm64"]: AWS Gravitonアーキテクチャ（コスト効率向上）
  # 省略時: ["x86_64"]
  # 注意: この属性を削除しても関数のアーキテクチャは変更されません
  architectures = ["x86_64"]

  # layers (Optional)
  # 設定内容: 関数に付加するLambda Layerバージョンと共有ライブラリのARNリストを指定します。
  # 設定可能な値: 最大5つのLambdaレイヤーバージョンARNのリスト
  # 省略時: レイヤーなし
  layers = []

  #-------------------------------------------------------------
  # パフォーマンス設定
  #-------------------------------------------------------------

  # memory_size (Optional)
  # 設定内容: 実行時に使用できるメモリ量をMB単位で指定します。
  # 設定可能な値: 128〜32768 MB（32 GB）を1 MBの増分で指定
  # 省略時: 128 MB
  memory_size = 128

  # timeout (Optional)
  # 設定内容: 関数の最大実行時間を秒単位で指定します。
  # 設定可能な値: 1〜900 秒
  # 省略時: 3 秒
  timeout = 3

  # reserved_concurrent_executions (Optional)
  # 設定内容: この関数の予約済み同時実行数を指定します。
  # 設定可能な値:
  #   - 0: Lambda関数のトリガーを無効化
  #   - -1: 同時実行の制限を削除（未予約同時実行を使用）
  #   - 正の整数: 指定した数の同時実行を予約
  # 省略時: -1（未予約同時実行を使用）
  reserved_concurrent_executions = -1

  #-------------------------------------------------------------
  # コード署名設定
  #-------------------------------------------------------------

  # code_signing_config_arn (Optional)
  # 設定内容: コード署名を有効にするためのコード署名設定のARNを指定します。
  # 設定可能な値: 有効なコード署名設定ARN
  # 省略時: コード署名なし
  code_signing_config_arn = null

  #-------------------------------------------------------------
  # バージョン・エイリアス設定
  #-------------------------------------------------------------

  # publish (Optional)
  # 設定内容: 作成・変更時に新しいLambda関数バージョンを発行するかを指定します。
  # 設定可能な値:
  #   - true: バージョンを発行する
  #   - false (デフォルト): バージョンを発行しない
  # 省略時: false
  publish = false

  # publish_to (Optional)
  # 設定内容: エイリアスまたはバージョン番号への発行先を指定します。
  # 設定可能な値:
  #   - "LATEST_PUBLISHED": 最新発行バージョンへ
  #   - 省略: 通常のバージョン発行
  # 省略時: 通常のバージョン発行
  publish_to = null

  # skip_destroy (Optional)
  # 設定内容: Terraform destroy時にLambda関数を削除しないかを指定します。
  # 設定可能な値:
  #   - true: destroy時に削除せずTerraform stateからのみ削除
  #   - false (デフォルト): destroy時に削除
  # 省略時: false
  skip_destroy = false

  #-------------------------------------------------------------
  # 暗号化設定
  #-------------------------------------------------------------

  # kms_key_arn (Optional)
  # 設定内容: 環境変数の暗号化に使用するKMSキーのARNを指定します。
  # 設定可能な値: 有効なKMSキーARN
  # 省略時: 環境変数使用時はLambdaがデフォルトサービスキーを使用
  # 注意: KMSAccessDeniedException が発生する場合はIAMロールの再作成が原因の可能性あり
  kms_key_arn = null

  #-------------------------------------------------------------
  # VPC設定
  #-------------------------------------------------------------

  # vpc_config (Optional)
  # 設定内容: Lambda関数をVPC内のリソースに接続する場合の設定ブロックです。
  # 関連機能: Lambda VPCアクセス
  #   VPC内のRDS・ElastiCache等のリソースへの接続を可能にします。
  #   - https://docs.aws.amazon.com/lambda/latest/dg/configuration-vpc.html
  vpc_config {

    # subnet_ids (Required)
    # 設定内容: 関数に関連付けるサブネットIDのセットを指定します。
    # 設定可能な値: 有効なサブネットIDのセット
    # 注意: 高可用性のため複数AZのサブネットを指定することを推奨
    subnet_ids = ["subnet-12345678", "subnet-87654321"]

    # security_group_ids (Required)
    # 設定内容: 関数に関連付けるセキュリティグループIDのセットを指定します。
    # 設定可能な値: 有効なセキュリティグループIDのセット
    security_group_ids = ["sg-12345678"]

    # ipv6_allowed_for_dual_stack (Optional)
    # 設定内容: デュアルスタックサブネット接続時のIPv6アウトバウンドトラフィックを許可するかを指定します。
    # 設定可能な値:
    #   - true: IPv6トラフィックを許可
    #   - false: IPv6トラフィックを拒否
    # 省略時: false
    ipv6_allowed_for_dual_stack = false
  }

  # replace_security_groups_on_destroy (Optional)
  # 設定内容: 削除前にVPC設定のセキュリティグループを置き換えるかを指定します。
  # 設定可能な値:
  #   - true: 削除前にセキュリティグループを replacement_security_group_ids に置き換える
  #   - false (デフォルト): セキュリティグループを置き換えない
  # 省略時: false
  replace_security_groups_on_destroy = false

  # replacement_security_group_ids (Optional)
  # 設定内容: 削除前にVPC設定に割り当てるセキュリティグループIDのリストを指定します。
  # 設定可能な値: 有効なセキュリティグループIDのリスト
  # 省略時: replace_security_groups_on_destroy = true の場合は必須
  replacement_security_group_ids = []

  #-------------------------------------------------------------
  # 環境変数設定
  #-------------------------------------------------------------

  # environment (Optional)
  # 設定内容: 関数実行時に利用可能な環境変数の設定ブロックです。
  # 関連機能: Lambda 環境変数
  #   - https://docs.aws.amazon.com/lambda/latest/dg/configuration-envvars.html
  environment {

    # variables (Optional)
    # 設定内容: 関数実行時に利用可能な環境変数のキーと値のマップを指定します。
    # 設定可能な値: 文字列のキーバリューマップ
    # 省略時: 環境変数なし
    variables = {
      ENVIRONMENT = "production"
      LOG_LEVEL   = "info"
    }
  }

  #-------------------------------------------------------------
  # エフェメラルストレージ設定
  #-------------------------------------------------------------

  # ephemeral_storage (Optional)
  # 設定内容: Lambda関数の /tmp ディレクトリに割り当てるエフェメラルストレージ容量の設定ブロックです。
  # 関連機能: Lambda エフェメラルストレージ
  #   - https://docs.aws.amazon.com/lambda/latest/dg/configuration-ephemeral-storage.html
  ephemeral_storage {

    # size (Optional)
    # 設定内容: /tmp に割り当てるストレージ容量をMB単位で指定します。
    # 設定可能な値: 512〜10240 MB（10 GB）
    # 省略時: 512 MB
    size = 512
  }

  #-------------------------------------------------------------
  # EFSファイルシステム設定
  #-------------------------------------------------------------

  # file_system_config (Optional)
  # 設定内容: EFSファイルシステムのマウント設定ブロックです。
  # 関連機能: Lambda と Amazon EFS の統合
  #   Lambda関数からEFSへの永続ファイルアクセスを可能にします。
  #   - https://docs.aws.amazon.com/lambda/latest/dg/configuration-filesystem.html
  # 注意: VPC設定が必要。EFSマウントターゲットが存在するサブネットに配置すること
  file_system_config {

    # arn (Required)
    # 設定内容: Amazon EFSアクセスポイントのARNを指定します。
    # 設定可能な値: 有効なEFSアクセスポイントARN
    arn = "arn:aws:elasticfilesystem:ap-northeast-1:123456789012:access-point/fsap-12345678"

    # local_mount_path (Required)
    # 設定内容: 関数がファイルシステムにアクセスするパスを指定します。
    # 設定可能な値: /mnt/ で始まるパス文字列
    local_mount_path = "/mnt/data"
  }

  #-------------------------------------------------------------
  # コンテナイメージ設定
  #-------------------------------------------------------------

  # image_config (Optional)
  # 設定内容: コンテナイメージの設定値の設定ブロックです。package_type = "Image" の場合に使用します。
  # 関連機能: Lambda コンテナイメージサポート
  #   - https://docs.aws.amazon.com/lambda/latest/dg/images-create.html
  image_config {

    # command (Optional)
    # 設定内容: コンテナイメージに渡すパラメーターのリストを指定します。
    # 設定可能な値: 文字列のリスト（例: ["app.handler"]）
    # 省略時: イメージのデフォルトCMDを使用
    command = ["app.handler"]

    # entry_point (Optional)
    # 設定内容: アプリケーションのエントリーポイントのリストを指定します。
    # 設定可能な値: 文字列のリスト（例: ["/lambda-entrypoint.sh"]）
    # 省略時: イメージのデフォルトENTRYPOINTを使用
    entry_point = ["/lambda-entrypoint.sh"]

    # working_directory (Optional)
    # 設定内容: コンテナイメージの作業ディレクトリを指定します。
    # 設定可能な値: 有効なディレクトリパス文字列
    # 省略時: イメージのデフォルト作業ディレクトリを使用
    working_directory = "/var/task"
  }

  #-------------------------------------------------------------
  # ロギング設定
  #-------------------------------------------------------------

  # logging_config (Optional)
  # 設定内容: 高度なロギングの設定ブロックです。
  # 関連機能: Lambda 高度なロギング制御
  #   JSON構造化ログやログレベルフィルタリングが可能です。
  #   - https://docs.aws.amazon.com/lambda/latest/dg/monitoring-cloudwatchlogs.html
  logging_config {

    # log_format (Required)
    # 設定内容: ログのフォーマットを指定します。
    # 設定可能な値:
    #   - "Text": テキスト形式
    #   - "JSON": JSON構造化形式
    log_format = "JSON"

    # application_log_level (Optional)
    # 設定内容: アプリケーションログの詳細レベルを指定します。log_format = "JSON" の場合のみ有効です。
    # 設定可能な値: "TRACE", "DEBUG", "INFO", "WARN", "ERROR", "FATAL"
    # 省略時: フィルタリングなし
    application_log_level = "INFO"

    # system_log_level (Optional)
    # 設定内容: Lambdaプラットフォームログの詳細レベルを指定します。log_format = "JSON" の場合のみ有効です。
    # 設定可能な値: "DEBUG", "INFO", "WARN"
    # 省略時: フィルタリングなし
    system_log_level = "WARN"

    # log_group (Optional)
    # 設定内容: ログの送信先CloudWatch Logsグループを指定します。
    # 設定可能な値: 有効なCloudWatch Logsグループ名
    # 省略時: /aws/lambda/<function_name> に自動的に作成されます
    log_group = "/aws/lambda/example-lambda-function"
  }

  #-------------------------------------------------------------
  # トレーシング設定
  #-------------------------------------------------------------

  # tracing_config (Optional)
  # 設定内容: AWS X-Rayトレーシングの設定ブロックです。
  # 関連機能: Lambda X-Rayトレーシング
  #   分散アプリケーションのリクエストフローを可視化し、パフォーマンス問題の診断に活用できます。
  #   - https://docs.aws.amazon.com/lambda/latest/dg/services-xray.html
  tracing_config {

    # mode (Required)
    # 設定内容: X-Rayトレーシングモードを指定します。
    # 設定可能な値:
    #   - "Active": X-Rayサブセグメントのサンプリングとトレーシングを有効化
    #   - "PassThrough": 上流のサービスのサンプリング決定に従う
    mode = "Active"
  }

  #-------------------------------------------------------------
  # デッドレターキュー設定
  #-------------------------------------------------------------

  # dead_letter_config (Optional)
  # 設定内容: 非同期呼び出し失敗時の通知先の設定ブロックです。
  # 関連機能: Lambda デッドレターキュー
  #   非同期呼び出しが全リトライ後に失敗した場合にSNS/SQSへメッセージを送信します。
  #   - https://docs.aws.amazon.com/lambda/latest/dg/invocation-async.html#invocation-dlq
  dead_letter_config {

    # target_arn (Required)
    # 設定内容: 呼び出し失敗時の通知先SNSトピックまたはSQSキューのARNを指定します。
    # 設定可能な値: 有効なSNSトピックARNまたはSQSキューARN
    target_arn = "arn:aws:sqs:ap-northeast-1:123456789012:lambda-dlq"
  }

  #-------------------------------------------------------------
  # SnapStart設定
  #-------------------------------------------------------------

  # snap_start (Optional)
  # 設定内容: SnapStart最適化の設定ブロックです。コールドスタート時間を短縮します。
  # 関連機能: Lambda SnapStart
  #   初期化済みの実行環境スナップショットからの高速起動を実現します。
  #   - https://docs.aws.amazon.com/lambda/latest/dg/snapstart.html
  snap_start {

    # apply_on (Required)
    # 設定内容: SnapStart最適化を適用するタイミングを指定します。
    # 設定可能な値:
    #   - "PublishedVersions": バージョン発行時にSnapStartを適用
    apply_on = "PublishedVersions"
  }

  #-------------------------------------------------------------
  # 耐久性設定
  #-------------------------------------------------------------

  # durable_config (Optional)
  # 設定内容: 長時間実行関数の耐久性設定ブロックです。
  # 設定可能な値: execution_timeout と retention_period で構成
  # 注意: durable_config は限定リージョン（us-east-2 等）でのみ利用可能です
  #   - https://builder.aws.com/build/capabilities
  durable_config {

    # execution_timeout (Required)
    # 設定内容: 耐久性関数の最大実行時間を秒単位で指定します。
    # 設定可能な値: 1〜31622400 秒（366日）
    execution_timeout = 3600

    # retention_period (Optional)
    # 設定内容: 関数の実行状態を保持する日数を指定します。
    # 設定可能な値: 1〜90 日
    # 省略時: 実行状態を保持しない（14がデフォルト）
    retention_period = 14
  }

  #-------------------------------------------------------------
  # テナント分離設定
  #-------------------------------------------------------------

  # tenancy_config (Optional)
  # 設定内容: テナント分離モードの設定ブロックです。
  tenancy_config {

    # tenant_isolation_mode (Required)
    # 設定内容: テナント分離モードを指定します。
    # 設定可能な値:
    #   - "PER_TENANT": テナントごとの分離モード
    tenant_isolation_mode = "PER_TENANT"
  }

  #-------------------------------------------------------------
  # キャパシティプロバイダー設定
  #-------------------------------------------------------------

  # capacity_provider_config (Optional)
  # 設定内容: Lambda キャパシティプロバイダーの設定ブロックです。
  # 関連機能: Lambda Managed Instances キャパシティプロバイダー
  #   専用コンピューティングリソースを使用した関数の実行を可能にします。
  capacity_provider_config {

    # lambda_managed_instances_capacity_provider_config (Required)
    # 設定内容: Lambda Managed Instancesキャパシティプロバイダーの設定ブロックです。
    lambda_managed_instances_capacity_provider_config {

      # capacity_provider_arn (Required)
      # 設定内容: キャパシティプロバイダーのARNを指定します。
      # 設定可能な値: 有効なLambdaキャパシティプロバイダーARN
      capacity_provider_arn = "arn:aws:lambda:ap-northeast-1:123456789012:capacity-provider:example"

      # execution_environment_memory_gib_per_vcpu (Optional)
      # 設定内容: 実行環境のvCPUあたりのメモリ容量をGiB単位で指定します。
      # 設定可能な値: 有効な数値
      # 省略時: 自動で設定
      execution_environment_memory_gib_per_vcpu = null

      # per_execution_environment_max_concurrency (Optional)
      # 設定内容: 実行環境ごとの最大同時実行数を指定します。
      # 設定可能な値: 有効な数値
      # 省略時: 自動で設定
      per_execution_environment_max_concurrency = null
    }
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: Terraform操作のタイムアウト時間の設定ブロックです。
  # 注意: VPCに接続したLambda関数の削除は最大45分かかる場合があります
  timeouts {

    # create (Optional)
    # 設定内容: リソース作成のタイムアウト時間を指定します。
    # 設定可能な値: "30m", "1h" 等のGo duration文字列
    # 省略時: プロバイダーデフォルト
    create = null

    # update (Optional)
    # 設定内容: リソース更新のタイムアウト時間を指定します。
    # 設定可能な値: "30m", "1h" 等のGo duration文字列
    # 省略時: プロバイダーデフォルト
    update = null

    # delete (Optional)
    # 設定内容: リソース削除のタイムアウト時間を指定します。
    # 設定可能な値: "30m", "1h", "45m" 等のGo duration文字列
    # 省略時: プロバイダーデフォルト
    delete = "45m"
  }

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 省略時: タグなし
  # 参考: プロバイダーレベルの default_tags と一致するキーはプロバイダー定義を上書きします
  tags = {
    Name        = "example-lambda-function"
    Environment = "production"
    ManagedBy   = "terraform"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: Lambda関数のARN
# - invoke_arn: API Gateway統合用の呼び出しARN
# - qualified_arn: バージョン番号付きARN（publish = true の場合）
# - qualified_invoke_arn: バージョン番号付き呼び出しARN
# - response_streaming_invoke_arn: レスポンスストリーミング用呼び出しARN
# - last_modified: リソースの最終変更日時
# - source_code_size: .zipファイルのバイトサイズ
# - version: 最新公開バージョン番号
# - signing_job_arn: 署名ジョブのARN
# - signing_profile_version_arn: 署名プロファイルバージョンのARN
# - snap_start.optimization_status: SnapStart最適化のステータス（"On" / "Off"）
# - vpc_config.vpc_id: Lambda関数が接続されているVPCのID
# - tags_all: プロバイダーのdefault_tagsを含む全タグマップ
#---------------------------------------------------------------
