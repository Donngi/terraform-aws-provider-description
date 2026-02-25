#---------------------------------------------------------------
# Amazon SageMaker Human Task UI
#---------------------------------------------------------------
#
# Amazon SageMaker の Human Task UI（ワーカータスクテンプレート）をプロビジョニングするリソースです。
# Human Task UI は Amazon Augmented AI (A2I) や SageMaker Ground Truth で使用される
# ワーカー向けのユーザーインターフェースを定義します。
# Liquid テンプレートと Crowd HTML Elements を使用してカスタムUIを構築できます。
#
# AWS公式ドキュメント:
#   - Amazon Augmented AI 概要: https://docs.aws.amazon.com/sagemaker/latest/dg/a2i-getting-started-core-components.html
#   - カスタムワーカータスクテンプレートの作成: https://docs.aws.amazon.com/sagemaker/latest/dg/sms-custom-templates-step2.html
#   - Crowd HTML Elements リファレンス: https://docs.aws.amazon.com/sagemaker/latest/dg/sms-ui-template-reference.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sagemaker_human_task_ui
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_sagemaker_human_task_ui" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # human_task_ui_name (Required, Forces new resource)
  # 設定内容: Human Task UI の名前を指定します。
  # 設定可能な値: 1-63文字の文字列（英数字およびハイフンのみ）
  human_task_ui_name = "example-human-task-ui"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するAWSリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # UIテンプレート設定
  #-------------------------------------------------------------

  ui_template {
    # content (Optional)
    # 設定内容: ワーカー向けUIのLiquidテンプレートのコンテンツを指定します。
    # 設定可能な値: HTML、CSS、JavaScript、Liquidテンプレート言語、Crowd HTML Elementsを含む文字列。
    #              file()関数を使用してHTMLファイルを読み込むことができます。
    # 注意: Amazon SageMaker では、Augmented AI 用の組み込みタスクタイプ（Amazon Textract、
    #       Amazon Rekognition など）を使用する場合、このフィールドは省略可能です。
    #       その場合、AWSが管理するデフォルトテンプレートが使用されます。
    # 参考: https://docs.aws.amazon.com/sagemaker/latest/dg/sms-custom-templates-step2.html
    content = file("sagemaker-human-task-ui-template.html")
  }

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 省略時: タグなし
  # 注意: プロバイダーレベルの default_tags 設定ブロックで定義されたタグと
  #       一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "example-human-task-ui"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: Human Task UI の Amazon Resource Name (ARN)
#
# - ui_template.content_sha256: テンプレートコンテンツのSHA-256ダイジェスト値
#
# - ui_template.url: ワーカーユーザーインターフェーステンプレートのURL
#
# - tags_all: プロバイダーの default_tags 設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
