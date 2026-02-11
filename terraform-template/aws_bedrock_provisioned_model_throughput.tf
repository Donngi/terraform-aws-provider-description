#---------------------------------------------------------------
# AWS Bedrock Provisioned Model Throughput
#---------------------------------------------------------------
#
# Amazon Bedrockのプロビジョンドスループットをプロビジョニングするリソースです。
# プロビジョンドスループットは、モデルに対して固定コストで高いスループットレベルを
# プロビジョニングするための機能です。カスタムモデルを使用する場合は、
# プロビジョンドスループットの購入が必須となります。
#
# AWS公式ドキュメント:
#   - Provisioned Throughput概要: https://docs.aws.amazon.com/bedrock/latest/userguide/prov-throughput.html
#   - Provisioned Throughput購入: https://docs.aws.amazon.com/bedrock/latest/userguide/prov-thru-purchase.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/bedrock_provisioned_model_throughput
#
# Provider Version: 6.28.0
# Generated: 2026-01-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_bedrock_provisioned_model_throughput" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # provisioned_model_name (Required)
  # 設定内容: プロビジョンドスループットの一意な名前を指定します。
  # 設定可能な値: 文字列（一意である必要があります）
  provisioned_model_name = "my-provisioned-model"

  # model_arn (Required)
  # 設定内容: このプロビジョンドスループットに関連付けるモデルのARNを指定します。
  # 設定可能な値: 有効なBedrockモデルのARN
  #   - Foundation Model例: arn:aws:bedrock:us-east-1::foundation-model/anthropic.claude-v2
  #   - Custom Model例: arn:aws:bedrock:us-east-1:123456789012:custom-model/my-custom-model
  model_arn = "arn:aws:bedrock:us-east-1::foundation-model/anthropic.claude-v2"

  # model_units (Required)
  # 設定内容: 割り当てるモデルユニット数を指定します。
  # 設定可能な値: 正の整数
  # 関連機能: Model Units (MU)
  #   モデルユニットは、指定されたモデルに対して特定のスループットレベルを提供します。
  #   MUは1分間に処理できる入力トークン数と生成できる出力トークン数を定義します。
  #   MUの詳細なスループット仕様については、AWSアカウントマネージャーにお問い合わせください。
  #   - https://docs.aws.amazon.com/bedrock/latest/userguide/prov-throughput.html
  model_units = 1

  #-------------------------------------------------------------
  # コミットメント設定
  #-------------------------------------------------------------

  # commitment_duration (Optional)
  # 設定内容: プロビジョンドスループットに要求するコミットメント期間を指定します。
  # 設定可能な値:
  #   - "OneMonth": 1ヶ月のコミットメント。期間終了までプロビジョンドスループットを削除不可
  #   - "SixMonths": 6ヶ月のコミットメント。期間終了までプロビジョンドスループットを削除不可
  #   - null/省略: コミットメントなし（オンデマンド）。いつでも削除可能
  # 注意: コミットメント期間が長いほど、時間単価が割引されます。
  #       カスタムモデルの場合、この引数を省略してオンデマンドのプロビジョンドスループットを
  #       購入できます。
  # 関連機能: Provisioned Throughput コミットメント
  #   コミットメント期間を選択することで、時間単価の割引を受けられます。
  #   - https://docs.aws.amazon.com/bedrock/latest/userguide/prov-throughput.html
  commitment_duration = "SixMonths"

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
  tags = {
    Name        = "my-provisioned-model"
    Environment = "production"
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  timeouts {
    # create (Optional)
    # 設定内容: リソース作成時のタイムアウト時間を指定します。
    # 設定可能な値: 時間を表す文字列（例: "30s", "2h45m"）
    #   有効な時間単位: "s"（秒）, "m"（分）, "h"（時間）
    # 省略時: デフォルトのタイムアウト値を使用
    # 注意: プロビジョンドスループットの作成には時間がかかる場合があります。
    #       "InService"ステータスになるまで待機する必要があるため、
    #       適切なタイムアウト値を設定してください。
    create = "10m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - provisioned_model_arn: プロビジョンドスループットのARN。
#                          InvokeModelやInvokeModelWithResponseStreamリクエストの
#                          modelIdパラメータとして使用できます。
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
