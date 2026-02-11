#---------------------------------------------------------------
# AWS IoT Thing Group Membership
#---------------------------------------------------------------
#
# IoT Thing（デバイス）をIoT Thing Group（グループ）に追加するためのリソース。
# Thing Groupを使用することで、複数のデバイスをまとめて管理し、
# ポリシー、属性、設定を一括適用できます。
#
# AWS公式ドキュメント:
#   - Thing Groups: https://docs.aws.amazon.com/iot/latest/developerguide/thing-groups.html
#   - AddThingToThingGroup API: https://docs.aws.amazon.com/iot/latest/apireference/API_AddThingToThingGroup.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iot_thing_group_membership
#
# Provider Version: 6.28.0
# Generated: 2026-01-28
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_iot_thing_group_membership" "example" {
  #---------------------------------------------------------------
  # Required Parameters
  #---------------------------------------------------------------

  # グループに追加するThingの名前
  # - IoT Thingはデバイスの論理表現
  # - 事前にaws_iot_thingリソースで作成されている必要があります
  # - 命名規則: 1〜128文字の英数字、ハイフン、アンダースコア、コロン
  thing_name = "example-thing"

  # ThingをメンバーとするThing Groupの名前
  # - 事前にaws_iot_thing_groupリソースで作成されている必要があります
  # - Thing Groupは階層構造を持つことができます（最大7レベル）
  # - 1つのThingは最大10個のグループに所属可能
  thing_group_name = "example-group"

  #---------------------------------------------------------------
  # Optional Parameters
  #---------------------------------------------------------------

  # 動的Thing Groupを静的Thing Groupで上書きするかどうか
  # - デフォルト: false
  # - trueに設定すると、Thingが既に10個のグループに所属している場合、
  #   最後の動的Thing Groupから削除されて、この静的グループに追加されます
  # - 動的Thing Groupとは: クエリ条件に基づいて自動的にメンバーが決定されるグループ
  # - 静的Thing Groupとは: 明示的にメンバーを追加/削除するグループ
  # - 10グループ制限に達している場合のみ有効
  override_dynamic_group = true

  # リソースが管理されるAWSリージョン
  # - 未指定の場合、プロバイダー設定のリージョンが使用されます
  # - IoT Coreはグローバルサービスではなく、リージョナルサービスです
  # - Thing、Thing Group、Membershipは同じリージョンに存在する必要があります
  # region = "us-east-1"
}

#---------------------------------------------------------------
# Attributes Reference
#---------------------------------------------------------------
# 以下の属性はリソース作成後に参照可能です（computed only）:
#
# - id: メンバーシップID
#   形式: "${thing_group_name}/${thing_name}"
#   例: "example-group/example-thing"
#
#---------------------------------------------------------------
