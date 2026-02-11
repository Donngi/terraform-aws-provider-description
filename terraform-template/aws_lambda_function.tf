#---------------------------------------------------------------
# AWS Lambda Function
#---------------------------------------------------------------
#
# AWS Lambdaは、サーバーレスコンピューティングサービスです。
# サーバーを管理することなく、イベント駆動でコードを実行できます。
# このリソースを使用して、Lambda関数を作成・管理します。
#
# AWS公式ドキュメント:
#   - What is AWS Lambda?: https://docs.aws.amazon.com/lambda/latest/dg/welcome.html
#   - Lambda Function Configuration: https://docs.aws.amazon.com/lambda/latest/dg/lambda-functions.html
#   - VPC Configuration: https://docs.aws.amazon.com/lambda/latest/dg/configuration-vpc.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function
#
# Provider Version: 6.28.0
# Generated: 2026-01-28
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_lambda_function" "example" {
  #---------------------------------------------------------------
  # 必須パラメータ
  #---------------------------------------------------------------

  # function_name - (必須) Lambda関数の一意な名前
  # 命名規則: 最大64文字、英数字とハイフン、アンダースコアが使用可能
  function_name = "example-lambda-function"

  # role - (必須) Lambda関数の実行ロールのARN
  # この実行ロールは、Lambda関数がAWSサービスやリソースにアクセスするために使用されます
  # 注意: 関数に権限を与えるためのロールであり、外部リソースから関数を呼び出すための
  # 権限はaws_lambda_permissionリソースで設定します
  role = "arn:aws:iam::123456789012:role/lambda-execution-role"

  #---------------------------------------------------------------
  # デプロイメントパッケージ設定（いずれか1つを指定）
  #---------------------------------------------------------------

  # filename - (オプション) ローカルファイルシステム上のデプロイパッケージ(.zip)のパス
  # image_uri、s3_bucketとは排他的です
  # package_type = "Zip"の場合に使用
  filename = "function.zip"

  # image_uri - (オプション) コンテナイメージのECR URI
  # filename、s3_bucketとは排他的です
  # package_type = "Image"の場合に使用
  # 例: "123456789012.dkr.ecr.us-east-1.amazonaws.com/my-function:latest"
  # image_uri = null

  # s3_bucket - (オプション) デプロイパッケージが格納されているS3バケット名
  # filename、image_uriとは排他的です
  # s3_key も合わせて指定が必要
  # s3_bucket = null

  # s3_key - (オプション) S3バケット内のオブジェクトキー
  # s3_bucketが指定されている場合は必須
  # s3_key = null

  # s3_object_version - (オプション) S3オブジェクトのバージョンID
  # バージョニングが有効なS3バケットで特定バージョンを使用する場合に指定
  # s3_object_version = null

  #---------------------------------------------------------------
  # ランタイム設定
  #---------------------------------------------------------------

  # runtime - (オプション) 関数のランタイム識別子
  # package_type = "Zip"の場合は必須
  # 有効な値: nodejs20.x, python3.12, java21, dotnet8, ruby3.3, provided.al2023 等
  # 最新のランタイム一覧: https://docs.aws.amazon.com/lambda/latest/dg/lambda-runtimes.html
  runtime = "nodejs20.x"

  # handler - (オプション) 関数のエントリーポイント
  # package_type = "Zip"の場合は必須
  # 形式: <ファイル名>.<関数名>
  # 例: Node.js の場合 "index.handler"、Python の場合 "lambda_function.lambda_handler"
  handler = "index.handler"

  # architectures - (オプション) 関数の命令セットアーキテクチャ
  # 有効な値: ["x86_64"] または ["arm64"]
  # デフォルト: ["x86_64"]
  # arm64（AWS Graviton2）は、コスト効率と性能が向上
  # この属性を削除しても、関数のアーキテクチャは変更されません
  architectures = ["x86_64"]

  # package_type - (オプション) Lambda デプロイパッケージのタイプ
  # 有効な値: "Zip" または "Image"
  # デフォルト: "Zip"
  package_type = "Zip"

  #---------------------------------------------------------------
  # メモリとタイムアウト設定
  #---------------------------------------------------------------

  # memory_size - (オプション) 関数が実行時に使用できるメモリ量（MB単位）
  # 有効な値: 128 MB から 10,240 MB（10 GB）の間で1 MB単位で設定可能
  # デフォルト: 128
  # メモリを増やすと、CPUパワーも比例して増加します
  memory_size = 128

  # timeout - (オプション) 関数の実行タイムアウト（秒単位）
  # 有効な値: 1秒から900秒（15分）
  # デフォルト: 3
  timeout = 3

  #---------------------------------------------------------------
  # コード整合性とバージョン管理
  #---------------------------------------------------------------

  # source_code_hash - (オプション) ソースコードパッケージファイルのハッシュ値
  # ローカルのソースコード変更を検出し、更新をトリガーするために使用
  # これはTerraform側で追跡される合成的な引数です
  # 外部での変更は検出されません。外部変更を含める場合はcode_sha256を使用
  # source_code_hash = filebase64sha256("function.zip")

  # code_sha256 - (オプション) ソースコードパッケージのBase64エンコードされたSHA-256ハッシュ
  # ソースコード変更時に更新をトリガーするために使用
  # コンテナイメージの場合、イメージダイジェストから直接取得されます
  # zipファイルの場合、.zipファイルのBase64エンコードされたSHA-256ハッシュ
  # レイヤーはこの計算に含まれません
  # code_sha256 = null

  # publish - (オプション) 作成/変更時に新しいLambda関数バージョンとして公開するかどうか
  # デフォルト: false
  # trueに設定すると、変更の度に新しいバージョン番号が割り当てられます
  publish = false

  # publish_to - (オプション) エイリアスまたはバージョン番号への公開設定
  # 通常のバージョン公開の場合は省略
  # 有効な値: "LATEST_PUBLISHED"
  # publish_to = null

  #---------------------------------------------------------------
  # 環境変数
  #---------------------------------------------------------------

  # environment - (オプション) 環境変数の設定ブロック
  environment {
    # variables - (オプション) 関数実行時に利用可能な環境変数のマップ
    variables = {
      ENVIRONMENT = "production"
      LOG_LEVEL   = "info"
    }
  }

  #---------------------------------------------------------------
  # レイヤー設定
  #---------------------------------------------------------------

  # layers - (オプション) Lambda Layer Version ARNのリスト（最大5つ）
  # レイヤーは、ライブラリや依存関係を関数コードと分離して管理できます
  # 複数の関数で共通の依存関係を共有する場合に有効
  # layers = ["arn:aws:lambda:us-east-1:123456789012:layer:my-layer:1"]

  #---------------------------------------------------------------
  # VPC設定
  #---------------------------------------------------------------

  # vpc_config - (オプション) VPC設定ブロック
  # Lambda関数をVPC内のリソースに接続する場合に使用
  # vpc_config {
  #   # subnet_ids - (必須) 関数に関連付けるサブネットIDのリスト
  #   # プライベートサブネットの使用を推奨
  #   # 複数のAZにまたがるサブネットを指定することで高可用性を確保
  #   subnet_ids = ["subnet-12345678", "subnet-87654321"]
  #
  #   # security_group_ids - (必須) 関数に関連付けるセキュリティグループIDのリスト
  #   security_group_ids = ["sg-12345678"]
  #
  #   # ipv6_allowed_for_dual_stack - (オプション) デュアルスタックサブネットに接続されたVPC関数でIPv6アウトバウンドトラフィックを許可するか
  #   # デフォルト: false
  #   ipv6_allowed_for_dual_stack = false
  # }

  #---------------------------------------------------------------
  # ストレージ設定
  #---------------------------------------------------------------

  # ephemeral_storage - (オプション) エフェメラルストレージ(/tmp)の設定
  # ephemeral_storage {
  #   # size - (必須) /tmpディレクトリのサイズ（MB単位）
  #   # 有効な値: 512 MB から 10,240 MB（10 GB）
  #   # デフォルト: 512
  #   size = 512
  # }

  # file_system_config - (オプション) EFSファイルシステムの設定
  # 関数コードから共有リソースにアクセス/変更する場合に使用
  # VPC設定も合わせて必要
  # file_system_config {
  #   # arn - (必須) Amazon EFS Access PointのARN
  #   arn = "arn:aws:elasticfilesystem:us-east-1:123456789012:access-point/fsap-12345678"
  #
  #   # local_mount_path - (必須) 関数がファイルシステムにアクセスできるパス
  #   # /mnt/で始まる必要があります
  #   local_mount_path = "/mnt/data"
  # }

  #---------------------------------------------------------------
  # ロギング設定
  #---------------------------------------------------------------

  # logging_config - (オプション) 高度なロギング設定ブロック
  # logging_config {
  #   # log_format - (必須) ログフォーマット
  #   # 有効な値: "Text" または "JSON"
  #   log_format = "JSON"
  #
  #   # application_log_level - (オプション) アプリケーションログの詳細レベル
  #   # 有効な値: "TRACE", "DEBUG", "INFO", "WARN", "ERROR", "FATAL"
  #   application_log_level = "INFO"
  #
  #   # system_log_level - (オプション) Lambdaプラットフォームログの詳細レベル
  #   # 有効な値: "DEBUG", "INFO", "WARN"
  #   system_log_level = "WARN"
  #
  #   # log_group - (オプション) ログの送信先CloudWatch Logsグループ
  #   # 指定しない場合、自動的に作成されます
  #   log_group = "/aws/lambda/example-function"
  # }

  #---------------------------------------------------------------
  # トレーシング設定
  #---------------------------------------------------------------

  # tracing_config - (オプション) AWS X-Rayトレーシング設定
  # tracing_config {
  #   # mode - (必須) トレーシングモード
  #   # 有効な値:
  #   #   - "Active": X-Rayトレーシングを有効化
  #   #   - "PassThrough": 上流のトレーシング決定に従う
  #   mode = "Active"
  # }

  #---------------------------------------------------------------
  # デッドレターキュー設定
  #---------------------------------------------------------------

  # dead_letter_config - (オプション) デッドレターキュー設定
  # 非同期呼び出しが失敗した場合の通知先を設定
  # dead_letter_config {
  #   # target_arn - (必須) 通知先のSNSトピックまたはSQSキューのARN
  #   target_arn = "arn:aws:sqs:us-east-1:123456789012:lambda-dlq"
  # }

  #---------------------------------------------------------------
  # コンテナイメージ設定
  #---------------------------------------------------------------

  # image_config - (オプション) コンテナイメージ設定値
  # package_type = "Image"の場合に使用
  # image_config {
  #   # command - (オプション) コンテナイメージに渡すパラメータ
  #   # Dockerfileのcmdをオーバーライド
  #   command = ["app.handler"]
  #
  #   # entry_point - (オプション) アプリケーションのエントリーポイント
  #   # Dockerfileのentrypointをオーバーライド
  #   entry_point = ["/lambda-entrypoint.sh"]
  #
  #   # working_directory - (オプション) コンテナイメージの作業ディレクトリ
  #   working_directory = "/app"
  # }

  #---------------------------------------------------------------
  # パフォーマンス最適化設定
  #---------------------------------------------------------------

  # snap_start - (オプション) SnapStart設定ブロック
  # コールドスタート時間を短縮（Java 11以降のランタイムで利用可能）
  # snap_start {
  #   # apply_on - (必須) SnapStart最適化を適用するタイミング
  #   # 有効な値: "PublishedVersions"
  #   apply_on = "PublishedVersions"
  # }

  # reserved_concurrent_executions - (オプション) この関数用に予約する同時実行数
  # 有効な値:
  #   - 0: 関数のトリガーを無効化
  #   - -1: 同時実行の制限を削除（デフォルト）
  #   - 正の整数: 指定した数の同時実行を予約
  # デフォルト: -1（無制限の同時実行制限）
  # reserved_concurrent_executions = -1

  #---------------------------------------------------------------
  # セキュリティ設定
  #---------------------------------------------------------------

  # kms_key_arn - (オプション) 環境変数の暗号化に使用するKMSキーのARN
  # 環境変数を使用している際に指定しない場合、Lambdaはデフォルトのサービスキーを使用
  # 環境変数を使用していない場合、この設定は保存されません
  # kms_key_arn = null

  # code_signing_config_arn - (オプション) コード署名設定のARN
  # この関数のコード署名を有効化する場合に指定
  # code_signing_config_arn = null

  # source_kms_key_arn - (オプション) 関数の.zipデプロイパッケージの暗号化に使用するKMSキーのARN
  # image_uriとは排他的です
  # source_kms_key_arn = null

  #---------------------------------------------------------------
  # Durable Functions設定（長時間実行ワークフロー）
  #---------------------------------------------------------------

  # durable_config - (オプション) Durable Function設定ブロック
  # 長時間実行のステートフルワークフローを構築する場合に使用
  # 注意: 限定されたリージョン（us-east-2等）でのみ利用可能
  # durable_config {
  #   # execution_timeout - (必須) Durable Functionの最大実行時間（秒単位）
  #   # 有効な値: 1秒から31,622,400秒（366日）
  #   execution_timeout = 3600
  #
  #   # retention_period - (オプション) 関数の実行状態を保持する日数
  #   # 有効な値: 1日から90日
  #   # 指定しない場合、実行状態は保持されません
  #   # デフォルト: 14
  #   retention_period = 14
  # }

  #---------------------------------------------------------------
  # Capacity Provider設定
  #---------------------------------------------------------------

  # capacity_provider_config - (オプション) Lambda Capacity Provider設定ブロック
  # capacity_provider_config {
  #   lambda_managed_instances_capacity_provider_config {
  #     # capacity_provider_arn - (必須) Capacity ProviderのARN
  #     capacity_provider_arn = "arn:aws:lambda:us-east-1:123456789012:capacity-provider/example"
  #
  #     # execution_environment_memory_gib_per_vcpu - (オプション) 実行環境のvCPUあたりのメモリGiB
  #     execution_environment_memory_gib_per_vcpu = 2
  #
  #     # per_execution_environment_max_concurrency - (オプション) 実行環境あたりの最大同時実行数
  #     per_execution_environment_max_concurrency = 10
  #   }
  # }

  #---------------------------------------------------------------
  # Tenancy設定
  #---------------------------------------------------------------

  # tenancy_config - (オプション) テナンシー設定ブロック
  # tenancy_config {
  #   # tenant_isolation_mode - (必須) テナント分離モード
  #   # 有効な値: "PER_TENANT"
  #   tenant_isolation_mode = "PER_TENANT"
  # }

  #---------------------------------------------------------------
  # リージョン設定
  #---------------------------------------------------------------

  # region - (オプション) このリソースが管理されるリージョン
  # 指定しない場合、プロバイダー設定のリージョンがデフォルトで使用されます
  # region = null

  #---------------------------------------------------------------
  # VPC削除前のセキュリティグループ置換設定
  #---------------------------------------------------------------

  # replace_security_groups_on_destroy - (オプション) 削除前にVPC設定のセキュリティグループを置換するか
  # デフォルト: false
  # これをtrueに設定する場合、replacement_security_group_idsの指定が必須
  # replace_security_groups_on_destroy = false

  # replacement_security_group_ids - (オプション) 削除前にVPC設定に割り当てるセキュリティグループIDのリスト
  # replace_security_groups_on_destroyがtrueの場合は必須
  # replacement_security_group_ids = null

  #---------------------------------------------------------------
  # その他の設定
  #---------------------------------------------------------------

  # description - (オプション) Lambda関数の説明
  description = "Example Lambda function created by Terraform"

  # skip_destroy - (オプション) 以前にデプロイされたLambda Layerの古いバージョンを保持するか
  # デフォルト: false
  # skip_destroy = false

  # tags - (オプション) Lambda関数のタグ（キー・バリューマップ）
  # プロバイダーのdefault_tags設定ブロックが存在する場合、
  # 一致するキーのタグはプロバイダーレベルで定義されたものを上書きします
  tags = {
    Environment = "production"
    ManagedBy   = "terraform"
  }

  # tags_all - (オプション/computed) すべてのタグのマップ
  # プロバイダーのdefault_tags設定から継承されたタグを含みます
  # 通常は明示的に設定せず、tagsとdefault_tagsから自動的に計算されます
  # tags_all = null

  # id - (オプション/computed) Lambda関数の識別子
  # 通常はTerraformによって自動的に計算されます
  # 明示的に設定することは推奨されません
  # id = null

  #---------------------------------------------------------------
  # Terraformリソース操作のタイムアウト設定
  #---------------------------------------------------------------

  # timeouts - (オプション) Terraformリソース操作のタイムアウト設定
  # timeouts {
  #   # create - (オプション) 作成操作のタイムアウト
  #   # VPC設定がある場合は最大45分かかる可能性があります
  #   create = "10m"
  #
  #   # update - (オプション) 更新操作のタイムアウト
  #   update = "10m"
  #
  #   # delete - (オプション) 削除操作のタイムアウト
  #   # VPC設定がある場合は最大45分かかる可能性があります
  #   delete = "45m"
  # }
}

