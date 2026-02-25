#---------------------------------------------------------------
# AWS SageMaker Studio Lifecycle Config
#---------------------------------------------------------------
#
# Amazon SageMaker AI Studio のライフサイクル設定をプロビジョニングするリソースです。
# ライフサイクル設定はシェルスクリプトを使用して、JupyterServer や KernelGateway 等の
# アプリ起動時に自動実行されるカスタマイズ処理（パッケージインストール、
# アイドルシャットダウン設定等）を定義します。
#
# AWS公式ドキュメント:
#   - SageMaker Studio ライフサイクル設定: https://docs.aws.amazon.com/sagemaker/latest/dg/studio-lifecycle-configurations.html
#   - CreateStudioLifecycleConfig API: https://docs.aws.amazon.com/sagemaker/latest/APIReference/API_CreateStudioLifecycleConfig.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sagemaker_studio_lifecycle_config
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_sagemaker_studio_lifecycle_config" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # studio_lifecycle_config_name (Required, Forces new resource)
  # 設定内容: ライフサイクル設定の名前を指定します。
  # 設定可能な値: 最大63文字。英数字とハイフンが使用可能（パターン: ^[a-zA-Z0-9](-*[a-zA-Z0-9]){0,62}）
  # 参考: https://docs.aws.amazon.com/sagemaker/latest/APIReference/API_CreateStudioLifecycleConfig.html
  studio_lifecycle_config_name = "example-lifecycle-config"

  # studio_lifecycle_config_app_type (Required, Forces new resource)
  # 設定内容: ライフサイクル設定を関連付けるアプリの種類を指定します。
  # 設定可能な値:
  #   - "JupyterServer": Studio Classic の JupyterServer アプリ用
  #   - "KernelGateway": Studio Classic の KernelGateway（カーネル）アプリ用
  #   - "CodeEditor": Code Editor アプリ用
  #   - "JupyterLab": JupyterLab アプリ用
  # 参考: https://docs.aws.amazon.com/sagemaker/latest/APIReference/API_CreateStudioLifecycleConfig.html
  studio_lifecycle_config_app_type = "JupyterServer"

  # studio_lifecycle_config_content (Required, Forces new resource)
  # 設定内容: ライフサイクル設定スクリプトの内容をBase64エンコードした文字列を指定します。
  # 設定可能な値: シェルスクリプトをBase64エンコードした文字列
  #              Terraformの base64encode() 関数を使用して直接エンコード可能
  # 注意: スクリプトはアプリ起動時に自動実行されます。
  #       スクリプトの実行時間が長い場合、アプリの起動に時間がかかります。
  # 参考: https://docs.aws.amazon.com/sagemaker/latest/dg/studio-lifecycle-configurations.html
  studio_lifecycle_config_content = base64encode("#!/bin/bash\necho 'Lifecycle configuration started'")

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
  tags = {
    Name        = "example-lifecycle-config"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: ライフサイクル設定のAmazon Resource Name (ARN)
#
# - tags_all: プロバイダーの default_tags 設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
