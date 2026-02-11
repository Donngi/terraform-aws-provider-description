#---------------------------------------------------------------
# Amazon SageMaker Image
#---------------------------------------------------------------
#
# Amazon SageMaker AIのImageリソースをプロビジョニングするリソースです。
# SageMaker Imageは、SageMaker Studio、SageMaker Notebooks、および
# SageMaker Training/Processingジョブで使用できるカスタムコンテナイメージを
# 管理するために使用されます。
#
# AWS公式ドキュメント:
#   - CreateImage API: https://docs.aws.amazon.com/sagemaker/latest/APIReference/API_CreateImage.html
#   - SageMaker Studio Custom Images: https://docs.aws.amazon.com/sagemaker/latest/dg/studio-byoi.html
#   - SageMaker Custom Images: https://docs.aws.amazon.com/sagemaker/latest/dg/custom-images.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sagemaker_image
#
# Provider Version: 6.28.0
# Generated: 2026-02-03
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_sagemaker_image" "example" {
  #-------------------------------------------------------------
  # 名前設定（必須）
  #-------------------------------------------------------------

  # image_name (Required)
  # 設定内容: イメージの名前を指定します。
  # 設定可能な値: 文字列（アカウント内で一意である必要があります）
  # 注意: 変更するとリソースの再作成が発生します
  # 制約:
  #   - 最小長: 1文字
  #   - 最大長: 63文字
  #   - パターン: ^[a-zA-Z0-9]([-.]?[a-zA-Z0-9]){0,62}$
  image_name = "my-sagemaker-image"

  #-------------------------------------------------------------
  # IAMロール設定（必須）
  #-------------------------------------------------------------

  # role_arn (Required)
  # 設定内容: Amazon SageMaker AIがユーザーに代わってタスクを実行できるようにするIAMロールのARNを指定します。
  # 設定可能な値: 有効なIAMロールARN
  # 必要な権限:
  #   - SageMaker AIサービスへの信頼関係
  #   - 必要に応じてECRからイメージをプルするための権限
  # 参考:
  #   - https://docs.aws.amazon.com/sagemaker/latest/dg/sagemaker-roles.html
  #   - https://docs.aws.amazon.com/sagemaker/latest/APIReference/API_CreateImage.html
  role_arn = "arn:aws:iam::123456789012:role/SageMakerExecutionRole"

  #-------------------------------------------------------------
  # 表示設定
  #-------------------------------------------------------------

  # display_name (Optional)
  # 設定内容: イメージの表示名を指定します。
  # 設定可能な値: 文字列
  # 省略時: 指定なし
  # 注意: ドメインに追加する際は、ドメイン内で一意である必要があります。
  # 制約:
  #   - 最小長: 1文字
  #   - 最大長: 128文字
  #   - パターン: ^\S(.*\S)?$
  display_name = "My Custom SageMaker Image"

  # description (Optional)
  # 設定内容: イメージの説明を指定します。
  # 設定可能な値: 文字列
  # 省略時: 指定なし
  # 制約:
  #   - 最小長: 1文字
  #   - 最大長: 512文字
  #   - パターン: .*
  description = "Custom image for SageMaker Studio with specialized ML libraries"

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
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  #   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  tags = {
    Name        = "my-sagemaker-image"
    Environment = "production"
    Purpose     = "custom-ml-environment"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: イメージの名前（image_nameと同じ値）
#
# - arn: AWSによってこのImageに割り当てられたARN
#   形式: arn:aws:sagemaker:<region>:<account-id>:image/<image-name>
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------

#---------------------------------------------------------------
# 1. IAMロールの作成
# SageMaker ImageにはIAMロールが必要です。
# 以下は基本的なIAMロールの例です:
#
# resource "aws_iam_role" "sagemaker_image_role" {
#   name = "sagemaker-image-role"
#
#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#---------------------------------------------------------------
