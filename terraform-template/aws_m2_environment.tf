#---------------------------------------------------------------
# AWS Mainframe Modernization Environment
#---------------------------------------------------------------
#
# AWS Mainframe Modernization のマネージド・ランタイム環境を作成します。
# ランタイム環境は、AWS のコンピューティングリソース、ランタイムエンジン、
# およびユーザー指定の設定を組み合わせたもので、移行されたメインフレーム
# ワークロードを持つ1つ以上のアプリケーションをホストします。
#
# AWS公式ドキュメント:
#   - Managed runtime environments in AWS Mainframe Modernization: https://docs.aws.amazon.com/m2/latest/userguide/environments-m2.html
#   - Create an AWS Mainframe Modernization runtime environment: https://docs.aws.amazon.com/m2/latest/userguide/create-environments-m2.html
#   - Update an AWS Mainframe Modernization runtime environment: https://docs.aws.amazon.com/m2/latest/userguide/update-environments-m2.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/m2_environment
#
# Provider Version: 6.28.0
# Generated: 2026-01-31
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_m2_environment" "example" {
  #---------------------------------------------------------------
  # 必須パラメータ
  #---------------------------------------------------------------

  # 環境名
  # アカウント内で一意である必要があります。
  name = "example-m2-environment"

  # エンジンタイプ
  # 使用するランタイムエンジンを指定します。
  # 有効な値: "microfocus" (Rocket Software) または "bluage" (AWS Blu Age)
  # 選択するエンジンは、優先する近代化パターンによって異なります。
  engine_type = "bluage"

  # インスタンスタイプ
  # M2 環境で使用するインスタンスタイプを指定します。
  # 例: "M2.m5.large", "M2.m5.xlarge" など
  instance_type = "M2.m5.large"

  #---------------------------------------------------------------
  # オプションパラメータ
  #---------------------------------------------------------------

  # メンテナンスウィンドウ中の変更適用
  # true の場合、変更をメンテナンスウィンドウ中に適用します。
  # false の場合、変更は即座に適用されます。
  # デフォルトは false です。
  apply_changes_during_maintenance_window = false

  # 環境の説明
  # 環境の目的や用途を説明するテキストです。
  description = "Example M2 environment for mainframe workload modernization"

  # エンジンバージョン
  # 環境で使用する特定のエンジンバージョンを指定します。
  # 指定しない場合、利用可能な最新バージョンが使用されます。
  # engine_version = "1.0"

  # 強制更新
  # true の場合、アプリケーションが実行中でも環境を強制的に更新します。
  # 注意: アプリケーションの中断が発生する可能性があります。
  force_update = false

  # KMS キー ID
  # 環境の暗号化に使用する KMS キーの ARN を指定します。
  # 指定しない場合、デフォルトの暗号化が使用されます。
  # kms_key_id = "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"

  # 優先メンテナンスウィンドウ
  # メンテナンスウィンドウの時間帯を指定します。
  # フォーマット: "ddd:hh24:mi-ddd:hh24:mi" (例: "sun:23:00-mon:01:30")
  # 24時間未満である必要があります。
  # 指定しない場合、ランダムな値が使用されます。
  # preferred_maintenance_window = "sun:23:00-mon:01:30"

  # パブリックアクセス可能
  # true の場合、この環境にデプロイされたアプリケーションへの
  # パブリックアクセスを許可します。
  # デフォルトは false です。
  publicly_accessible = false

  # セキュリティグループ ID
  # 環境に関連付けるセキュリティグループの ID のリストです。
  # VPC 内のトラフィック制御に使用されます。
  security_group_ids = ["sg-01234567890abcdef"]

  # サブネット ID
  # 環境をデプロイするサブネットの ID のリストです。
  # 高可用性構成の場合、複数のアベイラビリティゾーンにまたがる
  # サブネットを指定することを推奨します。
  subnet_ids = ["subnet-01234567890abcdef", "subnet-01234567890abcdea"]

  # リージョン
  # このリソースが管理されるリージョンを指定します。
  # 指定しない場合、プロバイダー設定のリージョンがデフォルトで使用されます。
  # region = "us-east-1"

  # タグ
  # リソースに割り当てるキー・バリュー形式のタグです。
  # プロバイダーの default_tags 設定と併用可能です。
  tags = {
    Environment = "production"
    Project     = "mainframe-modernization"
    ManagedBy   = "terraform"
  }

  #---------------------------------------------------------------
  # ネストブロック: 高可用性設定
  #---------------------------------------------------------------

  # 高可用性構成
  # 複数のインスタンスで環境を実行し、可用性を向上させます。
  # desired_capacity で希望するインスタンス数を指定します。
  high_availability_config {
    # 希望インスタンス数
    # 環境で実行する希望インスタンス数を指定します。
    # 高可用性のために 2 以上を推奨します。
    desired_capacity = 2
  }

  #---------------------------------------------------------------
  # ネストブロック: ストレージ設定
  #---------------------------------------------------------------

  # ストレージ構成
  # 環境にマウントする外部ストレージを設定します。
  # EFS または FSx のいずれかを使用できます。
  storage_configuration {
    # EFS ファイルシステム
    # Amazon EFS ファイルシステムをマウントします。
    # efs {
    #   # ファイルシステム ID
    #   # マウントする EFS ファイルシステムの ID を指定します。
    #   file_system_id = "fs-01234567890abcdef"
    #
    #   # マウントポイント
    #   # ファイルシステムをマウントするパスを指定します。
    #   # /m2/mount/ で始まる必要があります。
    #   mount_point = "/m2/mount/efs-storage"
    # }

    # FSx ファイルシステム
    # Amazon FSx ファイルシステムをマウントします。
    # fsx {
    #   # ファイルシステム ID
    #   # マウントする FSx ファイルシステムの ID を指定します。
    #   file_system_id = "fs-01234567890abcdef"
    #
    #   # マウントポイント
    #   # ファイルシステムをマウントするパスを指定します。
    #   # /m2/mount/ で始まる必要があります。
    #   mount_point = "/m2/mount/fsx-storage"
    # }
  }

  #---------------------------------------------------------------
  # ネストブロック: タイムアウト設定
  #---------------------------------------------------------------

  # タイムアウト設定
  # 各操作のタイムアウト時間を指定します。
  # timeouts {
  #   # 作成タイムアウト
  #   # 環境の作成操作のタイムアウト時間を指定します。
  #   # 例: "30m", "1h", "2h45m"
  #   create = "60m"
  #
  #   # 更新タイムアウト
  #   # 環境の更新操作のタイムアウト時間を指定します。
  #   update = "60m"
  #
  #   # 削除タイムアウト
  #   # 環境の削除操作のタイムアウト時間を指定します。
  #   delete = "60m"
  # }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用)
#---------------------------------------------------------------
# 以下の属性は computed のみで、設定ファイルでは指定できません。
# これらは environment 作成後に参照可能です。
#
# - arn                 : 環境の ARN
# - id                  : 環境の ID
# - environment_id      : 環境の ID (id と同じ値)
# - load_balancer_arn   : 環境によって作成されたロードバランサーの ARN
# - tags_all            : プロバイダーの default_tags を含む全てのタグ
#
# 使用例:
# output "environment_arn" {
#   value = aws_m2_environment.example.arn
# }
#---------------------------------------------------------------
