#---------------------------------------------------------------
# AWS SageMaker Notebook Instance Lifecycle Configuration
#---------------------------------------------------------------
#
# Amazon SageMaker AIのノートブックインスタンスに関連付けるライフサイクル設定を
# プロビジョニングするリソースです。ライフサイクル設定は、ノートブックインスタンスの
# 作成時または起動時に実行されるシェルスクリプトを定義します。
# スクリプトはrootユーザーとして実行され、パッケージのインストール、
# ネットワーク・セキュリティ設定、AWSサービスへのアクセスなどに使用されます。
#
# AWS公式ドキュメント:
#   - ライフサイクル設定の概要: https://docs.aws.amazon.com/sagemaker/latest/dg/notebook-lifecycle-config.html
#   - CreateNotebookInstanceLifecycleConfig API: https://docs.aws.amazon.com/sagemaker/latest/APIReference/API_CreateNotebookInstanceLifecycleConfig.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sagemaker_notebook_instance_lifecycle_configuration
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_sagemaker_notebook_instance_lifecycle_configuration" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Optional, Forces new resource)
  # 設定内容: ライフサイクル設定の一意な名前を指定します。
  # 設定可能な値: 最大63文字の英数字およびハイフン（パターン: [a-zA-Z0-9](-*[a-zA-Z0-9])*）
  # 省略時: Terraformがランダムな一意の名前を生成します。
  name = "example-lifecycle-config"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用します。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # スクリプト設定
  #-------------------------------------------------------------

  # on_create (Optional)
  # 設定内容: ノートブックインスタンスの作成時に一度だけ実行されるシェルスクリプトを
  #           base64エンコードした文字列で指定します。
  # 設定可能な値: base64エンコードされたシェルスクリプト文字列（最大16384文字）
  # 省略時: 作成時のスクリプトは実行されません。
  # 注意: スクリプトはrootユーザーとして実行されます。スクリプトの実行時間は
  #       最大5分以内に制限されます。機密情報はスクリプトに含めないでください。
  # 参考: https://docs.aws.amazon.com/sagemaker/latest/dg/notebook-lifecycle-config.html
  on_create = base64encode("#!/bin/bash\necho 'on_create script executed'")

  # on_start (Optional)
  # 設定内容: ノートブックインスタンスの起動のたびに（作成時を含む）実行される
  #           シェルスクリプトをbase64エンコードした文字列で指定します。
  # 設定可能な値: base64エンコードされたシェルスクリプト文字列（最大16384文字）
  # 省略時: 起動時のスクリプトは実行されません。
  # 注意: スクリプトはrootユーザーとして実行されます。スクリプトの実行時間は
  #       最大5分以内に制限されます。機密情報はスクリプトに含めないでください。
  # 参考: https://docs.aws.amazon.com/sagemaker/latest/dg/notebook-lifecycle-config.html
  on_start = base64encode("#!/bin/bash\necho 'on_start script executed'")

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 省略時: タグは設定されません。
  # 注意: プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #       一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "example-lifecycle-config"
    Environment = "production"
    ManagedBy   = "terraform"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: AWSが割り当てたライフサイクル設定のAmazon Resource Name (ARN)
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
