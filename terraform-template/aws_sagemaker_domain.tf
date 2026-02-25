#---------------------------------------------------------------
# Amazon SageMaker Domain
#---------------------------------------------------------------
#
# Amazon SageMaker AI のドメインをプロビジョニングするリソースです。
# ドメインは、Amazon SageMaker Studio やその他の SageMaker アプリケーションを
# 使用するための統合環境で、ユーザーはドメインを通じてノートブック、
# 実験管理、モデルデプロイなどの ML ワークロードを実行します。
# ドメインには VPC、サブネット、認証モード、ユーザーデフォルト設定などを構成します。
#
# AWS公式ドキュメント:
#   - SageMaker Domain概要: https://docs.aws.amazon.com/sagemaker/latest/dg/studio-entity-status.html
#   - CreateDomain API: https://docs.aws.amazon.com/sagemaker/latest/APIReference/API_CreateDomain.html
#   - DomainSettings: https://docs.aws.amazon.com/sagemaker/latest/APIReference/API_DomainSettings.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/sagemaker_domain
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_sagemaker_domain" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # domain_name (Required)
  # 設定内容: ドメインの名前を指定します。
  # 設定可能な値: 最大63文字の英数字およびハイフン
  domain_name = "example-domain"

  # auth_mode (Required)
  # 設定内容: ドメインメンバーがアクセスに使用する認証モードを指定します。
  # 設定可能な値:
  #   - "IAM": IAM認証を使用。個別の IAM ユーザー/ロールでアクセス制御
  #   - "SSO": AWS IAM Identity Center (旧 SSO) を使用した認証
  auth_mode = "IAM"

  # vpc_id (Required)
  # 設定内容: Studio が通信に使用する Amazon VPC の ID を指定します。
  # 設定可能な値: 有効な VPC ID
  vpc_id = "vpc-12345678"

  # subnet_ids (Required)
  # 設定内容: Studio が通信に使用する VPC サブネットの ID セットを指定します。
  # 設定可能な値: 有効なサブネット ID のセット
  # 注意: 高可用性のため複数の AZ にまたがるサブネットを指定することを推奨
  subnet_ids = ["subnet-12345678", "subnet-87654321"]

  #-------------------------------------------------------------
  # ネットワーク設定
  #-------------------------------------------------------------

  # app_network_access_type (Optional)
  # 設定内容: 非 EFS トラフィックに使用する VPC を指定します。
  # 設定可能な値:
  #   - "PublicInternetOnly" (デフォルト): 非 EFS トラフィックはパブリックインターネット経由
  #   - "VpcOnly": 全トラフィックを VPC 経由にルーティング。より高いセキュリティレベル
  # 参考: https://docs.aws.amazon.com/config/latest/developerguide/sagemaker-domain-in-vpc.html
  app_network_access_type = "PublicInternetOnly"

  # app_security_group_management (Optional)
  # 設定内容: VPCOnly モードでアプリ間通信に必要なセキュリティグループを
  #           作成・管理するエンティティを指定します。
  # 設定可能な値:
  #   - "Service": SageMaker サービスがセキュリティグループを管理
  #   - "Customer": ユーザーがセキュリティグループを管理
  # 注意: app_network_access_type が "VpcOnly" の場合に設定が必要
  app_security_group_management = "Service"

  #-------------------------------------------------------------
  # 暗号化設定
  #-------------------------------------------------------------

  # kms_key_id (Optional)
  # 設定内容: ドメインに紐付く EFS ボリュームの暗号化に使用する
  #           AWS KMS カスタマーマネージド CMK を指定します。
  # 設定可能な値: 有効な KMS キー ID または ARN
  # 省略時: AWS マネージドキーで暗号化されます
  kms_key_id = null

  #-------------------------------------------------------------
  # タグ伝播設定
  #-------------------------------------------------------------

  # tag_propagation (Optional)
  # 設定内容: ドメインでカスタムタグ伝播をサポートするかを指定します。
  # 設定可能な値:
  #   - "ENABLED": タグ伝播を有効化
  #   - "DISABLED" (デフォルト): タグ伝播を無効化
  tag_propagation = "DISABLED"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効な AWS リージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # データ保持ポリシー設定
  #-------------------------------------------------------------

  # retention_policy (Optional)
  # 設定内容: ドメイン削除後にリソースを保持するかどうかのポリシーを指定します。
  # 省略時: 全リソースが保持されます（Retain）
  retention_policy {

    # home_efs_file_system (Optional)
    # 設定内容: Amazon EFS ボリュームに保存されたデータの保持ポリシーを指定します。
    # 設定可能な値:
    #   - "Retain" (デフォルト): ドメイン削除後もデータを保持
    #   - "Delete": ドメイン削除時にデータも削除
    home_efs_file_system = "Retain"
  }

  #-------------------------------------------------------------
  # デフォルトユーザー設定
  #-------------------------------------------------------------

  # default_user_settings (Required)
  # 設定内容: ドメイン内のユーザープロファイルのデフォルト設定を指定します。
  # 注意: 最低1つ、最大1つのブロックを指定する必要があります
  default_user_settings {

    # execution_role (Required)
    # 設定内容: ユーザーの実行ロール ARN を指定します。
    # 設定可能な値: 有効な IAM ロール ARN。sagemaker.amazonaws.com をサービスプリンシパルとした信頼関係が必要
    execution_role = "arn:aws:iam::123456789012:role/sagemaker-execution-role"

    # security_groups (Optional)
    # 設定内容: ユーザーに紐付けるセキュリティグループ ID のリストを指定します。
    # 設定可能な値: 有効なセキュリティグループ ID のセット
    security_groups = ["sg-12345678"]

    # auto_mount_home_efs (Optional)
    # 設定内容: ユーザープロファイルに対して EFS ボリュームの自動マウントをサポートするかを指定します。
    # 設定可能な値:
    #   - "Enabled": 自動マウントを有効化
    #   - "Disabled": 自動マウントを無効化
    #   - "DefaultAsDomain": ドメインデフォルトを使用（ユーザープロファイルのみ）
    # 省略時: ドメインのデフォルト値を使用
    auto_mount_home_efs = "Enabled"

    # default_landing_uri (Optional)
    # 設定内容: ドメインにアクセスした際にユーザーが誘導されるデフォルト画面を指定します。
    # 設定可能な値:
    #   - "studio::": Studio をデフォルト画面として使用（studio_web_portal が ENABLED の場合のみ）
    #   - "app:JupyterServer:": Studio Classic をデフォルト画面として使用
    # 省略時: ドメインのデフォルト設定を使用
    default_landing_uri = "studio::"

    # studio_web_portal (Optional)
    # 設定内容: ユーザーが Studio にアクセスできるかどうかを指定します。
    # 設定可能な値:
    #   - "ENABLED": Studio へのアクセスを許可
    #   - "DISABLED": Studio へのアクセスを無効化（デフォルト体験が Studio の場合もアクセス不可）
    # 省略時: ドメインのデフォルト値を使用
    studio_web_portal = "ENABLED"

    #-------------------------------------------------------------
    # 共有設定
    #-------------------------------------------------------------

    # sharing_settings (Optional)
    # 設定内容: ノートブックの共有設定ブロックを指定します。
    sharing_settings {

      # notebook_output_option (Optional)
      # 設定内容: ノートブック共有時にセルの出力を含めるかを指定します。
      # 設定可能な値:
      #   - "Allowed": ノートブックセルの出力を含めることを許可
      #   - "Disabled" (デフォルト): ノートブックセルの出力を含めない
      notebook_output_option = "Disabled"

      # s3_output_path (Optional)
      # 設定内容: notebook_output_option が Allowed の場合に、
      #           ノートブックセル出力を保存する Amazon S3 バケットを指定します。
      # 設定可能な値: 有効な S3 パス（s3://bucket-name/prefix 形式）
      s3_output_path = null

      # s3_kms_key_id (Optional)
      # 設定内容: notebook_output_option が Allowed の場合に、
      #           Amazon S3 バケット内のノートブックセル出力を暗号化する KMS キー ID を指定します。
      # 設定可能な値: 有効な KMS キー ID または ARN
      s3_kms_key_id = null
    }

    #-------------------------------------------------------------
    # Canvas アプリ設定
    #-------------------------------------------------------------

    # canvas_app_settings (Optional)
    # 設定内容: SageMaker Canvas アプリケーションの設定ブロックを指定します。
    # 関連機能: Amazon SageMaker Canvas
    #   コードなしで ML モデルの構築・デプロイができるビジュアル UI ツール。
    canvas_app_settings {

      # direct_deploy_settings (Optional)
      # 設定内容: SageMaker Canvas アプリケーションのモデルデプロイ権限設定ブロックを指定します。
      direct_deploy_settings {

        # status (Optional)
        # 設定内容: Canvas アプリケーションでモデルデプロイ権限を有効化するかを指定します。
        # 設定可能な値:
        #   - "ENABLED": モデルデプロイを許可
        #   - "DISABLED": モデルデプロイを無効化
        status = "DISABLED"
      }

      # emr_serverless_settings (Optional)
      # 設定内容: SageMaker Canvas アプリケーションで Amazon EMR Serverless ジョブを
      #           実行するための設定ブロックを指定します。
      emr_serverless_settings {

        # execution_role_arn (Optional)
        # 設定内容: SageMaker Canvas で Amazon EMR Serverless ジョブを実行するために
        #           引き受ける AWS IAM ロールの ARN を指定します。
        # 設定可能な値: 有効な IAM ロール ARN
        execution_role_arn = null

        # status (Optional)
        # 設定内容: Canvas アプリケーションで Amazon EMR Serverless ジョブ機能を
        #           有効化するかを指定します。
        # 設定可能な値:
        #   - "ENABLED": EMR Serverless を有効化
        #   - "DISABLED": EMR Serverless を無効化
        status = "DISABLED"
      }

      # generative_ai_settings (Optional)
      # 設定内容: Canvas アプリケーションの生成 AI 設定ブロックを指定します。
      generative_ai_settings {

        # amazon_bedrock_role_arn (Optional)
        # 設定内容: Amazon Bedrock にアクセスするための IAM ロール ARN を指定します。
        # 設定可能な値: 有効な IAM ロール ARN
        amazon_bedrock_role_arn = null
      }

      # identity_provider_oauth_settings (Optional)
      # 設定内容: OAuth を使用した外部データソースへの接続設定ブロックを指定します。
      # 注意: 最大20件まで指定可能
      identity_provider_oauth_settings {

        # secret_arn (Required)
        # 設定内容: クライアント ID・シークレット、認可 URL、トークン URL など
        #           ID プロバイダーの認証情報を保存する AWS Secrets Manager シークレットの ARN を指定します。
        # 設定可能な値: 有効な AWS Secrets Manager シークレット ARN
        secret_arn = "arn:aws:secretsmanager:ap-northeast-1:123456789012:secret:example"

        # data_source_name (Optional)
        # 設定内容: 接続するデータソースの名前を指定します。
        # 設定可能な値:
        #   - "SalesforceGenie": Salesforce Data Cloud
        #   - "Snowflake": Snowflake
        data_source_name = "Snowflake"

        # status (Optional)
        # 設定内容: Canvas アプリケーションで OAuth によるデータソース接続を
        #           有効化するかを指定します。
        # 設定可能な値:
        #   - "ENABLED": OAuth を有効化
        #   - "DISABLED": OAuth を無効化
        status = "ENABLED"
      }

      # kendra_settings (Optional)
      # 設定内容: ドキュメントクエリ機能の設定ブロックを指定します。
      kendra_settings {

        # status (Optional)
        # 設定内容: Canvas アプリケーションでドキュメントクエリ機能を
        #           有効化するかを指定します。
        # 設定可能な値:
        #   - "ENABLED": Amazon Kendra を有効化
        #   - "DISABLED": Amazon Kendra を無効化
        status = "DISABLED"
      }

      # model_register_settings (Optional)
      # 設定内容: SageMaker Canvas アプリケーションのモデルレジストリ設定ブロックを指定します。
      model_register_settings {

        # cross_account_model_register_role_arn (Optional)
        # 設定内容: SageMaker AI モデルレジストリアカウントの ARN を指定します。
        #           別の SageMaker Canvas AWS アカウントが作成したモデルバージョンを
        #           登録する場合にのみ必要です。
        # 設定可能な値: 有効な IAM ロール ARN
        cross_account_model_register_role_arn = null

        # status (Optional)
        # 設定内容: Canvas アプリケーションのモデルレジストリ統合を
        #           有効化するかを指定します。
        # 設定可能な値:
        #   - "ENABLED": モデルレジストリを有効化
        #   - "DISABLED": モデルレジストリを無効化
        status = "ENABLED"
      }

      # time_series_forecasting_settings (Optional)
      # 設定内容: Canvas アプリの時系列予測設定ブロックを指定します。
      time_series_forecasting_settings {

        # amazon_forecast_role_arn (Optional)
        # 設定内容: 時系列予測のために Amazon Forecast へ渡す IAM ロールの ARN を指定します。
        #           省略時は UserProfile または Domain の実行ロールを使用します。
        # 設定可能な値: 有効な IAM ロール ARN
        # 参考: https://docs.aws.amazon.com/sagemaker/latest/dg/security-iam-awsmanpol-canvas.html#security-iam-awsmanpol-AmazonSageMakerCanvasForecastAccess
        amazon_forecast_role_arn = null

        # status (Optional)
        # 設定内容: Canvas アプリで時系列予測機能を有効化するかを指定します。
        # 設定可能な値:
        #   - "ENABLED": 時系列予測を有効化
        #   - "DISABLED": 時系列予測を無効化
        status = "ENABLED"
      }

      # workspace_settings (Optional)
      # 設定内容: SageMaker Canvas アプリケーションのワークスペース設定ブロックを指定します。
      workspace_settings {

        # s3_artifact_path (Optional)
        # 設定内容: Canvas が生成するアーティファクトを保存する Amazon S3 バケットを指定します。
        # 設定可能な値: 有効な S3 パス（s3://bucket-name/prefix 形式）
        # 注意: S3 ロケーションを更新すると既存の設定に影響し、ユーザーは既存のアーティファクトへのアクセスを失います
        s3_artifact_path = null

        # s3_kms_key_id (Optional)
        # 設定内容: Amazon S3 バケット内の Canvas 生成アーティファクトを暗号化する
        #           KMS 暗号化キー ID を指定します。
        # 設定可能な値: 有効な KMS キー ID または ARN
        s3_kms_key_id = null
      }
    }

    #-------------------------------------------------------------
    # Code Editor アプリ設定
    #-------------------------------------------------------------

    # code_editor_app_settings (Optional)
    # 設定内容: Code Editor アプリケーションの設定ブロックを指定します。
    # 関連機能: SageMaker Code Editor
    #   Visual Studio Code ベースの統合開発環境。
    code_editor_app_settings {

      # built_in_lifecycle_config_arn (Optional)
      # 設定内容: デフォルトのライフサイクル設定の前に実行されるライフサイクル設定を指定します。
      #           デフォルトのライフサイクル設定への変更を上書きできます。
      # 設定可能な値: 有効なライフサイクル設定 ARN
      built_in_lifecycle_config_arn = null

      # lifecycle_config_arns (Optional)
      # 設定内容: ライフサイクル設定の ARN のセットを指定します。
      # 設定可能な値: 有効なライフサイクル設定 ARN のセット
      lifecycle_config_arns = []

      # app_lifecycle_management (Optional)
      # 設定内容: Code Editor アプリケーションのアイドルシャットダウン設定ブロックを指定します。
      app_lifecycle_management {

        # idle_settings (Optional)
        # 設定内容: Studio アプリケーションのアイドルシャットダウンに関する設定ブロックを指定します。
        idle_settings {

          # lifecycle_management (Optional)
          # 設定内容: アプリケーションのアイドルシャットダウンを有効化するかを指定します。
          # 設定可能な値:
          #   - "ENABLED": アイドルシャットダウンを有効化
          #   - "DISABLED": アイドルシャットダウンを無効化
          lifecycle_management = "ENABLED"

          # idle_timeout_in_minutes (Optional)
          # 設定内容: アプリケーションがアイドル状態になってからシャットダウンするまでの
          #           待機時間（分）を指定します。
          # 設定可能な値: 60〜525600 の整数
          idle_timeout_in_minutes = 60

          # min_idle_timeout_in_minutes (Optional)
          # 設定内容: ユーザーがカスタムアイドルシャットダウンに設定できる最小値（分）を指定します。
          # 設定可能な値: 60〜525600 の整数
          min_idle_timeout_in_minutes = 60

          # max_idle_timeout_in_minutes (Optional)
          # 設定内容: ユーザーがカスタムアイドルシャットダウンに設定できる最大値（分）を指定します。
          # 設定可能な値: 60〜525600 の整数
          max_idle_timeout_in_minutes = 120
        }
      }

      # custom_image (Optional)
      # 設定内容: CodeEditor アプリとして実行するように設定されたカスタム SageMaker イメージの
      #           リストを指定します。最大200件まで指定可能。
      custom_image {

        # app_image_config_name (Required)
        # 設定内容: App Image Config の名前を指定します。
        # 設定可能な値: 有効な AppImageConfig 名
        app_image_config_name = "example-app-image-config"

        # image_name (Required)
        # 設定内容: カスタムイメージの名前を指定します。
        # 設定可能な値: 有効な SageMaker イメージ名
        image_name = "example-custom-image"

        # image_version_number (Optional)
        # 設定内容: カスタムイメージのバージョン番号を指定します。
        # 設定可能な値: 正の整数
        # 省略時: 最新バージョンを使用
        image_version_number = 1
      }

      # default_resource_spec (Optional)
      # 設定内容: インスタンスに作成されたデフォルトのインスタンスタイプと
      #           SageMaker イメージの ARN を指定します。
      default_resource_spec {

        # instance_type (Optional)
        # 設定内容: イメージバージョンを実行するインスタンスタイプを指定します。
        # 設定可能な値: SageMaker インスタンスタイプ（例: ml.t3.medium, ml.g4dn.xlarge）
        # 参考: https://docs.aws.amazon.com/sagemaker/latest/dg/notebooks-available-instance-types.html
        instance_type = "ml.t3.medium"

        # sagemaker_image_arn (Optional)
        # 設定内容: イメージバージョンが属する SageMaker イメージの ARN を指定します。
        # 設定可能な値: 有効な SageMaker イメージ ARN
        sagemaker_image_arn = null

        # sagemaker_image_version_arn (Optional)
        # 設定内容: インスタンスに作成されたイメージバージョンの ARN を指定します。
        # 設定可能な値: 有効な SageMaker イメージバージョン ARN
        sagemaker_image_version_arn = null

        # sagemaker_image_version_alias (Optional)
        # 設定内容: SageMaker イメージバージョンのエイリアスを指定します。
        # 設定可能な値: 有効なイメージバージョンエイリアス文字列
        sagemaker_image_version_alias = null

        # lifecycle_config_arn (Optional)
        # 設定内容: リソースに紐付けられたライフサイクル設定の ARN を指定します。
        # 設定可能な値: 有効なライフサイクル設定 ARN
        lifecycle_config_arn = null
      }
    }

    #-------------------------------------------------------------
    # カスタムファイルシステム設定
    #-------------------------------------------------------------

    # custom_file_system_config (Optional)
    # 設定内容: ユーザープロファイルにカスタムファイルシステムを割り当てる設定ブロックを指定します。
    #           許可されたユーザーは Amazon SageMaker Studio でこのファイルシステムにアクセスできます。
    custom_file_system_config {

      # efs_file_system_config (Optional)
      # 設定内容: EFS ファイルシステムの設定ブロックを指定します。最大1件まで指定可能。
      efs_file_system_config {

        # file_system_id (Required)
        # 設定内容: Amazon EFS ファイルシステムの ID を指定します。
        # 設定可能な値: 有効な Amazon EFS ファイルシステム ID
        file_system_id = "fs-12345678"

        # file_system_path (Required)
        # 設定内容: Amazon SageMaker Studio でアクセス可能なファイルシステムディレクトリの
        #           パスを指定します。許可されたユーザーはこのディレクトリ以下のみアクセス可能です。
        # 設定可能な値: 有効なファイルシステムパス文字列
        file_system_path = "/home"
      }
    }

    # custom_posix_user_config (Optional)
    # 設定内容: ファイルシステム操作に使用する POSIX ID の詳細設定ブロックを指定します。
    # 注意: 最大1件まで指定可能
    custom_posix_user_config {

      # uid (Required)
      # 設定内容: POSIX ユーザー ID を指定します。
      # 設定可能な値: 正の整数
      uid = 1000

      # gid (Required)
      # 設定内容: POSIX グループ ID を指定します。
      # 設定可能な値: 正の整数
      gid = 1001
    }

    #-------------------------------------------------------------
    # JupyterLab アプリ設定
    #-------------------------------------------------------------

    # jupyter_lab_app_settings (Optional)
    # 設定内容: JupyterLab アプリケーションの設定ブロックを指定します。
    # 注意: 最大1件まで指定可能
    jupyter_lab_app_settings {

      # built_in_lifecycle_config_arn (Optional)
      # 設定内容: デフォルトのライフサイクル設定の前に実行されるライフサイクル設定を指定します。
      # 設定可能な値: 有効なライフサイクル設定 ARN
      built_in_lifecycle_config_arn = null

      # lifecycle_config_arns (Optional)
      # 設定内容: ライフサイクル設定の ARN のセットを指定します。
      # 設定可能な値: 有効なライフサイクル設定 ARN のセット
      lifecycle_config_arns = []

      # app_lifecycle_management (Optional)
      # 設定内容: JupyterLab アプリケーションのアイドルシャットダウン設定ブロックを指定します。
      app_lifecycle_management {

        # idle_settings (Optional)
        # 設定内容: Studio アプリケーションのアイドルシャットダウンに関する設定ブロックを指定します。
        idle_settings {

          # lifecycle_management (Optional)
          # 設定内容: アプリケーションのアイドルシャットダウンを有効化するかを指定します。
          # 設定可能な値:
          #   - "ENABLED": アイドルシャットダウンを有効化
          #   - "DISABLED": アイドルシャットダウンを無効化
          lifecycle_management = "ENABLED"

          # idle_timeout_in_minutes (Optional)
          # 設定内容: アプリケーションがアイドル状態になってからシャットダウンするまでの
          #           待機時間（分）を指定します。
          # 設定可能な値: 60〜525600 の整数
          idle_timeout_in_minutes = 60

          # min_idle_timeout_in_minutes (Optional)
          # 設定内容: ユーザーが設定できるカスタムアイドルシャットダウンの最小値（分）を指定します。
          # 設定可能な値: 60〜525600 の整数
          min_idle_timeout_in_minutes = 60

          # max_idle_timeout_in_minutes (Optional)
          # 設定内容: ユーザーが設定できるカスタムアイドルシャットダウンの最大値（分）を指定します。
          # 設定可能な値: 60〜525600 の整数
          max_idle_timeout_in_minutes = 120
        }
      }

      # code_repository (Optional)
      # 設定内容: JupyterServer アプリケーションでクローン用に自動表示する
      #           Git リポジトリのリストを指定します。最大10件まで指定可能。
      code_repository {

        # repository_url (Required)
        # 設定内容: Git リポジトリの URL を指定します。
        # 設定可能な値: 有効な Git リポジトリ URL
        repository_url = "https://github.com/example/repo.git"
      }

      # custom_image (Optional)
      # 設定内容: JupyterLab アプリとして実行するように設定されたカスタム SageMaker イメージの
      #           リストを指定します。最大200件まで指定可能。
      custom_image {

        # app_image_config_name (Required)
        # 設定内容: App Image Config の名前を指定します。
        # 設定可能な値: 有効な AppImageConfig 名
        app_image_config_name = "example-app-image-config"

        # image_name (Required)
        # 設定内容: カスタムイメージの名前を指定します。
        # 設定可能な値: 有効な SageMaker イメージ名
        image_name = "example-custom-image"

        # image_version_number (Optional)
        # 設定内容: カスタムイメージのバージョン番号を指定します。
        # 設定可能な値: 正の整数
        # 省略時: 最新バージョンを使用
        image_version_number = 1
      }

      # default_resource_spec (Optional)
      # 設定内容: インスタンスに作成されたデフォルトのインスタンスタイプと
      #           SageMaker イメージの ARN を指定します。
      default_resource_spec {

        # instance_type (Optional)
        # 設定内容: イメージバージョンを実行するインスタンスタイプを指定します。
        # 設定可能な値: SageMaker インスタンスタイプ（例: ml.t3.medium, ml.g4dn.xlarge）
        instance_type = "ml.t3.medium"

        # sagemaker_image_arn (Optional)
        # 設定内容: イメージバージョンが属する SageMaker イメージの ARN を指定します。
        # 設定可能な値: 有効な SageMaker イメージ ARN
        sagemaker_image_arn = null

        # sagemaker_image_version_arn (Optional)
        # 設定内容: インスタンスに作成されたイメージバージョンの ARN を指定します。
        # 設定可能な値: 有効な SageMaker イメージバージョン ARN
        sagemaker_image_version_arn = null

        # sagemaker_image_version_alias (Optional)
        # 設定内容: SageMaker イメージバージョンのエイリアスを指定します。
        # 設定可能な値: 有効なイメージバージョンエイリアス文字列
        sagemaker_image_version_alias = null

        # lifecycle_config_arn (Optional)
        # 設定内容: リソースに紐付けられたライフサイクル設定の ARN を指定します。
        # 設定可能な値: 有効なライフサイクル設定 ARN
        lifecycle_config_arn = null
      }

      # emr_settings (Optional)
      # 設定内容: Amazon EMR クラスターや EMR Serverless アプリケーションの
      #           実行に必要なリソースを管理・アクセスするための IAM ロールを設定するブロックを指定します。
      emr_settings {

        # assumable_role_arns (Optional)
        # 設定内容: SageMaker AI の実行ロールが引き受けられる IAM ロールの ARN の配列を指定します。
        #           Amazon EMR クラスターまたは EMR Serverless アプリケーションに関連する
        #           操作（一覧表示、接続、終了など）を実行するために使用します。
        # 設定可能な値: 有効な IAM ロール ARN のセット
        assumable_role_arns = []

        # execution_role_arns (Optional)
        # 設定内容: Amazon EMR クラスターインスタンスまたはジョブ実行環境が
        #           他の AWS サービスやリソースにアクセスするために使用する IAM ロールの ARN の配列を指定します。
        # 設定可能な値: 有効な IAM ロール ARN のセット
        execution_role_arns = []
      }
    }

    #-------------------------------------------------------------
    # Jupyter Server アプリ設定
    #-------------------------------------------------------------

    # jupyter_server_app_settings (Optional)
    # 設定内容: Jupyter Server のアプリ設定ブロックを指定します。
    # 注意: 最大1件まで指定可能
    jupyter_server_app_settings {

      # lifecycle_config_arns (Optional)
      # 設定内容: ライフサイクル設定の ARN のセットを指定します。
      # 設定可能な値: 有効なライフサイクル設定 ARN のセット
      lifecycle_config_arns = []

      # code_repository (Optional)
      # 設定内容: JupyterServer アプリケーションでクローン用に自動表示する
      #           Git リポジトリのリストを指定します。最大10件まで指定可能。
      code_repository {

        # repository_url (Required)
        # 設定内容: Git リポジトリの URL を指定します。
        # 設定可能な値: 有効な Git リポジトリ URL
        repository_url = "https://github.com/example/repo.git"
      }

      # default_resource_spec (Optional)
      # 設定内容: インスタンスに作成されたデフォルトのインスタンスタイプと
      #           SageMaker イメージの ARN を指定します。
      default_resource_spec {

        # instance_type (Optional)
        # 設定内容: イメージバージョンを実行するインスタンスタイプを指定します。
        # 設定可能な値: SageMaker インスタンスタイプ（例: ml.t3.medium, ml.g4dn.xlarge）
        instance_type = "ml.t3.medium"

        # sagemaker_image_arn (Optional)
        # 設定内容: イメージバージョンが属する SageMaker イメージの ARN を指定します。
        # 設定可能な値: 有効な SageMaker イメージ ARN
        sagemaker_image_arn = null

        # sagemaker_image_version_arn (Optional)
        # 設定内容: インスタンスに作成されたイメージバージョンの ARN を指定します。
        # 設定可能な値: 有効な SageMaker イメージバージョン ARN
        sagemaker_image_version_arn = null

        # sagemaker_image_version_alias (Optional)
        # 設定内容: SageMaker イメージバージョンのエイリアスを指定します。
        # 設定可能な値: 有効なイメージバージョンエイリアス文字列
        sagemaker_image_version_alias = null

        # lifecycle_config_arn (Optional)
        # 設定内容: リソースに紐付けられたライフサイクル設定の ARN を指定します。
        # 設定可能な値: 有効なライフサイクル設定 ARN
        lifecycle_config_arn = null
      }
    }

    #-------------------------------------------------------------
    # Kernel Gateway アプリ設定
    #-------------------------------------------------------------

    # kernel_gateway_app_settings (Optional)
    # 設定内容: カーネルゲートウェイアプリの設定ブロックを指定します。
    # 注意: 最大1件まで指定可能
    kernel_gateway_app_settings {

      # lifecycle_config_arns (Optional)
      # 設定内容: ライフサイクル設定の ARN のセットを指定します。
      # 設定可能な値: 有効なライフサイクル設定 ARN のセット
      lifecycle_config_arns = []

      # custom_image (Optional)
      # 設定内容: KernelGateway アプリとして実行するように設定されたカスタム SageMaker イメージの
      #           リストを指定します。最大200件まで指定可能。
      custom_image {

        # app_image_config_name (Required)
        # 設定内容: App Image Config の名前を指定します。
        # 設定可能な値: 有効な AppImageConfig 名
        app_image_config_name = "example-app-image-config"

        # image_name (Required)
        # 設定内容: カスタムイメージの名前を指定します。
        # 設定可能な値: 有効な SageMaker イメージ名
        image_name = "example-custom-image"

        # image_version_number (Optional)
        # 設定内容: カスタムイメージのバージョン番号を指定します。
        # 設定可能な値: 正の整数
        # 省略時: 最新バージョンを使用
        image_version_number = 1
      }

      # default_resource_spec (Optional)
      # 設定内容: インスタンスに作成されたデフォルトのインスタンスタイプと
      #           SageMaker イメージの ARN を指定します。
      default_resource_spec {

        # instance_type (Optional)
        # 設定内容: イメージバージョンを実行するインスタンスタイプを指定します。
        # 設定可能な値: SageMaker インスタンスタイプ（例: ml.t3.medium, ml.g4dn.xlarge）
        instance_type = "ml.t3.medium"

        # sagemaker_image_arn (Optional)
        # 設定内容: イメージバージョンが属する SageMaker イメージの ARN を指定します。
        # 設定可能な値: 有効な SageMaker イメージ ARN
        sagemaker_image_arn = null

        # sagemaker_image_version_arn (Optional)
        # 設定内容: インスタンスに作成されたイメージバージョンの ARN を指定します。
        # 設定可能な値: 有効な SageMaker イメージバージョン ARN
        sagemaker_image_version_arn = null

        # sagemaker_image_version_alias (Optional)
        # 設定内容: SageMaker イメージバージョンのエイリアスを指定します。
        # 設定可能な値: 有効なイメージバージョンエイリアス文字列
        sagemaker_image_version_alias = null

        # lifecycle_config_arn (Optional)
        # 設定内容: リソースに紐付けられたライフサイクル設定の ARN を指定します。
        # 設定可能な値: 有効なライフサイクル設定 ARN
        lifecycle_config_arn = null
      }
    }

    #-------------------------------------------------------------
    # R Session アプリ設定
    #-------------------------------------------------------------

    # r_session_app_settings (Optional)
    # 設定内容: RSession アプリの設定ブロックを指定します。
    # 注意: 最大1件まで指定可能
    r_session_app_settings {

      # custom_image (Optional)
      # 設定内容: RSession アプリとして実行するように設定されたカスタム SageMaker イメージの
      #           リストを指定します。最大200件まで指定可能。
      custom_image {

        # app_image_config_name (Required)
        # 設定内容: App Image Config の名前を指定します。
        # 設定可能な値: 有効な AppImageConfig 名
        app_image_config_name = "example-app-image-config"

        # image_name (Required)
        # 設定内容: カスタムイメージの名前を指定します。
        # 設定可能な値: 有効な SageMaker イメージ名
        image_name = "example-custom-image"

        # image_version_number (Optional)
        # 設定内容: カスタムイメージのバージョン番号を指定します。
        # 設定可能な値: 正の整数
        # 省略時: 最新バージョンを使用
        image_version_number = 1
      }

      # default_resource_spec (Optional)
      # 設定内容: インスタンスに作成されたデフォルトのインスタンスタイプと
      #           SageMaker イメージの ARN を指定します。
      default_resource_spec {

        # instance_type (Optional)
        # 設定内容: イメージバージョンを実行するインスタンスタイプを指定します。
        # 設定可能な値: SageMaker インスタンスタイプ（例: ml.t3.medium, ml.g4dn.xlarge）
        instance_type = "ml.t3.medium"

        # sagemaker_image_arn (Optional)
        # 設定内容: イメージバージョンが属する SageMaker イメージの ARN を指定します。
        # 設定可能な値: 有効な SageMaker イメージ ARN
        sagemaker_image_arn = null

        # sagemaker_image_version_arn (Optional)
        # 設定内容: インスタンスに作成されたイメージバージョンの ARN を指定します。
        # 設定可能な値: 有効な SageMaker イメージバージョン ARN
        sagemaker_image_version_arn = null

        # sagemaker_image_version_alias (Optional)
        # 設定内容: SageMaker イメージバージョンのエイリアスを指定します。
        # 設定可能な値: 有効なイメージバージョンエイリアス文字列
        sagemaker_image_version_alias = null

        # lifecycle_config_arn (Optional)
        # 設定内容: リソースに紐付けられたライフサイクル設定の ARN を指定します。
        # 設定可能な値: 有効なライフサイクル設定 ARN
        lifecycle_config_arn = null
      }
    }

    #-------------------------------------------------------------
    # RStudio Server Pro アプリ設定
    #-------------------------------------------------------------

    # r_studio_server_pro_app_settings (Optional)
    # 設定内容: RStudioServerPro アプリとのユーザーインタラクションを設定するブロックを指定します。
    # 注意: 最大1件まで指定可能
    r_studio_server_pro_app_settings {

      # access_status (Optional)
      # 設定内容: 現在のユーザーが RStudioServerPro アプリへのアクセス権を持つかを指定します。
      # 設定可能な値:
      #   - "ENABLED": アクセスを許可
      #   - "DISABLED": アクセスを無効化
      access_status = "ENABLED"

      # user_group (Optional)
      # 設定内容: RStudioServerPro アプリ内でユーザーが持つ権限レベルを指定します。
      # 設定可能な値:
      #   - "R_STUDIO_USER" (デフォルト): 標準ユーザー権限
      #   - "R_STUDIO_ADMIN": RStudio 管理ダッシュボードへのアクセス権を持つ管理者
      user_group = "R_STUDIO_USER"
    }

    #-------------------------------------------------------------
    # Space ストレージ設定
    #-------------------------------------------------------------

    # space_storage_settings (Optional)
    # 設定内容: プライベートスペースのデフォルトストレージ設定ブロックを指定します。
    # 注意: 最大1件まで指定可能
    space_storage_settings {

      # default_ebs_storage_settings (Optional)
      # 設定内容: プライベートスペースのデフォルト EBS ストレージ設定ブロックを指定します。
      # 注意: 最大1件まで指定可能
      default_ebs_storage_settings {

        # default_ebs_volume_size_in_gb (Required)
        # 設定内容: プライベートスペースの EBS ストレージボリュームのデフォルトサイズ（GB）を指定します。
        # 設定可能な値: 正の整数
        default_ebs_volume_size_in_gb = 10

        # maximum_ebs_volume_size_in_gb (Required)
        # 設定内容: プライベートスペースの EBS ストレージボリュームの最大サイズ（GB）を指定します。
        # 設定可能な値: 正の整数
        maximum_ebs_volume_size_in_gb = 100
      }
    }

    #-------------------------------------------------------------
    # Studio Web Portal 設定
    #-------------------------------------------------------------

    # studio_web_portal_settings (Optional)
    # 設定内容: Studio Web Portal の表示設定ブロックを指定します。
    # 注意: 最大1件まで指定可能
    studio_web_portal_settings {

      # hidden_app_types (Optional)
      # 設定内容: Studio の左ナビゲーションペインから非表示にする対応アプリケーションを指定します。
      # 設定可能な値: 非表示にするアプリケーションタイプのセット
      hidden_app_types = []

      # hidden_instance_types (Optional)
      # 設定内容: Studio ユーザーインターフェイスから非表示にするインスタンスタイプを指定します。
      # 設定可能な値: 非表示にするインスタンスタイプのセット
      hidden_instance_types = []

      # hidden_ml_tools (Optional)
      # 設定内容: Studio 左ナビゲーションペインから非表示にする ML ツールを指定します。
      # 設定可能な値: 非表示にする ML ツールのセット
      hidden_ml_tools = []
    }

    #-------------------------------------------------------------
    # TensorBoard アプリ設定
    #-------------------------------------------------------------

    # tensor_board_app_settings (Optional)
    # 設定内容: TensorBoard アプリの設定ブロックを指定します。
    # 注意: 最大1件まで指定可能
    tensor_board_app_settings {

      # default_resource_spec (Optional)
      # 設定内容: インスタンスに作成されたデフォルトのインスタンスタイプと
      #           SageMaker イメージの ARN を指定します。
      default_resource_spec {

        # instance_type (Optional)
        # 設定内容: イメージバージョンを実行するインスタンスタイプを指定します。
        # 設定可能な値: SageMaker インスタンスタイプ（例: ml.t3.medium, ml.g4dn.xlarge）
        instance_type = "ml.t3.medium"

        # sagemaker_image_arn (Optional)
        # 設定内容: イメージバージョンが属する SageMaker イメージの ARN を指定します。
        # 設定可能な値: 有効な SageMaker イメージ ARN
        sagemaker_image_arn = null

        # sagemaker_image_version_arn (Optional)
        # 設定内容: インスタンスに作成されたイメージバージョンの ARN を指定します。
        # 設定可能な値: 有効な SageMaker イメージバージョン ARN
        sagemaker_image_version_arn = null

        # sagemaker_image_version_alias (Optional)
        # 設定内容: SageMaker イメージバージョンのエイリアスを指定します。
        # 設定可能な値: 有効なイメージバージョンエイリアス文字列
        sagemaker_image_version_alias = null

        # lifecycle_config_arn (Optional)
        # 設定内容: リソースに紐付けられたライフサイクル設定の ARN を指定します。
        # 設定可能な値: 有効なライフサイクル設定 ARN
        lifecycle_config_arn = null
      }
    }
  }

  #-------------------------------------------------------------
  # デフォルトスペース設定
  #-------------------------------------------------------------

  # default_space_settings (Optional)
  # 設定内容: ドメイン内のスペースのデフォルト設定ブロックを指定します。
  # 注意: 最大1件まで指定可能
  default_space_settings {

    # execution_role (Required)
    # 設定内容: スペースの実行ロールを指定します。
    # 設定可能な値: 有効な IAM ロール ARN。sagemaker.amazonaws.com をサービスプリンシパルとした信頼関係が必要
    execution_role = "arn:aws:iam::123456789012:role/sagemaker-space-execution-role"

    # security_groups (Optional)
    # 設定内容: Amazon VPC でスペースが使用するセキュリティグループを指定します。
    # 設定可能な値: 有効なセキュリティグループ ID のセット
    security_groups = ["sg-12345678"]

    # custom_file_system_config (Optional)
    # 設定内容: ユーザープロファイルにカスタムファイルシステムを割り当てる設定ブロックを指定します。
    custom_file_system_config {

      # efs_file_system_config (Optional)
      # 設定内容: EFS ファイルシステムの設定ブロックを指定します。最大1件まで指定可能。
      efs_file_system_config {

        # file_system_id (Required)
        # 設定内容: Amazon EFS ファイルシステムの ID を指定します。
        # 設定可能な値: 有効な Amazon EFS ファイルシステム ID
        file_system_id = "fs-12345678"

        # file_system_path (Required)
        # 設定内容: Amazon SageMaker Studio でアクセス可能なファイルシステムディレクトリの
        #           パスを指定します。
        # 設定可能な値: 有効なファイルシステムパス文字列
        file_system_path = "/home"
      }
    }

    # custom_posix_user_config (Optional)
    # 設定内容: ファイルシステム操作に使用する POSIX ID の詳細設定ブロックを指定します。
    # 注意: 最大1件まで指定可能
    custom_posix_user_config {

      # uid (Required)
      # 設定内容: POSIX ユーザー ID を指定します。
      # 設定可能な値: 正の整数
      uid = 1000

      # gid (Required)
      # 設定内容: POSIX グループ ID を指定します。
      # 設定可能な値: 正の整数
      gid = 1001
    }

    # jupyter_lab_app_settings (Optional)
    # 設定内容: JupyterLab アプリケーションの設定ブロックを指定します。
    # 注意: 最大1件まで指定可能
    jupyter_lab_app_settings {

      # built_in_lifecycle_config_arn (Optional)
      # 設定内容: デフォルトのライフサイクル設定の前に実行されるライフサイクル設定を指定します。
      # 設定可能な値: 有効なライフサイクル設定 ARN
      built_in_lifecycle_config_arn = null

      # lifecycle_config_arns (Optional)
      # 設定内容: ライフサイクル設定の ARN のセットを指定します。
      # 設定可能な値: 有効なライフサイクル設定 ARN のセット
      lifecycle_config_arns = []

      # app_lifecycle_management (Optional)
      # 設定内容: JupyterLab アプリケーションのアイドルシャットダウン設定ブロックを指定します。
      app_lifecycle_management {

        # idle_settings (Optional)
        # 設定内容: Studio アプリケーションのアイドルシャットダウンに関する設定ブロックを指定します。
        idle_settings {

          # lifecycle_management (Optional)
          # 設定内容: アプリケーションのアイドルシャットダウンを有効化するかを指定します。
          # 設定可能な値:
          #   - "ENABLED": アイドルシャットダウンを有効化
          #   - "DISABLED": アイドルシャットダウンを無効化
          lifecycle_management = "ENABLED"

          # idle_timeout_in_minutes (Optional)
          # 設定内容: アプリケーションがアイドル状態になってからシャットダウンするまでの
          #           待機時間（分）を指定します。
          # 設定可能な値: 60〜525600 の整数
          idle_timeout_in_minutes = 60

          # min_idle_timeout_in_minutes (Optional)
          # 設定内容: ユーザーが設定できるカスタムアイドルシャットダウンの最小値（分）を指定します。
          # 設定可能な値: 60〜525600 の整数
          min_idle_timeout_in_minutes = 60

          # max_idle_timeout_in_minutes (Optional)
          # 設定内容: ユーザーが設定できるカスタムアイドルシャットダウンの最大値（分）を指定します。
          # 設定可能な値: 60〜525600 の整数
          max_idle_timeout_in_minutes = 120
        }
      }

      # code_repository (Optional)
      # 設定内容: JupyterServer アプリケーションでクローン用に自動表示する
      #           Git リポジトリのリストを指定します。最大10件まで指定可能。
      code_repository {

        # repository_url (Required)
        # 設定内容: Git リポジトリの URL を指定します。
        # 設定可能な値: 有効な Git リポジトリ URL
        repository_url = "https://github.com/example/repo.git"
      }

      # custom_image (Optional)
      # 設定内容: JupyterLab アプリとして実行するように設定されたカスタム SageMaker イメージの
      #           リストを指定します。最大200件まで指定可能。
      custom_image {

        # app_image_config_name (Required)
        # 設定内容: App Image Config の名前を指定します。
        # 設定可能な値: 有効な AppImageConfig 名
        app_image_config_name = "example-app-image-config"

        # image_name (Required)
        # 設定内容: カスタムイメージの名前を指定します。
        # 設定可能な値: 有効な SageMaker イメージ名
        image_name = "example-custom-image"

        # image_version_number (Optional)
        # 設定内容: カスタムイメージのバージョン番号を指定します。
        # 設定可能な値: 正の整数
        # 省略時: 最新バージョンを使用
        image_version_number = 1
      }

      # default_resource_spec (Optional)
      # 設定内容: インスタンスに作成されたデフォルトのインスタンスタイプと
      #           SageMaker イメージの ARN を指定します。
      default_resource_spec {

        # instance_type (Optional)
        # 設定内容: イメージバージョンを実行するインスタンスタイプを指定します。
        # 設定可能な値: SageMaker インスタンスタイプ（例: ml.t3.medium, ml.g4dn.xlarge）
        instance_type = "ml.t3.medium"

        # sagemaker_image_arn (Optional)
        # 設定内容: イメージバージョンが属する SageMaker イメージの ARN を指定します。
        # 設定可能な値: 有効な SageMaker イメージ ARN
        sagemaker_image_arn = null

        # sagemaker_image_version_arn (Optional)
        # 設定内容: インスタンスに作成されたイメージバージョンの ARN を指定します。
        # 設定可能な値: 有効な SageMaker イメージバージョン ARN
        sagemaker_image_version_arn = null

        # sagemaker_image_version_alias (Optional)
        # 設定内容: SageMaker イメージバージョンのエイリアスを指定します。
        # 設定可能な値: 有効なイメージバージョンエイリアス文字列
        sagemaker_image_version_alias = null

        # lifecycle_config_arn (Optional)
        # 設定内容: リソースに紐付けられたライフサイクル設定の ARN を指定します。
        # 設定可能な値: 有効なライフサイクル設定 ARN
        lifecycle_config_arn = null
      }

      # emr_settings (Optional)
      # 設定内容: Amazon EMR クラスターや EMR Serverless アプリケーションの
      #           実行に必要なリソースを管理・アクセスするための IAM ロールを設定するブロックを指定します。
      emr_settings {

        # assumable_role_arns (Optional)
        # 設定内容: SageMaker AI の実行ロールが引き受けられる IAM ロールの ARN の配列を指定します。
        # 設定可能な値: 有効な IAM ロール ARN のセット
        assumable_role_arns = []

        # execution_role_arns (Optional)
        # 設定内容: Amazon EMR クラスターインスタンスまたはジョブ実行環境が
        #           他の AWS サービスやリソースにアクセスするために使用する IAM ロールの ARN の配列を指定します。
        # 設定可能な値: 有効な IAM ロール ARN のセット
        execution_role_arns = []
      }
    }

    # jupyter_server_app_settings (Optional)
    # 設定内容: Jupyter Server のアプリ設定ブロックを指定します。
    # 注意: 最大1件まで指定可能
    jupyter_server_app_settings {

      # lifecycle_config_arns (Optional)
      # 設定内容: ライフサイクル設定の ARN のセットを指定します。
      # 設定可能な値: 有効なライフサイクル設定 ARN のセット
      lifecycle_config_arns = []

      # code_repository (Optional)
      # 設定内容: JupyterServer アプリケーションでクローン用に自動表示する
      #           Git リポジトリのリストを指定します。最大10件まで指定可能。
      code_repository {

        # repository_url (Required)
        # 設定内容: Git リポジトリの URL を指定します。
        # 設定可能な値: 有効な Git リポジトリ URL
        repository_url = "https://github.com/example/repo.git"
      }

      # default_resource_spec (Optional)
      # 設定内容: インスタンスに作成されたデフォルトのインスタンスタイプと
      #           SageMaker イメージの ARN を指定します。
      default_resource_spec {

        # instance_type (Optional)
        # 設定内容: イメージバージョンを実行するインスタンスタイプを指定します。
        # 設定可能な値: SageMaker インスタンスタイプ（例: ml.t3.medium, ml.g4dn.xlarge）
        instance_type = "ml.t3.medium"

        # sagemaker_image_arn (Optional)
        # 設定内容: イメージバージョンが属する SageMaker イメージの ARN を指定します。
        # 設定可能な値: 有効な SageMaker イメージ ARN
        sagemaker_image_arn = null

        # sagemaker_image_version_arn (Optional)
        # 設定内容: インスタンスに作成されたイメージバージョンの ARN を指定します。
        # 設定可能な値: 有効な SageMaker イメージバージョン ARN
        sagemaker_image_version_arn = null

        # sagemaker_image_version_alias (Optional)
        # 設定内容: SageMaker イメージバージョンのエイリアスを指定します。
        # 設定可能な値: 有効なイメージバージョンエイリアス文字列
        sagemaker_image_version_alias = null

        # lifecycle_config_arn (Optional)
        # 設定内容: リソースに紐付けられたライフサイクル設定の ARN を指定します。
        # 設定可能な値: 有効なライフサイクル設定 ARN
        lifecycle_config_arn = null
      }
    }

    # kernel_gateway_app_settings (Optional)
    # 設定内容: カーネルゲートウェイアプリの設定ブロックを指定します。
    # 注意: 最大1件まで指定可能
    kernel_gateway_app_settings {

      # lifecycle_config_arns (Optional)
      # 設定内容: ライフサイクル設定の ARN のセットを指定します。
      # 設定可能な値: 有効なライフサイクル設定 ARN のセット
      lifecycle_config_arns = []

      # custom_image (Optional)
      # 設定内容: KernelGateway アプリとして実行するように設定されたカスタム SageMaker イメージの
      #           リストを指定します。最大200件まで指定可能。
      custom_image {

        # app_image_config_name (Required)
        # 設定内容: App Image Config の名前を指定します。
        # 設定可能な値: 有効な AppImageConfig 名
        app_image_config_name = "example-app-image-config"

        # image_name (Required)
        # 設定内容: カスタムイメージの名前を指定します。
        # 設定可能な値: 有効な SageMaker イメージ名
        image_name = "example-custom-image"

        # image_version_number (Optional)
        # 設定内容: カスタムイメージのバージョン番号を指定します。
        # 設定可能な値: 正の整数
        # 省略時: 最新バージョンを使用
        image_version_number = 1
      }

      # default_resource_spec (Optional)
      # 設定内容: インスタンスに作成されたデフォルトのインスタンスタイプと
      #           SageMaker イメージの ARN を指定します。
      default_resource_spec {

        # instance_type (Optional)
        # 設定内容: イメージバージョンを実行するインスタンスタイプを指定します。
        # 設定可能な値: SageMaker インスタンスタイプ（例: ml.t3.medium, ml.g4dn.xlarge）
        instance_type = "ml.t3.medium"

        # sagemaker_image_arn (Optional)
        # 設定内容: イメージバージョンが属する SageMaker イメージの ARN を指定します。
        # 設定可能な値: 有効な SageMaker イメージ ARN
        sagemaker_image_arn = null

        # sagemaker_image_version_arn (Optional)
        # 設定内容: インスタンスに作成されたイメージバージョンの ARN を指定します。
        # 設定可能な値: 有効な SageMaker イメージバージョン ARN
        sagemaker_image_version_arn = null

        # sagemaker_image_version_alias (Optional)
        # 設定内容: SageMaker イメージバージョンのエイリアスを指定します。
        # 設定可能な値: 有効なイメージバージョンエイリアス文字列
        sagemaker_image_version_alias = null

        # lifecycle_config_arn (Optional)
        # 設定内容: リソースに紐付けられたライフサイクル設定の ARN を指定します。
        # 設定可能な値: 有効なライフサイクル設定 ARN
        lifecycle_config_arn = null
      }
    }

    # space_storage_settings (Optional)
    # 設定内容: プライベートスペースのストレージ設定ブロックを指定します。
    # 注意: 最大1件まで指定可能
    space_storage_settings {

      # default_ebs_storage_settings (Optional)
      # 設定内容: プライベートスペースのデフォルト EBS ストレージ設定ブロックを指定します。
      # 注意: 最大1件まで指定可能
      default_ebs_storage_settings {

        # default_ebs_volume_size_in_gb (Required)
        # 設定内容: プライベートスペースの EBS ストレージボリュームのデフォルトサイズ（GB）を指定します。
        # 設定可能な値: 正の整数
        default_ebs_volume_size_in_gb = 10

        # maximum_ebs_volume_size_in_gb (Required)
        # 設定内容: プライベートスペースの EBS ストレージボリュームの最大サイズ（GB）を指定します。
        # 設定可能な値: 正の整数
        maximum_ebs_volume_size_in_gb = 100
      }
    }
  }

  #-------------------------------------------------------------
  # ドメイン設定
  #-------------------------------------------------------------

  # domain_settings (Optional)
  # 設定内容: ドメインの詳細設定ブロックを指定します。
  # 注意: 最大1件まで指定可能
  domain_settings {

    # execution_role_identity_config (Optional)
    # 設定内容: SageMaker AI ユーザープロファイル名を sts:SourceIdentity キーとして
    #           実行ロールに紐付けるための設定を指定します。
    # 設定可能な値:
    #   - "USER_PROFILE_NAME": ユーザープロファイル名を SourceIdentity として使用
    #   - "DISABLED": SourceIdentity を使用しない
    # 参考: https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_temp_control-access_monitor.html
    execution_role_identity_config = "USER_PROFILE_NAME"

    # security_group_ids (Optional)
    # 設定内容: ドメインレベルアプリとユーザーアプリ間の通信に使用する
    #           Amazon VPC のセキュリティグループを指定します。
    # 設定可能な値: 有効なセキュリティグループ ID のセット
    security_group_ids = ["sg-12345678"]

    # docker_settings (Optional)
    # 設定内容: ドメインの Docker インタラクション設定ブロックを指定します。
    # 注意: 最大1件まで指定可能
    docker_settings {

      # enable_docker_access (Optional)
      # 設定内容: ドメインが Docker にアクセスできるかを指定します。
      # 設定可能な値:
      #   - "ENABLED": Docker アクセスを有効化
      #   - "DISABLED": Docker アクセスを無効化
      enable_docker_access = "ENABLED"

      # vpc_only_trusted_accounts (Optional)
      # 設定内容: ドメインを VPC のみモードで作成した場合に信頼する
      #           Amazon Web Services アカウントのリストを指定します。
      # 設定可能な値: 有効な AWS アカウント ID のセット
      vpc_only_trusted_accounts = []
    }

    # r_studio_server_pro_domain_settings (Optional)
    # 設定内容: RStudioServerPro ドメインレベルアプリを設定するブロックを指定します。
    # 注意: 最大1件まで指定可能
    r_studio_server_pro_domain_settings {

      # domain_execution_role_arn (Required)
      # 設定内容: RStudioServerPro ドメインレベルアプリの実行ロールの ARN を指定します。
      # 設定可能な値: 有効な IAM ロール ARN
      domain_execution_role_arn = "arn:aws:iam::123456789012:role/rstudio-domain-execution-role"

      # r_studio_connect_url (Optional)
      # 設定内容: RStudio Connect サーバーを指す URL を指定します。
      # 設定可能な値: 有効な URL 文字列
      r_studio_connect_url = null

      # r_studio_package_manager_url (Optional)
      # 設定内容: RStudio Package Manager サーバーを指す URL を指定します。
      # 設定可能な値: 有効な URL 文字列
      r_studio_package_manager_url = null

      # default_resource_spec (Optional)
      # 設定内容: インスタンスに作成されたデフォルトのインスタンスタイプと
      #           SageMaker イメージの ARN を指定します。
      default_resource_spec {

        # instance_type (Optional)
        # 設定内容: イメージバージョンを実行するインスタンスタイプを指定します。
        # 設定可能な値: SageMaker インスタンスタイプ（例: ml.t3.medium, ml.g4dn.xlarge）
        instance_type = "ml.t3.medium"

        # sagemaker_image_arn (Optional)
        # 設定内容: イメージバージョンが属する SageMaker イメージの ARN を指定します。
        # 設定可能な値: 有効な SageMaker イメージ ARN
        sagemaker_image_arn = null

        # sagemaker_image_version_arn (Optional)
        # 設定内容: インスタンスに作成されたイメージバージョンの ARN を指定します。
        # 設定可能な値: 有効な SageMaker イメージバージョン ARN
        sagemaker_image_version_arn = null

        # sagemaker_image_version_alias (Optional)
        # 設定内容: SageMaker イメージバージョンのエイリアスを指定します。
        # 設定可能な値: 有効なイメージバージョンエイリアス文字列
        sagemaker_image_version_alias = null

        # lifecycle_config_arn (Optional)
        # 設定内容: リソースに紐付けられたライフサイクル設定の ARN を指定します。
        # 設定可能な値: 有効なライフサイクル設定 ARN
        lifecycle_config_arn = null
      }
    }
  }

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 注意: プロバイダーレベルの default_tags 設定と一致するキーを持つタグは上書きされます
  tags = {
    Name        = "example-domain"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: ドメインに割り当てられた Amazon Resource Name (ARN)
# - id: ドメインの ID
# - url: ドメインの URL
# - home_efs_file_system_id: このドメインが管理する Amazon EFS のファイルシステム ID
# - security_group_id_for_domain_boundary: RSessionGateway アプリと RStudioServerPro アプリ間の
#                                          トラフィックを認可するセキュリティグループ ID
# - single_sign_on_application_arn: IAM Identity Center で SageMaker AI が管理するアプリの ARN
#                                   (2023年9月19日以降に作成したドメインのみ返却)
# - single_sign_on_managed_application_instance_id: SSO マネージドアプリケーションインスタンス ID
# - tags_all: プロバイダーの default_tags 設定ブロックから継承されたタグを含む全タグのマップ
#---------------------------------------------------------------
