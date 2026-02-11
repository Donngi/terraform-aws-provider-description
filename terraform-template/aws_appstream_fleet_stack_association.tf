#---------------------------------------------------------------
# AWS AppStream Fleet Stack Association
#---------------------------------------------------------------
#
# Amazon AppStream 2.0のフリートとスタックの関連付けを管理するリソースです。
# フリートをスタックに関連付けることで、ユーザーはスタックを通じてフリートの
# ストリーミングインスタンスにアクセスできるようになります。
#
# AWS公式ドキュメント:
#   - AppStream 2.0 概要: https://docs.aws.amazon.com/appstream2/latest/developerguide/what-is-appstream.html
#   - AssociateFleet API: https://docs.aws.amazon.com/appstream2/latest/APIReference/API_AssociateFleet.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appstream_fleet_stack_association
#
# Provider Version: 6.28.0
# Generated: 2026-01-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_appstream_fleet_stack_association" "example" {
  #-------------------------------------------------------------
  # 必須設定
  #-------------------------------------------------------------

  # fleet_name (Required)
  # 設定内容: 関連付けるフリートの名前を指定します。
  # 設定可能な値: 既存のAppStream 2.0フリート名（最小1文字）
  # 注意: フリートはあらかじめ作成されている必要があります。
  fleet_name = "example-fleet"

  # stack_name (Required)
  # 設定内容: 関連付けるスタックの名前を指定します。
  # 設定可能な値: 既存のAppStream 2.0スタック名（最小1文字）
  # 注意: スタックはあらかじめ作成されている必要があります。
  stack_name = "example-stack"

  #-------------------------------------------------------------
  # オプション設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: フリートとスタックの関連付けの一意なID。
#       `fleet_name` と `stack_name` をスラッシュ (`/`) で結合した形式。
#       例: "example-fleet/example-stack"
#---------------------------------------------------------------
