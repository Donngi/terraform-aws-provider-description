#---------------------------------------------------------------
# Amazon SageMaker User Profile
#---------------------------------------------------------------
#
# Amazon SageMaker AIドメイン内の個別ユーザーを表すユーザープロファイルを
# プロビジョニングするリソースです。ユーザープロファイルはドメイン内で
# ユーザーが利用するアプリケーション設定・実行ロール・ストレージ設定を管理します。
# ドメインの認証モードがSSOの場合はSSO関連の設定も必要です。
#
# AWS公式ドキュメント:
#   - ドメインユーザープロファイル: https://docs.aws.amazon.com/sagemaker/latest/dg/domain-user-profile.html
#   - ユーザープロファイルの追加: https://docs.aws.amazon.com/sagemaker/latest/dg/domain-user-profile-add.html
#   - UserSettings APIリファレンス: https://docs.aws.amazon.com/sagemaker/latest/APIReference/API_UserSettings.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/sagemaker_user_profile
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_sagemaker_user_profile" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # domain_id (Required)
  # 設定内容: ユーザープロファイルを作成する対象のSageMakerドメインIDを指定します。
  # 設定可能な値: 有効なSageMakerドメインID
  domain_id = "d-xxxxxxxxxxxx"

  # user_profile_name (Required)
  # 設定内容: ユーザープロファイルの名前を指定します。
  # 設定可能な値: 英数字・ハイフンからなる文字列（ドメイン内で一意であること）
  user_profile_name = "example-user"

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
  # SSO設定
  #-------------------------------------------------------------

  # single_sign_on_user_identifier (Optional)
  # 設定内容: single_sign_on_user_value で指定する値の種別を指定します。
  # 設定可能な値: "UserName"（現在サポートされる唯一の値）
  # 省略時: ドメインのAuthModeがSSOの場合は必須。非SSO時は指定不可。
  single_sign_on_user_identifier = null

  # single_sign_on_user_value (Optional)
  # 設定内容: このユーザープロファイルに関連付けるAWS IAM Identity CenterユーザーのIDを指定します。
  # 設定可能な値: IAM Identity Centerディレクトリ内の有効なユーザー名
  # 省略時: ドメインのAuthModeがSSOの場合は必須。非SSO時は指定不可。
  single_sign_on_user_value = null

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 省略時: タグなし
  tags = {
    Name        = "example-user"
    Environment = "production"
  }

  #-------------------------------------------------------------
  # ユーザー設定
  #-------------------------------------------------------------

  # user_settings (Optional)
  # 設定内容: ユーザーのアプリケーション設定・実行ロール・ストレージ等を定義するブロックです。
  # 参考: https://docs.aws.amazon.com/sagemaker/latest/APIReference/API_UserSettings.html
  user_settings {

    # execution_role (Required)
    # 設定内容: ユーザーの実行ロールARNを指定します。
    # 設定可能な値: 有効なIAMロールARN
    execution_role = "arn:aws:iam::123456789012:role/sagemaker-execution-role"

    # auto_mount_home_efs (Optional)
    # 設定内容: ユーザープロファイルのEFSボリュームの自動マウントを有効にするかを指定します。
    # 設定可能な値:
    #   - "Enabled": 自動マウントを有効化
    #   - "Disabled": 自動マウントを無効化
    #   - "DefaultAsDomain": ドメインの設定に従う（ユーザープロファイルのみ有効）
    # 省略時: Terraformがデフォルト値を使用
    auto_mount_home_efs = "Enabled"

    # default_landing_uri (Optional)
    # 設定内容: ドメインにアクセスした際にユーザーがデフォルトでリダイレクトされるUIを指定します。
    # 設定可能な値:
    #   - "studio::": SageMaker Studio（StudioWebPortalがENABLEDの場合のみ有効）
    #   - "app:JupyterServer:": Studio Classic
    # 省略時: ドメインの設定に従う
    default_landing_uri = "studio::"

    # security_groups (Optional)
    # 設定内容: ユーザーに割り当てるセキュリティグループIDのセットを指定します。
    # 設定可能な値: 有効なセキュリティグループIDのリスト
    # 省略時: ドメインのデフォルトセキュリティグループが適用されます
    security_groups = ["sg-12345678"]

    # studio_web_portal (Optional)
    # 設定内容: ユーザーがSageMaker Studioにアクセスできるかを指定します。
    # 設定可能な値:
    #   - "ENABLED": Studioへのアクセスを有効化
    #   - "DISABLED": Studioへのアクセスを無効化
    # 省略時: Terraformがデフォルト値を使用
    studio_web_portal = "ENABLED"

    #-------------------------------------------------------------
    # Studio Webポータル設定
    #-------------------------------------------------------------

    # studio_web_portal_settings (Optional)
    # 設定内容: Studio Webポータルで非表示にするアプリ種別・インスタンスタイプ・MLツールを設定するブロックです。
    studio_web_portal_settings {

      # hidden_app_types (Optional)
      # 設定内容: Studio左ナビゲーションペインから非表示にするアプリケーション種別のセットを指定します。
      # 設定可能な値: SageMaker Studioでサポートされるアプリ種別の文字列セット
      # 省略時: 非表示にするアプリなし
      hidden_app_types = []

      # hidden_instance_types (Optional)
      # 設定内容: Studio UIから非表示にするインスタンスタイプのセットを指定します。
      # 設定可能な値: 有効なSageMakerインスタンスタイプ文字列のセット
      # 省略時: 非表示にするインスタンスタイプなし
      hidden_instance_types = []

      # hidden_ml_tools (Optional)
      # 設定内容: Studio左ナビゲーションペインから非表示にするMLツールのセットを指定します。
      # 設定可能な値: SageMaker Studioでサポートされるツール名の文字列セット
      # 省略時: 非表示にするMLツールなし
      hidden_ml_tools = []
    }

    #-------------------------------------------------------------
    # 共有設定
    #-------------------------------------------------------------

    # sharing_settings (Optional)
    # 設定内容: ノートブックセル出力の共有方法を設定するブロックです。
    sharing_settings {

      # notebook_output_option (Optional)
      # 設定内容: ノートブック共有時にセル出力を含めるかを指定します。
      # 設定可能な値:
      #   - "Allowed": セル出力を共有に含めることを許可
      #   - "Disabled": セル出力を共有に含めない（デフォルト）
      # 省略時: "Disabled"
      notebook_output_option = "Disabled"

      # s3_kms_key_id (Optional)
      # 設定内容: notebook_output_optionがAllowedの場合に、S3バケットに保存するセル出力の暗号化に使用するKMSキーIDを指定します。
      # 設定可能な値: 有効なKMSキーID
      # 省略時: 暗号化なし
      s3_kms_key_id = null

      # s3_output_path (Optional)
      # 設定内容: notebook_output_optionがAllowedの場合に、セル出力を保存するS3バケットのパスを指定します。
      # 設定可能な値: 有効なS3バケットURIまたはパス
      # 省略時: 出力先S3パスなし
      s3_output_path = null
    }

    #-------------------------------------------------------------
    # ストレージ設定
    #-------------------------------------------------------------

    # space_storage_settings (Optional)
    # 設定内容: プライベートスペースのデフォルトEBSストレージを設定するブロックです。
    space_storage_settings {

      # default_ebs_storage_settings (Optional)
      # 設定内容: プライベートスペースのEBSストレージのデフォルト・最大サイズを設定するブロックです。
      default_ebs_storage_settings {

        # default_ebs_volume_size_in_gb (Required)
        # 設定内容: プライベートスペースのEBSストレージボリュームのデフォルトサイズ（GB）を指定します。
        # 設定可能な値: 正の整数（GB単位）
        default_ebs_volume_size_in_gb = 10

        # maximum_ebs_volume_size_in_gb (Required)
        # 設定内容: プライベートスペースのEBSストレージボリュームの最大サイズ（GB）を指定します。
        # 設定可能な値: default_ebs_volume_size_in_gb 以上の正の整数（GB単位）
        maximum_ebs_volume_size_in_gb = 100
      }
    }

    #-------------------------------------------------------------
    # カスタムファイルシステム設定
    #-------------------------------------------------------------

    # custom_file_system_config (Optional)
    # 設定内容: ユーザープロファイルに割り当てるカスタムファイルシステムを設定するブロックです。
    # 注意: 複数のブロックを指定できます。
    custom_file_system_config {

      # efs_file_system_config (Optional)
      # 設定内容: EFSファイルシステムの接続設定を定義するブロックです。
      efs_file_system_config {

        # file_system_id (Required)
        # 設定内容: 接続するAmazon EFSファイルシステムのIDを指定します。
        # 設定可能な値: 有効なEFSファイルシステムID（例: fs-xxxxxxxx）
        file_system_id = "fs-12345678"

        # file_system_path (Optional)
        # 設定内容: SageMaker AI Studioからアクセス可能なEFSのディレクトリパスを指定します。
        # 設定可能な値: 有効なEFSディレクトリパス文字列
        # 省略時: ルートパスが使用されます
        file_system_path = "/shared"
      }
    }

    #-------------------------------------------------------------
    # カスタムPOSIXユーザー設定
    #-------------------------------------------------------------

    # custom_posix_user_config (Optional)
    # 設定内容: ファイルシステム操作に使用するPOSIXユーザーのUID/GIDを設定するブロックです。
    custom_posix_user_config {

      # gid (Required)
      # 設定内容: POSIXグループIDを指定します。
      # 設定可能な値: 有効なPOSIXグループID（正の整数）
      gid = 1001

      # uid (Required)
      # 設定内容: POSIXユーザーIDを指定します。
      # 設定可能な値: 有効なPOSIXユーザーID（正の整数）
      uid = 1001
    }

    #-------------------------------------------------------------
    # Canvas アプリケーション設定
    #-------------------------------------------------------------

    # canvas_app_settings (Optional)
    # 設定内容: SageMaker Canvas アプリケーションの各種機能設定を定義するブロックです。
    # 参考: https://docs.aws.amazon.com/sagemaker/latest/dg/canvas-setting-up.html
    canvas_app_settings {

      # direct_deploy_settings (Optional)
      # 設定内容: Canvasアプリケーションのモデルデプロイ権限設定を定義するブロックです。
      direct_deploy_settings {

        # status (Optional)
        # 設定内容: Canvasアプリケーションでモデルデプロイ権限を有効にするかを指定します。
        # 設定可能な値:
        #   - "ENABLED": モデルデプロイを有効化
        #   - "DISABLED": モデルデプロイを無効化
        # 省略時: ドメインの設定に従う
        status = "DISABLED"
      }

      # emr_serverless_settings (Optional)
      # 設定内容: CanvasでAmazon EMR Serverlessジョブを実行するための設定ブロックです。
      emr_serverless_settings {

        # execution_role_arn (Optional)
        # 設定内容: EMR Serverlessジョブを実行するためのIAMロールARNを指定します。
        # 設定可能な値: 有効なIAMロールARN
        # 省略時: ユーザープロファイルの実行ロールが使用されます
        execution_role_arn = null

        # status (Optional)
        # 設定内容: CanvasアプリケーションのEMR Serverlessジョブ機能を有効にするかを指定します。
        # 設定可能な値:
        #   - "ENABLED": EMR Serverlessジョブを有効化
        #   - "DISABLED": EMR Serverlessジョブを無効化
        # 省略時: ドメインの設定に従う
        status = "DISABLED"
      }

      # generative_ai_settings (Optional)
      # 設定内容: CanvasのGenerative AI機能設定を定義するブロックです。
      generative_ai_settings {

        # amazon_bedrock_role_arn (Optional)
        # 設定内容: Amazon Bedrockを使用するためのIAMロールARNを指定します。
        # 設定可能な値: 有効なIAMロールARN
        # 省略時: Bedrock統合を使用しない
        amazon_bedrock_role_arn = null
      }

      # identity_provider_oauth_settings (Optional)
      # 設定内容: 外部データソースへのOAuth接続設定を定義するブロックです。最大20件指定可能。
      identity_provider_oauth_settings {

        # data_source_name (Optional)
        # 設定内容: OAuth接続するデータソース名を指定します。
        # 設定可能な値:
        #   - "SalesforceGenie": Salesforce Data Cloud
        #   - "Snowflake": Snowflake
        # 省略時: データソース名なし
        data_source_name = "Snowflake"

        # secret_arn (Required)
        # 設定内容: OAuthのクライアントIDやシークレット等の認証情報を格納するSecrets ManagerシークレットのARNを指定します。
        # 設定可能な値: 有効なSecrets Manager シークレットARN
        secret_arn = "arn:aws:secretsmanager:ap-northeast-1:123456789012:secret:canvas-oauth-secret"

        # status (Optional)
        # 設定内容: このデータソースのOAuth連携を有効にするかを指定します。
        # 設定可能な値:
        #   - "ENABLED": OAuth連携を有効化
        #   - "DISABLED": OAuth連携を無効化
        # 省略時: ドメインの設定に従う
        status = "DISABLED"
      }

      # kendra_settings (Optional)
      # 設定内容: Canvasのドキュメントクエリ（Amazon Kendra連携）設定を定義するブロックです。
      kendra_settings {

        # status (Optional)
        # 設定内容: Canvasアプリケーションのドキュメントクエリ機能を有効にするかを指定します。
        # 設定可能な値:
        #   - "ENABLED": ドキュメントクエリを有効化
        #   - "DISABLED": ドキュメントクエリを無効化
        # 省略時: ドメインの設定に従う
        status = "DISABLED"
      }

      # model_register_settings (Optional)
      # 設定内容: Canvasアプリケーションのモデルレジストリ統合設定を定義するブロックです。
      model_register_settings {

        # cross_account_model_register_role_arn (Optional)
        # 設定内容: 異なるAWSアカウントのSageMakerモデルレジストリにモデルを登録するためのIAMロールARNを指定します。
        # 設定可能な値: 有効なIAMロールARN
        # 省略時: クロスアカウント登録なし
        cross_account_model_register_role_arn = null

        # status (Optional)
        # 設定内容: Canvasアプリケーションのモデルレジストリ統合を有効にするかを指定します。
        # 設定可能な値:
        #   - "ENABLED": モデルレジストリ統合を有効化
        #   - "DISABLED": モデルレジストリ統合を無効化
        # 省略時: ドメインの設定に従う
        status = "DISABLED"
      }

      # time_series_forecasting_settings (Optional)
      # 設定内容: Canvasの時系列予測（Amazon Forecast連携）設定を定義するブロックです。
      time_series_forecasting_settings {

        # amazon_forecast_role_arn (Optional)
        # 設定内容: Amazon Forecastに渡すIAMロールARNを指定します。未指定の場合はユーザーの実行ロールが使用されます。
        # 設定可能な値: 有効なIAMロールARN
        # 省略時: ユーザープロファイルまたはドメインの実行ロールが使用されます
        amazon_forecast_role_arn = null

        # status (Optional)
        # 設定内容: Canvasアプリケーションの時系列予測機能を有効にするかを指定します。
        # 設定可能な値:
        #   - "ENABLED": 時系列予測を有効化
        #   - "DISABLED": 時系列予測を無効化
        # 省略時: ドメインの設定に従う
        status = "DISABLED"
      }

      # workspace_settings (Optional)
      # 設定内容: Canvasのワークスペース設定（成果物保存先S3等）を定義するブロックです。
      workspace_settings {

        # s3_artifact_path (Optional)
        # 設定内容: Canvasが成果物を保存するS3バケットのパスを指定します。
        # 設定可能な値: 有効なS3バケットURI
        # 省略時: デフォルトのS3パスが使用されます
        s3_artifact_path = null

        # s3_kms_key_id (Optional)
        # 設定内容: S3バケットに保存するCanvas成果物の暗号化に使用するKMSキーIDを指定します。
        # 設定可能な値: 有効なKMSキーID
        # 省略時: 暗号化なし
        s3_kms_key_id = null
      }
    }

    #-------------------------------------------------------------
    # Code Editor アプリケーション設定
    #-------------------------------------------------------------

    # code_editor_app_settings (Optional)
    # 設定内容: Code Editorアプリケーションのインスタンス・ライフサイクル・カスタムイメージを設定するブロックです。
    code_editor_app_settings {

      # built_in_lifecycle_config_arn (Optional)
      # 設定内容: デフォルトのライフサイクル設定の前に実行されるビルトインライフサイクル設定のARNを指定します。
      # 設定可能な値: 有効なSageMakerライフサイクル設定ARN
      # 省略時: ビルトインライフサイクル設定なし
      built_in_lifecycle_config_arn = null

      # lifecycle_config_arns (Optional)
      # 設定内容: Code Editorアプリに適用するライフサイクル設定ARNのセットを指定します。
      # 設定可能な値: 有効なSageMakerライフサイクル設定ARNのセット
      # 省略時: ライフサイクル設定なし
      lifecycle_config_arns = []

      # app_lifecycle_management (Optional)
      # 設定内容: アイドル状態のCode Editorアプリを自動シャットダウンするためのライフサイクル管理設定ブロックです。
      app_lifecycle_management {

        # idle_settings (Optional)
        # 設定内容: アイドルシャットダウンのタイムアウト設定を定義するブロックです。
        idle_settings {

          # idle_timeout_in_minutes (Optional)
          # 設定内容: アプリがアイドル状態になってからシャットダウンするまでの待機時間（分）を指定します。
          # 設定可能な値: 60〜525600の整数
          # 省略時: ライフサイクル管理設定のデフォルト値が使用されます
          idle_timeout_in_minutes = 60

          # lifecycle_management (Optional)
          # 設定内容: このアプリタイプのアイドルシャットダウンを有効にするかを指定します。
          # 設定可能な値:
          #   - "ENABLED": アイドルシャットダウンを有効化
          #   - "DISABLED": アイドルシャットダウンを無効化
          # 省略時: ドメインの設定に従う
          lifecycle_management = "ENABLED"

          # max_idle_timeout_in_minutes (Optional)
          # 設定内容: ユーザーがカスタム設定できるアイドルタイムアウトの最大値（分）を指定します。
          # 設定可能な値: 60〜525600の整数
          # 省略時: 上限なし
          max_idle_timeout_in_minutes = 120

          # min_idle_timeout_in_minutes (Optional)
          # 設定内容: ユーザーがカスタム設定できるアイドルタイムアウトの最小値（分）を指定します。
          # 設定可能な値: 60〜525600の整数
          # 省略時: 下限なし
          min_idle_timeout_in_minutes = 60
        }
      }

      # custom_image (Optional)
      # 設定内容: Code Editorアプリとして実行するカスタムSageMakerイメージを設定するブロックです。最大200件指定可能。
      custom_image {

        # app_image_config_name (Required)
        # 設定内容: カスタムイメージに使用するApp Image Configの名前を指定します。
        # 設定可能な値: 有効なApp Image Config名
        app_image_config_name = "my-code-editor-image-config"

        # image_name (Required)
        # 設定内容: カスタムイメージの名前を指定します。
        # 設定可能な値: 有効なSageMakerカスタムイメージ名
        image_name = "my-code-editor-image"

        # image_version_number (Optional)
        # 設定内容: カスタムイメージのバージョン番号を指定します。
        # 設定可能な値: 正の整数
        # 省略時: 最新バージョンが使用されます
        image_version_number = null
      }

      # default_resource_spec (Optional)
      # 設定内容: Code EditorアプリのデフォルトインスタンスタイプとSageMakerイメージARNを指定するブロックです。
      default_resource_spec {

        # instance_type (Optional)
        # 設定内容: イメージバージョンが実行されるインスタンスタイプを指定します。
        # 設定可能な値: 有効なSageMakerインスタンスタイプ（例: ml.t3.medium, ml.c5.large）
        # 参考: https://docs.aws.amazon.com/sagemaker/latest/dg/notebooks-available-instance-types.html
        # 省略時: デフォルトのインスタンスタイプが使用されます
        instance_type = "ml.t3.medium"

        # lifecycle_config_arn (Optional)
        # 設定内容: リソースに適用するライフサイクル設定ARNを指定します。
        # 設定可能な値: 有効なSageMakerライフサイクル設定ARN
        # 省略時: ライフサイクル設定なし
        lifecycle_config_arn = null

        # sagemaker_image_arn (Optional)
        # 設定内容: イメージバージョンが属するSageMakerイメージのARNを指定します。
        # 設定可能な値: 有効なSageMakerイメージARN
        # 省略時: デフォルトイメージが使用されます
        sagemaker_image_arn = null

        # sagemaker_image_version_alias (Optional)
        # 設定内容: SageMakerイメージバージョンのエイリアスを指定します。
        # 設定可能な値: 有効なイメージバージョンエイリアス文字列
        # 省略時: エイリアスなし
        sagemaker_image_version_alias = null

        # sagemaker_image_version_arn (Optional)
        # 設定内容: インスタンスで作成されたイメージバージョンのARNを指定します。
        # 設定可能な値: 有効なSageMakerイメージバージョンARN
        # 省略時: 最新バージョンが使用されます
        sagemaker_image_version_arn = null
      }
    }

    #-------------------------------------------------------------
    # JupyterLab アプリケーション設定
    #-------------------------------------------------------------

    # jupyter_lab_app_settings (Optional)
    # 設定内容: JupyterLabアプリケーションのインスタンス・ライフサイクル・カスタムイメージ・EMR連携を設定するブロックです。
    jupyter_lab_app_settings {

      # built_in_lifecycle_config_arn (Optional)
      # 設定内容: デフォルトのライフサイクル設定の前に実行されるビルトインライフサイクル設定のARNを指定します。
      # 設定可能な値: 有効なSageMakerライフサイクル設定ARN
      # 省略時: ビルトインライフサイクル設定なし
      built_in_lifecycle_config_arn = null

      # lifecycle_config_arns (Optional)
      # 設定内容: JupyterLabアプリに適用するライフサイクル設定ARNのセットを指定します。
      # 設定可能な値: 有効なSageMakerライフサイクル設定ARNのセット
      # 省略時: ライフサイクル設定なし
      lifecycle_config_arns = []

      # app_lifecycle_management (Optional)
      # 設定内容: アイドル状態のJupyterLabアプリを自動シャットダウンするためのライフサイクル管理設定ブロックです。
      app_lifecycle_management {

        # idle_settings (Optional)
        # 設定内容: アイドルシャットダウンのタイムアウト設定を定義するブロックです。
        idle_settings {

          # idle_timeout_in_minutes (Optional)
          # 設定内容: アプリがアイドル状態になってからシャットダウンするまでの待機時間（分）を指定します。
          # 設定可能な値: 60〜525600の整数
          # 省略時: ライフサイクル管理設定のデフォルト値が使用されます
          idle_timeout_in_minutes = 60

          # lifecycle_management (Optional)
          # 設定内容: このアプリタイプのアイドルシャットダウンを有効にするかを指定します。
          # 設定可能な値:
          #   - "ENABLED": アイドルシャットダウンを有効化
          #   - "DISABLED": アイドルシャットダウンを無効化
          # 省略時: ドメインの設定に従う
          lifecycle_management = "ENABLED"

          # max_idle_timeout_in_minutes (Optional)
          # 設定内容: ユーザーがカスタム設定できるアイドルタイムアウトの最大値（分）を指定します。
          # 設定可能な値: 60〜525600の整数
          # 省略時: 上限なし
          max_idle_timeout_in_minutes = 120

          # min_idle_timeout_in_minutes (Optional)
          # 設定内容: ユーザーがカスタム設定できるアイドルタイムアウトの最小値（分）を指定します。
          # 設定可能な値: 60〜525600の整数
          # 省略時: 下限なし
          min_idle_timeout_in_minutes = 60
        }
      }

      # code_repository (Optional)
      # 設定内容: JupyterServerアプリでユーザーに表示するGitリポジトリを設定するブロックです。最大10件指定可能。
      code_repository {

        # repository_url (Required)
        # 設定内容: GitリポジトリのURLを指定します。
        # 設定可能な値: 有効なGitリポジトリURL文字列
        repository_url = "https://github.com/example/repository"
      }

      # custom_image (Optional)
      # 設定内容: JupyterLabアプリとして実行するカスタムSageMakerイメージを設定するブロックです。最大200件指定可能。
      custom_image {

        # app_image_config_name (Required)
        # 設定内容: カスタムイメージに使用するApp Image Configの名前を指定します。
        # 設定可能な値: 有効なApp Image Config名
        app_image_config_name = "my-jupyterlab-image-config"

        # image_name (Required)
        # 設定内容: カスタムイメージの名前を指定します。
        # 設定可能な値: 有効なSageMakerカスタムイメージ名
        image_name = "my-jupyterlab-image"

        # image_version_number (Optional)
        # 設定内容: カスタムイメージのバージョン番号を指定します。
        # 設定可能な値: 正の整数
        # 省略時: 最新バージョンが使用されます
        image_version_number = null
      }

      # default_resource_spec (Optional)
      # 設定内容: JupyterLabアプリのデフォルトインスタンスタイプとSageMakerイメージARNを指定するブロックです。
      default_resource_spec {

        # instance_type (Optional)
        # 設定内容: イメージバージョンが実行されるインスタンスタイプを指定します。
        # 設定可能な値: 有効なSageMakerインスタンスタイプ（例: ml.t3.medium, ml.c5.large）
        # 参考: https://docs.aws.amazon.com/sagemaker/latest/dg/notebooks-available-instance-types.html
        # 省略時: デフォルトのインスタンスタイプが使用されます
        instance_type = "ml.t3.medium"

        # lifecycle_config_arn (Optional)
        # 設定内容: リソースに適用するライフサイクル設定ARNを指定します。
        # 設定可能な値: 有効なSageMakerライフサイクル設定ARN
        # 省略時: ライフサイクル設定なし
        lifecycle_config_arn = null

        # sagemaker_image_arn (Optional)
        # 設定内容: イメージバージョンが属するSageMakerイメージのARNを指定します。
        # 設定可能な値: 有効なSageMakerイメージARN
        # 省略時: デフォルトイメージが使用されます
        sagemaker_image_arn = null

        # sagemaker_image_version_alias (Optional)
        # 設定内容: SageMakerイメージバージョンのエイリアスを指定します。
        # 設定可能な値: 有効なイメージバージョンエイリアス文字列
        # 省略時: エイリアスなし
        sagemaker_image_version_alias = null

        # sagemaker_image_version_arn (Optional)
        # 設定内容: インスタンスで作成されたイメージバージョンのARNを指定します。
        # 設定可能な値: 有効なSageMakerイメージバージョンARN
        # 省略時: 最新バージョンが使用されます
        sagemaker_image_version_arn = null
      }

      # emr_settings (Optional)
      # 設定内容: JupyterLabからAmazon EMRクラスターやEMR Serverlessアプリを管理・アクセスするためのIAMロール設定ブロックです。
      emr_settings {

        # assumable_role_arns (Optional)
        # 設定内容: SageMakerの実行ロールが引き受けることのできるIAMロールARNのセットを指定します。EMRリソース操作（一覧表示・接続・終了等）に使用されます。
        # 設定可能な値: 有効なIAMロールARNのセット
        # 省略時: 引き受け可能なロールなし
        assumable_role_arns = []

        # execution_role_arns (Optional)
        # 設定内容: EMRクラスターインスタンスまたはジョブ実行環境が使用するIAMロールARNのセットを指定します。
        # 設定可能な値: 有効なIAMロールARNのセット
        # 省略時: 実行ロールなし
        execution_role_arns = []
      }
    }

    #-------------------------------------------------------------
    # Jupyter Server アプリケーション設定
    #-------------------------------------------------------------

    # jupyter_server_app_settings (Optional)
    # 設定内容: Jupyter Serverアプリケーションのデフォルトリソース仕様・ライフサイクル・Gitリポジトリを設定するブロックです。
    jupyter_server_app_settings {

      # lifecycle_config_arns (Optional)
      # 設定内容: Jupyter Serverアプリに適用するライフサイクル設定ARNのセットを指定します。
      # 設定可能な値: 有効なSageMakerライフサイクル設定ARNのセット
      # 省略時: ライフサイクル設定なし
      lifecycle_config_arns = []

      # code_repository (Optional)
      # 設定内容: JupyterServerアプリでユーザーに表示するGitリポジトリを設定するブロックです。最大10件指定可能。
      code_repository {

        # repository_url (Required)
        # 設定内容: GitリポジトリのURLを指定します。
        # 設定可能な値: 有効なGitリポジトリURL文字列
        repository_url = "https://github.com/example/repository"
      }

      # default_resource_spec (Optional)
      # 設定内容: Jupyter ServerアプリのデフォルトインスタンスタイプとSageMakerイメージARNを指定するブロックです。
      default_resource_spec {

        # instance_type (Optional)
        # 設定内容: イメージバージョンが実行されるインスタンスタイプを指定します。
        # 設定可能な値: 有効なSageMakerインスタンスタイプ（例: system, ml.t3.medium）
        # 参考: https://docs.aws.amazon.com/sagemaker/latest/dg/notebooks-available-instance-types.html
        # 省略時: デフォルトのインスタンスタイプが使用されます
        instance_type = "system"

        # lifecycle_config_arn (Optional)
        # 設定内容: リソースに適用するライフサイクル設定ARNを指定します。
        # 設定可能な値: 有効なSageMakerライフサイクル設定ARN
        # 省略時: ライフサイクル設定なし
        lifecycle_config_arn = null

        # sagemaker_image_arn (Optional)
        # 設定内容: イメージバージョンが属するSageMakerイメージのARNを指定します。
        # 設定可能な値: 有効なSageMakerイメージARN
        # 省略時: デフォルトイメージが使用されます
        sagemaker_image_arn = null

        # sagemaker_image_version_alias (Optional)
        # 設定内容: SageMakerイメージバージョンのエイリアスを指定します。
        # 設定可能な値: 有効なイメージバージョンエイリアス文字列
        # 省略時: エイリアスなし
        sagemaker_image_version_alias = null

        # sagemaker_image_version_arn (Optional)
        # 設定内容: インスタンスで作成されたイメージバージョンのARNを指定します。
        # 設定可能な値: 有効なSageMakerイメージバージョンARN
        # 省略時: 最新バージョンが使用されます
        sagemaker_image_version_arn = null
      }
    }

    #-------------------------------------------------------------
    # Kernel Gateway アプリケーション設定
    #-------------------------------------------------------------

    # kernel_gateway_app_settings (Optional)
    # 設定内容: Kernel Gatewayアプリケーションのデフォルトリソース仕様・ライフサイクル・カスタムイメージを設定するブロックです。
    kernel_gateway_app_settings {

      # lifecycle_config_arns (Optional)
      # 設定内容: Kernel Gatewayアプリに適用するライフサイクル設定ARNのセットを指定します。
      # 設定可能な値: 有効なSageMakerライフサイクル設定ARNのセット
      # 省略時: ライフサイクル設定なし
      lifecycle_config_arns = []

      # custom_image (Optional)
      # 設定内容: KernelGatewayアプリとして実行するカスタムSageMakerイメージを設定するブロックです。最大200件指定可能。
      custom_image {

        # app_image_config_name (Required)
        # 設定内容: カスタムイメージに使用するApp Image Configの名前を指定します。
        # 設定可能な値: 有効なApp Image Config名
        app_image_config_name = "my-kernel-gateway-image-config"

        # image_name (Required)
        # 設定内容: カスタムイメージの名前を指定します。
        # 設定可能な値: 有効なSageMakerカスタムイメージ名
        image_name = "my-kernel-gateway-image"

        # image_version_number (Optional)
        # 設定内容: カスタムイメージのバージョン番号を指定します。
        # 設定可能な値: 正の整数
        # 省略時: 最新バージョンが使用されます
        image_version_number = null
      }

      # default_resource_spec (Optional)
      # 設定内容: Kernel GatewayアプリのデフォルトインスタンスタイプとSageMakerイメージARNを指定するブロックです。
      default_resource_spec {

        # instance_type (Optional)
        # 設定内容: イメージバージョンが実行されるインスタンスタイプを指定します。
        # 設定可能な値: 有効なSageMakerインスタンスタイプ（例: ml.t3.medium, ml.c5.large）
        # 参考: https://docs.aws.amazon.com/sagemaker/latest/dg/notebooks-available-instance-types.html
        # 省略時: デフォルトのインスタンスタイプが使用されます
        instance_type = "ml.t3.medium"

        # lifecycle_config_arn (Optional)
        # 設定内容: リソースに適用するライフサイクル設定ARNを指定します。
        # 設定可能な値: 有効なSageMakerライフサイクル設定ARN
        # 省略時: ライフサイクル設定なし
        lifecycle_config_arn = null

        # sagemaker_image_arn (Optional)
        # 設定内容: イメージバージョンが属するSageMakerイメージのARNを指定します。
        # 設定可能な値: 有効なSageMakerイメージARN
        # 省略時: デフォルトイメージが使用されます
        sagemaker_image_arn = null

        # sagemaker_image_version_alias (Optional)
        # 設定内容: SageMakerイメージバージョンのエイリアスを指定します。
        # 設定可能な値: 有効なイメージバージョンエイリアス文字列
        # 省略時: エイリアスなし
        sagemaker_image_version_alias = null

        # sagemaker_image_version_arn (Optional)
        # 設定内容: インスタンスで作成されたイメージバージョンのARNを指定します。
        # 設定可能な値: 有効なSageMakerイメージバージョンARN
        # 省略時: 最新バージョンが使用されます
        sagemaker_image_version_arn = null
      }
    }

    #-------------------------------------------------------------
    # RSession アプリケーション設定
    #-------------------------------------------------------------

    # r_session_app_settings (Optional)
    # 設定内容: RSessionGatewayアプリケーションのデフォルトリソース仕様・カスタムイメージを設定するブロックです。
    r_session_app_settings {

      # custom_image (Optional)
      # 設定内容: RSessionアプリとして実行するカスタムSageMakerイメージを設定するブロックです。最大200件指定可能。
      custom_image {

        # app_image_config_name (Required)
        # 設定内容: カスタムイメージに使用するApp Image Configの名前を指定します。
        # 設定可能な値: 有効なApp Image Config名
        app_image_config_name = "my-rsession-image-config"

        # image_name (Required)
        # 設定内容: カスタムイメージの名前を指定します。
        # 設定可能な値: 有効なSageMakerカスタムイメージ名
        image_name = "my-rsession-image"

        # image_version_number (Optional)
        # 設定内容: カスタムイメージのバージョン番号を指定します。
        # 設定可能な値: 正の整数
        # 省略時: 最新バージョンが使用されます
        image_version_number = null
      }

      # default_resource_spec (Optional)
      # 設定内容: RSessionアプリのデフォルトインスタンスタイプとSageMakerイメージARNを指定するブロックです。
      default_resource_spec {

        # instance_type (Optional)
        # 設定内容: イメージバージョンが実行されるインスタンスタイプを指定します。
        # 設定可能な値: 有効なSageMakerインスタンスタイプ（例: ml.t3.medium, ml.c5.large）
        # 参考: https://docs.aws.amazon.com/sagemaker/latest/dg/notebooks-available-instance-types.html
        # 省略時: デフォルトのインスタンスタイプが使用されます
        instance_type = "ml.t3.medium"

        # lifecycle_config_arn (Optional)
        # 設定内容: リソースに適用するライフサイクル設定ARNを指定します。
        # 設定可能な値: 有効なSageMakerライフサイクル設定ARN
        # 省略時: ライフサイクル設定なし
        lifecycle_config_arn = null

        # sagemaker_image_arn (Optional)
        # 設定内容: イメージバージョンが属するSageMakerイメージのARNを指定します。
        # 設定可能な値: 有効なSageMakerイメージARN
        # 省略時: デフォルトイメージが使用されます
        sagemaker_image_arn = null

        # sagemaker_image_version_alias (Optional)
        # 設定内容: SageMakerイメージバージョンのエイリアスを指定します。
        # 設定可能な値: 有効なイメージバージョンエイリアス文字列
        # 省略時: エイリアスなし
        sagemaker_image_version_alias = null

        # sagemaker_image_version_arn (Optional)
        # 設定内容: インスタンスで作成されたイメージバージョンのARNを指定します。
        # 設定可能な値: 有効なSageMakerイメージバージョンARN
        # 省略時: 最新バージョンが使用されます
        sagemaker_image_version_arn = null
      }
    }

    #-------------------------------------------------------------
    # RStudio Server Pro アプリケーション設定
    #-------------------------------------------------------------

    # r_studio_server_pro_app_settings (Optional)
    # 設定内容: RStudioServerProアプリケーションとのユーザーインタラクション設定を定義するブロックです。
    r_studio_server_pro_app_settings {

      # access_status (Optional)
      # 設定内容: 現在のユーザーがRStudioServerProアプリにアクセスできるかを指定します。
      # 設定可能な値:
      #   - "ENABLED": RStudioServerProアプリへのアクセスを有効化
      #   - "DISABLED": RStudioServerProアプリへのアクセスを無効化
      # 省略時: ドメインの設定に従う
      access_status = "ENABLED"

      # user_group (Optional)
      # 設定内容: RStudioServerProアプリ内でのユーザーの権限レベルを指定します。
      # 設定可能な値:
      #   - "R_STUDIO_USER": 一般ユーザー（デフォルト）
      #   - "R_STUDIO_ADMIN": 管理ダッシュボードへのアクセス権を持つ管理者ユーザー
      # 省略時: "R_STUDIO_USER"
      user_group = "R_STUDIO_USER"
    }

    #-------------------------------------------------------------
    # TensorBoard アプリケーション設定
    #-------------------------------------------------------------

    # tensor_board_app_settings (Optional)
    # 設定内容: TensorBoardアプリケーションのデフォルトリソース仕様を設定するブロックです。
    tensor_board_app_settings {

      # default_resource_spec (Optional)
      # 設定内容: TensorBoardアプリのデフォルトインスタンスタイプとSageMakerイメージARNを指定するブロックです。
      default_resource_spec {

        # instance_type (Optional)
        # 設定内容: イメージバージョンが実行されるインスタンスタイプを指定します。
        # 設定可能な値: 有効なSageMakerインスタンスタイプ（例: ml.t3.medium, ml.c5.large）
        # 参考: https://docs.aws.amazon.com/sagemaker/latest/dg/notebooks-available-instance-types.html
        # 省略時: デフォルトのインスタンスタイプが使用されます
        instance_type = "ml.t3.medium"

        # lifecycle_config_arn (Optional)
        # 設定内容: リソースに適用するライフサイクル設定ARNを指定します。
        # 設定可能な値: 有効なSageMakerライフサイクル設定ARN
        # 省略時: ライフサイクル設定なし
        lifecycle_config_arn = null

        # sagemaker_image_arn (Optional)
        # 設定内容: イメージバージョンが属するSageMakerイメージのARNを指定します。
        # 設定可能な値: 有効なSageMakerイメージARN
        # 省略時: デフォルトイメージが使用されます
        sagemaker_image_arn = null

        # sagemaker_image_version_alias (Optional)
        # 設定内容: SageMakerイメージバージョンのエイリアスを指定します。
        # 設定可能な値: 有効なイメージバージョンエイリアス文字列
        # 省略時: エイリアスなし
        sagemaker_image_version_alias = null

        # sagemaker_image_version_arn (Optional)
        # 設定内容: インスタンスで作成されたイメージバージョンのARNを指定します。
        # 設定可能な値: 有効なSageMakerイメージバージョンARN
        # 省略時: 最新バージョンが使用されます
        sagemaker_image_version_arn = null
      }
    }
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: ユーザープロファイルのAmazon Resource Name (ARN)
# - home_efs_file_system_uid: Amazon EFSボリューム内のユーザープロファイルのID
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
