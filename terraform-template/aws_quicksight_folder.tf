# ==============================================================================
# Resource: aws_quicksight_folder
# Provider Version: 6.28.0
# ==============================================================================
# 説明:
#   QuickSightフォルダを管理するリソース。
#   QuickSightのダッシュボード、分析、データセットなどを整理するための
#   フォルダ構造を作成できます。
#
# ユースケース:
#   - QuickSightアセットの階層的な整理
#   - フォルダレベルでのアクセス権限管理
#   - チームやプロジェクトごとのコンテンツ分離
#
# 参考リンク:
#   - https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/quicksight_folder
#   - https://docs.aws.amazon.com/quicksight/latest/APIReference/API_CreateFolder.html
# ==============================================================================

# ------------------------------------------------------------------------------
# 基本的な使用例
# ------------------------------------------------------------------------------
resource "aws_quicksight_folder" "example" {
  # ----------------------------------------------------------------------------
  # 必須パラメータ
  # ----------------------------------------------------------------------------

  # folder_id (必須)
  # 説明: フォルダの識別子
  # タイプ: string
  # 制約: 新しいリソースの作成を強制
  # 例: "example-folder-id", "analytics-folder", "team-dashboard"
  folder_id = "example-folder-id"

  # ----------------------------------------------------------------------------
  # 準必須パラメータ（通常必要）
  # ----------------------------------------------------------------------------

  # name (準必須)
  # 説明: フォルダの表示名
  # タイプ: string
  # 注: UIに表示されるフォルダ名
  # 例: "Analytics Dashboards", "Sales Reports", "Team Folder"
  name = "Example Folder"

  # ----------------------------------------------------------------------------
  # オプションパラメータ
  # ----------------------------------------------------------------------------

  # aws_account_id (オプション)
  # 説明: AWSアカウントID
  # タイプ: string
  # デフォルト: Terraform AWSプロバイダーのアカウントIDを自動決定
  # 制約: 新しいリソースの作成を強制
  # 例: "123456789012"
  # aws_account_id = "123456789012"

  # folder_type (オプション)
  # 説明: フォルダのタイプ
  # タイプ: string
  # デフォルト: "SHARED"
  # 有効な値: "SHARED"
  # 注: 現在は共有フォルダのみサポート
  # folder_type = "SHARED"

  # parent_folder_arn (オプション)
  # 説明: 親フォルダのARN
  # タイプ: string
  # デフォルト: 設定しない場合、ルートレベルのフォルダが作成される
  # 注: フォルダの階層構造を作成する場合に使用
  # 例: "arn:aws:quicksight:us-east-1:123456789012:folder/parent-folder-id"
  # parent_folder_arn = aws_quicksight_folder.parent.arn

  # region (オプション)
  # 説明: このリソースが管理されるリージョン
  # タイプ: string
  # デフォルト: プロバイダー設定のリージョン
  # 例: "us-east-1", "ap-northeast-1"
  # region = "us-east-1"

  # tags (オプション)
  # 説明: リソースタグのキー/バリューマップ
  # タイプ: map(string)
  # 注: プロバイダーのdefault_tagsと統合される
  # 例: { Environment = "production", Team = "analytics" }
  # tags = {
  #   Environment = "production"
  #   Project     = "analytics"
  # }

  # ----------------------------------------------------------------------------
  # ネストされたブロック: permissions
  # ----------------------------------------------------------------------------
  # 説明: フォルダのリソース権限セット
  # 制約: 最大64項目

  # permissions {
  #   # actions (必須)
  #   # 説明: 許可または取り消すIAMアクションのリスト
  #   # タイプ: set(string)
  #   # 例: ["quicksight:DescribeFolder", "quicksight:UpdateFolder"]
  #   actions = [
  #     "quicksight:CreateFolder",
  #     "quicksight:DescribeFolder",
  #     "quicksight:UpdateFolder",
  #     "quicksight:DeleteFolder",
  #     "quicksight:CreateFolderMembership",
  #     "quicksight:DeleteFolderMembership",
  #     "quicksight:DescribeFolderPermissions",
  #     "quicksight:UpdateFolderPermissions",
  #   ]
  #
  #   # principal (必須)
  #   # 説明: プリンシパルのARN
  #   # タイプ: string
  #   # 注: ユーザー、グループ、またはロールのARN
  #   # 例: "arn:aws:quicksight:us-east-1:123456789012:user/default/user-name"
  #   # 参考: https://docs.aws.amazon.com/quicksight/latest/APIReference/API_ResourcePermission.html
  #   principal = "arn:aws:quicksight:us-east-1:123456789012:user/default/example-user"
  # }

  # ----------------------------------------------------------------------------
  # ネストされたブロック: timeouts
  # ----------------------------------------------------------------------------
  # 説明: リソース操作のタイムアウト設定

  # timeouts {
  #   # create (オプション)
  #   # 説明: リソース作成のタイムアウト
  #   # タイプ: string
  #   # 例: "5m", "30s"
  #   create = "5m"
  #
  #   # read (オプション)
  #   # 説明: リソース読み取りのタイムアウト
  #   # タイプ: string
  #   read = "5m"
  #
  #   # update (オプション)
  #   # 説明: リソース更新のタイムアウト
  #   # タイプ: string
  #   update = "5m"
  #
  #   # delete (オプション)
  #   # 説明: リソース削除のタイムアウト
  #   # タイプ: string
  #   delete = "5m"
  # }
}

