################################################################################
# AWS License Manager Grant
# https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/licensemanager_grant
#
# AWS License Manager Grantを使用して、ライセンスを他のAWSアカウントと共有できます。
# これにより、組織内の複数のアカウント間でライセンスの配布と管理を効率化できます。
################################################################################

resource "aws_licensemanager_grant" "example" {
  # ----------------------------------------------------------------------------
  # 必須パラメータ
  # ----------------------------------------------------------------------------

  # グラント名
  # 説明: グラントを識別するための名前
  # 用途: 他のAWSアカウントとライセンスを共有する際の識別子として使用
  # 例: "share-license-with-dev-account", "production-license-grant"
  name = "share-license-with-account"

  # 許可される操作
  # 説明: グラント先のアカウントに許可する操作のリスト
  # 用途: ライセンスに対して実行可能な操作を制限
  # 有効な値:
  #   - ListPurchasedLicenses: 購入済みライセンスの一覧表示
  #   - CheckoutLicense: ライセンスのチェックアウト（使用開始）
  #   - CheckInLicense: ライセンスのチェックイン（使用終了）
  #   - ExtendConsumptionLicense: ライセンス消費期間の延長
  #   - CreateToken: ライセンストークンの作成
  # 注意: 必要最小限の権限のみを付与することを推奨
  allowed_operations = [
    "ListPurchasedLicenses",
    "CheckoutLicense",
    "CheckInLicense",
    "ExtendConsumptionLicense",
    "CreateToken"
  ]

  # ライセンスARN
  # 説明: 共有するライセンスのARN
  # 用途: License Managerで管理されているライセンスを特定
  # 形式: arn:aws:license-manager::ACCOUNT_ID:license:LICENSE_ID
  # 注意: 有効なライセンスARNを指定する必要があります
  license_arn = "arn:aws:license-manager::111111111111:license:l-exampleARN"

  # プリンシパル
  # 説明: グラント先のターゲットアカウントのARN
  # 用途: ライセンスを共有する相手のAWSアカウントを指定
  # 形式: arn:aws:iam::ACCOUNT_ID:root
  # 例:
  #   - "arn:aws:iam::123456789012:root" (特定のアカウント)
  #   - 組織単位でのライセンス共有の場合も個別のアカウントARNを指定
  principal = "arn:aws:iam::111111111112:root"

  # ホームリージョン
  # 説明: ライセンスのホームリージョン
  # 用途: ライセンスが作成されたリージョンを指定
  # 注意: ライセンスが存在するリージョンと一致する必要があります
  # 例: "us-east-1", "eu-west-1", "ap-northeast-1"
  home_region = "us-east-1"

  # ----------------------------------------------------------------------------
  # オプションパラメータ
  # ----------------------------------------------------------------------------

  # リージョン
  # 説明: このリソースが管理されるリージョン
  # 用途: 特定のリージョンでリソースを管理する場合に指定
  # デフォルト: プロバイダー設定のリージョン
  # 注意: 通常はhome_regionと同じ値を使用
  # region = "us-east-1"

  # ----------------------------------------------------------------------------
  # 計算される属性（読み取り専用）
  # ----------------------------------------------------------------------------

  # 以下の属性はTerraformによって自動的に設定されます:
  #
  # id         - グラントのARN（arnと同じ値）
  # arn        - グラントのARN
  #              形式: arn:aws:license-manager::ACCOUNT_ID:grant:GRANT_ID
  # parent_arn - 親ライセンスのARN
  # status     - グラントのステータス
  #              値: ACTIVE, DELETED, DISABLED, FAILED_WORKFLOW, PENDING_ACCEPT, PENDING_DELETE, REJECTED, WORKFLOW_COMPLETED
  # version    - グラントのバージョン番号

  # ----------------------------------------------------------------------------
  # 使用例とベストプラクティス
  # ----------------------------------------------------------------------------

  # 1. 最小権限の原則
  #    必要最小限の操作のみを allowed_operations に含める
  #
  # 2. アカウント間の共有
  #    AWS Organizations内のアカウント間でライセンスを共有する際に使用
  #
  # 3. ライセンスの追跡
  #    License Managerダッシュボードでグラントの使用状況を監視
  #
  # 4. コスト最適化
  #    複数アカウントでライセンスを効率的に共有してコストを削減
  #
  # 5. コンプライアンス
  #    ライセンス使用状況を追跡して、ソフトウェアライセンスコンプライアンスを維持

  # ----------------------------------------------------------------------------
  # 関連リソース
  # ----------------------------------------------------------------------------

  # - aws_licensemanager_license_configuration: ライセンス設定の管理
  # - aws_licensemanager_association: リソースとライセンス設定の関連付け
  # - aws_organizations_organization: AWS Organizations設定（クロスアカウント共有時）

  # ----------------------------------------------------------------------------
  # 注意事項
  # ----------------------------------------------------------------------------

  # 1. グラント先のアカウントは、グラントを受け入れる必要がある場合があります
  # 2. ライセンスのホームリージョンは、ライセンス作成時に設定されたリージョンと一致する必要があります
  # 3. グラントの削除は、ライセンスの使用状況に影響を与える可能性があります
  # 4. allowed_operationsで指定する操作は、元のライセンスで許可されている操作のサブセットである必要があります
  # 5. プリンシパルは必ずIAMルートユーザーのARN形式で指定します
}

# ----------------------------------------------------------------------------
# 出力例
# ----------------------------------------------------------------------------

output "licensemanager_grant_id" {
  description = "License Manager グラントのID（ARN）"
  value       = aws_licensemanager_grant.example.id
}

output "licensemanager_grant_arn" {
  description = "License Manager グラントのARN"
  value       = aws_licensemanager_grant.example.arn
}

output "licensemanager_grant_status" {
  description = "License Manager グラントのステータス"
  value       = aws_licensemanager_grant.example.status
}

output "licensemanager_grant_version" {
  description = "License Manager グラントのバージョン"
  value       = aws_licensemanager_grant.example.version
}

output "licensemanager_grant_parent_arn" {
  description = "親ライセンスのARN"
  value       = aws_licensemanager_grant.example.parent_arn
}
