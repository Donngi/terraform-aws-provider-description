#---------------------------------------------------------------
# EC2 Image Builder Distribution Configuration
#---------------------------------------------------------------
#
# EC2 Image Builder Distribution Configurationは、イメージビルダーで作成した
# AMIやコンテナイメージをどのように配布するかを定義するリソースです。
# 配布先のリージョン、アカウント、起動テンプレート、S3エクスポート設定、
# SSMパラメータへの保存など、イメージの配布戦略を一元管理できます。
#
# AWS公式ドキュメント:
#   - Manage Image Builder distribution settings: https://docs.aws.amazon.com/imagebuilder/latest/userguide/manage-distribution-settings.html
#   - Set up cross-account AMI distribution: https://docs.aws.amazon.com/imagebuilder/latest/userguide/cross-account-dist.html
#   - Configure AMI distribution with launch template: https://docs.aws.amazon.com/imagebuilder/latest/userguide/dist-using-launch-template.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/imagebuilder_distribution_configuration
#
# Provider Version: 6.28.0
# Generated: 2026-01-27
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_imagebuilder_distribution_configuration" "example" {
  #---------------------------------------------------------------
  # Required Arguments
  #---------------------------------------------------------------

  # (Required) 配布設定の名前
  # 命名規則に従った一意の識別子を指定します
  name = "example-distribution-config"

  # (Required) 配布設定のブロック（最低1つ必須）
  # イメージを配布するリージョンや配布方法を定義します
  distribution {
    # (Required) 配布先のAWSリージョン
    # この設定で定義された内容が適用される対象リージョンを指定します
    region = "us-east-1"

    #-----------------------------------------------------------
    # Optional Arguments (distribution block)
    #-----------------------------------------------------------

    # (Optional) License Manager License ConfigurationのARNセット
    # ライセンス管理が必要なソフトウェアを含むAMIの場合に指定します
    # license_configuration_arns = [
    #   "arn:aws:license-manager:us-east-1:123456789012:license-configuration:lic-1234567890abcdef0"
    # ]

    #-----------------------------------------------------------
    # Optional: AMI Distribution Configuration
    #-----------------------------------------------------------
    # AMI配布時の詳細設定（名前、タグ、暗号化、起動許可など）

    ami_distribution_configuration {
      # (Optional) 配布されるAMIに付与するタグ
      # コスト管理やリソース識別に使用します
      ami_tags = {
        Environment = "production"
        CostCenter  = "IT"
      }

      # (Optional) 配布されるAMIの説明
      # AMIカタログで表示される説明文です
      description = "Production web server image"

      # (Optional) AMI暗号化に使用するKMS Key ARN
      # 未指定の場合はデフォルトのEBS暗号化キーが使用されます
      kms_key_id = "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"

      # (Optional) 配布されるAMIの名前
      # {{ imagebuilder:buildDate }} などの変数が使用可能です
      name = "example-ami-{{ imagebuilder:buildDate }}"

      # (Optional) AMIを配布する対象のAWSアカウントIDセット
      # 指定したアカウントにAMIのコピーが作成され、所有権が移転します
      target_account_ids = [
        "123456789012",
        "210987654321"
      ]

      # (Optional) EC2起動許可の設定
      # AMIを起動できるアカウント、組織、OUを制御します
      launch_permission {
        # (Optional) 起動許可を付与するAWS OrganizationのARNセット
        organization_arns = [
          "arn:aws:organizations::123456789012:organization/o-abcd1234"
        ]

        # (Optional) 起動許可を付与するOrganizational UnitのARNセット
        organizational_unit_arns = [
          "arn:aws:organizations::123456789012:ou/o-abcd1234/ou-xyz1-12345678"
        ]

        # (Optional) 起動許可を付与するEC2ユーザーグループ
        # "all"を指定するとパブリックAMIになります
        # user_groups = ["all"]

        # (Optional) 起動許可を付与するAWSアカウントIDセット
        user_ids = [
          "123456789012"
        ]
      }
    }

    #-----------------------------------------------------------
    # Optional: Container Distribution Configuration
    #-----------------------------------------------------------
    # コンテナイメージ配布時の設定（ECRリポジトリへのプッシュ）

    # container_distribution_configuration {
    #   # (Optional) コンテナイメージに付与するタグセット
    #   container_tags = [
    #     "latest",
    #     "v1.0.0"
    #   ]
    #
    #   # (Optional) コンテナ配布設定の説明
    #   description = "Production container image"
    #
    #   # (Required) コンテナイメージの配布先リポジトリ
    #   target_repository {
    #     # (Required) 出力コンテナイメージを保存するリポジトリ名
    #     # この名前にリポジトリのロケーションがプレフィックスとして付与されます
    #     repository_name = "example-repository"
    #
    #     # (Required) イメージを登録するサービス
    #     # 有効な値: "ECR"
    #     service = "ECR"
    #   }
    # }

    #-----------------------------------------------------------
    # Optional: Fast Launch Configuration
    #-----------------------------------------------------------
    # Windows AMI用の高速起動設定（最大1000個まで指定可能）

    # fast_launch_configuration {
    #   # (Required) 高速起動を有効にするWindows AMIの所有者アカウントID
    #   account_id = "123456789012"
    #
    #   # (Required) Windows高速起動の有効/無効
    #   # trueで有効化、falseで無効化します
    #   enabled = true
    #
    #   # (Optional) リソース作成のために起動される並列インスタンスの最大数
    #   max_parallel_launches = 10
    #
    #   # (Optional) 高速起動が有効なWindows AMIがWindowsインスタンスを起動する際に
    #   # 使用する起動テンプレートの設定
    #   launch_template {
    #     # (Optional) Windows AMI高速起動用の起動テンプレートID
    #     # launch_template_idかlaunch_template_nameのいずれかを指定します
    #     launch_template_id = "lt-0abcd1234efgh5678"
    #
    #     # (Optional) Windows AMI高速起動用の起動テンプレート名
    #     # launch_template_name = "example-launch-template"
    #
    #     # (Optional) 使用する起動テンプレートのバージョン
    #     launch_template_version = "$Latest"
    #   }
    #
    #   # (Optional) Windows AMI用の事前プロビジョニングされたインスタンスから
    #   # 作成されるスナップショット数の管理設定
    #   snapshot_configuration {
    #     # (Optional) 高速起動が有効なWindows AMI用に保持する
    #     # 事前プロビジョニング済みスナップショットの数
    #     target_resource_count = 5
    #   }
    # }

    #-----------------------------------------------------------
    # Optional: Launch Template Configuration
    #-----------------------------------------------------------
    # AMI配布時に起動テンプレートを更新する設定（最大100個まで）

    launch_template_configuration {
      # (Required) 使用するAmazon EC2起動テンプレートのID
      launch_template_id = "lt-0aaa1bcde2ff3456"

      # (Optional) この設定が適用されるアカウントID
      # 未指定の場合は現在のアカウントが使用されます
      account_id = "123456789012"

      # (Optional) 指定したAmazon EC2起動テンプレートをデフォルトの
      # 起動テンプレートとして設定するかどうか
      # デフォルトはtrue
      default = true
    }

    #-----------------------------------------------------------
    # Optional: S3 Export Configuration
    #-----------------------------------------------------------
    # VM イメージディスクをS3にエクスポートする設定

    # s3_export_configuration {
    #   # (Required) エクスポートされるイメージのディスクイメージフォーマット
    #   # 有効な値: "RAW", "VHD", "VMDK"
    #   disk_image_format = "VMDK"
    #
    #   # (Required) エクスポートに使用するIAMロールの名前
    #   role_name = "imagebuilder-s3-export-role"
    #
    #   # (Required) エクスポートされたイメージを保存するS3バケット名
    #   # バケットはエクスポート設定を作成する前に存在している必要があります
    #   s3_bucket = "example-image-export-bucket"
    #
    #   # (Optional) エクスポートされるイメージのプレフィックス
    #   s3_prefix = "exports/"
    # }

    #-----------------------------------------------------------
    # Optional: SSM Parameter Configuration
    #-----------------------------------------------------------
    # AMI IDをSSM Parameterに保存する設定

    # ssm_parameter_configuration {
    #   # (Required) 配布後にAMI IDを保存するSSMパラメータ名
    #   parameter_name = "/imagebuilder/latest-ami-id"
    #
    #   # (Optional) 対象リージョンでこのパラメータを所有するAWSアカウントID
    #   # このアカウントは配布設定でターゲットアカウントとして指定する必要があります
    #   ami_account_id = "123456789012"
    #
    #   # (Optional) SSMパラメータのデータタイプ
    #   # 有効な値: "text", "aws:ec2:image"
    #   # AWSは "aws:ec2:image" の使用を推奨しています
    #   data_type = "aws:ec2:image"
    # }
  }

  #---------------------------------------------------------------
  # Optional Arguments
  #---------------------------------------------------------------

  # (Optional) 配布設定の説明
  # 配布設定の目的や用途を記載します
  description = "Distribution configuration for production images"

  # (Optional) このリソースが管理されるリージョン
  # 未指定の場合はプロバイダー設定のリージョンが使用されます
  # region = "us-east-1"

  # (Optional) 配布設定リソースに付与するタグ
  # provider default_tagsと組み合わせて使用できます
  tags = {
    Name        = "example-distribution-config"
    Environment = "production"
    ManagedBy   = "terraform"
  }
}

#---------------------------------------------------------------
# Attributes Reference
#---------------------------------------------------------------
# 以下の属性はリソース作成後に参照可能です（computed only）

# output "distribution_configuration_arn" {
#   description = "配布設定のAmazon Resource Name (ARN)"
#   value       = aws_imagebuilder_distribution_configuration.example.arn
# }
#
# output "distribution_configuration_date_created" {
#   description = "配布設定が作成された日時"
#   value       = aws_imagebuilder_distribution_configuration.example.date_created
# }
#
# output "distribution_configuration_date_updated" {
#   description = "配布設定が更新された日時"
#   value       = aws_imagebuilder_distribution_configuration.example.date_updated
# }
#
# output "distribution_configuration_tags_all" {
#   description = "provider default_tagsを含む全てのタグのマップ"
#   value       = aws_imagebuilder_distribution_configuration.example.tags_all
# }
