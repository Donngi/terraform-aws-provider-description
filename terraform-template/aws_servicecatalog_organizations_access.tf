#---------------------------------------------------------------
# AWS Service Catalog Organizations Access
#---------------------------------------------------------------
#
# AWS Service CatalogとAWS Organizationsの統合を管理し、
# ポートフォリオ共有機能を組織全体で有効化するリソースです。
#
# このリソースは、Service Catalogが組織構造の更新を受け取り、
# 共有設定を最新の組織構造と同期できるようにします。
# AWS側で `organizations:EnableAWSServiceAccess` が自動的に設定され、
# 組織構造の変更に応じてポートフォリオ共有が同期されます。
#
# 重要な制限事項:
# - このリソースは組織の管理アカウントでのみ使用可能
# - 委任管理者アカウントでは使用不可
# - 一度無効化した後に再有効化すると、ポートフォリオアクセス権限が
#   組織構造の最新変更と同期されない可能性があるため注意が必要
#
# AWS公式ドキュメント:
#   - EnableAWSOrganizationsAccess API: https://docs.aws.amazon.com/servicecatalog/latest/dg/API_EnableAWSOrganizationsAccess.html
#   - ポートフォリオの共有方法: https://docs.aws.amazon.com/servicecatalog/latest/adminguide/catalogs_portfolios_sharing_how-to-share.html
#   - AWS Organizations統合: https://docs.aws.amazon.com/organizations/latest/userguide/services-that-can-integrate-servicecatalog.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/servicecatalog_organizations_access
#
# Provider Version: 6.28.0
# Generated: 2026-02-05
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_servicecatalog_organizations_access" "example" {
  #-------------------------------------------------------------
  # Organizations連携設定
  #-------------------------------------------------------------

  # enabled (Required)
  # 設定内容: AWS Organizations連携を有効化するかどうかを指定します。
  # 設定可能な値:
  #   - true: Service CatalogがAWS Organizationsの構造更新を受け取り、
  #           ポートフォリオ共有が組織構造と自動同期されます
  #   - false: Organizations連携を無効化します
  # 関連機能: Service Catalog Organizations統合
  #   このフラグを有効にすると、Service Catalogは自動的に
  #   `organizations:EnableAWSServiceAccess` APIを呼び出し、
  #   ポートフォリオの共有が組織の構造と同期されるようになります。
  #   組織単位（OU）やアカウントへのポートフォリオ共有が可能になります。
  #   - https://docs.aws.amazon.com/servicecatalog/latest/dg/API_EnableAWSOrganizationsAccess.html
  # 注意: 組織の管理アカウントでのみ設定可能。委任管理者アカウントでは使用できません。
  # 参考: https://docs.aws.amazon.com/organizations/latest/userguide/services-that-can-integrate-servicecatalog.html
  enabled = true

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト設定を指定します。
  # 設定可能な値: 各操作のタイムアウト時間（例: "60s", "5m", "1h"）
  # 省略時: デフォルトのタイムアウト値が使用されます
  timeouts {
    # read (Optional)
    # 設定内容: リソースの読み取り操作のタイムアウトを指定します。
    # 設定可能な値: 時間文字列（例: "60s", "5m", "1h"）
    # 省略時: 20m（20分）
    # 用途: 組織の規模が大きい場合や、API応答が遅い場合に
    #       タイムアウトを延長することで操作の成功率を向上できます
    read = "20m"
  }
}

#---------------------------------------------------------------
# Attributes Reference（参照専用の出力属性）
#---------------------------------------------------------------
#
# このリソースは以下の属性をエクスポートします:
#
# - id: このリソースを使用しているAWSアカウントのアカウントID
#       Terraform内で他のリソースから参照する際に使用可能です。
#
