#---------------------------------------------------------------
# AWS SageMaker Hub
#---------------------------------------------------------------
#
# Amazon SageMaker AIのプライベートモデルハブをプロビジョニングするリソースです。
# ハブはJumpStartの基盤モデルやアルゴリズム等のMLアーティファクトをキュレートし、
# 組織内のユーザーに対してガバナンスとセキュリティを確保しながら共有する仕組みを提供します。
#
# AWS公式ドキュメント:
#   - SageMaker JumpStart プライベートハブ概要: https://docs.aws.amazon.com/sagemaker/latest/dg/jumpstart-curated-hubs.html
#   - プライベートモデルハブの作成: https://docs.aws.amazon.com/sagemaker/latest/dg/jumpstart-curated-hubs-admin-guide-create.html
#   - CreateHub API: https://docs.aws.amazon.com/sagemaker/latest/APIReference/API_CreateHub.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sagemaker_hub
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_sagemaker_hub" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # hub_name (Required, Forces new resource)
  # 設定内容: ハブの名前を指定します。
  # 設定可能な値: 0〜63文字の文字列。パターン: [a-zA-Z0-9](-*[a-zA-Z0-9]){0,62}
  # 参考: https://docs.aws.amazon.com/sagemaker/latest/APIReference/API_CreateHub.html
  hub_name = "example-hub"

  # hub_description (Required)
  # 設定内容: ハブの説明文を指定します。
  # 設定可能な値: 0〜1023文字の文字列
  # 参考: https://docs.aws.amazon.com/sagemaker/latest/APIReference/API_CreateHub.html
  hub_description = "プライベートモデルハブのサンプル説明"

  #-------------------------------------------------------------
  # 表示設定
  #-------------------------------------------------------------

  # hub_display_name (Optional)
  # 設定内容: ハブの表示名を指定します。SageMaker Studio等のUIで表示されます。
  # 設定可能な値: 0〜255文字の文字列
  # 省略時: hub_name が表示名として使用されます。
  # 参考: https://docs.aws.amazon.com/sagemaker/latest/APIReference/API_CreateHub.html
  hub_display_name = "サンプル プライベートハブ"

  # hub_search_keywords (Optional)
  # 設定内容: ハブの検索に使用するキーワードのセットを指定します。
  # 設定可能な値: 各要素0〜255文字の文字列。小文字のみ使用可能（パターン: [^A-Z]*）。最大50件
  # 省略時: 検索キーワードなし
  # 参考: https://docs.aws.amazon.com/sagemaker/latest/APIReference/API_CreateHub.html
  hub_search_keywords = [
    "foundation-model",
    "generative-ai",
  ]

  #-------------------------------------------------------------
  # S3ストレージ設定
  #-------------------------------------------------------------

  # s3_storage_config (Optional)
  # 設定内容: ハブコンテンツを格納するAmazon S3ストレージ設定を指定します。
  # 省略時: S3ストレージを使用せず、SageMakerが管理するストレージを使用します。
  # 参考: https://docs.aws.amazon.com/sagemaker/latest/APIReference/API_CreateHub.html
  s3_storage_config {
    # s3_output_path (Optional)
    # 設定内容: ハブコンテンツのホスティングに使用するAmazon S3バケットのプレフィックスを指定します。
    # 設定可能な値: 有効なS3 URIプレフィックス（例: s3://my-bucket/hub-content/）
    # 省略時: S3ストレージパスが設定されません。
    s3_output_path = "s3://my-bucket/sagemaker-hub-content/"
  }

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
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ（最大50件）
  # 省略時: タグなし
  # 注意: プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #       一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "example-hub"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: ハブに割り当てられたAmazon Resource Name (ARN)
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