#---------------------------------------------------------------
# Attributes Reference (computed only - 参照専用)
#---------------------------------------------------------------
# 以下の属性は、Lambdaサービスによって自動的に計算・設定される値です。
# Terraformでは直接設定できず、参照のみ可能です。
#
# arn
#   - Lambda関数を識別するARN
#   - 例: "arn:aws:lambda:us-east-1:123456789012:function:example-function"
#
# invoke_arn
#   - API GatewayからLambda関数を呼び出すために使用するARN
#   - aws_api_gateway_integrationのuriで使用
#   - 例: "arn:aws:apigateway:us-east-1:lambda:path/2015-03-31/functions/arn:aws:lambda:us-east-1:123456789012:function:example-function/invocations"
#
# qualified_arn
#   - Lambda関数のバージョン番号を含むARN（publish = trueの場合）
#   - 例: "arn:aws:lambda:us-east-1:123456789012:function:example-function:1"
#
# qualified_invoke_arn
#   - バージョン番号付きのAPI Gateway呼び出し用ARN
#   - aws_api_gateway_integrationのuriで使用
#
# response_streaming_invoke_arn
#   - レスポンスストリーミングを使用してAPI GatewayからLambda関数を呼び出すためのARN
#   - aws_api_gateway_integrationのuriで使用
#
# last_modified
#   - このリソースが最後に変更された日時
#   - ISO 8601形式のタイムスタンプ
#
# version
#   - Lambda関数の最新公開バージョン
#   - publish = trueの場合に更新されます
#
# source_code_size
#   - 関数の.zipファイルのサイズ（バイト単位）
#
# signing_job_arn
#   - 署名ジョブのARN
#   - コード署名が有効な場合に設定
#
# signing_profile_version_arn
#   - 署名プロファイルバージョンのARN
#   - コード署名が有効な場合に設定
#
# snap_start.optimization_status
#   - SnapStart設定の最適化ステータス
#   - 有効な値: "On" または "Off"
#
# vpc_config.vpc_id
#   - VPCのID
#   - vpc_configブロックが設定されている場合に自動的に取得
#
# tags_all
#   - リソースに割り当てられたタグのマップ
#   - プロバイダーのdefault_tags設定ブロックから継承されたタグを含む
#
#---------------------------------------------------------------
# 使用例 - Attributes Referenceの参照方法
#---------------------------------------------------------------
# output "lambda_arn" {
#   description = "Lambda関数のARN"
#   value       = aws_lambda_function.example.arn
# }
#
# output "lambda_invoke_arn" {
#   description = "API Gateway統合用のLambda呼び出しARN"
#   value       = aws_lambda_function.example.invoke_arn
# }
#
# output "lambda_version" {
#   description = "Lambda関数の最新バージョン"
#   value       = aws_lambda_function.example.version
# }
#---------------------------------------------------------------
