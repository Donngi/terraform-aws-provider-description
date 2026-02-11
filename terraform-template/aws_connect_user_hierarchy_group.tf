# ============================================================================
# AWS Provider Terraform Resource Template
# ============================================================================
# Resource: aws_connect_user_hierarchy_group
# Generated: 2026-01-19
# Provider Version: 6.28.0
#
# 注意: このテンプレートは生成時点(2026-01-19)の情報に基づいています。
#       最新の仕様については、必ず公式ドキュメントをご確認ください。
#       https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/connect_user_hierarchy_group
# ============================================================================

# Amazon Connect User Hierarchy Group
#
# Amazon Connect のユーザー階層グループを作成・管理するリソースです。
# ユーザー階層構造を使用することで、エージェントを場所やスキルセットに基づいて
# チームやグループに整理し、レポートやアクセス制御を行うことができます。
#
# 重要な注意事項:
# - User Hierarchy Structure を事前に作成する必要があります
# - 階層は最大5レベルまで定義可能です
# - 親グループIDを指定しない場合、レベル1の階層グループとして作成されます
#
# 関連ドキュメント:
# - Amazon Connect: Getting Started
#   https://docs.aws.amazon.com/connect/latest/adminguide/amazon-connect-get-started.html
# - Organize agents into teams and groups
#   https://docs.aws.amazon.com/connect/latest/adminguide/agent-hierarchy.html
# - API Reference: HierarchyPath
#   https://docs.aws.amazon.com/connect/latest/APIReference/API_HierarchyPath.html

resource "aws_connect_user_hierarchy_group" "example" {
  # ============================================================================
  # 必須パラメータ
  # ============================================================================

  # instance_id - Amazon Connect インスタンスの識別子
  # Amazon Connect インスタンスを一意に識別するIDを指定します。
  # 形式: aaaaaaaa-bbbb-cccc-dddd-111111111111 (UUID形式)
  #
  # 参考: https://docs.aws.amazon.com/connect/latest/adminguide/amazon-connect-get-started.html
  instance_id = "aaaaaaaa-bbbb-cccc-dddd-111111111111"

  # name - ユーザー階層グループの名前
  # 階層グループを識別するための名前を指定します。
  # 制約: 100文字以内
  #
  # 例: "Sales Team", "Support Level 1", "Regional Managers"
  name = "example-hierarchy-group"

  # ============================================================================
  # オプションパラメータ
  # ============================================================================

  # parent_group_id - 親階層グループの識別子
  # この階層グループの親となる階層グループのIDを指定します。
  # 指定しない場合(null)、レベル1の階層グループとして作成されます。
  #
  # 階層構造:
  # - Level 1: parent_group_id = null
  # - Level 2: parent_group_id = Level 1 の hierarchy_group_id
  # - Level 3: parent_group_id = Level 2 の hierarchy_group_id
  # - Level 4: parent_group_id = Level 3 の hierarchy_group_id
  # - Level 5: parent_group_id = Level 4 の hierarchy_group_id
  #
  # 参考: https://docs.aws.amazon.com/connect/latest/APIReference/API_HierarchyPath.html
  parent_group_id = null

  # region - リソースが管理されるAWSリージョン
  # このリソースが作成・管理されるリージョンを指定します。
  # 指定しない場合、プロバイダー設定のリージョンが使用されます。
  #
  # 例: "us-east-1", "ap-northeast-1", "eu-west-1"
  #
  # 参考:
  # - Regional Endpoints: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # - Provider Configuration: https://registry.terraform.io/providers/hashicorp/aws/latest/docs#aws-configuration-reference
  region = null

  # tags - リソースタグ
  # 階層グループに適用するタグを指定します。
  # プロバイダーレベルで default_tags が設定されている場合、
  # 同じキーのタグはここで指定した値で上書きされます。
  #
  # 用途: リソース管理、コスト配分、アクセス制御など
  #
  # 参考: https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  tags = {
    Name        = "Example User Hierarchy Group"
    Environment = "production"
    Department  = "customer-service"
  }

  # tags_all - すべてのタグ(プロバイダーのdefault_tagsを含む)
  # プロバイダーの default_tags とリソース固有の tags を組み合わせた
  # 完全なタグセットを指定します。
  #
  # 注意: 通常は Terraform が自動的に管理するため、明示的な指定は不要です。
  #       プロバイダーの default_tags を使用している場合は、
  #       このパラメータを省略することを推奨します。
  #
  # 参考: https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  tags_all = null

  # id - Terraform リソース識別子
  # Amazon Connect インスタンスIDと階層グループIDをコロン(:)で連結した形式の
  # 識別子です。通常は Terraform が自動的に管理します。
  #
  # 形式: instance_id:hierarchy_group_id
  # 例: "aaaaaaaa-bbbb-cccc-dddd-111111111111:12345678-1234-1234-1234-123456789012"
  #
  # 注意: このパラメータは通常、明示的に設定する必要はありません。
  #       import などの特殊な用途でのみ使用します。
  id = null
}

