#---------------------------------------------------------------
# Amazon SageMaker Studio Space
#---------------------------------------------------------------
#
# Amazon SageMaker Studio のスペースをプロビジョニングするリソースです。
# スペースはSageMaker Studioアプリケーション（Code Editor、JupyterLab、
# Studio Classic）のストレージとリソースを管理する単位です。
# スペースはプライベート（単一ユーザー専用）またはシェアード（ドメイン内
# の全ユーザーがアクセス可能）として作成できます。
#
# AWS公式ドキュメント:
#   - SageMaker Studio スペース: https://docs.aws.amazon.com/sagemaker/latest/dg/studio-updated-spaces.html
#   - 共有スペースでのコラボレーション: https://docs.aws.amazon.com/sagemaker/latest/dg/domain-space.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sagemaker_space
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_sagemaker_space" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # domain_id (Required)
  # 設定内容: スペースを関連付けるSageMaker DomainのIDを指定します。
  # 設定可能な値: 有効なSageMaker Domain ID
  domain_id = "d-xxxxxxxxxx"

  # space_name (Required, Forces new resource)
  # 設定内容: スペースの名前を指定します。
  # 設定可能な値: ドメイン内で一意な文字列
  space_name = "example-space"

  # space_display_name (Optional)
  # 設定内容: SageMaker Studio UIに表示されるスペースの表示名を指定します。
  # 設定可能な値: 任意の文字列
  # 省略時: space_nameが表示名として使用されます。
  space_display_name = "Example Space"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するAWSリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用します。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # オーナーシップ設定
  #-------------------------------------------------------------

  # ownership_settings (Optional)
  # 設定内容: スペースのオーナーシップ設定ブロックを指定します。
  # 注意: space_sharing_settingsを設定する場合は必須です。
  # 関連機能: SageMaker プライベートスペース
  #   プライベートスペースの所有ユーザーを指定します。
  #   - https://docs.aws.amazon.com/sagemaker/latest/dg/studio-updated-spaces.html
  ownership_settings {

    # owner_user_profile_name (Required)
    # 設定内容: プライベートスペースの所有者となるユーザープロファイル名を指定します。
    # 設定可能な値: ドメイン内の有効なユーザープロファイル名
    owner_user_profile_name = "example-user-profile"
  }

  #-------------------------------------------------------------
  # スペース共有設定
  #-------------------------------------------------------------

  # space_sharing_settings (Optional)
  # 設定内容: スペースの共有設定ブロックを指定します。
  # 注意: ownership_settingsを設定する場合は必須です。
  # 関連機能: SageMaker 共有スペース
  #   共有スペースはドメイン内の全ユーザーがアクセス可能です。
  #   - https://docs.aws.amazon.com/sagemaker/latest/dg/domain-space.html
  space_sharing_settings {

    # sharing_type (Required)
    # 設定内容: スペースの共有タイプを指定します。
    # 設定可能な値:
    #   - "Private": 単一ユーザー専用のプライベートスペース
    #   - "Shared": ドメイン内の全ユーザーがアクセス可能な共有スペース
    sharing_type = "Private"
  }

  #-------------------------------------------------------------
  # スペース設定
  #-------------------------------------------------------------

  # space_settings (Optional)
  # 設定内容: スペースの詳細設定ブロックを指定します。
  # 関連機能: SageMaker Studio アプリケーション設定
  #   スペースで実行するアプリケーションの種類やリソース設定を定義します。
  #   - https://docs.aws.amazon.com/sagemaker/latest/dg/studio-updated-spaces.html
  space_settings {

    # app_type (Optional)
    # 設定内容: スペース内で作成されるアプリケーションの種類を指定します。
    # 設定可能な値:
    #   - "JupyterServer": Jupyter Serverアプリケーション（Studio Classic）
    #   - "KernelGateway": カーネルゲートウェイアプリケーション
    #   - "TensorBoard": TensorBoardアプリケーション
    #   - "RStudioServerPro": RStudio Server Proアプリケーション
    #   - "RSessionGateway": Rセッションゲートウェイアプリケーション
    #   - "JupyterLab": JupyterLabアプリケーション
    #   - "CodeEditor": Code Editorアプリケーション
    # 省略時: アプリケーションタイプは未指定となります。
    app_type = "JupyterLab"

    #-----------------------------------------------------------
    # カスタムファイルシステム設定
    #-----------------------------------------------------------

    # custom_file_system (Optional)
    # 設定内容: スペースに割り当てるカスタムファイルシステムの設定ブロックです。
    # 設定可能な値: 複数指定可能
    # 関連機能: Amazon EFS カスタムファイルシステム
    #   ユーザーが作成したEFSファイルシステムをスペースに割り当てます。
    custom_file_system {

      # efs_file_system (Required)
      # 設定内容: Amazon EFSカスタムファイルシステムの設定ブロックです。
      efs_file_system {

        # file_system_id (Required)
        # 設定内容: Amazon EFSファイルシステムのIDを指定します。
        # 設定可能な値: 有効なEFSファイルシステムID（例: fs-xxxxxxxxxx）
        file_system_id = "fs-xxxxxxxxxx"
      }
    }

    #-----------------------------------------------------------
    # Code Editorアプリケーション設定
    #-----------------------------------------------------------

    # code_editor_app_settings (Optional)
    # 設定内容: Code Editorアプリケーションの設定ブロックです。
    # 関連機能: SageMaker Studio Code Editor
    #   ブラウザベースのVS Code互換コードエディタです。
    #   - https://docs.aws.amazon.com/sagemaker/latest/dg/code-editor.html
    code_editor_app_settings {

      # default_resource_spec (Required)
      # 設定内容: Code Editorアプリケーションのデフォルトリソース仕様の設定ブロックです。
      default_resource_spec {

        # instance_type (Optional)
        # 設定内容: アプリケーションが実行されるインスタンスタイプを指定します。
        # 設定可能な値: ml.t3.micro, ml.t3.small, ml.t3.medium, ml.t3.large,
        #   ml.t3.xlarge, ml.t3.2xlarge, ml.m5.xlarge, ml.m5.2xlarge,
        #   ml.m5.4xlarge, ml.m5.8xlarge, ml.m5.12xlarge, ml.m5.16xlarge,
        #   ml.m5.24xlarge, ml.c5.xlarge, ml.c5.2xlarge, ml.c5.4xlarge,
        #   ml.c5.9xlarge, ml.c5.18xlarge, ml.p3.2xlarge, ml.p3.8xlarge,
        #   ml.p3.16xlarge, ml.g4dn.xlarge, ml.g4dn.2xlarge, ml.g4dn.4xlarge,
        #   ml.g4dn.8xlarge, ml.g4dn.12xlarge, ml.g4dn.16xlarge 等
        # 省略時: デフォルトインスタンスタイプが使用されます。
        instance_type = "ml.t3.medium"

        # lifecycle_config_arn (Optional)
        # 設定内容: リソースに関連付けるライフサイクル設定のARNを指定します。
        # 設定可能な値: 有効なSageMaker Studioライフサイクル設定ARN
        # 省略時: ライフサイクル設定は関連付けられません。
        lifecycle_config_arn = null

        # sagemaker_image_arn (Optional)
        # 設定内容: インスタンス上で作成されたSageMaker AIイメージのARNを指定します。
        # 設定可能な値: 有効なSageMaker AIイメージARN
        # 省略時: デフォルトイメージが使用されます。
        sagemaker_image_arn = null

        # sagemaker_image_version_alias (Optional)
        # 設定内容: SageMaker AIイメージバージョンのエイリアスを指定します。
        # 設定可能な値: 有効なイメージバージョンエイリアス文字列
        # 省略時: デフォルトバージョンが使用されます。
        sagemaker_image_version_alias = null

        # sagemaker_image_version_arn (Optional)
        # 設定内容: インスタンス上で作成されたイメージバージョンのARNを指定します。
        # 設定可能な値: 有効なSageMaker AIイメージバージョンARN
        # 省略時: デフォルトバージョンが使用されます。
        sagemaker_image_version_arn = null
      }

      # app_lifecycle_management (Optional)
      # 設定内容: スペース内のCode Editorアプリケーションのライフサイクルを
      #   設定・管理するための設定ブロックです。
      # 関連機能: SageMaker Studio アイドルシャットダウン
      #   アイドル状態のアプリケーションを自動シャットダウンしてコストを最適化します。
      app_lifecycle_management {

        # idle_settings (Optional)
        # 設定内容: Studioアプリケーションのアイドルシャットダウン設定ブロックです。
        idle_settings {

          # idle_timeout_in_minutes (Optional)
          # 設定内容: アプリケーションがアイドル状態になってからシャットダウンするまでの
          #   待機時間（分単位）を指定します。
          # 設定可能な値: 60〜525600（分）の整数
          # 省略時: アイドルシャットダウンは設定されません。
          idle_timeout_in_minutes = 60
        }
      }
    }

    #-----------------------------------------------------------
    # JupyterLabアプリケーション設定
    #-----------------------------------------------------------

    # jupyter_lab_app_settings (Optional)
    # 設定内容: JupyterLabアプリケーションの設定ブロックです。
    # 関連機能: SageMaker JupyterLab
    #   フルマネージドのJupyterLabアプリケーションです。
    #   - https://docs.aws.amazon.com/sagemaker/latest/dg/studio-updated-jl.html
    jupyter_lab_app_settings {

      # default_resource_spec (Required)
      # 設定内容: JupyterLabアプリケーションのデフォルトリソース仕様の設定ブロックです。
      default_resource_spec {

        # instance_type (Optional)
        # 設定内容: アプリケーションが実行されるインスタンスタイプを指定します。
        # 設定可能な値: ml.t3.micro, ml.t3.medium, ml.m5.xlarge, ml.g4dn.xlarge 等
        # 省略時: デフォルトインスタンスタイプが使用されます。
        instance_type = "ml.t3.medium"

        # lifecycle_config_arn (Optional)
        # 設定内容: リソースに関連付けるライフサイクル設定のARNを指定します。
        # 設定可能な値: 有効なSageMaker Studioライフサイクル設定ARN
        # 省略時: ライフサイクル設定は関連付けられません。
        lifecycle_config_arn = null

        # sagemaker_image_arn (Optional)
        # 設定内容: インスタンス上で作成されたSageMaker AIイメージのARNを指定します。
        # 設定可能な値: 有効なSageMaker AIイメージARN
        # 省略時: デフォルトイメージが使用されます。
        sagemaker_image_arn = null

        # sagemaker_image_version_alias (Optional)
        # 設定内容: SageMaker AIイメージバージョンのエイリアスを指定します。
        # 設定可能な値: 有効なイメージバージョンエイリアス文字列
        # 省略時: デフォルトバージョンが使用されます。
        sagemaker_image_version_alias = null

        # sagemaker_image_version_arn (Optional)
        # 設定内容: インスタンス上で作成されたイメージバージョンのARNを指定します。
        # 設定可能な値: 有効なSageMaker AIイメージバージョンARN
        # 省略時: デフォルトバージョンが使用されます。
        sagemaker_image_version_arn = null
      }

      # app_lifecycle_management (Optional)
      # 設定内容: スペース内のJupyterLabアプリケーションのライフサイクルを
      #   設定・管理するための設定ブロックです。
      app_lifecycle_management {

        # idle_settings (Optional)
        # 設定内容: Studioアプリケーションのアイドルシャットダウン設定ブロックです。
        idle_settings {

          # idle_timeout_in_minutes (Optional)
          # 設定内容: アプリケーションがアイドル状態になってからシャットダウンするまでの
          #   待機時間（分単位）を指定します。
          # 設定可能な値: 60〜525600（分）の整数
          # 省略時: アイドルシャットダウンは設定されません。
          idle_timeout_in_minutes = 60
        }
      }

      # code_repository (Optional)
      # 設定内容: JupyterLabアプリケーションでクローン用に表示するGitリポジトリの
      #   設定ブロックです。最大10個まで指定可能です。
      code_repository {

        # repository_url (Required)
        # 設定内容: Gitリポジトリのクローン元URLを指定します。
        # 設定可能な値: 有効なGitリポジトリURL
        repository_url = "https://github.com/example/repo.git"
      }
    }

    #-----------------------------------------------------------
    # Jupyter Server（Studio Classic）アプリケーション設定
    #-----------------------------------------------------------

    # jupyter_server_app_settings (Optional)
    # 設定内容: Jupyter Serverアプリケーション（Studio Classic）の設定ブロックです。
    # 関連機能: SageMaker Studio Classic
    #   - https://docs.aws.amazon.com/sagemaker/latest/dg/studio.html
    jupyter_server_app_settings {

      # lifecycle_config_arns (Optional)
      # 設定内容: ライフサイクル設定のARNセットを指定します。
      # 設定可能な値: 有効なSageMaker Studioライフサイクル設定ARNのセット
      # 省略時: ライフサイクル設定は関連付けられません。
      lifecycle_config_arns = []

      # default_resource_spec (Optional)
      # 設定内容: Jupyter Serverアプリケーションのデフォルトリソース仕様の設定ブロックです。
      default_resource_spec {

        # instance_type (Optional)
        # 設定内容: アプリケーションが実行されるインスタンスタイプを指定します。
        # 設定可能な値: ml.t3.micro, ml.t3.medium, ml.m5.xlarge 等
        # 省略時: デフォルトインスタンスタイプが使用されます。
        instance_type = "system"

        # lifecycle_config_arn (Optional)
        # 設定内容: リソースに関連付けるライフサイクル設定のARNを指定します。
        # 設定可能な値: 有効なSageMaker Studioライフサイクル設定ARN
        # 省略時: ライフサイクル設定は関連付けられません。
        lifecycle_config_arn = null

        # sagemaker_image_arn (Optional)
        # 設定内容: インスタンス上で作成されたSageMaker AIイメージのARNを指定します。
        # 設定可能な値: 有効なSageMaker AIイメージARN
        # 省略時: デフォルトイメージが使用されます。
        sagemaker_image_arn = null

        # sagemaker_image_version_alias (Optional)
        # 設定内容: SageMaker AIイメージバージョンのエイリアスを指定します。
        # 設定可能な値: 有効なイメージバージョンエイリアス文字列
        # 省略時: デフォルトバージョンが使用されます。
        sagemaker_image_version_alias = null

        # sagemaker_image_version_arn (Optional)
        # 設定内容: インスタンス上で作成されたイメージバージョンのARNを指定します。
        # 設定可能な値: 有効なSageMaker AIイメージバージョンARN
        # 省略時: デフォルトバージョンが使用されます。
        sagemaker_image_version_arn = null
      }

      # code_repository (Optional)
      # 設定内容: Jupyter Serverアプリケーションでクローン用に表示するGitリポジトリの
      #   設定ブロックです。最大10個まで指定可能です。
      code_repository {

        # repository_url (Required)
        # 設定内容: Gitリポジトリのクローン元URLを指定します。
        # 設定可能な値: 有効なGitリポジトリURL
        repository_url = "https://github.com/example/repo.git"
      }
    }

    #-----------------------------------------------------------
    # Kernel Gatewayアプリケーション設定
    #-----------------------------------------------------------

    # kernel_gateway_app_settings (Optional)
    # 設定内容: Kernel Gatewayアプリケーションの設定ブロックです。
    # 関連機能: SageMaker KernelGateway アプリ
    #   Studio Classic環境でノートブックカーネルを実行するためのアプリケーションです。
    kernel_gateway_app_settings {

      # lifecycle_config_arns (Optional)
      # 設定内容: ライフサイクル設定のARNセットを指定します。
      # 設定可能な値: 有効なSageMaker Studioライフサイクル設定ARNのセット
      # 省略時: ライフサイクル設定は関連付けられません。
      lifecycle_config_arns = []

      # default_resource_spec (Required)
      # 設定内容: Kernel Gatewayアプリケーションのデフォルトリソース仕様の設定ブロックです。
      default_resource_spec {

        # instance_type (Optional)
        # 設定内容: アプリケーションが実行されるインスタンスタイプを指定します。
        # 設定可能な値: ml.t3.micro, ml.t3.medium, ml.m5.xlarge, ml.g4dn.xlarge 等
        # 省略時: デフォルトインスタンスタイプが使用されます。
        instance_type = "ml.t3.medium"

        # lifecycle_config_arn (Optional)
        # 設定内容: リソースに関連付けるライフサイクル設定のARNを指定します。
        # 設定可能な値: 有効なSageMaker Studioライフサイクル設定ARN
        # 省略時: ライフサイクル設定は関連付けられません。
        lifecycle_config_arn = null

        # sagemaker_image_arn (Optional)
        # 設定内容: インスタンス上で作成されたSageMaker AIイメージのARNを指定します。
        # 設定可能な値: 有効なSageMaker AIイメージARN
        # 省略時: デフォルトイメージが使用されます。
        sagemaker_image_arn = null

        # sagemaker_image_version_alias (Optional)
        # 設定内容: SageMaker AIイメージバージョンのエイリアスを指定します。
        # 設定可能な値: 有効なイメージバージョンエイリアス文字列
        # 省略時: デフォルトバージョンが使用されます。
        sagemaker_image_version_alias = null

        # sagemaker_image_version_arn (Optional)
        # 設定内容: インスタンス上で作成されたイメージバージョンのARNを指定します。
        # 設定可能な値: 有効なSageMaker AIイメージバージョンARN
        # 省略時: デフォルトバージョンが使用されます。
        sagemaker_image_version_arn = null
      }

      # custom_image (Optional)
      # 設定内容: KernelGatewayアプリとして実行するカスタムSageMaker AIイメージの
      #   設定ブロックです。最大200個まで指定可能です。
      custom_image {

        # app_image_config_name (Required)
        # 設定内容: アプリイメージ設定の名前を指定します。
        # 設定可能な値: 有効なSageMaker App Image Config名
        app_image_config_name = "example-app-image-config"

        # image_name (Required)
        # 設定内容: カスタムイメージの名前を指定します。
        # 設定可能な値: 有効なSageMaker AIカスタムイメージ名
        image_name = "example-custom-image"

        # image_version_number (Optional)
        # 設定内容: カスタムイメージのバージョン番号を指定します。
        # 設定可能な値: 正の整数
        # 省略時: 最新バージョンが使用されます。
        image_version_number = 1
      }
    }

    #-----------------------------------------------------------
    # ストレージ設定
    #-----------------------------------------------------------

    # space_storage_settings (Optional)
    # 設定内容: スペースのストレージ設定ブロックです。
    # 関連機能: SageMaker Studio EBSストレージ
    #   Code EditorおよびJupyterLabスペースは各アプリケーションに専用のEBSボリュームが
    #   アタッチされます。
    #   - https://docs.aws.amazon.com/sagemaker/latest/dg/studio-updated-spaces.html
    space_storage_settings {

      # ebs_storage_settings (Required)
      # 設定内容: スペースのEBSストレージ設定ブロックです。
      ebs_storage_settings {

        # ebs_volume_size_in_gb (Required)
        # 設定内容: スペースのEBSストレージボリュームサイズをGB単位で指定します。
        # 設定可能な値: 正の整数（GB単位）
        ebs_volume_size_in_gb = 50
      }
    }
  }

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "example-space"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: スペースのAmazon Resource Name (ARN)
# - home_efs_file_system_uid: Amazon EFSボリューム内のスペースプロファイルのID
# - url: スペースのURL。AWS IAM Identity Center認証を使用する場合、
#        アプリケーションタイプに応じたリダイレクトパラメータを追加してアクセスします。
# - id: スペースのARN（arnと同値）
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
