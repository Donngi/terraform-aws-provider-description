#---------------------------------------------------------------
# AWS WorkSpaces Web Network Settings Association
#---------------------------------------------------------------
#
# Amazon WorkSpaces Secure Browserのネットワーク設定をWebポータルに
# 関連付けるリソースです。ネットワーク設定をポータルに関連付けることで、
# ストリーミングインスタンスが指定されたVPC・サブネット・セキュリティグループを
# 通じてネットワーク接続を確立できるようになります。
#
# AWS公式ドキュメント:
#   - ネットワーク設定の構成: https://docs.aws.amazon.com/workspaces-web/latest/adminguide/network-settings.html
#   - AssociateNetworkSettings API: https://docs.aws.amazon.com/workspaces-web/latest/APIReference/API_AssociateNetworkSettings.html
#   - NetworkSettings: https://docs.aws.amazon.com/workspaces-web/latest/APIReference/API_NetworkSettings.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/workspacesweb_network_settings_association
#
# Provider Version: 6.28.0
# Generated: 2026-02-06
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_workspacesweb_network_settings_association" "example" {
  #-------------------------------------------------------------
  # 関連付け設定
  #-------------------------------------------------------------

  # network_settings_arn (Required, Forces new resource)
  # 設定内容: ポータルに関連付けるネットワーク設定のARNを指定します。
  # 設定可能な値: 有効なWorkSpaces Webネットワーク設定のARN
  #   形式: arn:aws:workspaces-web:<region>:<account-id>:networkSettings/<id>
  # 注意: 変更すると既存の関連付けが削除され、新しい関連付けが作成されます。
  #       ネットワーク設定はaws_workspacesweb_network_settingsリソースで
  #       事前に作成されている必要があります。
  # 参考: https://docs.aws.amazon.com/workspaces-web/latest/APIReference/API_NetworkSettings.html
  network_settings_arn = "arn:aws:workspaces-web:ap-northeast-1:123456789012:networkSettings/example-id"

  # portal_arn (Required, Forces new resource)
  # 設定内容: ネットワーク設定を関連付けるWebポータルのARNを指定します。
  # 設定可能な値: 有効なWorkSpaces WebポータルのARN
  #   形式: arn:aws:workspaces-web:<region>:<account-id>:portal/<id>
  # 注意: 変更すると既存の関連付けが削除され、新しい関連付けが作成されます。
  #       ポータルはaws_workspacesweb_portalリソースで事前に作成されている
  #       必要があります。
  # 参考: https://docs.aws.amazon.com/workspaces-web/latest/adminguide/getting-started-step1.html
  portal_arn = "arn:aws:workspaces-web:ap-northeast-1:123456789012:portal/example-id"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは追加の読み取り専用属性をエクスポートしません。
# 入力として指定した network_settings_arn、portal_arn、region が
# そのまま参照可能です。
#---------------------------------------------------------------