# ==============================================================================
# 属性リファレンス (読み取り専用)
# ==============================================================================
# 以下の属性はリソース作成後に参照可能です:
#
# - arn (string)
#     フォルダのARN
#     例: output "folder_arn" { value = aws_quicksight_folder.example.arn }
#
# - created_time (string)
#     フォルダが作成された時刻
#     例: output "folder_created_time" { value = aws_quicksight_folder.example.created_time }
#
# - folder_path (list(string))
#     フォルダの祖先ARN文字列の配列
#     注: ルートレベルのフォルダの場合は空
#     例: output "folder_path" { value = aws_quicksight_folder.example.folder_path }
#
# - id (string)
#     AWSアカウントIDとフォルダIDをカンマで結合した文字列
#     例: "123456789012,example-folder-id"
#     例: output "folder_id" { value = aws_quicksight_folder.example.id }
#
# - last_updated_time (string)
#     フォルダが最後に更新された時刻
#     例: output "folder_last_updated" { value = aws_quicksight_folder.example.last_updated_time }
#
# - tags_all (map(string))
#     リソースに割り当てられたタグのマップ
#     注: プロバイダーのdefault_tagsから継承されたタグを含む
#     例: output "folder_tags_all" { value = aws_quicksight_folder.example.tags_all }
# ==============================================================================


# ==============================================================================
# 使用例: 権限付きフォルダ
# ==============================================================================
# resource "aws_quicksight_folder" "with_permissions" {
#   folder_id = "analytics-folder"
#   name      = "Analytics Team Folder"
#
#   permissions {
#     actions = [
#       "quicksight:CreateFolder",
#       "quicksight:DescribeFolder",
#       "quicksight:UpdateFolder",
#       "quicksight:DeleteFolder",
#       "quicksight:CreateFolderMembership",
#       "quicksight:DeleteFolderMembership",
#       "quicksight:DescribeFolderPermissions",
#       "quicksight:UpdateFolderPermissions",
#     ]
#     principal = aws_quicksight_user.analytics_user.arn
#   }
#
#   tags = {
#     Team        = "Analytics"
#     Environment = "Production"
#   }
# }
# ==============================================================================


# ==============================================================================
# 使用例: 親フォルダ付きの階層構造
# ==============================================================================
# resource "aws_quicksight_folder" "parent" {
#   folder_id = "parent-folder"
#   name      = "Parent Folder"
# }
#
# resource "aws_quicksight_folder" "child" {
#   folder_id = "child-folder"
#   name      = "Child Folder"
#
#   parent_folder_arn = aws_quicksight_folder.parent.arn
#
#   tags = {
#     ParentFolder = aws_quicksight_folder.parent.name
#   }
# }
# ==============================================================================


# ==============================================================================
# 使用例: 複数の権限設定
# ==============================================================================
# resource "aws_quicksight_folder" "team_folder" {
#   folder_id = "team-shared-folder"
#   name      = "Team Shared Folder"
#
#   # 管理者権限
#   permissions {
#     actions = [
#       "quicksight:CreateFolder",
#       "quicksight:DescribeFolder",
#       "quicksight:UpdateFolder",
#       "quicksight:DeleteFolder",
#       "quicksight:CreateFolderMembership",
#       "quicksight:DeleteFolderMembership",
#       "quicksight:DescribeFolderPermissions",
#       "quicksight:UpdateFolderPermissions",
#     ]
#     principal = aws_quicksight_user.admin.arn
#   }
#
#   # 読み取り専用権限
#   permissions {
#     actions = [
#       "quicksight:DescribeFolder",
#       "quicksight:DescribeFolderPermissions",
#     ]
#     principal = aws_quicksight_group.viewers.arn
#   }
#
#   tags = {
#     Team        = "Data Science"
#     Environment = "Production"
#     ManagedBy   = "Terraform"
#   }
# }
# ==============================================================================


# ==============================================================================
# 注意事項とベストプラクティス
# ==============================================================================
# 1. フォルダIDの命名
#    - 一意で意味のある名前を使用
#    - 英数字、ハイフン、アンダースコアのみ使用推奨
#
# 2. 権限管理
#    - 最小権限の原則に従う
#    - 必要な権限のみを付与
#    - グループベースの権限管理を推奨
#
# 3. 階層構造
#    - 深すぎる階層は避ける（3-4レベルまで推奨）
#    - 論理的な構造を維持
#
# 4. タグ戦略
#    - 一貫性のあるタグ付け規則を使用
#    - コスト管理やリソース追跡のためにタグを活用
#
# 5. リソース削除
#    - フォルダを削除する前に、フォルダ内のすべてのアセットを確認
#    - 空のフォルダのみ削除可能
#
# 6. リージョン設定
#    - QuickSightはリージョン固有のサービス
#    - リソースのリージョンを明示的に管理
# ==============================================================================
