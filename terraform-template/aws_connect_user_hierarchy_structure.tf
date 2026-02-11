#================================================================================
# aws_connect_user_hierarchy_structure
#================================================================================
# 生成日: 2026-01-19
# Provider Version: 6.28.0
#
# 【注意事項】
# このテンプレートは生成時点の AWS Provider 仕様に基づいています。
# 最新の仕様や詳細については、必ず公式ドキュメントをご確認ください。
# - Terraform AWS Provider: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/connect_user_hierarchy_structure
# - AWS Connect API Reference: https://docs.aws.amazon.com/connect/latest/APIReference/API_HierarchyStructure.html
# - AWS Connect Admin Guide: https://docs.aws.amazon.com/connect/latest/adminguide/agent-hierarchy.html
#================================================================================

resource "aws_connect_user_hierarchy_structure" "example" {
  #================================================================================
  # Required Arguments
  #================================================================================

  # instance_id - (必須) Amazon Connect インスタンスの識別子
  # Amazon Connect インスタンスを一意に識別する ID を指定します。
  # この階層構造がどの Connect インスタンスに属するかを定義します。
  # 形式: "aaaaaaaa-bbbb-cccc-dddd-111111111111"
  # https://docs.aws.amazon.com/connect/latest/adminguide/find-instance-arn.html
  instance_id = "aaaaaaaa-bbbb-cccc-dddd-111111111111"

  #================================================================================
  # Optional Arguments
  #================================================================================

  # id - (オプション) リソースの識別子
  # Terraform により自動的に計算されます。通常は明示的に指定する必要はありません。
  # 計算時には instance_id と同じ値になります。
  # id = "aaaaaaaa-bbbb-cccc-dddd-111111111111"

  # region - (オプション) このリソースが管理されるリージョン
  # 指定しない場合、プロバイダー設定のリージョンがデフォルトで使用されます。
  # 複数リージョンでリソースを管理する場合に明示的に指定します。
  # https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-east-1"

  #================================================================================
  # Block: hierarchy_structure (必須)
  #================================================================================
  # ユーザー階層構造のレベルを定義するブロックです。
  # Amazon Connect では、エージェントを場所やスキルセットに基づいて組織化するため、
  # 最大 5 つのレベルまで階層を設定できます。
  # 少なくとも level_one は必須で、level_two から level_five はオプションです。
  # https://docs.aws.amazon.com/connect/latest/adminguide/agent-hierarchy.html
  #================================================================================
  hierarchy_structure {

    #------------------------------------------------------------------------------
    # Block: level_one (オプションですが、通常は必須)
    #------------------------------------------------------------------------------
    # 階層の第 1 レベルを定義します。
    # 最も基本的なグループ分けに使用されます（例: 地域、部門など）。
    #------------------------------------------------------------------------------
    level_one {
      # name - (必須) 階層レベルの名前
      # 最大 50 文字までの文字列を指定します。
      # エージェントのグループ化や報告目的で使用されます。
      # 例: "Region", "Division", "Department"
      name = "levelone"

      # arn - (Computed) 階層レベルの Amazon Resource Name (ARN)
      # AWS により自動的に生成されます。Terraform では読み取り専用です。

      # id - (Computed) 階層レベルの識別子
      # AWS により自動的に生成されます。Terraform では読み取り専用です。
    }

    #------------------------------------------------------------------------------
    # Block: level_two (オプション)
    #------------------------------------------------------------------------------
    # 階層の第 2 レベルを定義します。
    # level_one のサブグループとして使用されます（例: 営業所、チームなど）。
    #------------------------------------------------------------------------------
    level_two {
      # name - (必須) 階層レベルの名前
      # 最大 50 文字までの文字列を指定します。
      # 例: "Office", "Team", "Unit"
      name = "leveltwo"

      # arn - (Computed) 階層レベルの Amazon Resource Name (ARN)
      # AWS により自動的に生成されます。Terraform では読み取り専用です。

      # id - (Computed) 階層レベルの識別子
      # AWS により自動的に生成されます。Terraform では読み取り専用です。
    }

    #------------------------------------------------------------------------------
    # Block: level_three (オプション)
    #------------------------------------------------------------------------------
    # 階層の第 3 レベルを定義します。
    # level_two のさらなるサブグループとして使用されます。
    #------------------------------------------------------------------------------
    level_three {
      # name - (必須) 階層レベルの名前
      # 最大 50 文字までの文字列を指定します。
      # 例: "Shift", "Squad", "Group"
      name = "levelthree"

      # arn - (Computed) 階層レベルの Amazon Resource Name (ARN)
      # AWS により自動的に生成されます。Terraform では読み取り専用です。

      # id - (Computed) 階層レベルの識別子
      # AWS により自動的に生成されます。Terraform では読み取り専用です。
    }

    #------------------------------------------------------------------------------
    # Block: level_four (オプション)
    #------------------------------------------------------------------------------
    # 階層の第 4 レベルを定義します。
    # より細かい組織化が必要な場合に使用されます。
    #------------------------------------------------------------------------------
    level_four {
      # name - (必須) 階層レベルの名前
      # 最大 50 文字までの文字列を指定します。
      # 例: "Subteam", "Pod", "Section"
      name = "levelfour"

      # arn - (Computed) 階層レベルの Amazon Resource Name (ARN)
      # AWS により自動的に生成されます。Terraform では読み取り専用です。

      # id - (Computed) 階層レベルの識別子
      # AWS により自動的に生成されます。Terraform では読み取り専用です。
    }

    #------------------------------------------------------------------------------
    # Block: level_five (オプション)
    #------------------------------------------------------------------------------
    # 階層の第 5 レベル（最も深いレベル）を定義します。
    # 最も詳細な組織化が必要な場合に使用されます。
    #------------------------------------------------------------------------------
    level_five {
      # name - (必須) 階層レベルの名前
      # 最大 50 文字までの文字列を指定します。
      # 例: "Individual", "Agent", "Associate"
      name = "levelfive"

      # arn - (Computed) 階層レベルの Amazon Resource Name (ARN)
      # AWS により自動的に生成されます。Terraform では読み取り専用です。

      # id - (Computed) 階層レベルの識別子
      # AWS により自動的に生成されます。Terraform では読み取り専用です。
    }
  }
}

