################################################################################
# AWS RAM Sharing with Organization
################################################################################
# リソース概要:
# - AWS Resource Access Manager (RAM) を使用して、AWS Organizations 内での
#   リソース共有を有効化するリソースです
# - 組織内共有を有効にすると、招待なしでリソースを共有できるようになります
# - 管理アカウントから実行する必要があります
#
# 重要な注意事項:
# - このリソースは組織内のリソース共有を管理するために使用します
# - aws_organizations_organization リソースで ram.amazonaws.com を
#   aws_service_access_principals に設定する方法は使用しないでください
#   （両方を同時に使用しないこと）
# - AWSServiceRoleForResourceAccessManager という名前のサービスリンクロールが
#   自動的に管理アカウントに作成されます
# - このロールには AWSResourceAccessManagerServiceRolePolicy ポリシーが
#   アタッチされ、AWS RAM が組織情報にアクセスできるようになります
# - 一度有効化すると、組織内のすべてのプリンシパルが共有リソースへの
#   アクセス権を取得します（招待プロセスなし）
#
# ユースケース:
# - 組織内の複数のアカウント間でVPC、サブネット、Transit Gatewayなどを共有
# - リソースの集中管理と組織全体でのコスト最適化
# - セキュリティグループルールやRoute 53リゾルバールールの共有
# - License Managerライセンスの組織内共有
# - Aurora DBクラスターやRoute 53プロファイルの共有
#
# 前提条件:
# - AWS Organizations が有効化されていること
# - 管理アカウントまたは委任された管理者アカウントからの実行
# - Organizations の信頼されたアクセスを有効にする権限
# - IAMロールまたはユーザーが管理アカウントに属していること
#
# 参考ドキュメント:
# - RAM ユーザーガイド: https://docs.aws.amazon.com/ram/latest/userguide/getting-started-sharing.html
# - EnableSharingWithAwsOrganization API: https://docs.aws.amazon.com/ram/latest/APIReference/API_EnableSharingWithAwsOrganization.html
# - RAM と Organizations の統合: https://docs.aws.amazon.com/organizations/latest/userguide/services-that-can-integrate-ram.html
# - Terraform Registry: https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/ram_sharing_with_organization
#
# Provider Version: 6.28.0
################################################################################

resource "aws_ram_sharing_with_organization" "example" {
  #-----------------------------------------------------------------------------
  # 必須設定
  #-----------------------------------------------------------------------------
  # このリソースには必須設定がありません。
  # リソースを作成するだけで、組織全体でのRAM共有が有効化されます。

  #-----------------------------------------------------------------------------
  # オプション設定
  #-----------------------------------------------------------------------------

  # id (Optional, Computed)
  # 型: string
  # 説明: リソースのID（AWSアカウントIDが使用されます）
  # 設定可能な値: 12桁のAWSアカウントID
  # 省略時: 自動的に現在のAWSアカウントID（管理アカウント）が設定されます
  # 注意: 通常、この属性を明示的に設定する必要はありません
  # id = null
}

################################################################################
# 使用例とベストプラクティス
################################################################################

# 基本的な使用例: Organization全体でRAM共有を有効化
resource "aws_ram_sharing_with_organization" "main" {
  # 設定不要 - リソース宣言のみで有効化されます
}

# RAM共有を有効化した後、リソース共有を作成する例
resource "aws_ram_resource_share" "example" {
  name                      = "example-resource-share"
  allow_external_principals = false # Organization内のみで共有

  # RAM共有が有効化されていることを確認
  depends_on = [aws_ram_sharing_with_organization.main]
}

# Transit Gatewayを組織内で共有する完全な例
resource "aws_ec2_transit_gateway" "example" {
  description = "Example Transit Gateway for Organization sharing"
  tags = {
    Name = "example-tgw"
  }
}

resource "aws_ram_resource_share" "tgw_share" {
  name                      = "tgw-organization-share"
  allow_external_principals = false

  depends_on = [aws_ram_sharing_with_organization.main]

  tags = {
    Environment = "production"
    ManagedBy   = "terraform"
  }
}

resource "aws_ram_resource_association" "tgw" {
  resource_arn       = aws_ec2_transit_gateway.example.arn
  resource_share_arn = aws_ram_resource_share.tgw_share.arn
}

