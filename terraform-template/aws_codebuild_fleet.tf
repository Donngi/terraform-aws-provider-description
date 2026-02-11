# ====================================================================
# AWS CodeBuild Fleet - Annotated Terraform Template
# ====================================================================
# 生成日: 2026-01-19
# Provider: hashicorp/aws
# Version: 6.28.0
#
# このテンプレートは生成時点の情報に基づいています。
# 最新の仕様については公式ドキュメントをご確認ください。
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codebuild_fleet
# ====================================================================

# AWS CodeBuild Fleet リソース
# CodeBuild のビルド環境用に専用インスタンスを提供するリザーブドキャパシティフリートを定義します。
# オンデマンドフリートと異なり、インスタンスは常時起動しておりビルド開始時の遅延を削減できます。
#
# 参考: https://docs.aws.amazon.com/codebuild/latest/userguide/fleets.html
resource "aws_codebuild_fleet" "example" {
  # ========================================
  # 必須パラメータ
  # ========================================

  # フリート名
  # CodeBuild フリートを識別するための名前を指定します。
  name = "example-codebuild-fleet"

  # ベースキャパシティ
  # フリートに割り当てる最小インスタンス数を指定します。
  # インスタンスは常時起動しており、ビルドリクエストに即座に対応できます。
  # コストはキャパシティに応じて発生するため、適切な値を設定してください。
  base_capacity = 2

  # コンピュートタイプ
  # フリートが使用するコンピュートリソースのタイプを指定します。
  # 有効な値:
  #   - ATTRIBUTE_BASED_COMPUTE: 属性ベースのコンピュート（vCPU、メモリ、ディスク指定）
  #   - CUSTOM_INSTANCE_TYPE: カスタムEC2インスタンスタイプ
  #   - BUILD_GENERAL1_SMALL: 3 GB メモリ、2 vCPUs
  #   - BUILD_GENERAL1_MEDIUM: 7 GB メモリ、4 vCPUs
  #   - BUILD_GENERAL1_LARGE: 15 GB メモリ、8 vCPUs
  #   - BUILD_GENERAL1_XLARGE: 70 GB メモリ、36 vCPUs
  #   - BUILD_GENERAL1_2XLARGE: 145 GB メモリ、72 vCPUs
  #   - BUILD_LAMBDA_1GB, BUILD_LAMBDA_2GB, BUILD_LAMBDA_4GB, BUILD_LAMBDA_8GB, BUILD_LAMBDA_10GB
  #
  # 参考: https://docs.aws.amazon.com/codebuild/latest/userguide/build-env-ref-compute-types.html
  compute_type = "BUILD_GENERAL1_SMALL"

  # 環境タイプ
  # コンピュートフリートの環境タイプを指定します。
  # 有効な値:
  #   - LINUX_CONTAINER: Linux コンテナ
  #   - LINUX_GPU_CONTAINER: GPU 対応 Linux コンテナ
  #   - ARM_CONTAINER: ARM アーキテクチャ Linux コンテナ
  #   - WINDOWS_CONTAINER: Windows コンテナ
  #   - WINDOWS_SERVER_2019_CONTAINER: Windows Server 2019 コンテナ
  #   - WINDOWS_SERVER_2022_CONTAINER: Windows Server 2022 コンテナ
  #   - LINUX_EC2: Linux EC2
  #   - ARM_EC2: ARM EC2
  #   - WINDOWS_EC2: Windows EC2
  #   - MAC_ARM: macOS ARM
  #
  # 参考: https://docs.aws.amazon.com/codebuild/latest/userguide/build-env-ref-compute-types.html
  environment_type = "LINUX_CONTAINER"

  # ========================================
  # オプションパラメータ
  # ========================================

  # フリートサービスロール
  # コンピュートフリートに関連付けるサービスロールのARNを指定します。
  # このロールはフリートがAWSリソースにアクセスするために必要な権限を提供します。
  # カスタムAMIを使用する場合は必須です。
  fleet_service_role = "arn:aws:iam::123456789012:role/CodeBuildFleetServiceRole"

  # イメージID
  # コンピュートフリートで使用するAmazon Machine Image (AMI) のIDを指定します。
  # カスタムAMIを使用する場合に指定します。
  # 指定しない場合は、CodeBuildが提供するデフォルトイメージが使用されます。
  image_id = "ami-0123456789abcdef0"

  # オーバーフロー動作
  # フリートのキャパシティが不足した場合の動作を指定します。
  # 有効な値:
  #   - ON_DEMAND: オンデマンドコンピュートリソースを使用（即座にビルド開始）
  #   - QUEUE: ビルドをキューに入れて待機（キャパシティが空くまで待つ）
  #
  # QUEUE を指定する場合は、scaling_configuration ブロックも設定可能です。
  overflow_behavior = "QUEUE"

  # リージョン
  # このリソースが管理されるAWSリージョンを指定します。
  # 指定しない場合は、プロバイダー設定のリージョンがデフォルトで使用されます。
  #
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = "us-east-1"

  # タグ
  # リソースに割り当てるタグのマップを指定します。
  # プロバイダーの default_tags 設定ブロックと組み合わせて使用できます。
  #
  # 参考: https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  tags = {
    Environment = "production"
    Team        = "platform"
    ManagedBy   = "terraform"
  }

  # tags_all
  # デフォルトタグとリソースタグを統合したすべてのタグのマップです。
  # 通常は Terraform によって自動的に管理されるため、明示的な指定は不要です。
  # プロバイダーの default_tags と tags を統合した結果がここに反映されます。
  # tags_all = {}

  # ========================================
  # ネストブロック: compute_configuration
  # ========================================
  # コンピュート設定（オプション）
  # compute_type が ATTRIBUTE_BASED_COMPUTE または CUSTOM_INSTANCE_TYPE の場合のみ指定します。
  # フリートのコンピュートリソースの詳細設定を行います。
  #
  # 参考: https://docs.aws.amazon.com/codebuild/latest/APIReference/API_ComputeConfiguration.html
  compute_configuration {
    # ディスク容量
    # インスタンスタイプに含まれるディスク容量（GB）を指定します。
    # compute_type が ATTRIBUTE_BASED_COMPUTE の場合に使用可能です。
    disk = 50

    # インスタンスタイプ
    # フリートで起動するEC2インスタンスタイプを指定します。
    # compute_type が CUSTOM_INSTANCE_TYPE の場合のみ指定します。
    # 有効な値: t2.micro, t3.small, m5.large など
    #
    # 参考: https://docs.aws.amazon.com/codebuild/latest/userguide/build-env-ref-compute-types.html#environment-reserved-capacity.instance-types
    instance_type = "t3.medium"

    # マシンタイプ
    # インスタンスタイプのマシンタイプを指定します。
    # compute_type が ATTRIBUTE_BASED_COMPUTE の場合のみ指定します。
    # 有効な値:
    #   - GENERAL: 汎用マシンタイプ
    #   - NVME: NVMe SSD を持つマシンタイプ
    machine_type = "GENERAL"

    # メモリ容量
    # インスタンスタイプのメモリ容量（GB）を指定します。
    # compute_type が ATTRIBUTE_BASED_COMPUTE の場合のみ指定します。
    memory = 8

    # vCPU数
    # インスタンスタイプの仮想CPU数を指定します。
    # compute_type が ATTRIBUTE_BASED_COMPUTE の場合のみ指定します。
    vcpu = 4
  }

  # ========================================
  # ネストブロック: scaling_configuration
  # ========================================
  # スケーリング設定（オプション）
  # overflow_behavior が QUEUE の場合のみ有効です。
  # オートスケーリング動作を定義し、負荷に応じて自動的にキャパシティを調整します。
  #
  # 参考: https://docs.aws.amazon.com/codebuild/latest/APIReference/API_ScalingConfigurationInput.html
  scaling_configuration {
    # 最大キャパシティ
    # オートスケーリング時のフリート内の最大インスタンス数を指定します。
    # base_capacity を超えてスケールアウトできる上限値です。
    max_capacity = 5

    # スケーリングタイプ
    # コンピュートフリートのスケーリングタイプを指定します。
    # 有効な値: TARGET_TRACKING_SCALING（ターゲット追跡スケーリング）
    scaling_type = "TARGET_TRACKING_SCALING"

    # ターゲット追跡スケーリング設定
    # スケーリングの詳細な動作を定義します。
    # メトリクスに基づいてターゲット値を維持するようスケールします。
    target_tracking_scaling_configs {
      # メトリクスタイプ
      # オートスケーリングを判断するメトリクスタイプを指定します。
      # 有効な値: FLEET_UTILIZATION_RATE（フリート使用率）
      metric_type = "FLEET_UTILIZATION_RATE"

      # ターゲット値
      # スケーリングを開始するメトリクスのターゲット値を指定します。
      # FLEET_UTILIZATION_RATE の場合、0.0〜1.0 の値（例: 0.75 = 75%使用率）
      target_value = 0.75
    }
  }

  # ========================================
  # ネストブロック: vpc_config
  # ========================================
  # VPC設定（オプション）
  # フリートをVPC内で実行する場合のネットワーク設定を行います。
  # プライベートサブネット内でビルドを実行したい場合などに使用します。
  vpc_config {
    # セキュリティグループID
    # VPC内のセキュリティグループIDのリストを指定します（必須）。
    # フリートのインスタンスに適用されるファイアウォールルールを定義します。
    security_group_ids = [
      "sg-0123456789abcdef0",
      "sg-0123456789abcdef1"
    ]

    # サブネット
    # VPC内のサブネットIDのリストを指定します（必須）。
    # フリートのインスタンスが起動されるサブネットを定義します。
    # 高可用性のため、複数のアベイラビリティゾーンのサブネットを指定することを推奨します。
    subnets = [
      "subnet-0123456789abcdef0",
      "subnet-0123456789abcdef1"
    ]

    # VPC ID
    # Amazon VPCのIDを指定します（必須）。
    # フリートが実行されるVPCを定義します。
    vpc_id = "vpc-0123456789abcdef0"
  }
}

# ====================================================================
# 出力例（参考）
# ====================================================================
# 以下の computed 属性は、リソース作成後に参照可能です。

# output "fleet_arn" {
#   description = "ARN of the CodeBuild Fleet"
#   value       = aws_codebuild_fleet.example.arn
# }
#
# output "fleet_id" {
#   description = "ID of the CodeBuild Fleet (same as ARN)"
#   value       = aws_codebuild_fleet.example.id
# }
#
# output "fleet_created" {
#   description = "Creation timestamp of the fleet"
#   value       = aws_codebuild_fleet.example.created
# }
#
# output "fleet_last_modified" {
#   description = "Last modification timestamp of the fleet"
#   value       = aws_codebuild_fleet.example.last_modified
# }
#
# output "fleet_status" {
#   description = "Current status of the fleet"
#   value       = aws_codebuild_fleet.example.status
# }
