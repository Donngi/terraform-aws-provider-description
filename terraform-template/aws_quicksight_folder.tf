#---------------------------------------------------------------
# Amazon QuickSight フォルダー
#---------------------------------------------------------------
#
# Amazon QuickSight のフォルダーをプロビジョニングするリソースです。
# フォルダーはダッシュボード、分析、データセット等の QuickSight アセットを
# 階層的に整理・管理するための組織構造です。
# フォルダーには共有フォルダーと制限付き共有フォルダーがあり、
# チームメンバー間でのコラボレーションとアクセス制御を提供します。
#
# AWS公式ドキュメント:
#   - QuickSight フォルダー概要: https://docs.aws.amazon.com/quicksight/latest/user/folders.html
#   - フォルダー操作 API: https://docs.aws.amazon.com/quicksight/latest/developerguide/folder-operations.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/quicksight_folder
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_quicksight_folder" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # folder_id (Required, Forces new resource)
  # 設定内容: フォルダーの一意な識別子を指定します。
  # 設定可能な値: 英数字、ハイフン、アンダースコアを含む文字列
  # 注意: このフィールドはリソース作成後に変更できません。
  folder_id = "example-folder-id"

  # name (Optional)
  # 設定内容: フォルダーの表示名を指定します。
  # 設定可能な値: 文字列
  name = "example-folder-name"

  #-------------------------------------------------------------
  # アカウント・リージョン設定
  #-------------------------------------------------------------

  # aws_account_id (Optional, Forces new resource)
  # 設定内容: フォルダーを作成する AWS アカウント ID を指定します。
  # 設定可能な値: 有効な 12 桁の AWS アカウント ID
  # 省略時: Terraform AWS プロバイダーが自動的に判定したアカウント ID を使用
  # 注意: このフィールドはリソース作成後に変更できません。
  aws_account_id = null

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効な AWS リージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # フォルダー構造設定
  #-------------------------------------------------------------

  # folder_type (Optional)
  # 設定内容: フォルダーの種類を指定します。
  # 設定可能な値:
  #   - "SHARED" (デフォルト): 共有フォルダー。チームメンバーとアセットを共有可能
  # 省略時: "SHARED"
  # 参考: https://docs.aws.amazon.com/quicksight/latest/APIReference/API_Folder.html
  folder_type = "SHARED"

  # parent_folder_arn (Optional)
  # 設定内容: 親フォルダーの Amazon Resource Name (ARN) を指定します。
  # 設定可能な値: 有効な QuickSight フォルダーの ARN
  # 省略時: ルートレベルのフォルダーとして作成されます。
  parent_folder_arn = null

  #-------------------------------------------------------------
  # アクセス権限設定
  #-------------------------------------------------------------

  # permissions (Optional)
  # 設定内容: フォルダーのリソース権限セットを指定します。最大 64 件設定可能です。
  # 関連機能: QuickSight リソース権限
  #   ユーザーまたはグループに対して QuickSight アクションの許可または拒否を設定します。
  #   フォルダーに関連するアクションには CreateFolder, DescribeFolder, UpdateFolder,
  #   DeleteFolder, CreateFolderMembership, DeleteFolderMembership,
  #   DescribeFolderPermissions, UpdateFolderPermissions 等があります。
  #   - https://docs.aws.amazon.com/quicksight/latest/APIReference/API_ResourcePermission.html
  permissions {
    # actions (Required)
    # 設定内容: 許可または拒否する IAM アクションのリストを指定します。
    # 設定可能な値: QuickSight フォルダー関連の IAM アクション文字列のセット
    #   例: "quicksight:CreateFolder", "quicksight:DescribeFolder",
    #       "quicksight:UpdateFolder", "quicksight:DeleteFolder",
    #       "quicksight:CreateFolderMembership", "quicksight:DeleteFolderMembership",
    #       "quicksight:DescribeFolderPermissions", "quicksight:UpdateFolderPermissions"
    actions = [
      "quicksight:DescribeFolder",
    ]

    # principal (Required)
    # 設定内容: 権限を付与するプリンシパルの ARN を指定します。
    # 設定可能な値: QuickSight ユーザーまたはグループの ARN
    # 参考: https://docs.aws.amazon.com/quicksight/latest/APIReference/API_ResourcePermission.html
    principal = "arn:aws:quicksight:ap-northeast-1:123456789012:user/default/example-user"
  }

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 省略時: タグなし
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルの default_tags 設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "example-folder"
    Environment = "production"
    ManagedBy   = "terraform"
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  timeouts {
    # create (Optional)
    # 設定内容: リソース作成操作のタイムアウト時間を指定します。
    # 設定可能な値: "60s", "5m", "1h" 等の時間文字列
    # 省略時: プロバイダーのデフォルトタイムアウトを使用
    create = null

    # read (Optional)
    # 設定内容: リソース読み取り操作のタイムアウト時間を指定します。
    # 設定可能な値: "60s", "5m", "1h" 等の時間文字列
    # 省略時: プロバイダーのデフォルトタイムアウトを使用
    read = null

    # update (Optional)
    # 設定内容: リソース更新操作のタイムアウト時間を指定します。
    # 設定可能な値: "60s", "5m", "1h" 等の時間文字列
    # 省略時: プロバイダーのデフォルトタイムアウトを使用
    update = null

    # delete (Optional)
    # 設定内容: リソース削除操作のタイムアウト時間を指定します。
    # 設定可能な値: "60s", "5m", "1h" 等の時間文字列
    # 省略時: プロバイダーのデフォルトタイムアウトを使用
    delete = null
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: フォルダーの Amazon Resource Name (ARN)
# - created_time: フォルダーが作成された時刻
# - folder_path: フォルダーの祖先 ARN 文字列の配列。ルートレベルのフォルダーの場合は空
# - id: AWS アカウント ID とフォルダー ID をカンマで連結した文字列
# - last_updated_time: フォルダーが最後に更新された時刻
# - tags_all: プロバイダーの default_tags 設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
