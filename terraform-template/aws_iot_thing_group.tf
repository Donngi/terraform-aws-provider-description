#---------------------------------------------------------------
# AWS IoT Thing Group
#---------------------------------------------------------------
#
# AWS IoT のモノグループ（Thing Group）をプロビジョニングするリソースです。
# モノグループはIoTデバイス（Thing）を論理的にグループ化し、
# 一括登録・管理・クエリを可能にします。グループ階層を作成でき、
# 親グループのポリシーは子グループおよびグループ内のすべてのThingに継承されます。
#
# AWS公式ドキュメント:
#   - Static thing groups: https://docs.aws.amazon.com/iot/latest/developerguide/thing-groups.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iot_thing_group
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_iot_thing_group" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: モノグループの名前を指定します。
  # 設定可能な値: 1〜128文字の英数字、コロン、アンダースコア、ハイフン（[a-zA-Z0-9:_-]+）
  name = "example-thing-group"

  # parent_group_name (Optional)
  # 設定内容: 親モノグループの名前を指定します。グループ階層を構成する場合に使用します。
  # 設定可能な値: 既存のモノグループ名
  # 省略時: 親グループなし（ルートグループとして作成）
  # 注意: グループ階層の最大深さはAWSのサービスクォータに依存します。
  #       また、グループの親は作成後に変更できません。
  # 参考: https://docs.aws.amazon.com/iot/latest/developerguide/thing-groups.html
  parent_group_name = null

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
  # プロパティ設定
  #-------------------------------------------------------------

  # properties (Optional)
  # 設定内容: モノグループのプロパティを定義するブロックです。
  #           グループの説明と属性ペイロードを設定できます。
  # 参考: https://docs.aws.amazon.com/iot/latest/developerguide/thing-groups.html
  properties {

    # description (Optional)
    # 設定内容: モノグループの説明文を指定します。
    # 設定可能な値: 最大2028文字の文字列（[\p{Graph}\x20]*）
    # 省略時: 説明なし
    description = "This is my thing group"

    # attribute_payload (Optional)
    # 設定内容: モノグループに付与するカスタム属性のペイロードを定義するブロックです。
    # 参考: https://docs.aws.amazon.com/iot/latest/apireference/API_ThingGroupDocument.html
    attribute_payload {

      # attributes (Optional)
      # 設定内容: モノグループに付与するカスタム属性のキーバリューマップを指定します。
      # 設定可能な値: 文字列のキーバリューマップ。
      #               キーは最大128文字、値は最大800文字
      # 省略時: 属性なし
      attributes = {
        One = "11111"
        Two = "TwoTwo"
      }
    }
  }

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 省略時: タグなし
  tags = {
    Name      = "example-thing-group"
    ManagedBy = "terraform"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: モノグループのAmazon Resource Name (ARN)
#
# - id: モノグループのID
#
# - metadata: モノグループのメタデータリスト。以下の属性を含みます:
#   - creation_date: モノグループの作成日時
#   - parent_group_name: 親モノグループの名前
#   - root_to_parent_groups: ルートから親グループまでの経路リスト
#     (各要素は group_arn と group_name を含む)
#
# - version: レジストリ内のモノグループレコードの現在のバージョン番号
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
