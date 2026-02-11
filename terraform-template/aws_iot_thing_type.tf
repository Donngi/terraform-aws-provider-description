#---------------------------------------------------------------
# AWS IoT Thing Type
#---------------------------------------------------------------
#
# AWS IoT Thing Typeをプロビジョニングするリソースです。
# Thing Typeは、同じタイプに関連付けられた全てのThingに対して、
# 共通の説明および設定情報を保存できるようにします。
# Thing Typeを定義することで、そのタイプの全てのThingが共有する
# 属性を定義でき、Thing管理を簡素化します。
#
# 主な特徴:
# - 各Thingは最大50個の属性を持つことができます（Thing Type未設定の場合は3個まで）
# - Thing Typeの数に制限はありません
# - 1つのThingは1つのThing Typeのみを持つことができます
# - Thing Type名は作成後に変更できません
# - 非推奨化または削除が可能（削除は非推奨化後かつThingが関連付けられていない場合のみ）
#
# AWS公式ドキュメント:
#   - Thing Types概要: https://docs.aws.amazon.com/iot/latest/developerguide/thing-types.html
#   - Thing Type API リファレンス: https://docs.aws.amazon.com/iot/latest/apireference/API_ThingTypeProperties.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iot_thing_type
#
# Provider Version: 6.28.0
# Generated: 2026-01-28
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_iot_thing_type" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required, Forces new resource)
  # 設定内容: Thing Typeの名前を指定します。
  # 設定可能な値: 文字列（Thing Type名として有効な名前）
  # 注意:
  #   - 作成後は変更できません（変更するとリソースが再作成されます）
  #   - Thing Type名は一意である必要があります
  name = "my_iot_thing_type"

  # deprecated (Optional)
  # 設定内容: Thing Typeを非推奨にするかどうかを指定します。
  # 設定可能な値:
  #   - true: Thing Typeを非推奨化。新しいThingをこのタイプに関連付けることができなくなります
  #   - false (デフォルト): Thing Typeは通常通り使用可能
  # 用途:
  #   - Thing Typeを段階的に廃止する際に使用
  #   - 非推奨化後、関連するThingがなければ削除が可能になります
  # 関連機能: Thing Type ライフサイクル管理
  #   Thing Typeを安全に廃止するためのメカニズム。
  #   非推奨化することで、既存のThingには影響を与えずに新規作成を防止できます。
  #   - https://docs.aws.amazon.com/iot/latest/developerguide/thing-types.html
  deprecated = false

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
  # Thing Type プロパティ設定
  #-------------------------------------------------------------

  # properties (Optional)
  # 設定内容: Thing Typeのプロパティを定義するブロックです。
  # 最大1つのブロックのみ指定可能です。
  properties {
    # description (Optional, Forces new resource)
    # 設定内容: Thing Typeの説明を指定します。
    # 設定可能な値: 文字列（最大2028文字）
    # 用途: Thing Typeの目的や用途を文書化するために使用
    # 注意: 作成後は変更できません（変更するとリソースが再作成されます）
    description = "Thing type for my IoT devices"

    # searchable_attributes (Optional, Forces new resource)
    # 設定内容: 検索可能なThing属性名のリストを指定します。
    # 設定可能な値: 文字列のセット（各属性名は最大128文字）
    # 用途:
    #   - このThing Typeに関連付けられたThingをクエリやフィルタリングする際に
    #     使用できる属性を定義します
    #   - 最大3つの検索可能属性を指定できます
    # 省略時: 検索可能な属性は設定されません
    # 注意: 作成後は変更できません（変更するとリソースが再作成されます）
    # 関連機能: Thing Registry検索機能
    #   Thing Typeに関連付けられたThingを効率的に検索するための機能。
    #   検索可能属性を定義することで、デバイスカタログの管理が容易になります。
    #   - https://docs.aws.amazon.com/iot/latest/developerguide/thing-types.html
    searchable_attributes = ["attribute1", "attribute2", "attribute3"]
  }

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
    Name        = "my-iot-thing-type"
    Environment = "production"
    Purpose     = "IoT device management"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: 作成されたAWS IoT Thing TypeのARN
#        (Amazon Resource Name)
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
