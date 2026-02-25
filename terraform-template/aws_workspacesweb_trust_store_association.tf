#---------------------------------------------------------------
# AWS WorkSpaces Web Trust Store Association
#---------------------------------------------------------------
#
# Amazon WorkSpaces Secure Browserのトラストストアをウェブポータルに
# 関連付けるリソースです。トラストストアをポータルに関連付けることで、
# ストリーミングセッションが指定のカスタムCA証明書を信頼し、
# 社内サイトや自己署名証明書を使用するサイトへのアクセスを
# 安全に許可できます。
#
# AWS公式ドキュメント:
#   - トラストストアの構成: https://docs.aws.amazon.com/workspaces-web/latest/adminguide/trust-stores.html
#   - AssociateTrustStore API: https://docs.aws.amazon.com/workspaces-web/latest/APIReference/API_AssociateTrustStore.html
#   - TrustStore: https://docs.aws.amazon.com/workspaces-web/latest/APIReference/API_TrustStore.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/workspacesweb_trust_store_association
#
# Provider Version: 6.28.0
# Generated: 2026-02-22
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_workspacesweb_trust_store_association" "example" {
  #-------------------------------------------------------------
  # 関連付け設定
  #-------------------------------------------------------------

  # trust_store_arn (Required, Forces new resource)
  # 設定内容: ポータルに関連付けるトラストストアのARNを指定します。
  # 設定可能な値: 有効なWorkSpaces Webトラストストアが持つARN
  #   形式: arn:aws:workspaces-web:<region>:<account-id>:trustStore/<id>
  # 注意: 変更すると既存の関連付けが削除され、新しい関連付けが作成されます。
  #       トラストストアはaws_workspacesweb_trust_storeリソースで
  #       事前に作成されている必要があります。
  # 参考: https://docs.aws.amazon.com/workspaces-web/latest/APIReference/API_TrustStore.html
  trust_store_arn = "arn:aws:workspaces-web:ap-northeast-1:123456789012:trustStore/example-id"

  # portal_arn (Required, Forces new resource)
  # 設定内容: トラストストアを関連付けるWebポータルのARNを指定します。
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
# 入力として指定した trust_store_arn、portal_arn、region が
# そのまま参照可能です。
#---------------------------------------------------------------
