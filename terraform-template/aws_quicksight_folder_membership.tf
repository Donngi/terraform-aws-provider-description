#---------------------------------------------------------------
# Amazon QuickSight フォルダメンバーシップ
#---------------------------------------------------------------
#
# Amazon QuickSightのフォルダ内にダッシュボード、分析、データセットなどの
# アセットを追加するためのリソースです。
# フォルダメンバーシップを管理することで、QuickSightアセットを
# 論理的にグループ化して整理できます。
#
# AWS公式ドキュメント:
#   - フォルダメンバーシップ操作: https://docs.aws.amazon.com/quicksight/latest/developerguide/folder-membership.html
#   - CreateFolderMembership API: https://docs.aws.amazon.com/quicksight/latest/APIReference/API_CreateFolderMembership.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/quicksight_folder_membership
#
# Provider Version: 6.28.0
# Generated: 2026-02-04
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_quicksight_folder_membership" "example" {
  #---------------------------------------------------------------
  # 必須パラメータ
  #---------------------------------------------------------------

  # フォルダID
  # QuickSightフォルダのIDを指定します。
  # このフォルダにアセットが追加されます。
  # フォルダIDはフォルダのURLから取得するか、aws_quicksight_folderリソースの
  # folder_id属性を参照できます。
  # 変更すると新しいリソースが作成されます（Forces new resource）。
  #
  # 型: string
  # 例: "example-folder-id"
  folder_id = "example-folder-id"

  # メンバーID
  # フォルダに追加するアセット（ダッシュボード、分析、データセット）のIDを指定します。
  # アセットのIDはURLから取得するか、以下のAPIオペレーションで取得できます:
  # - ListAnalyses
  # - ListDashboards
  # - ListDataSets
  # 変更すると新しいリソースが作成されます（Forces new resource）。
  #
  # 型: string
  # 例: "example-dataset-id"
  member_id = "example-dataset-id"

  # メンバータイプ
  # フォルダに追加するアセットのタイプを指定します。
  # 指定可能な値:
  # - ANALYSIS: 分析
  # - DASHBOARD: ダッシュボード
  # - DATASET: データセット
  # 変更すると新しいリソースが作成されます（Forces new resource）。
  #
  # 型: string
  # 例: "DATASET", "DASHBOARD", "ANALYSIS"
  member_type = "DATASET"

  #---------------------------------------------------------------
  # オプションパラメータ
  #---------------------------------------------------------------

  # AWSアカウントID
  # QuickSightフォルダメンバーシップを作成するAWSアカウントのIDを指定します。
  # 指定しない場合、Terraform AWSプロバイダーで設定されているアカウントIDが
  # 自動的に使用されます。
  # 変更すると新しいリソースが作成されます（Forces new resource）。
  #
  # 型: string
  # デフォルト: プロバイダーのアカウントID
  # 例: "123456789012"
  # aws_account_id = "123456789012"

  # リージョン
  # このリソースを管理するAWSリージョンを指定します。
  # 指定しない場合、プロバイダー設定で指定されたリージョンが使用されます。
  # リージョナルエンドポイントの詳細については、AWS公式ドキュメントを参照してください。
  # 変更すると新しいリソースが作成されます（Forces new resource）。
  #
  # 型: string
  # デフォルト: プロバイダーのリージョン
  # 例: "us-east-1", "ap-northeast-1"
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-east-1"
}

#---------------------------------------------------------------
# Attributes Reference (参照専用属性)
#---------------------------------------------------------------
# このリソースでは以下の属性が参照可能です（computed only）:
#
# - id (string)
#   リソースのID。以下の形式で出力されます:
#   "AWSアカウントID,フォルダID,メンバータイプ,メンバーID"
#   例: "123456789012,example-folder-id,DATASET,example-dataset-id"
#
#---------------------------------------------------------------
