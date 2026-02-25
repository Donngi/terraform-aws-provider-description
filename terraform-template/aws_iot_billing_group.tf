#---------------------------------------------------------------
# AWS IoT Billing Group
#---------------------------------------------------------------
#
# AWS IoT Billing Groupをプロビジョニングするリソースです。
# Billing GroupはIoT Thingをグループ化し、コストの追跡・管理を
# 容易にするための仕組みです。
# 各Thingを特定のBilling Groupに関連付けることで、
# AWS Cost Explorer上でグループ別のコスト分析が可能になります。
#
# 主な特徴:
# - ThingをBilling Groupに関連付けてコスト管理が可能
# - 1つのThingは1つのBilling Groupにのみ所属できます
# - Billing Group名は作成後に変更できません
# - グループにはオプションで説明（description）を付与できます
#
# AWS公式ドキュメント:
#   - Billing Groupの概要: https://docs.aws.amazon.com/iot/latest/developerguide/iot-billing-groups.html
#   - API リファレンス: https://docs.aws.amazon.com/iot/latest/apireference/API_CreateBillingGroup.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iot_billing_group
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_iot_billing_group" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required, Forces new resource)
  # 設定内容: Billing Groupの名前を指定します。
  # 設定可能な値: 文字列（Billing Group名として有効な名前）
  # 注意:
  #   - 作成後は変更できません（変更するとリソースが再作成されます）
  #   - 名前はAWSアカウント内で一意である必要があります
  name = "my_iot_billing_group"

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
  # Billing Group プロパティ設定
  #-------------------------------------------------------------

  # properties (Optional)
  # 設定内容: Billing Groupのプロパティを定義するブロックです。
  # 省略時: プロパティなしでBilling Groupが作成されます
  properties {
    # description (Optional)
    # 設定内容: Billing Groupの説明を指定します。
    # 設定可能な値: 文字列（Billing Groupの目的や用途を示す任意のテキスト）
    # 省略時: 説明なしで作成されます
    description = "Billing group for production IoT devices"
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
    Name        = "my-iot-billing-group"
    Environment = "production"
    Purpose     = "IoT cost management"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: 作成されたAWS IoT Billing GroupのARN
#        (Amazon Resource Name)
#
# - id: Billing Groupの名前（nameと同一）
#
# - metadata: Billing Groupのメタデータリスト。各要素は以下を含みます:
#             - creation_date: Billing Groupの作成日時
#
# - version: Billing Groupのバージョン番号
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
