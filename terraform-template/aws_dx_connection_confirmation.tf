#---------------------------------------------------------------
# AWS Direct Connect Connection Confirmation
#---------------------------------------------------------------
#
# インターコネクト上で作成されたホスト接続（Hosted Connection）の
# 確認（承認）を行うリソースです。
#
# Direct ConnectパートナーによってプロビジョニングされたHosted Connectionは、
# 作成直後は"ordering"状態となり、お客様がこのリソースを使用して
# 接続を確認（承認）することで"available"状態に遷移します。
#
# AWS公式ドキュメント:
#   - Hosted Connectionの承認: https://docs.aws.amazon.com/directconnect/latest/UserGuide/accept-hosted-connection.html
#   - ConfirmConnection API: https://docs.aws.amazon.com/directconnect/latest/APIReference/API_ConfirmConnection.html
#   - Direct Connect接続の種類: https://docs.aws.amazon.com/directconnect/latest/UserGuide/WorkingWithConnections.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dx_connection_confirmation
#
# Provider Version: 6.28.0
# Generated: 2026-01-22
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_dx_connection_confirmation" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # connection_id (Required)
  # 設定内容: 確認（承認）するホスト接続のIDを指定します。
  # 設定可能な値: "dxcon-" で始まるDirect Connect接続ID
  #              （例: "dxcon-ffabc123"）
  # 注意: この接続はDirect Connectパートナーによってプロビジョニングされた
  #       ホスト接続である必要があります。Dedicated Connectionには使用できません。
  # 関連機能: ホスト接続は、パートナーがお客様に代わってプロビジョニングする
  #           物理的なイーサネット接続です。接続を使用する前に、
  #           このリソースを使用して確認（承認）する必要があります。
  connection_id = "dxcon-ffabc123"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: 接続のID（connection_idと同じ値）
#
#---------------------------------------------------------------
