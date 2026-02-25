#---------------------------------------------------------------
# AWS IAM Security Token Service Preferences
#---------------------------------------------------------------
#
# AWS STSグローバルエンドポイントのトークンバージョン設定を管理するリソースです。
# AWSアカウントのSTSグローバルエンドポイント（sts.amazonaws.com）が発行する
# セッショントークンのバージョンを指定します。
# v1Tokenはデフォルトリージョンのみで有効、v2Tokenは全リージョンで有効です。
#
# AWS公式ドキュメント:
#   - STSグローバルエンドポイントの管理: https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_temp_enable-regions.html
#   - SetSecurityTokenServicePreferences API: https://docs.aws.amazon.com/IAM/latest/APIReference/API_SetSecurityTokenServicePreferences.html
#   - AWS STSリージョンとエンドポイント: https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_temp_region-endpoints.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_security_token_service_preferences
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_iam_security_token_service_preferences" "example" {
  #-------------------------------------------------------------
  # グローバルエンドポイントトークンバージョン設定
  #-------------------------------------------------------------

  # global_endpoint_token_version (Required)
  # 設定内容: STSグローバルエンドポイントが発行するセッショントークンのバージョンを指定します。
  # 設定可能な値:
  #   - "v1Token": バージョン1トークン。デフォルトで有効化されているAWSリージョンでのみ有効。
  #               文字数が少ないため既存システムとの互換性が高い。
  #   - "v2Token": バージョン2トークン。全リージョン（オプトインリージョン含む）で有効。
  #               v1Tokenより文字数が多いため、トークン長に上限がある場合は注意が必要。
  # 注意: v2Tokenに変更すると既存システムのトークン長制限に影響する可能性があります。
  #       リージョナルエンドポイントの使用を推奨します。
  # 参考: https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_temp_enable-regions.html
  global_endpoint_token_version = "v2Token"
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: AWSアカウントID
#---------------------------------------------------------------