# 組織全体またはOUに共有する場合
resource "aws_ram_principal_association" "organization" {
  principal          = "arn:aws:organizations::123456789012:organization/o-xxxxx"
  resource_share_arn = aws_ram_resource_share.tgw_share.arn
}

################################################################################
# 出力値
################################################################################

output "ram_sharing_account_id" {
  description = "RAM共有が有効化されたAWSアカウントID（管理アカウント）"
  value       = aws_ram_sharing_with_organization.example.id
}

output "ram_sharing_enabled" {
  description = "RAM組織共有が有効化されているかどうか"
  value       = true
}

################################################################################
# 補足情報
################################################################################
# Attributes Reference (読み取り専用属性):
# - id: 組織のAWSアカウントID（管理アカウント）
#
# インポート:
# 既存のRAM組織共有設定をインポートできます
# terraform import aws_ram_sharing_with_organization.example 123456789012
#
# 関連リソース:
# - aws_ram_resource_share: 実際のリソース共有を作成
# - aws_ram_principal_association: 共有へのプリンシパル（アカウント/OU/組織）の関連付け
# - aws_ram_resource_association: 共有へのリソースの関連付け
# - aws_ram_resource_share_accepter: 外部アカウントでの共有受け入れ（組織外共有の場合）
#
# 共有可能なリソースタイプ（一部）:
# - EC2: サブネット、トランジットゲートウェイ、Capacity Reservations
# - Route 53: Resolver ルール、プロファイル
# - License Manager: ライセンス設定
# - RDS: Aurora DBクラスター
# - VPC: IPAMプール、プレフィックスリスト
# - その他多数のAWSサービス
#
# セキュリティ考慮事項:
# - 組織内共有を有効にすると、すべての組織メンバーが共有リソースへの
#   アクセス権を持つ可能性があります
# - 適切なIAMポリシーとリソースベースのポリシーで追加の制限を設定してください
# - リソース共有の範囲を特定のOU、アカウント、IAMロール/ユーザーに制限することを推奨
# - 定期的に共有リソースとアクセス許可を監査してください
# - 共有を無効化する場合は、このリソースを削除します（terraform destroy）
# - 無効化する前に、すべてのリソース共有を削除することを推奨
#
# API操作:
# - 作成時: EnableSharingWithAwsOrganization
# - 削除時: DisableSharingWithAwsOrganization
# - HTTPステータス: 200 OK (成功時)
# - レスポンス: { "returnValue": true/false }
#
# 発生しうるエラー:
# - OperationNotPermittedException: 管理アカウント以外から実行した場合
# - ServerInternalException: AWSサーバー内部エラー
# - ServiceUnavailableException: サービスが一時的に利用不可
#
# 制限事項:
# - 管理アカウントまたは委任された管理者アカウントからのみ実行可能
# - リージョンごとに設定が必要（グローバル設定ではない）
# - 一度有効化すると、組織内のすべてのアカウントで即座に有効になります
#
# コスト:
# - このリソース自体に追加コストはかかりません
# - ただし、共有されたリソースの使用には通常のAWS料金が適用されます
# - コスト配分タグを使用して、共有リソースの使用状況を追跡できます
#
# トラブルシューティング:
# 1. 共有が有効にならない場合:
#    - 管理アカウントで実行しているか確認
#    - 必要なIAM権限があるか確認
#    - Organizations が有効化されているか確認
# 2. リソース共有が機能しない場合:
#    - ram_sharing_with_organization が作成されているか確認
#    - allow_external_principals = false に設定されているか確認
#    - リソース共有のアクセス許可が正しく設定されているか確認
# 3. アクセス拒否エラーが発生する場合:
#    - リソース所有者とプリンシパルのIAMポリシーを確認
#    - リソースベースのポリシーを確認
#    - Service Control Policies (SCP) を確認
#
# ベストプラクティス:
# - 共有リソースに明確な命名規則とタグ付けを適用する
# - 最小権限の原則に従い、必要最小限の共有を行う
# - CloudTrail で RAM API呼び出しを監視する
# - 定期的に使用されていない共有を削除する
# - マルチリージョン展開の場合、各リージョンで有効化が必要
# - ドキュメント化: どのリソースが共有されているか、なぜ共有されているかを記録
################################################################################
