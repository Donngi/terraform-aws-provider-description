#---------------------------------------------------------------
# SageMaker User Profile
#---------------------------------------------------------------
#
# Amazon SageMaker AIドメイン内の個々のユーザーを表すユーザープロファイルを作成します。
# 各ユーザープロファイルは、ユーザーがオンボードしたときに作成され、JupyterServer、
# JupyterLab、Code Editor、Studio Classicなどのアプリケーションを起動できます。
# ユーザープロファイルには専用のAmazon EFSディレクトリ、実行ロール、
# およびアプリケーション設定が関連付けられます。
#
# AWS公式ドキュメント:
#   - Domain user profiles: https://docs.aws.amazon.com/sagemaker/latest/dg/domain-user-profile.html
#   - Add user profiles: https://docs.aws.amazon.com/sagemaker/latest/dg/domain-user-profile-add.html
#   - API Reference: https://docs.aws.amazon.com/sagemaker/latest/APIReference/API_CreateUserProfile.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sagemaker_user_profile
#
# Provider Version: 6.28.0
# Generated: 2026-02-03
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_sagemaker_user_profile" "example" {
  #---------------------------------------------------------------
  # 必須パラメータ
  #---------------------------------------------------------------

  # ユーザープロファイルが関連付けられるSageMaker Domainのリソース識別子
  # 例: "d-xxxxxxxxxxxx"
  domain_id = "d-xxxxxxxxxxxx"

  # ユーザープロファイル名
  # ドメイン内で一意である必要があります
  # 例: "data-scientist-user"
  user_profile_name = "example-user"

  #---------------------------------------------------------------
  # オプションパラメータ
  #---------------------------------------------------------------

  # このリソースが管理されるAWSリージョン
  # 指定しない場合、プロバイダー設定のリージョンがデフォルトで使用されます
  # 例: "us-east-1"
  # region = null

  # AWS Single Sign-On (SSO) ユーザー識別子のタイプ
  # ドメインのAuthModeがSSOの場合は必須です
  # 現在サポートされている値: "UserName"
  # ドメインのAuthModeがSSOでない場合は指定できません
  # single_sign_on_user_identifier = null

  # AWS Single Sign-On (SSO) ユーザーのユーザー名
  # ドメインのAuthModeがSSOの場合は必須で、ディレクトリ内の
  # 有効なユーザー名と一致する必要があります
  # ドメインのAuthModeがSSOでない場合は指定できません
  # single_sign_on_user_value = null

  # リソースに割り当てるタグのマップ
  # プロバイダーのdefault_tagsと統合されます
  # tags = {
  #   Environment = "production"
  #   Team        = "data-science"
  # }

  #---------------------------------------------------------------
  # ユーザー設定ブロック
  #---------------------------------------------------------------
  # ユーザープロファイルのアプリケーション設定、実行ロール、
  # セキュリティグループなどを定義します
  user_settings {
    # 必須: ユーザーの実行ロールARN
    # このロールはSageMakerがユーザーに代わってAWSリソースにアクセスする際に使用されます
    execution_role = "arn:aws:iam::123456789012:role/SageMakerExecutionRole"

    #---------------------------------------------------------------
    # オプション属性
    #---------------------------------------------------------------

    # EFSボリュームの自動マウントサポート
    # 有効な値: "Enabled", "Disabled", "DefaultAsDomain"
    # "DefaultAsDomain"はユーザープロファイルでのみサポートされます
    # auto_mount_home_efs = null

    # ユーザーがドメインにアクセスする際のデフォルトエクスペリエンス
    # 有効な値:
    #   - "studio::": Studio (StudioWebPortalがENABLEDの場合のみ)
    #   - "app:JupyterServer:": Studio Classic
    # default_landing_uri = null

    # ユーザーに関連付けられるセキュリティグループIDのリスト
    # 例: ["sg-12345678", "sg-87654321"]
    # security_groups = null

    # ユーザーがStudioにアクセスできるかどうか
    # 有効な値: "ENABLED", "DISABLED"
    # "DISABLED"の場合、ドメインのデフォルトがStudioでもアクセスできません
    # studio_web_portal = null

    #---------------------------------------------------------------
    # Canvas App Settings
    #---------------------------------------------------------------
    # SageMaker Canvasアプリケーションの設定
    # canvas_app_settings {
    #   # モデルデプロイメント設定
    #   direct_deploy_settings {
    #     # モデルデプロイメント権限の有効/無効
    #     # 有効な値: "ENABLED", "DISABLED"
    #     status = null
    #   }
    #
    #   # EMR Serverlessジョブ設定
    #   emr_serverless_settings {
    #     # EMR ServerlessジョブをCanvas内で実行するためのIAMロールARN
    #     # このロールはデータの読み書き権限とEMR Serverlessとの信頼関係が必要
    #     execution_role_arn = null
    #
    #     # EMR Serverlessジョブ機能の有効/無効
    #     # 有効な値: "ENABLED", "DISABLED"
    #     status = null
    #   }
    #
    #   # 生成AI設定
    #   generative_ai_settings {
    #     # Amazon BedrockにアクセスするためのロールARN
    #     amazon_bedrock_role_arn = null
    #   }
    #
    #   # OAuth設定（外部データソース接続用）
    #   # 最大20個まで設定可能
    #   identity_provider_oauth_settings {
    #     # 必須: Secrets ManagerシークレットのARN
    #     # クライアントID、シークレット、認証URL、トークンURLを保存
    #     secret_arn = "arn:aws:secretsmanager:region:account-id:secret:secret-name"
    #
    #     # データソース名
    #     # 有効な値: "SalesforceGenie", "Snowflake"
    #     data_source_name = null
    #
    #     # OAuthの有効/無効
    #     # 有効な値: "ENABLED", "DISABLED"
    #     status = null
    #   }
    #
    #   # Kendraドキュメントクエリ設定
    #   kendra_settings {
    #     # ドキュメントクエリ機能の有効/無効
    #     # 有効な値: "ENABLED", "DISABLED"
    #     status = null
    #   }
    #
    #   # モデルレジストリ設定
    #   model_register_settings {
    #     # クロスアカウントモデルレジストリ用のロールARN
    #     # 異なるAWSアカウントで作成されたモデルバージョンを登録する場合のみ必要
    #     cross_account_model_register_role_arn = null
    #
    #     # モデルレジストリ統合の有効/無効
    #     # 有効な値: "ENABLED", "DISABLED"
    #     status = null
    #   }
    #
    #   # 時系列予測設定
    #   time_series_forecasting_settings {
    #     # Amazon Forecastに渡されるIAMロールARN
    #     # AmazonSageMakerCanvasForecastAccessポリシーをアタッチし、
    #     # forecast.amazonaws.comをサービスプリンシパルとして信頼関係に追加する必要があります
    #     amazon_forecast_role_arn = null
    #
    #     # 時系列予測の有効/無効
    #     # 有効な値: "ENABLED", "DISABLED"
    #     status = null
    #   }
    #
    #   # ワークスペース設定
    #   workspace_settings {
    #     # Canvasが生成するアーティファクトを保存するS3バケット
    #     # 変更すると既存の設定に影響し、ユーザーは再ログインが必要
    #     s3_artifact_path = null
    #
    #     # S3バケット内のアーティファクトを暗号化するKMSキーID
    #     s3_kms_key_id = null
    #   }
    # }

    #---------------------------------------------------------------
    # Code Editor App Settings
    #---------------------------------------------------------------
    # Code Editorアプリケーションの設定
    # code_editor_app_settings {
    #   # デフォルトライフサイクル設定より前に実行される組み込みライフサイクル設定ARN
    #   # デフォルトライフサイクル設定の変更を上書き可能
    #   built_in_lifecycle_config_arn = null
    #
    #   # ライフサイクル設定のARNリスト
    #   lifecycle_config_arns = null
    #
    #   # アプリライフサイクル管理設定
    #   app_lifecycle_management {
    #     idle_settings {
    #       # アイドルタイムアウト時間（分）
    #       # 有効な値: 60～525600
    #       idle_timeout_in_minutes = null
    #
    #       # アイドルシャットダウンの有効/無効
    #       # 有効な値: "ENABLED", "DISABLED"
    #       lifecycle_management = null
    #
    #       # ユーザーが設定できるアイドルタイムアウトの最大値（分）
    #       # 有効な値: 60～525600
    #       max_idle_timeout_in_minutes = null
    #
    #       # ユーザーが設定できるアイドルタイムアウトの最小値（分）
    #       # 有効な値: 60～525600
    #       min_idle_timeout_in_minutes = null
    #     }
    #   }
    #
    #   # カスタムSageMaker AIイメージ設定（最大200個）
    #   custom_image {
    #     # 必須: App Image Config名
    #     app_image_config_name = "example-config"
    #
    #     # 必須: カスタムイメージ名
    #     image_name = "example-image"
    #
    #     # カスタムイメージのバージョン番号
    #     image_version_number = null
    #   }
    #
    #   # デフォルトリソース仕様
    #   default_resource_spec {
    #     # インスタンスタイプ
    #     # 有効な値についてはSageMaker AIインスタンスタイプを参照
    #     # https://docs.aws.amazon.com/sagemaker/latest/dg/notebooks-available-instance-types.html
    #     instance_type = null
    #
    #     # ライフサイクル設定ARN
    #     lifecycle_config_arn = null
    #
    #     # SageMaker AIイメージARN
    #     sagemaker_image_arn = null
    #
    #     # SageMaker AIイメージバージョンエイリアス
    #     sagemaker_image_version_alias = null
    #
    #     # SageMaker AIイメージバージョンARN
    #     sagemaker_image_version_arn = null
    #   }
    # }

    #---------------------------------------------------------------
    # Custom File System Config
    #---------------------------------------------------------------
    # ユーザープロファイルへのカスタムファイルシステム割り当て設定
    # 許可されたユーザーはStudio内でこのファイルシステムにアクセス可能
    # custom_file_system_config {
    #   efs_file_system_config {
    #     # 必須: Amazon EFSファイルシステムID
    #     # 例: "fs-12345678"
    #     file_system_id = "fs-12345678"
    #
    #     # SageMaker AI Studio内でアクセス可能なファイルシステムディレクトリのパス
    #     # 許可されたユーザーはこのディレクトリとそのサブディレクトリのみアクセス可能
    #     file_system_path = null
    #   }
    # }

    #---------------------------------------------------------------
    # Custom POSIX User Config
    #---------------------------------------------------------------
    # ファイルシステム操作に使用されるPOSIX IDの詳細設定
    # custom_posix_user_config {
    #   # 必須: POSIXグループID
    #   gid = 1000
    #
    #   # 必須: POSIXユーザーID
    #   uid = 1000
    # }

    #---------------------------------------------------------------
    # JupyterLab App Settings
    #---------------------------------------------------------------
    # JupyterLabアプリケーションの設定
    # jupyter_lab_app_settings {
    #   # デフォルトライフサイクル設定より前に実行される組み込みライフサイクル設定ARN
    #   built_in_lifecycle_config_arn = null
    #
    #   # ライフサイクル設定のARNリスト
    #   lifecycle_config_arns = null
    #
    #   # アプリライフサイクル管理設定
    #   app_lifecycle_management {
    #     idle_settings {
    #       # アイドルタイムアウト時間（分）
    #       # 有効な値: 60～525600
    #       idle_timeout_in_minutes = null
    #
    #       # アイドルシャットダウンの有効/無効
    #       # 有効な値: "ENABLED", "DISABLED"
    #       lifecycle_management = null
    #
    #       # ユーザーが設定できるアイドルタイムアウトの最大値（分）
    #       # 有効な値: 60～525600
    #       max_idle_timeout_in_minutes = null
    #
    #       # ユーザーが設定できるアイドルタイムアウトの最小値（分）
    #       # 有効な値: 60～525600
    #       min_idle_timeout_in_minutes = null
    #     }
    #   }
    #
    #   # Gitリポジトリ設定（最大10個）
    #   code_repository {
    #     # 必須: GitリポジトリのURL
    #     repository_url = "https://github.com/example/repo.git"
    #   }
    #
    #   # カスタムSageMaker AIイメージ設定（最大200個）
    #   custom_image {
    #     # 必須: App Image Config名
    #     app_image_config_name = "example-config"
    #
    #     # 必須: カスタムイメージ名
    #     image_name = "example-image"
    #
    #     # カスタムイメージのバージョン番号
    #     image_version_number = null
    #   }
    #
    #   # デフォルトリソース仕様
    #   default_resource_spec {
    #     # インスタンスタイプ
    #     instance_type = null
    #
    #     # ライフサイクル設定ARN
    #     lifecycle_config_arn = null
    #
    #     # SageMaker AIイメージARN
    #     sagemaker_image_arn = null
    #
    #     # SageMaker AIイメージバージョンエイリアス
    #     sagemaker_image_version_alias = null
    #
    #     # SageMaker AIイメージバージョンARN
    #     sagemaker_image_version_arn = null
    #   }
    #
    #   # EMR設定
    #   emr_settings {
    #     # SageMakerの実行ロールが引き受け可能なIAMロールのARN配列
    #     # EMRクラスターまたはEMR Serverlessアプリケーションに関連する
    #     # 操作やタスクを実行する際の権限とアクセスポリシーを定義
    #     assumable_role_arns = null
    #
    #     # EMRクラスターインスタンスまたはジョブ実行環境が使用するIAMロールのARN配列
    #     # ランタイム中にS3、CloudWatchなどの他のAWSサービスにアクセスするために使用
    #     execution_role_arns = null
    #   }
    # }

    #---------------------------------------------------------------
    # Jupyter Server App Settings
    #---------------------------------------------------------------
    # Jupyter Serverアプリケーション設定
    # jupyter_server_app_settings {
    #   # ライフサイクル設定のARNリスト
    #   lifecycle_config_arns = null
    #
    #   # Gitリポジトリ設定（最大10個）
    #   code_repository {
    #     # 必須: GitリポジトリのURL
    #     repository_url = "https://github.com/example/repo.git"
    #   }
    #
    #   # デフォルトリソース仕様
    #   default_resource_spec {
    #     # インスタンスタイプ
    #     instance_type = null
    #
    #     # ライフサイクル設定ARN
    #     lifecycle_config_arn = null
    #
    #     # SageMaker AIイメージARN
    #     sagemaker_image_arn = null
    #
    #     # SageMaker AIイメージバージョンエイリアス
    #     sagemaker_image_version_alias = null
    #
    #     # SageMaker AIイメージバージョンARN
    #     sagemaker_image_version_arn = null
    #   }
    # }

    #---------------------------------------------------------------
    # Kernel Gateway App Settings
    #---------------------------------------------------------------
    # Kernel Gatewayアプリケーション設定
    # kernel_gateway_app_settings {
    #   # ライフサイクル設定のARNリスト
    #   lifecycle_config_arns = null
    #
    #   # カスタムSageMaker AIイメージ設定（最大200個）
    #   custom_image {
    #     # 必須: App Image Config名
    #     app_image_config_name = "example-config"
    #
    #     # 必須: カスタムイメージ名
    #     image_name = "example-image"
    #
    #     # カスタムイメージのバージョン番号
    #     image_version_number = null
    #   }
    #
    #   # デフォルトリソース仕様
    #   default_resource_spec {
    #     # インスタンスタイプ
    #     instance_type = null
    #
    #     # ライフサイクル設定ARN
    #     lifecycle_config_arn = null
    #
    #     # SageMaker AIイメージARN
    #     sagemaker_image_arn = null
    #
    #     # SageMaker AIイメージバージョンエイリアス
    #     sagemaker_image_version_alias = null
    #
    #     # SageMaker AIイメージバージョンARN
    #     sagemaker_image_version_arn = null
    #   }
    # }

    #---------------------------------------------------------------
    # RSession App Settings
    #---------------------------------------------------------------
    # RSessionアプリケーション設定
    # r_session_app_settings {
    #   # カスタムSageMaker AIイメージ設定（最大200個）
    #   custom_image {
    #     # 必須: App Image Config名
    #     app_image_config_name = "example-config"
    #
    #     # 必須: カスタムイメージ名
    #     image_name = "example-image"
    #
    #     # カスタムイメージのバージョン番号
    #     image_version_number = null
    #   }
    #
    #   # デフォルトリソース仕様
    #   default_resource_spec {
    #     # インスタンスタイプ
    #     instance_type = null
    #
    #     # ライフサイクル設定ARN
    #     lifecycle_config_arn = null
    #
    #     # SageMaker AIイメージARN
    #     sagemaker_image_arn = null
    #
    #     # SageMaker AIイメージバージョンエイリアス
    #     sagemaker_image_version_alias = null
    #
    #     # SageMaker AIイメージバージョンARN
    #     sagemaker_image_version_arn = null
    #   }
    # }

    #---------------------------------------------------------------
    # RStudio Server Pro App Settings
    #---------------------------------------------------------------
    # RStudioServerProアプリケーション設定
    # r_studio_server_pro_app_settings {
    #   # 現在のユーザーがRStudioServerProアプリにアクセスできるかどうか
    #   # 有効な値: "ENABLED", "DISABLED"
    #   access_status = null
    #
    #   # RStudioServerProアプリ内でのユーザーの権限レベル
    #   # デフォルト: "R_STUDIO_USER"
    #   # 有効な値: "R_STUDIO_USER", "R_STUDIO_ADMIN"
    #   # "R_STUDIO_ADMIN"はRStudio管理ダッシュボードへのアクセスを許可
    #   user_group = null
    # }

    #---------------------------------------------------------------
    # Sharing Settings
    #---------------------------------------------------------------
    # 共有設定
    # sharing_settings {
    #   # ノートブック共有時にセル出力を含めるかどうか
    #   # デフォルト: "Disabled"
    #   # 有効な値: "Allowed", "Disabled"
    #   notebook_output_option = null
    #
    #   # ノートブックセル出力をS3バケットで暗号化するためのKMSキーID
    #   # notebook_output_optionが"Allowed"の場合に使用
    #   s3_kms_key_id = null
    #
    #   # ノートブックセル出力を保存するS3バケット
    #   # notebook_output_optionが"Allowed"の場合に使用
    #   s3_output_path = null
    # }

    #---------------------------------------------------------------
    # Space Storage Settings
    #---------------------------------------------------------------
    # プライベートスペースのストレージ設定
    # space_storage_settings {
    #   default_ebs_storage_settings {
    #     # 必須: プライベートスペースのデフォルトEBSストレージボリュームサイズ（GB）
    #     default_ebs_volume_size_in_gb = 5
    #
    #     # 必須: プライベートスペースの最大EBSストレージボリュームサイズ（GB）
    #     maximum_ebs_volume_size_in_gb = 100
    #   }
    # }

    #---------------------------------------------------------------
    # Studio Web Portal Settings
    #---------------------------------------------------------------
    # Studio Webポータル設定
    # studio_web_portal_settings {
    #   # Studioの左ナビゲーションペインから非表示にするアプリケーション
    #   # 例: ["JupyterServer", "CodeEditor"]
    #   hidden_app_types = null
    #
    #   # StudioのUIから非表示にするインスタンスタイプ
    #   # 例: ["ml.m5.xlarge", "ml.t3.medium"]
    #   hidden_instance_types = null
    #
    #   # Studioの左ナビゲーションペインから非表示にする機械学習ツール
    #   # 例: ["Training", "Experiments"]
    #   hidden_ml_tools = null
    # }

    #---------------------------------------------------------------
    # TensorBoard App Settings
    #---------------------------------------------------------------
    # TensorBoardアプリケーション設定
    # tensor_board_app_settings {
    #   # デフォルトリソース仕様
    #   default_resource_spec {
    #     # インスタンスタイプ
    #     instance_type = null
    #
    #     # ライフサイクル設定ARN
    #     lifecycle_config_arn = null
    #
    #     # SageMaker AIイメージARN
    #     sagemaker_image_arn = null
    #
    #     # SageMaker AIイメージバージョンエイリアス
    #     sagemaker_image_version_alias = null
    #
    #     # SageMaker AIイメージバージョンARN
    #     sagemaker_image_version_arn = null
    #   }
    # }
  }
}

#---------------------------------------------------------------
# Attributes Reference (Computed Only)
#---------------------------------------------------------------
# 以下の属性はTerraformによって計算され、参照可能ですが設定できません:
#
# - arn                        : ユーザープロファイルのAmazon Resource Name (ARN)
# - home_efs_file_system_uid   : Amazon Elastic File System (EFS)ボリューム内のユーザープロファイルID
# - id                         : ユーザープロファイルのリソースID
# - tags_all                   : プロバイダーのdefault_tagsを含む全てのタグのマップ
