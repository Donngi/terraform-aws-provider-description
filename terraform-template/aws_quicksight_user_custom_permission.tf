#---------------------------------------------------------------
# QuickSight ユーザーカスタム権限プロファイル
#---------------------------------------------------------------
#
# QuickSightユーザーにカスタム権限プロファイルを割り当てるリソースです。
# カスタム権限プロファイルを使用することで、特定のユーザーに対してQuickSightアプリケーション内の
# 機能へのアクセスを制限できます（例: データのExcel/CSV出力の無効化、アセット共有の制限など）。
# IAM Identity Centerユーザーを含むすべてのIDタイプに対応しています。
#
# AWS公式ドキュメント:
#   - UpdateUserCustomPermission API: https://docs.aws.amazon.com/quicksight/latest/APIReference/API_UpdateUserCustomPermission.html
#   - カスタム権限プロファイル: https://docs.aws.amazon.com/quicksight/latest/APIReference/API_CustomPermissions.html
#   - QuickSight アクセス制御: https://docs.aws.amazon.com/quicksight/latest/APIReference/controlling-access.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/quicksight_user_custom_permission
#
# Provider Version: 6.28.0
# Generated: 2026-02-04
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_quicksight_user_custom_permission" "example" {
  #---------------------------------------------------------------
  # 必須パラメータ
  #---------------------------------------------------------------

  # カスタム権限プロファイル名
  # - 事前に作成済みのカスタム権限プロファイルの名前を指定します
  # - aws_quicksight_custom_permissions リソースで作成したプロファイル名を参照します
  # - Forces new resource: この値を変更すると、リソースが再作成されます
  # - 長さ制限: 1〜64文字
  # - 使用可能文字: 英数字、+, =, ,, ., @, _, -
  custom_permissions_name = "example-custom-permissions"

  # ユーザー名
  # - カスタム権限プロファイルを割り当てる対象のQuickSightユーザー名を指定します
  # - aws_quicksight_user リソースで作成したユーザー名を参照します
  # - Forces new resource: この値を変更すると、リソースが再作成されます
  # - 長さ制限: 最小1文字
  # - 使用可能文字: Unicode文字 (\u0020-\u00FF)
  user_name = "example-user"

  #---------------------------------------------------------------
  # オプションパラメータ
  #---------------------------------------------------------------

  # AWSアカウントID
  # - カスタム権限設定を更新するAWSアカウントのIDを指定します
  # - 指定しない場合: Terraform AWSプロバイダーで自動判定されたアカウントIDが使用されます
  # - Forces new resource: この値を変更すると、リソースが再作成されます
  # - 形式: 12桁の数字
  # aws_account_id = "123456789012"

  # 名前空間
  # - ユーザーが属するQuickSightの名前空間を指定します
  # - デフォルト: "default"
  # - Forces new resource: この値を変更すると、リソースが再作成されます
  # - 長さ制限: 最大64文字
  # - 使用可能文字: 英数字、., _, -
  # namespace = "default"

  # リージョン
  # - このリソースを管理するAWSリージョンを指定します
  # - 指定しない場合: プロバイダー設定のリージョンが使用されます
  # - リージョナルエンドポイント: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-east-1"
}

#---------------------------------------------------------------
# Attributes Reference
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします（computed only、入力不可）:
#
# (なし - このリソースはcomputed only属性を持ちません)
#
#---------------------------------------------------------------
