#---------------------------------------------------------------
# AWS License Manager Grant
#---------------------------------------------------------------
#
# AWS License Managerのライセンスグラントをプロビジョニングするリソースです。
# グラントを使用することで、ライセンスを他のAWSアカウントと共有できます。
# グラントには許可する操作（allowed_operations）を指定し、
# 対象アカウントのルートユーザーARN（principal）を指定します。
#
# AWS公式ドキュメント:
#   - License Managerのグラント: https://docs.aws.amazon.com/license-manager/latest/userguide/granted-licenses.html
#   - グラントの配布: https://docs.aws.amazon.com/license-manager/latest/userguide/distribute-entitlement.html
#   - CreateGrant API: https://docs.aws.amazon.com/license-manager/latest/APIReference/API_Grant.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/licensemanager_grant
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_licensemanager_grant" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: グラントの名前を指定します。
  # 設定可能な値: 文字列
  name = "share-license-with-account"

  # license_arn (Required)
  # 設定内容: グラントするライセンスのARNを指定します。
  # 設定可能な値: 有効なLicense ManagerライセンスのARN
  # 参考: https://docs.aws.amazon.com/license-manager/latest/userguide/granted-licenses.html
  license_arn = "arn:aws:license-manager::111111111111:license:l-exampleARN"

  # principal (Required)
  # 設定内容: グラントの対象となるアカウントのルートユーザーARNを指定します。
  # 設定可能な値: 対象AWSアカウントのルートユーザーARN（例: arn:aws:iam::123456789012:root）
  # 参考: https://docs.aws.amazon.com/license-manager/latest/userguide/distribute-entitlement.html
  principal = "arn:aws:iam::111111111112:root"

  #-------------------------------------------------------------
  # 操作権限設定
  #-------------------------------------------------------------

  # allowed_operations (Required)
  # 設定内容: グラントで許可する操作のリストを指定します。
  #           ライセンスで許可された操作のサブセットである必要があります。
  # 設定可能な値:
  #   - "CreateGrant": 他のアカウントへのグラント作成を許可
  #   - "CheckoutLicense": ライセンスのチェックアウトを許可
  #   - "CheckoutBorrowLicense": ライセンスの借り出しチェックアウトを許可
  #   - "CheckInLicense": ライセンスのチェックインを許可
  #   - "ExtendConsumptionLicense": ライセンス消費の延長を許可
  #   - "ListPurchasedLicenses": 購入済みライセンスの一覧表示を許可
  #   - "CreateToken": トークンの作成を許可
  # 参考: https://docs.aws.amazon.com/license-manager/latest/APIReference/API_Grant.html
  allowed_operations = [
    "ListPurchasedLicenses",
    "CheckoutLicense",
    "CheckInLicense",
    "ExtendConsumptionLicense",
    "CreateToken",
  ]

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
# このリソースは以下の属性をエクスポートします:
#
# - id: グラントのARN（arnと同じ値）
# - arn: グラントのAmazon Resource Name (ARN)
# - home_region: グラントのホームリージョン
# - parent_arn: 親グラントのARN
# - status: グラントのステータス
#           (PENDING_WORKFLOW, PENDING_ACCEPT, REJECTED, ACTIVE,
#            FAILED_WORKFLOW, DELETED, PENDING_DELETE, DISABLED,
#            WORKFLOW_COMPLETED)
# - version: グラントのバージョン番号
#---------------------------------------------------------------
