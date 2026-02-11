#---------------------------------------------------------------
# AWS Glue Development Endpoint
#---------------------------------------------------------------
#
# AWS Glueで開発とテスト用のETLスクリプト実行環境を提供するDevelopment Endpointをプロビジョニングします。
# Development Endpointは、Apache SparkとPythonを実行できる環境であり、JupyterノートブックやREPLシェル、
# PyCharmなどから接続してスクリプトを対話的に開発・デバッグできます。
#
# 注意: Development EndpointはAWS Glue 2.0より前のバージョンでのみサポートされています。
# 新しいバージョンではAWS Glue StudioのNotebooksなどのインタラクティブ環境が推奨されています。
#
# AWS公式ドキュメント:
#   - Development endpoints: https://docs.aws.amazon.com/glue/latest/dg/dev-endpoints.html
#   - DevEndpoint API Reference: https://docs.aws.amazon.com/glue/latest/webapi/API_DevEndpoint.html
#   - Adding a development endpoint: https://docs.aws.amazon.com/glue/latest/dg/add-dev-endpoint.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/glue_dev_endpoint
#
# Provider Version: 6.28.0
# Generated: 2026-01-27
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_glue_dev_endpoint" "example" {
  #---------------------------------------------------------------
  # 必須パラメータ
  #---------------------------------------------------------------

  # エンドポイント名
  # アカウント内で一意である必要があります
  # Type: string (required)
  name = "example-dev-endpoint"

  # このエンドポイントに関連付けるIAMロールのARN
  # AWS Glueがユーザーに代わってリソースにアクセスするために使用されます
  # AWSGlueServiceRoleなどの適切な権限を持つロールを指定する必要があります
  # Type: string (required)
  role_arn = "arn:aws:iam::123456789012:role/AWSGlueServiceRole"

  #---------------------------------------------------------------
  # オプション - 基本設定
  #---------------------------------------------------------------

  # Glueのバージョン
  # Apache SparkとPythonのバージョンを指定します
  # デフォルトはAWS Glue version 0.9です
  # 例: "0.9", "1.0", "2.0"
  # Type: string (optional)
  # glue_version = "1.0"

  # エンドポイントの設定に使用される引数のマップ
  # キーと値のペアで追加設定を指定できます
  # Pythonバージョンなどをここで指定できます（例: {"GLUE_PYTHON_VERSION": "3"}）
  # Type: map(string) (optional)
  # arguments = {
  #   "GLUE_PYTHON_VERSION" = "3"
  # }

  # AWS Glueデータ処理ユニット(DPU)の数
  # このエンドポイントに割り当てられるDPU数を指定します
  # worker_typeとは競合します（両方は指定できません）
  # Type: number (optional)
  # number_of_nodes = 5

  # ワーカーの数
  # G.1XまたはG.2Xワーカータイプを選択した場合のみ使用可能です
  # このエンドポイントに割り当てられる指定ワーカータイプの数を設定します
  # Type: number (optional)
  # number_of_workers = 3

  # 事前定義されたワーカータイプ
  # このエンドポイントに割り当てられるワーカータイプを指定します
  # 使用可能な値: "Standard", "G.1X", "G.2X"
  # number_of_nodesとは競合します（両方は指定できません）
  # Type: string (optional)
  # worker_type = "G.1X"

  #---------------------------------------------------------------
  # オプション - S3パス設定
  #---------------------------------------------------------------

  # 追加のJava JARファイルのS3パス
  # このエンドポイントでロードするJava Jarファイルへのパスを指定します
  # 複数のパスはカンマで区切ります
  # Type: string (optional)
  # extra_jars_s3_path = "s3://my-bucket/jars/"

  # 追加のPythonライブラリのS3パス
  # このエンドポイントでロードするPythonライブラリへのパスを指定します
  # 複数の値は完全なパスをカンマで区切って指定する必要があります
  # C拡張に依存するライブラリは使用できません
  # Type: string (optional)
  # extra_python_libs_s3_path = "s3://my-bucket/python-libs/"

  #---------------------------------------------------------------
  # オプション - ネットワーク設定
  #---------------------------------------------------------------

  # サブネットID
  # VPC内にエンドポイントを作成する場合のサブネットIDを指定します
  # Type: string (optional)
  # subnet_id = "subnet-12345678"

  # セキュリティグループID
  # このエンドポイントで使用するセキュリティグループのIDを指定します
  # VPC内のリソースへの安全なアクセスを設定します
  # Type: set(string) (optional)
  # security_group_ids = ["sg-12345678"]

  #---------------------------------------------------------------
  # オプション - 認証設定
  #---------------------------------------------------------------

  # 公開鍵
  # このエンドポイントの認証に使用される公開鍵を指定します
  # SSH接続に使用されます
  # Type: string (optional)
  # public_key = "ssh-rsa AAAAB3NzaC1yc2E..."

  # 公開鍵のリスト
  # このエンドポイントの認証に使用される公開鍵のリストを指定します
  # 複数のSSH公開鍵を登録できます
  # Type: set(string) (optional)
  # public_keys = [
  #   "ssh-rsa AAAAB3NzaC1yc2E...",
  #   "ssh-rsa AAAAB3NzaC1yc2E..."
  # ]

  #---------------------------------------------------------------
  # オプション - セキュリティ設定
  #---------------------------------------------------------------

  # セキュリティ設定名
  # このエンドポイントで使用するセキュリティ設定構造の名前を指定します
  # 暗号化設定などを含みます
  # Type: string (optional)
  # security_configuration = "example-security-config"

  #---------------------------------------------------------------
  # オプション - リージョン設定
  #---------------------------------------------------------------

  # リソースを管理するリージョン
  # 指定しない場合、プロバイダー設定のリージョンがデフォルトで使用されます
  # Type: string (optional, computed)
  # region = "us-east-1"

  #---------------------------------------------------------------
  # オプション - タグ
  #---------------------------------------------------------------

  # リソースタグ
  # キーと値のペアでリソースにタグを付けます
  # プロバイダーレベルでdefault_tagsが設定されている場合、
  # 一致するキーのタグはここで指定した値で上書きされます
  # Type: map(string) (optional)
  # tags = {
  #   Environment = "development"
  #   Project     = "data-pipeline"
  # }

  # 全タグ（プロバイダーのdefault_tagsを含む）
  # プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
  # リソースに割り当てられたすべてのタグのマップ
  # 通常は明示的に設定する必要はなく、Terraformが自動的に管理します
  # Type: map(string) (optional, computed)
  # tags_all = {
  #   Environment = "development"
  #   Project     = "data-pipeline"
  # }

  #---------------------------------------------------------------
  # オプション - その他の設定
  #---------------------------------------------------------------

  # リソースID
  # Terraformが自動的に管理するリソースの一意な識別子
  # 通常は明示的に設定する必要はありません
  # Type: string (optional, computed)
  # id = "example-dev-endpoint"
}