# ============================================================================
# 出力例
# ============================================================================
# このリソースからは以下の属性が出力されます(computed):
#
# - arn (string)
#     階層グループのAmazon Resource Name (ARN)
#     例: "arn:aws:connect:us-east-1:123456789012:instance/aaaaaaaa-bbbb-cccc-dddd-111111111111/agent-group/12345678-1234-1234-1234-123456789012"
#
# - hierarchy_group_id (string)
#     階層グループの識別子
#     例: "12345678-1234-1234-1234-123456789012"
#
# - hierarchy_path (list of objects)
#     階層グループ内のレベルに関する情報を含むブロック
#     各レベル(level_one ~ level_five)には以下の属性が含まれます:
#       - arn (string): 階層グループのARN
#       - id (string): 階層グループの識別子
#       - name (string): 階層グループの名前
#
# - level_id (string)
#     階層グループのレベル識別子
#     例: "1" (レベル1), "2" (レベル2), ..., "5" (レベル5)
#
# 参考: https://docs.aws.amazon.com/connect/latest/APIReference/API_HierarchyPath.html

# ============================================================================
# 使用例
# ============================================================================
#
# 基本的な使用例:
# resource "aws_connect_user_hierarchy_group" "basic" {
#   instance_id = "aaaaaaaa-bbbb-cccc-dddd-111111111111"
#   name        = "example"
#
#   tags = {
#     "Name" = "Example User Hierarchy Group"
#   }
# }
#
# 親グループを持つ階層構造の例:
# resource "aws_connect_user_hierarchy_group" "parent" {
#   instance_id = "aaaaaaaa-bbbb-cccc-dddd-111111111111"
#   name        = "parent"
#
#   tags = {
#     "Name" = "Example User Hierarchy Group Parent"
#   }
# }
#
# resource "aws_connect_user_hierarchy_group" "child" {
#   instance_id     = "aaaaaaaa-bbbb-cccc-dddd-111111111111"
#   name            = "child"
#   parent_group_id = aws_connect_user_hierarchy_group.parent.hierarchy_group_id
#
#   tags = {
#     "Name" = "Example User Hierarchy Group Child"
#   }
# }
#
# 5レベルの階層構造の例:
# resource "aws_connect_user_hierarchy_group" "level1" {
#   instance_id = "aaaaaaaa-bbbb-cccc-dddd-111111111111"
#   name        = "Global"
# }
#
# resource "aws_connect_user_hierarchy_group" "level2" {
#   instance_id     = "aaaaaaaa-bbbb-cccc-dddd-111111111111"
#   name            = "North America"
#   parent_group_id = aws_connect_user_hierarchy_group.level1.hierarchy_group_id
# }
#
# resource "aws_connect_user_hierarchy_group" "level3" {
#   instance_id     = "aaaaaaaa-bbbb-cccc-dddd-111111111111"
#   name            = "US East"
#   parent_group_id = aws_connect_user_hierarchy_group.level2.hierarchy_group_id
# }
#
# resource "aws_connect_user_hierarchy_group" "level4" {
#   instance_id     = "aaaaaaaa-bbbb-cccc-dddd-111111111111"
#   name            = "New York"
#   parent_group_id = aws_connect_user_hierarchy_group.level3.hierarchy_group_id
# }
#
# resource "aws_connect_user_hierarchy_group" "level5" {
#   instance_id     = "aaaaaaaa-bbbb-cccc-dddd-111111111111"
#   name            = "Manhattan Office"
#   parent_group_id = aws_connect_user_hierarchy_group.level4.hierarchy_group_id
# }
