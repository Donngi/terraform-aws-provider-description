#---------------------------------------------------------------
# AWS WorkSpaces Web Data Protection Settings Association
#---------------------------------------------------------------
#
# Amazon WorkSpaces Secure Browser（WorkSpaces Web）のポータルに
# データ保護設定を関連付けるリソースです。
# データ保護設定はインラインデータ編集（マスキング）等の機能を提供し、
# セッション中の機密データ漏洩を防ぎます。
#
# AWS公式ドキュメント:
#   - データ保護設定の関連付け: https://docs.aws.amazon.com/workspaces-web/latest/adminguide/associate-data-protection-settings.html
#   - データ保護設定の管理: https://docs.aws.amazon.com/workspaces-web/latest/adminguide/data-protection-settings.html
#   - AssociateDataProtectionSettings API: https://docs.aws.amazon.com/workspaces-web/latest/APIReference/API_AssociateDataProtectionSettings.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/workspacesweb_data_protection_settings_association
#
# Provider Version: 6.28.0
# Generated: 2026-02-22
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_workspacesweb_data_protection_settings_association" "example" {
  #-------------------------------------------------------------
  # 関連付け設定
  #-------------------------------------------------------------

  # data_protection_settings_arn (Required, Forces new resource)
  # 設定内容: ポータルに関連付けるデータ保護設定のARNを指定します。
  # 設定可能な値: 有効なデータ保護設定のARN（20〜2048文字）
  # 参考: https://docs.aws.amazon.com/workspaces-web/latest/adminguide/create-data-protection-settings.html
  data_protection_settings_arn = "arn:aws:workspaces-web:ap-northeast-1:123456789012:dataProtectionSettings/example"

  # portal_arn (Required, Forces new resource)
  # 設定内容: データ保護設定を関連付けるWebポータルのARNを指定します。
  # 設定可能な値: 有効なWorkSpaces WebポータルのARN（20〜2048文字）
  # 参考: https://docs.aws.amazon.com/workspaces-web/latest/APIReference/API_AssociateDataProtectionSettings.html
  portal_arn = "arn:aws:workspaces-web:ap-northeast-1:123456789012:portal/example"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するAWSリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用します。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: ポータルARNとデータ保護設定ARNを組み合わせたリソースID
#---------------------------------------------------------------
