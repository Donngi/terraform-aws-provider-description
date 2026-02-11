#---------------------------------------------------------------
# AWS Bedrock Inference Profile
#---------------------------------------------------------------
#
# Amazon Bedrockの推論プロファイルをプロビジョニングするリソースです。
# 推論プロファイルは、モデル呼び出しのメトリクスやコストを追跡するための
# リソースとして機能し、クロスリージョン推論のルーティングにも使用できます。
#
# 推論プロファイルには2つのタイプがあります:
# - クロスリージョン（システム定義）: AWSが定義した複数リージョンへのルーティング
# - アプリケーション: ユーザーが作成するコスト追跡・使用量監視用プロファイル
#
# AWS公式ドキュメント:
#   - Inference Profiles概要: https://docs.aws.amazon.com/bedrock/latest/userguide/inference-profiles.html
#   - クロスリージョン推論: https://docs.aws.amazon.com/bedrock/latest/userguide/cross-region-inference.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/bedrock_inference_profile
#
# Provider Version: 6.28.0
# Generated: 2026-01-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

data "aws_caller_identity" "current" {}

resource "aws_bedrock_inference_profile" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: 推論プロファイルの名前を指定します。
  # 設定可能な値: 文字列
  # 用途: コスト配分追跡やプロジェクト識別に使用する名前を設定
  name = "Claude Sonnet for Project 123"

  # description (Optional)
  # 設定内容: 推論プロファイルの説明を指定します。
  # 設定可能な値: 文字列
  # 用途: プロファイルの用途や目的を記述
  description = "Profile with tag for cost allocation tracking"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # モデルソース設定
  #-------------------------------------------------------------

  # model_source (Required)
  # 設定内容: この推論プロファイルがメトリクスとコストを追跡するモデルのソースを指定します。
  # 関連機能: Amazon Bedrock Inference Profiles
  #   推論プロファイルを使用すると、基盤モデルまたはクロスリージョン推論プロファイルに対して
  #   メトリクスとコストを追跡できます。
  #   - https://docs.aws.amazon.com/bedrock/latest/userguide/inference-profiles.html
  model_source {
    # copy_from (Required)
    # 設定内容: コピー元のモデルまたは推論プロファイルのARNを指定します。
    # 設定可能な値:
    #   - 基盤モデルARN: arn:aws:bedrock:{region}::foundation-model/{model-id}
    #   - クロスリージョン推論プロファイルARN: arn:aws:bedrock:{region}:{account-id}:inference-profile/{profile-id}
    # 例:
    #   - 基盤モデル: "arn:aws:bedrock:us-west-2::foundation-model/anthropic.claude-3-5-sonnet-20241022-v2:0"
    #   - クロスリージョンプロファイル: "arn:aws:bedrock:eu-central-1:${data.aws_caller_identity.current.account_id}:inference-profile/eu.anthropic.claude-3-5-sonnet-20240620-v1:0"
    copy_from = "arn:aws:bedrock:us-west-2::foundation-model/anthropic.claude-3-5-sonnet-20241022-v2:0"
  }

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: 推論プロファイルに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 用途: コスト配分、プロジェクト追跡、リソース管理に使用
  # 注意: プロバイダーレベルのdefault_tags設定で定義されたタグと
  #       一致するキーを持つタグは上書きされます。
  tags = {
    ProjectID   = "123"
    Environment = "production"
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト時間を指定します。
  # 関連機能: Terraform タイムアウト設定
  #   リソースの作成・更新・削除操作のタイムアウト時間をカスタマイズできます。
  timeouts {
    # create (Optional)
    # 設定内容: リソース作成のタイムアウト時間を指定します。
    # 設定可能な値: "30s", "5m", "2h45m" などの時間文字列
    # 有効な時間単位: "s"（秒）, "m"（分）, "h"（時間）
    create = null

    # update (Optional)
    # 設定内容: リソース更新のタイムアウト時間を指定します。
    # 設定可能な値: "30s", "5m", "2h45m" などの時間文字列
    # 有効な時間単位: "s"（秒）, "m"（分）, "h"（時間）
    update = null

    # delete (Optional)
    # 設定内容: リソース削除のタイムアウト時間を指定します。
    # 設定可能な値: "30s", "5m", "2h45m" などの時間文字列
    # 有効な時間単位: "s"（秒）, "m"（分）, "h"（時間）
    # 注意: 削除操作へのタイムアウト設定は、destroy操作前に状態が保存された場合のみ適用されます。
    delete = null
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: 推論プロファイルのAmazon Resource Name (ARN)
#
# - id: 推論プロファイルの一意識別子
#
# - models: 推論プロファイル内の各モデルに関する情報のリスト
#   - model_arn: モデルのAmazon Resource Name (ARN)
#
# - status: 推論プロファイルのステータス
#   - "ACTIVE": 推論プロファイルが使用可能な状態
#
# - type: 推論プロファイルのタイプ
#   - "SYSTEM_DEFINED": Amazon Bedrockによって定義されたプロファイル
#   - "APPLICATION": ユーザーによって定義されたプロファイル
#
# - created_at: 推論プロファイルが作成された日時
#
# - updated_at: 推論プロファイルが最後に更新された日時
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
