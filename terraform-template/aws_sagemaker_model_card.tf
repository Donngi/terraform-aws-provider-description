#---------------------------------------------------------------
# AWS SageMaker Model Card
#---------------------------------------------------------------
#
# Amazon SageMaker AIのモデルカードを管理するリソースです。
# モデルカードはMLモデルのドキュメントを構造化された形式で記録し、
# ビジネス目的、想定利用シーン、モデル性能、注意事項などの情報を
# 一元的に管理するためのガバナンスツールです。
#
# AWS公式ドキュメント:
#   - SageMaker Model Cards概要: https://docs.aws.amazon.com/sagemaker/latest/dg/model-cards.html
#   - Model Cards JSONスキーマ: https://docs.aws.amazon.com/sagemaker/latest/dg/model-cards.html#model-cards-json-schema
#   - CreateModelCard API: https://docs.aws.amazon.com/sagemaker/latest/APIReference/API_CreateModelCard.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sagemaker_model_card
#
# Provider Version: 6.36.0
# Generated: 2026-03-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_sagemaker_model_card" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # model_card_name (Required, Forces new resource)
  # 設定内容: モデルカードの名前を指定します。
  # 設定可能な値: 一意の文字列
  # 参考: https://docs.aws.amazon.com/sagemaker/latest/APIReference/API_CreateModelCard.html
  model_card_name = "my-model-card"

  # model_card_status (Required)
  # 設定内容: モデルカードの承認ステータスを指定します。
  # 設定可能な値: "Draft" / "PendingReview" / "Approved" / "Archived"
  # 参考: https://docs.aws.amazon.com/sagemaker/latest/APIReference/API_CreateModelCard.html
  model_card_status = "Draft"

  # content (Required)
  # 設定内容: モデルカードの内容をModel Card JSONスキーマ形式で指定します。
  # 設定可能な値: Model Card JSONスキーマに準拠したJSON文字列
  # 参考: https://docs.aws.amazon.com/sagemaker/latest/dg/model-cards.html#model-cards-json-schema
  content = jsonencode({
    business_details = {
      business_problem = "品質分類モデル"
    }
    intended_uses = {
      intended_uses = "本番環境でのテスト用途"
    }
    additional_information = {
      caveats_and_recommendations = "利用時の注意事項"
    }
  })

  #-------------------------------------------------------------
  # 暗号化設定
  #-------------------------------------------------------------

  # security_config (Optional)
  # 設定内容: モデルカードコンテンツの暗号化・復号に使用するKMSキーを設定します。
  # 省略時: AWS管理のキーで暗号化されます。
  # 参考: https://docs.aws.amazon.com/sagemaker/latest/APIReference/API_CreateModelCard.html
  security_config {
    # kms_key_id (Required)
    # 設定内容: モデルカードコンテンツの暗号化に使用するKMSキーのARNを指定します。
    # 設定可能な値: 有効なKMSキーARN
    kms_key_id = "arn:aws:kms:ap-northeast-1:123456789012:key/example-key-id"
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
  # 設定可能な値: キーと値のペアのマップ
  # 省略時: タグなし
  # 注意: プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #       一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "my-model-card"
    Environment = "production"
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト時間を設定します。
  # 省略時: デフォルトのタイムアウト値が適用されます。
  timeouts {
    # delete (Optional)
    # 設定内容: 削除操作のタイムアウト時間を指定します。
    # 設定可能な値: 時間単位の文字列（例: "30s", "5m", "1h"）
    # 省略時: デフォルトのタイムアウト値
    delete = "5m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - model_card_arn: モデルカードに割り当てられたAmazon Resource Name (ARN)
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
