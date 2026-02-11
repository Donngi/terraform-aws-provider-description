#---------------------------------------------------------------
# AWS SageMaker App Image Config
#---------------------------------------------------------------
#
# SageMaker AI Studio、SageMaker Canvas、SageMaker Notebooksで使用するカスタム
# コンテナイメージの設定を管理するリソースです。
# KernelGatewayアプリ、JupyterLabアプリ、Code Editorアプリ用の
# カスタムイメージ設定を提供します。
#
# AWS公式ドキュメント:
#   - SageMaker App Image Config概要: https://docs.aws.amazon.com/sagemaker/latest/dg/studio-byoi.html
#   - カスタムイメージの仕様: https://docs.aws.amazon.com/sagemaker/latest/dg/studio-byoi-specs.html
#   - Kernel Gateway: https://docs.aws.amazon.com/sagemaker/latest/dg/studio-byoi-create.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sagemaker_app_image_config
#
# Provider Version: 6.28.0
# Generated: 2026-02-03
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_sagemaker_app_image_config" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # app_image_config_name (Required)
  # 設定内容: App Image Configの名前を指定します。
  # 設定可能な値: 文字列（英数字とハイフン）
  # 注意: この名前はAWSアカウント内で一意である必要があります
  app_image_config_name = "example-image-config"

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
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 注意: プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #       一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "example-image-config"
    Environment = "development"
  }

  #-------------------------------------------------------------
  # kernel_gateway_image_config ブロック (Optional)
  #-------------------------------------------------------------
  # KernelGatewayアプリとして実行されるSageMaker AIイメージ内の
  # ファイルシステムとカーネルの設定を定義します。
  # 注意: code_editor_app_image_config、jupyter_lab_image_config、
  #       kernel_gateway_image_configのいずれか1つを設定する必要があります。
  #       空のブロック（例: kernel_gateway_image_config {}）も有効な設定です。

  kernel_gateway_image_config {
    #-----------------------------------------------------------
    # kernel_spec ブロック (Required, 最大5個)
    #-----------------------------------------------------------
    # カーネル仕様を定義します。最大5つのカーネルを設定可能です。

    kernel_spec {
      # name (Required)
      # 設定内容: カーネルの名前を指定します。
      # 設定可能な値: カーネル名の文字列（例: "python3", "r"）
      # 注意: この名前はJupyter Kernelspec仕様に従う必要があります
      name = "python3"

      # display_name (Optional)
      # 設定内容: カーネルの表示名を指定します。
      # 設定可能な値: カーネルの表示名文字列
      # 省略時: nameの値が表示名として使用されます
      display_name = "Python 3"
    }

    #-----------------------------------------------------------
    # file_system_config ブロック (Optional)
    #-----------------------------------------------------------
    # ファイルシステムの設定を定義します。
    # ユーザーのEFSホームディレクトリのマウント設定やPOSIX権限を設定します。

    file_system_config {
      # default_uid (Optional)
      # 設定内容: デフォルトのPOSIXユーザーID（UID）を指定します。
      # 設定可能な値: 0または1000
      # 省略時: 1000
      # 注意: default_gidとdefault_uidの有効な組み合わせは[0, 0]と[100, 1000]のみです
      default_uid = 1000

      # default_gid (Optional)
      # 設定内容: デフォルトのPOSIXグループID（GID）を指定します。
      # 設定可能な値: 0または100
      # 省略時: 100
      # 注意: default_gidとdefault_uidの有効な組み合わせは[0, 0]と[100, 1000]のみです
      default_gid = 100

      # mount_path (Optional)
      # 設定内容: ユーザーのEFSホームディレクトリをマウントするイメージ内のパスを指定します。
      # 設定可能な値: ディレクトリパス文字列
      # 省略時: /home/sagemaker-user
      # 注意: ディレクトリは空である必要があります
      mount_path = "/home/sagemaker-user"
    }
  }

  #-------------------------------------------------------------
  # code_editor_app_image_config ブロック (Optional)
  #-------------------------------------------------------------
  # Code Editorアプリケーション用の設定を定義します。
  # 注意: code_editor_app_image_config、jupyter_lab_image_config、
  #       kernel_gateway_image_configのいずれか1つを設定する必要があります。

  # code_editor_app_image_config {
  #   #---------------------------------------------------------
  #   # container_config ブロック (Optional)
  #   #---------------------------------------------------------
  #   # アプリケーションイメージコンテナの実行設定を定義します。
  #
  #   container_config {
  #     # container_arguments (Optional)
  #     # 設定内容: アプリケーション実行時のコンテナ引数を指定します。
  #     # 設定可能な値: 文字列のリスト
  #     container_arguments = [
  #       "--enable-extension",
  #       "my-extension"
  #     ]
  #
  #     # container_entrypoint (Optional)
  #     # 設定内容: コンテナ内でアプリケーションを実行するためのエントリーポイントを指定します。
  #     # 設定可能な値: 文字列のリスト
  #     container_entrypoint = [
  #       "/usr/local/bin/start.sh"
  #     ]
  #
  #     # container_environment_variables (Optional)
  #     # 設定内容: コンテナに設定する環境変数を指定します。
  #     # 設定可能な値: キーと値のペアのマップ
  #     container_environment_variables = {
  #       ENV_VAR_1 = "value1"
  #       ENV_VAR_2 = "value2"
  #     }
  #   }
  #
  #   #---------------------------------------------------------
  #   # file_system_config ブロック (Optional)
  #   #---------------------------------------------------------
  #   # ファイルシステムの設定を定義します。
  #
  #   file_system_config {
  #     # default_uid (Optional)
  #     # 設定内容: デフォルトのPOSIXユーザーID（UID）を指定します。
  #     # 設定可能な値: 0または1000
  #     # 省略時: 1000
  #     default_uid = 1000
  #
  #     # default_gid (Optional)
  #     # 設定内容: デフォルトのPOSIXグループID（GID）を指定します。
  #     # 設定可能な値: 0または100
  #     # 省略時: 100
  #     default_gid = 100
  #
  #     # mount_path (Optional)
  #     # 設定内容: ユーザーのEFSホームディレクトリをマウントするイメージ内のパスを指定します。
  #     # 設定可能な値: ディレクトリパス文字列
  #     # 省略時: /home/sagemaker-user
  #     mount_path = "/home/sagemaker-user"
  #   }
  # }

  #-------------------------------------------------------------
  # jupyter_lab_image_config ブロック (Optional)
  #-------------------------------------------------------------
  # JupyterLabアプリケーション用の設定を定義します。
  # 注意: code_editor_app_image_config、jupyter_lab_image_config、
  #       kernel_gateway_image_configのいずれか1つを設定する必要があります。

  # jupyter_lab_image_config {
  #   #---------------------------------------------------------
  #   # container_config ブロック (Optional)
  #   #---------------------------------------------------------
  #   # アプリケーションイメージコンテナの実行設定を定義します。
  #
  #   container_config {
  #     # container_arguments (Optional)
  #     # 設定内容: アプリケーション実行時のコンテナ引数を指定します。
  #     # 設定可能な値: 文字列のリスト
  #     container_arguments = [
  #       "--ServerApp.token=''",
  #       "--ServerApp.password=''"
  #     ]
  #
  #     # container_entrypoint (Optional)
  #     # 設定内容: コンテナ内でアプリケーションを実行するためのエントリーポイントを指定します。
  #     # 設定可能な値: 文字列のリスト
  #     container_entrypoint = [
  #       "jupyter",
  #       "lab"
  #     ]
  #
  #     # container_environment_variables (Optional)
  #     # 設定内容: コンテナに設定する環境変数を指定します。
  #     # 設定可能な値: キーと値のペアのマップ
  #     container_environment_variables = {
  #       JUPYTER_ENABLE_LAB = "yes"
  #     }
  #   }
  #
  #   #---------------------------------------------------------
  #   # file_system_config ブロック (Optional)
  #   #---------------------------------------------------------
  #   # ファイルシステムの設定を定義します。
  #
  #   file_system_config {
  #     # default_uid (Optional)
  #     # 設定内容: デフォルトのPOSIXユーザーID（UID）を指定します。
  #     # 設定可能な値: 0または1000
  #     # 省略時: 1000
  #     default_uid = 1000
  #
  #     # default_gid (Optional)
  #     # 設定内容: デフォルトのPOSIXグループID（GID）を指定します。
  #     # 設定可能な値: 0または100
  #     # 省略時: 100
  #     default_gid = 100
  #
  #     # mount_path (Optional)
  #     # 設定内容: ユーザーのEFSホームディレクトリをマウントするイメージ内のパスを指定します。
  #     # 設定可能な値: ディレクトリパス文字列
  #     # 省略時: /home/sagemaker-user
  #     mount_path = "/home/sagemaker-user"
  #   }
  # }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: App Image Configの名前
#
# - arn: AWSによってこのApp Image Configに割り当てられた
#        Amazon Resource Name (ARN)
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
