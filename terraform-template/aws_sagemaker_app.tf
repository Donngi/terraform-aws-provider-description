#---------------------------------------------------------------
# AWS SageMaker App
#---------------------------------------------------------------
#
# Amazon SageMaker DomainまたはUser Profile内で実行されるアプリケーションを作成する
# リソースです。JupyterServer、KernelGateway、RStudioServerPro、CodeEditor、
# JupyterLab、TensorBoard、Canvas、DetailedProfilerなどの各種アプリタイプを
# サポートします。
#
# AWS公式ドキュメント:
#   - CreateApp API: https://docs.aws.amazon.com/sagemaker/latest/APIReference/API_CreateApp.html
#   - SageMaker Studio概要: https://docs.aws.amazon.com/sagemaker/latest/dg/studio.html
#   - Lifecycle Configurations: https://docs.aws.amazon.com/sagemaker/latest/dg/studio-lcc.html
#   - ResourceSpec: https://docs.aws.amazon.com/sagemaker/latest/APIReference/API_ResourceSpec.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sagemaker_app
#
# Provider Version: 6.28.0
# Generated: 2025-02-03
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_sagemaker_app" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # app_name (Required)
  # 設定内容: アプリケーションの名前を指定します。
  # 設定可能な値: 文字列（0〜63文字、パターン: [a-zA-Z0-9](-*[a-zA-Z0-9]){0,62}）
  # 注意: アプリケーション名はDomain/UserProfile/Spaceの中で一意である必要があります。
  app_name = "example-jupyter-app"

  # app_type (Required)
  # 設定内容: アプリケーションのタイプを指定します。
  # 設定可能な値:
  #   - "JupyterServer": Studio Classicのビジュアルインターフェースを提供
  #   - "KernelGateway": Studio Classicのノートブックとターミナルのコード実行環境を提供
  #   - "RStudioServerPro": RStudio Server Proアプリケーション
  #   - "RSessionGateway": RSessionゲートウェイアプリケーション
  #   - "TensorBoard": TensorBoardアプリケーション
  #   - "CodeEditor": Code Editorアプリケーション
  #   - "JupyterLab": JupyterLabアプリケーション
  #   - "Canvas": SageMaker Canvasアプリケーション
  #   - "DetailedProfiler": 詳細なプロファイラーアプリケーション
  # 注意: JupyterServerアプリはresource_specでinstance_type="system"のみをサポート
  #       KernelGatewayアプリはその他すべてのインスタンスタイプをサポート
  app_type = "JupyterServer"

  # domain_id (Required)
  # 設定内容: SageMaker DomainのIDを指定します。
  # 設定可能な値: 文字列（0〜63文字、パターン: d-(-*[a-z0-9]){1,61}）
  # 関連リソース: aws_sagemaker_domain
  # 注意: アプリケーションはDomain内のUserProfileまたはSpaceに関連付けられます。
  domain_id = "d-example123456"

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
  # ユーザー/スペース設定
  #-------------------------------------------------------------

  # user_profile_name (Optional)
  # 設定内容: ユーザープロファイル名を指定します。
  # 設定可能な値: 文字列（0〜63文字、パターン: [a-zA-Z0-9](-*[a-zA-Z0-9]){0,62}）
  # 関連リソース: aws_sagemaker_user_profile
  # 注意: user_profile_nameまたはspace_nameのいずれか一方が必須です。
  #       両方を同時に指定することはできません。
  user_profile_name = "example-user"

  # space_name (Optional)
  # 設定内容: スペース名を指定します。
  # 設定可能な値: 文字列（0〜63文字、パターン: [a-zA-Z0-9](-*[a-zA-Z0-9]){0,62}）
  # 関連リソース: aws_sagemaker_space
  # 注意: user_profile_nameまたはspace_nameのいずれか一方が必須です。
  #       両方を同時に指定することはできません。
  space_name = null

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 注意: プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #       一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "example-jupyter-app"
    Environment = "development"
    ManagedBy   = "terraform"
  }

  #-------------------------------------------------------------
  # resource_spec ブロック (Optional)
  #-------------------------------------------------------------
  # インスタンスタイプとSageMaker AIイメージのARNを定義します。
  # このブロックは最大1つまで指定可能です。

  resource_spec {
    # instance_type (Optional)
    # 設定内容: イメージバージョンが実行されるインスタンスタイプを指定します。
    # 設定可能な値:
    #   - JupyterServerアプリの場合: "system" のみ
    #   - KernelGatewayアプリの場合: 以下のような各種インスタンスタイプ
    #     "ml.t3.micro", "ml.t3.small", "ml.t3.medium", "ml.t3.large",
    #     "ml.t3.xlarge", "ml.t3.2xlarge", "ml.m5.large", "ml.m5.xlarge",
    #     "ml.m5.2xlarge", "ml.m5.4xlarge", "ml.m5.8xlarge", "ml.m5.12xlarge",
    #     "ml.m5.16xlarge", "ml.m5.24xlarge", "ml.c5.large", "ml.c5.xlarge",
    #     "ml.c5.2xlarge", "ml.c5.4xlarge", "ml.c5.9xlarge", "ml.c5.12xlarge",
    #     "ml.c5.18xlarge", "ml.c5.24xlarge", "ml.p3.2xlarge", "ml.p3.8xlarge",
    #     "ml.p3.16xlarge", "ml.p3dn.24xlarge", "ml.g4dn.xlarge", "ml.g4dn.2xlarge",
    #     "ml.g4dn.4xlarge", "ml.g4dn.8xlarge", "ml.g4dn.12xlarge", "ml.g4dn.16xlarge",
    #     "ml.r5.large", "ml.r5.xlarge", "ml.r5.2xlarge", "ml.r5.4xlarge",
    #     "ml.r5.8xlarge", "ml.r5.12xlarge", "ml.r5.16xlarge", "ml.r5.24xlarge",
    #     "ml.g5.xlarge", "ml.g5.2xlarge", "ml.g5.4xlarge", "ml.g5.8xlarge",
    #     "ml.g5.12xlarge", "ml.g5.16xlarge", "ml.g5.24xlarge", "ml.g5.48xlarge",
    #     "ml.g6.xlarge", "ml.g6.2xlarge", "ml.g6.4xlarge", "ml.g6.8xlarge",
    #     "ml.g6.12xlarge", "ml.g6.16xlarge", "ml.g6.24xlarge", "ml.g6.48xlarge",
    #     "ml.g6e.xlarge", "ml.g6e.2xlarge", "ml.g6e.4xlarge", "ml.g6e.8xlarge",
    #     "ml.g6e.12xlarge", "ml.g6e.16xlarge", "ml.g6e.24xlarge", "ml.g6e.48xlarge"
    # 参考: https://docs.aws.amazon.com/sagemaker/latest/dg/notebooks-available-instance-types.html
    instance_type = "system"

    # lifecycle_config_arn (Optional)
    # 設定内容: リソースにアタッチされるLifecycle ConfigurationのARNを指定します。
    # 設定可能な値: 有効なLifecycle Configuration ARN、または "None"（クリアする場合）
    # 関連リソース: aws_sagemaker_studio_lifecycle_config
    # 用途: アプリ起動時やシャットダウン時に実行されるスクリプトを定義
    # パターン: arn:aws[a-z\-]*:sagemaker:[a-z0-9\-]*:[0-9]{12}:studio-lifecycle-config/.*
    lifecycle_config_arn = null

    # sagemaker_image_arn (Optional, Computed)
    # 設定内容: イメージバージョンが所属するSageMaker AIイメージのARNを指定します。
    # 設定可能な値: 有効なSageMaker Image ARN
    # 関連リソース: aws_sagemaker_image
    # 注意: sagemaker_image_version_arnまたはsagemaker_image_version_aliasと併用可能
    #       省略時はデフォルトイメージが使用されます（Computed）
    sagemaker_image_arn = null

    # sagemaker_image_version_alias (Optional)
    # 設定内容: SageMaker Imageバージョンエイリアスを指定します。
    # 設定可能な値: SemVer 2.0.0形式のバージョン文字列
    # 関連リソース: aws_sagemaker_image_version
    # 注意: sagemaker_image_version_arnとは排他的（どちらか一方のみ指定）
    sagemaker_image_version_alias = null

    # sagemaker_image_version_arn (Optional)
    # 設定内容: インスタンス上に作成されるイメージバージョンのARNを指定します。
    # 設定可能な値: 有効なSageMaker Image Version ARN、または "None"（クリアする場合）
    # 関連リソース: aws_sagemaker_image_version
    # 注意: sagemaker_image_version_aliasとは排他的（どちらか一方のみ指定）
    #       値をクリアする場合は "None" を指定
    sagemaker_image_version_arn = null
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: アプリケーションのAmazon Resource Name (ARN)
#
# - arn: アプリケーションのAmazon Resource Name (ARN)
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------

#---------------------------------------------------------------
#
# 1. JupyterServer アプリケーションの例:
#    resource "aws_sagemaker_app" "jupyter" {
#      domain_id         = aws_sagemaker_domain.example.id
#      user_profile_name = aws_sagemaker_user_profile.example.user_profile_name
#      app_name          = "default"
#      app_type          = "JupyterServer"
#
#      resource_spec {
#        instance_type = "system"
#      }
#---------------------------------------------------------------
