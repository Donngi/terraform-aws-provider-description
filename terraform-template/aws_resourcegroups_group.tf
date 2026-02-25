#---------------------------------------------------------------
# AWS Resource Groups Group
#---------------------------------------------------------------
#
# AWS Resource Groupsのリソースグループをプロビジョニングするリソースです。
# タグベースのクエリまたはサービス設定（configuration）によって、
# 関連するAWSリソースを論理的にグループ化し、一元管理を可能にします。
# グループに対してSystems Manager等のサービスからの一括操作が可能になります。
#
# AWS公式ドキュメント:
#   - AWS Resource Groups概要: https://docs.aws.amazon.com/ARG/latest/userguide/resource-groups.html
#   - CreateGroup API: https://docs.aws.amazon.com/ARG/latest/APIReference/API_CreateGroup.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/resourcegroups_group
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_resourcegroups_group" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: リソースグループの名前を指定します。
  # 設定可能な値: 最大127文字。英数字、ハイフン、ドット、アンダースコアが使用可能
  # 注意: "AWS" または "aws" で始まる名前は使用不可
  name = "example-resource-group"

  # description (Optional)
  # 設定内容: リソースグループの説明を指定します。
  # 設定可能な値: 任意の文字列
  # 省略時: 説明なし
  description = "サンプルリソースグループの説明"

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
  # リソースクエリ設定
  #-------------------------------------------------------------

  # resource_query (Required)
  # 設定内容: タグベースまたはCloudFormationスタックベースでリソースを
  #           グループに含めるためのクエリ設定ブロックです。
  # 関連機能: Resource Groups タグベースグループ
  #   タグキーと値によるフィルタリングでリソースを動的にグループ化します。
  #   - https://docs.aws.amazon.com/ARG/latest/userguide/resource-groups.html
  resource_query {

    # query (Required)
    # 設定内容: リソースクエリをJSON文字列で指定します。
    # 設定可能な値: ResourceTypeFiltersとTagFilters（またはStackIdentifier）を含むJSON文字列
    #   タグベース例: {"ResourceTypeFilters":["AWS::AllSupported"],"TagFilters":[{"Key":"Env","Values":["prod"]}]}
    #   スタックベース例: {"ResourceTypeFilters":["AWS::AllSupported"],"StackIdentifier":"arn:aws:cloudformation:..."}
    query = <<JSON
{
  "ResourceTypeFilters": [
    "AWS::EC2::Instance"
  ],
  "TagFilters": [
    {
      "Key": "Environment",
      "Values": ["production"]
    }
  ]
}
JSON

    # type (Optional)
    # 設定内容: リソースクエリのタイプを指定します。
    # 設定可能な値:
    #   - "TAG_FILTERS_1_0" (デフォルト): タグベースのクエリ
    #   - "CLOUDFORMATION_STACK_1_0": CloudFormationスタックベースのクエリ
    # 省略時: TAG_FILTERS_1_0
    type = "TAG_FILTERS_1_0"
  }

  #-------------------------------------------------------------
  # サービス設定
  #-------------------------------------------------------------

  # configuration (Optional)
  # 設定内容: リソースグループとAWSサービスを関連付け、サービスがグループ内の
  #           リソースと対話する方法を指定する設定ブロックです。
  # 注意: resource_queryとconfigurationの両方を指定することも可能ですが、
  #       サービスタイプによっては排他的な場合があります。
  #       複数のconfigurationブロックを指定可能（setネスティングモード）
  # 参考: https://docs.aws.amazon.com/ARG/latest/APIReference/API_GroupConfiguration.html
  configuration {

    # type (Required)
    # 設定内容: グループ設定アイテムのタイプを指定します。
    # 設定可能な値:
    #   - "AWS::EC2::CapacityReservationPool": EC2キャパシティ予約プール
    #   - "AWS::EC2::HostManagement": EC2専有ホスト管理
    #   - "AWS::NetworkFirewall::RuleGroup": Network Firewallルールグループ
    #   - "AWS::ResourceGroups::Generic": 汎用設定
    #   その他AWSサービスがサポートするタイプ
    type = "AWS::ResourceGroups::Generic"

    # parameters (Optional)
    # 設定内容: グループ設定アイテムのパラメータ設定ブロックです。
    # 複数のparametersブロックを指定可能（setネスティングモード）
    parameters {

      # name (Required)
      # 設定内容: グループ設定パラメータの名前を指定します。
      # 設定可能な値: 設定タイプに応じた有効なパラメータ名
      name = "allowed-resource-types"

      # values (Required)
      # 設定内容: 指定したパラメータに対する値のリストを指定します。
      # 設定可能な値: 文字列のリスト。パラメータ名に応じた有効な値
      values = ["AWS::EC2::Instance", "AWS::EC2::NetworkInterface"]
    }
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト時間を指定するブロックです。
  timeouts {

    # create (Optional)
    # 設定内容: リソース作成時のタイムアウト時間を指定します。
    # 設定可能な値: "30s", "5m", "1h" 等のGoの時間文字列
    # 省略時: プロバイダーのデフォルトタイムアウトを使用
    create = "5m"

    # update (Optional)
    # 設定内容: リソース更新時のタイムアウト時間を指定します。
    # 設定可能な値: "30s", "5m", "1h" 等のGoの時間文字列
    # 省略時: プロバイダーのデフォルトタイムアウトを使用
    update = "5m"
  }

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースグループに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "example-resource-group"
    Environment = "production"
    ManagedBy   = "terraform"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: リソースグループに割り当てられたARN
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
