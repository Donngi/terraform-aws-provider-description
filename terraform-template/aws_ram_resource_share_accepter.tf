#---------------------------------------------------------------
# AWS Resource Access Manager (RAM) Resource Share Accepter
#---------------------------------------------------------------
#
# AWS Resource Access Manager (RAM) のリソース共有招待を受け入れるためのリソースです。
# 受信側のAWSアカウントから、送信側のAWSアカウントが共有したリソースへの
# アクセスを許可する招待を受け入れます。
#
# 注意: 両方のAWSアカウントが同じOrganizationに属しており、
#       AWS OrganizationsとのRAM共有が有効になっている場合、
#       このリソースは不要です（RAM Resource Share招待が使用されないため）。
#       https://docs.aws.amazon.com/ram/latest/userguide/getting-started-sharing.html#getting-started-sharing-orgs
#
# AWS公式ドキュメント:
#   - RAM概要: https://docs.aws.amazon.com/ram/latest/userguide/what-is.html
#   - RAMリソース共有: https://docs.aws.amazon.com/ram/latest/userguide/getting-started-sharing.html
#   - 共有可能なリソース: https://docs.aws.amazon.com/ram/latest/userguide/shareable.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ram_resource_share_accepter
#
# Provider Version: 6.28.0
# Generated: 2026-02-03
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_ram_resource_share_accepter" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # share_arn (Required)
  # 設定内容: 受け入れるリソース共有のARNを指定します。
  # 設定可能な値: 有効なRAMリソース共有のARN
  # 注意: 送信側アカウントから共有されたリソースのARNを指定してください。
  #       通常、aws_ram_principal_associationリソースのresource_share_arn属性から取得します。
  share_arn = "arn:aws:ram:us-east-1:123456789012:resource-share/12345678-1234-1234-1234-123456789012"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソースの作成・削除操作のタイムアウトを指定します。
  timeouts {
    # create (Optional)
    # 設定内容: リソース共有招待の受け入れ操作のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列（例: "5m", "1h"）
    # 省略時: デフォルトタイムアウト（5分）が適用されます
    create = "5m"

    # delete (Optional)
    # 設定内容: リソース共有招待の削除（拒否）操作のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列（例: "5m", "1h"）
    # 省略時: デフォルトタイムアウト（5分）が適用されます
    delete = "5m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - invitation_arn: リソース共有招待のARN
#
# - share_id: コンソールに表示されるリソース共有のID
#
# - status: リソース共有のステータス
#   値: ACTIVE, PENDING, FAILED, DELETING, DELETED
#
# - receiver_account_id: 招待を受け入れる受信側アカウントのアカウントID
#
# - sender_account_id: 招待を送信する送信側アカウントのアカウントID
#
# - share_name: リソース共有の名前
#
# - resources: リソース共有経由で共有されるリソースのARNのリスト
#---------------------------------------------------------------

#---------------------------------------------------------------
# 以下は、送信側アカウントと受信側アカウント間でリソースを共有する
# 完全な例です。
#
#---------------------------------------------------------------
