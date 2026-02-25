#---------------------------------------------------------------
# AWS Resource Groups Resource
#---------------------------------------------------------------
#
# AWS Resource Groupsのスタティックグループにリソースを追加するリソースです。
# グループARNと追加対象リソースのARNを指定することで、特定のリソースを
# スタティックリソースグループのメンバーとして管理します。
# サポートされるグループタイプは AWS::EC2::HostManagement、
# AWS::EC2::CapacityReservationPool、AWS::ResourceGroups::ApplicationGroup です。
#
# AWS公式ドキュメント:
#   - AWS Resource Groups ユーザーガイド: https://docs.aws.amazon.com/ARG/latest/userguide/welcome.html
#   - GroupResources APIリファレンス: https://docs.aws.amazon.com/ARG/latest/APIReference/API_GroupResources.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/resourcegroups_resource
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_resourcegroups_resource" "example" {
  #-------------------------------------------------------------
  # グループ設定
  #-------------------------------------------------------------

  # group_arn (Required)
  # 設定内容: リソースを追加するリソースグループの名前またはARNを指定します。
  # 設定可能な値: リソースグループの名前、またはARN形式の文字列
  #   例: "arn:aws:resource-groups:ap-northeast-1:123456789012:group/example-group"
  group_arn = "arn:aws:resource-groups:ap-northeast-1:123456789012:group/example-group"

  #-------------------------------------------------------------
  # リソース設定
  #-------------------------------------------------------------

  # resource_arn (Required)
  # 設定内容: グループに追加するリソースのARNを指定します。
  # 設定可能な値: 有効なAWSリソースのARN文字列
  #   例: EC2ホストのARN "arn:aws:ec2:ap-northeast-1:123456789012:dedicated-host/h-xxxxxxxxxxxxxxxxx"
  # 注意: グループタイプによって追加可能なリソースタイプが異なります。
  #   AWS::EC2::HostManagement グループには EC2 Dedicated Host のみ追加可能です。
  resource_arn = "arn:aws:ec2:ap-northeast-1:123456789012:dedicated-host/h-xxxxxxxxxxxxxxxxx"

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
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト時間を設定するブロックです。
  timeouts {

    # create (Optional)
    # 設定内容: リソース作成操作のタイムアウト時間を指定します。
    # 設定可能な値: "30s", "5m", "1h" のようなGoの時間フォーマット文字列
    # 省略時: プロバイダーのデフォルトタイムアウトを使用
    create = "30m"

    # delete (Optional)
    # 設定内容: リソース削除操作のタイムアウト時間を指定します。
    # 設定可能な値: "30s", "5m", "1h" のようなGoの時間フォーマット文字列
    # 省略時: プロバイダーのデフォルトタイムアウトを使用
    delete = "30m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: group_arn と resource_arn をカンマ区切りで結合した文字列
#
# - resource_type: リソースのタイプ（例: AWS::EC2::Instance）
#---------------------------------------------------------------