#================================================================================
# Outputs (参考例)
#================================================================================
# 生成されたリソースの属性を出力する例です。

# output "connect_hierarchy_structure_id" {
#   description = "The identifier of the hosting Amazon Connect Instance"
#   value       = aws_connect_user_hierarchy_structure.example.id
# }

# output "connect_hierarchy_level_one_arn" {
#   description = "The ARN of hierarchy level one"
#   value       = aws_connect_user_hierarchy_structure.example.hierarchy_structure[0].level_one[0].arn
# }

# output "connect_hierarchy_level_one_id" {
#   description = "The ID of hierarchy level one"
#   value       = aws_connect_user_hierarchy_structure.example.hierarchy_structure[0].level_one[0].id
# }

#================================================================================
# 補足情報
#================================================================================
# - Amazon Connect では、エージェントを効率的に管理するために階層構造を使用します
# - 階層レベルは上位から下位に向かって level_one → level_five の順に定義します
# - 階層レベルを削除すると、既存の連絡先へのリンクが切断され、元に戻せません
# - 階層構造を作成・管理するには「Users and Permissions - Agent hierarchy - Create」
#   権限が必要です
# - 階層グループは、階層レベル作成後に上位レベルから順に追加します
#
# 参考ドキュメント:
# - Amazon Connect User Hierarchy: https://docs.aws.amazon.com/connect/latest/adminguide/agent-hierarchy.html
# - HierarchyStructure API: https://docs.aws.amazon.com/connect/latest/APIReference/API_HierarchyStructure.html
# - UpdateUserHierarchyStructure API: https://docs.aws.amazon.com/connect/latest/APIReference/API_UpdateUserHierarchyStructure.html
# - DescribeUserHierarchyStructure API: https://docs.aws.amazon.com/connect/latest/APIReference/API_DescribeUserHierarchyStructure.html
#================================================================================