#---------------------------------------------------------------
# Attributes Reference
#---------------------------------------------------------------
#
# 以下の属性がエクスポートされます（computed属性）:
#
# - arn
#   エンドポイントのARN
#   Type: string
#
# - availability_zone
#   このエンドポイントが配置されているAWSアベイラビリティーゾーン
#   Type: string
#
# - failure_reason
#   このエンドポイントの現在の障害理由
#   エンドポイントの作成や更新に失敗した場合にその理由が記録されます
#   Type: string
#
# - id
#   エンドポイントのID
#   Type: string
#
# - private_address
#   VPC内でエンドポイントにアクセスするためのプライベートIPアドレス
#   VPC内にエンドポイントを作成した場合のみ存在します
#   Type: string
#
# - public_address
#   このエンドポイントが使用するパブリックIPアドレス
#   非VPCエンドポイントを作成した場合のみ存在します
#   Type: string
#
# - region
#   リソースが管理されているリージョン
#   Type: string
#
# - status
#   このエンドポイントの現在のステータス
#   例: "PROVISIONING", "READY", "TERMINATING", "TERMINATED", "FAILED"
#   Type: string
#
# - tags_all
#   リソースに割り当てられたタグのマップ
#   プロバイダーのdefault_tags設定ブロックから継承されたタグも含みます
#   Type: map(string)
#
# - vpc_id
#   このエンドポイントで使用されているVPCのID
#   Type: string
#
# - yarn_endpoint_address
#   リモートApache Sparkインタープリタが使用するYARNエンドポイントアドレス
#   Type: string
#
# - zeppelin_remote_spark_interpreter_port
#   リモートApache SparkインタープリタのApache Zeppelinポート
#   Type: number
#
#---------------------------------------------------------------
