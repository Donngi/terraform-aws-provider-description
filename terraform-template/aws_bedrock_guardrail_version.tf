#---------------------------------------------------------------
# AWS Bedrock Guardrail Version
#---------------------------------------------------------------
#
# Amazon Bedrock GuardrailのバージョンをプロビジョニングするTerraformリソースです。
# Guardrailバージョンを作成することで、特定の設定状態を保存し、
# 本番環境へのデプロイや他バージョンとの比較が可能になります。
#
# AWS公式ドキュメント:
#   - Guardrailバージョンの作成: https://docs.aws.amazon.com/bedrock/latest/userguide/guardrails-versions-create.html
#   - Guardrailバージョンの表示: https://docs.aws.amazon.com/bedrock/latest/userguide/guardrails-versions-view.html
#   - CreateGuardrailVersion API: https://docs.aws.amazon.com/bedrock/latest/APIReference/API_CreateGuardrailVersion.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/bedrock_guardrail_version
#
# Provider Version: 6.28.0
# Generated: 2026-01-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_bedrock_guardrail_version" "example" {
  #-------------------------------------------------------------
  # Guardrail設定
  #-------------------------------------------------------------

  # guardrail_arn (Required)
  # 設定内容: バージョンを作成する対象のGuardrailのARNを指定します。
  # 設定可能な値: 有効なAmazon Bedrock GuardrailのARN
  # 注意: aws_bedrock_guardrailリソースのguardrail_arn属性を参照して指定します。
  guardrail_arn = aws_bedrock_guardrail.example.guardrail_arn

  #-------------------------------------------------------------
  # バージョン説明
  #-------------------------------------------------------------

  # description (Optional)
  # 設定内容: Guardrailバージョンの説明を指定します。
  # 設定可能な値: 任意の文字列
  # 用途: バージョンの目的や変更内容を記録するために使用します。
  description = "Production release v1.0"

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
  # ライフサイクル設定
  #-------------------------------------------------------------

  # skip_destroy (Optional)
  # 設定内容: Terraform destroy時に以前デプロイされたGuardrailの
  #           旧バージョンを保持するかどうかを指定します。
  # 設定可能な値:
  #   - true: destroy時にバージョンを削除せず、Terraform stateから削除のみ
  #   - false (デフォルト): destroy時にバージョンを削除
  # 用途: 本番環境で使用中のバージョンを保護したい場合に使用します。
  skip_destroy = true

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  timeouts {
    # create (Optional)
    # 設定内容: リソース作成時のタイムアウト時間を指定します。
    # 設定可能な値: 時間を表す文字列（例: "30s", "5m", "2h45m"）
    # 有効な時間単位: "s" (秒), "m" (分), "h" (時間)
    create = "5m"

    # delete (Optional)
    # 設定内容: リソース削除時のタイムアウト時間を指定します。
    # 設定可能な値: 時間を表す文字列（例: "30s", "5m", "2h45m"）
    # 有効な時間単位: "s" (秒), "m" (分), "h" (時間)
    # 注意: 削除操作のタイムアウトは、destroy操作の前に
    #       変更がstateに保存される場合にのみ適用されます。
    delete = "5m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - version: 作成されたGuardrailのバージョン番号
#            バージョンは作成順に番号が付与されます。
#---------------------------------------------------------------
