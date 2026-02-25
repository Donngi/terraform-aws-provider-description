#---------------------------------------------------------------
# Amazon Rekognition Project
#---------------------------------------------------------------
#
# Amazon Rekognitionのプロジェクトをプロビジョニングするリソースです。
# プロジェクトはカスタムラベルモデルやコンテンツモデレーションモデルを
# 管理するための論理的なグループです。
# データセット・モデルバージョンなどのリソースをプロジェクト単位で管理します。
#
# AWS公式ドキュメント:
#   - Amazon Rekognition Custom Labels プロジェクト作成: https://docs.aws.amazon.com/rekognition/latest/customlabels-dg/mp-create-project.html
#   - Amazon Rekognition Custom Labels 概要: https://docs.aws.amazon.com/rekognition/latest/customlabels-dg/what-is.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rekognition_project
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_rekognition_project" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: プロジェクトの名前を指定します。
  # 設定可能な値: 1〜255文字の英数字・ハイフン・アンダースコアを含む文字列
  name = "example-project"

  #-------------------------------------------------------------
  # 機能設定
  #-------------------------------------------------------------

  # feature (Optional)
  # 設定内容: プロジェクトがカスタマイズする機能の種類を指定します。
  # 設定可能な値:
  #   - "CUSTOM_LABELS" (デフォルト): カスタムラベルモデルの作成に使用します。
  #                                   独自の画像データセットでトレーニングし、
  #                                   オブジェクト・シーン・概念の検出が可能です。
  #   - "CONTENT_MODERATION": コンテンツモデレーションモデルの作成に使用します。
  #                            自動更新（auto_update）を有効化して使用します。
  # 省略時: "CUSTOM_LABELS"
  # 注意: "CUSTOM_LABELS"の場合、auto_updateは設定しないでください。
  #       "CONTENT_MODERATION"の場合、auto_updateをENABLEDに設定してください。
  # 参考: https://docs.aws.amazon.com/rekognition/latest/customlabels-dg/mp-create-project.html
  feature = "CUSTOM_LABELS"

  # auto_update (Optional)
  # 設定内容: モデルの自動再トレーニングを有効にするかを指定します。
  # 設定可能な値:
  #   - "ENABLED": 自動再トレーニングを有効化します。
  #   - "DISABLED": 自動再トレーニングを無効化します。
  # 注意: featureが"CONTENT_MODERATION"の場合のみ設定してください。
  #       featureが"CUSTOM_LABELS"の場合は設定しないでください。
  # 参考: https://docs.aws.amazon.com/rekognition/latest/customlabels-dg/mp-create-project.html
  auto_update = null

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
  # 省略時: タグなし
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "example-project"
    Environment = "production"
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  timeouts {
    # create (Optional)
    # 設定内容: リソース作成操作のタイムアウト時間を指定します。
    # 設定可能な値: "30s", "5m", "2h" など時間単位（s: 秒, m: 分, h: 時間）を含む文字列
    # 省略時: プロバイダーのデフォルトタイムアウトを使用
    create = "5m"

    # delete (Optional)
    # 設定内容: リソース削除操作のタイムアウト時間を指定します。
    # 設定可能な値: "30s", "5m", "2h" など時間単位（s: 秒, m: 分, h: 時間）を含む文字列
    # 省略時: プロバイダーのデフォルトタイムアウトを使用
    delete = "5m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: プロジェクトのAmazon Resource Name (ARN)
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
