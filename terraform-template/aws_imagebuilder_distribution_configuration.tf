#---------------------------------------------------------------
# EC2 Image Builder 配布設定
#---------------------------------------------------------------
#
# EC2 Image Builderの配布設定をプロビジョニングするリソースです。
# 配布設定は、作成したAMIやコンテナイメージを複数のリージョンや
# AWSアカウントに配布するための設定を定義します。
# AMI配布、コンテナイメージ配布、S3エクスポート、ライセンス設定、
# Fast Launch設定、起動テンプレート設定などを統合管理します。
#
# AWS公式ドキュメント:
#   - Image Builder 配布設定管理: https://docs.aws.amazon.com/imagebuilder/latest/userguide/manage-distribution-settings.html
#   - AMI 配布設定: https://docs.aws.amazon.com/imagebuilder/latest/userguide/ami-distribution-settings.html
#   - コンテナイメージ配布: https://docs.aws.amazon.com/imagebuilder/latest/userguide/container-distribution-settings.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/imagebuilder_distribution_configuration
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_imagebuilder_distribution_configuration" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: 配布設定の名前を指定します。
  # 設定可能な値: 英数字、ハイフン、アンダースコアを含む文字列
  # 注意: 配布設定名はAWSアカウント内で一意である必要があります。
  name = "example-distribution-configuration"

  # description (Optional)
  # 設定内容: 配布設定の説明を指定します。
  # 設定可能な値: 任意の文字列
  # 省略時: 説明なしで配布設定が作成されます。
  description = "Example distribution configuration for multi-region AMI distribution"

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用します。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # 配布先リージョン設定
  #-------------------------------------------------------------

  # distribution (Required, min_items: 1)
  # 設定内容: イメージを配布するリージョンと配布方法の設定を定義します。
  # 注意: 少なくとも1つのdistributionブロックが必要です。
  #       各リージョンに対して個別のdistributionブロックを定義します。
  # 関連機能: マルチリージョン配布
  #   Image Builderはビルド後に自動的に指定リージョンへイメージをコピーし、
  #   暗号化キーや共有設定など配布先ごとの設定を適用します。
  #   - https://docs.aws.amazon.com/imagebuilder/latest/userguide/ami-distribution-settings.html
  distribution {
    # region (Required)
    # 設定内容: イメージを配布するAWSリージョンを指定します。
    # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1, eu-west-1）
    # 注意: ビルドリージョンを含むすべての配布先リージョンを指定する必要があります。
    region = "ap-northeast-1"

    # license_configuration_arns (Optional)
    # 設定内容: このリージョンへの配布に関連付けるAWS License ManagerのライセンスARNセットを指定します。
    # 設定可能な値: ライセンス設定ARN文字列のセット
    # 省略時: ライセンス設定は関連付けられません。
    # 参考: https://docs.aws.amazon.com/license-manager/latest/userguide/license-configurations.html
    license_configuration_arns = []

    #-----------------------------------------------------------
    # AMI 配布設定
    #-----------------------------------------------------------

    # ami_distribution_configuration (Optional, max_items: 1)
    # 設定内容: AMIの配布に関する詳細設定を定義します。
    # 省略時: デフォルト設定でAMIが配布されます。
    # 注意: container_distribution_configurationとは排他的ではなく、
    #       AMIとコンテナの両方を配布する場合は両方指定できます。
    # 関連機能: AMI配布とアカウント共有
    #   作成したAMIを他のAWSアカウントやリージョンと共有し、
    #   暗号化キーや起動権限などの詳細設定を制御できます。
    ami_distribution_configuration {
      # name (Optional)
      # 設定内容: 配布されるAMIの名前パターンを指定します。
      # 設定可能な値: AMI名のパターン文字列（{{ imagebuilder:buildDate }}等の変数使用可）
      # 省略時: デフォルトのAMI名が使用されます。
      # 注意: 同じリージョン内でAMI名が重複しないよう、日付変数の使用を推奨します。
      name = "example-ami-{{ imagebuilder:buildDate }}"

      # description (Optional)
      # 設定内容: 配布されるAMIの説明を指定します。
      # 設定可能な値: 任意の文字列
      # 省略時: AMIに説明は設定されません。
      description = "Example AMI built by Image Builder"

      # kms_key_id (Optional)
      # 設定内容: AMIの暗号化に使用するKMSキーのARNまたはIDを指定します。
      # 設定可能な値: 有効なKMSキーARN、キーID、またはキーエイリアス
      # 省略時: AMIはデフォルトのEBS暗号化設定に従います（暗号化なしの場合もあります）。
      # 注意: クロスアカウント共有時は、共有先アカウントからもKMSキーへのアクセスが必要です。
      # 参考: https://docs.aws.amazon.com/kms/latest/developerguide/services-ebs.html
      kms_key_id = null

      # ami_tags (Optional)
      # 設定内容: 配布されるAMIに付与するタグのマップを指定します。
      # 設定可能な値: キーと値のペアのマップ
      # 省略時: AMIにタグは付与されません。
      # 注意: リソースレベルのtagsとは別に、AMI自体に付与するタグです。
      ami_tags = {
        Name      = "example-ami"
        BuildDate = "{{ imagebuilder:buildDate }}"
      }

      # target_account_ids (Optional)
      # 設定内容: このAMIを共有するAWSアカウントIDのセットを指定します。
      # 設定可能な値: 12桁のAWSアカウントIDのセット
      # 省略時: 他のアカウントへの共有は行われません。
      # 注意: 共有先アカウントへAMIをコピーする場合は、
      #       launch_permissionのuser_idsを代わりに使用します。
      target_account_ids = []

      # launch_permission (Optional, max_items: 1)
      # 設定内容: AMIの起動権限設定を定義します。
      # 省略時: AMI所有アカウントのみが起動権限を持ちます。
      # 関連機能: AMI起動権限の制御
      #   特定のAWSアカウント、組織、組織ユニットにAMIの起動権限を付与し、
      #   ゴールデンAMIを組織全体で共有できます。
      launch_permission {
        # user_ids (Optional)
        # 設定内容: AMIの起動権限を付与するAWSアカウントIDのセットを指定します。
        # 設定可能な値: 12桁のAWSアカウントIDのセット
        # 省略時: 特定アカウントへの起動権限付与は行われません。
        user_ids = ["123456789012"]

        # user_groups (Optional)
        # 設定内容: AMIの起動権限を付与するユーザーグループのセットを指定します。
        # 設定可能な値: "all"（全パブリックアクセス）など
        # 省略時: グループへの起動権限付与は行われません。
        # 注意: "all"を指定するとAMIがパブリックになります。本番環境では慎重に扱ってください。
        user_groups = []

        # organization_arns (Optional)
        # 設定内容: AMIの起動権限を付与するAWS Organizations組織のARNセットを指定します。
        # 設定可能な値: AWS Organizations組織ARN文字列のセット
        # 省略時: 組織への起動権限付与は行われません。
        organization_arns = []

        # organizational_unit_arns (Optional)
        # 設定内容: AMIの起動権限を付与するAWS Organizations組織ユニット（OU）のARNセットを指定します。
        # 設定可能な値: AWS Organizations組織ユニットARN文字列のセット
        # 省略時: 組織ユニットへの起動権限付与は行われません。
        organizational_unit_arns = []
      }
    }

    #-----------------------------------------------------------
    # コンテナ配布設定
    #-----------------------------------------------------------

    # container_distribution_configuration (Optional, max_items: 1)
    # 設定内容: コンテナイメージの配布に関する詳細設定を定義します。
    # 省略時: コンテナイメージの配布設定は行われません。
    # 注意: コンテナレシピを使用するパイプラインで配布先ECRリポジトリを指定する場合に使用します。
    # 関連機能: コンテナイメージのECR配布
    #   ビルドしたコンテナイメージを指定したECRリポジトリに自動的にプッシュし、
    #   複数のタグを付与することができます。
    # container_distribution_configuration {
    #   # description (Optional)
    #   # 設定内容: コンテナ配布設定の説明を指定します。
    #   # 設定可能な値: 任意の文字列
    #   # 省略時: 説明なしで配布設定が作成されます。
    #   description = "Container distribution to ECR"
    #
    #   # container_tags (Optional)
    #   # 設定内容: 配布するコンテナイメージに付与するタグのセットを指定します。
    #   # 設定可能な値: コンテナイメージタグ文字列のセット（例: "latest", "1.0.0"）
    #   # 省略時: タグなしでコンテナイメージが配布されます。
    #   container_tags = ["latest", "{{ imagebuilder:buildDate }}"]
    #
    #   # target_repository (Required, min_items: 1, max_items: 1)
    #   # 設定内容: コンテナイメージの配布先リポジトリを定義します。
    #   target_repository {
    #     # service (Required)
    #     # 設定内容: コンテナリポジトリのサービスを指定します。
    #     # 設定可能な値: "ECR"（Amazon Elastic Container Registry）
    #     service = "ECR"
    #
    #     # repository_name (Required)
    #     # 設定内容: 配布先ECRリポジトリの名前を指定します。
    #     # 設定可能な値: 有効なECRリポジトリ名
    #     # 注意: リポジトリは事前に作成されている必要があります。
    #     repository_name = "example-repository"
    #   }
    # }

    #-----------------------------------------------------------
    # Fast Launch 設定
    #-----------------------------------------------------------

    # fast_launch_configuration (Optional, max_items: 1000)
    # 設定内容: Windows AMIのFast Launch設定を定義します。
    # 省略時: Fast Launchは設定されません。
    # 関連機能: EC2 Windows AMI Fast Launch
    #   事前プロビジョニングされたスナップショットを使用して、
    #   Windowsインスタンスの起動時間を大幅に短縮します。
    #   - https://docs.aws.amazon.com/imagebuilder/latest/userguide/win-ami-config-fast-launch.html
    # fast_launch_configuration {
    #   # account_id (Required)
    #   # 設定内容: Fast Launch設定を適用するAWSアカウントIDを指定します。
    #   # 設定可能な値: 12桁のAWSアカウントID
    #   account_id = "123456789012"
    #
    #   # enabled (Required)
    #   # 設定内容: Fast Launchを有効にするかを指定します。
    #   # 設定可能な値:
    #   #   - true: Fast Launchを有効にします
    #   #   - false: Fast Launchを無効にします
    #   enabled = true
    #
    #   # max_parallel_launches (Optional)
    #   # 設定内容: Fast Launch設定の最大並列起動数を指定します。
    #   # 設定可能な値: 正の整数
    #   # 省略時: デフォルト値が使用されます。
    #   max_parallel_launches = 6
    #
    #   # launch_template (Optional, max_items: 1)
    #   # 設定内容: Fast Launch用の起動テンプレートを定義します。
    #   # 省略時: デフォルトの起動テンプレートが使用されます。
    #   launch_template {
    #     # launch_template_id (Optional)
    #     # 設定内容: 使用する起動テンプレートのIDを指定します。
    #     # 設定可能な値: 有効な起動テンプレートID（lt-xxxxxxxxxxxxxxxxx）
    #     # 省略時: launch_template_nameで指定します。
    #     launch_template_id = "lt-0123456789abcdef0"
    #
    #     # launch_template_name (Optional)
    #     # 設定内容: 使用する起動テンプレートの名前を指定します。
    #     # 設定可能な値: 有効な起動テンプレート名
    #     # 省略時: launch_template_idで指定します。
    #     launch_template_name = null
    #
    #     # launch_template_version (Optional)
    #     # 設定内容: 使用する起動テンプレートのバージョンを指定します。
    #     # 設定可能な値: バージョン番号文字列（例: "1", "2"）
    #     # 省略時: デフォルトバージョンが使用されます。
    #     launch_template_version = "1"
    #   }
    #
    #   # snapshot_configuration (Optional, max_items: 1)
    #   # 設定内容: Fast Launch用のスナップショット設定を定義します。
    #   # 省略時: デフォルトのスナップショット設定が使用されます。
    #   snapshot_configuration {
    #     # target_resource_count (Optional)
    #     # 設定内容: 事前プロビジョニングするスナップショット数を指定します。
    #     # 設定可能な値: 正の整数
    #     # 省略時: デフォルト値が使用されます。
    #     target_resource_count = 1
    #   }
    # }

    #-----------------------------------------------------------
    # 起動テンプレート設定
    #-----------------------------------------------------------

    # launch_template_configuration (Optional, max_items: 100)
    # 設定内容: 配布されたAMIに対して起動テンプレートを自動作成・更新する設定を定義します。
    # 省略時: 起動テンプレートは自動作成されません。
    # 関連機能: EC2起動テンプレート自動管理
    #   Image Builderが新しいAMIを作成するたびに、関連する起動テンプレートを
    #   自動的に最新AMI IDで更新します。
    #   - https://docs.aws.amazon.com/imagebuilder/latest/userguide/managing-image-builder-cli.html
    # launch_template_configuration {
    #   # launch_template_id (Required)
    #   # 設定内容: 更新する起動テンプレートのIDを指定します。
    #   # 設定可能な値: 有効な起動テンプレートID（lt-xxxxxxxxxxxxxxxxx）
    #   launch_template_id = "lt-0123456789abcdef0"
    #
    #   # account_id (Optional)
    #   # 設定内容: 起動テンプレートを所有するAWSアカウントIDを指定します。
    #   # 設定可能な値: 12桁のAWSアカウントID
    #   # 省略時: 配布設定を所有するアカウントが使用されます。
    #   account_id = "123456789012"
    #
    #   # default (Optional)
    #   # 設定内容: この起動テンプレートをデフォルトテンプレートとして設定するかを指定します。
    #   # 設定可能な値:
    #   #   - true: デフォルト起動テンプレートとして設定します
    #   #   - false: デフォルト設定を変更しません
    #   # 省略時: デフォルトテンプレートの設定は変更されません。
    #   default = true
    # }

    #-----------------------------------------------------------
    # S3 エクスポート設定
    #-----------------------------------------------------------

    # s3_export_configuration (Optional, max_items: 1)
    # 設定内容: AMIをS3バケットにエクスポートする設定を定義します。
    # 省略時: S3へのエクスポートは行われません。
    # 関連機能: AMIのVM Import/Export
    #   AMIをVHD、VMDK、RAWなどの形式でS3バケットにエクスポートし、
    #   オンプレミス環境やその他のクラウドで使用できます。
    #   - https://docs.aws.amazon.com/imagebuilder/latest/userguide/export-vm-images.html
    # s3_export_configuration {
    #   # disk_image_format (Required)
    #   # 設定内容: エクスポートするディスクイメージのフォーマットを指定します。
    #   # 設定可能な値:
    #   #   - "VHD": 仮想ハードディスク（Hyper-V互換）
    #   #   - "VMDK": 仮想マシンディスク（VMware互換）
    #   #   - "RAW": 生ディスクイメージ
    #   disk_image_format = "VHD"
    #
    #   # role_name (Required)
    #   # 設定内容: VMエクスポート操作に使用するIAMロール名を指定します。
    #   # 設定可能な値: 有効なIAMロール名
    #   # 注意: ロールにはS3バケットへの書き込み権限とEC2エクスポート権限が必要です。
    #   # 参考: https://docs.aws.amazon.com/vm-import/latest/userguide/required-permissions.html
    #   role_name = "vmimport"
    #
    #   # s3_bucket (Required)
    #   # 設定内容: エクスポートしたイメージを保存するS3バケット名を指定します。
    #   # 設定可能な値: 有効なS3バケット名
    #   # 注意: バケットはエクスポートを実行するリージョンと同じリージョンに存在する必要があります。
    #   s3_bucket = "example-export-bucket"
    #
    #   # s3_prefix (Optional)
    #   # 設定内容: エクスポートオブジェクトのS3プレフィックス（フォルダパス）を指定します。
    #   # 設定可能な値: 任意のS3オブジェクトプレフィックス文字列
    #   # 省略時: バケットのルートにエクスポートされます。
    #   s3_prefix = "exports/amis/"
    # }

    #-----------------------------------------------------------
    # SSM パラメータ設定
    #-----------------------------------------------------------

    # ssm_parameter_configuration (Optional)
    # 設定内容: AMIのIDをAWS Systems Manager Parameter Storeに自動的に保存する設定を定義します。
    # 省略時: SSMパラメータへの自動保存は行われません。
    # 関連機能: AMI IDのSSMパラメータ自動管理
    #   Image Builderが新しいAMIを作成するたびに、指定したSSMパラメータを
    #   最新のAMI IDで自動更新します。これにより、アプリケーションは
    #   常に最新のAMI IDを動的に参照できます。
    #   - https://docs.aws.amazon.com/imagebuilder/latest/userguide/image-builder-ssm.html
    # ssm_parameter_configuration {
    #   # parameter_name (Required)
    #   # 設定内容: AMI IDを保存するSSMパラメータの名前を指定します。
    #   # 設定可能な値: 有効なSSMパラメータ名（/ で始まるパス形式を推奨）
    #   # 注意: パラメータが存在しない場合は自動的に作成されます。
    #   parameter_name = "/imagebuilder/latest-ami-id"
    #
    #   # ami_account_id (Optional)
    #   # 設定内容: SSMパラメータを管理するAWSアカウントIDを指定します。
    #   # 設定可能な値: 12桁のAWSアカウントID
    #   # 省略時: 配布設定を所有するアカウントが使用されます。
    #   ami_account_id = "123456789012"
    #
    #   # data_type (Optional)
    #   # 設定内容: SSMパラメータのデータタイプを指定します。
    #   # 設定可能な値:
    #   #   - "aws:ec2:image": EC2 AMI ID（AMI IDの検証を有効化）
    #   #   - "text": テキスト文字列
    #   # 省略時: "text" として扱われます。
    #   # 注意: "aws:ec2:image"を使用すると、パラメータ値がAMI IDとして検証されます。
    #   data_type = "aws:ec2:image"
    # }
  }

  # distribution (2つ目のリージョンの例)
  # 複数リージョンへ配布する場合は、追加のdistributionブロックを定義します。
  # distribution {
  #   region = "us-east-1"
  #
  #   ami_distribution_configuration {
  #     name = "example-ami-{{ imagebuilder:buildDate }}"
  #     kms_key_id = "arn:aws:kms:us-east-1:123456789012:key/mrk-example"
  #   }
  # }

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  #   - https://docs.aws.amazon.com/general/latest/gr/aws_tagging.html
  tags = {
    Name        = "example-distribution-configuration"
    Environment = "development"
    ManagedBy   = "Terraform"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: 配布設定のAmazon Resource Name (ARN)
#
# - arn: 配布設定のAmazon Resource Name (ARN)
#
# - date_created: 配布設定が作成された日時（ISO 8601形式）
#
# - date_updated: 配布設定が最後に更新された日時（ISO 8601形式）
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
