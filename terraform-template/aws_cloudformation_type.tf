#---------------------------------------------------------------
# AWS CloudFormation Type
#---------------------------------------------------------------
#
# CloudFormation Typeのバージョンを管理するリソースです。
# カスタムリソースタイプやモジュールをCloudFormationレジストリに登録し、
# CloudFormationテンプレートで使用できるようにします。
#
# AWS公式ドキュメント:
#   - CloudFormationレジストリ: https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/registry.html
#   - レジストリの概念: https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/registry-concepts.html
#   - RegisterType API: https://docs.aws.amazon.com/AWSCloudFormation/latest/APIReference/API_RegisterType.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudformation_type
#
# Provider Version: 6.28.0
# Generated: 2026-01-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_cloudformation_type" "example" {
  #-------------------------------------------------------------
  # 必須設定
  #-------------------------------------------------------------

  # schema_handler_package (Required)
  # 設定内容: 登録するエクステンションのプロジェクトパッケージを含むS3バケットのURLを指定します。
  # 設定可能な値: s3://またはhttps://で始まるURL
  #   - 例: s3://example-bucket/example-object
  # 関連機能: CloudFormation Type Registration
  #   エクステンションの登録に必要なファイルを含むパッケージ。
  #   ハンドラーコード、スキーマ、その他の必要なファイルを含みます。
  #   - https://docs.aws.amazon.com/cloudformation-cli/latest/userguide/resource-types.html
  schema_handler_package = "s3://my-bucket/my-extension-package.zip"

  # type_name (Required)
  # 設定内容: CloudFormation Typeの名前を指定します。
  # 設定可能な値: 命名規則に従った文字列
  #   - リソースタイプ: Company::Service::Resource 形式
  #   - 例: ExampleCompany::ExampleService::ExampleResource
  # 関連機能: CloudFormation Type Naming
  #   タイプ名は組織、サービス、リソースを識別する3つの部分で構成されます。
  #   - https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/registry-concepts.html
  type_name = "ExampleCompany::ExampleService::ExampleResource"

  #-------------------------------------------------------------
  # タイプ設定
  #-------------------------------------------------------------

  # type (Optional)
  # 設定内容: CloudFormation レジストリのタイプを指定します。
  # 設定可能な値:
  #   - "RESOURCE": リソースタイプ。AWS or サードパーティリソースをモデル化
  #   - "MODULE": モジュール。再利用可能なリソース設定をパッケージ化
  # 省略時: 指定なしの場合、スキーマから推測されます
  # 関連機能: CloudFormation Extension Types
  #   リソースタイプはCRUDL操作をサポートし、モジュールは複数リソースの
  #   設定をカプセル化します。
  #   - https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/registry-concepts.html
  type = "RESOURCE"

  #-------------------------------------------------------------
  # IAMロール設定
  #-------------------------------------------------------------

  # execution_role_arn (Optional)
  # 設定内容: エクステンション呼び出し時にCloudFormationが引き受けるIAMロールのARNを指定します。
  # 設定可能な値: 有効なIAMロールARN
  # 省略時: なし（エクステンションがAWS APIを呼び出さない場合は不要）
  # 関連機能: CloudFormation Execution Role
  #   エクステンションハンドラーがAWS APIを呼び出す場合、必要な権限を持つ
  #   実行ロールを作成し、アカウントにプロビジョニングする必要があります。
  #   CloudFormationはこのロールを引き受けて一時的なセッショントークンを作成し、
  #   エクステンションハンドラーに渡します。
  #   - https://docs.aws.amazon.com/AWSCloudFormation/latest/APIReference/API_RegisterType.html
  execution_role_arn = "arn:aws:iam::123456789012:role/cloudformation-type-execution-role"

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
  # ロギング設定
  #-------------------------------------------------------------

  # logging_config (Optional)
  # 設定内容: ロギング設定を指定するブロック。
  # 関連機能: CloudFormation Type Logging
  #   エクステンションハンドラー呼び出し時のエラーログ情報を
  #   CloudWatch Logsに送信するための設定です。
  logging_config {
    # log_group_name (Required)
    # 設定内容: CloudFormationがエラーログ情報を送信するCloudWatch Logsロググループの名前を指定します。
    # 設定可能な値: 有効なCloudWatch Logsロググループ名
    log_group_name = "/aws/cloudformation/type/ExampleCompany-ExampleService-ExampleResource"

    # log_role_arn (Required)
    # 設定内容: CloudWatch Logsにエラーログ情報を送信する際にCloudFormationが引き受けるIAMロールのARNを指定します。
    # 設定可能な値: 有効なIAMロールARN（CloudWatch Logsへの書き込み権限が必要）
    log_role_arn = "arn:aws:iam::123456789012:role/cloudformation-type-logging-role"
  }

  #-------------------------------------------------------------
  # ライフサイクル設定
  #-------------------------------------------------------------
  # NOTE: このリソースのdestroy操作はバージョンを非推奨としてマークします。
  #       これが唯一のLIVEバージョンだった場合、タイプ自体も非推奨になります。
  #       再デプロイを適切に順序付けるため、create_before_destroyの使用を推奨します。
  lifecycle {
    create_before_destroy = true
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: CloudFormation Typeバージョンの Amazon Resource Name (ARN)
#        type_arnも参照してください。
#
# - default_version_id: CloudFormation Typeのデフォルトバージョンの識別子
#
# - deprecated_status: バージョンの非推奨ステータス
#
# - description: バージョンの説明
#
# - documentation_url: CloudFormation Typeのドキュメントへの URL
#
# - is_default_version: このCloudFormation Typeバージョンがデフォルトバージョンかどうか
#
# - provisioning_type: CloudFormation Typeのプロビジョニング動作
#
# - schema: CloudFormation TypeスキーマのJSONドキュメント
#
# - source_url: CloudFormation Typeのソースコードへの URL
#
# - type_arn: CloudFormation Typeの Amazon Resource Name (ARN)
#---------------------------------------------------------------
