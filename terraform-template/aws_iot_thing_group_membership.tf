#---------------------------------------------------------------
# AWS IoT Thing Group Membership
#---------------------------------------------------------------
#
# AWS IoT ThingをThing Groupに追加するメンバーシップをプロビジョニングするリソースです。
# Thingを静的なThing Groupに関連付け、グループ単位でのポリシー適用や
# デバイス管理を実現します。
#
# AWS公式ドキュメント:
#   - AWS IoT Thing Groups概要: https://docs.aws.amazon.com/iot/latest/developerguide/thing-groups.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iot_thing_group_membership
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_iot_thing_group_membership" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # thing_name (Required)
  # 設定内容: グループに追加するIoT Thingの名前を指定します。
  # 設定可能な値: 既存のIoT Thing名の文字列
  thing_name = "example-thing"

  # thing_group_name (Required)
  # 設定内容: ThingをメンバーとしてにするIoT Thing Groupの名前を指定します。
  # 設定可能な値: 既存のIoT Thing Group名の文字列
  thing_group_name = "example-group"

  #-------------------------------------------------------------
  # グループ割り当て設定
  #-------------------------------------------------------------

  # override_dynamic_group (Optional)
  # 設定内容: Thingが10グループの上限に達した際に、動的グループより静的グループを優先するかを指定します。
  # 設定可能な値:
  #   - true: Thingがすでに10グループに属しており、そのうち1つ以上が動的グループの場合、
  #           静的グループへの追加時に最後の動的グループから自動的に削除されます。
  #   - false (デフォルト): 動的グループを上書きしません。
  # 省略時: false
  # 参考: https://docs.aws.amazon.com/iot/latest/developerguide/thing-groups.html
  override_dynamic_group = false

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するAWSリージョンを指定します。
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
# - id: メンバーシップID（Thing名とThing Group名の組み合わせ）
#---------------------------------------------------------------
