#---------------------------------------------------------------
# EMR Studio Session Mapping
#---------------------------------------------------------------
#
# EMR Studioへのユーザーまたはグループのアクセスマッピングを管理します。
# IAM Identity Center（旧AWS SSO）のユーザー/グループに対して、
# 特定のEMR Studioへのアクセス権限とセッションポリシーを関連付けます。
#
# ユースケース:
#   - EMR Studioへの細かいアクセス制御の実装
#   - IAM Identity Centerユーザーのスタジオへのマッピング
#   - ユーザー/グループごとの異なる権限レベルの設定
#
# AWS公式ドキュメント:
#   - Assign and manage EMR Studio users: https://docs.aws.amazon.com/emr/latest/ManagementGuide/emr-studio-manage-users.html
#   - CreateStudioSessionMapping API: https://docs.aws.amazon.com/emr/latest/APIReference/API_CreateStudioSessionMapping.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/emr_studio_session_mapping
#
# Provider Version: 6.28.0
# Generated: 2026-01-27
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_emr_studio_session_mapping" "example" {
  #---------------------------------------------------------------
  # Required Parameters
  #---------------------------------------------------------------

  # EMR StudioのID
  # - EMR Studioリソースから取得するか、既存のStudio IDを指定
  # - 例: aws_emr_studio.example.id
  studio_id = "s-XXXXXXXXXXXX"

  # マッピング対象のアイデンティティタイプ
  # - 許可される値:
  #   - "USER": IAM Identity Centerの個別ユーザー
  #   - "GROUP": IAM Identity Centerのグループ
  # - グループを使用すると複数ユーザーへの一括権限付与が可能
  identity_type = "USER"

  # セッションポリシーのARN
  # - このユーザー/グループに適用されるIAMポリシーのARN
  # - EMR Studio内での実行可能なアクション（クラスター作成等）を制御
  # - 最終的な権限はStudioユーザーロールとこのセッションポリシーの交差
  # - 例: arn:aws:iam::123456789012:policy/EMRStudio_Advanced_User_Policy
  #
  # 注意: ユーザーロールのARNではなく、セッションポリシーのARNを指定する
  session_policy_arn = "arn:aws:iam::123456789012:policy/EMRStudioSessionPolicy"

  #---------------------------------------------------------------
  # Optional Parameters
  #---------------------------------------------------------------

  # IAM Identity Storeからのユーザー/グループID（グローバル一意識別子）
  # - identity_idまたはidentity_nameのいずれか一方を指定
  # - Identity Store APIから取得可能なGUID形式のID
  # - 例: 1234567890-abcdef01-2345-6789-0abc-def012345678
  # identity_id = null

  # IAM Identity Storeからのユーザー/グループ名
  # - identity_idまたはidentity_nameのいずれか一方を指定
  # - ユーザーの場合: UserName（例: john.doe@example.com）
  # - グループの場合: DisplayName（例: DataAnalytics）
  identity_name = "user@example.com"

  # このリソースを管理するAWSリージョン
  # - 指定しない場合、プロバイダー設定のリージョンを使用
  # - EMR Studioが存在するリージョンと一致させる必要あり
  # region = null

  # リソースID（主にインポート時に使用）
  # - Terraformが自動生成するため、通常は指定不要
  # - インポート時のみ明示的に指定する場合がある
  # id = null
}

#---------------------------------------------------------------
# Attributes Reference
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id - EMR Studio Session Mappingの一意識別子

#---------------------------------------------------------------
# 使用例
#---------------------------------------------------------------
# resource "aws_emr_studio_session_mapping" "data_scientist" {
#   studio_id          = aws_emr_studio.example.id
#   identity_type      = "USER"
#   identity_name      = "data.scientist@example.com"
#   session_policy_arn = aws_iam_policy.advanced_user.arn
# }
#
# resource "aws_emr_studio_session_mapping" "analytics_team" {
#   studio_id          = aws_emr_studio.example.id
#   identity_type      = "GROUP"
#   identity_name      = "DataAnalyticsTeam"
#   session_policy_arn = aws_iam_policy.basic_user.arn
# }

#---------------------------------------------------------------
# 関連リソース
#---------------------------------------------------------------
# - aws_emr_studio: EMR Studioの作成
# - aws_iam_policy: セッションポリシーの定義
