#---------------------------------------------------------------
# SageMaker Space
#---------------------------------------------------------------
#
# Amazon SageMaker AI Spaceリソース。
# Spaceは、Amazon SageMaker AI Domainにおける共同作業環境を提供するリソースです。
# Private SpaceとShared Spaceの2種類があり、Shared Spaceでは複数のユーザーが
# リアルタイムでJupyter NotebookやJupyterLabアプリケーションを共同編集できます。
# Spaceにはストレージ設定、アプリケーション設定、実行ロール等を定義でき、
# ドメイン内のユーザー間でのコラボレーションを実現します。
#
# AWS公式ドキュメント:
#   - Collaboration with shared spaces: https://docs.aws.amazon.com/sagemaker/latest/dg/domain-space.html
#   - Amazon SageMaker Studio spaces: https://docs.aws.amazon.com/sagemaker/latest/dg/studio-updated-spaces.html
#   - CreateSpace API Reference: https://docs.aws.amazon.com/sagemaker/latest/APIReference/API_CreateSpace.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sagemaker_space
#
# Provider Version: 6.28.0
# Generated: 2026-02-03
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_sagemaker_space" "example" {
  #---------------------------------------------------------------
  # 必須パラメータ
  #---------------------------------------------------------------

  # Spaceが作成されるSageMaker AI DomainのID
  # 例: "d-xxxxxxxxxxxx"
  domain_id = "d-xxxxxxxxxxxx"

  # Spaceの名前
  # 英数字とハイフンのみ使用可能（63文字以内）
  # パターン: [a-zA-Z0-9](-*[a-zA-Z0-9]){0,62}
  space_name = "example-space"

  #---------------------------------------------------------------
  # オプションパラメータ
  #---------------------------------------------------------------

  # リージョン指定
  # 指定しない場合はプロバイダー設定のリージョンを使用
  # region = "us-west-2"

  # SageMaker Studio UIに表示されるSpace名
  # space_nameと異なる、より読みやすい名前を設定可能
  space_display_name = "Example Space Display Name"

  # タグ設定
  # Shared Space内で作成されたリソースには自動的にドメインARNとSpace ARNタグが付与され、
  # コスト管理やCloudTrailログ監視に使用可能
  tags = {
    Environment = "dev"
    Team        = "ml-team"
  }

  # プロバイダーのdefault_tagsと統合されたタグ（読み取り専用）
  # tags_all = {}

  #---------------------------------------------------------------
  # Ownership Settings（所有権設定）
  #---------------------------------------------------------------
  # Private Spaceの所有者を指定
  # space_sharing_settingsが設定されている場合は必須

  ownership_settings {
    # Private Spaceの所有者となるUser Profileの名前
    # パターン: [a-zA-Z0-9](-*[a-zA-Z0-9]){0,62}
    owner_user_profile_name = "example-user-profile"
  }

  #---------------------------------------------------------------
  # Space Sharing Settings（共有設定）
  #---------------------------------------------------------------
  # Spaceの共有タイプを指定
  # ownership_settingsが設定されている場合は必須

  space_sharing_settings {
    # 共有タイプ
    # - "Private": 単一ユーザー専用のSpace
    # - "Shared": ドメイン内の全ユーザーがアクセス可能な共同作業Space
    sharing_type = "Private"
  }

  #---------------------------------------------------------------
  # Space Settings（Space設定）
  #---------------------------------------------------------------
  # Spaceのアプリケーション設定とストレージ設定

  space_settings {
    # Space内で作成されるアプリケーションの種類
    # 有効な値: JupyterServer, KernelGateway, DetailedProfiler, TensorBoard,
    #          CodeEditor, JupyterLab, RStudioServerPro, RSessionGateway, Canvas
    # 注意: Shared Spaceでは通常JupyterServerまたはJupyterLabを使用
    app_type = "JupyterLab"

    #---------------------------------------------------------------
    # Code Editor App Settings
    #---------------------------------------------------------------
    # Code Editorアプリケーションの設定（app_type = "CodeEditor"の場合）

    # code_editor_app_settings {
    #   # デフォルトリソース指定（必須）
    #   default_resource_spec {
    #     # インスタンスタイプ
    #     # 例: "ml.t3.medium", "ml.t3.large", "ml.m5.large"
    #     instance_type = "ml.t3.medium"
    #
    #     # ライフサイクル設定のARN
    #     # 起動時・シャットダウン時のスクリプト実行を制御
    #     # lifecycle_config_arn = "arn:aws:sagemaker:region:account-id:studio-lifecycle-config/config-name"
    #
    #     # SageMaker Imageの ARN
    #     # sagemaker_image_arn = "arn:aws:sagemaker:region:account-id:image/image-name"
    #
    #     # SageMaker Image Versionのエイリアス
    #     # sagemaker_image_version_alias = "latest"
    #
    #     # SageMaker Image VersionのARN
    #     # sagemaker_image_version_arn = "arn:aws:sagemaker:region:account-id:image-version/image-name/version"
    #   }
    #
    #   # アプリケーションライフサイクル管理設定
    #   app_lifecycle_management {
    #     # アイドル設定
    #     idle_settings {
    #       # アイドルタイムアウト（分）
    #       # アプリケーションがアイドル状態になってから自動シャットダウンするまでの時間
    #       # 有効範囲: 60～525600分（60分～365日）
    #       idle_timeout_in_minutes = 120
    #     }
    #   }
    # }

    #---------------------------------------------------------------
    # JupyterLab App Settings
    #---------------------------------------------------------------
    # JupyterLabアプリケーションの設定（app_type = "JupyterLab"の場合）

    jupyter_lab_app_settings {
      # デフォルトリソース指定（必須）
      default_resource_spec {
        # インスタンスタイプ
        instance_type = "ml.t3.medium"

        # ライフサイクル設定のARN
        # lifecycle_config_arn = "arn:aws:sagemaker:region:account-id:studio-lifecycle-config/config-name"

        # SageMaker Imageの ARN
        # sagemaker_image_arn = "arn:aws:sagemaker:region:account-id:image/image-name"

        # SageMaker Image Versionのエイリアス
        # sagemaker_image_version_alias = "latest"

        # SageMaker Image VersionのARN
        # sagemaker_image_version_arn = "arn:aws:sagemaker:region:account-id:image-version/image-name/version"
      }

      # アプリケーションライフサイクル管理設定
      app_lifecycle_management {
        # アイドル設定
        idle_settings {
          # アイドルタイムアウト（分）
          # 有効範囲: 60～525600分
          idle_timeout_in_minutes = 120
        }
      }

      # コードリポジトリ設定（最大10個）
      # JupyterLabアプリケーションで自動表示されるGitリポジトリのリスト
      # code_repository {
      #   # リポジトリURL（必須）
      #   repository_url = "https://github.com/example/repo.git"
      # }
      #
      # code_repository {
      #   repository_url = "https://github.com/example/another-repo.git"
      # }
    }

    #---------------------------------------------------------------
    # JupyterServer App Settings
    #---------------------------------------------------------------
    # JupyterServerアプリケーションの設定（app_type = "JupyterServer"の場合）

    # jupyter_server_app_settings {
    #   # デフォルトリソース指定
    #   default_resource_spec {
    #     # インスタンスタイプ
    #     instance_type = "ml.t3.medium"
    #
    #     # ライフサイクル設定のARN
    #     # lifecycle_config_arn = "arn:aws:sagemaker:region:account-id:studio-lifecycle-config/config-name"
    #
    #     # SageMaker Imageの ARN
    #     # sagemaker_image_arn = "arn:aws:sagemaker:region:account-id:image/image-name"
    #
    #     # SageMaker Image Versionのエイリアス
    #     # sagemaker_image_version_alias = "latest"
    #
    #     # SageMaker Image VersionのARN
    #     # sagemaker_image_version_arn = "arn:aws:sagemaker:region:account-id:image-version/image-name/version"
    #   }
    #
    #   # ライフサイクル設定ARNのリスト
    #   # lifecycle_config_arns = [
    #   #   "arn:aws:sagemaker:region:account-id:studio-lifecycle-config/config-name-1",
    #   #   "arn:aws:sagemaker:region:account-id:studio-lifecycle-config/config-name-2"
    #   # ]
    #
    #   # コードリポジトリ設定（最大10個）
    #   # code_repository {
    #   #   repository_url = "https://github.com/example/repo.git"
    #   # }
    # }

    #---------------------------------------------------------------
    # KernelGateway App Settings
    #---------------------------------------------------------------
    # KernelGatewayアプリケーションの設定（app_type = "KernelGateway"の場合）

    # kernel_gateway_app_settings {
    #   # デフォルトリソース指定（必須）
    #   default_resource_spec {
    #     # インスタンスタイプ
    #     instance_type = "ml.t3.medium"
    #
    #     # ライフサイクル設定のARN
    #     # lifecycle_config_arn = "arn:aws:sagemaker:region:account-id:studio-lifecycle-config/config-name"
    #
    #     # SageMaker Imageの ARN
    #     # sagemaker_image_arn = "arn:aws:sagemaker:region:account-id:image/image-name"
    #
    #     # SageMaker Image Versionのエイリアス
    #     # sagemaker_image_version_alias = "latest"
    #
    #     # SageMaker Image VersionのARN
    #     # sagemaker_image_version_arn = "arn:aws:sagemaker:region:account-id:image-version/image-name/version"
    #   }
    #
    #   # ライフサイクル設定ARNのリスト
    #   # lifecycle_config_arns = [
    #   #   "arn:aws:sagemaker:region:account-id:studio-lifecycle-config/config-name"
    #   # ]
    #
    #   # カスタムイメージ設定（最大200個）
    #   # KernelGatewayアプリとして実行されるカスタムSageMaker Imageのリスト
    #   # custom_image {
    #   #   # App Image Config名（必須）
    #   #   app_image_config_name = "my-image-config"
    #   #
    #   #   # カスタムイメージ名（必須）
    #   #   image_name = "my-custom-image"
    #   #
    #   #   # イメージバージョン番号
    #   #   # image_version_number = 1
    #   # }
    # }

    #---------------------------------------------------------------
    # Space Storage Settings（ストレージ設定）
    #---------------------------------------------------------------
    # Spaceで使用するストレージの設定

    space_storage_settings {
      # EBSストレージ設定（必須）
      ebs_storage_settings {
        # EBSボリュームサイズ（GB）（必須）
        # 有効範囲: 5～16384 GB
        # Private SpaceとShared Spaceで個別のEBSボリュームが割り当てられます
        ebs_volume_size_in_gb = 10
      }
    }

    #---------------------------------------------------------------
    # Custom File System（カスタムファイルシステム）
    #---------------------------------------------------------------
    # SageMaker AI Domainに割り当てるカスタムファイルシステム

    # custom_file_system {
    #   # EFSファイルシステム設定（必須）
    #   efs_file_system {
    #     # EFSファイルシステムID（必須）
    #     # Amazon EFSファイルシステムのID
    #     file_system_id = "fs-xxxxxxxxxxxx"
    #   }
    # }
  }
}

#---------------------------------------------------------------
# Attributes Reference（参照可能な属性）
#---------------------------------------------------------------
# リソース作成後に参照可能な属性:
#
# - arn
#     SpaceのAmazon Resource Name (ARN)
#     例: arn:aws:sagemaker:us-west-2:123456789012:space/d-xxxxxxxxxxxx/example-space
#
# - home_efs_file_system_uid
#     Amazon EFSボリューム内のSpaceプロファイルのID
#     各SpaceにはEFS内に専用のプライベートディレクトリが割り当てられます
#
# - id
#     SpaceのARN（arnと同じ値）
#
# - url
#     SpaceのURL
#     IAM Identity Centerで認証している場合、アプリケーションタイプに応じた
#     リダイレクトパラメータを追加することでフェデレーションアクセスが可能
#
# - tags_all
#     プロバイダーのdefault_tagsと統合された全タグのマップ
#
#---------------------------------------------------------------
